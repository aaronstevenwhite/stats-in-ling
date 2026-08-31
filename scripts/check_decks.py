#!/usr/bin/env python3
"""Check the Fall 2026 Quarto decks against the reference slide structure."""

from __future__ import annotations

import re
import sys
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]
DECK_ROOT = ROOT / "decks"
EXPECTED = [
    "data-and-probability",
    "random-variables-and-distributions",
    "statistical-inference",
    "linear-regression",
    "model-criticism-and-prediction",
    "generalized-linear-models",
    "mixed-effects-models",
    "experimental-design",
    "latent-structure",
    "factorization",
    "missing-data",
    "custom-model-design",
]

EXPECTED_DATES = {
    "data-and-probability": ("2026-08-31", "[August 31, September 2 and 9,] YYYY"),
    "random-variables-and-distributions": ("2026-09-14", "[September 14, 16, 21 and 23,] YYYY"),
    "statistical-inference": ("2026-09-28", "[September 28 and 30, October 5,] YYYY"),
    "linear-regression": ("2026-10-07", "[October 7 and 14,] YYYY"),
    "model-criticism-and-prediction": ("2026-10-14", "[October 14, 19 and 21,] YYYY"),
    "generalized-linear-models": ("2026-11-02", "[November 2 and 4,] YYYY"),
    "experimental-design": ("2026-11-09", "[November 9 and 11,] YYYY"),
    "mixed-effects-models": ("2026-11-16", "[November 16 and 18,] YYYY"),
    "latent-structure": ("2026-11-23", "[November 23,] YYYY"),
    "factorization": ("2026-11-30", "[November 30,] YYYY"),
    "missing-data": ("2026-12-02", "[December 2,] YYYY"),
    "custom-model-design": ("2026-12-02", "[December 2,] YYYY"),
}

BANNED = {
    "Gaussian regression": "ordinary linear regression",
    "normal-error model": "ordinary linear regression with normally distributed errors",
    "prediction target": "a statement of what is held out and what is available",
    "transfer target": "out-of-sample prediction for the stated group",
    "transfer unit": "held-out group",
    "support-variance mismatch": "a direct description of the two model failures",
    "in-sample optimism": "optimism of training error",
    "hard partition": "partition",
    "delve": "examine",
    "tapestry": "a concrete description",
    "realm": "the specific domain",
    "navigate the complexities": "a direct description of the problem",
    "it's worth noting": "a direct statement",
    "it's important to note": "a direct statement",
    "key takeaway": "Upshot",
    "why this matters": "the specific consequence",
    "the big picture": "the specific question or conclusion",
    "putting it all together": "Conclusion",
    "dive into": "examine",
    "holistic": "a precise property",
    "cutting-edge": "a concrete description",
    "game-changer": "a concrete consequence",
    "underscores the importance": "a concrete consequence",
    "sheds light on": "shows or suggests",
    "paving the way": "a concrete next step",
    "plays a crucial role": "the specific function",
    "clearly": "a claim hedged to the evidence",
    "obviously": "a claim hedged to the evidence",
    "undoubtedly": "a claim hedged to the evidence",
}

ROLE_HEADINGS = {
    "Big Question",
    "Question",
    "Surprising Fact",
    "Challenge",
    "Possibility",
    "Answer",
    "Idea",
    "Approach",
    "Goal",
    "Data",
    "Method",
    "Implementation",
    "Output",
    "Interpretation",
    "Upshot",
    "Interim Discussion",
    "Conclusion",
    "This Module",
}


def split_front_matter(text: str) -> tuple[dict, str]:
    if not text.startswith("---\n"):
        return {}, text
    _, raw, body = text.split("---", 2)
    return yaml.safe_load(raw) or {}, body


def strip_notes_and_code(text: str) -> str:
    text = re.sub(r"```.*?```", " ", text, flags=re.DOTALL)
    text = re.sub(r":::\s*\{\.notes\}.*?:::", " ", text, flags=re.DOTALL)
    text = re.sub(r"<[^>]+>", " ", text)
    text = re.sub(r"\$\$.*?\$\$", " EQUATION ", text, flags=re.DOTALL)
    text = re.sub(r"\$[^$]+\$", " VARIABLE ", text)
    text = re.sub(r"!\[[^]]*\]\([^)]*\)", " ", text)
    text = re.sub(r"\[([^]]+)\]\([^)]*\)", r"\1", text)
    text = re.sub(r"\{[^}]*\}", " ", text)
    text = re.sub(r"[#*_>`]", " ", text)
    return text


def visible_slide_word_counts(body: str) -> list[tuple[str, int]]:
    pieces = re.split(r"(?m)^##\s+", body)
    counts = []
    for piece in pieces[1:]:
        lines = piece.splitlines()
        heading = re.sub(r"\s*\{.*\}\s*$", "", lines[0]).strip()
        visible = strip_notes_and_code("\n".join(lines))
        words = re.findall(r"\b[\w’'-]+\b", visible)
        counts.append((heading, len(words)))
    return counts


