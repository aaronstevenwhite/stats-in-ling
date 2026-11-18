# Problem Set 4: Mixed effects models

Extract the complete package and complete all six exercises in `ps4.ipynb`. The exercises sum to 100 points. Keep equations, code, numerical results, and interpretations in the notebook.

## Setup

Use R 4.1 or newer, Jupyter Notebook or JupyterLab, and the R kernel. Install the R packages and register the kernel once:

```r
install.packages(c("lme4", "brms", "ordbetareg", "posterior",
                   "dplyr", "ggplot2", "IRkernel"))
IRkernel::installspec()
```

Reuse the working CmdStan installation from Problem Sets 2–3. If you need to install it:

```r
install.packages("cmdstanr",
                repos = c("https://stan-dev.r-universe.dev", getOption("repos")))
cmdstanr::check_cmdstan_toolchain()
cmdstanr::install_cmdstan(cores = 2)
```

CmdStan requires a C++ toolchain. Follow the [CmdStanR installation guide](https://mc-stan.org/cmdstanr/articles/cmdstanr.html) for your operating system. The ordered beta helper was checked with `ordbetareg` 0.7.2 and `brms` 2.20.4.

Open the notebook from the extracted directory:

```bash
jupyter notebook ps4.ipynb
```

Select the R kernel and run cells in order. Keep the notebook in this directory so that paths beginning with `data/` and `scripts/` resolve.

## Files and data

```text
ps4-assignment/
├── README.md
├── ps4.ipynb
├── ps4.qmd
├── data/
│   ├── inference-choices.csv
│   ├── projection-ratings.csv
│   ├── contents.csv
│   ├── README.md
│   └── provenance.json
└── scripts/
    ├── helpers.R
    └── prepare_data.R
```

Both teaching tables are ready to use. The binary responses are recorded choices; the slider responses retain exact zeros and ones. See [data/README.md](data/README.md) for measurements, columns, exclusions, and attribution.

`scripts/helpers.R` generates ordered beta replications and records whether a response came from an endpoint or the interior. Use it as written. The notebook develops the models and the quantities you interpret.

Rebuilding the tables is optional. Install `digest` with `install.packages("digest")`, then run `Rscript scripts/prepare_data.R` from this directory. The script downloads the pinned source files and verifies their checksums. You can instead pass the path to a local clone of the authors' repository as its one argument.

## Exercises and computation

| Exercise | Points | Work |
|---|---:|---|
| 1 | 10 | identify measurement units and repeated observations |
| 2 | 20 | fit a logistic mixed model and derive a likelihood ratio test |
| 3 | 15 | derive participant modes and predict for new participants |
| 4 | 20 | derive beta endpoint sensitivity and the ordered beta mean |
| 5 | 20 | derive shared-predicate covariance and fit with brms |
| 6 | 15 | check conditional distributions and full response means |

The frequentist section uses six predicates from the complete binary table. The Bayesian section fits one ordered beta mixed model with four chains, 1,500 warmup iterations and 3,000 retained iterations per chain. Allow time for compilation, sampling, and prediction.

The notebook creates `stan_cache/` and saves the Bayesian fit there. Keep that directory while working so completed fits can be reused. If you change sampling iterations, set `file_refit = "always"` for that run: `"on_change"` does not detect iteration changes. Resolve failed sampling diagnostics before interpreting the draws.

## Grading and submission

- **50% Functionality and completeness:** the code runs and every requested derivation, calculation, plot, and interpretation is present.
- **50% In class presentation:** be prepared to explain any part of your submitted analysis.

You may use LLMs for coding assistance, but you must understand and be able to explain the submitted code and reasoning. Submit the completed notebook through the course learning management system. All six exercises are required; use the due date in the course schedule.
