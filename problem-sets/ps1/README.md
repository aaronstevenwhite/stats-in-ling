# Problem Set 1: paired acoustic measurements

This directory contains the rebuilt PS1.

- `ps1.qmd` is the student assignment.
- `ps1-answer-key.qmd` is the instructor key and is not part of the public site.
- `scripts/prepare_data.R` extracts the audited `phonTools::h95` release and runs schema checks.

The generated CSV is intentionally excluded from the course release. Students create it locally so that the course does not republish a data table whose original page lacks a standalone redistribution statement.

Generate the local data file from the repository root with:

```bash
Rscript problem-sets/ps1/scripts/prepare_data.R problem-sets/ps1/data/hillenbrand_vowels.csv
```

The expected SHA-256 checksum is `de3450982779fe3ac2e914974eb0ba6a7e0f778d7328f6dbb5d5ab5a58af22c9`.

The empirical specification and acceptance test live in `research/homework-validation/ps1/`.
