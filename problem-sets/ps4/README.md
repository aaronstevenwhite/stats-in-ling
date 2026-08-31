# Problem Set 4: Commitment in naturally occurring discourse

This directory contains the Fall 2026 CommitmentBank problem set. The assignment develops one multilevel cumulative logit model and uses prior prediction, sampling diagnostics, posterior prediction, posterior predictive checking, and discourse grouped validation to evaluate it.

## Current assignment files

- `ps4.qmd`: student handout and course reading
- `ps4-answer-key.qmd`: executable instructor key
- `scripts/prepare-commitmentbank.R`: retrieves the official release, verifies its checksum, and creates a text free analysis table
- `data/commitmentbank-grouped-cv.csv`: anonymous discourse level results from the frozen grouped validation pilot
- `data/README.md`: provenance and redistribution constraints

The course website renders `ps4.qmd`. It does not render the older notebook.

## Prepare the data

From the course repository root, run:

```sh
Rscript problem-sets/ps4/scripts/prepare-commitmentbank.R
```

The script downloads the official CommitmentBank CSV and writes `data/commitmentbank-model.csv`. The analysis table excludes the source passage and prompt text. Those files remain local because the repository and source corpora do not state redistribution terms that would permit packaging the passages with the assignment.

The student handout uses the prepared table for descriptive work and model fitting. It uses the supplied grouped result table for the five fold new discourse comparison so that students can analyze prediction for an omitted discourse without fitting ten additional multilevel models.

## R packages

The answer key uses:

```r
install.packages(c(
  "brms",
  "rstan",
  "posterior",
  "loo",
  "ggplot2"
))
```

The fitted models use four chains, 1,000 warmup iterations per chain, and 1,000 retained iterations per chain. A complete clean run may take substantial time because the data contain 9,599 ratings and three grouping distributions.

## Scientific validation

The frozen validation records are in `research/homework-validation/ps4/` at the repository root. The approved comparison holds out complete discourses. The environment model improves grouped expected log predictive density by 97.99, with discourse level standard error 14.10. The ratio is 6.95. All final fold fits have zero divergent transitions, and the largest final fold R-hat is 1.018.

The earlier row level validation and the first grouped sampling run remain documented as failed gates. Their criteria were not weakened after the results were seen.

## Archived Fall 2025 materials

`ps4.ipynb`, `mald_items.csv`, and the Stan files in `models/` belong to the Fall 2025 MALD assignment. They remain in the directory to preserve the earlier course materials, but they are not part of the Fall 2026 problem set and are not rendered on the course website.
