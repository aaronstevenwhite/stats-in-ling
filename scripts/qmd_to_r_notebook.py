#!/usr/bin/env python3
"""Convert a Quarto assignment into a Jupyter notebook with an R kernel."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


SITE_ROOT = "https://aaronstevenwhite.io/stats-in-ling/"
R_FENCE = re.compile(r"^```\{r(?:[^}]*)\}\s*$")
CALLOUT = re.compile(r'^:::\s+\{\.callout-[^ ]+\s+title="([^"]+)"\}\s*$')


def split_front_matter(text: str) -> tuple[dict[str, str], str]:
    lines = text.splitlines(keepends=True)
    if not lines or lines[0].strip() != "---":
        return {}, text

    closing_index = next(
        (index for index, line in enumerate(lines[1:], start=1) if line.strip() == "---"),
        None,
    )
    if closing_index is None:
        raise ValueError("The Quarto front matter has no closing delimiter.")

    metadata: dict[str, str] = {}
    for line in lines[1:closing_index]:
        match = re.match(r'^(title|subtitle):\s*["\']?(.*?)["\']?\s*$', line)
        if match:
            metadata[match.group(1)] = match.group(2)

    return metadata, "".join(lines[closing_index + 1 :])


def notebook_markdown(text: str) -> str:
    converted_lines: list[str] = []
    for line in text.splitlines(keepends=True):
        callout_match = CALLOUT.match(line.strip())
        if callout_match:
            converted_lines.append(f"#### {callout_match.group(1)}\n")
        elif line.strip() == ":::":
            continue
        else:
            converted_lines.append(line)

    converted = "".join(converted_lines)
    converted = re.sub(r'\{download="[^"]+"\}', "", converted)
    converted = re.sub(
        r"\]\(\.\./\.\./([^\s)#]+)\.qmd(#[^)]*)?\)",
        lambda match: f"]({SITE_ROOT}{match.group(1)}.html{match.group(2) or ''})",
        converted,
    )
    converted = converted.replace(
        "](../../downloads/",
        f"]({SITE_ROOT}downloads/",
    )
    return converted.strip() + "\n"


def source_lines(text: str) -> list[str]:
    return text.splitlines(keepends=True)


def markdown_cell(source: str, cell_id: str) -> dict[str, object]:
    return {
        "cell_type": "markdown",
        "id": cell_id,
        "metadata": {},
        "source": source_lines(source),
    }


def code_cell(source: str, cell_id: str) -> dict[str, object]:
    return {
        "cell_type": "code",
        "execution_count": None,
        "id": cell_id,
        "metadata": {"vscode": {"languageId": "r"}},
        "outputs": [],
        "source": source_lines(source),
    }


def convert(input_path: Path) -> dict[str, object]:
    metadata, body = split_front_matter(input_path.read_text(encoding="utf-8"))
    title = metadata.get("title", input_path.stem)
    subtitle = metadata.get("subtitle")

    cells: list[dict[str, object]] = []
    title_source = f"# {title}\n"
    if subtitle:
        title_source += f"\n*{subtitle}*\n"
    cells.append(markdown_cell(title_source, "title"))

    markdown_lines: list[str] = []
    code_lines: list[str] = []
    in_r_cell = False

    def append_markdown() -> None:
        nonlocal markdown_lines
        text = "".join(markdown_lines).strip()
        if text:
            cells.append(
                markdown_cell(
                    notebook_markdown(text),
                    f"cell-{len(cells) + 1:03d}",
                )
            )
        markdown_lines = []

    for line in body.splitlines(keepends=True):
        if not in_r_cell and R_FENCE.match(line.strip()):
            append_markdown()
            in_r_cell = True
            code_lines = []
        elif in_r_cell and line.strip() == "```":
            source = "".join(code_lines).rstrip() + "\n"
            cells.append(code_cell(source, f"cell-{len(cells) + 1:03d}"))
            in_r_cell = False
            code_lines = []
        elif in_r_cell:
            code_lines.append(line)
        else:
            markdown_lines.append(line)

    if in_r_cell:
        raise ValueError(f"Unclosed R code fence in {input_path}")
    append_markdown()

    return {
        "cells": cells,
        "metadata": {
            "kernelspec": {
                "display_name": "R",
                "language": "R",
                "name": "ir",
            },
            "language_info": {
                "codemirror_mode": "r",
                "file_extension": ".r",
                "mimetype": "text/x-r-source",
                "name": "R",
                "pygments_lexer": "r",
            },
        },
        "nbformat": 4,
        "nbformat_minor": 5,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("input", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument(
        "--check",
        action="store_true",
        help="Fail if OUTPUT is not the notebook generated from INPUT.",
    )
    arguments = parser.parse_args()

    rendered = json.dumps(
        convert(arguments.input),
        ensure_ascii=False,
        indent=1,
    ) + "\n"

    if arguments.check:
        if not arguments.output.exists():
            raise SystemExit(f"Missing generated notebook: {arguments.output}")
        if arguments.output.read_text(encoding="utf-8") != rendered:
            raise SystemExit(f"Stale generated notebook: {arguments.output}")
        return

    arguments.output.parent.mkdir(parents=True, exist_ok=True)
    arguments.output.write_text(rendered, encoding="utf-8")


if __name__ == "__main__":
    main()
