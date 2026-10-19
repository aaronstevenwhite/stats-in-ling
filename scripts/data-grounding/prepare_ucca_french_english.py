#!/usr/bin/env python3
"""Prepare graph-aware counts from the UCCA French--English 20K v2 release.

The extraction uses the official ``ucca`` Python API.  It never flattens the
graphs to a dependency table.  Source passage IDs are ordered by the passage
ranges documented in the two release READMEs; the v2 XML filenames themselves
are not in bilingual-pair order.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import sys
import tarfile
import tempfile
import urllib.request
from pathlib import Path


ENGLISH_COMMIT = "47c06f9fc3a779c9195b5d0641fa13d05f8ea3b6"
FRENCH_COMMIT = "e926da7288fa548095ed2170f6d78cc4d7c334f9"
TOOLKIT_COMMIT = "31e381f2b2693e82c8402b09a6d28f97d595a1eb"

ARCHIVES = {
    "english": {
        "url": (
            "https://codeload.github.com/UniversalConceptualCognitiveAnnotation/"
            f"UCCA_English-20K/tar.gz/{ENGLISH_COMMIT}"
        ),
        "sha256": "b07b54bbbb4126481107dab55cdbccd8e2429203788d016cb1c580da01ad9a5d",
    },
    "french": {
        "url": (
            "https://codeload.github.com/UniversalConceptualCognitiveAnnotation/"
            f"UCCA_French-20K/tar.gz/{FRENCH_COMMIT}"
        ),
        "sha256": "56e900697f9fc3563d6b30a34d71e0f8f7e523cd8b1b6b942e40f1989ffd5d58",
    },
    "toolkit": {
        "url": f"https://codeload.github.com/huji-nlp/ucca/tar.gz/{TOOLKIT_COMMIT}",
        "sha256": "dc1782b02afd61f88d4c4839ffa75aee791827c88c3818157969f72699d67667",
    },
}


def inclusive(start: int, end: int) -> list[int]:
    return list(range(start, end + 1))


# The legacy passage IDs are the source-order ranges documented in both v2
# READMEs.  The current IDs are recovered from the official repository history
# and checked against source-text order.  Several reviewed passages received
# new IDs, so numeric sorting of the v2 filenames does not preserve alignment.
ENGLISH_CURRENT_IDS = (
    inclusive(2883, 2909)
    + inclusive(2845, 2848)
    + inclusive(2854, 2882)
    + inclusive(2910, 3003)
)
ENGLISH_LEGACY_IDS = (
    inclusive(36, 62)
    + inclusive(286, 318)
    + inclusive(814, 846)
    + inclusive(880, 909)
    + inclusive(968, 998)
)

FRENCH_CHAPTER_1 = (
    [3232, 3243, 3254]
    + inclusive(3262, 3266)
    + [3269, 3843, 3291, 3300, 3301, 3844, 3303, 3313, 3324, 3335]
    + inclusive(3338, 3342)
    + inclusive(3189, 3192)
)
FRENCH_CHAPTER_2 = inclusive(3193, 3225)
FRENCH_CHAPTER_3 = (
    inclusive(3226, 3231)
    + inclusive(3233, 3242)
    + inclusive(3244, 3253)
    + inclusive(3255, 3261)
)
FRENCH_CHAPTER_4 = (
    inclusive(3267, 3268)
    + inclusive(3270, 3279)
    + inclusive(3281, 3290)
    + inclusive(3292, 3299)
)
FRENCH_CHAPTER_5 = (
    [3304]
    + inclusive(3305, 3312)
    + inclusive(3314, 3323)
    + inclusive(3325, 3334)
    + inclusive(3336, 3337)
)
FRENCH_CURRENT_IDS = (
    FRENCH_CHAPTER_1
    + FRENCH_CHAPTER_2
    + FRENCH_CHAPTER_3
    + FRENCH_CHAPTER_4
    + FRENCH_CHAPTER_5
)
FRENCH_LEGACY_IDS = (
    inclusive(77, 103)
    + inclusive(416, 448)
    + inclusive(764, 796)
    + inclusive(848, 877)
    + inclusive(911, 941)
)

CHAPTERS = [1] * 27 + [2] * 33 + [3] * 33 + [4] * 30 + [5] * 31
CHAPTER_POSITIONS = (
    inclusive(1, 27)
    + inclusive(1, 33)
    + inclusive(1, 33)
    + inclusive(1, 30)
    + inclusive(1, 31)
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def safe_extract(archive: Path, destination: Path) -> Path:
    with tarfile.open(archive, "r:gz") as bundle:
        members = bundle.getmembers()
        destination_resolved = destination.resolve()
        for member in members:
            target = (destination / member.name).resolve()
            if destination_resolved not in target.parents and target != destination_resolved:
                raise ValueError(f"Unsafe archive path: {member.name}")
        bundle.extractall(destination)
    roots = [path for path in destination.iterdir() if path.is_dir()]
    if len(roots) != 1:
        raise ValueError(f"Expected one archive root in {destination}, found {roots}")
    return roots[0]


def fetch_archive(kind: str, parent: Path) -> Path:
    specification = ARCHIVES[kind]
    archive = parent / f"{kind}.tar.gz"
    urllib.request.urlretrieve(str(specification["url"]), archive)
    observed = sha256(archive)
    if observed != specification["sha256"]:
        raise ValueError(
            f"{kind} archive checksum mismatch: {observed} != {specification['sha256']}"
        )
    extracted = parent / kind
    extracted.mkdir()
    return safe_extract(archive, extracted)


def graph_counts(passage: object, language: str, release_id: int) -> dict[str, object]:
    # Imports occur after the pinned official toolkit has been put on sys.path.
    from ucca import layer0, layer1  # type: ignore

    layer_zero = passage.layer(layer0.LAYER_ID)
    layer_one = passage.layer(layer1.LAYER_ID)
    foundational_nodes = [
        node for node in layer_one.all if isinstance(node, layer1.FoundationalNode)
    ]

    scene_nodes = []
    primary_main_relation_scene_nodes = []
    implicit_scene_nodes = []
    participant_primary = participant_remote = 0
    adverbial_primary = adverbial_remote = 0
    remote_edges = primary_edges = 0

    for node in foundational_nodes:
        semantic_edges = [
            edge for edge in node.outgoing if edge.tag != layer1.EdgeTags.Terminal
        ]
        has_main_relation = any(
            edge.tag in {layer1.EdgeTags.Process, layer1.EdgeTags.State}
            for edge in semantic_edges
        )
        has_primary_main_relation = any(
            edge.tag in {layer1.EdgeTags.Process, layer1.EdgeTags.State}
            and not edge.attrib.get("remote", False)
            for edge in semantic_edges
        )
        if has_main_relation:
            scene_nodes.append(node)
            if node.attrib.get("implicit", False):
                implicit_scene_nodes.append(node)
        if has_primary_main_relation:
            primary_main_relation_scene_nodes.append(node)

        for edge in semantic_edges:
            is_remote = bool(edge.attrib.get("remote", False))
            if is_remote:
                remote_edges += 1
            else:
                primary_edges += 1
            if edge.tag == layer1.EdgeTags.Participant:
                if is_remote:
                    participant_remote += 1
                else:
                    participant_primary += 1
            if edge.tag == layer1.EdgeTags.Adverbial:
                if is_remote:
                    adverbial_remote += 1
                else:
                    adverbial_primary += 1

    discontiguous = sum(
        bool(node.discontiguous)
        for node in foundational_nodes
        if node is not layer_one.root and not node.attrib.get("implicit", False)
    )
    implicit = sum(
        bool(node.attrib.get("implicit", False)) for node in foundational_nodes
    )

    return {
        "language": language,
        "release_passage_id": str(release_id),
        "terminal_count": len(layer_zero.all),
        "word_count": len(layer_zero.words),
        "foundational_node_count": len(foundational_nodes),
        "primary_edge_count": primary_edges,
        "remote_edge_count": remote_edges,
        "implicit_node_count": implicit,
        "discontiguous_node_count": discontiguous,
        "scene_count": len(scene_nodes),
        "scene_count_primary_main_relation": len(primary_main_relation_scene_nodes),
        "implicit_scene_count": len(implicit_scene_nodes),
        "participant_primary_edge_count": participant_primary,
        "participant_remote_edge_count": participant_remote,
        "adverbial_primary_edge_count": adverbial_primary,
        "adverbial_remote_edge_count": adverbial_remote,
    }


def validate(rows: list[dict[str, object]]) -> None:
    assert len(ENGLISH_CURRENT_IDS) == len(ENGLISH_LEGACY_IDS) == 154
    assert len(FRENCH_CURRENT_IDS) == len(FRENCH_LEGACY_IDS) == 154
    assert len(set(ENGLISH_CURRENT_IDS)) == len(set(FRENCH_CURRENT_IDS)) == 154
    assert len(rows) == 308
    assert {(row["language"], row["pair_id"]) for row in rows} == {
        (language, pair_id) for language in ("en", "fr") for pair_id in range(1, 155)
    }

    by_language = {
        language: [row for row in rows if row["language"] == language]
        for language in ("en", "fr")
    }
    assert sum(int(row["terminal_count"]) for row in by_language["en"]) == 12_638
    assert sum(int(row["terminal_count"]) for row in by_language["fr"]) == 13_021
    assert sum(int(row["word_count"]) for row in by_language["en"]) == 10_812
    assert sum(int(row["word_count"]) for row in by_language["fr"]) == 11_037
    assert sum(int(row["scene_count"]) for row in by_language["en"]) == 1_839
    assert sum(int(row["scene_count"]) for row in by_language["fr"]) == 2_121

    pairs: dict[int, dict[str, dict[str, object]]] = {}
    for row in rows:
        pairs.setdefault(int(row["pair_id"]), {})[str(row["language"])] = row
    scene_absolute_difference = sum(
        abs(int(pair["fr"]["scene_count"]) - int(pair["en"]["scene_count"]))
        for pair in pairs.values()
    )
    assert scene_absolute_difference == 320


def write_csv(rows: list[dict[str, object]], path: Path) -> None:
    with path.open("w", encoding="utf-8", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]), lineterminator="\n")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    repository = Path(__file__).resolve().parents[2]
    parser = argparse.ArgumentParser()
    parser.add_argument("--english-source-directory", type=Path)
    parser.add_argument("--french-source-directory", type=Path)
    parser.add_argument("--toolkit-directory", type=Path)
    parser.add_argument(
        "--output-directory",
        type=Path,
        default=repository / "data" / "ucca-french-english",
    )
    arguments = parser.parse_args()

    temporary = tempfile.TemporaryDirectory(prefix="ucca-fr-en-")
    temporary_path = Path(temporary.name)
    english = arguments.english_source_directory or fetch_archive(
        "english", temporary_path
    )
    french = arguments.french_source_directory or fetch_archive("french", temporary_path)
    toolkit = arguments.toolkit_directory or fetch_archive("toolkit", temporary_path)
    sys.path.insert(0, str(toolkit))

    try:
        from ucca import convert  # type: ignore
        from ucca.__version__ import VERSION as toolkit_version  # type: ignore
    except ModuleNotFoundError as error:
        raise SystemExit(
            "The official UCCA toolkit requires numpy and spaCy. Install its "
            "requirements or run this script with a Python environment that provides them."
        ) from error

    rows: list[dict[str, object]] = []
    for pair_id, (chapter, within_chapter) in enumerate(
        zip(CHAPTERS, CHAPTER_POSITIONS), start=1
    ):
        specifications = (
            (
                "en",
                english,
                ENGLISH_CURRENT_IDS[pair_id - 1],
                ENGLISH_LEGACY_IDS[pair_id - 1],
            ),
            (
                "fr",
                french,
                FRENCH_CURRENT_IDS[pair_id - 1],
                FRENCH_LEGACY_IDS[pair_id - 1],
            ),
        )
        for language, source, current_id, legacy_id in specifications:
            xml_path = source / "xml" / f"{current_id}.xml"
            if not xml_path.exists():
                raise FileNotFoundError(xml_path)
            passage = convert.file2passage(str(xml_path))
            if str(passage.ID) != str(current_id):
                raise ValueError(f"Passage ID mismatch in {xml_path}: {passage.ID}")
            rows.append(
                {
                    "pair_id": pair_id,
                    "chapter": chapter,
                    "pair_position_in_chapter": within_chapter,
                    "legacy_passage_id": legacy_id,
                    **graph_counts(passage, language, current_id),
                }
            )

    validate(rows)
    arguments.output_directory.mkdir(parents=True, exist_ok=True)
    output = arguments.output_directory / "passage-counts.csv"
    write_csv(rows, output)

    provenance = {
        "dataset": "UCCA French-English Twenty Thousand Leagues v2",
        "source_repositories": {
            "english": "https://github.com/UniversalConceptualCognitiveAnnotation/UCCA_English-20K",
            "french": "https://github.com/UniversalConceptualCognitiveAnnotation/UCCA_French-20K",
            "toolkit": "https://github.com/huji-nlp/ucca",
        },
        "source_commits": {
            "english": ENGLISH_COMMIT,
            "french": FRENCH_COMMIT,
            "toolkit": TOOLKIT_COMMIT,
        },
        "source_archive_sha256": {
            key: value["sha256"] for key, value in ARCHIVES.items()
        },
        "toolkit_version": toolkit_version,
        "license": "CC BY-SA 3.0 Unported",
        "license_evidence": "Official UCCA project corpus index",
        "license_url": "https://universalconceptualcognitiveannotation.github.io/",
        "preparation_script": "scripts/data-grounding/prepare_ucca_french_english.py",
        "pairing": (
            "154 passage pairs in source order, reconstructed from the v2 READMEs "
            "and official repository rename history; v2 filenames are not pair order"
        ),
        "scene_definition": (
            "distinct foundational nodes with an outgoing P or S edge; a remote "
            "reference to a node never creates another node or another Scene"
        ),
        "rows": len(rows),
        "pairs": 154,
        "output_sha256": sha256(output),
    }
    (arguments.output_directory / "provenance.json").write_text(
        json.dumps(provenance, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(
        "Prepared 308 language-passage rows for 154 UCCA pairs; "
        "mean absolute Scene-count difference = 320 / 154."
    )


if __name__ == "__main__":
    main()
