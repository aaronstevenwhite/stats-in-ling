# Linguistic-data audit of the notes

## Scope and audit standard

I audited all 214 active `.qmd` pages in `foundations`, `random-variables-and-distributions`, `statistical-inference`, `regression-models`, `model-criticism-and-prediction`, `experimental-design`, `latent-structure`, `factorization`, `missing-data`, and `custom-models`. I excluded the root index, assignments and problem sets, `notes-sources`, slides and `slides-archive`, generated HTML, and other generated artifacts.

The audit asks whether each page keeps eight objects aligned: (i) the linguistic construct, (ii) the unit of observation, (iii) the sampling or assignment process, (iv) the measurement procedure, (v) the coding and preprocessing, (vi) any aggregation, (vii) the model's interpretation, and (viii) the limits of the resulting claim. I use **linguistic-data issue** for a mismatch among those objects. I do not use it for a merely mathematical or statistical question that another member of the audit swarm should assess.

The notes are unusually careful about units, row keys, first-stage measurement, dependence, and scope of inference. Most pages introduce no new linguistic-data problem. The remaining problems are concentrated in a small number of reusable examples. Fixing them at their canonical dossiers, and then adding one-sentence reminders on dependent pages, should address nearly every critique below.

## Priority findings and concrete repairs

### L1. Decode historical and package-specific phonetic labels at first use

**Pages.** `foundations/linguistic-data.qmd` and any page that first displays a Hillenbrand label without the corresponding word and IPA value.

The first Hillenbrand row is described as “the vowel coded `{`.” That is faithful to the stored table, but a student should not have to know that the source code corresponds to the vowel in *had*, conventionally /æ/ in the notes. A raw package label is not itself a transparent phonological category.

**Repair.** Add a compact lookup table at the canonical Hillenbrand dossier with three columns: stored code, elicitation word, and IPA label already used elsewhere in the course. At first display, write “source code `{`, the /æ/ vowel in *had*.” Link every later Hillenbrand page to that key. Preserve the warning that the elicitation label is an intended category rather than an acoustic measurement.

### L2. State that the Zipf analysis is over lowercased orthographic word forms, not Turkish lexemes or morphemes

**Page.** `foundations/zipfs-law.qmd`.

The preparation is documented accurately, including the treatment of UD multiword-token ranges. But the linguistic consequence of counting lowercased surface forms in an agglutinative language needs to be more prominent. Inflectionally related forms occupy different types, while a lemma or morpheme analysis would produce a different rank-frequency curve. “Word type” can otherwise be read as a lexical type.

**Repair.** Name the represented object **orthographic syntactic-word-form type** on first use. Add a short contrast among token, lowercased form type, lemma type, and morpheme type using one attested row from the prepared data. State that the present curve describes the first of those type systems and that Turkish morphology likely spreads evidence across many surface types. Add a check-your-understanding question asking what changes under lemmatization.

### L3. Keep the restricted BOUN pronoun count in the axis label and prose

**Page.** `statistical-inference/poisson-maximum-likelihood.qmd`.

The count vector is built from the course extract of tokens tagged `UPOS=PRON`, `PronType=Prs`, and an attested `Case` value. The opening and axis label shorten this to “annotated personal pronouns.” That wording may be read as all personal pronouns in the sentence, even though tokens outside the extract's filter do not enter the count.

**Repair.** Replace the shorthand with “case-annotated personal-pronoun tokens satisfying the course filter” at the first definition and on the figure axis. State that a reconstructed zero means no token satisfying that filter, not necessarily no personal-pronoun expression of any kind. Link back to the full filter in `populations-and-samples.qmd`.

### L4. Explain the Turkish phonology behind the UniMorph cross-tab, and state that the two variables are not competing analyses of the same conditioning relation

**Pages.** `statistical-inference/fishers-exact-test.qmd` and `statistical-inference/chi-squared-test.qmd`.

The notes correctly call the last two characters a course-derived orthographic ending rather than a morpheme boundary. The remaining linguistic problem is that last-stem-vowel class and the *d*/*t* initial encode different parts of Turkish past-tense allomorphy. Vowel harmony relates the suffix vowel to the last stem vowel, while the *d*/*t* alternation is ordinarily connected to the stem-final segment's voicing environment. A front/back-vowel by *d*/*t* table can show a resource association, but students may mistake it for the primary phonological conditioning relation.

**Repair.** Before the table, add a two-sentence morphological map: the derived two-character sequence combines a consonant-initial alternation and a harmonizing vowel, and the present cross-tab intentionally pairs the consonant initial with a noncanonical predictor for teaching independence. Add `stem_final_segment` or a derived final-obstruent-voicing class to the displayed example, if that field can be derived without changing the data record. Use the canonical conditioning variable in a sensitivity table, or state explicitly that the current table is not an analysis of the rule that licenses *d* versus *t*. Do not call the final characters “the suffix” without the existing qualification.

### L5. Make fixation-contingent selection a standing part of every Provo estimand

**Pages.** The canonical dossiers are `statistical-inference/beyond-conjugacy.qmd`, `regression-models/regression-models.qmd`, and `model-criticism-and-prediction/likelihood-ratio-tests.qmd`; the issue propagates to Provo application pages listed in the ledger.

The canonical descriptions correctly define first-fixation duration (FFD), distinguish it from gaze duration and total time, and note that skipped words contribute no positive FFD. Some shorter application pages then refer simply to “mean log first-fixation duration” or “complete content-word positions.” The modeled response is more specific: it is the mean log FFD among readers who fixated the word and survived the positive-duration/source filters. Predictability may affect both whether a word is fixated and the duration conditional on fixation, so this conditioning is substantive rather than clerical.

**Repair.** Give the response a stable name, such as **fixation-contingent mean log FFD**, at the canonical dossier. On every application page, include one reminder sentence or a link whose anchor contains the conditioning statement. When a figure says “mean log first-fixation duration,” add “among retained positive fixations” in the caption or nearby prose. Add one diagram distinguishing the binary skipping process from the positive-duration process. The notes need not fit a hurdle model, but they should say that the present analyses concern the second part only.

### L6. Reconcile UCCA `terminal_count` and `word_count` as two different exposure choices

**Pages.** `statistical-inference/paired-observations.qmd`, `statistical-inference/paired-mean-inference.qmd`, and `regression-models/poisson-mixed-models.qmd`.

The paired pages normalize Scene differences by `terminal_count`, while the Poisson mixed model uses `word_count` as its offset. Both variables exist in the prepared table and need not be identical. At present, a student is not told whether terminals include punctuation or other nonword units, why one denominator is preferred for one analysis, or how sensitive the cross-language comparison is to that choice.

**Repair.** Define both columns together in the UCCA dossier. State exactly which graph terminals are omitted from `word_count`. Choose one primary exposure on linguistic grounds and use it consistently, or present the other as a named sensitivity analysis. In the Poisson page, refit with the alternative exposure and report whether the French-to-English rate contrast changes materially. In the paired page, replace the generic phrase “passage length” with the exact denominator.

### L7. Make the mechanical relation between MALD acoustic duration and onset-based response time explicit

**Pages.** `regression-models/multiple-regression.qmd` and all MALD applications listed in the ledger.

The MALD dossier says that response time is measured from stimulus onset and uses recording duration as a predictor. This creates a partly mechanical relation: longer recordings occupy more of the onset-to-response interval, and listeners may respond before or after acoustic offset. The duration coefficient is thus not a clean estimate of additional lexical-processing time. The item table also aggregates unequal numbers of retained correct trials, so an unweighted regression of item means gives each word equal influence despite different precision.

