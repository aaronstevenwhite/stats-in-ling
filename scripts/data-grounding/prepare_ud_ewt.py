#!/usr/bin/env python3
"""Fetch and prepare pinned UD English EWT WH and pronoun extracts."""

from __future__ import annotations

import argparse
import csv
import hashlib
import tempfile
import urllib.request
from pathlib import Path
from typing import Iterator


COMMIT = "4a4d77f599ea53cc405f85d0cec4b2f14f81d42b"
SOURCE_URL = (
    "https://raw.githubusercontent.com/UniversalDependencies/UD_English-EWT/"
    f"{COMMIT}/en_ewt-ud-train.conllu"
)
SOURCE_SHA256 = "d68e06122a702464c613076523d56740f047e5bbe89dd90ec32737e04d952143"
WH_FORMS = {"what", "which", "who"}


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


def sentences(path: Path) -> Iterator[dict[str, object]]:
    metadata: dict[str, str] = {}
    tokens: list[dict[str, object]] = []
    current_document = ""
    with path.open(encoding="utf-8") as stream:
        for raw_line in stream:
            line = raw_line.rstrip("\n")
            if line.startswith("# newdoc id = "):
                current_document = line.split(" = ", 1)[1]
                continue
            if line.startswith("# ") and " = " in line:
                key, value = line[2:].split(" = ", 1)
                metadata[key] = value
                continue
            if not line:
                if tokens:
                    yield {
                        "document_id": current_document,
                        "sentence_id": metadata.get("sent_id", ""),
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
                    "lemma": fields[2],
                    "upos": fields[3],
                    "features": parse_features(fields[5]),
                    "head": int(fields[6]) if fields[6] != "_" else 0,
                    "deprel": fields[7],
                }
            )
    if tokens:
        yield {
            "document_id": current_document,
            "sentence_id": metadata.get("sent_id", ""),
            "sentence_text": metadata.get("text", ""),
            "tokens": tokens,
        }


def make_extracts(path: Path) -> tuple[list[dict[str, object]], list[dict[str, object]]]:
    wh_rows: list[dict[str, object]] = []
    pronoun_rows: list[dict[str, object]] = []
    for sentence in sentences(path):
        tokens = sentence["tokens"]
        assert isinstance(tokens, list)
        selected_wh = [
            token
            for token in tokens
            if str(token["form"]).lower() in WH_FORMS
            and token["deprel"] in {"nsubj", "obj"}
            and int(token["head"]) > 0
        ]
        if len(selected_wh) == 1:
            token = selected_wh[0]
            wh_rows.append(
                {
                    "document_id": sentence["document_id"],
                    "sentence_id": sentence["sentence_id"],
                    "sentence_text": sentence["sentence_text"],
                    "token_id": token["token_id"],
                    "wh_form": str(token["form"]).lower(),
                    "wh_lemma": str(token["lemma"]).lower(),
                    "upos": token["upos"],
                    "dependency_relation": token["deprel"],
                    "object": int(token["deprel"] == "obj"),
                }
            )

        for token in tokens:
            features = token["features"]
            assert isinstance(features, dict)
            case = features.get("Case")
            if token["upos"] != "PRON" or case not in {"Acc", "Gen", "Nom"}:
                continue
            if features.get("PronType") != "Prs":
                continue
            pronoun_rows.append(
                {
                    "document_id": sentence["document_id"],
                    "sentence_id": sentence["sentence_id"],
                    "token_id": token["token_id"],
                    "form": token["form"],
                    "lemma": token["lemma"],
                    "case": case,
                    "number": features.get("Number", ""),
                    "person": features.get("Person", ""),
                    "possessive": int(features.get("Poss") == "Yes"),
                    "dependency_relation": token["deprel"],
                    "accusative": int(case == "Acc"),
                }
            )
    return wh_rows, pronoun_rows


def validate(wh_rows: list[dict[str, object]], pronoun_rows: list[dict[str, object]]) -> None:
    if len(wh_rows) != 671:
        raise ValueError(f"Expected 671 selected WH tokens; found {len(wh_rows)}")
    if len(pronoun_rows) != 15_163:
        raise ValueError(
            f"Expected 15,163 case-annotated pronouns; found {len(pronoun_rows)}"
        )
    assert set(wh_rows[0]) == {
        "document_id", "sentence_id", "sentence_text", "token_id", "wh_form",
        "wh_lemma", "upos", "dependency_relation", "object",
    }
    assert set(pronoun_rows[0]) == {
        "document_id", "sentence_id", "token_id", "form", "lemma", "case",
        "number", "person", "possessive", "dependency_relation", "accusative",
    }
    wh_keys = [(row["sentence_id"], row["token_id"]) for row in wh_rows]
    pronoun_keys = [(row["sentence_id"], row["token_id"]) for row in pronoun_rows]
    assert len(wh_keys) == len(set(wh_keys))
    assert len(pronoun_keys) == len(set(pronoun_keys))
    assert {row["wh_form"] for row in wh_rows} == WH_FORMS
    assert {row["dependency_relation"] for row in wh_rows} == {"nsubj", "obj"}
    assert {row["case"] for row in pronoun_rows} == {"Acc", "Gen", "Nom"}
    assert all(int(row["token_id"]) > 0 for row in wh_rows + pronoun_rows)
    assert all(row["object"] in {0, 1} for row in wh_rows)
    assert all(row["possessive"] in {0, 1} for row in pronoun_rows)
    assert all(row["accusative"] in {0, 1} for row in pronoun_rows)
    assert sum(not row["number"] for row in pronoun_rows) == 2_857
    assert all(row["person"] for row in pronoun_rows)
    assert all(row["document_id"] and row["sentence_id"] for row in pronoun_rows)


def write_rows(rows: list[dict[str, object]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    repository = Path(__file__).resolve().parents[2]
    parser = argparse.ArgumentParser()
    parser.add_argument("--conllu", type=Path)
    parser.add_argument(
        "--output-directory", type=Path, default=repository / "data/ud-ewt"
    )
    arguments = parser.parse_args()

    temporary_directory: tempfile.TemporaryDirectory[str] | None = None
    if arguments.conllu is None:
        temporary_directory = tempfile.TemporaryDirectory(prefix="ud-ewt-")
        source = Path(temporary_directory.name) / "en_ewt-ud-train.conllu"
        print(f"Downloading pinned source: {SOURCE_URL}")
        urllib.request.urlretrieve(SOURCE_URL, source)
    else:
        source = arguments.conllu

    try:
        if sha256(source) != SOURCE_SHA256:
            raise ValueError("UD English EWT source checksum does not match the pin")
        wh_rows, pronoun_rows = make_extracts(source)
        validate(wh_rows, pronoun_rows)
        write_rows(wh_rows, arguments.output_directory / "ud-ewt-wh.csv")
        write_rows(pronoun_rows, arguments.output_directory / "ud-ewt-pronouns.csv")
        print(f"Selected WH tokens: {len(wh_rows)}")
        print(f"Case-annotated personal pronouns: {len(pronoun_rows)}")
        print(f"Wrote: {arguments.output_directory.resolve()}")
    finally:
        if temporary_directory is not None:
            temporary_directory.cleanup()


if __name__ == "__main__":
    main()

