# Problem Set 1: Frequentist hypothesis testing

**LING 214/414: Statistical Methods in Linguistics**

## Overview

Problem Set 1 is the frequentist member of the matched PS1–PS2 sequence. It uses paired Hillenbrand F1 measurements for continuous inference and German UniMorph lexeme tables for categorical inference. All six exercises are required for every student.

Students complete `ps1.ipynb`. Open the notebook from the extracted assignment directory and use the R kernel so that its relative paths resolve to the included `data` and `scripts` directories.

The assignment covers five procedures:

1. a paired t procedure for the population mean F1 difference
2. a Wilcoxon signed-rank procedure for the location of the paired F1 differences
3. an exact binomial sign procedure for the population probability that the F1 difference has the predicted direction
4. Fisher's exact test for syllable class and stem-final sibilance by genitive *-es* attestation, followed by a repeated-sampling analysis of small lexeme samples
5. a chi-squared test for grammatical gender by plural-suffix class

[Problem Set 2](../ps2/README.md) follows the same inferential sequence with distinct linguistic data and Bayesian analyses.

## Directory Structure

```text
ps1/
├── README.md
├── ps1.ipynb
├── ps1.qmd
├── ps1-answer-key.qmd
├── data/
│   ├── hillenbrand_vowels.csv
│   ├── unimorph_genitive.csv
│   ├── unimorph_plural.csv
│   ├── unimorph_genitive_lexemes.csv
│   ├── unimorph_genitive_lexeme_population.csv
│   └── unimorph_plural_lexemes.csv
└── scripts/
    ├── prepare_data.R
    ├── fetch_unimorph_data.py
    └── prepare_unimorph_tables.R
```

`ps1.ipynb` is the student working file. It is generated from `ps1.qmd`, which supplies the course-site version. `ps1-answer-key.qmd` is the instructor key and is excluded from the public course site. The two unsummarized UniMorph files and the Hillenbrand CSV are generated locally. The three lexeme-level UniMorph tables are included with the assignment.

The downloadable public package contains `ps1.ipynb`, `ps1.qmd`, this README, all three preparation scripts, and the three redistributable UniMorph teaching tables. It omits the instructor key, the locally generated Hillenbrand table, and the two form-level UniMorph intermediate files.

## Setup Instructions

### 1. Install Required Software

Running the notebook requires:

- Jupyter Notebook or JupyterLab
- R 4.0 or newer
- the `IRkernel` R package and a registered R kernel
- `phonTools` version 0.2.2.2 for the audited Hillenbrand extraction
- `dplyr`, `ggplot2`, and `tidyr` for the assignment analysis

Install the required R packages and register the kernel once:

```r
install.packages(c("IRkernel", "phonTools", "dplyr", "ggplot2", "tidyr"))
IRkernel::installspec()
```

### 2. Generate Datasets

Extract `ps1-assignment.zip`, open a terminal in the extracted `ps1-assignment` directory, and generate the Hillenbrand table. The first notebook cell runs the same preparation function when this table is absent, but running the script directly makes the required file explicit.

```bash
Rscript scripts/prepare_data.R data/hillenbrand_vowels.csv
```

The three lexeme-level UniMorph tables are already included. Rebuilding them from the pinned source additionally requires Python 3.9 or newer with `pandas`:

```bash
python3 -m venv .venv
.venv/bin/python -m pip install pandas

.venv/bin/python scripts/fetch_unimorph_data.py

Rscript scripts/prepare_unimorph_tables.R
```

The Python script downloads the pinned German UniMorph source and writes the two form-level intermediate files. The second R script checks those files, reduces them to one row per lexeme, and draws the fixed 120-lexeme teaching sample.

### 3. Open the Notebook

```bash
jupyter notebook ps1.ipynb
```

Select the R kernel if Jupyter does not select it automatically. Keep the notebook in the extracted assignment directory while working so that paths beginning with `data/` and `scripts/` continue to resolve.

## Datasets

### 1. Hillenbrand vowel acoustics (`hillenbrand_vowels.csv`)