**Repair.** Add a timing schematic with stimulus onset, acoustic offset, and response. State that the duration coefficient mixes physical presentation time with whatever processing differences remain at fixed frequency and phone count. If offset-relative latencies or early-response flags are available, show a sensitivity analysis; otherwise mark the decomposition as unavailable. At the item-summary dossier, distinguish the equal-item target from a precision-weighted target and point forward to the grouped likelihood in `distributional-regression.qmd`, which uses `n_observations` and within-item variance. Short MALD pages should remind students that item means are conditional on correct retained trials and do not recover listener effects.

### L8. Treat Nettle's country language totals as database counts attached to geopolitical units, not interchangeable biological counts

**Pages.** `regression-models/poisson-regression.qmd`, `poisson-regression-example.qmd`, `exposure-offsets.qmd`, `count-overdispersion.qmd`, and `quasi-poisson.qmd`.

The notes already reject a causal climate claim and mention history, contact, and spatial dependence. Two additional measurement problems deserve explicit treatment. First, one language may be counted in more than one country, so country counts do not partition a population of independent languages. Second, country boundaries, documentation practices, and decisions about language versus variety affect the response. Treating area as exposure also asserts proportional growth in the expected database count per square kilometer, which is not a neutral correction for “opportunity.”

**Repair.** Add a country-language measurement box defining what the source's `Langs` field counts and whether cross-border languages can recur. State that country is a geopolitical aggregation unit and that both response and area may stand in for historical and documentation processes. On the offset page, show the distinction between estimating the log-area coefficient and fixing it to one before interpreting a rate. Carry this reminder into the overdispersion pages: extra-Poisson variation can reflect measurement and boundary construction, not only latent stochastic heterogeneity.

### L9. Do not let the Storme liaison proxy inherit a literal count-data interpretation from integer truncation

**Pages.** `regression-models/zero-inflated-counts.qmd` and `regression-models/negative-binomial-regression.qmd`.

These pages admirably disclose that `reconstructed_count` is `trunc(100 * sum(freqfilms2))`, not an observed token tally. That fact is more than a caveat. Multiplying a normalized frequency and truncating it produces integer support, but it does not supply the Poisson or negative-binomial sampling process, exposure, or variance relation of a count. The location of zero is partly an artifact of the `.01` threshold before scaling.

**Repair.** Rename the response throughout as **truncated frequency proxy**. Present Poisson and negative-binomial fits as deliberate likelihood stress tests for an integer-valued proxy, not as preferred linguistic models. Avoid language such as “count process” when referring to the source measurement. If raw token counts and corpus denominators are available from the source, rebuild the example around those counts with offsets; otherwise add a parallel continuous or two-part analysis of `frequency_per_million_sum` and explain why it answers a different question.

### L10. Complete the Natural Stories predictor dossier with units, tokenization, and the known alignment exception

**Pages.** `model-criticism-and-prediction/prediction-targets.qmd` is canonical; the issue propagates to `index.qmd`, `training-and-test-data.qmd`, `predictive-loss.qmd`, `bias-variance-tradeoff.qmd`, `cross-validation.qmd`, and `grouped-cross-validation.qmd`.

The response ladder is strong, including the corrected one-position displacement. The predictor ladder is less complete. `log_unigram_frequency` is the logarithm of a Google Books count, not a probability or a frequency normalized to a common token denominator. `gpt3_surprisal` is obtained by combining subword-token log probabilities at the experimental word, but the page does not state the logarithm base or the token-to-word aggregation convention in its main prose. The data record also documents a released `peaked`/`peeked` alignment exception that the notes do not mention.

**Repair.** Add a predictor provenance table naming source, numerical unit, transformation, aggregation from model tokens to experiment words, and interpretation. State the log base used by the released GPT-3 values and name the resulting surprisal unit. Add the documented spelling mismatch as a concrete example of position-based alignment and say which surface form supplies the reading time, length, frequency, and surprisal. This is useful pedagogy because it shows that “joined by position” is an empirical decision, not a perfect lexical identity relation.

### L11. State the genealogical information available across PHOIBLE splits

**Pages.** `factorization/data-matrices.qmd`, `centering-and-scaling.qmd`, `principal-component-analysis.qmd`, `rank-one-structure.qmd`, `scores-and-loadings.qmd`, `singular-value-decomposition.qmd`, `reconstruction.qmd`, and `choosing-components.qmd`.

Sampling one inventory per Glottocode prevents duplicate row weight for the same doculect, and macroarea stratification preserves broad geographic coverage. It does not keep related languages or source traditions in one split. A test inventory may therefore be reconstructed using directions learned partly from genealogically close inventories. The notes correctly say that the target is hidden cells in a partly observed record rather than an unseen family, but the information set should name this availability directly.

**Repair.** Add “genealogically related inventories may remain in training” to the validation-target specification. Join a family identifier if it is already present in the pinned metadata and report a family-blocked sensitivity split. If that join is outside the present data record, state that family leakage cannot be quantified here. Keep the present split for the narrow cell-completion lesson, but do not let its bootstrap interval read as inventory-level independence across a typological population.

### L12. Correct the rank-grid description and sharpen the target of participant normalization in the VALEX--MegaAcceptability analysis

**Page.** `factorization/valex-megaacceptability.qmd`.

The page says that the maximum candidate rank, 50, is “just below” the number of response-frame targets, but the audited inputs contain exactly 50 experimental frames. More substantively, held-out verbs are predicted for participants whose response origin and scale may be estimated from their other training-verb judgments. This is a legitimate new-verb target, but it is not prediction for a new participant, and the 1--7 ordinal response is treated as interval-valued during within-participant standardization and averaging.

**Repair.** Correct “just below” to “equal to” or change the candidate grid. Add the participant information set to the validation-target specification: held-out verbs are new, while participant calibration from other verbs may remain available. State immediately beside the normalization equation that subtraction, division, and averaging impose an interval-scale approximation to the ordinal ratings. Preserve the current warning that this procedure is not the paper's ordinal normalization.

### L13. Separate Turkish PropBank role class from choice-set difficulty and adjudication dependence

**Page.** `custom-models/annotations-as-measurements.qmd`.

The page correctly defines `correct` as agreement with adjudication rather than independent truth. But the core-versus-adjunct coefficient may also reflect differences in the number, wording, or confusability of the role descriptions offered for different predicate frames. In addition, adjudication follows the crowd layer, so the comparison target may not be statistically or procedurally independent of the worker judgments whose agreement it scores.

**Repair.** Add a protocol ledger stating which response options a worker saw and whether the adjudicator had access to aggregate crowd choices. If option-set size or frame identity is recoverable, summarize it by role group and add a frame or option-set sensitivity analysis. If not, state that the role-group coefficient combines role class with unmeasured choice-set composition. Replace any residual “accuracy” language with “agreement with the later project adjudication.”

### L14. Preserve the observation hierarchy when application pages become short

**Pages.** This is a cross-cutting repair for the application pages tagged `L5`, `L7`, `L8`, `L10`, or `L11` in the ledger.

The canonical dossiers are generally excellent. The recurring risk is **dossier attrition**: a short page inherits a filename and a response column but not the condition under which that response exists or the groups within which rows repeat. A reader who enters through a direct link can miss the earlier caveat.

