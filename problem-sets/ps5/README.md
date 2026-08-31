# Problem Set 5: Low rank structure in phoneme inventories

This directory contains the Fall 2026 PS5 release.

* `ps5.qmd`: student assignment
* `ps5-answer-key.qmd`: instructor answer key, excluded from the public site
* `scripts/prepare-phoible.R`: pinned PHOIBLE 2.0 retrieval and preparation
* `scripts/phoible-svd-functions.R`: audited matrix, masking, SVD, and scoring functions
* `data/README-PHOIBLE.md`: data provenance and generation instructions

Generate the local data object from the repository root:

```bash
Rscript problem-sets/ps5/scripts/prepare-phoible.R
```

The assignment was frozen and piloted before release. Its specification, data card, analysis, outputs, and decision are in `research/homework-validation/ps5/`.

## Legacy materials

The Malayalam survey notebooks, data, tests, submissions, and grading records remain in this directory as archival Fall 2025 materials. They are not part of the Fall 2026 public assignment and must not be added to the Quarto render list.
