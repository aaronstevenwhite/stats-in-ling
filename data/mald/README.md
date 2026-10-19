# MALD teaching inputs

These tables derive from MALD 1.1, the Massive Auditory Lexical Decision
database described by Tucker et al. ([2019](https://doi.org/10.3758/s13428-018-1056-1)).
The pinned release is available from the [University of Alberta repository](https://doi.org/10.7939/r3-kh0r-r116)
under CC BY-NC 4.0.

`mald-items.csv` retains the item-level summaries needed for multiple regression,
diagnostics, and distributional regression. `mald-connected-trials.csv` is a
response-blind, hash-selected participant-by-item table for the mixed-model run.
It retains incorrect decisions rather than silently converting the accuracy
response into a correct-only sample.

Rebuild both tables from the audited local release:

```bash
Rscript scripts/data-grounding/prepare_mald.R \
  problem-sets/ps3/data/MALD1_1_AllData.txt data/mald
```

The script checks the source checksum, dimensions, required columns, filtering
rules, item replication, and output checksums. See `provenance.json` for the exact
selection salts and derived-file hashes.
