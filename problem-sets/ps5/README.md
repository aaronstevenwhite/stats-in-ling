# Problem Set 5: Structure in phoneme inventories

Complete all ten numbered tasks in `ps5.qmd`. Use R and keep this directory as the working directory for the analysis.

## Setup and files

The analysis uses base R. You also need an internet connection to download PHOIBLE 2.0 and either `shasum` or `sha256sum` to verify the archive.

Run the preparation script from this directory:

```sh
Rscript scripts/prepare-phoible.R
```

It creates `data/phoible-pilot.rds`, containing the tables loaded by the assignment. The preparation script checks the source archive before creating the object.

- `ps5.qmd` contains the task instructions and R code.
- `scripts/prepare-phoible.R` downloads and prepares the pinned PHOIBLE data.
- `scripts/phoible-svd-functions.R` defines inventory selection, matrix construction, masking, SVD fitting, and scoring.
- [data/README-PHOIBLE.md](data/README-PHOIBLE.md) describes the source, filters, and license.

Select rank using validation cells, then evaluate the selected representation on test cells. Report your computed results and explain the prediction target and limits of the interpretation.

## Grading and submission

- **50% Functionality and completeness:** the code runs and every requested calculation, plot, and interpretation is present.
- **50% In class presentation:** be prepared to explain any part of your submitted analysis.

You may use LLMs for coding assistance, but you must understand and be able to explain the submitted code and reasoning. Submit the completed analysis through the course learning management system. All ten tasks are required; use the due date in the course schedule.
