# Problem Set 5: Telicity, clustering, and factorization

Complete all six exercises in `ps5.ipynb` and the numbered blanks in both Stan templates. The exercises sum to 100 points. Keep equations, visible numerical results, and interpretations in the notebook.

## Setup

Use R 4.1 or newer, Jupyter Notebook or JupyterLab, and the R kernel. Install the R packages once:

```r
install.packages(c("dplyr", "ggplot2", "posterior", "digest", "IRkernel"))
IRkernel::installspec()
install.packages("cmdstanr",
                repos = c("https://stan-dev.r-universe.dev", getOption("repos")))
```

Reuse the working CmdStan installation from the preceding assignments. If it is not installed, follow the [CmdStanR installation guide](https://mc-stan.org/cmdstanr/articles/cmdstanr.html) for your operating system, then run:

```r
cmdstanr::check_cmdstan_toolchain()
cmdstanr::install_cmdstan(cores = 2)
```

Open the notebook from the extracted assignment directory:

```sh
jupyter notebook ps5.ipynb
```

Select the R kernel. Keep the notebook in this directory so that relative paths to data, models, and helpers resolve.

## Files and data

```text
ps5-assignment/
├── README.md
├── ps5.ipynb
├── ps5.qmd
├── models/
│   ├── fixed-telicity.stan
│   └── varying-telicity.stan
├── scripts/
│   ├── helpers.R
│   └── prepare_data.R
└── data/
    ├── aspect-responses.csv
    ├── aspect-sentences.csv
    ├── README.md
    ├── provenance.json
    └── CC-BY-SA-4.0.txt
```

Both teaching tables are ready to use. [data/README.md](data/README.md) describes the contentful subset, sense annotations, response categories, source, and license. Read the paper and data documentation linked there before interpreting the models.

Open `models/fixed-telicity.stan` and `models/varying-telicity.stan` in a text editor or JupyterLab's file editor. Fill F1–F5 and V1–V3, then save the files at those same paths before running the compilation cell. F3 occurs twice; it computes the same contribution in the model and generated quantities. The notebook explains each line's mathematical role.

Use `scripts/helpers.R` as written. It constructs counts, compiles completed programs, checks sampling, calculates posterior predictions, and simulates response counts. The likelihoods you develop are in the Stan templates.

To rebuild the tables optionally, run `Rscript scripts/prepare_data.R` from this directory. The script downloads the two pinned public source CSVs and verifies their checksums. It can instead take one argument giving a local clone of the source repository.

## Exercises and computation

| Exercise | Points | Work |
|---|---:|---|
| 1 | 10 | distinguish observations and grouping units; split participants |
| 2 | 20 | derive a shared-class likelihood and complete its Stan template |
| 3 | 20 | derive judgment-specific mixtures and complete their Stan template |
| 4 | 15 | fit four models, check sampling, and check conditional predictions |
| 5 | 20 | compare held out predictions and measurement-error sensitivity |
| 6 | 15 | derive joint predictions and factorization geometry; interpret the comparison |

The four candidates hold telicity fixed by verb, annotated sense, or sentence, or let a new state be drawn for each judgment. They share response profiles and priors. The error probability is a declared measurement assumption, not a quantity directly observed in the experiments.

The notebook fits four training models at each of two error rates, then refits the four primary specifications to training plus validation data before testing. Each uses four chains, 1,000 warmup iterations, and 1,000 retained iterations per chain. Allow time for compilation and sampling; runtime depends on your machine.

Programs, draws, and fitted objects are saved under `stan_cache/`. The cache key includes the program, data, seed, and sampler settings. A changed iteration count thus creates a different fit. Resolve diagnostic failures before interpreting results. Keep the cache while working, but omit it from the submission.

## Grading and submission

- **50% Functionality and completeness:** every requested derivation, calculation, plot, and interpretation is present, and the completed code runs.
- **50% In class presentation:** be prepared to explain any part of your submitted models and reasoning.

You may use LLMs for coding assistance, but you must understand and be able to explain the submitted code and reasoning. Submit the completed notebook and both completed Stan files through the course learning management system. Use the due date in the course schedule.
