# Data for Problem Set 4

The teaching tables adapt public numerical data and materials from Judith Degen and Judith Tonhauser's projective-probability repository, pinned at commit e4b672a3068820458f42dfb7a4b70d417a887bc5:
https://github.com/judith-tonhauser/projective-probability/tree/e4b672a3068820458f42dfb7a4b70d417a887bc5.

The source CSVs already implement the authors' participant exclusions. The adaptation omits control trials, demographics, free text comments, reaction times, and platform identifiers. Participant labels are replaced separately in each experiment and do not support linking people across experiments. No response is dichotomized, nudged, or averaged. provenance.json records the source and teaching file SHA256 checksums. scripts/prepare_data.R reproduces the transformation.

## inference-choices.csv

8,720 target judgments from 436 participants, twenty predicates, and twenty complement contents. Every participant contributes twenty judgments. yes is 1 for a recorded Yes and 0 for No. predicate retains the released predicate label. content aligns complement contents across predicates. It is not a complete sentence identifier: sentences also contain a predicate and names.

Source: results/8-projectivity-no-fact-binary/data/cd.csv. This is Experiment 1b of Degen and Tonhauser (2022), Are there factive predicates? An empirical investigation, Language 98(3), 552–591, https://doi.org/10.1353/lan.0.0271. Participants judged whether a questioner was certain of the complement content, without the preceding prior probability facts used in the slider experiment below.

## projection-ratings.csv

5,320 target slider judgments from 266 participants, twenty predicates, and twenty complement contents. Every participant contributes twenty judgments. rating retains the recorded value on [0,1], including 643 zeros and 219 ones. prior_condition is factL or factH for the lower or higher prior probability fact associated with that content. There are 2,660 judgments in each condition. This is an experimental condition label, not a normed probability or a participant's own prior rating.

Source: results/3-projectivity/data/cd.csv. This is Experiment 2b of Degen and Tonhauser (2021), Prior beliefs modulate projection, Open Mind 5, 59–70, https://doi.org/10.1162/opmi_a_00042. The response measures attributed certainty in a complement after a clause-embedding question and preceding fact. Both experiments ask about speaker certainty, but differ in preceding context and response format. They were collected separately and are not a randomized comparison of binary versus continuous response formats.

## contents.csv

A crosswalk from anonymous content IDs to the twenty complement contents, with the source's apostrophe escape sequence decoded. Content IDs are shared across the two teaching tables. Predicates are crossed with contents; forty fact/content combinations in the slider study comprise two contexts for each of twenty contents. They are not forty unrelated content replications.

## Attribution and source terms

Cite both original papers and the repository when using these tables. The repository does not include a general license covering these source CSVs. This adaptation does not assert a new license over the authors' data or materials. The 2021 article itself is published under CC BY 4.0; that statement is not used to relicense the separate repository. No article text, figures, or model code is distributed in this package.
