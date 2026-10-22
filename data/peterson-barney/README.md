# Peterson--Barney package input

The latent-structure run uses Peterson and Barney's
([1952](https://doi.org/10.1121/1.1906875)) vowel measurements as distributed in
`phonTools::pb52`. Each row identifies speaker, speaker type and sex, vowel,
repetition, F0, and F1--F3. The audited package version is 0.2.2.2.

The course loads the table from the package rather than vendoring it:

```r
data("pb52", package = "phonTools")
```

Validate the installed release before use:

```bash
Rscript scripts/data-grounding/validate_pb52.R
```

The script asserts 1,520 rows, 76 speakers, two repetitions, the nine-column
schema, and complete measurements. The pinned `phonTools` release declares
`BSD_2_clause + file LICENSE`, but its documentation does not state separate
redistribution terms for the historical `pb52` table. Thus the repository loads
the object from the pinned package and stores neither a copy nor a derived table.
