#!/usr/bin/env python3
"""Prepare paper-audited teaching extracts from UD Turkish BOUN 2.18."""

from __future__ import annotations

import argparse
import csv
import hashlib
import tempfile
import urllib.request
from collections import Counter
from pathlib import Path
from typing import Iterator


RELEASE = "2.18"
COMMIT = "0def94a229dcbc28d32192b0138b560c075c6d87"
SOURCE_FILES = {
    "train": (
        "tr_boun-ud-train.conllu",
        "ae54aef82e69cb7ccc54703a07e2ebcde66c2e4453a5debfac1eb78dfed60e9f",
    ),
    "dev": (
        "tr_boun-ud-dev.conllu",
        "b3531bb26337b3ef258796e6948d2c3469e71704613b9373cd87f341409e2d8d",
    ),
    "test": (
        "tr_boun-ud-test.conllu",
        "c7f234f6a7c1b7025f8cab9025239286836e971b653fb1dd3f266a84ac74dbeb",
    ),
}
SOURCE_ROOT = (
    "https://raw.githubusercontent.com/UniversalDependencies/UD_Turkish-BOUN/"
    f"{COMMIT}"
)
WH_LEMMAS = {"hangi", "kim", "ne"}
CASES = {"Abl", "Acc", "Dat", "Equ", "Gen", "Ins", "Loc", "Nom"}


def turkish_lower(value: str) -> str:
    """Lowercase Turkish orthography without conflating dotted and dotless I."""
    return value.translate(str.maketrans({"I": "ı", "İ": "i"})).lower()


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def parse_features(value: str) -> dict[str, str]:
    if value == "_":
        return {}
    return dict(field.split("=", 1) for field in value.split("|") if "=" in field)


def sentences(path: Path, split: str) -> Iterator[dict[str, object]]:
    metadata: dict[str, str] = {}
    tokens: list[dict[str, object]] = []
    with path.open(encoding="utf-8") as stream:
        for raw_line in stream:
            line = raw_line.rstrip("\n")
            if line.startswith("# ") and " = " in line:
                key, value = line[2:].split(" = ", 1)
                metadata[key] = value
                continue
            if not line:
                if tokens:
                    sentence_id = metadata.get("sent_id", "")
                    yield {
                        "split": split,
                        "register": sentence_id.split("_", 1)[0],
                        "sentence_id": sentence_id,
                        "sentence_text": metadata.get("text", ""),
                        "tokens": tokens,
                    }
                metadata = {}
                tokens = []
                continue
            if line.startswith("#"):
                continue
            fields = line.split("\t")
            if len(fields) != 10 or "-" in fields[0] or "." in fields[0]:
                continue
            tokens.append(
                {
                    "token_id": int(fields[0]),
                    "form": fields[1],
                    "lemma": fields[2].lower(),
                    "upos": fields[3],
                    "features": parse_features(fields[5]),
                    "dependency_relation": fields[7],
                }
            )
    if tokens:
        sentence_id = metadata.get("sent_id", "")
        yield {
            "split": split,
            "register": sentence_id.split("_", 1)[0],
            "sentence_id": sentence_id,
            "sentence_text": metadata.get("text", ""),
            "tokens": tokens,
        }


def make_extracts(
    sources: dict[str, Path],
) -> tuple[
    list[dict[str, object]],
    list[dict[str, object]],
    list[dict[str, object]],
]:
    wh_rows: list[dict[str, object]] = []
    pronoun_rows: list[dict[str, object]] = []
    word_form_counts: Counter[str] = Counter()
    for split in ("train", "dev", "test"):
        for sentence in sentences(sources[split], split):
            tokens = sentence["tokens"]
            assert isinstance(tokens, list)
            for token in tokens:
                features = token["features"]
                assert isinstance(features, dict)
                if token["upos"] != "PUNCT":
                    word_form_counts[turkish_lower(str(token["form"]))] += 1
                shared = {
                    "split": sentence["split"],
                    "register": sentence["register"],
                    "sentence_id": sentence["sentence_id"],
                    "sentence_text": sentence["sentence_text"],
                    "token_id": token["token_id"],
                    "form": token["form"],
                    "lemma": token["lemma"],
                    "case": features.get("Case", ""),
                    "number": features.get("Number", ""),
                    "person": features.get("Person", ""),
                    "dependency_relation": token["dependency_relation"],
                }
                if (
                    token["upos"] == "PRON"
                    and features.get("PronType") == "Int"
                    and token["lemma"] in WH_LEMMAS
                    and token["dependency_relation"] in {"nsubj", "obj"}
                ):
                    wh_rows.append(
                        {
                            **shared,
                            "object": int(token["dependency_relation"] == "obj"),
                            "ne_lemma": int(token["lemma"] == "ne"),
                        }
                    )
                if (
                    token["upos"] == "PRON"
                    and features.get("PronType") == "Prs"
                    and features.get("Case") in CASES
                ):
                    pronoun_rows.append(
                        {
                            **shared,
                            "reflexive": int(features.get("Reflex") == "Yes"),
                            "accusative": int(features["Case"] == "Acc"),
                        }
                    )
    word_form_rows = [
        {"word_form": form, "frequency": frequency}
        for form, frequency in sorted(
            word_form_counts.items(), key=lambda item: (-item[1], item[0])
        )
    ]
    return wh_rows, pronoun_rows, word_form_rows


