# Hillenbrand vowel teaching tables

These tables represent the 1,668 /hVd/ vowel tokens produced by 139 speakers
in Hillenbrand et al. (1995). Each speaker contributes one token for each of 12
vowels.

`vowels-complete.csv` is the audited `phonTools::h95` teaching table from
`phonTools` 0.2-2.2. It contains duration, F0, and steady-state F1--F3. The
package documentation states that its 10 originally missing F2 values and 41
originally missing F3 values were imputed. This table is suitable for pages
that require complete duration or formant measurements, including empirical
distributions and paired speaker contrasts. It must not be presented as the
raw missingness pattern.

Rebuild the complete table with:

```sh
Rscript scripts/data-grounding/prepare_hillenbrand.R
```

The script requires `phonTools` 0.2-2.2 and rejects a different package
version. The distinct `data/hillenbrand-raw/` asset retains natural
missingness for the missing-data chapter.

Hillenbrand et al. (1995) use the /hVd/ recordings to characterize the
acoustics and identification of 12 American English vowels across adult men,
adult women, and children. A row is a vowel token nested within a speaker; the
1,668 rows are consequently not 1,668 independent speakers. The teaching table
retains the source speaker and vowel identifiers plus duration, F0, and
steady-state F1--F3. Its complete formant columns reflect the package's
imputation and must not be used to teach the release's natural missingness.
The `phonTools` package supplies the table and documentation but not the
original paper's analysis code.

Primary paper: <https://doi.org/10.1121/1.411872>. Package documentation:
<https://cran.r-project.org/package=phonTools>.

## Checksums

- `vowels-complete.csv`: `de3450982779fe3ac2e914974eb0ba6a7e0f778d7328f6dbb5d5ab5a58af22c9`

