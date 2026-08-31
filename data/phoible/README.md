# PHOIBLE pilot data

This directory contains retrieval and preparation code for the PHOIBLE 2.0 pilot. It does not contain the raw archive.

Run the preparation from the repository root:

```bash
Rscript data/phoible/prepare_data.R
```

The script downloads the pinned Zenodo archive to a temporary directory, verifies both recorded checksums, extracts the CLDF tables, and writes `phoible-pilot.rds`. The generated R object is ignored by Git because it can be reconstructed from the archived release.

The PHOIBLE project describes PHOIBLE 2.0 as licensed under Creative Commons Attribution ShareAlike 3.0 Unported. Any redistributed derivative must preserve attribution and the share alike condition. See `research/homework-validation/ps5/data-card.md` for source and license links.
