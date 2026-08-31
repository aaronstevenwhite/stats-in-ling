#!/usr/bin/env python3
"""Check rendered course prose for the project's voice and separator rules."""

from __future__ import annotations

import glob
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

RENDER_PATTERNS = (
    "index.qmd",
    "learning-path.qmd",
    "assignments/*.qmd",
    "problem-sets/ps1/ps1.qmd",
    "problem-sets/ps2/ps2.qmd",
    "problem-sets/ps3/ps3-dative-alternation.qmd",
    "problem-sets/ps4/ps4.qmd",
    "problem-sets/ps5/ps5.qmd",
    "foundations/*.qmd",
    "random-variables-and-distributions/*.qmd",
    "statistical-inference/*.qmd",
    "regression-models/*.qmd",
    "model-criticism-and-prediction/*.qmd",
    "experimental-design/*.qmd",
    "latent-structure/*.qmd",
    "factorization/*.qmd",
    "missing-data/*.qmd",
    "custom-models/*.qmd",
)

BANNED = (
    "therefore",
    "for example",
    "although",
    "utilize",
    "in order to",
    "at its core",
    "at the heart of",
    "taken together",
    "key takeaway",
    "delve",
    "tapestry",
    "realm",
    "landscape",
    "deep dive",
    "state-of-the-art",
    "synergy",
    "paradigm shift",
    "navigate the complexities",
    "unpack",
    "bring to the table",
    "at the end of the day",
    "it's worth noting",
    "it is worth noting",
    "it's important to note",
    "it is important to note",
    "it should be noted",
    "needless to say",
    "in today's world",
    "in the modern era",
    "now more than ever",
    "ever-evolving",
    "ever-changing",
    "testament to",
    "stands as a testament",
    "treasure trove",
    "when it comes to",
    "a myriad",
    "plethora of",
    "plays a pivotal role",
    "plays a crucial role",
    "underscores the importance",
    "highlights the importance",
    "highlight the importance",
    "sheds light on",
    "shed light on",
    "paving the way",
    "pave the way",
    "dive into",
    "holistic",
    "seamless",
    "cutting-edge",
    "game-changer",
    "groundbreaking",
    "exciting new avenues",
    "opens the door to",
    "has the potential to revolutionize",
    "harness the power",
    "foster",
    "multifaceted",
    "nuanced",
    "resonate",
    "clearly",
    "obviously",
    "undoubtedly",
    "it is evident that",
    "without a doubt",
    "it goes without saying",
)

COINING_PATTERNS = (
    re.compile(r"\b(?:we|i) (?:will )?(?:call|refer to)\b", re.I),
    re.compile(r"\bcall (?:this|that)\b", re.I),
    re.compile(r"\bcommits? (?:the |a |an )?\*\*", re.I),
    re.compile(
        r"\bthis (?:is|creates|produces) (?:the |a |an )?\*\*[^*]*"
        r"(?:problem|error|failure|gap|mismatch|confusion|substitution|"
        r"shortcut|rule|conflation|leap|ritual|overreach|collapse)[^*]*\*\*",
        re.I,
    ),
)


def public_sources() -> list[Path]:
    files: set[Path] = set()
    for pattern in RENDER_PATTERNS:
        for match in glob.glob(str(ROOT / pattern)):
            path = Path(match)
            if path.is_file():
                files.add(path)
    return sorted(files)


def check_line(path: Path, number: int, line: str) -> list[str]:
    failures: list[str] = []
    lowered = line.casefold()

    if "—" in line:
        failures.append("em dash")
    if "–" in line:
        failures.append("en dash")
    if re.search(r"\s--\s", line):
        failures.append("double-hyphen separator")

    for phrase in BANNED:
        if re.search(rf"\b{re.escape(phrase)}\b", lowered):
            failures.append(f"banned phrase: {phrase}")

    for pattern in COINING_PATTERNS:
        if pattern.search(line):
            failures.append("nonstandard term-coining construction")

    return [
        f"{path.relative_to(ROOT)}:{number}: {failure}: {line.strip()}"
        for failure in failures
    ]


def main() -> int:
    files = public_sources()
    failures: list[str] = []

    for path in files:
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            failures.extend(check_line(path, number, line))

    if failures:
        print("Public prose check failed:")
        print("\n".join(failures))
        return 1

    print(f"Public prose check passed for {len(files)} source files.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
