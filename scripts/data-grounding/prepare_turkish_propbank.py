#!/usr/bin/env python3
"""Prepare a privacy-sanitized ITU/IMST Turkish PropBank teaching extract.

The upstream CrowdFlower exports contain direct identifiers and free-text fields.
This script reads those files locally, verifies their pinned checksums, and writes
only newly numbered item/worker identifiers plus the categorical judgments needed
for the paper-audited role-description difficulty analysis.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
import unicodedata
from collections import Counter, defaultdict
from pathlib import Path


COMMIT = "5cd9c9918c8a7f4fd62802387e04d14b995ecb66"
SOURCE_REPOSITORY = "https://github.com/turkishpropbank/turkishpropbank.github.io"
SOURCE_FILES = {
    "LICENSE": "479913a99fbd3cae0b16c77253afe03e9e0b046b5901615486fc70f45524a983",
    "README.md": "2ca3ba689e4dc7616fe8257ba6068fe8db10d250468f2efe4847fb656769c6bb",
    "crowdresults/sra/argAnnotation.argres": "d1d86985652aaca7c415759aa2956a0e985a93b41bc2199223b0b46698fbb72b",
    "crowdresults/sra/jobDesign.txt": "5436d43be8a4ce1af249c643f4b6c833c6ac098cdfc116799d90bd880245f083",
    "crowdresults/sra/instructions.html": "40bb2e32870a56b1574124dae6a7734b1ecb54c99dbb52a6816e5f772da71ddb",
    "crowdresults/sra/first5100/a845549.csv": "9252d5373c4cab3ea64631f4d977085575332c2c7d9e9e196e28951e15ccec96",
    "crowdresults/sra/first5100/f845549.csv": "9c8360174c5a3c21237c9f0552dc6679ecb8151383ebbbc67d35b3a7703966e7",
    "crowdresults/sra/last13450/a846963.csv": "310fe36802ac4c59c8e158ece55d856a42a985568d9a0492851c649f26cd32c5",
    "crowdresults/sra/last13450/f846963.csv": "c88aa060e6a401cd3e78c54764c5586e561d2022b5386720c202b32f743e90b1",
}

AGGREGATE_FILES = (
    "crowdresults/sra/first5100/a845549.csv",
    "crowdresults/sra/last13450/a846963.csv",
)
JUDGMENT_FILES = (
    "crowdresults/sra/first5100/f845549.csv",
    "crowdresults/sra/last13450/f846963.csv",
)
ADJUDICATED_FILE = "crowdresults/sra/argAnnotation.argres"

# These are the general choices in the released task design. Predicate-specific
# numbered roles occur in arg0--arg4. The three choices whose final release label
# is sometimes '_' remain adjunct-like by the task definition, not by guesswork.
ADJUNCT_DESCRIPTIONS = {
    "Ettirgen eylemlerdeki yaptıran, ettiren vb",
    "Kiminle (Kardeşimle, NATOyla, onlarla)",
    "Nerede (mahallede, konuşmasında, hayalinde)",
    "İzlediği yol (patikadan)",
    "Amacı, bitiş noktası (Eve, odaya vb.) ya da faydalanan (annem için, arkadaşıma vb)",
    "Nasıl (hızlıca, güzel, yavaş, yapıp, koşup vb)",
    "Miktarı (yüzde elli), (az, çok, biraz), (benden fazla) vb.",
    "Yan cümlecik (.. olarak, ... olmak üzere vb...)",
    "Nedeni ya da kaynağı (yüzünden, onun için, dağdan vb)",
    "Cümle başındaki Bağlaç (Ayrıca, Fakat, Buna rağmen vb.) ya da Seslenme (Allahım, duy sesimi)",
    "Olumsuzluk anlamı ekleyici (Hiçbir zaman, asla, değil, yok, hiç)",
    "Yardımcı fiil elemanı (mezun olmak'taki mezun, hayal etmek'teki hayal vb... )",
    "Ne Zaman (Eylül, Pazartesi), Ne Sıklıkla (her zaman, bazen), Kaçıncı (ilk, son) ya da Ne kadarlığına (bir aylığına)",
    "Tüm cümleyi etkileyen, diğer tanımlara uymayan zarflar (Mutlaka, muhtemelen vb...)",
    "Fiil ikilemesi (yapıp yapıp, bakıla bakıla, ister istemez, olursan ol, vb... )",
    "Ne ile (uçakla, gözleriyle, çekiçle vb...)",
}
NOT_ARGUMENT_DESCRIPTION = "Eylemle ilişkili değil"
CORE_LABEL = re.compile(r"^(?:A[0-5]|A-A)$")
BANNED_OUTPUT_FIELDS = {
    "_worker_id",
    "_ip",
    "_country",
    "_region",
    "_city",
    "_created_at",
    "_started_at",
    "_last_judgment_at",
    "external_id",
    "last_ip",
    "email",
    "hata",
    "hata2",
    "sent",
    "sentence",
    "farg",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8-sig", errors="strict", newline="") as stream:
        return list(csv.DictReader(stream))


def value(row: dict[str, str], field: str) -> str:
    return (row.get(field) or "").strip()


def normalize_description(text: str) -> str:
    return re.sub(r"\s+", " ", unicodedata.normalize("NFC", text)).strip()


def aggregate_key(row: dict[str, str]) -> tuple[str, ...]:
    return tuple(value(row, field) for field in ("sid", "pred", "pred_no", "senseid", "farg"))


def adjudicated_key(row: dict[str, str]) -> tuple[str, ...]:
    return tuple(
        value(row, field)
        for field in ("sid", "predicate", "pred_no", "senseid", "farg")
    )


def role_group(aggregate: dict[str, str], adjudicated: dict[str, str]) -> str:
    description = normalize_description(value(adjudicated, "farg_desr"))
    label = value(adjudicated, "farg_label")
    core_descriptions = {
        normalize_description(value(aggregate, field))
        for field in ("arg0", "arg1", "arg2", "arg3", "arg4")
        if value(aggregate, field) not in {"", "N.A"}
    }
    if description == NOT_ARGUMENT_DESCRIPTION:
        return "not_argument"
    if CORE_LABEL.fullmatch(label) or description in core_descriptions:
        return "core"
    if label.startswith("AM-") or description in ADJUNCT_DESCRIPTIONS:
        return "adjunct"
    return "unresolved"


def write_rows(rows: list[dict[str, object]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = list(rows[0])
    if set(fields) & BANNED_OUTPUT_FIELDS:
        raise ValueError("output schema contains a prohibited identifying or free-text field")
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields, lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def prepare(source_root: Path) -> tuple[list[dict[str, object]], dict[str, object]]:
    for relative, expected in SOURCE_FILES.items():
        source = source_root / relative
        observed = sha256(source)
        if observed != expected:
            raise ValueError(f"checksum mismatch for {relative}: {observed}")

    aggregate_rows = [
        row
        for relative in AGGREGATE_FILES
        for row in read_rows(source_root / relative)
    ]
    judgment_rows = [
        row
        for relative in JUDGMENT_FILES
        for row in read_rows(source_root / relative)
    ]
    adjudicated_rows = read_rows(source_root / ADJUDICATED_FILE)

    # Reconcile the two counts reported by the paper and release. The paper's
    # 20,060 is 18,550 finalized ordinary task rows plus 1,510 unique explicit
    # gold/test candidates. Seventy-two gold candidates share a linguistic key
    # with a row flagged non-gold, numerically accounting for the 72-row drop in
    # the adjudicated release. The release does not include its build script, so
    # the provenance note reports this as a count reconciliation, not as a claim
    # to have reconstructed every post-adjudication edit.
    ordinary_rows = [row for row in aggregate_rows if value(row, "_unit_state") == "finalized"]
    explicit_gold_rows = [row for row in aggregate_rows if value(row, "_golden") == "true"]
    ordinary_keys = {aggregate_key(row) for row in ordinary_rows}
    nongold_flag_keys = {
        aggregate_key(row) for row in aggregate_rows if value(row, "_golden") == "false"
    }
    explicit_gold_keys = {aggregate_key(row) for row in explicit_gold_rows}
    overlap = nongold_flag_keys & explicit_gold_keys
    inconsistent_state_rows = [
        row
        for row in aggregate_rows
        if value(row, "_golden") == "false" and value(row, "_unit_state") == "golden"
    ]
    assert len(ordinary_rows) == 18_550
    assert len(explicit_gold_keys) == 1_510
    assert len(overlap) == 72
    assert len(inconsistent_state_rows) == 6
    assert len(ordinary_rows) + len(explicit_gold_keys) == 20_060
    assert len(ordinary_rows) + len(explicit_gold_keys) - len(overlap) == 19_988
    assert len(adjudicated_rows) == 19_988

    final_by_key: dict[tuple[str, ...], list[dict[str, str]]] = defaultdict(list)
    for row in adjudicated_rows:
        final_by_key[adjudicated_key(row)].append(row)
    for rows in final_by_key.values():
        if len({(value(row, "farg_desr"), value(row, "farg_label")) for row in rows}) != 1:
            raise ValueError("a duplicated adjudicated key has conflicting final labels")

    matched_ordinary = {
        value(row, "_unit_id"): row
        for row in ordinary_rows
        if aggregate_key(row) in final_by_key
    }
    assert len(matched_ordinary) == 18_306

    matched_judgments = [
        row for row in judgment_rows if value(row, "_unit_id") in matched_ordinary
    ]
    assert len(matched_judgments) == 55_207
    assert len({value(row, "_worker_id") for row in matched_judgments}) == 144
    assert all(value(row, "_tainted") == "false" for row in matched_judgments)
    assert all(value(row, "_missed") == "" for row in matched_judgments)

    item_map = {
        source_id: f"item_{index:05d}"
        for index, source_id in enumerate(sorted(matched_ordinary), 1)
    }
    worker_map = {
        source_id: f"worker_{index:03d}"
        for index, source_id in enumerate(
            sorted({value(row, "_worker_id") for row in matched_judgments}), 1
        )
    }
    judgment_index: Counter[str] = Counter()
    output_rows: list[dict[str, object]] = []
    for judgment in matched_judgments:
        source_item = value(judgment, "_unit_id")
        aggregate = matched_ordinary[source_item]
        adjudicated = final_by_key[aggregate_key(aggregate)][0]
        group = role_group(aggregate, adjudicated)
        judgment_index[source_item] += 1
        selected = normalize_description(value(judgment, "farg_secim"))
        final = normalize_description(value(adjudicated, "farg_desr"))
        output_rows.append(
            {
                "item_id": item_map[source_item],
                "worker_id": worker_map[value(judgment, "_worker_id")],
                "judgment_index": judgment_index[source_item],
                "predicate_lemma": value(adjudicated, "predicate"),
                "sense_id": value(adjudicated, "senseid"),
                "adjudicated_label": value(adjudicated, "farg_label"),
                "role_group": group,
                "selected_role_description": selected,
                "adjudicated_role_description": final,
                "correct": int(selected == final),
            }
        )

    counts = Counter(row["role_group"] for row in output_rows)
    assert counts == {
        "core": 36_672,
        "adjunct": 16_112,
        "not_argument": 2_252,
        "unresolved": 171,
    }
    assert sum(row["correct"] for row in output_rows) == 46_078

    summary = {
        "source_commit": COMMIT,
        "aggregate_export_rows": len(aggregate_rows),
        "ordinary_finalized_rows": len(ordinary_rows),
        "unique_explicit_gold_candidates": len(explicit_gold_keys),
        "gold_candidates_also_in_ordinary": len(overlap),
        "nongold_flagged_rows_with_golden_unit_state": len(inconsistent_state_rows),
        "paper_candidate_count_before_deduplication": 20_060,
        "adjudicated_release_rows": len(adjudicated_rows),
        "ordinary_items_exactly_linked_to_adjudication": len(matched_ordinary),
        "ordinary_items_excluded_after_post_adjudication_key_changes": len(ordinary_rows)
        - len(matched_ordinary),
        "sanitized_judgments": len(output_rows),
        "sanitized_workers": len(worker_map),
        "correct_judgments": sum(row["correct"] for row in output_rows),
        "role_group_judgments": dict(sorted(counts.items())),
    }
    return output_rows, summary


def main() -> None:
    repository = Path(__file__).resolve().parents[2]
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-root", type=Path, required=True)
    parser.add_argument(
        "--output-directory",
        type=Path,
        default=repository / "data" / "turkish-propbank",
    )
    arguments = parser.parse_args()

    rows, summary = prepare(arguments.source_root)
    output = arguments.output_directory
    data_path = output / "role-agreement-judgments.csv"
    write_rows(rows, data_path)

    provenance = {
        "dataset": "ITU/IMST Turkish PropBank semantic-role crowdsourcing release",
        "source_repository": SOURCE_REPOSITORY,
        "source_commit": COMMIT,
        "source_files": SOURCE_FILES,
        "license": "CC-BY-NC-SA-4.0",
        "preparation_script": "scripts/data-grounding/prepare_turkish_propbank.py",
        "privacy": {
            "removed": [
                "original worker and judgment identifiers",
                "IP addresses",
                "country, region, and city",
                "timestamps",
                "platform trust and channel metadata",
                "free-text error reports",
                "sentences and candidate argument text",
            ],
            "replacement": "fresh opaque item and worker identifiers local to this extract",
        },
        "linkage": "ordinary finalized task rows exactly matched to final adjudication by sentence, predicate, predicate number, sense, and candidate argument; post-adjudication key changes are excluded",
        "summary": summary,
        "outputs": {
            data_path.name: {
                "rows": len(rows),
                "sha256": sha256(data_path),
            }
        },
    }
    output.mkdir(parents=True, exist_ok=True)
    provenance_path = output / "provenance.json"
    provenance_path.write_text(
        json.dumps(provenance, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )

    print(json.dumps(summary, ensure_ascii=False, indent=2))
    print(f"Wrote: {data_path.resolve()}")
    print(f"SHA-256: {sha256(data_path)}")


if __name__ == "__main__":
    main()
