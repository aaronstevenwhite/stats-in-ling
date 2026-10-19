# Describing what happens

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Describing what happens

Source note: `foundations/index.qmd`

Welcome to Describing what happens. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: From linguistic records to probabilities

Source note: `foundations/index.qmd`

Next, we take up From linguistic records to probabilities.

## Slide 3: From linguistic records to probabilities

Source note: `foundations/index.qmd`

A linguistic record does not determine its own statistical unit. An audio file may contain many word and vowel tokens; a vowel token may in turn contain a duration, a fundamental frequency, and a formant trajectory. Treating any one of these objects as a row produces a different dataset from the same record.

## Slide 4: From linguistic records to probabilities

Source note: `foundations/index.qmd`

This choice creates the **representation problem (RP)**: before we count anything, we must decide what one row represents and which differences among speakers, items, and tokens remain visible. The same problem arises with every kind of linguistic data. A corpus can be divided into documents, sentences, word tokens, or word types. A reading-time experiment can retain one row for each trial or average those trials by participant or sentence.

## Slide 5: From linguistic records to probabilities

Source note: `foundations/index.qmd`

We identify the observations and comparisons before assigning probability to outcomes and events.

## Slide 6: Linguistic data and comparisons

Source note: `foundations/index.qmd`

First, we turn linguistic records into data. Once we distinguish a record from the observations extracted from it, we can state what each row represents, which columns identify it, and which speakers or words occur in more than one row.

## Slide 7: Linguistic data and comparisons

Source note: `foundations/index.qmd`

Second, we turn a research question into a comparison. A numerical contrast is not interpretable until we know which response was measured, how the conditions differed, and whether participants and sentence items occurred in both conditions. These facts determine which difference we have estimated.

## Slide 8: Linguistic data and comparisons

Source note: `foundations/index.qmd`

Third, we work through Zipf's law by counting word tokens, grouping them into types, ordering the types by frequency, and comparing the observed counts with an inverse rank function. A rank frequency function may describe a corpus well, but that fit does not tell us which process produced the corpus.

## Slide 9: Probability

Source note: `foundations/index.qmd`

Now we can state the probability question. What results can the observation process produce, which groupings of those results matter, and how much probability should each grouping receive? A sample space is the set of possible outcomes represented by the model. An event is a set of those outcomes. The outcome definition and the event definition must both follow from the linguistic record and the target comparison.

## Slide 10: Probability

Source note: `foundations/index.qmd`

We do not always assign probabilities to every subset of the sample space. A sigma-algebra specifies which events are measurable. We construct generated event spaces from attested linguistic features, then define a probability measure that assigns a probability to each measurable event. The sample space, sigma-algebra, and probability measure form the probability space

$$
\langle\Omega,\mathcal{F},\mathbb{P}\rangle.
$$

## Slide 11: Probability

Source note: `foundations/index.qmd`

Once the probability space is defined, we can calculate probabilities for relations among events. We begin with mutually exclusive events, whose intersection is empty, and introduce the standard comma notation for joint probabilities. We then define conditional probability by restricting probability to a conditioning event. The chain rule follows by rearranging that definition, and Bayes' rule follows by factoring the same joint probability in two orders. We conclude with independence: its conditional interpretation is invariance under conditioning, and its unrestricted definition is the product factorization.

## Slide 12: Probability

Source note: `foundations/index.qmd`

The chapter dependency graph shows which later chapters use these definitions. The order matters: each page adds one object that the next page assumes. Begin by deciding what one linguistic observation represents.

## Slide 13: Turning linguistic records into data

Source note: `foundations/linguistic-data.qmd`

Next, we take up Turning linguistic records into data.

## Slide 14: Hillenbrand et al. (1995): the empirical object

Source note: `foundations/linguistic-data.qmd`

The data source is Hillenbrand et al. (1995). It provides American English /hVd/ vowel tokens with acoustic measurements.

## Slide 15: Turning linguistic records into data

Source note: `foundations/linguistic-data.qmd`

What, exactly, is one datum in an acoustic study? We call the decision that answers this question **unit choice**. A record, such as an audio file, may contain several candidate observations, and several records may contribute to one speaker-level summary. Thus file count does not determine sample size.

## Slide 16: Turning linguistic records into data

Source note: `foundations/linguistic-data.qmd`

We make unit choice concrete with Hillenbrand et al.'s (1995) study of American English vowels. The study recorded 45 men, 48 women, and 46 children producing 12 vowels in /hVd/ words, measured duration and formant contours, and asked listeners to identify the intended vowels. The complete teaching table is the audited `phonTools::h95` table from package version 0.2-2.2 under the package's BSD-2-Clause license. One row is one /hVd/ vowel token from one speaker; each speaker contributes one token for each vowel. The package imputed 10 originally missing F2 values and 41 originally missing F3 values, so this table cannot be used to study the release's natural missingness. The data record gives the source, preprocessing, license, and checksum.

## Slide 17: Unit and observation key

Source note: `foundations/linguistic-data.qmd`

The **unit of observation** is the entity represented by one row. Here it is one vowel token, not one speaker and not one acoustic measurement considered apart from its token. We use **observation key** for the smallest set of columns that identifies a row. The pair

$$
\langle\text{speaker ID},\text{vowel}\rangle
$$

is the key in this table.

## Slide 18: Unit and observation key

Source note: `foundations/linguistic-data.qmd`

Row uniqueness distinguishes tokens; repeated speaker IDs reveal tokens that share a talker.

## Slide 19: What aggregation removes

Source note: `foundations/linguistic-data.qmd`

To see what aggregation changes, compare the token table with speaker-by-vowel means and vowel means. In this design, the first aggregation happens to preserve one row per speaker and vowel because there is one token in each cell. The second collapses 139 speakers to one row per vowel.

## Slide 20: What aggregation removes

Source note: `foundations/linguistic-data.qmd`

Once we replace the speaker-specific rows with vowel means, the resulting table cannot show how speakers vary. That information has been removed before a statistical model sees the data.

## Slide 21: Raw tokens and summaries

Source note: `foundations/linguistic-data.qmd`

The figure shows the raw F1 measurements for *heed* /i/ and *hid* /ɪ/ (`i` and `I` in the release). The paired lines preserve the fact that each speaker produced both vowels; the accent points are vowel means, not additional observations.

## Slide 22: Raw tokens and summaries

Source note: `foundations/linguistic-data.qmd`

Each gray point is a vowel token; lines join tokens from the same speaker. Blue diamonds show means across speakers.

## Slide 23: Tokens and types

Source note: `foundations/linguistic-data.qmd`

A **token** is an occurrence in a particular context; a **type** groups occurrences that the analysis treats as equivalent. The table contains 1668 vowel tokens and 12 vowel-category types. A study of within-category acoustic variation needs the tokens. A descriptive inventory of which categories were elicited may use the types.

## Slide 24: Tokens and types

Source note: `foundations/linguistic-data.qmd`

The grouping follows from the linguistic question. The same principle holds for words: occurrences of *runs* are distinct tokens, one word-form type, and perhaps members of the lemma *run*. No representation is preferable without a target question.

## Slide 25: Measurement, analysis, and generalization

Source note: `foundations/linguistic-data.qmd`

Before plotting or modeling, finish this sentence: > One observation represents ______.

## Slide 26: Measurement, analysis, and generalization

Source note: `foundations/linguistic-data.qmd`

State what one observation represents before checking identifiers, repeated units, preprocessing, and replication.

## Slide 27: Measurement, analysis, and generalization

Source note: `foundations/linguistic-data.qmd`

For the present table, one observation represents one speaker's production of one vowel in an /hVd/ word. The response may be duration or a formant measurement, the key is speaker by vowel, and speaker is a repeated grouping variable. Because most speakers were raised in Michigan's Lower Peninsula, these data provide a benchmark for that sampled population rather than a population sample of all American English speakers.

## Slide 28: Measurement, analysis, and generalization

Source note: `foundations/linguistic-data.qmd`

The unit tells us what a row means, while the key tells us which row it is. The next page uses these same records to align a comparison with a phonetic question.

## Slide 29: Turning linguistic records into data: question 1

Source note: `foundations/linguistic-data.qmd`

How many rows belong to each speaker, and why does that make `speaker_id` an incomplete observation key?

## Slide 30: Turning linguistic records into data: answer 1

Source note: `foundations/linguistic-data.qmd`

Every speaker contributes 12 rows, so `speaker_id` repeats and becomes a complete observation key only when paired with `vowel`.

## Slide 31: Turning linguistic records into data: question 2

Source note: `foundations/linguistic-data.qmd`

Create a table with one row per speaker by averaging F1 across vowels. Which phonetic contrast does that aggregation remove?

## Slide 32: Turning linguistic records into data: answer 2

Source note: `foundations/linguistic-data.qmd`

Averaging F1 across vowels leaves one row per speaker but removes the within-speaker vowel contrast that distinguishes productions such as /i/ and /ɪ/.

## Slide 33: Turning linguistic records into data: question 3

Source note: `foundations/linguistic-data.qmd`

Use the data to count the number of tokens and speakers in each `speaker_type`. Which count answers a question about productions, and which answers a question about talkers?

## Slide 34: Turning linguistic records into data: answer 3

Source note: `foundations/linguistic-data.qmd`

The table contains 324 tokens from 27 boys, 228 from 19 girls, 540 from 45 men, and 576 from 48 women; token counts answer questions about productions, whereas distinct-speaker counts answer questions about talkers.

## Slide 35: Turning a question into a comparison

Source note: `foundations/making-sense-of-data.qmd`

The next topic is Turning a question into a comparison.

## Slide 36: Turning a question into a comparison

Source note: `foundations/making-sense-of-data.qmd`

How much higher is F1 in *hid* /ɪ/ than in *heed* /i/ for the speakers in the Hillenbrand study? A numerical subtraction is interpretable only after we align its unit, response, linguistic contrast, comparison, and target. We call failures of this alignment the **comparison-alignment problem**.

## Slide 37: Turning a question into a comparison

Source note: `foundations/making-sense-of-data.qmd`

Hillenbrand et al. (1995) compared vowel acoustics and identification; here we isolate one paired acoustic contrast.

## Slide 38: Response and linguistic contrast

Source note: `foundations/making-sense-of-data.qmd`