**Repair.** Give each recurring resource a two- or three-sentence reusable reminder containing (i) row unit, (ii) response construction, and (iii) principal dependence or selection limitation. Put it after the first link to the canonical dossier on every application page. This is not a request to duplicate the full dossier. It is the minimum local context needed to interpret the formula on that page.

### L15. Replace compressed caveat formulas with an explicit account of the sample and its limits

**Pages.** Every data-bearing page, with special attention to BOUN, Provo, MALD, Natural Stories, PHOIBLE, and experimental pages that currently compress several qualifications into one sentence.

Some caveats are technically accurate but pedagogically opaque. For instance, a sentence such as “tokens remain nested in sentences, and the selected registers are not a probability sample of Turkish usage” names two problems without explaining either one. A student still needs to know (i) why tokens from one sentence may resemble one another, (ii) which registers were included and excluded, (iii) how records reached the dataset, and (iv) whether the displayed proportion describes the prepared extract, the source treebank, written Turkish in those registers, or Turkish usage more broadly. Phrases such as “pinned corpus extract,” “dependence remains,” and “population-relative” should not carry that work by themselves unless those terms have already been defined and linked.

**Repair.** Give each canonical dataset dossier a four-part **sample-to-claim map**: collection or recruitment procedure; inclusion and preprocessing rules; resulting row unit and repeated groups; and the narrowest population or resource to which the summary applies. On later pages, link the first relevant term—such as *token dependence*, *conditional-on-fixation response*, *item mean*, *held-out inventory*, or *random assignment*—to its first explanation and repeat one plain-language sentence about why it matters locally. Spell out dependence as a concrete source of shared information: “two tokens from the same sentence share a local context, so treating them as unrelated observations overstates how much distinct information the table contains.” Spell out register selection as a coverage claim: “the extract contains the listed written registers; it does not represent their prevalence in Turkish usage and contains no spoken conversation.” End with a direct statement of what the estimate does and does not describe. Do not introduce a compact technical label until the underlying idea has been explained in ordinary language.

### L16. Break the repeated compact-negation template and teach the positive data story first

**Pages.** This is a corpus-wide prose problem, with the densest data-bearing instances listed below.

The limitation paragraphs repeatedly use a compact “X, not Y” or “does not establish Y” frame. In the audited snapshot, the 214 active pages contain 25 matches for `This is ... not ...`, 43 matches for `This ... does not ...`, 103 instances of `It is not`, 407 instances of `does not`, and 189 instances of `rather than`. These counts overlap, and many individual contrasts are accurate. The problem is the recurrence: students repeatedly receive a label for a forbidden inference without first receiving the sampling or measurement facts that explain why the inference fails. The rhythm also makes independent caveats sound machine-generated.

**Repair.** Use a **fact--consequence--scope** paragraph for empirical limitations. First give the concrete fact about recruitment, corpus construction, task display, aggregation, or split membership. Next explain how that fact changes the information in the rows. Then state the narrow conclusion the analysis supports. A final contrast may be useful, but it should land the argument rather than substitute for it. Vary the architecture: a short process narrative, a four-row sample-to-claim table, a worked token, or a two-stage diagram will often teach more than another negation. Do not mechanically delete all negative statements; preserve those that correct a likely misconception after the positive account has been supplied.

The following file-specific repairs address the highest-impact instances:

| Page | Concrete repair to the recurring caveat frame |
|:--|:--|
| `statistical-inference/populations-and-samples.qmd` | Use the current source facts—sentences sampled within five selected written registers, then filtered to qualifying annotated pronoun tokens—to walk from sampled sentence to analysis row. End by naming two separate targets: the finite release and a hypothetical Turkish-usage process. Make this paragraph the link target for later BOUN caveats; do not reduce it to “nested tokens” or “pinned extract.” |
| `foundations/bayes-rule.qmd` | Replace “It cannot be” plus “the empirical measure” with a denominator-specific account: the displayed prevalence is the share among retained *ne/değil/yok* rows in the five represented written registers. Neither the register mix nor the three-lemma filter matches a draw from all Turkish production. |
| `foundations/zipfs-law.qmd` | Replace “not a balanced probability sample” with the observed collection frame: five selected written registers, unknown prevalence weights, no spoken interaction in this release, and counts over lowercased surface forms. Then state that the fitted curve summarizes those represented word-form counts. |
| `statistical-inference/beyond-conjugacy.qmd` | Replace the three-item negation (“not participant-level ... causal ... probability sample”) with a positive target sentence: the model assigns equal weight to 55 passage-by-part-of-speech summaries formed from positive FFDs. Follow with one sentence each on the removed reader distribution, observational POS contrast, and selected passage set. |
| `regression-models/regression-models.qmd` | Introduce the fixation-contingent word-position response before any warning about what it is not. Draw the raw reader trial → positive FFD → word-position mean → passage comparison chain, then locate the regression on that chain. |
| `regression-models/ordinal-mixed-models.qmd` | Replace “computational teaching subset, not a probability sample” with the actual inclusion route for verbs, participants, frames, and responses. State which selected rows the estimates summarize and which source normalization steps were omitted in a separate methods-comparison paragraph. |
| `regression-models/poisson-regression.qmd` | Lead with how the country-language database total is constructed, including recurring transboundary languages and country-boundary dependence. Only then delimit the target to modeled variation among the represented country records. |
| `regression-models/poisson-mixed-models.qmd` | The page already names one novel, one translation, and one annotation history. Turn those facts into a short chain explaining why passages share author, translator, genre, and annotation context; then state that the coefficient summarizes this aligned release. The existing “not a random sample of languages” clause can be removed after that explanation. |
| `model-criticism-and-prediction/leave-one-out-cross-validation.qmd` | Replace the list of four things the target is not with the exact omission operation: one word-position summary is removed while other positions, passages, and reader-aggregated information remain. The scope follows directly from what crosses the boundary. |
| `factorization/choosing-components.qmd` | Replace “does not establish transfer to unseen families” with the split facts: one record per Glottocode, macroarea balance, no family blocking, and possible close relatives on both sides. Then state that the score evaluates cell completion under that information set. |
| `factorization/valex-megaacceptability.qmd` | Explain the outer split in positive terms: verb rows cross the boundary, while a participant's other training-verb judgments can still calibrate that participant. Then label the target “new verb for known participants under within-participant normalization.” |
| `missing-data/complete-case-analysis.qmd` | After showing the concentration of missing cells in the released `er` category, list the source information that is and is not available about tracking or signal quality. Conclude that the table identifies composition change but cannot choose among causes. This teaches the limitation without “not a diagnosis” as a slogan. |
| `latent-structure/k-means.qmd` | State that ten centroids were fixed before fitting so their acoustic partition can be compared with ten elicitation labels. That procedural fact makes the evaluation target clear; the phrase “not a claim that K-means discovered the category count” can then be shortened or removed. |
| `custom-models/generative-stories.qmd` | Describe the natural-parts prompt, the sentence-anchored predicate node, and the resulting yes/no response before discussing construct validity. Then say that the response is one task-conditioned indicator from which an event-structural analysis may be inferred under additional assumptions. |
| `custom-models/annotations-as-measurements.qmd` | Replace repeated agreement-versus-truth slogans with the actual sequence: worker sees a predicate-specific choice set, worker selects a description, later project adjudication supplies the comparison label. This sequence explains both the measurement and the dependence concern in **L13**. |
| `experimental-design/power-by-simulation.qmd` | Separate calibration from projection. Give a numbered list of mechanisms retained by the generator and mechanisms omitted, then state the future-study conditions under which the simulated power curve would be relevant. |

