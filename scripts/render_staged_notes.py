#!/usr/bin/env python3
"""Render an exact course prefix and authenticate the resulting note HTML.

The driver temporarily narrows ``project.render`` to the exact note pages in the
selected deck prefix, runs one project render, and restores the project file in
a ``finally`` block. It therefore cannot expand ``regression-models/*.qmd`` and
accidentally execute GLM or mixed-model pages while building the ordinary-
regression stage.
Quarto's project-level ``freeze: auto`` and knitr ``cache: true`` settings reuse
unchanged computations.  After a successful render, this script records source,
HTML, and displayed-figure hashes for the slide generator.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
from datetime import datetime, timezone
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit

from rebuild_slides_and_transcripts import DECKS, ROOT, selected_decks


RECEIPT_PATH = ROOT / "decks" / "note-render-receipts.json"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class ImageSourceParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.sources: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "img":
            return
        values = {key: value or "" for key, value in attrs}
        source = values.get("src", "")
        if source and not source.startswith(("data:", "http://", "https://")):
            self.sources.append(unquote(urlsplit(source).path))


def figure_paths(page: str, html_path: Path) -> list[str]:
    parser = ImageSourceParser()
    parser.feed(html_path.read_text(encoding="utf-8"))
    note_dir = (ROOT / page).parent
    doc_dir = html_path.parent
    figures: list[str] = []
    for source in parser.sources:
        candidates = [(note_dir / source).resolve(), (doc_dir / source).resolve()]
        for candidate in candidates:
            try:
                relative = candidate.relative_to(ROOT)
            except ValueError:
                continue
            if candidate.exists():
                value = str(relative)
                if value not in figures:
                    figures.append(value)
                break
    return figures


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--through", choices=list(DECKS), required=True)
    args = parser.parse_args()
    decks = selected_decks(args.through)
    pages = [page for config in decks.values() for page in config["pages"]]

    project_config = ROOT / "_quarto.yml"
    backup_config = ROOT / "_quarto.yml.codex-stage-backup"
    if backup_config.exists():
        raise RuntimeError(
            f"Found {backup_config.name}; restore it before starting another staged render"
        )
    original = project_config.read_text(encoding="utf-8")
    render_block = "  render:\n" + "".join(
        f"    - {page}\n" for page in pages
    )
    staged, replacements = re.subn(
        r"(?ms)^  render:\n.*?(?=^  resources:)",
        render_block,
        original,
        count=1,
    )
    if replacements != 1:
        raise RuntimeError("Could not isolate project.render in _quarto.yml")

    backup_config.write_text(original, encoding="utf-8")
    temporary_config = project_config.with_name("_quarto.yml.codex-stage-tmp")
    temporary_config.write_text(staged, encoding="utf-8")
    temporary_config.replace(project_config)
    try:
        print(
            f"rendering {len(pages)} exact note pages through {args.through}",
            flush=True,
        )
        subprocess.run(
            ["quarto", "render", "--no-clean"],
            cwd=ROOT,
            check=True,
        )
    finally:
        restore = project_config.with_name("_quarto.yml.codex-stage-restore")
        restore.write_text(backup_config.read_text(encoding="utf-8"), encoding="utf-8")
        restore.replace(project_config)
        backup_config.unlink(missing_ok=True)

    receipts: dict[str, dict] = {}
    for page in pages:
        source_path = ROOT / page
        html_path = ROOT / "docs" / Path(page).with_suffix(".html")
        if not html_path.exists():
            raise RuntimeError(f"Quarto did not produce {html_path.relative_to(ROOT)}")
        figures = figure_paths(page, html_path)
        receipts[page] = {
            "source_sha256": digest(source_path),
            "html_sha256": digest(html_path),
            "figures": figures,
            "figure_sha256": {
                figure: digest(ROOT / figure) for figure in figures
            },
        }

    payload = {
        "through": args.through,
        "modules": list(decks),
        "rendered_at_utc": datetime.now(timezone.utc).isoformat(),
        "pages": receipts,
    }
    temporary = RECEIPT_PATH.with_name(RECEIPT_PATH.name + ".tmp")
    temporary.write_text(
        json.dumps(payload, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    temporary.replace(RECEIPT_PATH)
    print(
        f"authenticated {len(pages)} rendered notes through {args.through}; "
        f"receipt: {RECEIPT_PATH.relative_to(ROOT)}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
