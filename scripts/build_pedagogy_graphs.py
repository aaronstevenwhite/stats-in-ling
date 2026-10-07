#!/usr/bin/env python3
"""Build auditable pedagogy graphs for the reference notes and course modules.

The graphs are deliberately source anchored.  Every content node records a file and
line span, and every sequential edge records the order in which a reader encounters
the material.  This makes the JSON useful both as a visualization input and as a
regression artifact for note/slide alignment.
"""

from __future__ import annotations

import hashlib
import json
import re
import subprocess
from collections import Counter
from pathlib import Path
from statistics import mean, median


ROOT = Path(__file__).resolve().parents[1]
REFERENCE_ROOT = Path(
    "/Users/awhite48/Projects/representation-learning-course/"
    "foundational-concepts-in-probability-and-statistics"
)
OUTPUT_ROOT = ROOT / "pedagogy"

REFERENCE_FILES = [
    "index.qmd",
    "random-variables-and-probability-distributions.qmd",
    "statistical-inference.qmd",
]

MODULES = {
    "data-and-probability": {
        "notes": [
            "foundations/index.qmd",
            "foundations/linguistic-data.qmd",
            "foundations/making-sense-of-data.qmd",
            "foundations/zipfs-law.qmd",
            "foundations/possibilities-and-events.qmd",
            "foundations/events.qmd",
            "foundations/event-spaces.qmd",
            "foundations/generating-event-spaces.qmd",
            "foundations/probability-measures.qmd",
            "foundations/probability-concepts.qmd",
            "foundations/joint-probability-of-events.qmd",
            "foundations/conditional-probability.qmd",
            "foundations/probability-factorization.qmd",
            "foundations/bayes-rule.qmd",
            "foundations/independence.qmd",
        ],
        "deck": "decks/data-and-probability/index.qmd",
    },
    "random-variables-and-distributions": {
        "notes": [
            "random-variables-and-distributions/index.qmd",
            "random-variables-and-distributions/why-random-variables.qmd",
            "random-variables-and-distributions/defining-random-variables.qmd",
            "random-variables-and-distributions/discrete-random-variables.qmd",
            "random-variables-and-distributions/probability-mass-functions.qmd",
            "random-variables-and-distributions/continuous-random-variables.qmd",
            "random-variables-and-distributions/probability-density-functions.qmd",
            "random-variables-and-distributions/cumulative-distribution-functions.qmd",
            "random-variables-and-distributions/expected-values.qmd",
            "random-variables-and-distributions/expectation-of-functions.qmd",
            "random-variables-and-distributions/linearity-of-expectation.qmd",
            "random-variables-and-distributions/when-expectations-fail.qmd",
            "random-variables-and-distributions/variance-and-covariance.qmd",
            "random-variables-and-distributions/standard-deviation.qmd",
            "random-variables-and-distributions/central-moments.qmd",
            "random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd",
            "random-variables-and-distributions/bernoulli-distribution.qmd",
            "random-variables-and-distributions/binomial-distribution.qmd",
            "random-variables-and-distributions/hypergeometric-distribution.qmd",
            "random-variables-and-distributions/geometric-distribution.qmd",
            "random-variables-and-distributions/negative-binomial-distribution.qmd",
            "random-variables-and-distributions/poisson-distribution.qmd",
            "random-variables-and-distributions/uniform-distribution.qmd",
            "random-variables-and-distributions/beta-distribution.qmd",
            "random-variables-and-distributions/normal-distribution.qmd",
            "random-variables-and-distributions/chi-squared-distribution.qmd",
            "random-variables-and-distributions/student-t-distribution.qmd",
            "random-variables-and-distributions/inverse-transform-sampling.qmd",
            "random-variables-and-distributions/random-seeds.qmd",
            "random-variables-and-distributions/joint-probability.qmd",
            "random-variables-and-distributions/marginal-distributions.qmd",
            "random-variables-and-distributions/conditional-independence.qmd",
            "random-variables-and-distributions/conditional-expectation.qmd",
            "random-variables-and-distributions/covariance.qmd",
            "random-variables-and-distributions/correlation.qmd",
        ],
        "deck": "decks/random-variables-and-distributions/index.qmd",
    },
    "statistical-inference": {
        "notes": [
            "statistical-inference/index.qmd",
            "statistical-inference/populations-and-samples.qmd",
            "statistical-inference/independent-sampling.qmd",
            "statistical-inference/pronoun-case-example.qmd",
            "statistical-inference/maximum-likelihood.qmd",
            "statistical-inference/poisson-maximum-likelihood.qmd",
            "statistical-inference/properties-of-estimators.qmd",
            "statistical-inference/standard-errors.qmd",
            "statistical-inference/estimator-bias.qmd",
            "statistical-inference/mean-squared-error.qmd",
            "statistical-inference/confidence-intervals.qmd",
            "statistical-inference/exact-binomial-intervals.qmd",
            "statistical-inference/bootstrap-confidence-intervals.qmd",
            "statistical-inference/null-hypotheses-and-test-statistics.qmd",
            "statistical-inference/one-sample-t-inference.qmd",
            "statistical-inference/paired-observations.qmd",
            "statistical-inference/paired-mean-inference.qmd",
            "statistical-inference/independent-means.qmd",
            "statistical-inference/fishers-exact-test.qmd",
            "statistical-inference/chi-squared-test.qmd",
            "statistical-inference/posterior-distributions.qmd",
            "statistical-inference/posterior-summaries.qmd",
            "statistical-inference/conjugate-priors.qmd",
            "statistical-inference/prior-predictive-distributions.qmd",
            "statistical-inference/predictive-distributions.qmd",
            "statistical-inference/beyond-conjugacy.qmd",
            "statistical-inference/monte-carlo-integration.qmd",
            "statistical-inference/importance-sampling.qmd",
            "statistical-inference/markov-chains.qmd",
            "statistical-inference/markov-chain-monte-carlo.qmd",
            "statistical-inference/metropolis-hastings.qmd",
            "statistical-inference/hamiltonian-monte-carlo.qmd",
            "statistical-inference/mass-matrix-geometry.qmd",
            "statistical-inference/no-u-turn-sampler.qmd",
            "statistical-inference/stan.qmd",
            "statistical-inference/checking-markov-chains.qmd",
            "statistical-inference/rhat.qmd",
            "statistical-inference/autocorrelation.qmd",
            "statistical-inference/effective-sample-size.qmd",
            "statistical-inference/divergent-transitions.qmd",
            "statistical-inference/parameter-pair-plots.qmd",
            "statistical-inference/generated-quantities.qmd",
            "statistical-inference/posterior-predictive-checks.qmd",
        ],
        "deck": "decks/statistical-inference/index.qmd",
    },
}