The same edit should be applied opportunistically on the remaining pages containing these templates. Mathematical misconception checks—such as “a p value is not the probability that the null is true”—may retain a compact contrast after the relevant probability space has been derived. Empirical sampling and measurement caveats usually need the fuller fact--consequence--scope form.

## Cross-cutting strengths to preserve

First, the notes regularly distinguish records, observations, summaries, and model quantities. The Provo passage ladder, MALD item-versus-trial distinction, UDS predicate-node item, and PHOIBLE inventory-record terminology are models worth retaining.

Second, the notes do not turn annotations into linguistic truth. This is especially strong in the UDS, Turkish PropBank, SuperTelicity, and MegaVeridicality pages.

Third, aggregation is usually named as a target-changing operation rather than a harmless convenience. The repairs above mainly ensure that this insight remains visible after students leave the canonical dossier.

Fourth, the notes repeatedly separate descriptive claims about pinned resources from claims about languages or language users. The remaining repairs make that discipline more consistent for country-level language counts, surface-form frequencies, and typological matrix validation.

Fifth, links should implement conceptual memory rather than act as bare provenance. A data page should link to the first treatment of every construct on which its interpretation depends, and its link text should name the idea students are meant to recall. The local reminder then needs to say, briefly, how that idea constrains the current analysis.

## Complete page-by-page ledger

“No linguistic-data issue” means that the page either contains no linguistic dataset or uses the unit, measurement, coding, aggregation, and inferential scope established in its dossier without introducing a new mismatch. A tag such as `L7` points to the concrete repair above.

### Foundations

| Page | Audit result |
|:--|:--|
| `foundations/bayes-rule.qmd` | No linguistic-data issue. The two conditional directions use the same explicitly restricted token table. |
| `foundations/conditional-probability.qmd` | No linguistic-data issue. The changing reference event and token denominator are visible. |
| `foundations/event-spaces.qmd` | No linguistic-data issue. The *ne* generator is an analytic distinction over declared token outcomes. |
| `foundations/events.qmd` | No linguistic-data issue. Token identity, lemma, and UD relation remain distinct. |
| `foundations/generating-event-spaces.qmd` | No linguistic-data issue. The atoms correctly cross source lemma and relation labels within the restricted extract. |
| `foundations/independence.qmd` | No linguistic-data issue. The page explicitly separates event, row-level, and causal independence. |
| `foundations/index.qmd` | No linguistic-data issue. The index foregrounds unit choice and aggregation. |
| `foundations/joint-probability-of-events.qmd` | No linguistic-data issue. Joint cells concern properties of the same sampled token. |
| `foundations/linguistic-data.qmd` | **L1.** Decode the package vowel code `{` as the /æ/ vowel in *had* and supply a reusable code-to-word-to-IPA key. |
| `foundations/making-sense-of-data.qmd` | No linguistic-data issue. F1, paired speaker structure, and the restricted cohort target are well aligned. |
| `foundations/possibilities-and-events.qmd` | No linguistic-data issue. The source sentence, token key, UD relation, and analytic restriction are stated. |
| `foundations/probability-concepts.qmd` | No linguistic-data issue. Exclusivity and exhaustivity are explicitly relative to the retained outcome space. |
| `foundations/probability-factorization.qmd` | No linguistic-data issue. The factorization does not add a causal interpretation to corpus labels. |
| `foundations/probability-measures.qmd` | No linguistic-data issue. Uniform row sampling is identified as an empirical measure on the finite extract. |
| `foundations/zipfs-law.qmd` | **L2.** Name the counted types as lowercased orthographic syntactic-word forms and contrast them with lemmas and morphemes. |

### Random variables and distributions

| Page | Audit result |
|:--|:--|
| `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd` | No linguistic-data issue. The extract restriction and the information lost by binary recoding are explicit. |
| `random-variables-and-distributions/bernoulli-distribution.qmd` | No linguistic-data issue. One binary source annotation is not confused with independence across rows. |
| `random-variables-and-distributions/beta-distribution.qmd` | No linguistic-data issue. The response is correctly identified as a first-stage fitted Provo probability, not a raw cloze proportion. |
| `random-variables-and-distributions/binomial-distribution.qmd` | No linguistic-data issue. Sentence clustering is used to challenge, rather than smuggle in, the binomial process. |
| `random-variables-and-distributions/central-moments.qmd` | No linguistic-data issue. The distribution is over uniformly sampled CMUdict pronunciation entries, not speech tokens. |
| `random-variables-and-distributions/chi-squared-distribution.qmd` | No linguistic-data issue. The /i/ restriction leaves one F1 value per speaker within group. |
| `random-variables-and-distributions/conditional-expectation.qmd` | No linguistic-data issue. Recipient length and realization remain source-coded properties of the same dative token. |
| `random-variables-and-distributions/conditional-independence.qmd` | No linguistic-data issue. The descriptive contingency comparison does not become a causal or row-independent claim. |
| `random-variables-and-distributions/continuous-random-variables.qmd` | No linguistic-data issue. Recorded whole milliseconds are distinguished from latent continuous duration. |
| `random-variables-and-distributions/correlation.qmd` | No linguistic-data issue. Recipient and theme lengths remain paired within dative tokens. |
| `random-variables-and-distributions/covariance.qmd` | No linguistic-data issue. The paired constituent measurements and word-count units are explicit. |
| `random-variables-and-distributions/cumulative-distribution-functions.qmd` | No linguistic-data issue. The empirical CDF is attached to one adult-male /i/ token per speaker. |
| `random-variables-and-distributions/defining-random-variables.qmd` | No linguistic-data issue. Pronunciation entries remain outcomes and phone counts remain derived values. |
| `random-variables-and-distributions/discrete-random-variables.qmd` | No linguistic-data issue. CMUdict codomain, observed support, and lexical-resource target are separated. |
| `random-variables-and-distributions/expectation-of-functions.qmd` | No linguistic-data issue. The page explicitly denies a substantive processing interpretation to an arbitrary mathematical transform. |
| `random-variables-and-distributions/expected-values.qmd` | No linguistic-data issue. The expectation is population-relative to the pinned pronunciation-entry table. |
| `random-variables-and-distributions/geometric-distribution.qmd` | No linguistic-data issue. The page makes the phonotactic failure of independent, memoryless phone trials the point of the example. |
| `random-variables-and-distributions/hypergeometric-distribution.qmd` | No linguistic-data issue. Lemma--paradigm rows, without-replacement sampling, and absence of token frequency are explicit. |
| `random-variables-and-distributions/index.qmd` | No linguistic-data issue. The index preserves the outcomes-to-values distinction across resources. |
| `random-variables-and-distributions/inverse-transform-sampling.qmd` | No linguistic-data issue. Simulated lemma draws are not presented as newly collected corpus evidence. |
| `random-variables-and-distributions/joint-probability.qmd` | No linguistic-data issue. Recipient and theme lengths are coordinates of one dative-token outcome. |
| `random-variables-and-distributions/linearity-of-expectation.qmd` | No linguistic-data issue. Vowel and consonant counts derive from one pronunciation entry without an independence claim. |
| `random-variables-and-distributions/marginal-distributions.qmd` | No linguistic-data issue. Marginalization is correctly described as discarding within-token pairing. |
| `random-variables-and-distributions/negative-binomial-distribution.qmd` | No linguistic-data issue. Conditioning on entries with three vowels and the phonotactic model failure are explicit. |
| `random-variables-and-distributions/normal-distribution.qmd` | No linguistic-data issue. Speaker groups are modeled separately and the /hVd/ elicitation limit is stated. |
| `random-variables-and-distributions/poisson-distribution.qmd` | No linguistic-data issue. The dative source fields, missing spans, repeated verbs/speakers, and count simplification are all disclosed. |
| `random-variables-and-distributions/probability-density-functions.qmd` | No linguistic-data issue. The kernel density is labeled descriptive rather than part of the original vowel study. |
| `random-variables-and-distributions/probability-mass-functions.qmd` | No linguistic-data issue. Uniform sampling from pronunciation entries remains the declared experiment. |
| `random-variables-and-distributions/random-seeds.qmd` | No linguistic-data issue. Computational repetition is distinguished from empirical replication. |
| `random-variables-and-distributions/standard-deviation.qmd` | No linguistic-data issue. Spread is interpreted in phones for the declared entry distribution. |
| `random-variables-and-distributions/student-t-distribution.qmd` | No linguistic-data issue. The paired speaker, rather than the vowel row, is the inferential unit. |
| `random-variables-and-distributions/uniform-distribution.qmd` | **L5 reminder.** The dossier is strong; retain “among positive fixations” whenever `mean_log_ffd` is mentioned on later Provo pages. |
| `random-variables-and-distributions/variance-and-covariance.qmd` | No linguistic-data issue. Phone and vowel-phone summaries remain linked to pronunciation entries. |
| `random-variables-and-distributions/when-expectations-fail.qmd` | No linguistic-data issue. Hillenbrand values only calibrate a deliberately inadequate Cauchy reference. |
| `random-variables-and-distributions/why-random-variables.qmd` | No linguistic-data issue. Orthographic words, pronunciation entries, and running-speech tokens are carefully separated. |

