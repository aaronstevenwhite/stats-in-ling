# Corrected Natural Stories input

Natural Stories contains self-paced reading times for ten construction-enriched
English stories. The course uses commit
`4700daad696e942f5aba23c957a7423d0de66612`, which contains the 2025 correction
for a one-position reading-time displacement. Cite Futrell et al. (2021),
*Language Resources and Evaluation*, 55, 63--77, and the
[source repository](https://github.com/languageMIT/naturalstories).

Prepare the pinned release:

```bash
Rscript scripts/data-grounding/prepare_natural_stories.R
```

The script verifies every source checksum and combines the corrected RTs with
(i) sentence membership from the released aligned UD parse, (ii) Google Books
unigram frequency, and (iii) GPT-3 word surprisal obtained by summing released
byte-pair log probabilities within experiment words. One documented spelling
difference remains in Story 2: the experiment records `peaked`, while the GPT-3
input records `peeked`. Position-based alignment preserves the released RT word;
the exception is stored in `gpt3-alignment-exception.csv`.

The prepared table has 848,875 rows, 180 participants, ten stories, 485
sentences, and 10,256 story-by-position tokens. It is ignored by Git because the
compressed object is generated from immutable public inputs. The accompanying
license is CC BY-NC-SA 4.0; downstream distribution must preserve attribution,
the noncommercial restriction, and share-alike terms.

Only ten stories are available. Leave-one-story-out results thus describe these
ten enriched texts and should be reported story by story, not treated as a large
sample of texts.
