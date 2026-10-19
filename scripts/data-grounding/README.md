# Early-course data preparation

These scripts build the canonical teaching inputs used by the data-grounded
foundations, probability, distribution, and inference notes. They use only
base R or the Python standard library unless a script says otherwise.

Run the local, offline preparations from the repository root:

```sh
python3 scripts/data-grounding/prepare_cmudict.py
Rscript scripts/data-grounding/prepare_unimorph_turkish.R \
  /path/to/pinned-turkish-unimorph.tsv
Rscript scripts/data-grounding/prepare_unimorph.R
Rscript scripts/data-grounding/prepare_dative.R
Rscript scripts/data-grounding/prepare_provo.R
Rscript scripts/data-grounding/prepare_hillenbrand.R
python3 scripts/data-grounding/prepare_ud_ewt.py \
  --conllu /path/to/en_ewt-ud-train.conllu
python3 scripts/data-grounding/prepare_ud_turkish_boun.py \
  --source-directory /path/to/UD_Turkish-BOUN-2.18
Rscript scripts/data-grounding/validate_early_course.R
```

`prepare_ud_ewt.py` can fetch its pinned input when `--conllu` is omitted. The
Turkish preparation scripts can fetch their exact pins when the source argument
is omitted. The validation command is deliberately offline: it checks the
committed teaching tables and never accesses the network. Raw Hillenbrand
missingness is prepared separately by `prepare_hillenbrand_raw.R`. Provo and
German UniMorph outputs are redistributed under verified CC BY 4.0 and CC
BY-SA 3.0 terms, respectively. German UniMorph and UD English EWT are retained
as transfer assets; Turkish UniMorph and UD Turkish BOUN are the primary
early-course anchors.

Each dataset directory contains a README, a citation record, a license or
terms record, and machine-readable provenance. The preparation scripts assert
the expected schema, row counts, ranges, key uniqueness, and missingness before
writing output.

