#!/usr/bin/env python3
"""Canonicalize probability notation outside PS1 and PS2.

This is a narrow mechanical rewrite. It changes delimiters and notation symbols,
not claims, values, code, or prose.
"""

from __future__ import annotations

import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIRS = [
    "foundations",
    "random-variables-and-distributions",
    "statistical-inference",
    "regression-models",
    "model-criticism-and-prediction",
    "experimental-design",
    "latent-structure",
    "factorization",
    "missing-data",
    "custom-models",
    "problem-sets/ps3",
    "problem-sets/ps4",
    "problem-sets/ps5",
]

CALL = re.compile(
    r"(?P<command>"
    r"\\mathbb\s*(?:\{E\}|E)|"
    r"\\operatorname\{E\}|\\mathrm\{E\}|"
    r"\\operatorname\{Var\}|\\mathrm\{Var\}"
    r")(?P<space>\s*)(?P<size>\\(?:left|bigl|Bigl|biggl|Biggl))?\("
)


def closing_paren(text: str, opening: int) -> int | None:
    depth = 0
    for index in range(opening, len(text)):
        char = text[index]
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
            if depth == 0:
                return index
    return None


def square_calls(text: str) -> str:
    """Rewrite E(...) and Var(...) calls, including nested calls."""
    while True:
        match = CALL.search(text)
        if not match:
            return text
        opening = match.end() - 1
        closing = closing_paren(text, opening)
        if closing is None:
            raise ValueError(f"unmatched notation call near: {text[match.start():match.start()+80]!r}")
        inner = square_calls(text[opening + 1 : closing])
        command = match.group("command")
        canonical = (
            r"\operatorname{Var}"
            if "Var" in command
            else r"\mathbb{E}"
        )
        close_prefix = re.search(r"\\(?:right|bigr|Bigr|biggr|Biggr)$", inner)
        if close_prefix:
            inner = inner[: close_prefix.start()]
        replacement = f"{canonical}[{inner}]"
        text = text[: match.start()] + replacement + text[closing + 1 :]


def canonicalize(text: str) -> str:
    text = text.replace(r"\Pr", r"\mathbb{P}")
    text = re.sub(r"\\mathbb\s+P", r"\\mathbb{P}", text)
    text = re.sub(r"\\mathbb\s+E", r"\\mathbb{E}", text)
    text = re.sub(
        r"(?<!mathbb )(?<!mathbb\{)(?<![A-Za-z\\])P"
        r"(?=(?:_\{[^}]+\}|_[A-Za-z])?\s*(?:\\left|\\bigl|\\Bigl)?(?:\(|\\\{))",
        r"\\mathbb{P}",
        text,
    )
    text = re.sub(
        r"(?<!mathbb )(?<!mathbb\{)(?<![A-Za-z\\])E(?=\s*[\[(])",
        r"\\mathbb{E}",
        text,
    )
    return square_calls(text)


def main() -> int:
    changed: list[str] = []
    for directory in SOURCE_DIRS:
        for path in sorted((ROOT / directory).rglob("*.qmd")):
            before = path.read_text(encoding="utf-8")
            after = canonicalize(before)
            if before != after:
                path.write_text(after, encoding="utf-8")
                changed.append(str(path.relative_to(ROOT)))
    print(f"canonicalized probability notation in {len(changed)} files")
    for path in changed:
        print(path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
