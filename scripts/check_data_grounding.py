#!/usr/bin/env python3
"""Validate the dataset manifest and inventory schematic note examples.

The default mode is a release guard: manifest errors or unallowlisted source
issues produce a nonzero exit status. ``--report`` emits the same inventory but
does not fail on source issues, which makes it suitable as a migration work list.
"""

from __future__ import annotations

import argparse
import fnmatch
import hashlib
import json
import re
import shutil
import subprocess
import sys
from collections import Counter
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any, Iterable


ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "research" / "dataset-audits" / "dataset-manifest.json"
ALLOWLIST = (
    ROOT
    / "research"
    / "dataset-audits"
    / "schematic-number-allowlist.json"
)

NOTE_GLOBS = (
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

SCHEMATIC_PATTERNS = (
    ("schematic-language", re.compile(r"\bschematic (?:example|data|dataset|numbers?|probabilit)", re.I)),
    ("toy-language", re.compile(r"\btoy (?:example|data|dataset|numbers?|model|probabilit)", re.I)),
    ("hypothetical-language", re.compile(r"\bhypothetical(?:ly)?\b", re.I)),
    ("invented-language", re.compile(r"\b(?:made[- ]up|fabricated|contrived) (?:example|data|dataset|numbers?|values?)", re.I)),
    ("suppose-language", re.compile(r"\bsuppose (?:we (?:have|observe|sample|record)|that there (?:are|is)|a corpus|a speaker|an annotator)", re.I)),
    ("imagine-language", re.compile(r"\bimagine (?:we|a corpus|a speaker|an experiment|a dataset)", re.I)),
    ("simplifying-number-language", re.compile(r"\bfor simplicity,? (?:assume|set|take|let)\b", re.I)),
)

STATISTIC_WORDS = (
    r"probabilit(?:y|ies)|mean|variance|standard deviation|expect(?:ation|ed value)|"
    r"correlation|covariance|coefficient|estimate|interval|test statistic|loss|"
    r"accuracy|p[- ]?value|odds|risk|rate|proportion"
)
NUMBER = r"[+-]?(?:\d+\.\d+|\.\d+|\d+%|\d+)"

PROSE_RESULT_RE = re.compile(
    rf"\b(?:{STATISTIC_WORDS})\b[^\n]{{0,24}}?(?:is|of|=|:|equals?)\s*\$?{NUMBER}\b",
    re.I,
)
OBSERVATION_COUNT_RE = re.compile(
    rf"\b{NUMBER}\s+(?:tokens?|words?|speakers?|participants?|annotators?|items?|"
    r"trials?|responses?|ratings?|sentences?|documents?|languages?|inventories?|"
    r"verbs?|nouns?|observations?|rows?|columns?|folds?)\b",
    re.I,
)
PROBABILITY_ASSIGNMENT_RE = re.compile(
    rf"(?:\\Pr|\bP|\\mathbb\{{P\}}|\\operatorname\{{Pr\}})\s*(?:\([^)]*\)|\{{[^}}]*\}})[^=\n]{{0,8}}(?:=|\\approx)\s*{NUMBER}",
    re.I,
)
MOMENT_ASSIGNMENT_RE = re.compile(
    rf"(?:\\mathbb\{{E\}}\s*\[[^\]]*\]|\bE\s*\[[^\]]*\]|"
    rf"\\operatorname\{{Var\}}\s*\([^)]*\)|\\mathrm\{{Var\}}\s*\([^)]*\)|"
    rf"\bVar\s*\([^)]*\))\s*(?:=|\\approx)\s*{NUMBER}",
    re.I,
)
NUMERIC_FRACTION_RE = re.compile(r"\\frac\{\s*\d+\s*\}\{\s*\d+\s*\}")
NUMERIC_VECTOR_RE = re.compile(r"\bc\s*\(([^)]*)\)")
NUMERIC_PARAMETER_RE = re.compile(
    rf"\b(?:p|prob(?:ability)?|mu|sigma|lambda|mean|variance|var|sd|alpha|beta)(?:_[A-Za-z0-9]+)?\s*(?:<-|=)\s*{NUMBER}\b",
    re.I,
)
RANDOM_GENERATOR_RE = re.compile(r"\br(?:norm|binom|pois|unif|beta|gamma|nbinom)\s*\(([^)]*)\)", re.I)
INLINE_RESULT_RE = re.compile(r"`r\s+[^`]+`")
INLINE_ALLOW_RE = re.compile(r"dqr-allow:\s*([a-z][a-z0-9-]*)", re.I)
NUMERIC_TOKEN_RE = re.compile(NUMBER)

ALGORITHM_SETTING_RE = re.compile(
    r"\b(?:iter(?:ations?)?|warmup|chains?|thin|refresh|cores?|workers?|folds?|"
    r"n_folds|k_grid|grid|adapt_delta|max_treedepth|max_depth|tolerance|tol|"
    r"batch_size|step_size|draws?|samples?)\b",
    re.I,
)
SCALE_BOUNDARY_RE = re.compile(
    r"\b(?:support|endpoint|bound(?:ary|ed)?|scale|range|lower|upper|minimum|maximum)\b",
    re.I,
)


@dataclass(frozen=True)
class Context:
    code: bool
    math: bool


@dataclass
class Issue:
    path: str
    line: int
    kind: str
    message: str
    excerpt: str
    digest: str
    allowed: bool = False
    allow_reason: str | None = None


def read_json(path: Path) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        raise ValueError(f"missing required file: {path.relative_to(ROOT)}") from None
    except json.JSONDecodeError as exc:
        raise ValueError(
            f"invalid JSON in {path.relative_to(ROOT)}:{exc.lineno}:{exc.colno}: {exc.msg}"
        ) from None


def nonempty_string(value: Any) -> bool:
    return isinstance(value, str) and bool(value.strip())


def validate_manifest(data: Any) -> list[str]:
    errors: list[str] = []
    if not isinstance(data, dict):
        return ["dataset manifest must contain a JSON object"]

    for key in ("schema_version", "updated", "policy", "vocabularies", "datasets", "runs"):
        if key not in data:
            errors.append(f"manifest missing top-level field: {key}")

    vocabularies = data.get("vocabularies", {})
    datasets = data.get("datasets", {})
    runs = data.get("runs", [])
    if not isinstance(datasets, dict) or not datasets:
        errors.append("manifest datasets must be a nonempty object")
        datasets = {}
    if not isinstance(runs, list) or not runs:
        errors.append("manifest runs must be a nonempty array")
        runs = []

    audit_vocab = set(vocabularies.get("audit_status", []))
    paper_gate_vocab = set(vocabularies.get("paper_gate_status", []))
    run_vocab = set(vocabularies.get("run_status", []))
    version_vocab = set(vocabularies.get("version_state", []))
    checksum_vocab = set(vocabularies.get("checksum_state", []))
    license_vocab = set(vocabularies.get("license_state", []))

    required_dataset_fields = {
        "name",
        "variables",
        "sources",
        "version",
        "checksum",
        "license",
        "redistribution",
        "audit_status",
        "paper_gate",
        "release_blockers",
    }
    for dataset_id, dataset in datasets.items():
        prefix = f"dataset {dataset_id}"
        if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", dataset_id):
            errors.append(f"{prefix}: id must be lowercase hyphenated text")
        if not isinstance(dataset, dict):
            errors.append(f"{prefix}: record must be an object")
            continue
        missing = required_dataset_fields - set(dataset)
        for field in sorted(missing):
            errors.append(f"{prefix}: missing field {field}")
        if not nonempty_string(dataset.get("name")):
            errors.append(f"{prefix}: name must be nonempty")
        if not isinstance(dataset.get("variables"), list) or not dataset.get("variables"):
            errors.append(f"{prefix}: variables must be a nonempty array")
        sources = dataset.get("sources")
        if not isinstance(sources, list) or not sources:
            errors.append(f"{prefix}: sources must be a nonempty array")
        else:
            for index, source in enumerate(sources, 1):
                if not isinstance(source, dict) or not nonempty_string(source.get("citation")):
                    errors.append(f"{prefix}: source {index} needs a citation")
                url = source.get("url") if isinstance(source, dict) else None
                if url is not None and not re.match(r"^https://", str(url)):
                    errors.append(f"{prefix}: source {index} URL must use https")

        version = dataset.get("version", {})
        if version.get("state") not in version_vocab:
            errors.append(f"{prefix}: invalid version state {version.get('state')!r}")
        if version.get("state") == "pinned" and not nonempty_string(version.get("value")):
            errors.append(f"{prefix}: pinned version needs a value")

        checksum = dataset.get("checksum", {})
        if checksum.get("state") not in checksum_vocab:
            errors.append(f"{prefix}: invalid checksum state {checksum.get('state')!r}")
        if checksum.get("state") == "verified":
            value = checksum.get("value")
            if checksum.get("algorithm") == "sha256" and not re.fullmatch(r"[0-9a-f]{64}", str(value)):
                errors.append(f"{prefix}: verified sha256 must contain 64 lowercase hex digits")

        license_record = dataset.get("license", {})
        if license_record.get("state") not in license_vocab:
            errors.append(f"{prefix}: invalid license state {license_record.get('state')!r}")
        if dataset.get("audit_status") not in audit_vocab:
            errors.append(f"{prefix}: invalid audit status {dataset.get('audit_status')!r}")
        paper_gate = dataset.get("paper_gate", {})
        if not isinstance(paper_gate, dict):
            errors.append(f"{prefix}: paper_gate must be an object")
        else:
            paper_status = paper_gate.get("status")
            if paper_status not in paper_gate_vocab:
                errors.append(f"{prefix}: invalid paper gate status {paper_status!r}")
            evidence = paper_gate.get("evidence")
            if not nonempty_string(evidence):
                errors.append(f"{prefix}: paper_gate needs an evidence-card path")
            elif not (ROOT / evidence).is_file():
                errors.append(f"{prefix}: paper-gate evidence does not exist: {evidence}")
        if not isinstance(dataset.get("release_blockers"), list):
            errors.append(f"{prefix}: release_blockers must be an array")

    run_ids: set[str] = set()
    run_statuses: dict[str, str] = {}
    introductions: Counter[str] = Counter()
    references: Counter[str] = Counter()
    orders: dict[str, int] = {}
    dataset_orders: dict[str, list[int]] = {}
    introduction_orders: dict[str, list[int]] = {}
    for run in runs:
        if not isinstance(run, dict):
            errors.append("each run must be an object")
            continue
        run_id = run.get("id")
        prefix = f"run {run_id!r}"
        if not nonempty_string(run_id):
            errors.append("run missing nonempty id")
            continue
        if run_id in run_ids:
            errors.append(f"duplicate run id: {run_id}")
        run_ids.add(run_id)
        run_statuses[run_id] = run.get("status")
        order = run.get("order")
        if not isinstance(order, int):
            errors.append(f"{prefix}: order must be an integer")
        else:
            orders[run_id] = order
        if run.get("status") not in run_vocab:
            errors.append(f"{prefix}: invalid status {run.get('status')!r}")
        if not nonempty_string(run.get("teaching_target")):
            errors.append(f"{prefix}: teaching_target must be nonempty")
        dataset_ids = run.get("dataset_ids")
        if not isinstance(dataset_ids, list) or not dataset_ids:
            errors.append(f"{prefix}: dataset_ids must be a nonempty array")
            dataset_ids = []
        for dataset_id in dataset_ids:
            references[dataset_id] += 1
            if isinstance(order, int):
                dataset_orders.setdefault(dataset_id, []).append(order)
            if dataset_id not in datasets:
                errors.append(f"{prefix}: unknown dataset id {dataset_id}")
        introduced = run.get("introduces")
        if not isinstance(introduced, list):
            errors.append(f"{prefix}: introduces must be an array")
            introduced = []
        for dataset_id in introduced:
            introductions[dataset_id] += 1
            if isinstance(order, int):
                introduction_orders.setdefault(dataset_id, []).append(order)
            if dataset_id not in dataset_ids:
                errors.append(f"{prefix}: introduces {dataset_id} but does not use it")
        variable_types = run.get("variable_types")
        if not isinstance(variable_types, list) or not variable_types:
            errors.append(f"{prefix}: variable_types must be a nonempty array")
        dependencies = run.get("depends_on")
        if not isinstance(dependencies, list):
            errors.append(f"{prefix}: depends_on must be an array")
        segments = run.get("segments")
        if not isinstance(segments, list) or not segments:
            errors.append(f"{prefix}: segments must be a nonempty array")
        else:
            for index, segment in enumerate(segments, 1):
                if not isinstance(segment, dict):
                    errors.append(f"{prefix}: segment {index} must be an object")
                    continue
                for endpoint in ("start", "end"):
                    relative = segment.get(endpoint)
                    if not nonempty_string(relative):
                        errors.append(f"{prefix}: segment {index} missing {endpoint}")
                    elif not (ROOT / relative).is_file():
                        errors.append(f"{prefix}: segment {index} {endpoint} does not exist: {relative}")

        if run.get("status") == "ready":
            for dataset_id in dataset_ids:
                dataset = datasets.get(dataset_id, {})
                gates = (
                    dataset.get("audit_status") == "approved",
                    dataset.get("paper_gate", {}).get("status") == "passed",
                    dataset.get("version", {}).get("state") == "pinned",
                    dataset.get("checksum", {}).get("state") == "verified",
                    dataset.get("license", {}).get("state") in {"verified", "restricted"},
                )
                if not all(gates):
                    errors.append(f"{prefix}: ready run uses dataset with an open source or audit gate: {dataset_id}")
                if not any(source.get("url") for source in dataset.get("sources", [])):
                    errors.append(f"{prefix}: ready run uses dataset without a linked source: {dataset_id}")

    listed_orders = [run.get("order") for run in runs if isinstance(run, dict)]
    if all(isinstance(order, int) for order in listed_orders):
        if listed_orders != sorted(listed_orders):
            errors.append("runs must be listed in increasing order")
        if len(listed_orders) != len(set(listed_orders)):
            errors.append("run order values must be unique")

    for run in runs:
        if not isinstance(run, dict) or run.get("id") not in orders:
            continue
        for dependency in run.get("depends_on", []):
            if dependency not in run_ids:
                errors.append(f"run {run['id']}: unknown dependency {dependency}")
            elif dependency in orders and orders[dependency] >= orders[run["id"]]:
                errors.append(f"run {run['id']}: dependency {dependency} must have a lower order")
            elif run.get("status") == "ready" and run_statuses.get(dependency) != "ready":
                errors.append(
                    f"run {run['id']}: ready run depends on non-ready run {dependency}"
                )

    for dataset_id in datasets:
        if references[dataset_id] == 0:
            errors.append(f"dataset {dataset_id}: not referenced by any run")
        if introductions[dataset_id] != 1:
            errors.append(
                f"dataset {dataset_id}: expected exactly one first-use introduction, found {introductions[dataset_id]}"
            )
        elif dataset_orders.get(dataset_id) and introduction_orders.get(dataset_id):
            if min(dataset_orders[dataset_id]) != min(introduction_orders[dataset_id]):
                errors.append(f"dataset {dataset_id}: introduction is not in its earliest declared run")

    return errors


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def validate_uds_cache(manifest: Any) -> list[str]:
    """Check the promoted UDS posterior cache and its provenance contract."""
    errors: list[str] = []
    dataset = manifest.get("datasets", {}).get("uds-event-structure", {})
    artifacts = {
        artifact.get("name"): artifact.get("sha256")
        for artifact in dataset.get("source_artifacts", [])
        if isinstance(artifact, dict)
    }
    paths = {
        "uds-natural-parts.csv": ROOT / "data/uds/uds-natural-parts.csv",
        "uds-natural-parts-posterior-cache.rds": ROOT / "data/uds/uds-natural-parts-posterior-cache.rds",
        "uds-natural-parts-posterior-cache-provenance.json": ROOT / "data/uds/uds-natural-parts-posterior-cache-provenance.json",
    }
    for name, path in paths.items():
        if not path.is_file():
            errors.append(f"UDS posterior artifact missing: {path.relative_to(ROOT)}")
            continue
        expected = artifacts.get(name)
        observed = sha256_file(path)
        if expected != observed:
            errors.append(f"UDS posterior artifact checksum mismatch: {name}")

    provenance_path = paths["uds-natural-parts-posterior-cache-provenance.json"]
    if provenance_path.is_file():
        try:
            provenance = read_json(provenance_path)
        except ValueError as exc:
            errors.append(str(exc))
        else:
            expected_fields = {
                "cache_sha256": artifacts.get("uds-natural-parts-posterior-cache.rds"),
                "source_csv_sha256": artifacts.get("uds-natural-parts.csv"),
                "source_fit_sha256": "f48a5b9d37fc91728804366515b8c34864fa69f9ece7755f33a6007a4641005c",
                "stan_sha256": "5d85750a5090c6b1cd709844336372e945ec85e68f8391f0c72d7a8141329fc0",
            }
            for field, expected in expected_fields.items():
                if provenance.get(field) != expected:
                    errors.append(f"UDS cache provenance mismatch for {field}")

    rscript = shutil.which("Rscript")
    validator = ROOT / "scripts/data-grounding/validate_uds_cache.R"
    if rscript is None:
        errors.append("Rscript is required to validate the UDS posterior cache")
    elif validator.is_file() and all(path.is_file() for path in paths.values()):
        result = subprocess.run(
            [rscript, str(validator), str(ROOT)],
            capture_output=True,
            text=True,
            timeout=30,
            check=False,
        )
        if result.returncode != 0:
            detail = (result.stderr or result.stdout).strip().splitlines()
            errors.append(
                "UDS posterior cache structure check failed"
                + (f": {detail[-1]}" if detail else "")
            )
    return errors


def validate_allowlist(data: Any) -> list[str]:
    errors: list[str] = []
    if not isinstance(data, dict):
        return ["allowlist must contain a JSON object"]
    reasons = data.get("approved_reasons")
    if not isinstance(reasons, dict) or not reasons:
        errors.append("allowlist approved_reasons must be a nonempty object")
        reasons = {}
    rules = data.get("file_rules")
    if not isinstance(rules, list):
        errors.append("allowlist file_rules must be an array")
        return errors
    for index, rule in enumerate(rules, 1):
        if not isinstance(rule, dict):
            errors.append(f"allowlist rule {index} must be an object")
            continue
        if not nonempty_string(rule.get("path")):
            errors.append(f"allowlist rule {index} needs a path glob")
        if rule.get("reason") not in reasons:
            errors.append(f"allowlist rule {index} has an unapproved reason")
        digest = rule.get("digest")
        if digest is not None and not re.fullmatch(r"[0-9a-f]{16}", str(digest)):
            errors.append(f"allowlist rule {index} digest must be 16 lowercase hex digits")
        kinds = rule.get("kinds")
        if kinds is not None and (not isinstance(kinds, list) or not all(nonempty_string(k) for k in kinds)):
            errors.append(f"allowlist rule {index} kinds must be an array of strings")
    return errors


def note_sources(selected: Iterable[str] | None = None) -> list[Path]:
    if selected:
        paths = [(ROOT / value).resolve() for value in selected]
        return sorted(path for path in paths if path.is_file() and path.suffix == ".qmd")
    paths: set[Path] = set()
    for pattern in NOTE_GLOBS:
        paths.update(path for path in ROOT.glob(pattern) if path.is_file())
    return sorted(paths)


def line_digest(line: str) -> str:
    normalized = " ".join(line.strip().split())
    return hashlib.sha256(normalized.encode("utf-8")).hexdigest()[:16]


def numeric_members(argument_text: str) -> int:
    return len(NUMERIC_TOKEN_RE.findall(argument_text))


def detect_line(line: str, context: Context) -> list[tuple[str, str]]:
    detections: list[tuple[str, str]] = []
    stripped = line.strip()
    if not stripped or stripped.startswith("<!--"):
        return detections

    for kind, pattern in SCHEMATIC_PATTERNS:
        if pattern.search(line):
            detections.append((kind, "schematic-example marker"))

    if INLINE_RESULT_RE.search(line):
        return detections

    if PROSE_RESULT_RE.search(line):
        detections.append(("hard-coded-statistic", "statistical quantity appears as a numeric literal"))
    if OBSERVATION_COUNT_RE.search(line):
        detections.append(("hard-coded-sample-size", "observation count appears as a numeric literal"))
    if PROBABILITY_ASSIGNMENT_RE.search(line):
        detections.append(("hard-coded-probability", "probability is assigned a numeric literal"))
    if MOMENT_ASSIGNMENT_RE.search(line):
        detections.append(("hard-coded-moment", "expectation or variance is assigned a numeric literal"))

    if context.math and NUMERIC_FRACTION_RE.search(line):
        detections.append(("numeric-math-example", "displayed mathematics contains a fully numeric fraction"))
    if context.math and "&" in line and numeric_members(line) >= 2:
        detections.append(("numeric-math-array", "displayed mathematical array contains numeric entries"))

    if context.code:
        for match in NUMERIC_VECTOR_RE.finditer(line):
            if numeric_members(match.group(1)) >= 3:
                detections.append(("hard-coded-r-vector", "R code contains a vector of at least three numeric literals"))
                break
        if NUMERIC_PARAMETER_RE.search(line):
            detections.append(("hard-coded-r-parameter", "R code assigns a model-like parameter from a numeric literal"))
        generator = RANDOM_GENERATOR_RE.search(line)
        if generator and numeric_members(generator.group(1)) >= 2:
            detections.append(("hard-coded-r-generator", "R generator uses multiple numeric literal arguments"))

    if stripped.startswith("|") and not re.fullmatch(r"[|:\- ]+", stripped):
        cells = [cell.strip() for cell in stripped.strip("|").split("|")]
        numeric_cells = [
            cell
            for cell in cells
            if re.match(rf"^[`*$\s]*[\[(]?\s*{NUMBER}(?:\s|$|[\],)])", cell)
        ]
        has_bare_decimal = any(
            re.search(r"(?:^|[\s\[(])[+-]?(?:\d+\.\d+|\.\d+)(?:$|[\s\],)])", cell)
            and not re.search(r"[A-Za-z]", cell)
            for cell in numeric_cells
        )
        if len(numeric_cells) >= 2 or has_bare_decimal:
            detections.append(("hard-coded-table-row", "Markdown table row contains numeric literals"))

    # Preserve order while avoiding duplicate kinds on one line.
    seen: set[str] = set()
    return [item for item in detections if not (item[0] in seen or seen.add(item[0]))]


def automatic_reason(line: str, context: Context, kind: str) -> str | None:
    if kind.startswith(("schematic-", "toy-", "hypothetical-", "invented-", "suppose-", "imagine-", "simplifying-")):
        return None
    if re.search(r"\bset\.seed\s*\(", line):
        return "random-seed"
    if context.code and ALGORITHM_SETTING_RE.search(line):
        return "algorithm-setting"
    if context.code and kind == "hard-coded-r-parameter" and re.search(r"\bmu\s*(?:<-|=)\s*0\b", line):
        return "symbolic-derivation"
    if SCALE_BOUNDARY_RE.search(line) and set(re.findall(r"\d+", line)).issubset({"0", "1", "100"}):
        return "scale-boundary"
    if context.math:
        integers = set(re.findall(r"(?<![A-Za-z])\d+(?![A-Za-z])", line))
        has_decimal = bool(re.search(r"\d+\.\d+|\.\d+", line))
        if integers and integers.issubset({"0", "1", "2"}) and not has_decimal:
            return "symbolic-derivation"
    return None


def external_reason(issue: Issue, rules: list[dict[str, Any]]) -> str | None:
    for rule in rules:
        if not fnmatch.fnmatch(issue.path, rule.get("path", "")):
            continue
        kinds = rule.get("kinds")
        if kinds is not None and issue.kind not in kinds:
            continue
        if rule.get("digest") is not None and issue.digest != rule["digest"]:
            continue
        return rule.get("reason")
    return None


def scan_file(
    path: Path,
    approved_reasons: set[str],
    rules: list[dict[str, Any]],
) -> list[Issue]:
    relative = path.relative_to(ROOT).as_posix()
    lines = path.read_text(encoding="utf-8").splitlines()
    in_frontmatter = bool(lines and lines[0].strip() == "---")
    in_code = False
    in_math = False
    issues: list[Issue] = []

    for number, line in enumerate(lines, 1):
        stripped = line.strip()
        if number == 1 and in_frontmatter:
            continue
        if in_frontmatter:
            if stripped == "---":
                in_frontmatter = False
            continue

        if stripped.startswith("```"):
            in_code = not in_code
            continue
        if not in_code and (stripped.startswith("$$") or stripped in {"\\[", "\\]"}):
            # A one-line $$ expression starts and ends on the same line.
            one_line = stripped.startswith("$$") and stripped.endswith("$$") and len(stripped) > 4
            context = Context(code=False, math=True)
            if not one_line:
                in_math = not in_math
        else:
            context = Context(code=in_code, math=in_math)

        detections = detect_line(line, context)
        if not detections:
            continue
        directive = INLINE_ALLOW_RE.search(line)
        directive_reason = directive.group(1).lower() if directive else None
        for kind, message in detections:
            issue = Issue(
                path=relative,
                line=number,
                kind=kind,
                message=message,
                excerpt=stripped[:240],
                digest=line_digest(line),
            )
            reason = directive_reason or automatic_reason(line, context, kind)
            if reason is None:
                reason = external_reason(issue, rules)
            if reason is not None:
                issue.allowed = reason in approved_reasons
                issue.allow_reason = reason
            issues.append(issue)
    return issues


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--report",
        action="store_true",
        help="emit the inventory but do not fail on source issues",
    )
    parser.add_argument(
        "--manifest-only",
        action="store_true",
        help="validate the manifest and allowlist without scanning notes",
    )
    parser.add_argument(
        "--show-allowed",
        action="store_true",
        help="include automatically or explicitly allowed detections in text output",
    )
    parser.add_argument(
        "--json-output",
        type=Path,
        help="write the complete inventory as JSON",
    )
    parser.add_argument(
        "--max-items",
        type=int,
        default=200,
        help="maximum number of source issues printed in text output",
    )
    parser.add_argument(
        "paths",
        nargs="*",
        help="optional repository-relative QMD files to scan",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    configuration_errors: list[str] = []
    try:
        manifest = read_json(MANIFEST)
        configuration_errors.extend(validate_manifest(manifest))
        configuration_errors.extend(validate_uds_cache(manifest))
    except ValueError as exc:
        manifest = {}
        configuration_errors.append(str(exc))
    try:
        allowlist = read_json(ALLOWLIST)
        configuration_errors.extend(validate_allowlist(allowlist))
    except ValueError as exc:
        allowlist = {}
        configuration_errors.append(str(exc))

    if configuration_errors:
        print("Data-grounding configuration check failed:")
        print("\n".join(f"- {error}" for error in configuration_errors))
        return 2

    if args.manifest_only:
        print(
            "Data manifest check passed for "
            f"{len(manifest['datasets'])} datasets and {len(manifest['runs'])} empirical runs."
        )
        return 0

    approved_reasons = set(allowlist["approved_reasons"])
    rules = allowlist["file_rules"]
    files = note_sources(args.paths)
    issues: list[Issue] = []
    for path in files:
        issues.extend(scan_file(path, approved_reasons, rules))

    unallowed = [issue for issue in issues if not issue.allowed]
    allowed = [issue for issue in issues if issue.allowed]
    kind_counts = Counter(issue.kind for issue in unallowed)
    reason_counts = Counter(issue.allow_reason for issue in allowed)

    displayed = issues if args.show_allowed else unallowed
    for issue in displayed[: max(args.max_items, 0)]:
        status = f"allowed:{issue.allow_reason}" if issue.allowed else "review"
        print(
            f"{issue.path}:{issue.line}: [{status}] {issue.kind}: "
            f"{issue.message}: {issue.excerpt}"
        )
    if len(displayed) > args.max_items >= 0:
        print(f"... {len(displayed) - args.max_items} additional items omitted")

    print(
        f"Data-grounding inventory: {len(files)} files; "
        f"{len(unallowed)} review items; {len(allowed)} allowlisted items."
    )
    if kind_counts:
        print("Review items by kind: " + ", ".join(f"{key}={value}" for key, value in sorted(kind_counts.items())))
    if reason_counts:
        print("Allowlisted items by reason: " + ", ".join(f"{key}={value}" for key, value in sorted(reason_counts.items())))

    if args.json_output:
        output = args.json_output if args.json_output.is_absolute() else ROOT / args.json_output
        payload = {
            "schema_version": 1,
            "files_scanned": len(files),
            "review_count": len(unallowed),
            "allowed_count": len(allowed),
            "issues": [asdict(issue) for issue in issues],
        }
        output.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")

    if unallowed and not args.report:
        print("Data-grounding guard failed. Use --report for a nonblocking migration inventory.")
        return 1
    print("Data-grounding guard passed." if not unallowed else "Data-grounding report completed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