The **response** is steady-state F1 in hertz. The predictor is vowel category, restricted to the intended vowels /i/ and /ɪ/. Because each of the 139 speakers produced both vowels, the comparison is within speaker.

## Slide 39: Response and linguistic contrast

Source note: `foundations/making-sense-of-data.qmd`

The response is steady-state first-formant frequency (Hz) for one /hVd/ vowel token. > The response is steady-state first-formant frequency in hertz for one /hVd/ vowel token.

## Slide 40: Response and linguistic contrast

Source note: `foundations/making-sense-of-data.qmd`

The release's F1 values were measured at a time judged maximally steady. They are not trajectories over the full vowel.

## Slide 41: Observations being compared

Source note: `foundations/making-sense-of-data.qmd`

The paired difference for speaker $s$ is

$$
d_s
\equiv
F1_{s,\text{/ɪ/}}-F1_{s,\text{/i/}}.
$$

## Slide 42: Observations being compared

Source note: `foundations/making-sense-of-data.qmd`

This subtraction holds the speaker fixed. Comparing two unpaired vowel means would produce the same difference of sample means in this complete balanced table, but it would discard the design fact that the two measurements came from the same vocal tract.

## Slide 43: Observations being compared

Source note: `foundations/making-sense-of-data.qmd`

The observed mean paired difference is 64.5 Hz, and 95.7% of speakers have a positive difference. Both summaries are computed from speaker-level contrasts, but they answer different questions about magnitude and directional consistency.

## Slide 44: Observations being compared

Source note: `foundations/making-sense-of-data.qmd`

Speaker-level F1 differences for /ɪ/ minus /i/. The blue line marks the observed mean paired difference.

## Slide 45: State the estimand

Source note: `foundations/making-sense-of-data.qmd`

Let $\mu_d$ be the population mean of the within-speaker difference under the elicitation and measurement protocol. The target is

$$
\tau
\equiv
\mu_d
=
\mathbb{E}\!\left[
F1_{s,\text{/ɪ/}}-F1_{s,\text{/i/}}
\right].
$$

## Slide 46: State the estimand

Source note: `foundations/making-sense-of-data.qmd`

The sample mean $\bar d$ estimates this target:

$$
\bar d
\equiv
\frac{1}{S}\sum_{s=1}^{S}d_s.
$$

## Slide 47: State the estimand

Source note: `foundations/making-sense-of-data.qmd`

The displayed difference describes the study's sampled speakers. Generalizing it to new speakers requires an account of how the sampled talkers represent a target population; the original study reports that most were raised in Michigan's Lower Peninsula.

## Slide 48: The same records, a different question

Source note: `foundations/making-sense-of-data.qmd`

The same rows can support at least three distinct questions: (i) how F1 differs between /i/ and /ɪ/, (ii) how duration differs between those vowels, and (iii) whether speakers with larger F1 contrasts also have larger duration contrasts. The first two have acoustic measurements as responses, while the third concerns an association between two speaker-level contrasts. Thus shared records do not imply a shared estimand.

## Slide 49: The same records, a different question

Source note: `foundations/making-sense-of-data.qmd`

Three alignment failures recur in linguistic analysis. First, a token-level dataset may be interpreted as if it contained independent speakers. Second, a predictor may confound the intended contrast with different lexical items or talker groups. Third, evaluation on already observed speakers may be described as prediction for new speakers. None of these failures can be repaired merely by changing the estimator.

## Slide 50: The same records, a different question

Source note: `foundations/making-sense-of-data.qmd`

The mean difference becomes interpretable because the unit, response, within-speaker comparison, and target have been stated. The Zipf page next applies the same discipline to a corpus-level pattern.

## Slide 51: Turning a question into a comparison: question 1

Source note: `foundations/making-sense-of-data.qmd`

Use `pairs` to compute the mean F1 for each vowel and verify the displayed identity for $\bar d$.

## Slide 52: Turning a question into a comparison: answer 1

Source note: `foundations/making-sense-of-data.qmd`

Mean F1 is 411.568 Hz for /i/ and 476.072 Hz for /ɪ/, so the mean of the 139 within-speaker differences is $476.072-411.568=64.504$ Hz.

## Slide 53: Turning a question into a comparison: question 2

Source note: `foundations/making-sense-of-data.qmd`

Replace F1 with `duration_ms`, construct the paired differences, and state the resulting response and estimand.

## Slide 54: Turning a question into a comparison: answer 2

Source note: `foundations/making-sense-of-data.qmd`

With duration as the response, the estimand is the mean within-speaker duration difference, /ɪ/ minus /i/, which is $-55.734$ ms in these data.

## Slide 55: Turning a question into a comparison: question 3

Source note: `foundations/making-sense-of-data.qmd`

Compute the mean F1 difference separately for each `speaker_type`. Why do those descriptive values not by themselves identify age or sex as a cause?

## Slide 56: Turning a question into a comparison: answer 3

Source note: `foundations/making-sense-of-data.qmd`

Mean F1 differences are 74.741 Hz for boys, 41.526 Hz for girls, 86.667 Hz for men, and 47.063 Hz for women; these observational summaries do not isolate age or sex.

## Slide 57: A first pattern: Zipf's law

Source note: `foundations/zipfs-law.qmd`

Now we turn to A first pattern: Zipf's law.

## Slide 58: UD Turkish BOUN: the empirical object

Source note: `foundations/zipfs-law.qmd`

The data source is Türk et al. (2022), UD Turkish BOUN 2.18. It provides manually reviewed Turkish Universal Dependencies tokens.

## Slide 59: A first pattern: Zipf's law

Source note: `foundations/zipfs-law.qmd`

Word types in corpora tend to show a broad inverse relation between frequency and frequency rank. But estimating both quantities from the same counts builds a downward relation into the display. We call this dependence the **same-sample rank problem**.

## Slide 60: A first pattern: Zipf's law

Source note: `foundations/zipfs-law.qmd`

Piantadosi's (2014) critical review demonstrates the problem with the written American National Corpus, separates rank and frequency estimation by splitting tokens, and shows systematic residual structure beyond a Zipf-Mandelbrot curve. The authorized ANC count snapshot is not available in this repository. We thus carry out an explicitly labeled, paper-aligned replication on UD Turkish BOUN release 2.18, pinned at commit `0def94a229dcbc28d32192b0138b560c075c6d87` under CC BY-SA 4.0.

## Slide 61: A first pattern: Zipf's law

Source note: `foundations/zipfs-law.qmd`

Türk et al. (2022) describe the BOUN Treebank and its annotation; Marşan et al. (2022) describe later agglutination-sensitive revisions. The treebank contains written sentences from five Turkish National Corpus registers. Native-speaker linguists manually annotated and cross-checked automatically preprocessed sentences. The prepared table lowercases source surface forms with Turkish dotted and dotless I preserved, and it excludes punctuation, multiword-token range lines, and empty nodes while retaining component syntactic words. One row is one word-form type; `frequency` is its count among non-punctuation syntactic-word tokens. The immediate UD release permits redistribution under CC BY-SA 4.0, though the public documents do not independently expose the upstream Turkish National Corpus permission reported by the paper. The data record gives the checksums and full terms caveat.

## Slide 62: Rank and the descriptive model

Source note: `foundations/zipfs-law.qmd`

Let $f(r)$ be the observed token count of the type assigned rank $r$. Zipf's law supplies the basic inverse form

$$
\widehat f(r)
\equiv
Cr^{-\alpha},
\qquad C>0,\ \alpha>0.
$$

## Slide 63: Rank and the descriptive model

Source note: `foundations/zipfs-law.qmd`

The Zipf-Mandelbrot generalization shifts rank by $\beta$:

$$
\widehat f(r)
\equiv
C(r+\beta)^{-\alpha},
\qquad C>0,\ \alpha>0,\ \beta\geq 0.
$$

## Slide 64: Rank and the descriptive model

Source note: `foundations/zipfs-law.qmd`

Here $f(r)$ is an observed count and $\widehat f(r)$ is a fitted count. The model is a descriptive approximation; matching it does not identify a mechanism of lexical choice, memory, or communication.

## Slide 65: Separate rank and frequency estimation

Source note: `foundations/zipfs-law.qmd`

Following Piantadosi (2014), we use a fixed binomial token split. One count part assigns ranks and the other estimates relative frequency. The random split is a computational device applied to the observed Turkish counts, not a new linguistic dataset. It also does not repair sentence or register dependence because the aggregate table lacks document identifiers.

## Slide 66: Separate rank and frequency estimation

Source note: `foundations/zipfs-law.qmd`

We fit the curve as a multinomial model over the finite ranked inventory, following Piantadosi's analysis. For $V$ observed word-form types, the model assigns rank $r$ probability

$$
p(r\mid\alpha,\beta)
\equiv
\frac{(r+\beta)^{-\alpha}}
{\sum_{j=1}^{V}(j+\beta)^{-\alpha}}.
$$

## Slide 67: Separate rank and frequency estimation

Source note: `foundations/zipfs-law.qmd`

If $n_r$ is the frequency-half count at rank $r$, maximizing the multinomial likelihood is equivalent to maximizing

$$
\ell(\alpha,\beta)
\equiv
\sum_{r=1}^{V}n_r\log p(r\mid\alpha,\beta).
$$

## Slide 68: Separate rank and frequency estimation

Source note: `foundations/zipfs-law.qmd`

The ranks come from one half and the counts from the other, which removes the same-count error that Piantadosi identifies. Types with zero frequency-half counts remain in the model support even though they cannot appear on a logarithmic plot.

## Slide 69: Separate rank and frequency estimation

Source note: `foundations/zipfs-law.qmd`

The fitted exponent is 0.77 and the fitted rank shift is 0.001. These parameters describe this tokenization of this treebank release; they are not estimates for Turkish as a whole.

## Slide 70: Separate rank and frequency estimation

Source note: `foundations/zipfs-law.qmd`

Turkish BOUN word-form frequencies. Ranks and relative frequencies are estimated from separate fixed token splits; the blue line is the fitted Zipf-Mandelbrot curve.

## Slide 71: Inspect the residual structure

Source note: `foundations/zipfs-law.qmd`

Define the log residual by

$$
e(r)
\equiv
\log f(r)-\log\widehat f(r).
$$

## Slide 72: Inspect the residual structure

Source note: `foundations/zipfs-law.qmd`

