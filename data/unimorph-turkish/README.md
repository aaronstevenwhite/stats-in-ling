# Turkish UniMorph past-tense teaching population

These tables derive from the Turkish UniMorph repository at commit
`6c179ace7d2f3d7f3484020e5304c1544d07bb6b`. Turkish is a Turkic language.
The pinned release describes its verb paradigms as semi-automatically generated
and partially checked by a native speaker; it describes its noun and adjective
paradigms as unverified Wiktionary material. The preparation thus excludes the
nouns and adjectives.

Pimentel et al. (2021) introduced the Turkish tables as part of a morphological
reinflection shared task. In that task, systems predict an inflected form from
a lemma and a UniMorph feature bundle. The paper characterizes Turkish as
highly agglutinative and notes that the release includes only forms that may
appear in main clauses. Its original analysis
compares system accuracy across languages and analyzes errors, including errors
on unseen lemmas and allomorphy. The associated task code and data are at
<https://github.com/sigmorphon/2021Task0>.

`verb-past-population.csv` contains the 588 distinct verb lemmas with exactly
one form bearing `V;IND;PST;3;SG;POS;DECL`. A row is thus a lexeme paired with
one paradigm cell, not a corpus token. The table is a census of this pinned
resource-defined population; it supplies no token frequencies and cannot
estimate how often a form occurs in Turkish usage.

The source supplies `lemma`, `form`, and `feature_bundle`. The course script
retains those columns and adds deterministic orthographic measurements. It
removes the infinitive ending *-mak* or *-mek* to obtain `stem`, records the
stem-final segment and last stem vowel, and records the final two characters of
the inflected form as `past_suffix`. This transformation preserves the
lemma--feature--form relation that the shared task models. It does not claim
that UniMorph supplies morpheme boundaries; UniMorph represents a whole form
paired with a lemma and an unordered feature set.

The eight observed final sequences are *-dı* (159), *-di* (128), *-du* (59),
*-dü* (42), *-tı* (88), *-ti* (66), *-tu* (19), and *-tü* (27). Exactly 200
forms have a *t*-initial sequence. `verb-past-sample-120.csv` is a simple random
sample without replacement from the 588 rows. It was drawn in R with seed 414,
the `Mersenne-Twister` generator, `Inversion` normal generation, and
`Rejection` sampling. The population and sample support Bernoulli,
categorical, hypergeometric, contingency-table, and Beta--Binomial
examples without invented counts. The fixed-size sample supports a
hypergeometric model. Any binomial example must instead state an independent-
draw sampling design rather than treat these without-replacement draws as
independent.

Rebuild from a local pinned source or let R download it:

```sh
Rscript scripts/data-grounding/prepare_unimorph_turkish.R \
  /path/to/unimorph-tur.tsv
Rscript scripts/data-grounding/prepare_unimorph_turkish.R
```

## Primary documentation

- Pimentel et al. (2021):
  <https://aclanthology.org/2021.sigmorphon-1.25/>
- UniMorph 4.0 resource paper: <https://aclanthology.org/2022.lrec-1.89/>
- UniMorph schema: <https://unimorph.github.io/doc/unimorph-schema.pdf>
- Pinned Turkish README, including annotation and license statements:
  <https://github.com/unimorph/tur/blob/6c179ace7d2f3d7f3484020e5304c1544d07bb6b/README.md>

## Checksums

- source TSV:
  `4ae44f4b039c344f7078d8073b968b0d67133d1e9d7e653ce8aba5ed24387957`
- `verb-past-population.csv`:
  `440ba51c27fd9b9db0366478dfbcf40ae50e7538e35ec0f8793d6231b9be76a4`
- `verb-past-sample-120.csv`:
  `b5d293b2496290b567a86ee7c77ce33cee249c3a9a5c7c38f6a11a2dba28980e`