**Source:** Hillenbrand, Getty, Clark, and Wheeler (1995), [“Acoustic characteristics of American English vowels”](https://doi.org/10.1121/1.411872), via `phonTools::h95`.

**Description:** The complete teaching table contains 1,668 vowel measurements from 139 speakers. The assignment restricts the focal comparison to the 45 adult men with one /i/ and one /ɪ/ measurement each.

**Use:** Vowel-space visualization, paired t inference, Wilcoxon signed-rank inference, and exact sign inference.

**Columns:**

- `speaker_id`: speaker identifier
- `speaker_type`: boy, girl, man, or woman
- `vowel`: X-SAMPA vowel category
- `duration_ms`: vowel duration in milliseconds
- `f0_hz`, `f1_hz`, `f2_hz`, `f3_hz`: frequency measurements in hertz

The expected SHA-256 checksum is `de3450982779fe3ac2e914974eb0ba6a7e0f778d7328f6dbb5d5ab5a58af22c9`.

### 2. German UniMorph genitives

**Source:** The [German UniMorph repository](https://github.com/unimorph/deu) at commit `d226d2112d3490d8f04ece10d4538123d4297a39`.

**Description:** `unimorph_genitive_lexeme_population.csv` contains 16,719 masculine or neuter lexemes with derived stem-final sibilance and genitive-suffix attestation variables. `unimorph_genitive_lexemes.csv` is the fixed 120-lexeme teaching sample. The string-based variables are derived by the preparation scripts rather than supplied as UniMorph annotations.

**Use:** Fisher's exact test and empirical sampling distributions across small random lexeme samples.

**Columns:**

- `lemma`: lexeme identifier
- `gender`: masculine or neuter UniMorph gender value
- `syllable_count`: orthographic vowel-group count
- `syllable_class`: monosyllabic or polysyllabic classification
- `ends_in_sibilant`: whether the lemma ends in the script's fixed sibilant string set
- `es_attested`, `s_attested`: whether an extracted genitive form with the suffix is present

The expected checksums are `176d6c8cbedeadb741ffaedaf1a5df3f91a0a996a6a2238960a39a0a115332cb` for the teaching sample and `98127c132956403e7b16447127a5049f656cd0c0f1efc9384919b6a312959239` for the population table.

### 3. German UniMorph plurals (`unimorph_plural_lexemes.csv`)

**Source:** The same pinned German UniMorph release.

**Description:** The table contains 13,297 noun lexemes with one retained plural form per lemma and a derived suffix class.

**Use:** Chi-squared inference for grammatical gender by plural-suffix class.

**Columns:**

- `lemma`: lexeme identifier
- `gender`: feminine, masculine, or neuter UniMorph gender value
- `singular_form`, `plural_form`: retained surface forms
- `plural_suffix`: `e`, `en`, `er`, `s`, or `ø`
- `syllable_count`: orthographic vowel-group count

The expected SHA-256 checksum is `f21c1292f2241269cc4cdd3563dd7cb6efe52ccee9c1edd9bdad4e310532ec61`.

The derived UniMorph tables are distributed under the source repository's [CC BY-SA 3.0 license](https://creativecommons.org/licenses/by-sa/3.0/). The generated Hillenbrand CSV is excluded from the course release because the package documentation does not provide a separate redistribution statement for that table.

## Problem Set Structure

| Tasks | Points | Statistical work |
|---|---:|---|
| 1 | 10 | visualize the vowel space, then construct and summarize paired differences |
| 2 | 20 | derive and apply the paired t statistic, then analyze a second vowel pair |
| 3 | 10 | construct and apply the Wilcoxon signed-rank statistic |
| 4 | 10 | derive and apply the exact sign procedure |
| 5 | 25 | analyze syllable and sibilant associations, derive Fisher's exact test, and estimate small-lexicon sampling distributions |
| 6 | 25 | derive and apply the chi-squared test of independence |

The task points sum to 100. The assignment-level grade follows the course policy below.

## Grading

- **50% Functionality and completeness:** the code runs and every requested calculation, plot, and interpretation is present.
- **50% In-class presentation:** every student must be prepared to explain any part of the submitted analysis.

Students may use LLMs for coding assistance, but they must understand and be able to explain the submitted code and reasoning.

## Submission

Submit the completed notebook through the course learning-management system. All six exercises are required. The course schedule supplies the due date.
