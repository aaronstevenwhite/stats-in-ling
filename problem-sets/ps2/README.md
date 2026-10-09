# Problem Set 2: Bayesian hypothesis testing

**LING 214/414: Statistical Methods in Linguistics**

## Overview

Problem Set 2 is the Bayesian member of the matched PS1–PS2 sequence. It uses passage-level Provo reading-time contrasts for continuous inference and selected UD English EWT annotations for categorical inference. All six exercises are required for every student.

The assignment covers five analyses:

1. a Bayesian normal model for the population mean passage contrast, including a guided one-dimensional conditional normal–normal derivation
2. a robust Student t location model corresponding to the Wilcoxon analysis
3. a beta–Bernoulli model for the population probability of a positive passage contrast
4. separate scalar beta–binomial models for a two-by-two syntactic association
5. a scalar shared-probability model with posterior predictive Pearson discrepancies for a three-by-two table

[Problem Set 1](../ps1/README.md) targets the corresponding quantities with frequentist procedures and distinct linguistic data.

## Directory Structure

```text
ps2/
├── README.md
├── ps2.qmd
├── ps2-answer-key.qmd
├── data/
│   ├── provo-content-word-positions.csv
│   ├── ud_wh_dependencies_raw.csv
│   └── ud_wh_dependencies.csv
└── scripts/
    ├── prepare_data.R
    ├── fetch_wh_data.py
    └── prepare_ud_wh_tables.R
```

`ps2.qmd` is the student assignment. `ps2-answer-key.qmd` is the instructor key and is excluded from the public course site. The Provo teaching table and selected UD table are included with the assignment. The larger UD intermediate file is generated locally.

The downloadable public package contains `ps2.qmd`, this README, all three preparation scripts, and both redistributable teaching tables. It omits the instructor key and the larger UD intermediate file.

## Setup Instructions

### 1. Install Required Software

Data preparation and analysis require:

- Python 3.9 or newer with `pandas`
- R 4.0 or newer
- `brms`, `posterior`, `cmdstanr`, `dplyr`, `ggplot2`, and `tidyr`
- a working CmdStan installation

From the repository root, create the assignment-specific Python environment and install `pandas`:

```bash
python3 -m venv problem-sets/ps2/.venv
problem-sets/ps2/.venv/bin/python -m pip install pandas
```

Install the R packages once, then use the [`cmdstanr` installation procedure](https://mc-stan.org/cmdstanr/articles/cmdstanr.html) to install CmdStan:

```r
install.packages(c("brms", "posterior", "dplyr", "ggplot2", "tidyr"))
install.packages(
  "cmdstanr",
  repos = c("https://stan-dev.r-universe.dev", getOption("repos"))
)
cmdstanr::check_cmdstan_toolchain()
cmdstanr::install_cmdstan(cores = 2)
```

### 2. Generate Datasets

Download `Provo_Corpus-Eyetracking_Data.csv` from the [Provo Corpus OSF project](https://osf.io/sjefs/). Then run every command below from the repository root. Replace `/path/to` with the location of the downloaded file.

```bash
Rscript problem-sets/ps2/scripts/prepare_data.R \
  /path/to/Provo_Corpus-Eyetracking_Data.csv \
  problem-sets/ps2/data/provo-content-word-positions.csv

problem-sets/ps2/.venv/bin/python \
  problem-sets/ps2/scripts/fetch_wh_data.py

Rscript problem-sets/ps2/scripts/prepare_ud_wh_tables.R
```

The Python script downloads the pinned UD English EWT training file and writes the raw WH-token dependency table. The second R script selects `what`, `which`, and `who` tokens annotated as `nsubj` or `obj`, retains sentences with exactly one selected dependency, and writes the teaching table.

### 3. Render the Assignment

```bash
quarto render problem-sets/ps2/ps2.qmd
```

The rendered student assignment is written to `docs/problem-sets/ps2/ps2.html`.

## Datasets

### 1. Provo content-word positions (`provo-content-word-positions.csv`)

**Source:** Luke and Christianson (2018), [“The Provo Corpus”](https://doi.org/10.3758/s13428-017-0908-4). The original release is available from the [Provo Corpus OSF project](https://osf.io/sjefs/).

**Description:** The table contains 1,593 complete content-word positions from 55 passages. It averages log first-fixation duration over readers with an observed positive first fixation at each position. Every passage contains at least four noun positions and four verb positions.

**Use:** Bayesian inference for the passage-level noun minus verb contrast and its sign.

**Columns:**

- `position_id`: passage-by-position identifier
- `Word_Unique_ID`, `Text_ID`, `Word_Number`: source word and passage identifiers
- `Word_Length`, `Word_POS`, `Word_In_Sentence_Number`: lexical and positional variables
- `OrthoMatchModel`, `POSMatchModel`, `LSA_Response_Match_Score`: source predictability measures
- `mean_log_ffd`: mean log first-fixation duration over contributing readers
- `n_fixations`: number of positive first fixations contributing to that mean

The expected SHA-256 checksum is `458a5233347c5e5e1b80e9d73a14b448d90bbd7031bd80b295b096d74f50e914`.

### 2. UD English EWT dependencies (`ud_wh_dependencies.csv`)

**Source:** [Universal Dependencies English EWT](https://github.com/UniversalDependencies/UD_English-EWT) at commit `4a4d77f599ea53cc405f85d0cec4b2f14f81d42b`.

**Description:** The table contains 671 sentences from the training split. Each retained sentence contains exactly one selected `what`, `which`, or `who` token annotated as `nsubj` or `obj`. The recorded relation is the UD dependency relation of the WH token. The script does not treat the token's syntactic head as a filler gap.

**Use:** Scalar beta–binomial association models and a posterior predictive check of a shared-probability independence model.

**Columns:**

- `sentence_id`: source-order sentence identifier
- `sentence_text`: source sentence retained for annotation interpretation
- `wh_word`, `wh_lemma`, `wh_pos`: WH-token form, lemma, and part of speech
- `deprel`: selected UD dependency relation

The expected SHA-256 checksum is `ec0d1028c7572971db0ed1c6d6eb2319f19ee1b2aebf6865f707418017c0a7eb`.

The Provo teaching table is an adaptation distributed under the source project's [CC BY 4.0 license](https://creativecommons.org/licenses/by/4.0/). The UD table is an adaptation distributed under the source repository's [CC BY-SA 4.0 license](https://github.com/UniversalDependencies/UD_English-EWT/blob/master/LICENSE.txt).

## Problem Set Structure

| Tasks | Points | Statistical work |
|---|---:|---|
| 1 | 10 | construct and summarize paired passage differences |
| 2 | 25 | derive a conditional normal–normal posterior and fit the normal location model |
| 3 | 10 | fit the robust Student t location model |
| 4 | 10 | derive and apply the beta–Bernoulli update |
| 5 | 20 | estimate two-row associations for two word-form comparisons and examine sample-size behavior |
| 6 | 25 | conduct a posterior predictive check of categorical independence |

The task points sum to 100. The assignment-level grade follows the course policy below.

## Grading

- **50% Functionality and completeness:** the code runs and every requested derivation, calculation, plot, and interpretation is present.
- **50% In-class presentation:** every student must be prepared to explain any part of the submitted analysis.

Students may use LLMs for coding assistance, but they must understand and be able to explain the submitted code and reasoning.

## Submission

Submit the completed notebook through the course learning-management system. All six exercises are required. The course schedule supplies the due date.
