# MegaVeridicality v1 teaching data

These files derive from the official [MegaVeridicality v1
release](https://megaattitude.io/projects/mega-veridicality/mega-veridicality-v1.zip),
distributed under CC BY-SA 4.0. White and Rawlins
([2018](https://ling.auf.net/lingbuzz/004012/current.pdf)) describe the item
construction, direct and conditional-antecedent tasks, ordinal measurement, and
original responsivity analyses.

`megaveridicality-v1-source.csv` preserves the 21,760 release rows in a stable
CSV. `megaveridicality-v1-active-native.csv` is the approved teaching table: it
retains the active-voice rows after applying the release's exclusion flag and
constructs task-specific respondent identifiers. The task prefix is necessary
because 29 numeric participant labels occur in both independently recruited
tasks. `verb-folds.csv` freezes the grouped-by-verb validation split.

Rebuild the files from a downloaded official archive:

```bash
Rscript scripts/data-grounding/prepare_megaveridicality.R \
  /path/to/mega-veridicality-v1.zip data/megaveridicality
```

The source and derived checksums, counts, filter, and citation are in
`provenance.json`. The upstream README is preserved as `SOURCE-README.md`.

