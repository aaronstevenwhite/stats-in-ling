# UD Turkish BOUN teaching extracts

These tables are derived from all three splits of UD Turkish BOUN release 2.18,
pinned to commit `0def94a229dcbc28d32192b0138b560c075c6d87`. Turkish is a
Turkic language. The treebank contains 9,761 written sentences sampled from
five Turkish National Corpus (Aksan et al. 2012) registers: essays, broadsheet
newspapers,
instructional texts, popular-culture articles, and biographies.

Türk et al. (2022) describe the source and original annotation process, and
Marşan et al. (2022) document the agglutination-sensitive revisions included
since UD 2.11. Approximately
2,000 sentences were randomly sampled within each selected register. Two
native-speaker linguists annotated the automatically preprocessed sentences;
two other linguists cross-checked their syntax. On 1,000 independently double-
annotated sentences, reported Cohen's kappa was 0.82 for heads and 0.83 for
dependency labels. Morphological analyses came primarily from the Sak et al.
(2011) analyzer, were converted to UD features, and were evaluated on a 250-token
sample (reported token accuracy 0.91 and feature F1 0.94).

`question-core-arguments.csv` contains 167 interrogative-pronoun tokens whose
lemma is *hangi* 'which', *kim* 'who', or *ne* 'what' and whose dependency
relation is `nsubj` or `obj`. The observed 3-by-2 table is:

| lemma | `nsubj` | `obj` |
|---|---:|---:|
| *hangi* | 2 | 1 |
| *kim* | 14 | 3 |
| *ne* | 35 | 112 |

The table retains the three-level lemma, an `object` indicator, and a
`ne_lemma` indicator. Thus foundations pages can introduce categorical and
binary events from one observed corpus table; later independence work can use
the better-populated *ne* versus other contrast without inventing counts.

`personal-pronoun-cases.csv` contains 2,128 tokens tagged `UPOS=PRON` and
`PronType=Prs` with an annotated case. It retains all eight attested UD case
values and supplies `accusative` and `reflexive` indicators. This is the
recommended non-Indo-European anchor for population, sample, and corpus-
proportion examples. The English EWT extract remains useful for a later
cross-linguistic transfer exercise.

`word-form-frequencies.csv` contains the frequency of each Turkish-lowercased surface
word form across all three release splits after excluding tokens whose source
UPOS tag is `PUNCT`. Multiword-token range lines and empty nodes are excluded by
the CoNLL-U parser, while their component syntactic words remain. The table has
33,876 form types representing 104,426 non-punctuation syntactic-word tokens.
It supports a paper-aligned replication of Piantadosi's (2014) rank-frequency
measurement lesson on this Turkish treebank; it is not a reproduction of the
paper's American National Corpus analysis or a balanced sample of Turkish.

The observation is a token, but the source sample was drawn as sentences and
tokens within a sentence are dependent. `split`, register, sentence ID,
sentence text, and token ID are retained so that analyses can preserve this
structure. The extract does not turn the treebank into a probability sample of
Turkish usage. Note also that BOUN labels lexically selected objects as `obj`
even when they bear non-accusative case, following the analysis in Türk et al.
(2022). The simplification filters source annotations; it does not recode case
or dependency relations.

Rebuild with local release files or let the script fetch the pin:

```sh
python3 scripts/data-grounding/prepare_ud_turkish_boun.py
python3 scripts/data-grounding/prepare_ud_turkish_boun.py \
  --source-directory /path/to/UD_Turkish-BOUN-2.18
```

## Primary documentation

- Türk et al. (2022): <https://doi.org/10.1007/s10579-021-09558-0>
- Marşan et al. (2022): <https://arxiv.org/abs/2207.11782>
- Aksan et al. (2012), Turkish National Corpus:
  <https://aclanthology.org/L12-1590/>
- Sak et al. (2011), Turkish morphological processing resources:
  <https://doi.org/10.1007/s10579-010-9128-6>
- UD Turkish BOUN release documentation:
  <https://universaldependencies.org/treebanks/tr_boun/>
- Turkish UD overview and dependency guidelines:
  <https://universaldependencies.org/tr/>
- UniMorph-style feature values are not substituted for UD values in these
  tables; the source CoNLL-U annotations are retained.

## Checksums

- train source: `ae54aef82e69cb7ccc54703a07e2ebcde66c2e4453a5debfac1eb78dfed60e9f`
- development source: `b3531bb26337b3ef258796e6948d2c3469e71704613b9373cd87f341409e2d8d`
- test source: `c7f234f6a7c1b7025f8cab9025239286836e971b653fb1dd3f266a84ac74dbeb`
- `question-core-arguments.csv`: `420a4f358b77af61decf75e4536f46c88c26a5ae84c1dd75de6269bc85cc49d9`
- `personal-pronoun-cases.csv`: `7ba0b69d2747f01a13960055ca46ff86af48841892b73065c2a3738bcf34eb07`
- `word-form-frequencies.csv`: `af438cff4ace0b4cc8126980e02e6d4bf00a41c7e1377985c2d43703ff64c68c`
