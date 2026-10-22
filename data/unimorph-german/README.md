# German UniMorph teaching tables

These legacy and transfer tables derive from the German UniMorph repository at
commit `d226d2112d3490d8f04ece10d4538123d4297a39`. The exact pinned README assigns
the resource the Creative Commons Attribution-ShareAlike 3.0 Unported license.
The early-course morphology sequence now uses the paper-audited Turkish
UniMorph verb population; the German tables remain available for later
cross-linguistic comparison and for reproducing earlier course materials.

The source represents an inflected form as a lemma paired with a UniMorph
feature bundle. The upstream course preparation code selects nominal paradigm
cells and adds orthographic variables:

- `genitive-population.csv` contains 16,719 masculine or neuter lexemes with
  detected *-s* and *-es* genitive-form attestation.
- `genitive-sample-120.csv` is the fixed seed-414 sample used when a lesson
  reproduces the earlier finite-population analysis.
- `plural-lexemes.csv` contains 13,297 noun lexemes with one retained plural
  form and a derived suffix class (`e`, `en`, `er`, `s`, or `ø`).

The observation in every table is a lexeme. `es_attested` and `s_attested` can
both be true because the source may contain alternative forms; they do not
encode one mutually exclusive suffix choice. The vowel-group count is a
deterministic orthographic heuristic. In this frozen preparation, 274 genitive
lexemes and 221 plural lexemes receive zero because the original script
replaces a diphthong with uppercase `V` before matching lowercase vowel groups.
The complete population is retained so the tables reproduce the course
release. Any page using syllable class must state this limitation or use a
separately versioned repair.

Validate and copy the tables without changing the assignment sources:

```sh
Rscript scripts/data-grounding/prepare_unimorph.R
```

The upstream form extraction is recorded in
`problem-sets/ps1/scripts/fetch_unimorph_data.py`; the lexeme reduction and
fixed sample are recorded in
`problem-sets/ps1/scripts/prepare_unimorph_tables.R`. Both are read-only inputs
to this notes-owned preparation.

## Checksums

- `genitive-population.csv`: `98127c132956403e7b16447127a5049f656cd0c0f1efc9384919b6a312959239`
- `genitive-sample-120.csv`: `176d6c8cbedeadb741ffaedaf1a5df3f91a0a996a6a2238960a39a0a115332cb`
- `plural-lexemes.csv`: `f21c1292f2241269cc4cdd3563dd7cb6efe52ccee9c1edd9bdad4e310532ec61`

## Primary documentation

- Pinned source and license statement:
  <https://github.com/unimorph/deu/tree/d226d2112d3490d8f04ece10d4538123d4297a39>
- UniMorph 4.0 resource paper: <https://aclanthology.org/2022.lrec-1.89/>
- UniMorph schema: <https://unimorph.github.io/doc/unimorph-schema.pdf>
