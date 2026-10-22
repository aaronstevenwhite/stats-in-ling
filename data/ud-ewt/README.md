# UD English EWT teaching extracts

These tables are derived from the training split of Universal Dependencies
English Web Treebank (UD English EWT) at commit
`4a4d77f599ea53cc405f85d0cec4b2f14f81d42b`.

These English tables are retained as legacy and cross-linguistic transfer
assets. The foundations sequence now uses UD Turkish BOUN as its primary
dependency and pronoun-case anchor.

`ud-ewt-wh.csv` contains one selected `what`, `which`, or `who` token per
sentence when the token is annotated as `nsubj` or `obj`. The 671 rows form the
fixed 3-by-2 table used for sample spaces, events, probability measures,
conditional probability, Bayes' rule, independence, and categorical models.
The column `object` is the indicator of `dependency_relation == "obj"`.

`ud-ewt-pronouns.csv` contains 15,163 personal-pronoun tokens for which UD
supplies `Case=Acc`, `Case=Gen`, or `Case=Nom`. Unlike the older course
heuristic, `case` is the UD morphological annotation. `accusative` is the
indicator of `case == "Acc"`. Document, sentence, and token identifiers remain
in the table because tokens within a document need not be independent.

The observations are corpus annotations, not a probability sample of English
usage. In particular, `nsubj` and `obj` are syntactic dependency relations,
whereas `Case` is a morphological feature.

Rebuild both tables with:

```sh
python3 scripts/data-grounding/prepare_ud_ewt.py
```

For an offline rebuild, download the pinned training file and pass it with
`--conllu`. The script verifies the source SHA-256 checksum before parsing.

## Schema

The WH table stores `document_id`, `sentence_id`, `sentence_text`, `token_id`,
`wh_form`, `wh_lemma`, `upos`, `dependency_relation`, and `object`. The pronoun
table stores the same identifiers plus `form`, `lemma`, `case`, `number`,
`person`, `possessive`, `dependency_relation`, and `accusative`.

## Checksums

- pinned training source: `d68e06122a702464c613076523d56740f047e5bbe89dd90ec32737e04d952143`
- `ud-ewt-wh.csv`: `fbc4b10149040ee1486fa6d7cc267025f2cc7925fed621e76d903aa9ee9f078d`
- `ud-ewt-pronouns.csv`: `bb4c7ae965770584c5ccf00e10c242a7e286407040a77f6f9050d86861eec844`

