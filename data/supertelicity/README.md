# SuperTelicity cloze data

The SuperTelicity cloze experiment records participant choices between *in* and
*for* together with selected temporal magnitudes. The local source repository is
pinned at commit `e45277ce466719c1a03629f6ccf1e12db9904421`; its creators license
the project under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).

Run the deterministic preparation from the repository root:

```bash
Rscript scripts/data-grounding/prepare_supertelicity.R
```

The prepared table removes sentence text while preserving stable sentence,
participant, verb, condition, and list identifiers. It codes *in* as one and
converts each numeral-unit response to log minutes using the conversion constants
recorded in `provenance.json`. The script checks the source checksum and the full
binary-response schema before writing the table.
