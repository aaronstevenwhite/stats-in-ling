# Aspectual-similarity teaching extract

`within-verb-similarity.csv` is the within-verb teaching extract (WVTE) used in the bounded-response application. It is derived from Experiment 2 of White, Grimm, and Glass (2026).

The extract retains test trials whose two descriptions are contentful and verbs that have both same-sense and different-sense pairs. Run the deterministic preparation script from the repository root:

```bash
Rscript data/aspectual-similarity/prepare.R \
  /path/to/aspectual-similarity-elm2026/data/data-similarity.csv \
  data/aspectual-similarity/within-verb-similarity.csv
```

The source data are CC BY-SA 4.0. This adapted extract is distributed under the same license. The source CSV checksum is `5b5e333446794f6420e60dd418e86c2a2389087940dd11d50accef6b735fccd6`.

