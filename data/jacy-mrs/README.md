# Jacy/Tanaka analysis-selection teaching extract

`tanaka-selection.csv` contains all 15,000 items in the ten manually treebanked
Tanaka profiles `tc-006` through `tc-015` in Jacy commit
`82c282e2592841478d07aa81a83489344bb16e00`. Japanese is non-Indo-European.
Each row is one sentence item, and `selected_analysis` records whether the
profile's `preference` relation identifies at least one accepted grammar
analysis for that item.

The original treebank paper reports 8,488 selected items after the first
annotation cycle: 7,809 with one acceptable analysis and 679 with multiple
acceptable analyses (Bond, Kuribayashi, and Hashimoto 2008). The pinned current
release contains 8,670 items with at least one preferred analysis. It contains
9,128 preference records because 333 items have multiple accepted results;
those items contribute 458 records beyond the first. Thus 9,128 is not a count
of selected sentence items.

The remaining 6,330 items divide into 3,666 items with one or more parser
readings but no preferred result and 2,664 items with no positive reading count.
The latter group contains 2,346 zeroes and 318 `-1` sentinel values. The release
also contains parser-message strings for 513 items, including 28 selected
items, so a nonempty message must not be equated with analysis failure.

## What selection means

Jacy is a hand-built HPSG grammar that derives syntax and Minimal Recursion
Semantics (MRS) together. Treebankers select an acceptable analysis among the
grammar's candidates, or reject all candidates. The MRS is generated from the
selected grammar analysis; it is not an independently annotated semantic edge
set. `selected-mrs-example.csv` preserves one actual selected MRS only to define
the object made available by treebanking.

This table supports a **grammar-coverage selection** analysis: model the
probability that an item has any preferred analysis as a function of the
release's `i-length` field, with profile structure retained. In the pinned
release, the overall selected-item proportion is 0.578. A logistic model with
profile fixed effects estimates a standardized length coefficient of -0.645
(SE 0.020). Adding length reduces residual deviance by 1,220.3 relative to a
profile-only model. A quadratic term reduces deviance by a further 51.1, so a
linear logit should be presented as a deliberate simplification and plotted
against raw binned proportions.

These results describe entry into this release's human-selected semantic
layer. They do not estimate grammaticality, semantic well-formedness, or usage
frequencies in Japanese. The Tanaka collection was assembled by students,
contains artificial and repetitive material, and retains errors despite later
editing. Official corpus documentation explicitly warns against statistical
analysis of the text as representative language use. The selection process,
not the sentence distribution, is the target here.

Three items contain a standalone full-width spacing token, so the release's
`i-length` exceeds a generic whitespace-split count by one. The analysis uses
the declared `i-length` value and records the three discrepancies in
`length_matches_whitespace_split`.

## Rebuild and validate

The R preparation reads field names from each profile's declared `[incr
tsdb()]` `relations` schema. It does not infer the meaning of columns from their
positions. With no source argument, it downloads and verifies the pinned Jacy
archive.

```sh
Rscript scripts/data-grounding/prepare_jacy_mrs.R
Rscript scripts/data-grounding/validate_ucca_jacy.R
```

To use an existing checkout:

```sh
Rscript scripts/data-grounding/prepare_jacy_mrs.R /path/to/jacy data/jacy-mrs
```

## Sources

- Bond, Kuribayashi, and Hashimoto (2008), [HPSG に基づくフリーな日本語ツリーバンクの構築](https://www.anlp.jp/proceedings/annual_meeting/2008/pdf_dir/PC1-7.pdf).
- Bond, Fujita, and Tanaka (2006), [The Hinoki Syntactic and Semantic Treebank
  of Japanese](https://doi.org/10.1007/s10579-007-9036-6).
- Copestake et al. (2005), [Minimal Recursion Semantics: An
  Introduction](https://doi.org/10.1007/s11168-006-6327-9).
- Nichols et al. (2010), [Paraphrasing Training Data for Statistical Machine
  Translation](https://doi.org/10.11185/imt.5.950).
- [Official Jacy/Hinoki documentation](https://delph-in.github.io/docs/grammars/JacyHinoki/)
  and [pinned Jacy repository](https://github.com/delph-in/jacy/tree/82c282e2592841478d07aa81a83489344bb16e00).
- [EDRDG Tanaka Corpus documentation and warning](https://www.edrdg.org/wiki/Tanaka_Corpus.html).

The pinned Jacy repository is MIT-licensed. The license text is preserved as
`LICENSE-MIT.txt`.