def validate(
    wh_rows: list[dict[str, object]],
    pronoun_rows: list[dict[str, object]],
    word_form_rows: list[dict[str, object]],
) -> None:
    assert len(wh_rows) == 167
    assert len(pronoun_rows) == 2_128
    keys = [(row["split"], row["sentence_id"], row["token_id"]) for row in wh_rows]
    pronoun_keys = [
        (row["split"], row["sentence_id"], row["token_id"])
        for row in pronoun_rows
    ]
    assert len(keys) == len(set(keys))
    assert len(pronoun_keys) == len(set(pronoun_keys))
    assert Counter((row["lemma"], row["dependency_relation"]) for row in wh_rows) == {
        ("hangi", "nsubj"): 2,
        ("hangi", "obj"): 1,
        ("kim", "nsubj"): 14,
        ("kim", "obj"): 3,
        ("ne", "nsubj"): 35,
        ("ne", "obj"): 112,
    }
    assert Counter(row["case"] for row in pronoun_rows) == {
        "Abl": 49,
        "Acc": 430,
        "Dat": 430,
        "Equ": 18,
        "Gen": 421,
        "Ins": 59,
        "Loc": 46,
        "Nom": 675,
    }
    assert all(row["sentence_id"] and row["sentence_text"] for row in wh_rows)
    assert all(row["sentence_id"] and row["sentence_text"] for row in pronoun_rows)
    assert all(row["case"] and row["number"] and row["person"] for row in wh_rows)
    assert all(row["case"] and row["number"] and row["person"] for row in pronoun_rows)
    assert all(row["object"] in {0, 1} and row["ne_lemma"] in {0, 1} for row in wh_rows)
    assert all(
        row["reflexive"] in {0, 1} and row["accusative"] in {0, 1}
        for row in pronoun_rows
    )
    if len(word_form_rows) != 33_876 or sum(
        int(row["frequency"]) for row in word_form_rows
    ) != 104_426:
        raise ValueError(
            "Unexpected word-form inventory: "
            f"{len(word_form_rows)} types, "
            f"{sum(int(row['frequency']) for row in word_form_rows)} tokens"
        )
    assert len({row["word_form"] for row in word_form_rows}) == len(word_form_rows)
    assert all(int(row["frequency"]) > 0 for row in word_form_rows)
    assert [int(row["frequency"]) for row in word_form_rows] == sorted(
        (int(row["frequency"]) for row in word_form_rows), reverse=True
    )


def write_rows(rows: list[dict[str, object]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    repository = Path(__file__).resolve().parents[2]
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-directory", type=Path)
    parser.add_argument(
        "--output-directory",
        type=Path,
        default=repository / "data" / "ud-turkish-boun",
    )
    arguments = parser.parse_args()

    temporary_directory: tempfile.TemporaryDirectory[str] | None = None
    if arguments.source_directory is None:
        temporary_directory = tempfile.TemporaryDirectory(prefix="ud-tr-boun-")
        source_directory = Path(temporary_directory.name)
        for filename, _ in SOURCE_FILES.values():
            urllib.request.urlretrieve(f"{SOURCE_ROOT}/{filename}", source_directory / filename)
    else:
        source_directory = arguments.source_directory

    try:
        sources = {
            split: source_directory / filename
            for split, (filename, _) in SOURCE_FILES.items()
        }
        for split, (_, expected) in SOURCE_FILES.items():
            if sha256(sources[split]) != expected:
                raise ValueError(f"UD Turkish BOUN {split} checksum does not match release {RELEASE}")
        wh_rows, pronoun_rows, word_form_rows = make_extracts(sources)
        validate(wh_rows, pronoun_rows, word_form_rows)
        write_rows(wh_rows, arguments.output_directory / "question-core-arguments.csv")
        write_rows(pronoun_rows, arguments.output_directory / "personal-pronoun-cases.csv")
        write_rows(word_form_rows, arguments.output_directory / "word-form-frequencies.csv")
        print(f"Turkish question core arguments: {len(wh_rows)}")
        print(f"Turkish case-annotated personal pronouns: {len(pronoun_rows)}")
        print(f"Turkish lowercased word-form types: {len(word_form_rows)}")
        print(f"Wrote: {arguments.output_directory.resolve()}")
    finally:
        if temporary_directory is not None:
            temporary_directory.cleanup()


if __name__ == "__main__":
    main()