### Statistical inference

| Page | Audit result |
|:--|:--|
| `statistical-inference/autocorrelation.qmd` | No linguistic-data issue. The diagnostic is applied to draws for the already specified passage-level target. |
| `statistical-inference/beyond-conjugacy.qmd` | No linguistic-data issue. This is the strongest Provo dossier: FFD, positive-fixation conditioning, two-stage aggregation, equal passage weighting, and lost variation are explicit. Preserve it as the canonical source for **L5** reminders. |
| `statistical-inference/bootstrap-confidence-intervals.qmd` | No linguistic-data issue. Speaker-row resampling matches the adult-women /I/ median target. |
| `statistical-inference/checking-markov-chains.qmd` | No linguistic-data issue. No new empirical interpretation is added. |
| `statistical-inference/chi-squared-test.qmd` | **L4.** Explain that stem-vowel class is not the canonical conditioner of the *d*/*t* alternation. |
| `statistical-inference/confidence-intervals.qmd` | No linguistic-data issue. The empirical speaker resampling and discrete-data transition keep units visible. |
| `statistical-inference/conjugate-priors.qmd` | No linguistic-data issue. The counterfactual exchangeable superpopulation is kept separate from the actual without-replacement UniMorph sample. |
| `statistical-inference/divergent-transitions.qmd` | No linguistic-data issue. The stress computation does not alter the empirical target. |
| `statistical-inference/effective-sample-size.qmd` | No linguistic-data issue. ESS is tied to posterior quantities, not linguistic sample size. |
| `statistical-inference/estimator-bias.qmd` | No linguistic-data issue. The median is deliberately evaluated against a mean target and the empirical cohort target is named. |
| `statistical-inference/exact-binomial-intervals.qmd` | No linguistic-data issue. Success is a within-speaker /I/-versus-/i/ duration comparison. |
| `statistical-inference/fishers-exact-test.qmd` | **L4.** Add the Turkish allomorphy map and delimit the noncanonical vowel-class by consonant-initial cross-tab. |
| `statistical-inference/generated-quantities.qmd` | No linguistic-data issue. Replicated passage summaries are not confused with regenerated reader trials. |
| `statistical-inference/hamiltonian-monte-carlo.qmd` | No linguistic-data issue. The passage summaries remain the fixed posterior target. |
| `statistical-inference/importance-sampling.qmd` | No linguistic-data issue. No new claim about the source data is introduced. |
| `statistical-inference/independent-means.qmd` | No linguistic-data issue. Disjoint speaker groups and noncausal group interpretation are explicit. |
| `statistical-inference/independent-sampling.qmd` | No linguistic-data issue. Sentence, document, and register dependence challenge the IID working model visibly. |
| `statistical-inference/index.qmd` | No linguistic-data issue. The module distinguishes finite resources, superpopulations, and model-based uncertainty. |
| `statistical-inference/markov-chain-monte-carlo.qmd` | No linguistic-data issue. The sampler targets the previously declared passage-summary posterior. |
| `statistical-inference/markov-chains.qmd` | No linguistic-data issue. Linguistic data are not reinterpreted on this computational page. |
| `statistical-inference/mass-matrix-geometry.qmd` | No linguistic-data issue. Posterior geometry is not presented as linguistic geometry. |
| `statistical-inference/maximum-likelihood.qmd` | No linguistic-data issue. The likelihood is conditional on a clearly declared binary resource model. |
| `statistical-inference/mean-squared-error.qmd` | No linguistic-data issue. The target parameter is stated before comparing estimators. |
| `statistical-inference/metropolis-hastings.qmd` | No linguistic-data issue. No new source-data claim is added. |
| `statistical-inference/monte-carlo-integration.qmd` | No linguistic-data issue. Computation and empirical sampling remain separate. |
| `statistical-inference/no-u-turn-sampler.qmd` | No linguistic-data issue. No new linguistic-data interpretation is introduced. |
| `statistical-inference/null-hypotheses-and-test-statistics.qmd` | No linguistic-data issue. The tested contrast and its reference model remain population-relative. |
| `statistical-inference/one-sample-t-inference.qmd` | No linguistic-data issue. Normality is correctly attached to speaker-level differences. |
| `statistical-inference/paired-mean-inference.qmd` | **L6.** Define why the sensitivity denominator is `terminal_count` and reconcile it with the `word_count` offset used later. |
| `statistical-inference/paired-observations.qmd` | **L6.** Define terminal versus word counts in the canonical UCCA dossier. The Scene node-count rule itself is appropriately graph-aware. |
| `statistical-inference/parameter-pair-plots.qmd` | No linguistic-data issue. The diagnostic does not broaden the Provo target. |
| `statistical-inference/poisson-maximum-likelihood.qmd` | **L3.** The counted event is a case-annotated personal-pronoun token satisfying the course filter, not any personal pronoun. |
| `statistical-inference/populations-and-samples.qmd` | No linguistic-data issue. The full BOUN filter and finite-release versus usage targets are exemplary. |
| `statistical-inference/posterior-distributions.qmd` | No linguistic-data issue. Orthographic ending, lemma--cell unit, and superpopulation assumption are explicit. |
| `statistical-inference/posterior-predictive-checks.qmd` | No linguistic-data issue. Replication occurs at the passage-summary level and is not promoted to reader-level adequacy. |
| `statistical-inference/posterior-summaries.qmd` | No linguistic-data issue. Posterior summaries preserve the UniMorph model's stated target. |
| `statistical-inference/predictive-distributions.qmd` | No linguistic-data issue. Counterfactual independent-block prediction is compared with the actual finite-resource design. |
| `statistical-inference/prior-predictive-distributions.qmd` | No linguistic-data issue. The exchangeable-superpopulation limitation remains visible. |
| `statistical-inference/pronoun-case-example.qmd` | No linguistic-data issue. The binary variable is a deterministic recoding of a source UD Case value and register variation is shown. |
| `statistical-inference/properties-of-estimators.qmd` | No linguistic-data issue. The speaker bootstrap is not presented as reconstructing recruitment. |
| `statistical-inference/rhat.qmd` | No linguistic-data issue. Cross-chain agreement is not confused with empirical replication. |
| `statistical-inference/stan.qmd` | No linguistic-data issue. The program implements the same fully specified passage-level target. |
| `statistical-inference/standard-errors.qmd` | No linguistic-data issue. Dependence and the estimator-specific meaning of standard error are explicit. |

### Regression models

| Page | Audit result |
|:--|:--|
| `regression-models/aspectual-similarity-example.qmd` | No linguistic-data issue. The target is prediction of held-out verbs from their aspectual profiles, not recovery of an intrinsic semantic kind. Link the first mention of this target to the fuller MegaAcceptability setup. |
| `regression-models/bayesian-linear-regression.qmd` | **L5 and L15 reminder.** Restate that each response is a word-position mean among readers with retained positive fixations and link “first-fixation duration” to its first procedural definition. |
| `regression-models/bounded-responses.qmd` | No linguistic-data issue. The MegaNegRaising prompt, sentence-rating unit, bounded slider, and exact endpoints are kept distinct. |
| `regression-models/centering-predictors.qmd` | **L5 reminder.** Centering changes the intercept's reference point; it does not change the fixation-contingent response population. |
| `regression-models/checking-linear-regression.qmd` | **L5 reminder.** The checks concern the word-position summary model, not trial-level reading behavior or the skipping mechanism. |
| `regression-models/coding-categorical-predictors.qmd` | **L7 reminder.** The sex label is a source demographic code, the rows are MALD word items, and item means retain only correct filtered trials. Link all three terms to the MALD dossier. |
| `regression-models/coefficient-of-determination.qmd` | **L5 reminder.** The variance explained is variance among aggregated, fixation-contingent word-position means. |
| `regression-models/correlated-predictors.qmd` | **L7 reminder.** Frequency, phone count, and acoustic duration are correlated properties of MALD stimuli; they are not independent interventions on lexical access. |
| `regression-models/count-overdispersion.qmd` | **L8.** Explain in ordinary language that countries do not partition languages, country boundaries and documentation affect the counts, and extra-Poisson variation need not be a latent biological-style process. |
| `regression-models/design-matrices.qmd` | **L7 reminder.** Keep the row as a word item and link the predictors to their source-field definitions rather than presenting the matrix as self-interpreting. |
| `regression-models/deviance-residuals.qmd` | No linguistic-data issue. The SuperTelicity response remains an in/for choice in a particular judgment task rather than a direct label of telicity. |
| `regression-models/deviance.qmd` | No linguistic-data issue. The likelihood comparison preserves the declared binary judgment target. |
| `regression-models/distributional-regression.qmd` | No new linguistic-data issue. This page directly repairs part of **L7** by using each item's retained-trial count and within-item variance; retain the warning that the response is still conditional on correct retained trials and that onset timing complicates acoustic-duration interpretation. |
| `regression-models/exponential-family.qmd` | No linguistic-data issue. The MegaVeridicality response is introduced as a bounded task measurement, not as direct access to a latent semantic truth. |
| `regression-models/exposure-offsets.qmd` | **L8.** A country-area offset fixes proportional scaling rather than merely “controlling for size.” Add the country-language measurement box and link to the first explanation of an exposure assumption. |
| `regression-models/fixed-and-random-effects.qmd` | **L7 reminder.** Participant and item effects belong to MALD trial data; make explicit that they cannot be recovered after reduction to one mean per word. |
| `regression-models/frequentist-linear-regression.qmd` | **L5 reminder.** State the aggregation and positive-fixation condition beside the model equation. |
| `regression-models/generalized-linear-mixed-models.qmd` | No linguistic-data issue. The response is an in/for task choice and is described as a noisy proxy rather than the semantic category itself. |
| `regression-models/generalized-linear-models.qmd` | No linguistic-data issue. The page keeps the response's support and observation unit visible while introducing the link-function framework. |
| `regression-models/helmert-coding.qmd` | **L7 reminder.** The coded groups are source categories attached to MALD word items; the contrasts do not create experimental comparisons. |
| `regression-models/heteroscedasticity.qmd` | No new linguistic-data issue. The unequal precision of MALD item means is correctly connected to retained-trial counts; keep the **L7** onset-versus-offset timing caveat visible. |
| `regression-models/index.qmd` | **L14--L15.** The index reuses several datasets. Give each resource link a short sample-to-claim reminder so that students entering here can recover row unit, response construction, and principal dependence without guessing from the column name. |
| `regression-models/influence.qmd` | **L5 reminder.** Influential rows are influential word positions in the aggregated conditional-duration analysis, not influential readers. |
| `regression-models/interactions.qmd` | No linguistic-data issue. MegaOrientation predictors and response are task measurements, and the interaction is not promoted to a population-general causal effect. |
| `regression-models/intraclass-correlation.qmd` | **L7 reminder.** The shared groups arise because multiple lexical-decision trials involve the same participant and item; describe that repetition in ordinary language before naming the ICC. |
| `regression-models/inverse-helmert-coding.qmd` | **L7 reminder.** Contrast coding changes the comparison among recorded MALD item groups, not the underlying sampling or construct. |
| `regression-models/iteratively-reweighted-least-squares.qmd` | No linguistic-data issue. The computational weights are kept separate from sampling weights and annotator confidence. |
| `regression-models/laplace-approximation.qmd` | No linguistic-data issue. Approximation error is attached to the fitted mixed model, not to linguistic annotation uncertainty. |
| `regression-models/leverage-and-influence.qmd` | **L5 reminder.** Link each row back to the fixation-contingent word-position estimand before interpreting leverage. |
| `regression-models/linear-regression-uncertainty.qmd` | **L5 reminder.** The uncertainty calculation is conditional on the aggregated Provo design and should not be read as reader-level uncertainty. |
| `regression-models/link-functions.qmd` | No linguistic-data issue. The response-scale meaning is separated from the model's linear predictor. |
| `regression-models/logistic-regression-example.qmd` | No linguistic-data issue. The sentence-level in/for response and duration covariate are both task-defined, and the coefficient is not described as a direct semantic law. |
| `regression-models/logistic-regression-with-multiple-predictors.qmd` | No linguistic-data issue. The observation remains one SuperTelicity judgment and the predictors remain properties of that item/task record. |
| `regression-models/logistic-regression.qmd` | No linguistic-data issue. Binary coding is connected to the elicitation choice rather than treated as the property itself. |
| `regression-models/multiple-regression.qmd` | **L7 and L15.** Add the onset/offset schematic, define the equal-item target, and replace compact sampling caveats with a sample-to-claim map for correct retained MALD trials. |
| `regression-models/negative-binomial-regression.qmd` | **L9.** Call the response a truncated frequency proxy, not a token count, and frame the fit as a likelihood stress test unless raw counts and exposures can be reconstructed. |
| `regression-models/odds-and-log-odds.qmd` | No linguistic-data issue. Odds refer to the recorded task response, not to the prevalence of a semantic class outside the experiment. |
| `regression-models/ordered-beta-regression.qmd` | No linguistic-data issue. Exact endpoints and interior slider responses are modeled as features of the response mechanism. |
| `regression-models/ordinal-mixed-models.qmd` | No linguistic-data issue. The pages distinguish task samples and do not imply that an ordinal judgment is interval-valued. A link to the first explanation of the response scale would improve entry-point accessibility. |
| `regression-models/ordinal-regression.qmd` | No linguistic-data issue. Ordered labels retain their order without acquiring unsupported distances. |
| `regression-models/overdispersion-and-random-effects.qmd` | No linguistic-data issue. Observation heterogeneity and grouping are presented as model features whose substantive source still requires domain interpretation. |
| `regression-models/poisson-mixed-models.qmd` | **L6.** Define `word_count`, reconcile it with `terminal_count`, and say in ordinary language what graph units enter the numerator and exposure. |
| `regression-models/poisson-regression-example.qmd` | **L8 and L15.** State exactly what a country total counts, how cross-border languages can recur, which population is not sampled, and what fixing the area coefficient to one assumes. |
| `regression-models/poisson-regression.qmd` | **L8 and L15.** The canonical Nettle dossier needs a sample-to-claim map rather than a compressed “country-level dependence” caveat. |
| `regression-models/quasi-poisson.qmd` | **L8.** Overdispersion may reflect geopolitical aggregation and documentation differences; link back to that measurement explanation. |
| `regression-models/random-effect-correlations.qmd` | **L7 reminder.** Correlation among participant effects concerns repeated MALD trial responses, not correlation among lexical properties. |
| `regression-models/random-effect-estimates.qmd` | **L7 reminder.** Participant- and item-specific estimates are conditional model quantities, not measured abilities or lexical difficulty scores. |
| `regression-models/random-effects.qmd` | **L7 and L15 reminder.** Explain repeated participants and words before using “crossed structure,” and link to the first participant/item sampling discussion. |
| `regression-models/random-intercepts.qmd` | **L7 reminder.** A participant or item intercept summarizes repeated responses under this task; it is not an intrinsic trait. |
| `regression-models/random-slopes.qmd` | **L7 reminder.** A varying task effect is defined over repeated trials and should not be interpreted as a stable participant phenotype. |
| `regression-models/regression-models.qmd` | **L5 and L15.** This is a canonical Provo dossier and already defines FFD well; give the conditioned response a stable name and add the plain-language sample-to-claim map that later pages can quote. |
| `regression-models/residualizing-a-predictor.qmd` | **L7 reminder.** Residual frequency remains a model-dependent transformation of correlated lexical stimulus properties, not a purified causal manipulation. |
| `regression-models/residuals.qmd` | **L5 reminder.** Residuals are discrepancies for aggregated conditional means, not participant-level errors. |
| `regression-models/response-transformations.qmd` | **L5 reminder.** Log transformation changes the scale of positive fixation durations but does not restore skipped words to the target. |
| `regression-models/ridge-regression.qmd` | **L7 reminder.** Shrinkage addresses correlated MALD predictors; it does not resolve the construct or onset-timing interpretation of acoustic duration. |
| `regression-models/simple-linear-regression.qmd` | **L5 reminder.** The response is a passage/word-position summary among positive fixations, not a raw reader trial. |
| `regression-models/singular-fits.qmd` | **L7 reminder.** A singular random-effects fit concerns what the repeated MALD design can support; it is not evidence that a participant or item source of variation is linguistically absent. |
| `regression-models/structured-data.qmd` | **L7 and L15.** Explain the actual repetition of participants and items in plain language, then link “crossed” and “nested” to their first definitions. |
| `regression-models/sufficient-statistics.qmd` | No linguistic-data issue. The mathematical reduction is not presented as a universal claim that linguistic preprocessing is lossless. |
| `regression-models/sum-coding.qmd` | **L7 reminder.** The grand mean is over the coded source groups in the retained MALD items, not a population-weighted mean. |
| `regression-models/variance-inflation-factors.qmd` | **L7 reminder.** VIF diagnoses the selected lexical predictor matrix and does not establish that one construct causes another. |
| `regression-models/why-generalized-linear-models.qmd` | No linguistic-data issue. The response support and elicitation procedure motivate the model family without reifying the task measurement. |
| `regression-models/why-not-beta-sliders.qmd` | No linguistic-data issue. Slider endpoints and interior values are tied to a response process, and the objection to a plain beta likelihood is measurement-relevant. |
| `regression-models/zero-inflated-counts.qmd` | **L9.** The structural-zero story is not licensed by truncating a normalized frequency below one count unit. Rename the response and separate proxy formation from any two-process linguistic hypothesis. |

### Model criticism and prediction

| Page | Audit result |
|:--|:--|
| `model-criticism-and-prediction/bias-variance-tradeoff.qmd` | **L10 and L15 reminder.** State that the response is a word-position mean built from retained Natural Stories trials and link predictors to their provenance table. |
| `model-criticism-and-prediction/comparing-predictive-loss.qmd` | No linguistic-data issue. Predictive loss is compared for the same MegaOrientation task target and split. |
| `model-criticism-and-prediction/cross-validation.qmd` | No new linguistic-data issue. Random-row validation is correctly distinguished from prediction for a new participant, item, or story; add the **L10** predictor-provenance link. |
| `model-criticism-and-prediction/grouped-cross-validation.qmd` | **L10 reminder.** Holding out a story tests transfer to one of ten enriched texts, not arbitrary English discourse or new readers. |
| `model-criticism-and-prediction/index.qmd` | **L10 and L14--L15.** Add the Natural Stories sample-to-claim reminder and link the response and predictors to their first full definitions. |
| `model-criticism-and-prediction/information-criteria.qmd` | **L5 reminder.** The information criterion compares models for fixation-contingent aggregated Provo responses; it does not assess the skipping process. |
| `model-criticism-and-prediction/leave-one-out-cross-validation.qmd` | **L5 reminder.** “Leave one out” removes one aggregated word-position observation, not an entire reader, sentence, or passage unless grouped validation says so. |
| `model-criticism-and-prediction/likelihood-ratio-tests.qmd` | **L5 and L15.** This is a strong Provo dossier; retain it as a canonical source, give the conditioned outcome a stable name, and add direct links from later pages. |
| `model-criticism-and-prediction/prediction-targets.qmd` | **L10 and L15.** Complete the predictor provenance and spelling-alignment example, then state which readers, texts, and word positions remain inside and outside each target. |
| `model-criticism-and-prediction/predictive-loss.qmd` | **L10 reminder.** Loss is computed for the released word-position response; link to the exact aggregation and alignment before interpreting model error. |
| `model-criticism-and-prediction/psis-loo.qmd` | **L5 reminder.** Pareto diagnostics concern sensitivity to one aggregated Provo row and should not be renamed reader-level influence. |
| `model-criticism-and-prediction/training-and-test-data.qmd` | **L10.** The split target is documented well; add predictor units and make explicit whether related positions from the same story can appear on both sides of a random-row split. |
| `model-criticism-and-prediction/waic.qmd` | **L5 reminder.** The pointwise unit is an aggregated word-position row, so the effective number of parameters is conditional on that analysis table. |

### Experimental design

| Page | Audit result |
|:--|:--|
| `experimental-design/between-participant-designs.qmd` | No linguistic-data issue. Participant assignment, item presentation, response unit, and estimand are separately named. Preserve the link to the first explanation of assignment units. |
| `experimental-design/counterbalancing.qmd` | No linguistic-data issue. The modal design cells and deviations from the realized protocol are disclosed rather than silently treated as perfect balance. |
| `experimental-design/exclusion-rules.qmd` | No linguistic-data issue. Attempted, analyzable, and retained rows are distinct states, and exclusion is not misdescribed as a property of the linguistic stimulus. |
| `experimental-design/index.qmd` | No linguistic-data issue. The index maintains the distinction among recruitment, assignment, measurement, and analysis. |
| `experimental-design/power-by-simulation.qmd` | No linguistic-data issue. The simplified missingness mechanism is declared and a sensitivity analysis is requested rather than hidden. |
| `experimental-design/random-assignment.qmd` | No linguistic-data issue. The locally unavailable assignment mechanism is marked as unavailable; no causal guarantee is inferred from the observed groups. |
| `experimental-design/units-of-assignment.qmd` | No linguistic-data issue. Participant, item, and trial assignment units are kept distinct from rows in the analysis table. |
| `experimental-design/within-participant-designs.qmd` | No linguistic-data issue. Repeated judgments, order/carryover concerns, and the participant-level comparison are explicit. |

### Latent structure

| Page | Audit result |
|:--|:--|
| `latent-structure/choosing-a-mixture.qmd` | No linguistic-data issue. The BIC comparison is tied to the speaker-token table, and the row-dependence limitation is stated. |
| `latent-structure/distance-and-scaling.qmd` | No linguistic-data issue. F1 and F2 are acoustic measurements on different numerical ranges, and scaling is not confused with perceptual normalization. |
| `latent-structure/expectation-maximization.qmd` | No linguistic-data issue. Latent component membership is a computational assignment rather than a recovered vowel essence. |
| `latent-structure/gaussian-mixtures.qmd` | No linguistic-data issue. Mixture components are explicitly model-dependent descriptions of the selected acoustic representation. |
| `latent-structure/index.qmd` | No linguistic-data issue. The module preserves the distinction among elicited word label, acoustic token, speaker, and model component. |
| `latent-structure/k-means.qmd` | No linguistic-data issue. Cluster labels do not inherit phonological category names without external validation. |
| `latent-structure/posterior-membership.qmd` | No linguistic-data issue. Posterior membership is uncertainty under the fitted acoustic mixture, not uncertainty in a listener's category perception. |
| `latent-structure/representing-objects.qmd` | No linguistic-data issue. The Peterson--Barney word/code key, F1/F2 measurements, speaker grouping, and representation target are unusually complete. |
| `latent-structure/silhouette-scores.qmd` | No linguistic-data issue. The internal separation score is not treated as proof of phonological naturalness. |
| `latent-structure/unsupervised-validation.qmd` | No linguistic-data issue. The calibration-panel target and the distinction between internal and external evidence are explicit. |
| `latent-structure/validating-a-mixture.qmd` | No linguistic-data issue. The held-out calibration logic does not turn source vowel labels into unproblematic acoustic ground truth. |
| `latent-structure/within-cluster-loss.qmd` | No linguistic-data issue. Loss is attached to the chosen acoustic coordinate system and scaling. |

### Factorization

| Page | Audit result |
|:--|:--|
| `factorization/centering-and-scaling.qmd` | **L11 reminder.** Inventory rows are PHOIBLE records, and macroarea stratification does not prevent related languages from crossing splits. |
| `factorization/choosing-components.qmd` | **L11 and L15.** The held-out-cell target is clear; add the genealogical information set and explain plainly that the test is not transfer to an unseen family. |
| `factorization/data-matrices.qmd` | **L11 and L15.** This canonical dossier should name one-inventory-per-Glottocode sampling, possible related-language overlap, and the resulting narrow cell-completion target. |
| `factorization/index.qmd` | **L11 reminder.** Preserve “inventory record” rather than “language,” and link the validation split to its first full account. |
| `factorization/principal-component-analysis.qmd` | **L11 reminder.** Components summarize the sampled inventory-feature matrix and are not universal articulatory axes. |
| `factorization/rank-one-structure.qmd` | **L11 reminder.** The inventory and segment coordinates describe co-occurrence in the prepared database, not direct phonological markedness. |
| `factorization/reconstruction.qmd` | **L11 reminder.** Reconstruction error concerns hidden cells in records whose relatives may be visible during training. |
| `factorization/scores-and-loadings.qmd` | **L11 reminder.** Scores and loadings inherit the database coding and split information; they are not measured language traits. |
| `factorization/singular-value-decomposition.qmd` | **L11 reminder.** The factorization is of a particular binary inventory-record matrix, not a decomposition of phonological systems in general. |
| `factorization/valex-megaacceptability.qmd` | **L12 and L15.** Correct the 50-rank description, state that participants remain known while verbs are held out, and explain the interval-scale approximation beside the normalization formula. |

### Missing data

| Page | Audit result |
|:--|:--|
| `missing-data/complete-case-analysis.qmd` | No linguistic-data issue. The Hillenbrand analysis identifies the retained speaker/token unit and shows how complete-case filtering changes its target. |
| `missing-data/index.qmd` | No linguistic-data issue. Missing measurement, structural absence, filtering, and unobserved linguistic value are not collapsed. |
| `missing-data/missingness-mechanisms.qmd` | No linguistic-data issue. MCAR, MAR, and MNAR are attached to an observation process rather than asserted from the observed table alone. |
| `missing-data/missingness-patterns.qmd` | No linguistic-data issue. Hillenbrand missing cells and grouping variables remain visible, and a blank acoustic cell is not described as absence of a vowel. |
| `missing-data/pca-imputation.qmd` | No linguistic-data issue. The single-imputation and transductive limitations are explicit, and completed values are not promoted to new measurements. |
| `missing-data/validating-imputation.qmd` | No linguistic-data issue. Artificial masking is distinguished from the actual missingness process and is used only for a declared calibration target. |

### Custom models

| Page | Audit result |
|:--|:--|
| `custom-models/annotations-as-measurements.qmd` | **L13 and L15.** Add the worker choice-set and adjudication protocol, keep “agreement” in place of “accuracy,” and link role class and gate outcomes to their first definitions. |
| `custom-models/annotator-effects.qmd` | No linguistic-data issue. Annotator effects concern response location under the task and are not described as annotator quality or linguistic competence. |
| `custom-models/gated-annotations.qmd` | No linguistic-data issue. The symbolic examples are explicitly hypothetical rather than fabricated source records, and the gate determines which follow-up measurements exist. |
| `custom-models/generative-stories.qmd` | No linguistic-data issue. An actual source sentence anchors the predicate-node item and the gate/measurement sequence is explicit. |
| `custom-models/index.qmd` | No independent linguistic-data issue. After **L13**, make the Turkish PropBank and UDS links name their measurement protocols rather than only the dataset titles. |
| `custom-models/parameter-recovery.qmd` | No linguistic-data issue. Simulated annotations are labeled as design-calibration data and are not passed off as empirical worker responses. |
| `custom-models/uds-measurement-model.qmd` | No linguistic-data issue. The item is a predicate node in a graph, not a lemma type, and repeated annotators/items are retained in the model. |
| `custom-models/writing-a-joint-model.qmd` | No linguistic-data issue. Omitted annotator effects are declared as a simplifying assumption rather than hidden by the joint likelihood. |
