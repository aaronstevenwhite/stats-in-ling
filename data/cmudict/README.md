# CMU Pronouncing Dictionary teaching table

`cmudict-pronunciations.csv` contains one row for each of the 133,854
pronunciation entries in CMUdict 0.7b. The source is the already tracked
`decks/random-variables-and-distributions/data/cmudict-0.7b` file. Its checksum
pins the release used by the notes.

The table preserves the orthographic entry and complete ARPAbet phone sequence.
It also derives four count variables: total phones, vowel phones, consonants
before the first vowel, and consonants before the third vowel. A vowel phone is
identified by the CMUdict stress digit `0`, `1`, or `2`. The third-vowel count is
missing by definition for the 78,428 pronunciations with fewer than three vowel
phones; the other derived variables are complete.

`entry` retains alternate-pronunciation labels such as `(2)`, while `word`
removes that label and `pronunciation_variant` records its integer value. The
observational unit is thus a dictionary pronunciation, not a word type or a
token in running speech.

CMUdict was developed as a machine-readable pronunciation lexicon for speech
technology. Its release documentation defines the ARPAbet phone representation
and alternate-pronunciation notation; it does not describe a probability
sample of English words or running-speech tokens. Entries sharing `word` are
dependent alternatives, and the table carries no lexical frequency. The
teaching transformation preserves every source pronunciation and adds only
deterministic counts, so empirical expectations describe this pinned lexicon
rather than English usage.

Primary release documentation and the machine-readable symbol table are in the
[CMUdict repository](https://github.com/cmusphinx/cmudict), and the 0.7b release
is documented in the [CMUSphinx release
post](https://cmusphinx.github.io/2014/11/cmudict-0-7b-update/). CMUdict is a
lexical resource rather than a paper-linked experiment; no original statistical
analysis code is part of the 0.7b release.

Rebuild the table with:

```sh
python3 scripts/data-grounding/prepare_cmudict.py
```

The script uses only the Python standard library and checks row counts, entry
uniqueness, ranges, and missingness.

## Checksum

- source CMUdict 0.7b: `209a8b4cd265013e96f4658632a9878103b0c5abf62b50d4ef3ae1be226b29e4`
- derived table: `bbf40ef2e185b32d515f5ba6dea91c640977007b61967dce2e489ccfb99385fd`

