# MegaOrientation v1.1 teaching data

These files derive from the corrected official [MegaOrientation v1.1
release](https://megaattitude.io/projects/mega-orientation/mega-orientation-v1.1.zip),
distributed under CC BY-SA 4.0. Moon and White
([2020](https://ling.auf.net/lingbuzz/005282/current.pdf)) describe the forced
future/past manipulation, predicate-frame selection, collection design, and
original latent model comparison.

`megaorientation-v1.1.tsv` contains all 44,160 v1.1 judgments and adds stable
predicate-frame and item identifiers plus compact frame codes.
`verb-folds-multiframe.csv` freezes a grouped split for the 662 verbs represented
in at least two frames. The paper's counts describe v1 (887 verbs and 869
participants); the corrected v1.1 release contains 898 verbs and 862 participant
identifiers. Course-computed numbers must use the latter release counts.

Rebuild the files from a downloaded official archive:

```bash
Rscript scripts/data-grounding/prepare_megaorientation.R \
  /path/to/mega-orientation-v1.1.zip data/megaorientation
```

The source and derived checksums, counts, version note, and citation are in
`provenance.json`. The upstream README is preserved as `SOURCE-README.md`.

