# UCCA French--English 20K v2 teaching extract

`passage-counts.csv` is a graph-aware extract from version 2 of the aligned
French--English UCCA corpus for the first five chapters of *Twenty Thousand
Leagues Under the Sea*. The independent observational unit for a paired
analysis is an aligned passage pair. There are 154 pairs, typically
corresponding to paragraphs.

Sulem, Abend, and Rappoport (2015) constructed the corpus to ask whether UCCA
structures are preserved across translations. The two sides were annotated
separately by the same bilingual annotator. The paper's release contained 583
sentences per language and reported mean Scene counts of 9.49 in English and
9.25 in French. The reviewed v2 repositories contain 154 passage graphs per
language but are not numerically identical to that release.

The teaching extract uses a **distinct Scene unit** as its counting rule. A
Scene is a foundational node with an outgoing Process (`P`) or State (`S`)
edge. Remote edges point to already existing nodes, so a remote reference never
creates another Scene. The extract retains counts of primary edges, remote
edges, implicit nodes, and discontinuous nodes rather than flattening each graph
to dependency columns.

The graph extraction yields 1,839 English Scenes and 2,121 French Scenes. The
mean absolute difference across aligned pairs is `320 / 154 = 2.078` Scenes.
With seed `20261018`, 9,999 random re-pairings have a mean absolute difference
of 8.503 Scenes on average; none is as small as the aligned value, so the
descriptive lower-tail fraction with a plus-one correction is `0.0001`. This is
a reference distribution, not a randomization-test null distribution, because
the translations were not randomly assigned.

## Release reconciliation

Two version-specific facts must remain visible in the notes.

1. The v2 XML filenames are internal annotation IDs, not bilingual-pair order.
   The preparation script reconstructs source order from the passage ranges in
   the official READMEs and the repositories' rename history. Sorting filenames
   produces a false pairing and must not be used.
2. The v2 READMEs report 12,574 English and 12,954 French tokens, the counts
   also reported for v1.2.2 in the SemEval 2019 paper. Direct graph inspection
   at the pinned v2 commits yields 12,638 and 13,021 Layer-0 terminals,
   respectively, including punctuation. It yields 10,812 and 11,037 non-
   punctuation word nodes. The paper's 583 sentences and the v2 README's 492
   sentences reflect different release histories. Course prose should report
   the direct v2 graph counts and name the release.

The reviewed v2 Scene means are 11.94 in English and 13.77 in French; the
count-overlap F-score is 0.919. These values do not reproduce the paper's 2015
numbers, likely because the annotations were reviewed under later guidelines.
The safe classroom analysis applies the paper's paired estimand to v2 rather
than presenting v2 as the paper's original data.

## Rebuild and validate

The preparation uses the official `ucca` Python API at a pinned commit. It
requires Python with NumPy and spaCy available. The script downloads and
checksums the two corpus archives and the toolkit archive when local source
directories are not supplied.

```sh
python3 scripts/data-grounding/prepare_ucca_french_english.py
Rscript scripts/data-grounding/validate_ucca_jacy.R
```

To use already cloned sources:

```sh
python3 scripts/data-grounding/prepare_ucca_french_english.py \
  --english-source-directory /path/to/UCCA_English-20K \
  --french-source-directory /path/to/UCCA_French-20K \
  --toolkit-directory /path/to/ucca
```

## Sources

- Sulem, Abend, and Rappoport (2015), [Conceptual Annotations Preserve
  Structure Across Translations: A French-English Case
  Study](https://aclanthology.org/W15-3502/).
- Abend and Rappoport (2013), [Universal Conceptual Cognitive Annotation
  (UCCA)](https://aclanthology.org/P13-1023/).
- Abend et al. (2020), [UCCA's Foundational Layer: Annotation Guidelines
  v2.1](https://arxiv.org/abs/2012.15810).
- [English v2 release](https://github.com/UniversalConceptualCognitiveAnnotation/UCCA_English-20K)
  and [French v2 release](https://github.com/UniversalConceptualCognitiveAnnotation/UCCA_French-20K).
- [Official UCCA project and corpus index](https://universalconceptualcognitiveannotation.github.io/).

The official corpus index licenses public UCCA corpora under CC BY-SA 3.0
Unported. The pinned repository READMEs request citation of Sulem et al. (2015).

