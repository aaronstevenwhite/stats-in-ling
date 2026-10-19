# ManyBabies 1 course input

ManyBabies 1 measured infants' looking time while they heard infant-directed
speech (IDS) and adult-directed speech (ADS) across 67 laboratories. The course
uses the official main trial table from commit
`dc3eb5b3578057096d337203635c0759d2fc04b6` of the
[public analysis repository](https://github.com/manybabies/mb1-analysis-public).
Cite The ManyBabies Consortium (2020), *Advances in Methods and Practices in
Psychological Science*, 3, 24--52,
[doi:10.1177/2515245919900809](https://doi.org/10.1177/2515245919900809).

Prepare the pinned release:

```bash
Rscript scripts/data-grounding/prepare_manybabies.R
```

The script verifies the trial table, variable dictionary, repository README,
and MIT license by SHA-256. It then writes `manybabies1-trials.rds`: 37,264 rows
for 2,329 infants in 67 labs. The official exclusion script completes each
infant's record to sixteen possible trials. Thus 4,383 rows have no recorded
trial metadata, and 10,369 rows have no included looking time. Both facts remain
explicit in `trial_metadata_observed` and `trial_missing`; the preparation does
not impute the outcome or discard missing trials.

The source repository README states that its data and code are licensed for
reuse, and the repository license is MIT. `LICENSE-MIT.txt` preserves those
terms. This input differs from the broader ManyBabies materials site, whose
materials may carry separate terms.

The released main table follows the consortium's documented validation and
exclusion process. The course should distinguish those protocol exclusions
from `trial_missing`, which identifies a possible trial without an included
looking time. Laboratory and method are observational groupings, not randomized
between-infant treatments. The experimental contrast is IDS versus ADS within
infant, with order counterbalanced across infants.
