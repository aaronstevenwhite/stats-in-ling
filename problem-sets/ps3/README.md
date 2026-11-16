# Problem Set 3: Regression models

**LING 214/414: Statistical Methods in Linguistics**

## Overview

Complete all six exercises in `ps3.ipynb`. Exercises 1–4 fit linear regressions to MALD word summaries and compare predictions with constant and frequency dependent residual variance. Exercises 5–6 fit Bayesian logistic regressions to dative choices using Stan through `brms` and `cmdstanr`, as in Problem Set 2. Check predictions by verb and predictor combination, compare fits with verb and speaker intercepts, and evaluate predictions for excluded verbs.

Open the notebook from the extracted `ps3-assignment` directory and select the R kernel. Both data tables are included.

## Directory structure

```text
ps3-assignment/
├── README.md
├── ps3.ipynb
├── ps3-dative-alternation.qmd
├── data/
│   ├── mald-items.csv
│   ├── mald-provenance.json
│   └── dative-alternation.csv
└── scripts/
    └── prepare_data.R
```

The historical filename `ps3-dative-alternation.qmd` preserves the course page's existing URL. It now contains the complete combined assignment and generates `ps3.ipynb`. `ps3-answer-key.qmd` and `ps3-answer-key.ipynb` are private instructor files and are excluded from the student package and course site. Rebuild the notebooks and complete key with `python3 scripts/rebuild_ps3_answer_key.py` from the repository root.

The previous MALD student notebook and key are preserved in `research/homework-validation/ps3/legacy/`. The old `ps3_answer_key.ipynb` and `ps3.zip` are historical materials; use the hyphenated current key and `downloads/ps3-assignment.zip`.

## Setup

Use R 4.1 or newer, Jupyter Notebook or JupyterLab, a registered R kernel, and the working CmdStan toolchain used in Problem Set 2. Install the packages once:

```r
install.packages(c("IRkernel", "dplyr", "ggplot2", "tidyr", "nlme", "brms", "posterior"))
IRkernel::installspec()
install.packages(
  "cmdstanr",
  repos = c("https://stan-dev.r-universe.dev", getOption("repos"))
)
cmdstanr::check_cmdstan_toolchain()
cmdstanr::install_cmdstan(cores = 2)
```

