#!/usr/bin/env python3
"""Release or hide scheduled course pages on the public branch."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from datetime import date
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "release-schedule.json"
QUARTO_PATH = ROOT / "_quarto.yml"
DECK_CONFIG_PATH = ROOT / "decks" / "_quarto.yml"
DECK_INDEX_PATH = ROOT / "decks" / "index.qmd"
PLACEHOLDER_FIELD = "course-release-placeholder: true"


class ReleaseError(RuntimeError):
    """Report a release error without a Python traceback."""


def run_git(*args: str, check: bool = True) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        ["git", *args],
        cwd=ROOT,
        check=check,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )


def load_manifest() -> dict[str, Any]:
    try:
        return json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    except FileNotFoundError as exc:
        raise ReleaseError(f"Release manifest not found: {MANIFEST_PATH}") from exc
    except json.JSONDecodeError as exc:
        raise ReleaseError(f"Release manifest is not valid JSON: {exc}") from exc


def current_branch() -> str:
    result = run_git("branch", "--show-current")
    branch = result.stdout.strip()
    if not branch:
        raise ReleaseError("The release script requires a named Git branch.")
    return branch


def branch_exists(branch: str) -> bool:
    result = run_git("show-ref", "--verify", f"refs/heads/{branch}", check=False)
    return result.returncode == 0


def require_clean_tracked_files() -> None:
    result = run_git("status", "--porcelain", "--untracked-files=no")
    if result.stdout.strip():
        raise ReleaseError(
            "Commit or restore tracked changes before releasing course material."
        )


def switch_to_public_branch(public_branch: str) -> None:
    if current_branch() == public_branch:
        require_clean_tracked_files()
        return
    require_clean_tracked_files()
    result = run_git("switch", public_branch, check=False)
    if result.returncode != 0:
        raise ReleaseError(result.stderr.strip() or f"Could not switch to {public_branch}.")


def source_text(source_branch: str, relative_path: str) -> str:
    result = run_git("show", f"{source_branch}:{relative_path}", check=False)
    if result.returncode != 0:
        raise ReleaseError(
            f"{relative_path} is not available on the local {source_branch} branch."
        )
    return result.stdout


def source_paths(source_branch: str, prefix: str) -> list[str]:
    result = run_git("ls-tree", "-r", "--name-only", source_branch, "--", prefix)
    paths = [line for line in result.stdout.splitlines() if line]
    if not paths:
        raise ReleaseError(
            f"No files under {prefix} are available on the local {source_branch} branch."
        )
    return paths


def module_paths(section_name: str) -> list[str]:
    lines = QUARTO_PATH.read_text(encoding="utf-8").splitlines()
    section_pattern = re.compile(r'^      - section: ["\'](.+)["\']$')
    page_pattern = re.compile(r"^\s+- ([^\s]+\.qmd)$")
    inside = False
    paths: list[str] = []

    for line in lines:
        section_match = section_pattern.match(line)
        if section_match:
            if inside:
                break
            inside = section_match.group(1) == section_name
            continue
        if inside:
            page_match = page_pattern.match(line)
            if page_match:
                paths.append(page_match.group(1))

    if not paths:
        raise ReleaseError(f'No pages found under sidebar section "{section_name}".')
    return paths


def entry_paths(entry: dict[str, Any], kind: str) -> list[str]:
    if kind == "module":
        return module_paths(entry["sidebar_section"])
    return list(entry["paths"])


def all_entries(manifest: dict[str, Any]) -> list[tuple[str, dict[str, Any]]]:
    return [
        *(("module", entry) for entry in manifest["modules"]),
        *(("assignment", entry) for entry in manifest["assignments"]),
    ]


def find_entry(
    manifest: dict[str, Any], target: str
) -> tuple[str, dict[str, Any]]:
    matches = [
        (kind, entry)
        for kind, entry in all_entries(manifest)
        if entry["id"] == target
    ]
    if not matches:
        choices = ", ".join(entry["id"] for _, entry in all_entries(manifest))
        raise ReleaseError(f"Unknown release target {target!r}. Choose one of: {choices}")
    return matches[0]


def source_title(source: str, fallback: str) -> str:
    frontmatter = re.match(r"^---\s*\n(.*?)\n---\s*\n", source, re.DOTALL)
    if not frontmatter:
        return fallback
    for line in frontmatter.group(1).splitlines():
        if not line.startswith("title:"):
            continue
        value = line.split(":", 1)[1].strip()
        if value.startswith('"') and value.endswith('"'):
            try:
                return json.loads(value)
            except json.JSONDecodeError:
                pass
        return value.strip("'\"") or fallback
    return fallback


def display_date(iso_date: str) -> str:
    parsed = date.fromisoformat(iso_date)
    return f"{parsed.strftime('%A, %B')} {parsed.day}, {parsed.year}"


def placeholder_text(entry: dict[str, Any], page_title: str) -> str:
    title = json.dumps(page_title, ensure_ascii=False)
    available = display_date(entry["available_on"])
    return (
        "---\n"
        f"title: {title}\n"
        "toc: false\n"
        f"course-release-id: {entry['id']}\n"
        f"{PLACEHOLDER_FIELD}\n"
        "---\n\n"
        f"{entry['synopsis']}\n\n"
        f"**Available {available}.**\n"
    )


def write_source_page(source_branch: str, relative_path: str, dry_run: bool) -> None:
    if dry_run:
        print(f"restore  {relative_path}")
        return
    destination = ROOT / relative_path
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(source_text(source_branch, relative_path), encoding="utf-8")


def write_placeholder(
    source_branch: str,
    entry: dict[str, Any],
    relative_path: str,
    dry_run: bool,
) -> None:
    source = source_text(source_branch, relative_path)
    title = source_title(source, entry["title"])
    if dry_run:
        print(f"hide     {relative_path}")
        return
    destination = ROOT / relative_path
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(placeholder_text(entry, title), encoding="utf-8")


def deck_paths(source_branch: str, entry: dict[str, Any]) -> list[str]:
    return source_paths(source_branch, f"decks/{entry['id']}")


def remove_public_file(relative_path: str, dry_run: bool) -> None:
    if dry_run:
        print(f"hide     {relative_path}")
        return
    destination = ROOT / relative_path
    if destination.exists():
        destination.unlink()


def tracked_in_index(relative_path: str) -> bool:
    result = run_git("ls-files", "--error-unmatch", "--", relative_path, check=False)
    return result.returncode == 0


def deck_config_text(manifest: dict[str, Any], released_ids: set[str]) -> str:
    render_lines = ["    - index.qmd"]
    render_lines.extend(
        f"    - {entry['id']}/index.qmd"
        for entry in manifest["modules"]
        if entry["id"] in released_ids
    )
    return (
        "project:\n"
        "  type: default\n"
        "  output-dir: ../docs/decks\n"
        "  render:\n"
        + "\n".join(render_lines)
        + "\n\n"
        "execute:\n"
        "  enabled: false\n\n"
        "format:\n"
        "  revealjs:\n"
        "    html-math-method: katex\n\n"
        "resources:\n"
        "  - shared/bird.svg\n"
        "  - shared/theme.css\n"
    )


def deck_index_text(manifest: dict[str, Any], released_ids: set[str]) -> str:
    lines = [
        "---",
        'title: "Course slides"',
        "format:",
        "  html:",
        "    theme: lux",
        "    toc: false",
        "---",
        "",
        "Slide decks become available with their corresponding modules.",
        "",
    ]
    for number, entry in enumerate(manifest["modules"], start=1):
        title = entry["title"]
        if entry["id"] in released_ids:
            description = f"[{title}]({entry['id']}/), {display_date(entry['available_on'])}"
        else:
            description = f"{title}, available {display_date(entry['available_on'])}"
        lines.append(f"{number}. {description}")
    return "\n".join(lines) + "\n"


def set_deck_states(
    manifest: dict[str, Any], released_ids: set[str], dry_run: bool
) -> list[str]:
    source_branch = manifest["source_branch"]
    changed = ["decks/_quarto.yml", "decks/index.qmd"]
    for entry in manifest["modules"]:
        paths = deck_paths(source_branch, entry)
        if entry["id"] in released_ids:
            for relative_path in paths:
                write_source_page(source_branch, relative_path, dry_run)
                changed.append(relative_path)
        else:
            for relative_path in paths:
                if tracked_in_index(relative_path):
                    changed.append(relative_path)
                remove_public_file(relative_path, dry_run)
    if dry_run:
        print("update   decks/_quarto.yml")
        print("update   decks/index.qmd")
    else:
        DECK_CONFIG_PATH.write_text(
            deck_config_text(manifest, released_ids), encoding="utf-8"
        )
        DECK_INDEX_PATH.write_text(
            deck_index_text(manifest, released_ids), encoding="utf-8"
        )
    return changed


def released_module_ids(
    manifest: dict[str, Any], public_branch: str, use_worktree: bool
) -> set[str]:
    return {
        entry["id"]
        for entry in manifest["modules"]
        if entry_state(entry, "module", public_branch, use_worktree) == "released"
    }


def set_entry_state(
    manifest: dict[str, Any],
    kind: str,
    entry: dict[str, Any],
    released: bool,
    dry_run: bool,
) -> list[str]:
    source_branch = manifest["source_branch"]
    paths = entry_paths(entry, kind)
    for relative_path in paths:
        if released:
            write_source_page(source_branch, relative_path, dry_run)
        else:
            write_placeholder(source_branch, entry, relative_path, dry_run)
    return paths


def release_assignment_overview(
    manifest: dict[str, Any], entry: dict[str, Any], dry_run: bool
) -> list[str]:
    if entry["id"] == "assignments":
        return []
    overview = next(item for item in manifest["assignments"] if item["id"] == "assignments")
    return set_entry_state(manifest, "assignment", overview, True, dry_run)


def page_state(path: str, public_branch: str, use_worktree: bool) -> str:
    if use_worktree:
        destination = ROOT / path
        if not destination.exists():
            return "missing"
        text = destination.read_text(encoding="utf-8")
    else:
        result = run_git("show", f"{public_branch}:{path}", check=False)
        if result.returncode != 0:
            return "missing"
        text = result.stdout
    return "hidden" if PLACEHOLDER_FIELD in text else "released"


def entry_state(
    entry: dict[str, Any], kind: str, public_branch: str, use_worktree: bool
) -> str:
    states = {
        page_state(path, public_branch, use_worktree)
        for path in entry_paths(entry, kind)
    }
    if len(states) == 1:
        return states.pop()
    return "partial"


def render_site(dry_run: bool) -> None:
    if dry_run:
        print("render   quarto render")
        print("render   quarto render decks")
        return
    print("Rendering the course site. This may take several minutes.")
    subprocess.run(["quarto", "render"], cwd=ROOT, check=True)
    subprocess.run(["quarto", "render", "decks"], cwd=ROOT, check=True)


def commit_release(paths: list[str], message: str, rendered: bool, dry_run: bool) -> None:
    targets = sorted(set(paths))
    if dry_run:
        print(f"commit   {message}")
        return
    run_git("add", "-A", "-f", "--", *targets)
    result = run_git("diff", "--cached", "--quiet", check=False)
    if result.returncode == 0:
        print("No changes to commit.")
        return
    run_git("commit", "-m", message)


def push_public_branch(manifest: dict[str, Any], dry_run: bool) -> None:
    if dry_run:
        print(f"push     {manifest['public_branch']}")
        return
    result = run_git("remote", check=False)
    if result.returncode != 0 or not result.stdout.strip():
        raise ReleaseError("No Git remote is configured. The release is committed locally.")
    subprocess.run(
        ["git", "push", "--set-upstream", "origin", manifest["public_branch"]],
        cwd=ROOT,
        check=True,
    )


def prepare_public(manifest: dict[str, Any], dry_run: bool) -> list[str]:
    changed: list[str] = []
    for kind, entry in all_entries(manifest):
        changed.extend(
            set_entry_state(
                manifest,
                kind,
                entry,
                bool(entry.get("released_by_default")),
                dry_run,
            )
        )
    released_ids = {
        entry["id"]
        for entry in manifest["modules"]
        if entry.get("released_by_default")
    }
    changed.extend(set_deck_states(manifest, released_ids, dry_run))
    return changed


def print_status(manifest: dict[str, Any]) -> None:
    public_branch = manifest["public_branch"]
    if not branch_exists(public_branch):
        raise ReleaseError(f"The public branch {public_branch!r} does not exist.")
    use_worktree = current_branch() == public_branch
    for heading, entries, kind in (
        ("Modules", manifest["modules"], "module"),
        ("Assignments", manifest["assignments"], "assignment"),
    ):
        print(heading)
        for entry in entries:
            state = entry_state(entry, kind, public_branch, use_worktree)
            print(
                f"  {entry['id']:<36} {state:<8} "
                f"{display_date(entry['available_on'])}"
            )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Release scheduled notes, slides, or assignments from the local source branch."
        )
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("status", help="Show the release state and scheduled date.")

    prepare = subparsers.add_parser(
        "prepare-public",
        help="Apply the default public state from the release schedule.",
    )
    prepare.add_argument("--dry-run", action="store_true")

    for command, help_text in (
        ("release", "Restore a module or assignment from the local source branch."),
        ("hide", "Replace a module or assignment with its scheduled placeholder."),
    ):
        command_parser = subparsers.add_parser(command, help=help_text)
        command_parser.add_argument("target", help="A module or assignment ID.")
        command_parser.add_argument(
            "--no-render",
            action="store_true",
            help="Change source pages without rendering the site.",
        )
        command_parser.add_argument(
            "--commit",
            action="store_true",
            help="Commit the changed pages and rendered site.",
        )
        command_parser.add_argument(
            "--push",
            action="store_true",
            help="Commit and push the public branch to origin.",
        )
        command_parser.add_argument("--dry-run", action="store_true")

    return parser


def main() -> int:
    args = build_parser().parse_args()
    try:
        manifest = load_manifest()
        source_branch = manifest["source_branch"]
        public_branch = manifest["public_branch"]
        if not branch_exists(source_branch):
            raise ReleaseError(f"The local source branch {source_branch!r} does not exist.")

        if args.command == "status":
            print_status(manifest)
            return 0

        switch_to_public_branch(public_branch)

        if args.command == "prepare-public":
            prepare_public(manifest, args.dry_run)
            return 0

        kind, entry = find_entry(manifest, args.target)
        released = args.command == "release"
        changed = set_entry_state(manifest, kind, entry, released, args.dry_run)
        if kind == "module":
            released_ids = released_module_ids(manifest, public_branch, True)
            if released:
                released_ids.add(entry["id"])
            else:
                released_ids.discard(entry["id"])
            changed.extend(set_deck_states(manifest, released_ids, args.dry_run))
        if released and kind == "assignment":
            changed.extend(release_assignment_overview(manifest, entry, args.dry_run))

        rendered = not args.no_render
        if rendered:
            render_site(args.dry_run)

        should_commit = args.commit or args.push
        action = "Release" if released else "Hide"
        if should_commit:
            commit_release(
                changed,
                f"{action} {entry['title']}",
                rendered,
                args.dry_run,
            )
        if args.push:
            push_public_branch(manifest, args.dry_run)
        elif not should_commit and not args.dry_run:
            print("Pages updated. Review the site, then commit the public branch when ready.")
        return 0
    except (ReleaseError, subprocess.CalledProcessError) as exc:
        print(f"release-course: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
