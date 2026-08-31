#!/usr/bin/env python3
"""Check links among the public Quarto source files."""

from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote

from check_public_prose import ROOT, public_sources


MARKDOWN_LINK = re.compile(r"\[[^\]]*\]\(([^)]+)\)")
HEADING = re.compile(r"^#{1,6}\s+(.+?)\s*$", re.M)
EXPLICIT_ID = re.compile(r"\{#([^\s}]+)[^}]*\}\s*$")
CODE_BLOCK = re.compile(r"^```.*?^```\s*$", re.M | re.S)


def pandoc_identifier(heading: str) -> str:
    """Approximate Pandoc's automatic heading identifier."""
    heading = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", heading)
    heading = re.sub(r"`([^`]*)`", r"\1", heading)
    heading = re.sub(r"<[^>]+>", "", heading)
    heading = re.sub(r"[*_~]", "", heading)
    heading = EXPLICIT_ID.sub("", heading).strip().casefold()
    heading = re.sub(r"\s+", "-", heading)
    heading = "".join(
        character
        for character in heading
        if character.isalnum() or character in "_.-"
    )
    heading = re.sub(r"^[^\w]+", "", heading, flags=re.UNICODE)
    return heading or "section"


def heading_ids(path: Path) -> set[str]:
    text = CODE_BLOCK.sub("", path.read_text(encoding="utf-8"))
    identifiers: set[str] = set()

    for heading in HEADING.findall(text):
        explicit = EXPLICIT_ID.search(heading)
        identifiers.add(explicit.group(1) if explicit else pandoc_identifier(heading))

    identifiers.update(re.findall(r"\{#([^\s}]+)", text))
    return identifiers


def link_failures(path: Path, public: set[Path]) -> list[str]:
    text = CODE_BLOCK.sub("", path.read_text(encoding="utf-8"))
    failures: list[str] = []

    for line_number, line in enumerate(text.splitlines(), 1):
        for raw_target in MARKDOWN_LINK.findall(line):
            target = raw_target.strip().strip("<>")
            if not target or "://" in target or target.startswith("mailto:"):
                continue

            file_part, separator, fragment = target.partition("#")
            if not file_part.endswith(".qmd"):
                continue

            resolved = (path.parent / unquote(file_part)).resolve()
            if not resolved.exists():
                failures.append(
                    f"{path.relative_to(ROOT)}:{line_number}: missing target: {target}"
                )
                continue

            if resolved not in public:
                failures.append(
                    f"{path.relative_to(ROOT)}:{line_number}: target is not public: {target}"
                )
                continue

            if separator and fragment and unquote(fragment) not in heading_ids(resolved):
                failures.append(
                    f"{path.relative_to(ROOT)}:{line_number}: missing anchor: {target}"
                )

    return failures


def main() -> int:
    sources = public_sources()
    public = {path.resolve() for path in sources}
    failures: list[str] = []

    for path in sources:
        failures.extend(link_failures(path, public))

    if failures:
        print("Internal link check failed:")
        print("\n".join(failures))
        return 1

    print(f"Internal link check passed for {len(sources)} source files.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
