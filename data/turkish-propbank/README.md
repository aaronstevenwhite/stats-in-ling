# ITU/IMST Turkish PropBank role-agreement extract

This teaching extract is derived from the semantic-role crowdsourcing release
described by Şahin and Adalı (2018). Turkish is a Turkic language. The resource
adds predicate-sense and semantic-role annotation to the 5,635-sentence IMST
dependency treebank, which contains roughly 56,000 orthographic words from ten
genres. Experts built predicate-specific frames, Turkish-speaking crowd workers
selected plain-language role descriptions, and an experienced annotator reviewed
items without complete crowd agreement.

The release is pinned to commit
`5cd9c9918c8a7f4fd62802387e04d14b995ecb66`. The original paper, the released
task design, the released worker instructions, the aggregate exports, the
individual-judgment exports, and the final adjudicated table were read before the
analysis was specified. The narrow teaching target is the **role-description
difficulty hypothesis (RDH)**: agreement with the adjudicated description may
vary between predicate-specific core roles and general adjunct-like roles in this
annotation task. The outcome is agreement with an adjudicated description. It is
not an independent measure of linguistic truth or annotator competence.

`role-agreement-judgments.csv` has one row per retained worker judgment. The
extract preserves crossed item and worker structure with fresh identifiers. It
does not contain the original worker IDs, judgment IDs, IP addresses, geographic
fields, timestamps, platform trust metadata, free-text error reports, sentences,
or candidate argument strings. The analysis keeps 55,207 judgments from 18,306
ordinary items and 144 workers whose pre-adjudication linguistic key matches the
final table exactly. The primary core-versus-adjunct comparison uses 52,784
judgments from 17,502 items. Items labeled as nonarguments and 171 unresolved
special cases are retained for auditing but excluded from that comparison.

## Count reconciliation

The paper reports 20,060 annotated candidates, whereas the released
`argAnnotation.argres` file contains 19,988 data rows. The aggregate exports
contain 18,550 finalized ordinary rows and 1,510 unique candidates explicitly
flagged as gold/test items, which sum to 20,060. Seventy-two explicit gold
candidates share the same sentence-predicate-sense-argument key with a row
flagged non-gold, matching the 72-row difference between the paper and release.
Six rows have the internally inconsistent combination `_golden=false` and
`_unit_state=golden`, and 244 ordinary rows cannot be linked after adjudication
by the full key. Thus the arithmetic discrepancy is accounted for, but the
release does not provide a build script that would establish every row-level
post-adjudication edit. The teaching extract excludes those 244 rows rather than
guessing their correspondence.

## Rebuild and validate

The script requires a local checkout because the raw exports include direct
identifiers and must not be copied into this repository or student-facing code.

```sh
python3 scripts/data-grounding/prepare_turkish_propbank.py \
  --source-root /path/to/turkishpropbank.github.io
Rscript scripts/data-grounding/validate_turkish_propbank.R
```

The validator checks the frozen checksum, privacy-minimized schema, observed
counts, and the crossed logistic pilot
`correct ~ role_group + (1 | item_id) + (1 | worker_id)`. The model is
nonsingular and converges without warnings in the recorded environment. Raw
agreement is 0.900 for core-role judgments and 0.724 for adjunct-like judgments;
the fitted adjunct coefficient is -1.329 on the logit scale. These are
release-specific task results, not population estimates for Turkish speakers.

## Sources and license

- Şahin, G. G., and Adalı, E. (2018). [Annotation of semantic roles for the
  Turkish Proposition Bank](https://doi.org/10.1007/s10579-017-9390-y).
- [Turkish PropBank project site and release](https://turkishpropbank.github.io/)
- [Pinned resource repository](https://github.com/turkishpropbank/turkishpropbank.github.io/tree/5cd9c9918c8a7f4fd62802387e04d14b995ecb66)

The project site states that resources created in the project are distributed
under CC BY-NC-SA 4.0. The repository's short `LICENSE` file is headed “Turkish
Frame Files,” though the repository also distributes the crowd exports. This
scope mismatch should be stated wherever the extract is introduced. The derived
file is intended only for the noncommercial course use allowed by the project-
wide statement, with attribution and share-alike terms preserved.