The [`cmdstanr` installation guide](https://mc-stan.org/cmdstanr/articles/cmdstanr.html) supplies platform specific compiler setup. If CmdStan already works for Problem Set 2, reuse that installation.

Then open the notebook:

```bash
jupyter notebook ps3.ipynb
```

Keep the notebook in the extracted assignment directory so that paths beginning with `data/` resolve.

## Datasets

### MALD word summaries

**Source:** Tucker, Brenner, Danielson, Kelley, Nenadić, and Sims (2019), [“The Massive Auditory Lexical Decision (MALD) database”](https://doi.org/10.3758/s13428-018-1056-1), *Behavior Research Methods* 51, 1187–1204. The teaching data use the expanded [MALD 1.1 release](https://nascl.rc.nau.edu/resources/massive-auditory-lexical-decision/), with 440 listeners.

**Unit:** one word, with at least five correct responses retained after applying `200 < RT < 3000` ms and positive SUBTLEX frequency. There are 23,756 rows. RT is measured from stimulus onset.

**Analysis columns:**

- `item`: word identifier
- `n_observations`: retained correct trial count
- `mean_log_rt`: mean of log RT in milliseconds over retained trials
- `sd_log_rt`, `variance_log_rt`: within word trial SD and variance on the log scale
- `log_frequency_subtlex`, `log_duration`, `n_phones`: predictors

The variance model concerns **word means around the regression**. The stored trial variances describe variation within words. Trial counts, omitted word properties, and shared listeners may contribute to residual variation among word means. Listener identities are unavailable, so changing the variance equation or resampling word rows leaves shared listener dependence unaccounted for. Explain this limitation when reporting confidence intervals and likelihood ratio results.

The table is copied without alteration from the course's audited `data/mald/mald-items.csv`. Its SHA-256 checksum is `96ce8002488a7e520851e15641edf70539a469e35e1511a32563a925b7e03a01`. The accompanying provenance file records source checksums, filters, and CC BY-NC 4.0 attribution. It also documents a separate connected trial table, which is not used or included in this assignment.

To rebuild the audited table from the original release, run the existing course preparation script from the repository root:

```bash
Rscript scripts/data-grounding/prepare_mald.R \
  /path/to/MALD1_1_AllData.txt data/mald
cp data/mald/mald-items.csv problem-sets/ps3/data/mald-items.csv
```

### English dative tokens

**Source:** Bresnan, Cueni, Nikitina, and Baayen (2007), [“Predicting the Dative Alternation”](https://web.stanford.edu/~bresnan/qs-submit.pdf), in *Cognitive Foundations of Interpretation*, pages 69–94; the adapted table is from `languageR` 1.5.0. The package's [documentation](https://search.r-project.org/CRAN/refmans/languageR/html/dative.html) describes the annotations.

**Unit:** one annotated dative token from spoken Switchboard or the written Wall Street Journal Treebank. The table contains 3,263 tokens, 75 verb types, and 849 PP responses. Sentence text is omitted.

**Analysis columns:** recipient realization, argument lengths, accessibility, pronominality, recipient animacy, modality, semantic class, and verb. The response is `pp = 1` for a PP recipient and zero for an NP recipient. Fit Bernoulli models with a logit link, using independent zero centered normal priors for the internally centered intercept (SD 2.5) and slopes (SD 1.5). The baseline and alignment fits use four chains with 1,000 warmup and 1,000 retained iterations each. Summarize the posterior coefficients and check predictions by verb and modality by pronominality cell.

Three additional fits assess verb and speaker dependence. Compare the full alignment model with a model adding verb intercepts, then compare spoken only fits with and without crossed verb and speaker intercepts. Speaker IDs are available for the 2,360 spoken tokens, covering 38 verbs and 424 speakers. The 903 written tokens have no speaker IDs and are excluded from the speaker comparison. Group specific slopes, discourse structure, and corpus sampling remain limitations. The observed verb check uses fitted verb intercepts; excluded verb evaluation uses the original baseline and alignment models.

The source package declares GPL (>= 2). The adapted CSV's SHA-256 checksum is `02a49e0ef2da7df73a7ef622ddf31a55ba13c52a9b66bcfdf2fef3def7932bea`. `scripts/prepare_data.R` reconstructs the CSV from the [frozen CRAN archive](https://cran.r-project.org/src/contrib/Archive/languageR/languageR_1.5.0.tar.gz), whose SHA-256 checksum is `d629739bbfd8846ac4db62310a99eda59a22cb0170e58bc2e1a241b244b637c6`:

```bash
Rscript scripts/prepare_data.R /path/to/languageR_1.5.0.tar.gz data/dative-alternation.csv
```

## Problem set structure

| Exercise | Points | Statistical work |
|---|---:|---|
| 1 | 10 | define the response, inspect word summaries, and center predictors |
| 2 | 20 | derive the frequency coefficient t test, calculate its standard error and p value, and interpret the slopes |
| 3 | 25 | measure residual variance, derive its frequency equation and Gaussian likelihood, and derive and apply a likelihood ratio test |
| 4 | 15 | implement five fold evaluation of predicted means and predictive distributions |
| 5 | 20 | derive the log posterior, fit Stan models, check conditional predictions, and assess dependence with matched sensitivity fits |
| 6 | 10 | summarize posterior probability contrasts, count data support, and refit Stan models with verbs omitted |

The points sum to 100. Fit MALD models by least squares and Gaussian maximum likelihood, and dative models by posterior sampling in Stan. Report confidence intervals for MALD coefficients and credible intervals for dative coefficients under their stated assumptions. Evaluate cross-validation scores descriptively because the training sets overlap.

Dative validation requires 150 exact Stan refits. Each refit uses training tokens only, retains the same priors and sampler settings, and passes the full sampling checks. Predictions average posterior probabilities with `posterior_epred()`. Three additional sensitivity fits assess grouping assumptions. The two grouped fits use 4,000 iterations per chain, including 2,000 warmup iterations, and check population coefficients, group SDs, and fitted group intercepts. The spoken additive fit uses the original chain settings. The `stan_cache/` directory stores reusable compiled programs and model files. It is created locally and excluded from the student package; allow the first run to finish before rerunning cells that use the fits.

## Instructor validation

From the repository root:

```bash
python3 scripts/rebuild_ps3_answer_key.py
Rscript problem-sets/ps3/scripts/validate_ps3_release.R
bash scripts/build-problem-set-packages.sh ps3
```

The validator checks the regression t statistic and log tail probability, reconstructs the Gaussian variance likelihood, and checks the likelihood ratio parameter counts. It executes every answer key code block and writes `research/homework-validation/ps3/stan-validation-summary.json`. It checks the MALD scale estimate and predictive losses, dative coefficient intervals, conditional predictive checks, grouping comparisons, profile matches, and excluded verb scores. It also checks sampling diagnostics for every Stan fit. In the full corpus comparison, the new recipient interval includes zero after adding verb intercepts. The earlier dative only validator concerns the previous maximum likelihood assignment.

## Grading

- **50% Functionality and completeness:** the code runs and every requested derivation, calculation, plot, and interpretation is present.
- **50% In class presentation:** every student must be prepared to explain any part of the submitted analysis.

Students may use LLMs for coding assistance, but they must understand and be able to explain the submitted code and reasoning.

## Submission

Submit the completed notebook through the course learning management system. All six exercises are required. The course schedule supplies the due date.
