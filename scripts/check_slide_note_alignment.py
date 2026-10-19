#!/usr/bin/env python3
"""Fail unless every generated slide and transcript matches the current notes.

This check is deliberately stricter than a normal deck lint.  It proves that no
old slide body survived the rebuild by requiring generator metadata on every
horizontal slide and by checking the exact ordered identifier list recorded by
the rebuild.  It also verifies current note hashes, transcript parity, figure
existence, source blocks, and the absence of schematic-example language.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
DECK_ROOT = ROOT / "decks"
MANIFEST_PATH = DECK_ROOT / "alignment-manifest.json"
RECEIPT_PATH = DECK_ROOT / "note-render-receipts.json"

GENERATED_HEADER = 'generator: "scripts/rebuild_slides_and_transcripts.py"'
META_RE = re.compile(
    r"^## (?P<title>.+)\n\n"
    r"<!-- generated-slide-id: (?P<id>[^;]+); notes-page: (?P<page>[^;]+); "
    r"note-sha256: (?P<hash>[0-9a-f]{64}); role: (?P<role>[^ ]+) -->\n",
    re.M,
)
SCHEMATIC_RE = re.compile(
    r"\b(?:toy data|toy example|hypothetical values?|illustrative values?|"
    r"made-up values?|arbitrary numbers?|suppose there (?:are|is)|imagine a dataset)\b",
    re.I,
)
UI_TEXT_RE = re.compile(r"\b(?:Show|Hide) All Code\b", re.I)
MALFORMED_INLINE_MATH_RE = re.compile(
    r"(?:\b[A-Z][A-Za-z]*\(\)|\(\)|\(_|=\)|\(\()"
)
OPEN_CLAUSE_RE = re.compile(
    r"\b(?:and|or|as|by|for|from|if|is|are|of|that|then|to|with|"
    r"call|define|denote|give|gives|let|where)\s*[,;:]?$",
    re.I,
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def split_slides(raw: str) -> list[str]:
    return re.split(r"(?m)(?=^##\s+)", raw)[1:]


def visible_part(slide: str) -> str:
    visible = re.sub(r":::\s*\{\.notes\}.*?:::", "", slide, flags=re.S)
    visible = re.sub(r"<!--.*?-->", "", visible, flags=re.S)
    return visible


def heading_title(heading: str) -> str:
    return re.sub(r"\s*\{.*\}\s*$", "", heading).strip()


def visible_word_count(text: str) -> int:
    text = re.sub(r"\$\$.*?\$\$", " equation ", text, flags=re.S)
    text = re.sub(r"\$[^$]+\$", " variable ", text)
    text = re.sub(r"!\[[^]]*\]\([^)]+\)(?:\{[^}]*\})?", " ", text)
    text = re.sub(r"<[^>]+>", " ", text)
    text = re.sub(r"\{[^}]*\}", " ", text)
    text = re.sub(r"[#*_>`|\[\]()]+", " ", text)
    return len(re.findall(r"\b[\w'/-]+\b", text))


def check(through: str | None = None) -> list[str]:
    problems: list[str] = []
    if not MANIFEST_PATH.exists():
        return ["missing decks/alignment-manifest.json"]
    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    from rebuild_slides_and_transcripts import DECKS, selected_decks

    expected_decks = selected_decks(through)
    if list(manifest) != list(expected_decks):
        problems.append(
            "manifest scope/order differs from the requested canonical deck prefix"
        )
    if not RECEIPT_PATH.exists():
        problems.append("missing decks/note-render-receipts.json")
        receipts = {"pages": {}}
    else:
        receipts = json.loads(RECEIPT_PATH.read_text(encoding="utf-8"))
    if receipts.get("modules") != list(expected_decks):
        problems.append("render-receipt scope/order differs from requested deck prefix")
    all_ids: list[str] = []

    for module, entry in manifest.items():
        if module not in expected_decks:
            problems.append(f"{module}: module is outside requested build scope")
            continue
        if entry.get("note_pages") != expected_decks[module]["pages"]:
            problems.append(f"{module}: manifest note list differs from canonical DECKS")
        deck_path = ROOT / entry["deck"]
        transcript_path = ROOT / entry["transcript"]
        if not deck_path.exists():
            problems.append(f"{module}: missing deck {entry['deck']}")
            continue
        if not transcript_path.exists():
            problems.append(f"{module}: missing transcript {entry['transcript']}")
            continue
        raw = deck_path.read_text(encoding="utf-8")
        transcript = transcript_path.read_text(encoding="utf-8")
        if "`r " in raw + transcript or "[[INLINE-R-NOT-EVALUATED]]" in raw + transcript:
            problems.append(f"{module}: deck or transcript contains unevaluated inline R")
        if GENERATED_HEADER not in raw:
            problems.append(f"{module}: deck is not wholly generator-owned")

        matches = list(META_RE.finditer(raw))
        roles = [match.group("role") for match in matches]
        if "check" in roles:
            problems.append(f"{module}: legacy check slides remain")
        for role_index, role in enumerate(roles):
            if role == "question":
                if role_index + 1 >= len(roles) or roles[role_index + 1] != "answer":
                    problems.append(
                        f"{module} slide {role_index + 2}: question is not followed immediately by its answer"
                    )
            elif role == "answer":
                if role_index == 0 or roles[role_index - 1] != "question":
                    problems.append(
                        f"{module} slide {role_index + 2}: answer is not immediately preceded by its question"
                    )
        qmd_slide_count = len(re.findall(r"(?m)^##\s+", raw)) + 1
        expected_count = entry["slide_count_including_title"]
        if qmd_slide_count != expected_count:
            problems.append(
                f"{module}: {qmd_slide_count} slides in source, expected {expected_count}"
            )
        if len(matches) != qmd_slide_count - 1:
            problems.append(
                f"{module}: {qmd_slide_count - 1 - len(matches)} horizontal slides lack generated metadata"
            )

        observed_ids = [entry["slide_ids"][0]] + [m.group("id") for m in matches]
        if observed_ids != entry["slide_ids"]:
            problems.append(f"{module}: ordered slide identifiers differ from manifest")
        all_ids.extend(observed_ids)

        observed_page_run: list[str] = []
        for match in matches:
            page = match.group("page")
            if not observed_page_run or observed_page_run[-1] != page:
                observed_page_run.append(page)
            note_path = ROOT / page
            if not note_path.exists():
                problems.append(f"{module}: slide references missing note {page}")
            elif match.group("hash") != sha256(note_path):
                problems.append(f"{module}: stale slide generated from an older {page}")
        if observed_page_run != entry["note_pages"]:
            problems.append(f"{module}: note-page sequence is incomplete or out of order")

        for page, expected_hash in entry["note_hashes"].items():
            note_path = ROOT / page
            if not note_path.exists() or sha256(note_path) != expected_hash:
                problems.append(f"{module}: manifest note hash is stale for {page}")
            elif re.search(r"\\[()]", note_path.read_text(encoding="utf-8")):
                problems.append(f"{module}: {page} contains unsupported \\( ... \\) inline math")
            receipt = receipts.get("pages", {}).get(page, {})
            rendered_path = ROOT / "docs" / Path(page).with_suffix(".html")
            if receipt.get("source_sha256") != expected_hash:
                problems.append(f"{module}: render receipt is stale for {page}")
            if not rendered_path.exists():
                problems.append(f"{module}: rendered note HTML is missing for {page}")
            elif receipt.get("html_sha256") != sha256(rendered_path):
                problems.append(f"{module}: rendered note HTML hash differs for {page}")
            if entry.get("note_html_hashes", {}).get(page) != receipt.get("html_sha256"):
                problems.append(f"{module}: manifest rendered-note hash is stale for {page}")

        slide_chunks = split_slides(raw)
        for index, (match, slide) in enumerate(zip(matches, slide_chunks), start=2):
            notes = re.findall(r":::\s*\{\.notes\}(.*?):::", slide, flags=re.S)
            if len(notes) != 1:
                problems.append(f"{module} slide {index}: expected exactly one speaker-note block")
                continue
            if "[Transcript]" not in notes[0] or "[Sources]" not in notes[0]:
                problems.append(f"{module} slide {index}: transcript or source block missing")
            visible = visible_part(slide)
            if re.search(r"check your understanding", visible, re.I):
                problems.append(f"{module} slide {index}: exposes 'Check your understanding'")
            if "`r " in visible:
                problems.append(f"{module} slide {index}: exposes unevaluated inline R")
            if "[[INLINE-R-NOT-EVALUATED]]" in visible:
                problems.append(
                    f"{module} slide {index}: rendered inline-R value was unavailable"
                )
            if SCHEMATIC_RE.search(visible):
                problems.append(f"{module} slide {index}: contains schematic-example language")
            if UI_TEXT_RE.search(visible + notes[0]):
                problems.append(f"{module} slide {index}: contains Quarto interface text")
            prose_visible = re.sub(r"```.*?```|`[^`]*`|\$\$.*?\$\$", " ", visible, flags=re.S)
            if MALFORMED_INLINE_MATH_RE.search(prose_visible):
                problems.append(f"{module} slide {index}: contains malformed inline mathematics")
            if match.group("role") in {"concept", "interpretation"}:
                tail = re.sub(r"<[^>]+>|\$[^$]+\$|[*_#>]", " ", prose_visible)
                tail = re.sub(r"\s+", " ", tail).strip()
                if tail and (OPEN_CLAUSE_RE.search(tail) or tail.endswith(",")):
                    problems.append(f"{module} slide {index}: visible prose ends in an open clause")
            if re.search(r":\s*equation\s+\d+\s*$", match.group("title"), re.I):
                problems.append(f"{module} slide {index}: uses a generic numbered-equation title")
            if heading_title(match.group("title")).casefold() == "interpretation":
                problems.append(f"{module} slide {index}: uses the generic title 'Interpretation'")
            if match.group("role") == "math":
                visible_equations = [value.strip() for value in re.findall(r"\$\$(.*?)\$\$", visible, re.S)]
                for equation in visible_equations:
                    if equation not in notes[0]:
                        problems.append(
                            f"{module} slide {index}: transcript omits the displayed equation"
                        )
            count = visible_word_count(visible)
            if count > 70:
                problems.append(f"{module} slide {index}: {count} visible words exceed the 70-word limit")
            role = match.group("role")
            role_limit = {"concept": 32, "answer": 34, "question": 36}.get(role)
            if role_limit is not None and count > role_limit:
                problems.append(
                    f"{module} slide {index}: {role} slide has {count} visible words; "
                    f"limit is {role_limit}"
                )
            if role in {"concept", "answer"} and visible.rstrip().endswith("…"):
                problems.append(f"{module} slide {index}: compact prose ends in an ellipsis")
            for image in re.findall(r"!\[[^]]*\]\(([^)]+)\)", visible):
                image_path = (deck_path.parent / image).resolve()
                if not image_path.exists():
                    problems.append(f"{module} slide {index}: missing figure {image}")
            if match.group("role") == "dataset":
                if "https://" not in visible or 'class="source"' not in visible:
                    problems.append(f"{module} slide {index}: first dataset use lacks linked citation")

        transcript_headings = re.findall(r"(?m)^## Slide (\d+): (.+)$", transcript)
        expected_titles = [
            re.search(r'(?m)^title:\s*"(.+)"$', raw).group(1)
        ] + [heading_title(m.group("title")) for m in matches]
        observed_titles = [title for _, title in transcript_headings]
        if observed_titles != expected_titles:
            problems.append(f"{module}: transcript titles/order differ from slides")
        observed_numbers = [int(number) for number, _ in transcript_headings]
        if observed_numbers != list(range(1, expected_count + 1)):
            problems.append(f"{module}: transcript does not have one numbered segment per slide")

        declared_figures = entry["figure_slide_count"]
        observed_figures = len(re.findall(r"role: figure -->", raw))
        if observed_figures != declared_figures:
            problems.append(f"{module}: figure-slide count differs from manifest")
        if observed_figures == 0:
            problems.append(f"{module}: no empirical data visualizations")

    duplicate_ids = sorted({slide_id for slide_id in all_ids if all_ids.count(slide_id) > 1})
    if duplicate_ids:
        problems.append(f"duplicate generated slide identifiers: {', '.join(duplicate_ids[:5])}")
    return problems


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--through",
        choices=list(__import__("rebuild_slides_and_transcripts").DECKS),
        help="Validate exactly the canonical prefix ending at this module.",
    )
    args = parser.parse_args()
    problems = check(args.through)
    if problems:
        print("Slide-note alignment check failed:")
        for problem in problems:
            print(f"  {problem}")
        return 1
    manifest = json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))
    slides = sum(entry["slide_count_including_title"] for entry in manifest.values())
    figures = sum(entry["figure_slide_count"] for entry in manifest.values())
    pages = sum(len(entry["note_pages"]) for entry in manifest.values())
    print(
        f"Slide-note alignment passed: {len(manifest)} decks, {slides} slides, "
        f"{pages} note pages, {figures} empirical figure slides, and matching transcripts."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
