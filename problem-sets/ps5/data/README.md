# Data for Problem Set 5

These tables adapt the contentful descriptions from Experiments 1a and 1b of White, Grimm, and Glass (2026), *Aspect is not a fixed property of linguistic expressions*. Use the PDF shared on Zulip for the reading. The [public repository](https://github.com/SuperMereo/aspect-is-not-fixed) documents the experiments, exclusions, source columns, and analysis. The source revision is 556fe1be0d7f9a00d507875ed3327055a6d93fb6. Data are licensed CC BY-SA 4.0; see `CC-BY-SA-4.0.txt`.

The source CSVs already apply the study's exclusions. This adaptation retains episodic contentful descriptions, their preposition and overlap responses, and the metadata needed for grouping. It omits bleached and templatic descriptions because their sense is not uniquely observed, and omits the separate similarity experiment. It also omits numeral and time-unit choices/stimuli and reaction times.

## aspect-responses.csv

There are 4,560 responses: 1,660 cloze choices and 2,900 overlap judgments, evenly divided between assigned *for* and *in*. There are 110 participants in the retained subset. Labels preserve each person's grouping within the subset and do not encode platform identifiers.

- `participant`: a consistent pseudonymous person label.
- `sentence_id`: the base event description.
- `block`: `cloze`, `overlap_for`, or `overlap_in`.
- `category`: `for` or `in` for cloze; the recorded integers 0–4 for overlap.

In cloze, participants chose preposition, numeral, and time unit. Only the preposition choice is retained. In overlap, those three fields were assigned in the stimulus; participants chose the proportion category. A preposition in the overlap blocks is thus a design feature, not a choice.

Overlap 0 means none of the interval, 1 less than half, 2 about half, 3 more than half, and 4 the entirety. The assignment treats these as categories without equal-spacing or ordinal-link assumptions. Since duration fields are omitted, its response profiles average across the recorded duration conditions.

## aspect-sentences.csv

There are 166 descriptions, 40 verbs, and 83 annotated senses, with two descriptions per sense.

- `sentence_id`: unique identifier used by the response table.
- `sentence`: base description text.
- `verb`: verb lemma.
- `verb_type`: manner or result classification, retained as descriptive metadata.
- `sense_id`: identifier for the combination of PropBank roleset and concrete/abstract reading.
- `roleset`: the PropBank identifier before the source's descriptive gloss.
- `concreteness`: concrete or abstract reading.

The two descriptions of a sense use different argument nouns. The annotation identifies their intended reading; it does not establish that every participant adopted precisely the same interpretation. Sentences nest within these annotated senses and verbs. Participants cross sentences.

## Reproduction and attribution

`provenance.json` records the public repository revision, hashes of the two source CSVs, filters, and hashes of both teaching tables. From the extracted assignment directory, `Rscript scripts/prepare_data.R` rebuilds the tables from the pinned public files. The script also accepts a local repository path.

Attribution: Aaron Steven White, Scott Grimm, and Lelia Glass (2026), *Aspect is not a fixed property of linguistic expressions*, Experiments in Linguistic Meaning. Adaptation: select contentful episodic trials, retain response categories, construct sense and sentence IDs, relabel participants consistently, and omit unused fields. The source and adapted tables are distributed under CC BY-SA 4.0.