MOTIFS = {
    "concept_cycle": [
        "MOTIVATE",
        "NAME_DEFINE",
        "FORMALIZE",
        "INSTANTIATE",
        "OPERATIONALIZE_OR_VISUALIZE",
        "INTERPRET",
        "CAVEAT_OR_EXTEND",
    ],
    "question_repair": [
        "POSE_QUESTION",
        "REJECT_NAIVE_ANSWER",
        "COUNTEREXAMPLE",
        "DEMONSTRATE_FAILURE",
        "NAME_REPAIR",
        "IMPLEMENT_REPAIR",
    ],
    "notation_contract": [
        "WRITE_FULL_FORM",
        "DEFINE_SHORTHAND",
        "READ_SHORTHAND",
        "STATE_SCOPE",
        "RECALL_FULL_FORM",
    ],
    "parameter_sweep": [
        "DEFINE_FAMILY",
        "BASELINE",
        "VARY_ONE_PARAMETER",
        "VISUALIZE",
        "INTERPRET_GEOMETRY",
        "TEST_LINGUISTIC_ADEQUACY",
    ],
    "module_close": [
        "ENUMERATE_OBJECTS",
        "STATE_DEPENDENCIES",
        "IDENTIFY_LIMITS",
        "POINT_FORWARD",
    ],
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def title_from_qmd(text: str, fallback: str) -> str:
    match = re.search(r'(?m)^title:\s*["\']?(.+?)["\']?\s*$', text)
    return match.group(1).strip('"\'') if match else fallback


def body_start(lines: list[str]) -> int:
    if not lines or lines[0].strip() != "---":
        return 0
    for index in range(1, len(lines)):
        if lines[index].strip() == "---":
            return index + 1
    return 0


def compact(text: str, limit: int = 180) -> str:
    text = re.sub(r"\s+", " ", text).strip()
    return text if len(text) <= limit else text[: limit - 1].rstrip() + "…"


def classify(kind: str, text: str) -> str:
    low = re.sub(r"\s+", " ", text).casefold()
    if kind == "heading":
        if any(word in low for word in ("check", "test your", "question")):
            return "CHECK"
        if any(word in low for word in ("summary", "summing up")):
            return "SUMMARIZE"
        return "ORIENT"
    if kind == "code":
        if re.search(r"\b(plot|hist|ggplot|lines|geom_|subplot|ax\.)\b", low):
            return "VISUALIZE"
        return "OPERATIONALIZE"
    if kind == "math":
        if any(token in text for token in ("\\begin{aligned}", "\\sum", "\\int", "\\prod", "\\frac")):
            return "DERIVE"
        return "FORMALIZE"
    if kind in {"table", "figure"}:
        return "INSTANTIATE"
    if ":::" in low and ("question" in low or "check" in low):
        return "CHECK"
    if any(phrase in low for phrase in ("known as", "referred to as", "we call", "is a [**", "definition")):
        return "NAME_DEFINE"
    if any(phrase in low for phrase in ("suppose", "consider", "for instance", "running example")):
        return "INSTANTIATE"
    if "?" in text or any(phrase in low for phrase in ("how do", "what does", "why does", "can we")):
        return "MOTIVATE"
    if any(phrase in low for phrase in ("does not", "cannot", "fails", "limitation", "potential worry", "but ", "however")):
        return "CAVEAT"
    if any(phrase in low for phrase in ("thus", "the exact upshot", "this means", "the result", "the moral")):
        return "INTERPRET"
    if any(phrase in low for phrase in ("next page", "we now turn", "we next", "begin with")):
        return "TRANSITION"
    return "DEVELOP"


def parse_blocks(path: Path, display_path: str) -> list[dict]:
    return parse_blocks_text(path.read_text(encoding="utf-8"), display_path)


def parse_blocks_text(text: str, display_path: str) -> list[dict]:
    lines = text.splitlines()
    index = body_start(lines)
    blocks: list[dict] = []
    serial = 0

    def add(kind: str, start: int, end: int, raw: str) -> None:
        nonlocal serial
        if not raw.strip():
            return
        node_id = f"{display_path}::b{serial:04d}"
        blocks.append(
            {
                "id": node_id,
                "type": "content_block",
                "source": {"file": display_path, "lines": [start, end]},
                "kind": kind,
                "move": classify(kind, raw),
                "excerpt": compact(raw),
                "layout": {"rank": serial, "x": 0, "y": serial},
            }
        )
        serial += 1

    while index < len(lines):
        line = lines[index]
        if not line.strip():
            index += 1
            continue
        start = index + 1
        if line.startswith("```"):
            fence = line[:3]
            end_index = index + 1
            while end_index < len(lines) and not lines[end_index].startswith(fence):
                end_index += 1
            end_index = min(end_index, len(lines) - 1)
            add("code", start, end_index + 1, "\n".join(lines[index : end_index + 1]))
            index = end_index + 1
            continue
        if line.strip().startswith("$$"):
            end_index = index
            if line.strip() == "$$":
                end_index += 1
                while end_index < len(lines) and lines[end_index].strip() != "$$":
                    end_index += 1
            add("math", start, min(end_index + 1, len(lines)), "\n".join(lines[index : end_index + 1]))
            index = end_index + 1
            continue
        heading = re.match(r"^(#{1,6})\s+(.+)$", line)
        if heading:
            add("heading", start, start, heading.group(2))
            index += 1
            continue
        if line.lstrip().startswith("|"):
            end_index = index + 1
            while end_index < len(lines) and lines[end_index].lstrip().startswith("|"):
                end_index += 1
            add("table", start, end_index, "\n".join(lines[index:end_index]))
            index = end_index
            continue
        if re.match(r"^\s*(?:[-*+] |\d+\. )", line):
            end_index = index + 1
            while end_index < len(lines) and (
                re.match(r"^\s*(?:[-*+] |\d+\. )", lines[end_index])
                or (lines[end_index].strip() and lines[end_index].startswith("  "))
            ):
                end_index += 1
            add("list", start, end_index, "\n".join(lines[index:end_index]))
            index = end_index
            continue
        end_index = index + 1
        while end_index < len(lines) and lines[end_index].strip():
            if lines[end_index].startswith("```") or lines[end_index].strip().startswith("$$"):
                break
            if re.match(r"^#{1,6}\s+", lines[end_index]):
                break
            if lines[end_index].lstrip().startswith("|"):
                break
            end_index += 1
        raw = "\n".join(lines[index:end_index])
        kind = "figure" if re.search(r"!\[[^]]*\]\(", raw) else "prose"
        add(kind, start, end_index, raw)
        index = end_index
    return blocks


def strip_for_style(text: str) -> str:
    lines = text.splitlines()
    start = body_start(lines)
    text = "\n".join(lines[start:])
    text = re.sub(r"```.*?```", " ", text, flags=re.DOTALL)
    text = re.sub(r"\$\$.*?\$\$", " ", text, flags=re.DOTALL)
    text = re.sub(r"\$[^$]+\$", " ", text)
    text = re.sub(r"(?m)^#{1,6}\s+.*$", " ", text)
    text = re.sub(r"\[([^]]+)\]\([^)]*\)", r"\1", text)
    text = re.sub(r"[*_`>#]", "", text)
    return text


def style_metrics(paths: list[Path]) -> dict:
    raw = "\n\n".join(path.read_text(encoding="utf-8") for path in paths)
    return style_metrics_text(raw)


def style_metrics_text(raw: str) -> dict:
    prose = strip_for_style(raw)
    paragraphs = [re.sub(r"\s+", " ", p).strip() for p in re.split(r"\n\s*\n", prose) if p.strip()]
    sentences = [
        sentence.strip()
        for sentence in re.split(r"(?<=[.!?])\s+(?=[A-Z\[])|\n+", "\n".join(paragraphs))
        if sentence.strip()
    ]
    lengths = [len(re.findall(r"\b[\w’'-]+\b", sentence)) for sentence in sentences]
    words = re.findall(r"\b[\w’'-]+\b", prose)
    phrases = [
        "for instance", "for example", "thus", "therefore", "though", "although",
        "that is", "basically", "more specifically", "suppose", "consider",
        "this", "but", "and", "so", "note that", "we", "i", "you",
        "may", "might", "could", "would", "tend to", "suggests", "appears",
        "indeed", "in fact", "crucially", "clearly", "obviously",
    ]
    lower = prose.casefold()
    counts = {phrase: len(re.findall(rf"\b{re.escape(phrase)}\b", lower)) for phrase in phrases}
    hedge_count = sum(counts[item] for item in ("may", "might", "could", "would", "tend to", "suggests", "appears"))
    booster_count = sum(counts[item] for item in ("indeed", "in fact", "crucially", "clearly", "obviously"))
    initial_counts = {
        token: len(re.findall(rf"(?m)(?:^|[.!?]\s+)({re.escape(token)})\b", prose, flags=re.I))
        for token in ("This", "So", "But", "And", "Thus", "Note that")
    }
    paragraph_sentence_counts = [
        len(re.findall(r"[.!?](?:\s|$)", paragraph)) or 1 for paragraph in paragraphs
    ]
    return {
        "words": len(words),
        "sentences": len(sentences),
        "sentence_words": {
            "mean": round(mean(lengths), 2) if lengths else 0,
            "median": round(median(lengths), 2) if lengths else 0,
            "under_10_percent": round(100 * sum(n < 10 for n in lengths) / len(lengths), 2) if lengths else 0,
            "at_least_40_percent": round(100 * sum(n >= 40 for n in lengths) / len(lengths), 2) if lengths else 0,
        },
        "paragraphs": len(paragraphs),
        "sentences_per_paragraph": {
            "mean": round(mean(paragraph_sentence_counts), 2) if paragraph_sentence_counts else 0,
            "median": round(median(paragraph_sentence_counts), 2) if paragraph_sentence_counts else 0,
        },
        "phrase_counts": counts,
        "stance": {
            "hedges": hedge_count,
            "boosters": booster_count,
            "hedges_per_booster": round(hedge_count / booster_count, 2) if booster_count else None,
        },
        "sentence_initial_counts": initial_counts,
        "punctuation": {
            "question_marks": raw.count("?"),
            "colons": raw.count(":"),
            "semicolons": raw.count(";"),
            "em_dashes": raw.count("—"),
            "en_dashes": raw.count("–"),
        },
    }


def document_graph(
    root: Path,
    display_paths: list[str],
    x_offset: int = 0,
    text_loader=None,
) -> tuple[list[dict], list[dict], list[dict]]:
    nodes: list[dict] = []
    edges: list[dict] = []
    sources: list[dict] = []
    for file_index, display_path in enumerate(display_paths):
        path = root / display_path
        text = text_loader(display_path) if text_loader else path.read_text(encoding="utf-8")
        doc_id = f"doc::{display_path}"
        blocks = parse_blocks_text(text, display_path)
        nodes.append(
            {
                "id": doc_id,
                "type": "document",
                "title": title_from_qmd(text, path.stem),
                "source": {"file": display_path, "lines": [1, len(text.splitlines())]},
                "layout": {"rank": file_index, "x": x_offset + file_index, "y": 0},
            }
        )
        sources.append({"file": display_path, "sha256": sha256_text(text), "lines": len(text.splitlines())})
        for block_index, block in enumerate(blocks):
            block["layout"]["x"] = x_offset + file_index
            block["layout"]["y"] = block_index + 1
            nodes.append(block)
            edges.append({"from": doc_id, "to": block["id"], "relation": "CONTAINS"})
            if block_index:
                edges.append({"from": blocks[block_index - 1]["id"], "to": block["id"], "relation": "NEXT"})
        if file_index:
            edges.append({"from": f"doc::{display_paths[file_index - 1]}", "to": doc_id, "relation": "NEXT_DOCUMENT"})
    return nodes, edges, sources


def slide_graph(path: Path, display_path: str, text: str | None = None) -> tuple[list[dict], list[dict]]:
    text = text if text is not None else path.read_text(encoding="utf-8")
    lines = text.splitlines()
    headings = [(i, line) for i, line in enumerate(lines) if re.match(r"^##\s+", line)]
    markers = [(i, m.group(1)) for i, line in enumerate(lines) if (m := re.match(r"^<!--\s*notes-page:\s*(.+?)\s*-->$", line))]
    nodes: list[dict] = []
    edges: list[dict] = []
    current_marker = None
    marker_index = 0
    for serial, (start_index, heading_line) in enumerate(headings):
        while marker_index < len(markers) and markers[marker_index][0] < start_index:
            current_marker = markers[marker_index][1]
            marker_index += 1
        end_index = headings[serial + 1][0] if serial + 1 < len(headings) else len(lines)
        raw = "\n".join(lines[start_index:end_index])
        title = re.sub(r"^##\s+|\s*\{.*\}\s*$", "", heading_line).strip()
        classes = re.findall(r"\.([\w-]+)", heading_line)
        visible = re.sub(r"::: \{\.notes\}.*?:::", " ", raw, flags=re.DOTALL)
        visible = re.sub(r"```.*?```", " ", visible, flags=re.DOTALL)
        visible = re.sub(r"\$\$.*?\$\$", " EQUATION ", visible, flags=re.DOTALL)
        visible = re.sub(r"\$[^$]+\$", " VARIABLE ", visible)
        visible = re.sub(r"\[([^]]+)\]\([^)]*\)", r"\1", visible)
        visible_words = len(re.findall(r"\b[\w’'-]+\b", visible))
        kind = "math" if "$$" in raw else "figure" if re.search(r"!\[[^]]*\]\(", raw) else "prose"
        slide_id = f"slide::{display_path}::{serial:04d}"
        nodes.append(
            {
                "id": slide_id,
                "type": "slide",
                "title": title,
                "source": {"file": display_path, "lines": [start_index + 1, end_index]},
                "notes_page": current_marker,
                "classes": classes,
                "visible_words": visible_words,
                "move": classify("heading", title) if kind == "prose" else classify(kind, raw),
                "modalities": {
                    "math": "$$" in raw,
                    "table": bool(re.search(r"(?m)^\|", raw)),
                    "figure": bool(re.search(r"!\[[^]]*\]\(", raw)),
                    "code": "```" in raw,
                },
                "layout": {"rank": serial, "x": 0, "y": serial},
            }
        )
        if serial:
            edges.append({"from": nodes[serial - 1]["id"], "to": slide_id, "relation": "NEXT"})
    return nodes, edges


def build_reference() -> dict:
    nodes, edges, sources = document_graph(REFERENCE_ROOT, REFERENCE_FILES)
    return {
        "schema_version": "1.0",
        "artifact": "reference_notes_style_and_pedagogy",
        "source_root": str(REFERENCE_ROOT),
        "source_files": sources,
        "style_profile": {
            "metrics": style_metrics([REFERENCE_ROOT / file for file in REFERENCE_FILES]),
            "document_metrics": {
                file: style_metrics([REFERENCE_ROOT / file]) for file in REFERENCE_FILES
            },
            "wording": [
                "I marks notational or instructional commitments; we marks shared reasoning; you marks learner action or a likely misconception.",
                "Definitions are named immediately with forms such as known as, referred to as, termed, and we call, then reused.",
                "Exact notation is paired with a plain-language gloss, often introduced by basically, more specifically, that is, or all this means.",
                "Claims use calibrated modals; mathematical necessities receive must or always, while modeling claims receive may, might, often, or for current purposes.",
                "Deictic wording such as this move, this fact, above, below, and now keeps the chain of reasoning explicit.",
            ],
            "sentence_structure": [
                "A longer formal sentence or display is usually followed by a short interpretation or consequence.",
                "Colons introduce definitions, formulas, lists, and consequences.",
                "Right-branching qualifications preserve the main clause and put scope conditions later.",
                "Displays and code are rhetorical nodes: prose announces the operation, the display performs it, and a short paragraph interprets it.",
            ],
            "paragraph_structure": [
                "Paragraphs are usually one to three sentences and perform one pedagogical move.",
                "The dominant unit is orientation, formula/code/plot, interpretation rather than a paper-style four-sentence paragraph.",
                "Examples precede generalization for difficult objects; definitions may precede examples when the object directly extends prior machinery.",
                "A final short paragraph lands the upshot and creates the dependency for the next object.",
            ],
            "source_evidence": [
                {"file": "index.qmd", "line": 14, "feature": "abstract_to_grounded", "excerpt": "That's very abstract, so let's consider a few examples relevant to this class"},
                {"file": "index.qmd", "line": 226, "feature": "name_and_reuse", "excerpt": "We call this extension the sigma-algebra generated by the family of sets"},
                {"file": "index.qmd", "line": 332, "feature": "explicit_transition", "excerpt": "Now let's turn to the measurement part"},
                {"file": "random-variables-and-probability-distributions.qmd", "line": 21, "feature": "formal_then_gloss", "excerpt": "That is, the pre-image of every event must itself be an event"},
                {"file": "random-variables-and-probability-distributions.qmd", "line": 1074, "feature": "short_upshot", "excerpt": "The moral is that the expected value is not guaranteed to exist"},
                {"file": "statistical-inference.qmd", "line": 512, "feature": "belief_update_gloss", "excerpt": "if I started out believing"},
                {"file": "statistical-inference.qmd", "line": 1090, "feature": "metacognitive_close", "excerpt": "We've covered a lot of ground"},
            ],
        },
        "pedagogical_motifs": MOTIFS,
        "macro_flow": [
            {
                "document": "index.qmd",
                "sequence": [
                    "possibility versus measurement",
                    "sample space",
                    "events and sigma-algebras",
                    "running pronoun representation",
                    "question-answer failure of naive union",
                    "generated sigma-algebra repair",
                    "probability measure",
                    "joint and conditional probability",
                    "Bayes rule",
                    "independence and misconception guard",
                ],
            },
            {
                "document": "random-variables-and-probability-distributions.qmd",
                "sequence": [
                    "measurable outcome-to-value mapping",
                    "discrete versus continuous variables",
                    "PMF and CDF notation contract",
                    "categorical and Bernoulli running example",
                    "finite to countably infinite support",
                    "geometric limitation and negative-binomial repair",
                    "continuous-density limitation",
                    "uniform to beta parameter sweep",
                    "normal family and linguistic application",
                    "joint, conditional, expectation, moments, covariance",
                ],
            },
            {
                "document": "statistical-inference.qmd",
                "sequence": [
                    "pronoun-case running example",
                    "likelihood and maximum likelihood",
                    "estimator sampling distribution",
                    "bias, error, and confidence procedures",
                    "posterior as prior-likelihood update",
                    "conjugacy and prediction",
                    "nonconjugacy as computational limit",
                    "Monte Carlo, importance sampling, and MCMC repairs",
                    "Metropolis-Hastings implementation",
                    "Stan transfer and posterior visualization",
                ],
            },
        ],
        "graph": {
            "directed": True,
            "node_types": ["document", "content_block"],
            "edge_types": ["CONTAINS", "NEXT", "NEXT_DOCUMENT"],
            "nodes": nodes,
            "edges": edges,
        },
    }


def build_course(text_loader=None, source_state: str = "working tree after revision") -> dict:
    graph_nodes: list[dict] = []
    graph_edges: list[dict] = []
    sources: list[dict] = []
    style_profiles: dict[str, dict] = {}
    for module_index, (module, config) in enumerate(MODULES.items()):
        module_id = f"module::{module}"
        graph_nodes.append(
            {
                "id": module_id,
                "type": "module",
                "title": module.replace("-", " ").title(),
                "layout": {"rank": module_index, "x": module_index * 3, "y": 0},
            }
        )
        note_nodes, note_edges, note_sources = document_graph(
            ROOT, config["notes"], module_index * 3, text_loader=text_loader
        )
        graph_nodes.extend(note_nodes)
        graph_edges.extend(note_edges)
        sources.extend(note_sources)
        for page_index, note in enumerate(config["notes"]):
            graph_edges.append({"from": module_id, "to": f"doc::{note}", "relation": "CONTAINS"})
            if page_index:
                graph_edges.append(
                    {"from": f"doc::{config['notes'][page_index - 1]}", "to": f"doc::{note}", "relation": "CANONICAL_NEXT_PAGE"}
                )
        deck_path = ROOT / config["deck"]
        deck_id = f"deck::{config['deck']}"
        deck_text = text_loader(config["deck"]) if text_loader else deck_path.read_text(encoding="utf-8")
        note_texts = [
            text_loader(note) if text_loader else (ROOT / note).read_text(encoding="utf-8")
            for note in config["notes"]
        ]
        style_profiles[module] = {
            "notes": style_metrics_text("\n\n".join(note_texts)),
            "deck": style_metrics_text(deck_text),
        }
        graph_nodes.append(
            {
                "id": deck_id,
                "type": "deck",
                "title": title_from_qmd(deck_text, module),
                "source": {"file": config["deck"], "lines": [1, len(deck_text.splitlines())]},
                "layout": {"rank": module_index, "x": module_index * 3 + 1, "y": 0},
            }
        )
        sources.append({"file": config["deck"], "sha256": sha256_text(deck_text), "lines": len(deck_text.splitlines())})
        slide_nodes, slide_edges = slide_graph(deck_path, config["deck"], text=deck_text)
        for slide in slide_nodes:
            slide["layout"]["x"] = module_index * 3 + 1
            slide["layout"]["y"] += 1
            graph_nodes.append(slide)
            graph_edges.append({"from": deck_id, "to": slide["id"], "relation": "CONTAINS"})
            if slide.get("notes_page"):
                graph_edges.append({"from": f"doc::{slide['notes_page']}", "to": slide["id"], "relation": "REALIZED_AS"})
        graph_edges.extend(slide_edges)
        graph_edges.append({"from": module_id, "to": deck_id, "relation": "HAS_DECK"})
    return {
        "schema_version": "1.0",
        "artifact": "course_modules_1_3_pedagogy_graph",
        "source_root": str(ROOT),
        "source_state": source_state,
        "canonical_order_source": "_quarto.yml sidebar",
        "source_files": sources,
        "style_profile": {
            "scope": "Prose metrics are reported separately for module notes and Reveal deck source.",
            "by_module": style_profiles,
        },
        "pedagogical_contract": {
            "page_flow": [
                "LINGUISTIC_PROBLEM",
                "NAME_OBJECT",
                "FORMAL_STATEMENT",
                "HAND_DERIVATION_OR_PLOT",
                "IMPLEMENTATION_OR_VISUAL_CHECK",
                "INTERPRETATION",
                "FAILURE_OR_OBJECTION",
                "CHECK",
                "UPSHOT_AND_NEXT_DEPENDENCY",
            ],
            "slide_rule": "One minimal slide realizes each nonempty note move, in the same order and with the same example, data, notation, and conclusion.",
        },
        "graph": {
            "directed": True,
            "node_types": ["module", "document", "content_block", "deck", "slide"],
            "edge_types": [
                "CONTAINS", "NEXT", "NEXT_DOCUMENT", "CANONICAL_NEXT_PAGE",
                "HAS_DECK", "REALIZED_AS",
            ],
            "nodes": graph_nodes,
            "edges": graph_edges,
        },
    }


def build_comparison(reference=None, before_course=None, after_course=None) -> dict:
    verification = {}
    for module, config in MODULES.items():
        deck_path = ROOT / config["deck"]
        deck_text = deck_path.read_text(encoding="utf-8")
        observed_markers = re.findall(
            r"(?m)^<!--\s*notes-page:\s*(.+?)\s*-->$", deck_text
        )
        slides, _ = slide_graph(deck_path, config["deck"])
        slides_by_page = Counter(
            slide["notes_page"] for slide in slides if slide.get("notes_page")
        )
        counts = [slides_by_page.get(page, 0) for page in config["notes"]]
        verification[module] = {
            "canonical_page_blocks": len(config["notes"]),
            "observed_page_markers": len(observed_markers),
            "marker_order_exact": observed_markers == config["notes"],
            "slides": len(slides),
            "slides_per_page": {
                "minimum": min(counts),
                "maximum": max(counts),
                "mean": round(mean(counts), 2),
            },
            "slides_over_70_visible_words": sum(
                slide["visible_words"] > 70 for slide in slides
            ),
            "unmapped_slides": sum(
                not slide.get("notes_page") for slide in slides
            ),
        }

    comparison_nodes = [
        {
            "id": "reference::tutorial_cycle",
            "type": "reference_pattern",
            "label": "motivation → definition → instantiation → computation/visualization → interpretation → limitation/check → next dependency",
        },
        {
            "id": "reference::notation_contract",
            "type": "reference_pattern",
            "label": "full definition → declared shorthand → full form when ambiguity returns",
        },
        {
            "id": "reference::limitation_repair",
            "type": "reference_pattern",
            "label": "limitation of the current object motivates the next object",
        },
    ]
    comparison_edges = []
    for module, stats in verification.items():
        module_id = f"course::{module}"
        comparison_nodes.append(
            {
                "id": module_id,
                "type": "course_realization",
                "label": module.replace("-", " ").title(),
                "page_blocks": stats["canonical_page_blocks"],
                "slides": stats["slides"],
            }
        )
        comparison_edges.extend(
            [
                {"from": "reference::tutorial_cycle", "to": module_id, "relation": "REALIZED_BY_PAGE_BLOCKS"},
                {"from": "reference::notation_contract", "to": module_id, "relation": "CONSTRAINS_NOTATION"},
                {"from": "reference::limitation_repair", "to": module_id, "relation": "CONSTRAINS_TRANSITIONS"},
            ]
        )

    style_comparison = {}
    if reference and before_course and after_course:
        def select(metrics: dict) -> dict:
            return {
                "words": metrics["words"],
                "sentences": metrics["sentences"],
                "sentence_words": metrics["sentence_words"],
                "sentences_per_paragraph": metrics["sentences_per_paragraph"],
                "stance": metrics["stance"],
                "sentence_initial_counts": metrics["sentence_initial_counts"],
            }

        style_comparison = {
            "reference_notes": select(reference["style_profile"]["metrics"]),
            "course_notes_by_module": {
                module: {
                    "before_revision": select(
                        before_course["style_profile"]["by_module"][module]["notes"]
                    ),
                    "after_revision": select(
                        after_course["style_profile"]["by_module"][module]["notes"]
                    ),
                }
                for module in MODULES
            },
            "interpretation": "Sentence metrics are diagnostics, not targets: formulas, lists, and page granularity make course prose shorter than the three long reference documents. The revision therefore prioritizes the reference move sequence and connective structure while preserving local mathematical clarity.",
        }

    return {
        "schema_version": "1.0",
        "artifact": "reference_to_course_alignment",
        "source_graphs": {
            "reference": "reference-notes-style-and-pedagogy.json",
            "course_before_revision": "course-modules-1-3-pedagogy-graph-before-revision.json",
            "course_after_revision": "course-modules-1-3-pedagogy-graph.json",
        },
        "comparison": {
            "preserve": [
                "One linguistic running example provides connective tissue across formal objects.",
                "Every new object enters through motivation, receives a full definition, and is instantiated before abstraction continues.",
                "Displays, calculations, code, and plots perform rhetorical work and receive an immediate interpretation.",
                "Limitations motivate the next distribution, inferential object, or computational method.",
                "Notation moves from full form to explicitly defined shorthand and returns to the full form when ambiguity is possible.",
            ],
            "course_mismatches_before_revision": [
                "The Module 1 deck inserted administration unrelated to the notes graph.",
                "The Module 1 deck introduced preimages before the random-variable module and substituted a different Bayes example.",
                "The Module 2 notes and deck used x-in-X and abbreviated event-set notation without a standard mathematical basis.",
                "The Module 2 deck retained topic order but compressed derivations, parameter sweeps, checks, and limitation-repair transitions.",
                "The Module 3 deck retained page order but compressed most worked derivations, implementations, checks, and diagnostic failures.",
            ],
            "style_metrics": style_comparison,
        },
        "minimal_transformation": [
            {"order": 1, "operation": "freeze", "target": "page order", "rule": "Use the sidebar order as the single canonical order and repair index roadmaps to match it."},
            {"order": 2, "operation": "delete", "target": "off-graph slides", "rule": "Remove administration, premature definitions, substituted examples, and other content that has no corresponding note page."},
            {"order": 3, "operation": "restore", "target": "missing rhetorical nodes", "rule": "Within each existing page block, restore every nonempty problem, definition, calculation/plot, interpretation, failure, check, and upshot from the note."},
            {"order": 4, "operation": "compress", "target": "slide prose", "rule": "Use the note's math, table, graph, linguistic example, or one short interpretive statement; do not replace a worked move with a synopsis."},
            {"order": 5, "operation": "normalize", "target": "notation", "rule": "Use full outcome-set builders for explicit events, declared codomains instead of x-in-X, defined shorthand only, and angle brackets for assembled structures."},
            {"order": 6, "operation": "verify", "target": "isomorphism", "rule": "Require notes-page markers in canonical order and compare note moves and defined terms with the corresponding slide block."},
        ],
        "graph_mapping": {
            "reference_CONCEPT_cycle": "course page block",
            "reference_NOTATION_CONTRACT": "course first-definition slide sequence",
            "reference_PARAMETER_SWEEP": "course adjacent plot/build sequence",
            "reference_LIMIT_REPAIR": "course page transition",
            "reference_MODULE_CLOSE": "course Module Summary",
        },
        "post_revision_verification": verification,
        "comparison_graph": {
            "directed": True,
            "node_types": ["reference_pattern", "course_realization"],
            "edge_types": [
                "REALIZED_BY_PAGE_BLOCKS",
                "CONSTRAINS_NOTATION",
                "CONSTRAINS_TRANSITIONS",
            ],
            "nodes": comparison_nodes,
            "edges": comparison_edges,
        },
    }


def write_json(name: str, payload: dict) -> None:
    OUTPUT_ROOT.mkdir(parents=True, exist_ok=True)
    (OUTPUT_ROOT / name).write_text(json.dumps(payload, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def main() -> int:
    reference = build_reference()
    after = build_course()
    write_json("reference-notes-style-and-pedagogy.json", reference)
    write_json("course-modules-1-3-pedagogy-graph.json", after)
    head_revision = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
    ).strip()

    def load_head(display_path: str) -> str:
        return subprocess.check_output(
            ["git", "show", f"HEAD:{display_path}"], cwd=ROOT, text=True
        )

    before = build_course(
        text_loader=load_head,
        source_state=f"git HEAD before revision ({head_revision})",
    )
    before["artifact"] = "course_modules_1_3_pedagogy_graph_before_revision"
    write_json("course-modules-1-3-pedagogy-graph-before-revision.json", before)
    write_json(
        "reference-course-alignment.json",
        build_comparison(reference=reference, before_course=before, after_course=after),
    )
    print("Wrote four pedagogy graph artifacts to pedagogy/.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
