#!/usr/bin/env python3
"""Reject course notation that violates the probability-symbol contract."""

from __future__ import annotations

import re
from pathlib import Path

from fix_probability_notation import ROOT, SOURCE_DIRS


RULES = {
    "probability measures use the canonical mathbb symbol": re.compile(r"\\mathbb\s+P"),
    "expectations use the canonical mathbb symbol": re.compile(r"\\mathbb\s+E"),
    "expectation must use square brackets": re.compile(
        r"(?:\\mathbb\s*(?:\{E\}|E)|\\operatorname\{E\}|\\mathrm\{E\})"
        r"\s*(?:\\left|\\bigl|\\Bigl|\\biggl|\\Biggl)?\("
    ),
    "variance must use square brackets": re.compile(
        r"(?:\\operatorname\{Var\}|\\mathrm\{Var\})"
        r"\s*(?:\\left|\\bigl|\\Bigl|\\biggl|\\Biggl)?\("
    ),
    "probability measures must use mathbb P": re.compile(r"\\Pr\b"),
    "plain probability-measure P": re.compile(
        r"(?<!mathbb )(?<!mathbb\{)(?<![A-Za-z\\])P"
        r"(?=(?:_\{[^}]+\}|_[A-Za-z])?\s*(?:\\left|\\bigl|\\Bigl)?(?:\(|\\\{))"
    ),
    "plain expectation E": re.compile(r"(?<!mathbb )(?<!mathbb\{)(?<![A-Za-z\\])E(?=\s*[\[(])"),
    "PMF symbols are p or q": re.compile(r"Lowercase \$p\$, \$q\$, and \$r\$ denote PMFs"),
    "PDF symbols are f or g": re.compile(r"lowercase \$f\$, \$g\$, and \$h\$ denote PDFs", re.I),
}


def main() -> int:
    problems: list[str] = []
    for directory in SOURCE_DIRS:
        for path in sorted((ROOT / directory).rglob("*.qmd")):
            text = path.read_text(encoding="utf-8")
            for label, pattern in RULES.items():
                for match in pattern.finditer(text):
                    line = text.count("\n", 0, match.start()) + 1
                    problems.append(f"{path.relative_to(ROOT)}:{line}: {label}")
    if problems:
        print("Probability-notation check failed:")
        print("\n".join(problems))
        return 1
    print("Probability-notation check passed for notes and PS3-5; PS1-2 were excluded.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
