# UDS natural-parts analysis extract

The custom-model run uses the approved binary natural-parts extract from UDS
event-structure annotations. The source is `decomp` 0.3.2, described by White et
al. ([2020](https://aclanthology.org/2020.lrec-1.699/)) and licensed CC BY-SA 4.0.

Recreate the prepared copy from the audited extract:

```bash
Rscript scripts/data-grounding/prepare_uds.R
```

The table contains 2,955 judgments of 1,000 items by 12 annotators. Its item and
annotator graph is connected. The preparation script checks the exact source
hash, schema, binary counts, item replication, and derived hash.

The directory also contains `uds-natural-parts-posterior-cache.rds`, a compact
render-time copy of 400 audited posterior draws for three population parameters,
1,000 item effects, and 12 annotator effects. Its companion provenance file records
the source response table, full fit, Stan program, fit seeds, sampling schedule,
and deterministic retained-row rule. Validate the promoted cache with:

```bash
Rscript scripts/data-grounding/validate_uds_cache.R .
```

The note pages show the complete model and fitting call but load this cache for
figures and summaries; they do not read ignored artifacts under `research/`.

This input licenses only the audited binary natural-parts model. Confidence,
annotator discrimination, and conditional branches require a separate extract,
likelihood, and recovery audit. No such gated follow-up is prepared here.