def check_deck(path: Path) -> list[str]:
    problems = []
    raw = path.read_text()
    metadata, body = split_front_matter(raw)
    rel = path.relative_to(ROOT)
    normalized = re.sub(r"\s+", " ", raw)

    title = str(metadata.get("title", ""))
    if not title:
        problems.append(f"{rel}: missing topical title")
    if re.search(r"\bLecture\s+\d+", title, flags=re.IGNORECASE):
        problems.append(f"{rel}: title must be topical and unnumbered")

    reveal = metadata.get("format", {}).get("revealjs", {})
    expected_metadata = {
        "width": 1280,
        "height": 720,
        "margin": 0,
        "center": False,
        "transition": "none",
        "slide-number": False,
        "controls": True,
        "progress": True,
        "self-contained": True,
        "embed-resources": True,
        "incremental": False,
    }
    for key, expected in expected_metadata.items():
        if reveal.get(key) != expected:
            problems.append(f"{rel}: revealjs {key!r} must be {expected!r}")
    css = reveal.get("css")
    if css != "../shared/theme.css" and css != ["../shared/theme.css"]:
        problems.append(f"{rel}: must use ../shared/theme.css")
    deck_name = path.parent.name
    expected_date, expected_date_format = EXPECTED_DATES[deck_name]
    if metadata.get("date") != expected_date:
        problems.append(f"{rel}: date must be {expected_date!r}")
    if metadata.get("date-format") != expected_date_format:
        problems.append(f"{rel}: date-format must be {expected_date_format!r}")

    for dash in ("—", "–"):
        if dash in raw:
            problems.append(f"{rel}: contains prohibited dash character {dash!r}")

    for banned, replacement in BANNED.items():
        if banned.casefold() in normalized.casefold():
            problems.append(
                f"{rel}: prohibited wording {banned!r}; use {replacement!r}"
            )

    headings = [
        re.sub(r"\s*\{.*\}\s*$", "", heading).strip()
        for heading in re.findall(r"(?m)^##\s+(.+)$", body)
    ]
    required_counts = {"This Module": 1}
    for required, expected_count in required_counts.items():
        count = headings.count(required)
        if count != expected_count:
            problems.append(
                f"{rel}: requires {expected_count} {required!r} slides, found {count}"
            )
    if ".section-slide" not in body:
        problems.append(f"{rel}: missing dark section divider")
    if re.search(r"(?m)^#\s+[^#].*\.section-slide", body):
        problems.append(f"{rel}: section dividers must be level-two horizontal slides")
    if "[Sources]" not in body:
        problems.append(f"{rel}: missing [Sources] speaker-note blocks")

    for piece in re.split(r"(?m)(?=^##\s+)", body)[1:]:
        heading = piece.splitlines()[0]
        visible = re.sub(
            r":::\s*\{\.notes\}.*?:::", "", piece, flags=re.DOTALL
        )
        has_external_link = bool(re.search(r"https?://[^)\s]+", visible))
        has_visible_source = 'class="source"' in visible or "class='source'" in visible
        if (has_external_link or has_visible_source) and "[Sources]" not in piece:
            problems.append(f"{rel}: {heading!r} needs a [Sources] note block")

    approved_roles = ROLE_HEADINGS | {"Important Point", "Result"}
    for match in re.finditer(r"(?m)^##\s+(.+?)\s+\{([^}]*)\}\s*$", body):
        heading, classes = match.groups()
        if "role-slide" not in classes:
            continue
        base = re.sub(r"\s+#\d+$", "", heading).strip()
        if base not in approved_roles:
            problems.append(f"{rel}: nonreference role label {heading!r}")

    for heading, count in visible_slide_word_counts(body):
        if count > 70:
            problems.append(
                f"{rel}: slide {heading!r} has {count} visible words; split the slide"
            )

    return problems


def main() -> int:
    paths = [DECK_ROOT / name / "index.qmd" for name in EXPECTED]
    missing = [path.relative_to(ROOT) for path in paths if not path.exists()]
    if missing:
        print("Deck check failed because these decks are missing:")
        for path in missing:
            print(f"  {path}")
        return 1

    problems = []
    for path in paths:
        problems.extend(check_deck(path))

    if problems:
        print("Deck check failed:")
        for problem in problems:
            print(f"  {problem}")
        return 1

    total_slides = 0
    for path in paths:
        _, body = split_front_matter(path.read_text())
        total_slides += len(re.findall(r"(?m)^##\s+", body)) + 1
    print(
        f"Deck check passed for {len(paths)} topical decks and {total_slides} slides."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
