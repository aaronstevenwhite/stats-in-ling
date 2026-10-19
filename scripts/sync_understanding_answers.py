#!/usr/bin/env python3
"""Insert audited understanding-check answers into their source notes.

The two JSON files are review-friendly staging artifacts produced from the note
analyses.  This script makes the notes authoritative by placing each answer key
in a collapsed ``details`` block immediately after its numbered questions.
Running it again replaces the generated block in place.
"""

from __future__ import annotations

import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ANSWER_FILES = (
    ROOT / "decks/check-answers-foundations-random.json",
    ROOT / "decks/check-answers-inference-regression.json",
)
CHECK_HEADING_RE = re.compile(
    r"(?m)^##\s+(?:Check your understanding|Test the distinction)\s*$"
)
DETAILS_RE = re.compile(
    r"\n*<details class=\"understanding-answers\">\s*\n"
    r"<summary>Answers</summary>.*?</details>\s*",
    re.S,
)
QUESTION_RE = re.compile(r"(?m)^\s*(\d+)[.)]\s+(.+?)\s*$")


def load_answers() -> dict[str, list[str]]:
    merged: dict[str, list[str]] = {}
    for path in ANSWER_FILES:
        if not path.exists():
            raise RuntimeError(f"Missing answer staging file: {path.relative_to(ROOT)}")
        document = json.loads(path.read_text(encoding="utf-8"))
        if not isinstance(document, dict):
            raise RuntimeError(f"Expected a JSON object in {path.relative_to(ROOT)}")
        overlap = set(merged) & set(document)
        if overlap:
            raise RuntimeError(f"Duplicate pages across answer files: {sorted(overlap)}")
        for page, values in document.items():
            if not isinstance(values, list) or not values or not all(
                isinstance(value, str) and value.strip() for value in values
            ):
                raise RuntimeError(f"Invalid answer list for {page}")
        merged.update(document)
    return merged


def insert_answers(page: str, answers: list[str]) -> bool:
    path = ROOT / page
    text = path.read_text(encoding="utf-8")
    headings = list(CHECK_HEADING_RE.finditer(text))
    if len(headings) != 1:
        raise RuntimeError(f"Expected one exercise heading in {page}; found {len(headings)}")
    heading = headings[0]
    section_start = heading.end()
    following = re.search(r"(?m)^##\s+", text[section_start:])
    section_end = section_start + following.start() if following else len(text)
    section = DETAILS_RE.sub("\n", text[section_start:section_end])
    questions = list(QUESTION_RE.finditer(section))
    if len(questions) != len(answers):
        raise RuntimeError(
            f"{page}: {len(questions)} questions but {len(answers)} staged answers"
        )
    if [int(match.group(1)) for match in questions] != list(range(1, len(questions) + 1)):
        raise RuntimeError(f"{page}: question numbering is not consecutive")
    insertion = questions[-1].end()
    answer_lines = [
        '<details class="understanding-answers">',
        "<summary>Answers</summary>",
        "",
    ]
    for number, answer in enumerate(answers, start=1):
        cleaned = re.sub(r"\s+", " ", answer).strip()
        answer_lines.append(
            f"{number}. {cleaned} <!-- dqr-allow: empirical-answer -->"
        )
    answer_lines.extend(["", "</details>"])
    revised_section = (
        section[:insertion].rstrip()
        + "\n\n"
        + "\n".join(answer_lines)
        + "\n\n"
        + section[insertion:].lstrip()
    )
    revised = text[:section_start] + revised_section + text[section_end:]
    if revised == text:
        return False
    path.write_text(revised, encoding="utf-8")
    return True


def main() -> int:
    answers = load_answers()
    changed = sum(insert_answers(page, values) for page, values in answers.items())
    question_count = sum(len(values) for values in answers.values())
    print(
        f"synchronized {question_count} answers across {len(answers)} note pages; "
        f"changed {changed} files"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