If the curve captured all systematic structure, residuals would fluctuate without an ordered pattern around zero. The restrained residual plot lets the data, rather than a callout, show where the approximation misses.

## Slide 73: Inspect the residual structure

Source note: `foundations/zipfs-law.qmd`

Ordered residuals from the fitted Zipf-Mandelbrot curve. The horizontal line marks zero residual.

## Slide 74: Inspect the residual structure

Source note: `foundations/zipfs-law.qmd`

The broad decline and the residual structure coexist. This is Piantadosi's description-explanation gap: a simple curve may summarize much of the distribution while providing weak evidence for any particular mechanism that can generate it.

## Slide 75: Inspect the residual structure

Source note: `foundations/zipfs-law.qmd`

This replication has two limits. First, BOUN is a five-register treebank, not a balanced probability sample of Turkish usage. Second, the aggregate frequency table permits a token split but not a document-level split, so discourse clustering remains. The result licenses a claim about represented word-form counts, not about a universal law of Turkish.

## Slide 76: Inspect the residual structure

Source note: `foundations/zipfs-law.qmd`

The next page moves from the whole word-form inventory to an audited token extract and defines a finite probability experiment.

## Slide 77: A first pattern: Zipf's law: question 1

Source note: `foundations/zipfs-law.qmd`

Which ten word forms are most frequent in the observed Turkish BOUN release, and what are their counts?

## Slide 78: A first pattern: Zipf's law: answer 1

Source note: `foundations/zipfs-law.qmd`

The ten most frequent forms are *bir* 2,746, *ve* 2,045, *bu* 1,258, *de* 836, *ki* 787, *da* 786, *için* 591, *çok* 485, *o* 450, and *gibi* 411.

## Slide 79: A first pattern: Zipf's law: question 2

Source note: `foundations/zipfs-law.qmd`

Recompute ordinary same-sample ranks from `frequency`. Why are those ranks mathematically dependent on the plotted frequencies?

## Slide 80: A first pattern: Zipf's law: answer 2

Source note: `foundations/zipfs-law.qmd`

Ordinary ranks are deterministic order statistics of `frequency`, so the plotted rank and frequency reuse the same counts and are mathematically dependent.

## Slide 81: A first pattern: Zipf's law: question 3

Source note: `foundations/zipfs-law.qmd`

Use `rank_frequency` to find the type with the largest absolute log residual. What does that residual establish, and what does it not establish about a generating mechanism?

## Slide 82: A first pattern: Zipf's law: answer 3

Source note: `foundations/zipfs-law.qmd`

The largest absolute log residual belongs to *olanak* at split rank 32,474, with residual 3.119; this establishes that the fitted curve underpredicts that split count, not that any particular mechanism generated it.

## Slide 83: A first pattern: Zipf's law: question 4

Source note: `foundations/zipfs-law.qmd`

Explain why lowercasing and excluding punctuation change both the type inventory and the rank assignment.

## Slide 84: A first pattern: Zipf's law: answer 4

Source note: `foundations/zipfs-law.qmd`

Lowercasing merges case-distinguished strings, while punctuation removal deletes types and tokens; both operations change counts and thus the ordering that defines frequency rank.

## Slide 85: Sample spaces

Source note: `foundations/possibilities-and-events.qmd`

The next topic is Sample spaces.

## Slide 86: Sample spaces

Source note: `foundations/possibilities-and-events.qmd`

We sample one annotated interrogative-pronoun token from a finite corpus extract. What, exactly, can happen? The **outcome-representation problem** is the need to decide whether an outcome is a token, a surface form, a lemma, or an annotated lemma-relation combination before assigning probabilities.

## Slide 87: Sample spaces

Source note: `foundations/possibilities-and-events.qmd`

We use the UD Turkish BOUN source introduced on the Zipf page. The teaching extract retains tokens whose annotated lemma is *hangi* ‘which’, *kim* ‘who’, or *ne* ‘what’ and whose Universal Dependencies relation is `nsubj` or `obj`. One row is one annotated token nested in a sentence. The preparation filters source annotations and adds binary indicators; it does not infer filler-gap dependencies or recode relations. This finite extract contains 167 tokens.

## Slide 88: Outcomes and the sample space

Source note: `foundations/possibilities-and-events.qmd`

Basically, an outcome is one represented result, and a sample space collects every result the probability experiment allows. More specifically, an **outcome** is one possible result represented by a probability model. The **sample space** $\Omega$ is the set of all such outcomes.

## Slide 89: Outcomes and the sample space

Source note: `foundations/possibilities-and-events.qmd`

Our experiment is uniform sampling of one row from the finite extract. If $N$ is the number of retained rows, then

$$
\Omega
\equiv
\{\omega_1,\ldots,\omega_N\},
$$

where $\omega_i$ is the token identified by its split, sentence ID, and token ID.

## Slide 90: Outcomes and the sample space

Source note: `foundations/possibilities-and-events.qmd`

The category map

$$
c(\omega_i)
\equiv
\langle L_i,R_i\rangle
$$

records lemma $L_i\in\{\textit{hangi},\textit{kim},\textit{ne}\}$ and dependency relation $R_i\in\{\texttt{nsubj},\texttt{obj}\}$.

## Slide 91: Outcomes and the sample space

Source note: `foundations/possibilities-and-events.qmd`

Every one of the six lemma-relation combinations is attested.

## Slide 92: Outcomes and the sample space

Source note: `foundations/possibilities-and-events.qmd`

This figure shows observed token counts in the six lemma-relation categories of the finite extract.

## Slide 93: Membership and granularity

Source note: `foundations/possibilities-and-events.qmd`

The notation $x\in\Omega$ says that $x$ is a member of the sample space. A row key observed in the extract belongs to $\Omega$; a new string not present as a retained token does not.

## Slide 94: Membership and granularity

Source note: `foundations/possibilities-and-events.qmd`

The statement that the second key is outside $\Omega$ concerns this finite probability experiment. It does not claim that Turkish cannot contain another interrogative-pronoun token.

## Slide 95: Membership and granularity

Source note: `foundations/possibilities-and-events.qmd`

Changing granularity changes the sample space. If outcomes were lemma types, the space would contain the three observed lemmas. If outcomes were lemma-relation categories, it would contain six observed categories. Neither space preserves sentence-level identity. We keep token outcomes because the empirical measure on later pages counts rows while retaining the sentence and register identifiers that reveal dependence.

## Slide 96: Omission and impossibility

Source note: `foundations/possibilities-and-events.qmd`

An omitted outcome is not an impossible linguistic result. The extract excludes interrogatives in relations other than `nsubj` and `obj`, and it excludes other interrogative lemmas. Thus its sample space describes a restricted annotated population. It is not an inventory of every interrogative expression in Turkish.

## Slide 97: Omission and impossibility

Source note: `foundations/possibilities-and-events.qmd`

This restriction has a useful consequence and a serious limit. It gives a transparent finite experiment for probability calculations, but it licenses only statements about uniform sampling from the retained extract. Sentences, not isolated tokens, were sampled from five registers, and the treebank is not a probability sample of Turkish usage.

## Slide 98: Omission and impossibility

Source note: `foundations/possibilities-and-events.qmd`

$\Omega$ records the model's answer to “what could happen?” The next page groups these token outcomes into events that answer linguistic questions.

## Slide 99: Sample spaces: question 1

Source note: `foundations/possibilities-and-events.qmd`

Use `wh` to give the observation key for the first token. Which three columns form it?

## Slide 100: Sample spaces: answer 1

Source note: `foundations/possibilities-and-events.qmd`

The first observation key is `train:ess_1258:2`, formed from `split`, `sentence_id`, and `token_id`.

## Slide 101: Sample spaces: question 2

Source note: `foundations/possibilities-and-events.qmd`

Use `category_counts` to identify the least frequent lemma-relation category. Does its low count make it absent from $\Omega$?

## Slide 102: Sample spaces: answer 2

Source note: `foundations/possibilities-and-events.qmd`

The least frequent category is *hangi*-`obj`, with one token; its low count does not remove that observed token from $\Omega$.

## Slide 103: Sample spaces: question 3

Source note: `foundations/possibilities-and-events.qmd`

Construct the sample space of observed lemma types. Which information in the token outcome space does this coarser space discard?

## Slide 104: Sample spaces: answer 3

Source note: `foundations/possibilities-and-events.qmd`

The coarser sample space is $\{\textit{hangi},\textit{kim},\textit{ne}\}$, which discards token identity, sentence and register information, and dependency relation.

## Slide 105: Sample spaces: question 4

Source note: `foundations/possibilities-and-events.qmd`

Why would adding all Turkish interrogative forms to the list, without adding observations, define a different probability experiment?

## Slide 106: Sample spaces: answer 4

Source note: `foundations/possibilities-and-events.qmd`

Adding unobserved Turkish interrogative forms would enlarge the declared sample space beyond the 167 retained token outcomes and thus define a different probability experiment.

## Slide 107: Events

Source note: `foundations/events.qmd`

Our next step is Events.

## Slide 108: Events

Source note: `foundations/events.qmd`

Most linguistic questions do not ask which exact token was sampled. They ask whether that token has a property. We represent such a question by collecting all token outcomes that make its answer “yes.”

## Slide 109: Events

Source note: `foundations/events.qmd`

An **event** is a subset of the sample space. Once a sigma-algebra $\mathcal F$ has been specified, the measurable events are exactly its members.

## Slide 110: Lemma and relation events

Source note: `foundations/events.qmd`

Let $N$ be the event that the sampled token's annotated lemma is *ne*, and let $O$ be the event that its annotated dependency relation is `obj`:

$$
N
\equiv
\{\omega\in\Omega:L(\omega)=\textit{ne}\},
$$

$$
O
\equiv
\{\omega\in\Omega:R(\omega)=\texttt{obj}\}.
$$

## Slide 111: Lemma and relation events

Source note: `foundations/events.qmd`

These definitions use properties of tokens to identify subsets of $\Omega$.

## Slide 112: Intersection, union, and complement

Source note: `foundations/events.qmd`

The intersection contains tokens in both events:

$$
N\cap O
\equiv
\{\omega\in\Omega:\omega\in N\text{ and }\omega\in O\}.
$$

## Slide 113: Intersection, union, and complement

Source note: `foundations/events.qmd`

The union contains tokens in either event or both:

