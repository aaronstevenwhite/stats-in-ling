# Raw Hillenbrand formants

This directory contains the nonimputed Hillenbrand et al.
([1995](https://doi.org/10.1121/1.411872)) vowel measurements needed for the
missing-data run. The pinned source is Santiago Barreda's
[permissioned repository](https://github.com/santiagobarreda/hillenbrand_et_al_1995)
at commit `6dd44decc8ef5b537cbb54732a3b00c8fa652e65`, licensed under MIT.

Prepare the table from the pinned RDS:

```bash
Rscript scripts/data-grounding/prepare_hillenbrand_raw.R
```

The output retains identifiers, duration, F0, steady-state F1--F3, and eight
trajectory samples for F1--F3. It preserves the original missing cells, including
10 steady-state F2 values and 41 steady-state F3 values. This distinction matters:
`phonTools::h95` has already imputed those cells and thus cannot serve as the
input to an imputation lesson.

Artificial validation masks may be drawn only from cells that are observed in
this table. The naturally missing cells have no released ground truth.
