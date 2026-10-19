#!/usr/bin/env python3
"""Prepare pronunciation-level CMUdict measurements without third-party code."""

from __future__ import annotations

import argparse
import csv
import hashlib
import re
from pathlib import Path


SOURCE_SHA256 = "209a8b4cd265013e96f4658632a9878103b0c5abf62b50d4ef3ae1be226b29e4"
EXPECTED_ROWS = 133_854
ALTERNATE = re.compile(r"^(?P<word>.*)\((?P<variant>[2-9][0-9]*)\)$")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def parse_pronunciations(source: Path) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    with source.open(encoding="latin-1") as stream:
        for line_number, raw_line in enumerate(stream, 1):
            line = raw_line.rstrip("\r\n")
            if not line or line.startswith(";;;"):
                continue
            fields = line.split("  ", 1)
            if len(fields) != 2:
                raise ValueError(f"Unexpected CMUdict row at line {line_number}")
            entry, phone_string = fields
            phones = phone_string.split()
            vowel_positions = [
                index for index, phone in enumerate(phones) if phone[-1:].isdigit()
            ]
            if not vowel_positions:
                raise ValueError(f"Pronunciation has no vowel phone: {entry}")
            alternate = ALTERNATE.match(entry)
            word = alternate.group("word") if alternate else entry
            variant = int(alternate.group("variant")) if alternate else 1
            rows.append(
                {
                    "entry": entry,
                    "word": word,
                    "pronunciation_variant": variant,
                    "phones": " ".join(phones),
                    "phone_count": len(phones),
                    "vowel_phone_count": len(vowel_positions),
                    "consonants_before_first_vowel": vowel_positions[0],
                    "consonants_before_third_vowel": (
                        vowel_positions[2] - 2 if len(vowel_positions) >= 3 else ""
                    ),
                }
            )
    return rows


def validate(rows: list[dict[str, object]]) -> None:
    if len(rows) != EXPECTED_ROWS:
        raise ValueError(f"Expected {EXPECTED_ROWS} pronunciations; found {len(rows)}")
    entries = [str(row["entry"]) for row in rows]
    if len(entries) != len(set(entries)):
        raise ValueError("CMUdict entry identifiers are not unique")
    phone_counts = [int(row["phone_count"]) for row in rows]
    vowel_counts = [int(row["vowel_phone_count"]) for row in rows]
    third_counts = [
        int(row["consonants_before_third_vowel"])
        for row in rows
        if row["consonants_before_third_vowel"] != ""
    ]
    assert set(rows[0]) == {
        "entry", "word", "pronunciation_variant", "phones", "phone_count",
        "vowel_phone_count", "consonants_before_first_vowel",
        "consonants_before_third_vowel",
    }
    assert min(phone_counts) == 1 and max(phone_counts) == 32
    assert min(vowel_counts) == 1 and max(vowel_counts) == 14
    assert all(0 <= int(row["consonants_before_first_vowel"]) <= 3 for row in rows)
    assert len(third_counts) == 55_426
    assert min(third_counts) == 0 and max(third_counts) == 8
    assert sum(row["consonants_before_third_vowel"] == "" for row in rows) == 78_428
    assert all(row["entry"] and row["word"] and row["phones"] for row in rows)


def write_csv(rows: list[dict[str, object]], output: Path) -> None:
    output.parent.mkdir(parents=True, exist_ok=True)
    fields = list(rows[0])
    with output.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    repository = Path(__file__).resolve().parents[2]
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--source",
        type=Path,
        default=repository / "decks/random-variables-and-distributions/data/cmudict-0.7b",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=repository / "data/cmudict/cmudict-pronunciations.csv",
    )
    arguments = parser.parse_args()

    if sha256(arguments.source) != SOURCE_SHA256:
        raise ValueError("CMUdict source checksum does not match the audited 0.7b file")
    rows = parse_pronunciations(arguments.source)
    validate(rows)
    write_csv(rows, arguments.output)
    print(f"CMUdict pronunciations: {len(rows)}")
    print(f"Wrote: {arguments.output.resolve()}")


if __name__ == "__main__":
    main()