$$
N\cup O
\equiv
\{\omega\in\Omega:\omega\in N\text{ or }\omega\in O\}.
$$

## Slide 114: Intersection, union, and complement

Source note: `foundations/events.qmd`

The complement contains tokens outside an event:

$$
N^c
\equiv
\Omega\setminus N.
$$

## Slide 115: Intersection, union, and complement

Source note: `foundations/events.qmd`

The intersection contains 112 tokens. The union contains 151 tokens, which is smaller than the sum of the two event sizes because tokens in $N\cap O$ would otherwise be counted twice.

## Slide 116: Intersection, union, and complement

Source note: `foundations/events.qmd`

This figure shows counts in the four nonoverlapping atoms formed by the *ne* and `obj` events.

## Slide 117: Membership and limiting events

Source note: `foundations/events.qmd`

For a particular token outcome $\omega_i$, either $\omega_i\in N$ or $\omega_i\notin N$. The realized outcome also determines whether $N$ and $O$ co-occur: both occur exactly when $\omega_i\in N\cap O$.

## Slide 118: Membership and limiting events

Source note: `foundations/events.qmd`

Two events delimit every event space. The impossible event contains no outcomes,

$$
\varnothing,
$$

whereas the certain event contains every outcome,

$$
\Omega.
$$

## Slide 119: Membership and limiting events

Source note: `foundations/events.qmd`

Every event satisfies

$$
\varnothing\subseteq E\subseteq\Omega.
$$

## Slide 120: Membership and limiting events

Source note: `foundations/events.qmd`

The event definitions are empirical in content but formal in structure. Their observed sizes come from the table; the set operations do not depend on those sizes.

## Slide 121: Membership and limiting events

Source note: `foundations/events.qmd`

Events turn linguistic properties into subsets of token outcomes. The next page asks which collections of these subsets can receive probabilities coherently.

## Slide 122: Events: question 1

Source note: `foundations/events.qmd`

Use the displayed event objects to compute $|N\setminus O|$ and interpret that event linguistically.

## Slide 123: Events: answer 1

Source note: `foundations/events.qmd`

$|N\setminus O|=35$; these are retained *ne* tokens annotated `nsubj` rather than `obj`.

## Slide 124: Events: question 2

Source note: `foundations/events.qmd`

Verify in R that $N\cap O=O\cap N$ and $N\cup O=O\cup N$.

## Slide 125: Events: answer 2

Source note: `foundations/events.qmd`

R returns identical sets for `intersect(N, O)` and `intersect(O, N)`, and likewise for the two orders of `union()`, verifying commutativity.

## Slide 126: Events: question 3

Source note: `foundations/events.qmd`

Use `wh` to define the event $K$ that the lemma is *kim*. Are $K$ and $N$ mutually exclusive in this token experiment?

## Slide 127: Events: answer 3

Source note: `foundations/events.qmd`

The *kim* event $K$ and the *ne* event $N$ are mutually exclusive because `intersect(K, N)` contains no token.

## Slide 128: Events: question 4

Source note: `foundations/events.qmd`

Explain why $N^c$ means “retained tokens whose lemma is not *ne*,” not “all non-*ne* words in Turkish.”

## Slide 129: Events: answer 4

Source note: `foundations/events.qmd`

$N^c$ is defined relative to the retained sample space $\Omega$, so it contains the 20 retained non-*ne* tokens rather than every non-*ne* word in Turkish.

## Slide 130: Sigma-algebras

Source note: `foundations/event-spaces.qmd`

The next topic is Sigma-algebras.

## Slide 131: Sigma-algebras

Source note: `foundations/event-spaces.qmd`

If a model assigns a probability to the event that a token has lemma *ne*, which other events must it measure? It must include the complement, and it must keep unions of measurable events available. We call this requirement the **closure problem**.

## Slide 132: Sigma-algebras

Source note: `foundations/event-spaces.qmd`

Basically, we solve the closure problem by collecting events in a way that never strands us without a required complement or union. More specifically, a **sigma-algebra**, also called an event space, is a collection $\mathcal F$ that contains the sample space and is closed under complements and countable unions.

## Slide 133: A one-generator event space

Source note: `foundations/event-spaces.qmd`

The sigma-algebra generated by $N$ is

$$
\mathcal F_N
\equiv
\sigma(N)
=
\{\varnothing,N,N^c,\Omega\}.
$$

## Slide 134: A one-generator event space

Source note: `foundations/event-spaces.qmd`

It contains exactly the unions of the two atoms $N$ and $N^c$. This event space can represent whether the lemma is *ne*, but it cannot distinguish *hangi* from *kim* inside $N^c$.

## Slide 135: Closure requirements

Source note: `foundations/event-spaces.qmd`

A collection $\mathcal F$ is a sigma-algebra only if: $\Omega\in\mathcal F$. if $B\in\mathcal F$, then $B^c\in\mathcal F$. if $B_1,B_2,\ldots\in\mathcal F$, then $\bigcup_iB_i\in\mathcal F$.

## Slide 136: Closure requirements

Source note: `foundations/event-spaces.qmd`

The impossible event follows from the first two requirements:

$$
\Omega^c=\varnothing\in\mathcal F.
$$

## Slide 137: Closure requirements

Source note: `foundations/event-spaces.qmd`

Intersections follow from complements and unions by De Morgan's law:

$$
B\cap C=(B^c\cup C^c)^c.
$$

## Slide 138: Closure requirements

Source note: `foundations/event-spaces.qmd`

Thus closure under complements and countable unions also gives closure under intersections.

## Slide 139: Two generators and their atoms

Source note: `foundations/event-spaces.qmd`

The events $N$ and $O$ split the observed token space into the four nonempty atoms

$$
N\cap O,
\quad
N\cap O^c,
\quad
N^c\cap O,
\quad
N^c\cap O^c.
$$

## Slide 140: Two generators and their atoms

Source note: `foundations/event-spaces.qmd`

Every event in $\sigma(N,O)$ is a union of these atoms.

## Slide 141: Two generators and their atoms

Source note: `foundations/event-spaces.qmd`

The observed generators produce 4 nonempty atoms and thus 16 measurable unions. These values are derived from the attested cross-classification rather than stipulated for instruction.

## Slide 142: Two generators and their atoms

Source note: `foundations/event-spaces.qmd`

This figure shows empirical sizes of the atoms that generate the event space.

## Slide 143: A collection that fails closure

Source note: `foundations/event-spaces.qmd`

Consider

$$
\mathcal G\equiv\{\Omega,N\}.
$$

## Slide 144: A collection that fails closure

Source note: `foundations/event-spaces.qmd`

It contains $\Omega$, but it omits $N^c$ and $\varnothing$. Thus it is not a sigma-algebra. Adding those two required events yields $\mathcal F_N$.

## Slide 145: A collection that fails closure

Source note: `foundations/event-spaces.qmd`

For finite examples, we often use the power set $2^\Omega$ as a modeling choice.

## Slide 146: A collection that fails closure

Source note: `foundations/event-spaces.qmd`

$\Omega$ lists outcomes, while $\mathcal F$ lists outcome groupings that can receive probabilities. The next page constructs the smallest event space forced by a richer set of linguistic distinctions.

## Slide 147: Sigma-algebras: question 1

Source note: `foundations/event-spaces.qmd`

Starting from $\{\Omega,N\}$, name the two events closure requires.

## Slide 148: Sigma-algebras: answer 1

Source note: `foundations/event-spaces.qmd`

Starting from $\{\Omega,N\}$, closure adds $N^c$ and $\varnothing$, yielding $\{\varnothing,N,N^c,\Omega\}$.

## Slide 149: Sigma-algebras: question 2

Source note: `foundations/event-spaces.qmd`

Use `atom_counts` to identify the largest atom. Which lemma and relation properties define it?

## Slide 150: Sigma-algebras: answer 2

Source note: `foundations/event-spaces.qmd`

The largest atom is $N\cap O$, the 112 tokens whose lemma is *ne* and whose dependency relation is `obj`.

## Slide 151: Sigma-algebras: question 3

Source note: `foundations/event-spaces.qmd`

Why does a singleton token subset fail to belong to $\mathcal F_N$ even though it belongs to $2^\Omega$?

## Slide 152: Sigma-algebras: answer 3

Source note: `foundations/event-spaces.qmd`

A singleton token is in $2^\Omega$ but not in $\mathcal F_N$ because $\mathcal F_N$ distinguishes only the complete *ne* and non-*ne* atoms, not individual tokens.

## Slide 153: Sigma-algebras: question 4

Source note: `foundations/event-spaces.qmd`

Use De Morgan's law to express $N\cap O$ using only complements and a union.

## Slide 154: Sigma-algebras: answer 4

Source note: `foundations/event-spaces.qmd`

De Morgan's law gives $N\cap O=(N^c\cup O^c)^c$.

## Slide 155: Generating sigma-algebras

Source note: `foundations/generating-event-spaces.qmd`

Next, we take up Generating sigma-algebras.

## Slide 156: Generating sigma-algebras

Source note: `foundations/generating-event-spaces.qmd`

Suppose we want to assign probabilities to the full three-way lemma distinction and the two-way dependency-relation distinction. What is the smallest sigma-algebra that supports both questions? We call finding that collection the **generation problem**.

## Slide 157: Generating sigma-algebras

Source note: `foundations/generating-event-spaces.qmd`

For a collection $\mathcal C$ of subsets of $\Omega$,

$$
\sigma(\mathcal C)
$$

denotes the smallest sigma-algebra containing every set in $\mathcal C$.

## Slide 158: Generating sigma-algebras

Source note: `foundations/generating-event-spaces.qmd`

The collection $\mathcal C$ is a **generating set**, and $\sigma(\mathcal C)$ is the sigma-algebra it generates.

## Slide 159: Generators and atoms

Source note: `foundations/generating-event-spaces.qmd`

Let $H$, $K$, and $N$ be the lemma events for *hangi*, *kim*, and *ne*, and let $S$ and $O$ be the relation events for `nsubj` and `obj`. The generating collection is

$$
\mathcal C
\equiv
\{H,K,N,S,O\}.
$$

Because the three lemma events partition $\Omega$ and the two relation events partition $\Omega$, the nonempty atoms are the intersections

$$
A_{\ell,r}
\equiv
\{\omega\in\Omega:L(\omega)=\ell,\ R(\omega)=r\}.
$$

## Slide 160: Generators and atoms

