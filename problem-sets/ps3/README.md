# Problem Set 3

The Fall 2026 course uses the dative-alternation assignment in `ps3-dative-alternation.qmd`.

- `ps3-dative-alternation.qmd` is the released student assignment.
- `ps3-answer-key.qmd` is the aligned instructor key.
- `data/dative-alternation.csv` is an adapted, text-free table from `languageR` 1.5.0.
- `scripts/prepare_data.R` reconstructs the table from the frozen CRAN source archive.
- `scripts/validate_dative_release.R` checks the frozen data dimensions, coefficient signs, profile predictions, and omitted-verb outcomes.

The MALD files `ps3.ipynb` and `ps3_answer_key.ipynb` are legacy Fall 2025 materials. They are retained as read-only audit evidence and are not the Fall 2026 assignment.

From the repository root, prepare the data with:

```bash
Rscript problem-sets/ps3/scripts/prepare_data.R \
  /path/to/languageR_1.5.0.tar.gz \
  problem-sets/ps3/data/dative-alternation.csv
```

The archive is available from the [CRAN archive](https://cran.r-project.org/src/contrib/Archive/languageR/languageR_1.5.0.tar.gz). Its audited SHA-256 checksum is `d629739bbfd8846ac4db62310a99eda59a22cb0170e58bc2e1a241b244b637c6`.

From the repository root, validate the released analysis with:

```bash
Rscript problem-sets/ps3/scripts/validate_dative_release.R
```

The frozen specification and release decision live in `research/homework-validation/ps3/`.
