# Problem Set 3: Regression models

**LING 214/414: Statistical Methods in Linguistics**

## Overview

Complete all six exercises in `ps3.ipynb`. Exercises 1–4 fit linear regressions to MALD word summaries and compare predictions with constant and frequency dependent residual variance. Exercises 5–6 fit Bayesian logistic regressions to dative choices using Stan through `brms` and `cmdstanr`, as in Problem Set 2. Check predictions by verb and predictor combination, inspect repeated speakers and verbs, and evaluate predictions for excluded verbs.

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

Complete the notebook. The Quarto file contains the same assignment in the format used for the course website. Keep the notebook, data, and scripts together in the extracted directory.

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

The [`cmdstanr` installation guide](https://mc-stan.org/cmdstanr/articles/cmdstanr.html) explains compiler setup for each operating system. If CmdStan already works for Problem Set 2, reuse that installation.

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

The included table's SHA-256 checksum is `96ce8002488a7e520851e15641edf70539a469e35e1511a32563a925b7e03a01`. The accompanying provenance file records the source checksum, filters, and CC BY-NC 4.0 attribution. No MALD download or preparation is required for this assignment.

### English dative tokens

**Source:** Bresnan, Cueni, Nikitina, and Baayen (2007), [“Predicting the Dative Alternation”](https://web.stanford.edu/~bresnan/qs-submit.pdf), in *Cognitive Foundations of Interpretation*, pages 69–94; the adapted table is from `languageR` 1.5.0. The package's [documentation](https://search.r-project.org/CRAN/refmans/languageR/html/dative.html) describes the annotations.

**Unit:** one annotated dative token from spoken Switchboard or the written Wall Street Journal Treebank. The table contains 3,263 tokens, 75 verb types, and 849 PP responses. Sentence text is omitted.

**Analysis columns:** recipient realization, argument lengths, accessibility, pronominality, recipient animacy, modality, semantic class, and verb. The response is `pp = 1` for a PP recipient and zero for an NP recipient. Fit Bernoulli models with a logit link, using independent zero centered normal priors for the internally centered intercept (SD 2.5) and slopes (SD 1.5). The baseline and alignment fits use four chains with 1,000 warmup and 1,000 retained iterations each. Summarize the posterior coefficients and check predictions by verb and modality by pronominality cell.

The token rows include repeated verbs and speakers. Speaker IDs are available for the 2,360 spoken tokens, covering 38 verbs and 424 speakers. The 903 written tokens have no speaker IDs. Count repeated identifiers and explain why the token count need not equal the amount of independent information. The models assume conditional independence across tokens; sampling diagnostics and predictive checks do not verify this assumption. Excluding verbs during cross-validation assesses prediction for those verbs, while speakers may occur in both partitions.

The source package declares GPL (>= 2). To reproduce the dative CSV, install `digest` with `install.packages("digest")`, download the archive below, and run the command from the extracted assignment directory. The adapted CSV's SHA-256 checksum is `02a49e0ef2da7df73a7ef622ddf31a55ba13c52a9b66bcfdf2fef3def7932bea`. `scripts/prepare_data.R` reconstructs the CSV from the [frozen CRAN archive](https://cran.r-project.org/src/contrib/Archive/languageR/languageR_1.5.0.tar.gz), whose SHA-256 checksum is `d629739bbfd8846ac4db62310a99eda59a22cb0170e58bc2e1a241b244b637c6`:

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
| 5 | 20 | derive the log posterior, fit Stan models, check conditional predictions, and examine observation units and conditional independence |
| 6 | 10 | summarize posterior probability contrasts, count data support, and refit Stan models with verbs omitted |

The points sum to 100. Fit MALD models by least squares and Gaussian maximum likelihood, and dative models by posterior sampling in Stan. Report confidence intervals for MALD coefficients and credible intervals for dative coefficients under their stated assumptions. Evaluate cross-validation scores descriptively because the training sets overlap.

Dative validation requires 150 exact Stan refits. Each refit uses training tokens only, retains the same priors and sampler settings, and passes the full sampling checks. Predictions average posterior probabilities with `posterior_epred()`. The `stan_cache/` directory stores reusable compiled programs and model files. It is created when you run the notebook; allow the first run to finish before rerunning cells that use the fits. If you extend sampling after a diagnostic failure, set `file_refit = "always"` for the affected fit: `"on_change"` does not detect changes to iteration counts.

## Grading

- **50% Functionality and completeness:** the code runs and every requested derivation, calculation, plot, and interpretation is present.
- **50% In class presentation:** every student must be prepared to explain any part of the submitted analysis.

Students may use LLMs for coding assistance, but they must understand and be able to explain the submitted code and reasoning.

## Submission

Submit the completed notebook through the course learning management system. All six exercises are required. The course schedule supplies the due date.