Source note: `foundations/generating-event-spaces.qmd`

The empirical cross-classification yields 6 nonempty atoms. Their unions form 64 events in $\sigma(\mathcal C)$. Each union is included because closure requires it, not because it corresponds to a familiar linguistic label.

## Slide 161: Generators and atoms

Source note: `foundations/generating-event-spaces.qmd`

This figure shows token counts in the lemma-by-relation atoms of the generated event space.

## Slide 162: Coarser generators

Source note: `foundations/generating-event-spaces.qmd`

A generator that records only whether the lemma is *ne* produces the two atoms $N$ and $N^c$. It cannot separate *hangi* from *kim*. Adding the object event refines those atoms into the four cells shown on the preceding page. Adding the three-way lemma partition refines the space again into the observed lemma-by-relation cells.

## Slide 163: Coarser generators

Source note: `foundations/generating-event-spaces.qmd`

This gives a finite construction procedure: list the distinctions supplied by the generators. intersect each distinction with the others and their complements. discard empty intersections. take every union of the remaining atoms.

## Slide 164: Coarser generators

Source note: `foundations/generating-event-spaces.qmd`

For a finite sample space, this procedure produces the smallest sigma-algebra containing the chosen generators.

## Slide 165: When a generator adds no distinction

Source note: `foundations/generating-event-spaces.qmd`

If $T$ is the certain event $\Omega$, then adding $T$ to the generating set splits no atom:

$$
\sigma(\mathcal C\cup\{\Omega\})
=
\sigma(\mathcal C).
$$

## Slide 166: When a generator adds no distinction

Source note: `foundations/generating-event-spaces.qmd`

Likewise, adding an event already expressible as a union of the existing atoms does not enlarge the sigma-algebra. What matters is whether the new event divides at least one existing atom.

## Slide 167: When a generator adds no distinction

Source note: `foundations/generating-event-spaces.qmd`

The generated event space preserves only the distinctions named by the generators. It does not license claims about unrepresented interrogative lemmas, non-core relations, or Turkish usage outside the sampled treebank registers.

## Slide 168: When a generator adds no distinction

Source note: `foundations/generating-event-spaces.qmd`

Generators determine the finest distinctions a probability measure can express. The next page assigns empirical mass to those distinctions.

## Slide 169: Generating sigma-algebras: question 1

Source note: `foundations/generating-event-spaces.qmd`

Use `atoms` to identify the smallest atom and inspect its source rows in `wh`.

## Slide 170: Generating sigma-algebras: answer 1

Source note: `foundations/generating-event-spaces.qmd`

The smallest atom is the single *hangi*-`obj` token, `train:ins_1722:2`, whose surface form is *Hangisini*.

## Slide 171: Generating sigma-algebras: question 2

Source note: `foundations/generating-event-spaces.qmd`

If the relation generator is removed, how many nonempty atoms remain in this dataset? Compute the number of unions they generate.

## Slide 172: Generating sigma-algebras: answer 2

Source note: `foundations/generating-event-spaces.qmd`

Removing the relation generator leaves three nonempty lemma atoms, and their unions form $2^3=8$ events.

## Slide 173: Generating sigma-algebras: question 3

Source note: `foundations/generating-event-spaces.qmd`

Show that the event “lemma is not *ne*” is already a union of two lemma atoms and thus adds no new distinction.

## Slide 174: Generating sigma-algebras: answer 3

Source note: `foundations/generating-event-spaces.qmd`

The event ‘lemma is not *ne*’ is the union of the disjoint *hangi* and *kim* atoms, so it introduces no new distinction.

## Slide 175: Generating sigma-algebras: question 4

Source note: `foundations/generating-event-spaces.qmd`

Why would a generator for register enlarge this event space? What dependence warning would then become relevant?

## Slide 176: Generating sigma-algebras: answer 4

Source note: `foundations/generating-event-spaces.qmd`

A register generator would split any lemma-relation atom that occurs across registers; those register clusters would also warn against treating the retained rows as iid usage tokens.

## Slide 177: Probability measures

Source note: `foundations/probability-measures.qmd`

Now we turn to Probability measures.

## Slide 178: Probability measures

Source note: `foundations/probability-measures.qmd`

The sample space $\Omega$ specifies token outcomes, and the sigma-algebra $\mathcal F$ specifies measurable groupings. We now need a numerical assignment that does not contradict those objects. We call this requirement the **coherence problem**.

## Slide 179: Probability measures

Source note: `foundations/probability-measures.qmd`

Basically, a probability measure assigns a number between zero and one to every measurable event. More specifically, a **probability measure** is a function

$$
\mathbb{P}:\mathcal F\rightarrow[0,1]
$$

that satisfies the probability axioms below.

## Slide 180: Probability measures

Source note: `foundations/probability-measures.qmd`

The triple

$$
\langle\Omega,\mathcal F,\mathbb{P}\rangle
$$

is a **probability space**.

## Slide 181: The empirical measure

Source note: `foundations/probability-measures.qmd`

The declared probability experiment samples one token uniformly from the finite extract. For every measurable token event $E$,

$$
\widehat{\mathbb{P}}(E)
\equiv
\frac{|E|}{|\Omega|}.
$$

## Slide 182: The empirical measure

Source note: `foundations/probability-measures.qmd`

Thus every token singleton has mass $1/|\Omega|$, and a linguistic event receives the sum of the masses of its member tokens. For the *ne* event $N$,

$$
\widehat{\mathbb{P}}(N)
=
\frac{1}{|\Omega|}
\sum_{\omega\in\Omega}\mathbf 1\{L(\omega)=\textit{ne}\}.
$$

## Slide 183: The empirical measure

Source note: `foundations/probability-measures.qmd`

This figure shows empirical probability mass assigned to each observed lemma-relation category.

## Slide 184: The three requirements

Source note: `foundations/probability-measures.qmd`

First, every event has nonnegative probability:

$$
\mathbb{P}(B)\geq 0
\qquad\text{for every }B\in\mathcal F.
$$

## Slide 185: The three requirements

Source note: `foundations/probability-measures.qmd`

Second, the full sample space has probability one:

$$
\mathbb{P}(\Omega)=1.
$$

## Slide 186: The three requirements

Source note: `foundations/probability-measures.qmd`

Third, probabilities add across a countable collection of pairwise disjoint events:

$$
\mathbb{P}\!\left(\bigcup_iB_i\right)
=
\sum_i\mathbb{P}(B_i).
$$

## Slide 187: The three requirements

Source note: `foundations/probability-measures.qmd`

The six lemma-relation atoms are nonnegative, disjoint, and exhaustive in this extract. Their empirical masses thus sum to one, as the calculation verifies.

## Slide 188: Consequences of the axioms

Source note: `foundations/probability-measures.qmd`

The impossible event has probability zero. Since $\Omega$ and $\varnothing$ are disjoint and $\Omega\cup\varnothing=\Omega$,

$$
\mathbb{P}(\Omega)
=
\mathbb{P}(\Omega)+\mathbb{P}(\varnothing),
$$

so

$$
\mathbb{P}(\varnothing)=0.
$$

## Slide 189: Consequences of the axioms

Source note: `foundations/probability-measures.qmd`

Likewise, $B$ and $B^c$ are disjoint and exhaustive:

$$
\mathbb{P}(B)+\mathbb{P}(B^c)=1,
$$

and thus

$$
\mathbb{P}(B^c)=1-\mathbb{P}(B).
$$

## Slide 190: Counts are not probabilities

Source note: `foundations/probability-measures.qmd`

The six raw category counts are data-derived nonnegative values, but assigning them directly as event probabilities violates normalization because their sum is the number of tokens rather than one. Dividing every count by the common total produces the empirical mass in the stated identity. This transformation changes the scale while preserving relative mass.

## Slide 191: Counts are not probabilities

Source note: `foundations/probability-measures.qmd`

Uniform row sampling neither makes the source sentences an independent uniform sample nor eliminates annotation error.

## Slide 192: Counts are not probabilities

Source note: `foundations/probability-measures.qmd`

A probability measure is a coherent numerical assignment to measurable events. The next page uses additivity to distinguish mutually exclusive from overlapping linguistic events.

## Slide 193: Probability measures: question 1

Source note: `foundations/probability-measures.qmd`

Compute $\widehat{\mathbb{P}}(L=\textit{kim})$ from the observed *kim* count and the 167 retained tokens.

## Slide 194: Probability measures: answer 1

Source note: `foundations/probability-measures.qmd`

$\widehat{\mathbb{P}}(L=\textit{kim})=17/167=0.101796$.

## Slide 195: Probability measures: question 2

Source note: `foundations/probability-measures.qmd`

Compute its complement both by filtering rows and with the complement rule.

## Slide 196: Probability measures: answer 2

Source note: `foundations/probability-measures.qmd`

The complement of the *kim* event contains 150 rows, so filtering and the complement rule both give $150/167=1-17/167=0.898204$.

## Slide 197: Probability measures: question 3

Source note: `foundations/probability-measures.qmd`

Verify that the three lemma events are pairwise disjoint and exhaustive.

## Slide 198: Probability measures: answer 3

Source note: `foundations/probability-measures.qmd`

The three lemma events have pairwise empty intersections, and their counts sum to $3+17+147=167$, so they are disjoint and exhaustive.

## Slide 199: Probability measures: question 4

Source note: `foundations/probability-measures.qmd`

Explain why the raw count of *ne* tokens is not itself a probability even though it determines the empirical probability after normalization.

## Slide 200: Probability measures: answer 4

Source note: `foundations/probability-measures.qmd`

The raw *ne* count is 147, which is not normalized to $[0,1]$; division by the common total gives the empirical probability $147/167=0.880240$.

## Slide 201: Relations among events

Source note: `foundations/probability-concepts.qmd`

Our next step is Relations among events.

## Slide 202: Relations among events

Source note: `foundations/probability-concepts.qmd`

Whether event probabilities can be added directly depends on how the events overlap. The distinction is structural: two events may be **mutually exclusive**, **exhaustive**, both, or neither.

## Slide 203: Mutually exclusive and exhaustive events

Source note: `foundations/probability-concepts.qmd`

Events $B$ and $C$ are mutually exclusive exactly when

$$
B\cap C=\varnothing.
$$

## Slide 204: Mutually exclusive and exhaustive events

Source note: `foundations/probability-concepts.qmd`

