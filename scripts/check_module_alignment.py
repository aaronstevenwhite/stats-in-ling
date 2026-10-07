#!/usr/bin/env python3
"""Check page-order, source markers, terminology, and notation in Modules 1--3."""

from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from pathlib import Path

from build_pedagogy_graphs import MODULES, ROOT, slide_graph


OUTPUT = ROOT / "pedagogy" / "alignment-check.json"


def page_markers(text: str) -> list[str]:
    return re.findall(r"(?m)^<!--\s*notes-page:\s*(.+?)\s*-->$", text)


def normalize_term(term: str) -> str:
    term = re.sub(r"\[([^]]+)\]\([^)]*\)", r"\1", term)
    term = re.sub(r"[$*_`{}\\]", "", term)
    term = re.sub(r"\s+", " ", term)
    return term.strip().casefold()


def defined_terms(text: str) -> list[str]:
    terms = []
    for match in re.findall(r"\*\*(.+?)\*\*", text, flags=re.DOTALL):
        term = normalize_term(match)
        if term and len(term) < 90 and not term.startswith("why this reading"):
            terms.append(term)
    return sorted(set(terms))


def slides_by_page(deck_path: Path) -> dict[str, str]:
    lines = deck_path.read_text(encoding="utf-8").splitlines()
    current = None
    grouped: dict[str, list[str]] = defaultdict(list)
    for line in lines:
        marker = re.match(r"^<!--\s*notes-page:\s*(.+?)\s*-->$", line)
        if marker:
            current = marker.group(1)
            continue
        if current:
            grouped[current].append(line)
    return {page: "\n".join(content) for page, content in grouped.items()}


def notation_problems(path: Path, display_path: str) -> list[dict]:
    problems = []
    lines = path.read_text(encoding="utf-8").splitlines()
    patterns = [
        (
            re.compile(r"\\\{\s*[A-Z](?:_[^}\s]+)?\s*(?:=|<|>|\\leq?|\\geq?|\\in)"),
            "abbreviated event set; use {omega in Omega | X(omega) ...}",
        ),
        (
            re.compile(r"\$F[012]\$"),
            "formant notation must use a subscript: F_0, F_1, or F_2",
        ),
    ]
    for number, line in enumerate(lines, 1):
        for pattern, message in patterns:
            if pattern.search(line):
                problems.append({"file": display_path, "line": number, "message": message, "text": line.strip()})
        for match in re.finditer(r"\b([a-z])\s*\\in\s*([A-Z])\b", line):
            if match.group(2) == match.group(1).upper():
                problems.append(
                    {
                        "file": display_path,
                        "line": number,
                        "message": "value-in-random-variable shorthand; name the codomain or support",
                        "text": line.strip(),
                    }
                )
    return problems


def main() -> int:
    errors: list[dict] = []
    warnings: list[dict] = []
    modules: dict[str, dict] = {}

    for module, config in MODULES.items():
        deck_path = ROOT / config["deck"]
        deck_text = deck_path.read_text(encoding="utf-8")
        markers = page_markers(deck_text)
        expected = config["notes"]
        if markers != expected:
            errors.append(
                {
                    "module": module,
                    "type": "page_order",
                    "expected": expected,
                    "observed": markers,
                }
            )

        grouped = slides_by_page(deck_path)
        term_rows = []
        for page in expected:
            note_text = (ROOT / page).read_text(encoding="utf-8")
            terms = defined_terms(note_text)
            deck_group = normalize_term(grouped.get(page, ""))
            found = [term for term in terms if term in deck_group]
            missing = [term for term in terms if term not in deck_group]
            ratio = 1.0 if not terms else len(found) / len(terms)
            term_rows.append(
                {
                    "page": page,
                    "defined_terms": terms,
                    "found": found,
                    "missing": missing,
                    "coverage": round(ratio, 3),
                }
            )
            if page not in grouped:
                errors.append({"module": module, "type": "missing_slide_block", "page": page})
            elif ratio < 0.5:
                warnings.append(
                    {
                        "module": module,
                        "type": "low_defined_term_coverage",
                        "page": page,
                        "coverage": round(ratio, 3),
                        "missing": missing,
                    }
                )

        slide_nodes, _ = slide_graph(deck_path, config["deck"])
        over_limit = [
            {"title": slide["title"], "words": slide["visible_words"], "lines": slide["source"]["lines"]}
            for slide in slide_nodes
            if slide["visible_words"] > 70
        ]
        if over_limit:
            errors.append({"module": module, "type": "slide_word_limit", "slides": over_limit})

        scope = [*config["notes"], config["deck"]]
        notation = []
        for display_path in scope:
            notation.extend(notation_problems(ROOT / display_path, display_path))
        if notation:
            errors.append({"module": module, "type": "notation", "problems": notation})

        modules[module] = {
            "expected_page_blocks": len(expected),
            "observed_page_markers": len(markers),
            "slides": len(slide_nodes),
            "page_defined_term_coverage": term_rows,
            "over_70_word_slides": over_limit,
            "notation_problems": notation,
        }

    payload = {
        "schema_version": "1.0",
        "status": "pass" if not errors else "fail",
        "errors": errors,
        "warnings": warnings,
        "modules": modules,
    }
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    if errors:
        print(f"Alignment check failed with {len(errors)} error group(s); see {OUTPUT.relative_to(ROOT)}.")
        return 1
    print(f"Alignment check passed; see {OUTPUT.relative_to(ROOT)}.")
    if warnings:
        print(f"There are {len(warnings)} term-coverage warning(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
