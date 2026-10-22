# MegaNegRaising balanced teaching table

This table derives from the official [MegaNegRaising v1 archive](https://megaattitude.io/projects/mega-negraising/), whose internal README identifies version 1.1 (2020-08-29). An and White ([2020](https://aclanthology.org/2020.scil-1.45/)) describe the elicitation and the original acceptability-weighted latent analysis.

The teaching table contains native-American-English responses in the past tense for active and passive eventive infinitivals with first- and third-person matrix subjects. It retains the 193 verbs observed in all four cells: 7,651 paired slider judgments in 772 verb-by-voice-by-subject cells. It omits sentence text but preserves participant and verb identifiers. The table is an adaptation under CC BY-SA 4.0.

Rebuild it from the official archive with:

```bash
Rscript scripts/data-grounding/prepare_meganegraising.R \
  /path/to/mega-negraising-v1.zip data/meganegraising
```

`meganegraising-release-summary.csv` records the release, native-speaker, and balanced-subset dimensions computed during preparation. The archive and teaching-table checksums are recorded in `provenance.json`.