They are exhaustive exactly when

$$
B\cup C=\Omega.
$$

## Slide 205: Mutually exclusive and exhaustive events

Source note: `foundations/probability-concepts.qmd`

Within this extract, the `nsubj` event $S$ and the `obj` event $O$ are mutually exclusive and exhaustive because every retained token has exactly one of those two source relations. Countable additivity thus gives

$$
\mathbb{P}(S\cup O)
=
\mathbb{P}(S)+\mathbb{P}(O)
=1.
$$

## Slide 206: Mutually exclusive and exhaustive events

Source note: `foundations/probability-concepts.qmd`

Mutual exclusivity does not imply exhaustivity. The *hangi* and *kim* lemma events share no token, but their union excludes the *ne* tokens observed in the same extract.

## Slide 207: Overlapping events

Source note: `foundations/probability-concepts.qmd`

The *ne* event $N$ and object event $O$ overlap. For arbitrary events,

$$
\mathbb{P}(B\cup C)
=
\mathbb{P}(B)+\mathbb{P}(C)-\mathbb{P}(B\cap C).
$$

## Slide 208: Overlapping events

Source note: `foundations/probability-concepts.qmd`

The subtracted term repairs the double count of outcomes in the intersection.

## Slide 209: Overlapping events

Source note: `foundations/probability-concepts.qmd`

The intersection has empirical probability 0.671. Thus adding the two marginal probabilities without subtracting the intersection would exceed the probability of their union by exactly that amount.

## Slide 210: Overlapping events

Source note: `foundations/probability-concepts.qmd`

This figure shows empirical masses in the four disjoint cells formed by the *ne* and object events.

## Slide 211: Dependence on the outcome representation

Source note: `foundations/probability-concepts.qmd`

Mutual exclusivity is relative to what one outcome represents. If one outcome is one retained token, the two relation labels are mutually exclusive. If one outcome were a sentence, the events “the sentence contains an `nsubj` interrogative token” and “the sentence contains an `obj` interrogative token” could co-occur. Changing the unit changes the event relation.

## Slide 212: Dependence on the outcome representation

Source note: `foundations/probability-concepts.qmd`

Labels alone do not guarantee mutual exclusivity. The *ne* event is a lemma property, whereas the object event is a syntactic-relation property, so one token may belong to both. The source's annotation schema tells us whether the coded values can co-occur.

## Slide 213: Dependence on the outcome representation

Source note: `foundations/probability-concepts.qmd`

Additivity without an overlap correction is licensed by disjointness, not by the familiarity of the labels. The next page records every intersection in one table.

## Slide 214: Relations among events: question 1

Source note: `foundations/probability-concepts.qmd`

Compute the probability of the union of the *hangi* and *kim* events. Why is no intersection subtraction needed?

## Slide 215: Relations among events: answer 1

Source note: `foundations/probability-concepts.qmd`

$\mathbb{P}(H\cup K)=20/167=0.119760$; no intersection term is needed because a token cannot have both the *hangi* and *kim* lemmas.

## Slide 216: Relations among events: question 2

Source note: `foundations/probability-concepts.qmd`

Verify the union formula for the *kim* and `obj` events.

## Slide 217: Relations among events: answer 2

Source note: `foundations/probability-concepts.qmd`

$\mathbb{P}(K\cup O)=17/167+116/167-3/167=130/167=0.778443$.

## Slide 218: Relations among events: question 3

Source note: `foundations/probability-concepts.qmd`

Do the six observed lemma-relation cell counts show that the three lemma events are exhaustive?

## Slide 219: Relations among events: answer 3

Source note: `foundations/probability-concepts.qmd`

Yes; the counts for *hangi*, *kim*, and *ne* are $3+17+147=167$, exactly the number of retained rows.

## Slide 220: Relations among events: question 4

Source note: `foundations/probability-concepts.qmd`

Describe a sentence-level outcome representation under which `nsubj` and `obj` interrogative events could co-occur.

## Slide 221: Relations among events: answer 4

Source note: `foundations/probability-concepts.qmd`

With one sentence as an outcome, the `nsubj` event and `obj` event could co-occur when that sentence contains one interrogative subject token and another interrogative object token.

## Slide 222: Joint probability

Source note: `foundations/joint-probability-of-events.qmd`

Now we turn to Joint probability.

## Slide 223: Joint probability

Source note: `foundations/joint-probability-of-events.qmd`

The probability that two properties hold of the same sampled token is a **joint probability**. For the *ne* event $N$ and object event $O$, we write

$$
\mathbb{P}(N,O)
\equiv
\mathbb{P}(N\cap O).
$$

## Slide 224: Joint probability

Source note: `foundations/joint-probability-of-events.qmd`

The comma is shorthand for intersection, not an ordering claim: $\mathbb{P}(N,O)=\mathbb{P}(O,N)$.

## Slide 225: The four joint events

Source note: `foundations/joint-probability-of-events.qmd`

The two binary distinctions partition $\Omega$ into

$$
N\cap O,
\quad
N\cap O^c,
\quad
N^c\cap O,
\quad
N^c\cap O^c.
$$

## Slide 226: The four joint events

Source note: `foundations/joint-probability-of-events.qmd`

Their probabilities sum to one because the four events are disjoint and exhaustive:

$$
\mathbb{P}(N,O)
+\mathbb{P}(N,O^c)
+\mathbb{P}(N^c,O)
+\mathbb{P}(N^c,O^c)
=1.
$$

## Slide 227: Marginal probabilities

Source note: `foundations/joint-probability-of-events.qmd`

A **marginal probability** sums over the other distinction. For instance,

$$
\mathbb{P}(N)
=
\mathbb{P}(N,O)+\mathbb{P}(N,O^c),
$$

and

$$
\mathbb{P}(O)
=
\mathbb{P}(N,O)+\mathbb{P}(N^c,O).
$$

## Slide 228: Marginal probabilities

Source note: `foundations/joint-probability-of-events.qmd`

The two margins do not determine the four cells. They report how common each property is separately but not how the properties co-occur.

## Slide 229: Marginal probabilities

Source note: `foundations/joint-probability-of-events.qmd`

This figure shows observed joint probability mass for the *ne* and object indicators.

## Slide 230: Marginal probabilities

Source note: `foundations/joint-probability-of-events.qmd`

The value $\mathbb{P}(N,O)$ is relative to the full finite extract. It does not give the proportion of objects whose lemma is *ne*, because that question uses only the object event as its reference set. The next page changes the denominator explicitly.

## Slide 231: Marginal probabilities

Source note: `foundations/joint-probability-of-events.qmd`

The treebank's sentence sampling and annotation process remain part of the interpretation. These joint probabilities summarize the retained annotated tokens; they do not estimate a context-free grammar of Turkish interrogatives.

## Slide 232: Joint probability: question 1

Source note: `foundations/joint-probability-of-events.qmd`

Use `joint_probability` to compute $\mathbb{P}(N^c,O)$ and interpret it.

## Slide 233: Joint probability: answer 1

Source note: `foundations/joint-probability-of-events.qmd`

$\mathbb{P}(N^c,O)=4/167=0.023952$, the probability that a uniformly sampled retained token is an object with a lemma other than *ne*.

## Slide 234: Joint probability: question 2

Source note: `foundations/joint-probability-of-events.qmd`

Verify both marginalization identities in R.

## Slide 235: Joint probability: answer 2

Source note: `foundations/joint-probability-of-events.qmd`

Summing the *ne* row gives $147/167=0.880240$, and summing the object column gives $116/167=0.694611$, matching the two direct marginals.

## Slide 236: Joint probability: question 3

Source note: `foundations/joint-probability-of-events.qmd`

Why does $\mathbb{P}(N,O)$ not mean “the proportion of object tokens that are *ne*”?

## Slide 237: Joint probability: answer 3

Source note: `foundations/joint-probability-of-events.qmd`

$\mathbb{P}(N,O)$ divides the 112 joint tokens by all 167 retained tokens, whereas the proportion of object tokens that are *ne* divides 112 by the 116 object tokens.

## Slide 238: Joint probability: question 4

Source note: `foundations/joint-probability-of-events.qmd`

Construct the three-by-two lemma-relation joint table directly from `wh` and verify that its cells sum to one after normalization.

## Slide 239: Joint probability: answer 4

Source note: `foundations/joint-probability-of-events.qmd`

The normalized lemma-by-relation cells are 2, 1, 14, 3, 35, and 112 divided by 167, and their probabilities sum to $(2+1+14+3+35+112)/167=1$.

## Slide 240: Conditional probability

Source note: `foundations/conditional-probability.qmd`

Next, we take up Conditional probability.

## Slide 241: Conditional probability

Source note: `foundations/conditional-probability.qmd`

The joint probability $\mathbb{P}(N,O)$ is computed relative to the full token extract. Suppose instead we ask: among tokens whose lemma is *ne*, what proportion are annotated `obj`? The phrase *among the* changes the reference event.

## Slide 242: Conditional probability

Source note: `foundations/conditional-probability.qmd`

Basically, conditioning keeps only the mass inside a reference event and rescales it to sum to one. More specifically, for events $B,C\in\mathcal F$ with $\mathbb{P}(C)>0$, the **conditional probability** of $B$ given $C$ is

$$
\mathbb{P}(B\mid C)
\equiv
\frac{\mathbb{P}(B,C)}{\mathbb{P}(C)}.
$$

## Slide 243: Conditional probability

Source note: `foundations/conditional-probability.qmd`

The denominator identifies the reference event; the numerator identifies the part of that event for which the target event also occurs.

## Slide 244: Conditioning as rescaling

Source note: `foundations/conditional-probability.qmd`

Let $N$ be the *ne* event and $O$ the object event. Then

$$
\mathbb{P}(O\mid N)
=
\frac{\mathbb{P}(O,N)}{\mathbb{P}(N)}.
$$

## Slide 245: Conditioning as rescaling

Source note: `foundations/conditional-probability.qmd`

The empirical value is 0.762. The conditional complement follows from the same rescaling:

$$
\mathbb{P}(O^c\mid N)
=
1-\mathbb{P}(O\mid N).
$$

## Slide 246: Conditioning as rescaling

Source note: `foundations/conditional-probability.qmd`

Conditioning also makes its own reference event certain:

$$
\mathbb{P}(C\mid C)
=
\frac{\mathbb{P}(C,C)}{\mathbb{P}(C)}
=
\frac{\mathbb{P}(C)}{\mathbb{P}(C)}
=1.
$$

## Slide 247: Reversing target and condition

Source note: `foundations/conditional-probability.qmd`

The reversed probability uses the same intersection but a different denominator:

$$
\mathbb{P}(N\mid O)
=
\frac{\mathbb{P}(N,O)}{\mathbb{P}(O)}.
$$

## Slide 248: Reversing target and condition

Source note: `foundations/conditional-probability.qmd`

Its empirical value is 0.966. Thus $\mathbb{P}(O\mid N)$ and $\mathbb{P}(N\mid O)$ answer different linguistic questions even though they share a numerator.

## Slide 249: Reversing target and condition

Source note: `foundations/conditional-probability.qmd`

This figure shows observed dependency-relation proportions within each lemma. Bars rescale separately within lemma.

## Slide 250: Positive-probability conditions

Source note: `foundations/conditional-probability.qmd`

The ratio definition requires $\mathbb{P}(C)>0$. If the conditioning event has zero probability, the denominator is zero and the elementary conditional probability is undefined. All three lemma events have positive mass in the observed extract, as the raw bars show.

## Slide 251: Positive-probability conditions

Source note: `foundations/conditional-probability.qmd`

The conditional values remain descriptions of this filtered treebank population. A difference among lemma-specific object proportions may reflect syntax, lexical semantics, register composition, annotation, or their combination. Conditioning changes a denominator; it does not identify a causal account.

## Slide 252: Positive-probability conditions

Source note: `foundations/conditional-probability.qmd`

Conditioning changes the reference event and renormalizes its mass. The next page rearranges the definition to recover a joint probability from a conditional and a marginal probability.

## Slide 253: Conditional probability: question 1

Source note: `foundations/conditional-probability.qmd`

Compute $\mathbb{P}(O^c\mid N)$ from the raw rows and with the complement rule.

## Slide 254: Conditional probability: answer 1

Source note: `foundations/conditional-probability.qmd`

$\mathbb{P}(O^c\mid N)=35/147=0.238095$, which also equals $1-112/147$.

## Slide 255: Conditional probability: question 2

Source note: `foundations/conditional-probability.qmd`

Compute $\mathbb{P}(O\mid L=\textit{kim})$ and $\mathbb{P}(L=\textit{kim}\mid O)$. Explain their denominators.

## Slide 256: Conditional probability: answer 2

Source note: `foundations/conditional-probability.qmd`

$\mathbb{P}(O\mid L=\textit{kim})=3/17=0.176471$ uses 17 *kim* tokens as its denominator; $\mathbb{P}(L=\textit{kim}\mid O)=3/116=0.025862$ uses 116 object tokens.

## Slide 257: Conditional probability: question 3

Source note: `foundations/conditional-probability.qmd`

Verify directly that conditioning $N$ on itself returns the certain-event probability in the empirical measure.

## Slide 258: Conditional probability: answer 3

Source note: `foundations/conditional-probability.qmd`

$\mathbb{P}(N\mid N)=147/147=1$ because filtering the *ne* rows by the same *ne* condition retains every row.

## Slide 259: Conditional probability: question 4

Source note: `foundations/conditional-probability.qmd`

Which scientific claims remain unsupported by the observed difference among lemma-specific object proportions?

## Slide 260: Conditional probability: answer 4

Source note: `foundations/conditional-probability.qmd`

The observed lemma-specific object proportions do not identify syntax, lexical semantics, register, or annotation as a cause because the treebank did not manipulate or balance those explanations.

## Slide 261: Probability factorization

Source note: `foundations/probability-factorization.qmd`

The next topic is Probability factorization.

## Slide 262: Probability factorization

Source note: `foundations/probability-factorization.qmd`

What proportion of all retained tokens are both *ne* and `obj`? If we know the proportion whose lemma is *ne* and the object proportion within those tokens, the **chain rule** reconstructs the joint probability.

## Slide 263: Probability factorization

Source note: `foundations/probability-factorization.qmd`

Because $\mathbb{P}(N)>0$, begin with conditional probability:

$$
\mathbb{P}(O\mid N)
=
\frac{\mathbb{P}(O,N)}{\mathbb{P}(N)}.
$$

## Slide 264: Probability factorization

Source note: `foundations/probability-factorization.qmd`

Multiply both sides by $\mathbb{P}(N)$:

$$
\mathbb{P}(O,N)
=
\mathbb{P}(O\mid N)\mathbb{P}(N).
$$

## Slide 265: Probability factorization

Source note: `foundations/probability-factorization.qmd`

More generally, for events $B$ and $C$ with $\mathbb{P}(B)>0$,

$$
\mathbb{P}(B,C)
=
\mathbb{P}(B)\mathbb{P}(C\mid B).
$$

## Slide 266: Probability factorization

Source note: `foundations/probability-factorization.qmd`

The empirical factors produce a joint probability of 0.671, exactly matching the directly counted intersection. This agreement is an algebraic identity, not evidence for independence.

## Slide 267: Probability factorization

Source note: `foundations/probability-factorization.qmd`

The marginal *ne* mass is partitioned into its observed `nsubj` and `obj` joint masses.

## Slide 268: Reversing the order

Source note: `foundations/probability-factorization.qmd`

The same joint probability can be factored in the other order:

$$
\mathbb{P}(N,O)
=
\mathbb{P}(O)\mathbb{P}(N\mid O).
$$

## Slide 269: Reversing the order

Source note: `foundations/probability-factorization.qmd`

Thus

$$
\mathbb{P}(O\mid N)\mathbb{P}(N)
=
\mathbb{P}(N\mid O)\mathbb{P}(O).
$$

## Slide 270: Reversing the order

Source note: `foundations/probability-factorization.qmd`

We use this identity to derive Bayes' rule.

## Slide 271: Three-event and general chain rules

Source note: `foundations/probability-factorization.qmd`

For events $B,C,D\in\mathcal F$, with the displayed conditioning events having positive probability, first write

$$
\mathbb{P}(B,C,D)
=
\mathbb{P}(D\mid B,C)\mathbb{P}(B,C),
$$

then factor the remaining joint probability:

$$
\mathbb{P}(B,C)
=
\mathbb{P}(C\mid B)\mathbb{P}(B).
$$

## Slide 272: Three-event and general chain rules

Source note: `foundations/probability-factorization.qmd`

Substitution yields

$$
\mathbb{P}(B,C,D)
=
\mathbb{P}(B)
\mathbb{P}(C\mid B)
\mathbb{P}(D\mid B,C).
$$

## Slide 273: Three-event and general chain rules

Source note: `foundations/probability-factorization.qmd`

Repeating the same move gives the general chain rule:

$$
\mathbb{P}(E_1,\ldots,E_M)
=
\mathbb{P}(E_1)
\prod_{i=2}^{M}
\mathbb{P}(E_i\mid E_1,\ldots,E_{i-1}).
$$

## Slide 274: Three-event and general chain rules

Source note: `foundations/probability-factorization.qmd`

The ordering is arbitrary, but every factor must condition on all preceding events in the chosen order.

## Slide 275: Factorization and dependence

Source note: `foundations/probability-factorization.qmd`

The conditional term retains any dependence between the events. Replacing $\mathbb{P}(O\mid N)$ with $\mathbb{P}(O)$ requires an additional independence assumption; the multiplication sign alone supplies no such assumption.

## Slide 276: Factorization and dependence

Source note: `foundations/probability-factorization.qmd`

The factorization describes the finite annotated extract. It does not show that lemma choice causes dependency relation, nor that the token rows are independent across sentences or registers.

## Slide 277: Factorization and dependence

Source note: `foundations/probability-factorization.qmd`

The chain rule expands a joint probability into ordered conditional factors without assuming independence. The next page solves the two factorizations for a reversed conditional.

## Slide 278: Probability factorization: question 1

Source note: `foundations/probability-factorization.qmd`

Reconstruct $\mathbb{P}(L=\textit{kim},O)$ from $\mathbb{P}(L=\textit{kim})$ and $\mathbb{P}(O\mid L=\textit{kim})$.

## Slide 279: Probability factorization: answer 1

Source note: `foundations/probability-factorization.qmd`

$\mathbb{P}(L=\textit{kim},O)=(17/167)(3/17)=3/167=0.017964$.

## Slide 280: Probability factorization: question 2

Source note: `foundations/probability-factorization.qmd`

Factor the same joint probability in the reverse order and verify equality in R.

## Slide 281: Probability factorization: answer 2

Source note: `foundations/probability-factorization.qmd`

The reverse factorization is $\mathbb{P}(O)\mathbb{P}(L=\textit{kim}\mid O)=(116/167)(3/116)=3/167$, equal to the same joint probability.

## Slide 282: Probability factorization: question 3

Source note: `foundations/probability-factorization.qmd`

Derive the three-event chain rule by applying the two-event rule twice.

## Slide 283: Probability factorization: answer 3

Source note: `foundations/probability-factorization.qmd`

Applying the two-event rule twice gives $\mathbb{P}(B,C,D)=\mathbb{P}(B\mid C,D)\mathbb{P}(C\mid D)\mathbb{P}(D)$ when the conditioning events have positive probability.

## Slide 284: Probability factorization: question 4

Source note: `foundations/probability-factorization.qmd`

Name the extra assumption needed to replace a conditional factor with its marginal counterpart.

## Slide 285: Probability factorization: answer 4

Source note: `foundations/probability-factorization.qmd`

Replacing $\mathbb{P}(O\mid N)$ with $\mathbb{P}(O)$ requires the additional assumption that $O$ and $N$ are independent.

## Slide 286: Bayes' rule

Source note: `foundations/bayes-rule.qmd`

The next topic is Bayes' rule.

## Slide 287: Bayes' rule

Source note: `foundations/bayes-rule.qmd`

The probability that a retained *ne* token is an object and the probability that a retained object token has lemma *ne* reverse the target and reference events. The **conditional-direction problem** is that one cannot be read directly from the other.

## Slide 288: Bayes' rule

Source note: `foundations/bayes-rule.qmd`

Recall the two chain-rule factorizations:

$$
\mathbb{P}(B,C)
=
\mathbb{P}(B\mid C)\mathbb{P}(C)
$$

and

$$
\mathbb{P}(B,C)
=
\mathbb{P}(C\mid B)\mathbb{P}(B).
$$

## Slide 289: Bayes' rule

Source note: `foundations/bayes-rule.qmd`

The left sides name the same intersection, so

$$
\mathbb{P}(B\mid C)\mathbb{P}(C)
=
\mathbb{P}(C\mid B)\mathbb{P}(B).
$$

## Slide 290: Bayes' rule

Source note: `foundations/bayes-rule.qmd`

If $\mathbb{P}(C)>0$, divide by $\mathbb{P}(C)$:

$$
\mathbb{P}(B\mid C)
=
\frac{\mathbb{P}(C\mid B)\mathbb{P}(B)}
{\mathbb{P}(C)}.
$$

## Slide 291: Bayes' rule

Source note: `foundations/bayes-rule.qmd`

This identity is **Bayes' rule**. It reverses the conditional direction while correcting for the two marginal probabilities. No independence assumption is used.

## Slide 292: Reversing the empirical conditional

Source note: `foundations/bayes-rule.qmd`

Let $N$ be the *ne* event and $O$ the object event. Bayes' rule gives

$$
\mathbb{P}(N\mid O)
=
\frac{\mathbb{P}(O\mid N)\mathbb{P}(N)}
{\mathbb{P}(O)}.
$$

## Slide 293: Reversing the empirical conditional

Source note: `foundations/bayes-rule.qmd`

The visible R calculation obtains 0.966. Directly counting *ne* tokens among objects gives the same result, which verifies the identity against the raw rows.

## Slide 294: Reversing the empirical conditional

Source note: `foundations/bayes-rule.qmd`

This figure shows the same joint count appears in both conditional directions, but each probability uses a different denominator.

## Slide 295: Evidence and prevalence

Source note: `foundations/bayes-rule.qmd`

In this calculation, $\mathbb{P}(O\mid N)$ gives the object rate within *ne*, $\mathbb{P}(N)$ gives the prevalence of *ne* in the retained extract, and $\mathbb{P}(O)$ gives the overall object rate. All three quantities are tied to the same finite observation process.

## Slide 296: Evidence and prevalence

Source note: `foundations/bayes-rule.qmd`

The two conditionals may be numerically close or far apart depending on the margins. Their difference is not paradoxical: the shared intersection is divided once by the size of $N$ and once by the size of $O$. Reading the right side of the conditioning bar first identifies the denominator.

## Slide 297: Evidence and prevalence

Source note: `foundations/bayes-rule.qmd`

A potential worry is that the *ne* prevalence in this extract might be treated as a population prevalence for Turkish. It cannot be. The source sampled sentences within five registers, the analysis further selected three lemmas and two relations, and tokens within sentences are dependent. Bayes' rule is exact for the empirical measure, but its inputs describe that measure.

## Slide 298: Evidence and prevalence

Source note: `foundations/bayes-rule.qmd`

Reversing a conditional requires the original conditional and the relevant marginal probabilities. The next page asks when conditioning leaves a probability unchanged.

## Slide 299: Bayes' rule: question 1

Source note: `foundations/bayes-rule.qmd`

Use Bayes' rule to compute $\mathbb{P}(L=\textit{kim}\mid O)$ from the reversed conditional and two margins.

## Slide 300: Bayes' rule: answer 1

Source note: `foundations/bayes-rule.qmd`

$\mathbb{P}(L=\textit{kim}\mid O)=\mathbb{P}(O\mid L=\textit{kim})\mathbb{P}(L=\textit{kim})/\mathbb{P}(O)=(3/17)(17/167)/(116/167)=3/116=0.025862$.

## Slide 301: Bayes' rule: question 2

Source note: `foundations/bayes-rule.qmd`

Verify the result by filtering the raw object rows.

## Slide 302: Bayes' rule: answer 2

Source note: `foundations/bayes-rule.qmd`

Direct filtering finds 3 *kim* tokens among 116 object tokens, again giving $3/116=0.025862$.

## Slide 303: Bayes' rule: question 3

Source note: `foundations/bayes-rule.qmd`

Explain why $\mathbb{P}(O\mid N)$ and $\mathbb{P}(N\mid O)$ share a numerator but not a denominator.

## Slide 304: Bayes' rule: answer 3

Source note: `foundations/bayes-rule.qmd`

Both conditionals use the 112 *ne*-object tokens in the numerator; $\mathbb{P}(O\mid N)$ divides by 147 *ne* tokens, while $\mathbb{P}(N\mid O)$ divides by 116 object tokens.

## Slide 305: Bayes' rule: question 4

Source note: `foundations/bayes-rule.qmd`

Which part of the calculation would change if the represented corpus deliberately oversampled one register?

## Slide 306: Bayes' rule: answer 4

Source note: `foundations/bayes-rule.qmd`

Register oversampling would change the empirical margins and could also change the within-register mixture behind the conditional, so the Bayes calculation would need probabilities appropriate to the target register distribution.

## Slide 307: Independence

Source note: `foundations/independence.qmd`

Now we turn to Independence.

## Slide 308: Independence

Source note: `foundations/independence.qmd`

Does learning that a retained token has lemma *ne* change the probability that it is annotated as an object? The **conditional-invariance question** compares

$$
\mathbb{P}(O)
$$

with

$$
\mathbb{P}(O\mid N).
$$

## Slide 309: Independence

Source note: `foundations/independence.qmd`

Events $B$ and $C$ are **independent** exactly when

$$
\mathbb{P}(B,C)
=
\mathbb{P}(B)\mathbb{P}(C).
$$

## Slide 310: Independence

Source note: `foundations/independence.qmd`

If $\mathbb{P}(C)>0$, this condition is equivalent to

$$
\mathbb{P}(B\mid C)=\mathbb{P}(B).
$$

## Slide 311: The observed comparison

Source note: `foundations/independence.qmd`

Under the empirical measure,

$$
\widehat{\mathbb{P}}(N,O)
\neq
\widehat{\mathbb{P}}(N)\widehat{\mathbb{P}}(O).
$$

## Slide 312: The observed comparison

Source note: `foundations/independence.qmd`

The observed joint mass is 0.671, while the product-of-marginals model assigns 0.611. Equivalently, the overall object probability is 0.695, whereas the object probability among *ne* tokens is 0.762. Thus the two events are not independent in this finite extract.

## Slide 313: Why the characterizations are equivalent

Source note: `foundations/independence.qmd`

Suppose $\mathbb{P}(C)>0$. If

$$
\mathbb{P}(B,C)=\mathbb{P}(B)\mathbb{P}(C),
$$

then

$$
\begin{aligned}
\mathbb{P}(B\mid C)
&=\frac{\mathbb{P}(B,C)}{\mathbb{P}(C)}\\
&=\frac{\mathbb{P}(B)\mathbb{P}(C)}{\mathbb{P}(C)}\\
&=\mathbb{P}(B).
\end{aligned}
$$

## Slide 314: Why the characterizations are equivalent

Source note: `foundations/independence.qmd`

Conversely, if $\mathbb{P}(B\mid C)=\mathbb{P}(B)$, the chain rule gives

$$
\begin{aligned}
\mathbb{P}(B,C)
&=\mathbb{P}(B\mid C)\mathbb{P}(C)\\
&=\mathbb{P}(B)\mathbb{P}(C).
\end{aligned}
$$

## Slide 315: Observed mass and the independence model

Source note: `foundations/independence.qmd`

The product of the empirical margins defines a comparison model:

$$
\widehat{\mathbb{P}}_{\mathrm{ind}}(b,c)
\equiv
\widehat{\mathbb{P}}(b)\widehat{\mathbb{P}}(c).
$$

## Slide 316: Observed mass and the independence model

Source note: `foundations/independence.qmd`

It preserves the observed margins while removing their association. It is a model derived from the linguistic data, not a second invented dataset.

## Slide 317: Observed mass and the independence model

Source note: `foundations/independence.qmd`

This figure shows observed joint probabilities and probabilities under the product-of-observed-marginals independence model.

## Slide 318: Independence is not mutual exclusivity

Source note: `foundations/independence.qmd`

If two positive-probability events are mutually exclusive, then their joint probability is the impossible-event probability while their marginal product is positive. They are thus dependent. Independence means that conditioning does not change probability; mutual exclusivity means that co-occurrence is impossible.

## Slide 319: Independence is not mutual exclusivity

Source note: `foundations/independence.qmd`

Observed dependence also does not identify a causal relation. The association between lemma and dependency relation may reflect the syntactic and semantic distribution of the lemmas, the selected registers, sentence clustering, and annotation choices. The empirical table shows dependence in the represented extract and nothing stronger.

## Slide 320: Independence is not mutual exclusivity

Source note: `foundations/independence.qmd`

Independence is a property of events under a particular probability measure. Changing the corpus population or observation process may change that property.

## Slide 321: Independence: question 1

Source note: `foundations/independence.qmd`

Compute the observed and independence-model probabilities for the *kim*-`obj` cell.

## Slide 322: Independence: answer 1

Source note: `foundations/independence.qmd`

The observed *kim*-`obj` probability is $3/167=0.017964$, whereas the product-of-marginals model assigns $(17/167)(116/167)=0.070709$.

## Slide 323: Independence: question 2

Source note: `foundations/independence.qmd`

Verify conditional invariance for each row of `independent` and its failure for the observed *ne* row.

## Slide 324: Independence: answer 2

Source note: `foundations/independence.qmd`

Under independence, both object conditionals equal 0.694611; observed *ne* tokens give $\mathbb{P}(O\mid N)=112/147=0.761905$, so conditional invariance fails.

## Slide 325: Independence: question 3

Source note: `foundations/independence.qmd`

Explain why the mutually exclusive *hangi* and *kim* events are not independent when both have positive probability.

## Slide 326: Independence: answer 3

Source note: `foundations/independence.qmd`

The mutually exclusive *hangi* and *kim* events have joint probability zero but a positive product of marginals, so they are dependent.

## Slide 327: Independence: question 4

Source note: `foundations/independence.qmd`

Which source identifiers in `wh` would you retain in a later model of dependence beyond this descriptive table, and why?

## Slide 328: Independence: answer 4

Source note: `foundations/independence.qmd`

A later dependence model should retain `sentence_id` for sentence clustering, `register` and `split` for corpus structure, and the full observation key including `token_id` for token identity.
