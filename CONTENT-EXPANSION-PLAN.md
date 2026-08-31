# Plan for expanding the Statistics in Linguistics notes

> **Status:** research notebook. The course spine, assignment map, page contract, and release gates are now controlled by [`COURSE-REVAMP-SPEC.md`](COURSE-REVAMP-SPEC.md). Dataset decisions are controlled by [`research/dataset-audits/registry.md`](research/dataset-audits/registry.md), and homework release states by [`research/homework-validation/registry.md`](research/homework-validation/registry.md). A candidate mapping below is not an approved course use unless those registries say so.

## Executive recommendation

The [syllabus](syllabus/syllabus.tex) already reserves time for most of the material missing from the notes: model evaluation in Week 7, experimental design in Week 10, clustering and mixture models in Week 12, factorization in Week 13, and custom model design in Week 14. The notes should fill those units without adding lecture numbers or turning the site into a chronological slide archive.

I recommend organizing the new material around the **dataset-rotation principle (DRP)**: every major topic receives a new dataset, and no dataset serves as the full worked example for a second topic. The statistical ideas recur; the empirical materials do not. Thus, students encounter a broader sample of linguistic research while learning to transfer a method beyond the dataset on which they first saw it.

The resources named below are candidate mappings, not approved teaching datasets. The [dataset-analysis audit protocol](research/dataset-audits/README.md) requires reading the primary paper, supplement, documentation, and public code; inspecting the released observations; and running the exact instructional comparison before a page is drafted. The [audited registry](research/dataset-audits/registry.md) supersedes any unqualified assignment in this document.

Once a mapping is approved, the DRP should be implemented strictly:

1. Each class meeting or major topical page has one primary dataset.
2. A primary dataset does not anchor a later class meeting.
3. Short comparisons may mention earlier results, but they do not reopen the earlier data.
4. Problem sets use datasets not analyzed in the notes.
5. MegaAttitude and UDS appear as several of the cases, not as a spine running through the course.

This plan uses acceptability and inference judgments, lexical decisions, self-paced reading, eye tracking, infant looking times, child-caregiver interaction, sociophonetic interviews, manually labeled formant trajectories, dynamic articulography, conversational phonetics, morphological paradigms, grammatical typology, phonological inventories, and semantic annotations. The aim is **disciplinary rotation (DR)**: phonetics should recur often enough to be visible, but no empirical domain should organize the course as a whole.

A potential worry about the DRP is the **setup-cost problem (SCP)**: a new dataset may require enough background that the statistical point gets lost. The notes should control the SCP with a standard “data anatomy” block, a small prepared teaching table, and no more than five minutes of domain background before the first plot. The empirical question should change; the page grammar should not.

The plan first identifies the syllabus gaps and topical site structure, then assigns a new dataset to each meeting and assessment, specifies the worked analyses, and ends with the data and build requirements needed to sustain the rotation.

## 1. What the syllabus promises that the notes do not yet support

The current notes cover probability, random variables, distributions, statistical inference, linear regression, generalized linear models, and mixed-effects models. They also contain useful discussions of contrasts, interactions, random slopes, overdispersion, diagnostics, posterior prediction, and regularization. Those topics should remain.

The main gaps concern how models are designed, evaluated, and adapted to linguistic measurements.

| Syllabus unit | Current support | Needed notes support |
|---|---|---|
| Week 7: model evaluation | PS3 and PS4 require parts of it, but the notes lack a coherent unit | Residual criticism, held-out prediction, grouped cross-validation, information criteria, posterior predictive checks, LOO, and sensitivity analysis |
| Week 10: experimental design | Little unified treatment | Units of assignment and analysis, factorial manipulation, counterbalancing, order, exclusions, multi-site variation, missingness, and simulation-based design analysis |
| Week 11: mixed effects | Strongest later unit | A design-to-model bridge, within/between decomposition, trial-level examples, singular-fit guidance, and nonlinear mixed models |
| Week 12: clustering and mixtures | PS5 contains methods not taught in the notes | Distance, scaling, clustering, Gaussian mixtures, soft assignment, stability, and uncertainty |
| Week 13: factorization | No coherent notes unit | PCA/SVD, low-rank matrix models, masking and reconstruction, rank selection, and limits on latent interpretation |
| Week 14: custom model design | No coherent notes unit | Generative stories, annotation measurement, custom likelihoods, prior prediction, recovery, and sensitivity analysis |

Five linguistic-data principles should cut across these units.

- **Response-likelihood alignment (RLA):** choose a likelihood from the scale, support, and plausible production mechanism of the response.
- **Dependence-aware analysis (DAA):** identify participants, items, speakers, documents, annotators, languages, families, communities, and time before fitting or splitting a model.
- **Measurement-aware inference (MAI):** treat ratings, automatic parses, frequencies, surprisal values, alignments, and normalized annotations as measurements rather than error-free facts.
- **Claim-matched validation (CMV):** leave out the unit to which the claim is supposed to generalize.
- **Theory-bearing analysis (TBA):** state the linguistic hypothesis before the model, use a predictor or manipulation that distinguishes it from a live alternative, and report the resulting contrast on the response scale.

The datasets rotate, but these five principles recur on every page. A participant identifier, corpus frequency used only as a control, or an unnamed latent dimension does not satisfy TBA. If the released data contain no theoretically interpretable predictor or manipulation for the proposed outcome, the dataset should be reassigned rather than retained because its shape happens to suit a method.

## 2. Proposed topical architecture

The site should use short topical pages, descriptive titles, and no lecture numbering.

### Study design and linguistic evidence

- **From a linguistic question to an estimand**
- **Participants, items, and assignment**
- **Counterbalancing and presentation order**
- **Power by simulation**
- **Corpus samples and population claims**
- **Exclusions and missing observations**
- **Causal claims from observational corpora**
- **Consent, provenance, and redistribution**

Primary cases in this module:

- [ManyBabies 1](https://manybabies.org/MB1/) for multi-site experimental design and simulation-based power;
- [CORAAL](https://oraal.github.io/coraal) for sociophonetic corpus sampling, community structure, ethics, and causal limits.

### Model evaluation and comparison

- **What makes a model useful?**
- **Residuals as model criticism**
- **Training, validation, and test data**
- **Cross-validation for linguistic data**
- **Likelihood-ratio tests and information criteria**
- **Posterior predictive checks**
- **LOO and WAIC**
- **Sensitivity analysis**

Primary cases in this module:

- [MALD](https://pubmed.ncbi.nlm.nih.gov/29916041/) for residual criticism;
- [Natural Stories](https://aclanthology.org/L18-1012.pdf) for grouped validation;
- [Wordbank](https://wordbank.stanford.edu/) for information criteria and predictive checks;
- the [VTR Formants Database](https://www.seas.ucla.edu/spapl/VTRFormants.html) for evaluating automatically derived acoustic measurements against manual reference trajectories.

### Models for linguistic outcomes

- **Choosing a likelihood**
- **Ordinal judgments**
- **Unordered categorical outcomes**
- **Proportions, sliders, and bounded responses**
- **Counts with excess variation or zeros**
- **Reaction-time distributions**
- **Nonlinear and dynamic effects**

Each page receives a different empirical case:

- [MegaVeridicality v1](https://megaattitude.io/projects/mega-veridicality/mega-veridicality-v1/) for ordinal judgments;
- [WALS Online Feature 81A](https://wals.info/feature/81A) for multinomial dominant-word-order categories;
- White, Grimm, and Glass's [aspectual-similarity judgments](https://github.com/supermereo/aspectual-similarity-elm2026) for bounded slider responses;
- the [Newman/Ratner CHILDES corpus](https://talkbank.org/childes/access/Eng-NA/NewmanRatner.html) for counts, exposure, and longitudinal zeros;
- [GECO](https://expsy.ugent.be/downloads/geco/) for raw-scale reading-time distributions;
- [Wieling's dynamic phonetic dataset](https://research.rug.nl/nl/publications/analyzing-dynamic-phonetic-data-using-generalized-additive-mixed-/datasets/) for GAMMs and articulatory trajectories.

### Dependence in linguistic data

- **From design to random effects**
- **Crossed and nested observations**
- **Random slopes and partial pooling**
- **Within-unit and between-unit effects**
- **Singular fits and weak variance components**
- **Dependence over experimental time**

The [English Lexicon Project](https://elexicon.wustl.edu/about.html) supplies the main design-to-model case. Its visual lexical-decision data cross participants with thousands of words and include site and trial-order structure. This dataset is not used in the model-evaluation unit, which instead uses MALD, Natural Stories, Wordbank, and VTR Formants.

### Latent structure in linguistic data

- **Distances and representations**
- **Clustering linguistic objects**
- **Mixture models and soft categories**
- **Principal components and singular vectors**
- **Matrix factorization**
- **Evaluating latent structure**

The datasets rotate within the module:

- [Grambank](https://grambank.clld.org/) for clustering languages from grammatical-feature profiles;
- the [Peterson and Barney vowel data](https://search.r-project.org/CRAN/refmans/phonTools/html/pb52.html) for Gaussian mixtures over vowel formants;
- the [Buckeye Corpus](https://buckeyecorpus.osu.edu/) for PCA/SVD of speaker-level phonetic profiles;
- [MegaAcceptability](https://megaattitude.io/projects/mega-acceptability/) paired with [VALEX](https://ilexir.co.uk/valex/index.html) for testing whether corpus subcategorization distributions recover selectional acceptability, and whether a low-dimensional abstraction improves that prediction.

### Measurement and custom model design

- **Annotations are measurements**
- **Derived predictors are estimates**
- **Missingness is part of the model**
- **Writing a generative story**
- **Building a custom likelihood**
- **Prior predictive simulation**
- **Recovery and sensitivity analysis**

[Universal Decompositional Semantics](https://decomp.readthedocs.io/en/latest/) supplies the custom-model case. Raw multi-annotator responses, normalized values, confidence scores, graph structure, and conditionally absent attributes make it possible to motivate a model that cannot be reduced to ordinary regression on an error-free response.

## 3. Week-by-week introduction plan

### Week 7: What makes a model work?

**Meeting 1: Residuals as criticism, using MALD**

Use a prepared item-level subset of the Massive Auditory Lexical Decision database. MALD contains time-aligned recordings for 26,793 words and 9,592 pseudowords, together with more than 227,000 lexical decisions from 231 listeners. Students fit a deliberately inadequate Gaussian model for mean response time, then diagnose skew, heteroscedasticity, influential items, and systematic errors across frequency and duration.

The meeting should distinguish three questions:

1. Does the optimizer report convergence?
2. Does the fitted model reproduce the distributional features relevant to the claim?
3. Does the model generalize beyond the observations used to fit it?

Only the first two are answered with MALD. The next meeting changes datasets.

**Meeting 2: What should be left out, using Natural Stories**

Natural Stories contains ten controlled narrative texts, 10,245 lexical tokens in 485 sentences, and self-paced reading data from 181 recruited participants. Use it to compare an observation-level random split with participant-held-out, sentence-held-out, and story-held-out validation.

Students must connect each split to a claim:

- a token split estimates performance on additional observations from known participants and texts;
- a participant split estimates performance for new readers of known materials;
- a story split asks whether the model generalizes to new discourse material.

Introduce k-fold validation, grouped folds, leakage from repeated text, and uncertainty in predictive differences. Do not reopen MALD.

**Optional evaluation page: Information criteria and posterior prediction, using Wordbank**

Wordbank archives anonymized MacArthur-Bates Communicative Development Inventory data contributed by researchers across languages and laboratories and provides downloadable child- and item-level data. Use an English child-by-word teaching extract to compare an age-only acquisition model with models that include word or semantic-category structure. Compare likelihood-ratio tests, AIC, held-out log score, and posterior predictions of vocabulary size and item-acquisition trajectories. The point is that different criteria answer different questions, not that one criterion should always win.

**Phonetic measurement page: When a predictor is another model's output, using VTR Formants**

The VTR Formants Database provides manually labeled vocal-tract-resonance trajectories for a 538-sentence subset of TIMIT selected across speakers, gender categories, dialects, and phonetic contexts. Run one reproducible automatic formant-tracking configuration on a small teaching subset, then compare automatic estimates with the manual reference values. Students should diagnose error by speaker, vowel, time within the vowel, and local phonetic context; compare observation-level and speaker-held-out summaries; and propagate measurement uncertainty into one downstream regression. This page names the **derived-measure problem (DMP)**: an acoustic column produced by a tracker is an estimate, not a directly observed fact.

**LING 214 target:** diagnose a model and choose a validation unit that matches a stated claim.

**LING 414 extension:** compare grouped cross-validation with Bayesian LOO, inspect reliability diagnostics, and report uncertainty in the comparison.

### Week 9: Matching the distribution to the response

Retain the current binary-logistic and Poisson introductions, but follow them with outcome-specific pages that use new data.

**Meeting 1: Counts and exposure, using CHILDES**

Use the Newman/Ratner corpus, a longitudinal corpus of 121 mother-child dyads followed from roughly 7 to 24 months. Extract counts of a linguistically motivated caregiver or child form per recording, together with recording duration or total tokens as exposure.

The progression is:

1. fit a Poisson model with an offset;
2. diagnose variation beyond the Poisson mean-variance relationship;
3. compare negative-binomial predictions;
4. ask whether zeros reflect short exposure, developmental absence, sampling variability, or a separate process;
5. account for repeated children and visits.

This dataset makes offsets, longitudinal dependence, attrition, and zero interpretation concrete.

**Meeting 2: Ordinal responses, using MegaVeridicality**

MegaVeridicality v1 contains *no*, *maybe*, and *yes* veridicality judgments, 1-7 acceptability ratings, participant and list identifiers, presentation order, predicate, frame, voice, polarity, conditionality, and exclusion fields. Use the three-level veridicality response to teach cumulative-link models and predicted category probabilities.

The predictors are the theoretically diagnostic environments in the experiment. Positive versus negative matrix polarity separates veridicality from projection through negation; placing the matrix clause in a conditional antecedent tests whether the inference projects or can be locally accommodated. Call the resulting four-condition pattern a **projection profile (PP)**. Fit polarity, conditional embedding, and their interaction with participant effects and partially pooled predicate-frame slopes. Summarize the model as four predicted *no/maybe/yes* distributions and as predicate-specific PP contrasts, not as a table of latent log-odds coefficients.

Compare this analysis with two lossy alternatives: deleting *maybe* and coercing the response to a numeric score. The ordinal model should include the participant and predicate-frame variation justified by the design, but the week should focus on what the environments diagnose, the likelihood, and the thresholds rather than on maximal random-effects syntax. The acceptability rating is a measurement check, not the primary theoretical predictor.

**Short laboratory: Multinomial outcomes, using WALS Online**

Use WALS Online Feature 81A, which classifies languages as SOV, SVO, VSO, VOS, OVS, OSV, or having no dominant order. Predict a reduced set of sufficiently frequent word-order categories from other syntactic features, then treat family and macroarea as dependence and sampling variables rather than ordinary independent predictors. Teach reference categories, probability normalization, class imbalance, confusion, and the difference between predicting a database label and explaining the historical development of a language.

**Short laboratory: Bounded responses, using aspectual-similarity judgments**

Experiment 2 from White, Grimm, and Glass (2026) contains 0--100 pairwise dissimilarity judgments for event descriptions that share a verb. Use a teaching extract restricted to contentful-contentful pairs and to verbs represented by both same-sense and different-sense pairs. Compare a Gaussian mixed benchmark with an ordered-beta model, and inspect exact endpoints and participant response style before fitting either one. The [resource-specific audit](research/dataset-audits/aspectual-similarity-elm2026.md) verifies that the substantive contrast survives participant and sentence-pair dependence and that the ordered-beta model reproduces the observed boundary mass.

**LING 214 target:** map the measurement scale to a plausible likelihood and interpret predictions on the observed scale.

**LING 414 extension:** compare proportional-odds with category-specific effects; then restore the full aspectual-similarity design and use the published fixed-only versus dependence-aware interaction contrast to diagnose pseudoreplication.

### Week 10: Designing linguistic evidence

Only one instructional meeting is available because the second meeting is the midterm.

**Meeting 1: Assignment, sites, and power, using ManyBabies 1**

ManyBabies 1 studied infant preference for infant-directed over adult-directed speech across 69 participating laboratories in 16 countries, using data from 2,329 tested infants and several experimental methods. This structure makes the difference among participant count, trial count, laboratory count, method, age, and language background visible.

Students first draw the design:

- trials are repeated within infants;
- infants are sampled within laboratories;
- laboratories differ in method and population;
- the treatment contrast is within or between units according to the protocol;
- inclusion rules affect the analyzable paired contrast.

They then simulate a simplified version of the experiment. Varying the number of trials, infants, and laboratories should show why those additions are not exchangeable. A LING 414 extension can simulate site heterogeneity and method-specific effects.

**Companion page: Sociophonetic samples and causal claims, using CORAAL**

CORAAL contains audio and time-aligned transcripts from more than 220 sociolinguistic interviews across communities and time periods; phone-aligned TextGrids are also available. Use one well-defined acoustic measure in a component comparison to distinguish a descriptive association from a population or causal claim. Students identify community, speaker, interviewer, birth cohort, recording, lexical item, and token as possible dependence or selection units, then assess whether recording provenance is entangled with the linguistic comparison.

The page should also address consent, licensing, community representation, and the fact that a public download does not erase the social conditions under which speech was recorded.

**Assessment alignment:** the midterm or LING 414 proposal should require an estimand, observational units, assignment or sampling mechanism, likelihood, dependence structure, exclusion policy, and target of generalization.

### Week 11: Dependence and dynamics

**Meeting 1: From design to mixed effects, using the English Lexicon Project**

Use a manageable trial-level extract from the visual lexical-decision task. Students identify subject, word, site, session, and trial order before seeing a model formula. Compare an item-level aggregate model with a crossed subject-by-word model, then add a within-subject order effect and a between-subject characteristic.

This case supports:

- crossed participant and item intercepts;
- by-participant or by-item slopes when the design supports them;
- within-unit versus between-unit predictors;
- partial pooling;
- singular or weakly identified variance components;
- generalization to new subjects versus new lexical items.

**Meeting 2: Positive and skewed trial outcomes, using GECO**

GECO provides monolingual and bilingual eye-tracking data, English and Dutch materials, and participant information. Use one eye-movement measure to combine response-likelihood alignment with subject and word dependence. Compare log-transformed Gaussian predictions with a positive raw-scale family, checking the center, slow tail, skipped words, and group-specific distributions.

**Acoustic extension: Dynamic trajectories, using the Wieling dataset**

Use the published articulatory trajectories from L1 and L2 speakers of English to introduce GAMMs. Compare a fixed-time summary with a smooth over normalized time; add speaker and item structure; inspect autocorrelation; and evaluate held-out speakers rather than held-out time points.

**LING 214 target:** derive dependence terms from a design and interpret partial pooling.

**LING 414 extension:** compare random-effects structures, response families, and correlation assumptions.

### Week 12: Categories as statistical hypotheses

**Meeting 1: Clustering languages, using Grambank**

Grambank covers 2,467 language varieties and 195 grammatical features, with genealogy, geography, source information, and explicit unknown values. Use a balanced teaching subset to introduce representation, scaling, missingness, distance, and cluster stability.

This example should resist automatic k-means. Many Grambank features are binary, some values are unknown, and languages are related genealogically and geographically. Compare a simple Euclidean/k-means baseline with a distance suited to mixed or binary features and a medoid or hierarchical method. Then compare the resulting clusters with known families and regions without treating that agreement as proof that the algorithm discovered natural language types.

**Meeting 2: Soft vowel categories, using Peterson and Barney**

Use F1/F2 measurements from the Peterson and Barney American English vowel data. The phonTools release contains 1,520 observations from 76 speakers, with speaker type, speaker identifier, vowel label, repetition, F0, F1, F2, and F3. Fit a Gaussian mixture to a speaker-normalized subset, plot posterior component probabilities, and compare components with intended vowel labels.

The example supports:

- hard versus soft assignments;
- covariance shape;
- component number;
- label switching;
- overlap among vowel categories;
- the difference between a statistical component and a phonological category.

This dataset remains distinct from Hillenbrand in PS1. Here, the problem is soft token-level category structure in a classic controlled production study; the first meeting instead studies discrete grammatical profiles across languages.

**LING 214 target:** choose a representation and compare hard and soft assignments.

**LING 414 extension:** propagate speaker uncertainty, compare covariance structures, and assess stability under resampling.

### Week 13: Low-dimensional structure

**Meeting 1: PCA and SVD of speaker profiles, using Buckeye**

The Buckeye Corpus contains conversational speech from 40 Columbus speakers with orthographic transcripts, phonetic labels, and time alignment. Prepare a speaker-by-feature table containing interpretable summaries such as vowel-space measures, segment durations, speech rate, and reduction measures.

Use this table to teach centering, scaling, scores, loadings, sign indeterminacy, and reconstruction. Hold out speakers only for the predictive extension; the core PCA demonstration should remain descriptive.

**Meeting 2: Can distributional experience recover selectional knowledge? MegaAcceptability and VALEX**

MegaAcceptability v1 supplies a 50-frame acceptability profile for each of 1,000 clause-embedding predicates. VALEX supplies independently observed corpus counts over subcategorization frames; 958 verbs overlap in the released analysis. The unit is a verb. Its predictors are its complete VALEX subcategorization profile, and its multivariate outcome is its MegaAcceptability profile across the 50 experimental frames.

Organize the analysis around two claims from [White and Rawlins](https://arxiv.org/abs/2004.04106). The **Direct Distribution Hypothesis (DDH)** says that a suitably normalized VALEX profile should linearly predict a held-out verb's acceptability profile. The **Abstraction Hypothesis (AH)** says that a low-dimensional syntactic or semantic representation of those corpus counts should improve that prediction. Compare (i) frame-mean and total-frequency baselines, (ii) direct smoothed distributions, and (iii) a logistic factor representation. Hold out entire verbs in the outer folds; choose smoothing, rank, and ridge penalty inside the training folds.

Global predictive performance is only the first result. Predeclare frame families that bear on clause-selection theory: declarative versus interrogative complements, object-plus-tensed-clause frames associated with communication predicates, and eventive versus stative infinitival complements. Compare errors and predicted contrasts within these families, then inspect held-out profiles for verbs such as *think* and *wonder*. The substantive question is where direct distribution fails and whether abstraction repairs those failures, not whether a factorization reconstructs cells it has already helped define.

The authors' released analysis provides a numerical benchmark: the best direct VALEX representation explains about 30.4--30.6% of held-out-verb variance, depending on whether one uses the value hard-coded in Figure 12 or the saved summary table, while the best reported logistic factor representation explains about 31.3%. Thus the shallow factorization offers, at most, a small repair. The course analysis should reproduce the direction of this comparison without inheriting its avoidable validation weaknesses: estimate outcome normalization from training ratings, infer test-verb coordinates from fixed factor loadings, repeat the verb-grouped folds, and resample verbs rather than ten fold scores.

**LING 214 target:** explain the DDH and AH, compare a direct distribution with one fixed-rank factor representation, and interpret predictions for held-out verbs and predeclared frame contrasts.

**LING 414 extension:** nest smoothing and rank selection, compare inductive with transductive factor scoring, and fit a raw-rating ordinal sensitivity model that propagates uncertainty from the acceptability judgments.

### Week 14: From an annotation task to a probability model

The syllabus leaves one instructional meeting before Thanksgiving.

**Meeting 1: Custom measurement model, using UDS**

UDS represents graph-anchored semantic properties as real-valued annotations with confidence values. Its toolkit can load normalized annotations or raw responses from multiple annotators. Event-structure attributes are also conditionally present: whether some questions are answered depends on the response to a gating question.

Build the class around an annotator-aware generative story:

1. each predicate or predicate-argument relation has a latent semantic property;
2. annotators have thresholds, biases, or response noise;
3. observed ordinal or scalar responses arise from the latent property and annotator behavior;
4. confidence is an additional measurement, not a magic observation weight;
5. some attributes are inapplicable because of the annotation protocol rather than accidentally missing.

Students draw the graph, write the conditional distributions, simulate prior predictions, and identify a predictive check that could reject the model. LING 214 students modify a supplied brms or Stan template. LING 414 students add annotator-specific thresholds or a gating model and conduct parameter recovery.

The [UDS reading tutorial](https://decomp.readthedocs.io/en/latest/tutorial/reading.html) documents raw and normalized formats, while the [semantic-type reference](https://decomp.readthedocs.io/en/latest/data/semantic-types.html) documents values, confidence, and conditional event-structure attributes. [Gantt, Glass, and White](https://transacl.org/index.php/tacl/article/view/3115) provide a research-scale destination in which event classifications are induced jointly from UDS graph structure and continuous properties.

## 4. Candidate dataset rotation registry

The registry below proposes a no-reuse allocation. It does not establish analysis viability. The current decision, corrected use, and required pilot for every mapping appear in the [audited registry](research/dataset-audits/registry.md). “Use” here means the one location the dataset would occupy if its mapping is approved.

| Topic or assessment | Dataset | Linguistic object | Full use |
|---|---|---|---|
| Residual model criticism | MALD | Auditory lexical-decision latency | Week 7, Meeting 1 |
| Grouped validation | Natural Stories | Self-paced reading in narratives | Week 7, Meeting 2 |
| Information criteria/PPC | Wordbank | Parent-reported vocabulary development | Evaluation extension |
| Derived acoustic measurement | VTR Formants | Manual and automatic formant trajectories | Evaluation extension |
| Count models | Newman/Ratner CHILDES | Longitudinal child-caregiver speech | Week 9, Meeting 1 |
| Ordinal models | MegaVeridicality v1 | Veridicality judgments | Week 9, Meeting 2 |
| Multinomial models | WALS Online Feature 81A | Dominant constituent-order categories | Week 9 laboratory |
| Bounded responses | Aspectual similarity, Experiment 2 | Pairwise event-description dissimilarity | Week 9 laboratory |
| Experimental design/power | ManyBabies 1 | Infant-directed-speech preference | Week 10 |
| Corpus sampling/causal limits | CORAAL | Sociophonetic interview data | Week 10 companion page |
| Mixed-effects design | English Lexicon Project | Visual lexical-decision trials | Week 11, Meeting 1 |
| Positive trial distributions | GECO | Monolingual/bilingual eye tracking | Week 11, Meeting 2 |
| Nonlinear trajectories | Wieling dynamic phonetics | L1/L2 articulatory trajectories | Week 11 extension |
| Clustering | Grambank | Cross-linguistic grammatical profiles | Week 12, Meeting 1 |
| Gaussian mixtures | Peterson and Barney | American English vowel formants | Week 12, Meeting 2 |
| PCA/SVD | Buckeye | Conversational speaker profiles | Week 13, Meeting 1 |
| Distributional prediction and factorization | VALEX + MegaAcceptability v1 | Corpus subcategorization profiles predicting predicate-frame acceptability | Week 13, Meeting 2 |
| Custom models | UDS | Raw semantic annotations | Week 14 |
| PS1 dataset | Hillenbrand | American English vowel acoustics | PS1 only |
| PS3 transfer dataset | Provo Corpus | Eye tracking with predictability norms | PS3 only |
| PS4 transfer dataset | CommitmentBank | Projection judgments in discourse | PS4 only |
| PS5 transfer dataset | PHOIBLE 2.0 | Cross-linguistic segment inventories | PS5 only |

The registry also provides a disciplinary balance check. Psycholinguistics and acquisition supply MALD, Natural Stories, Wordbank, CHILDES, ManyBabies, the English Lexicon Project, and GECO. Syntax, semantics, morphology, and typology supply MegaVeridicality, the aspectual-similarity judgments, WALS, Grambank, MegaAcceptability, and UDS. Phonetics and sociophonetics supply VTR Formants, CORAAL, Wieling, Peterson and Barney, and Buckeye. The assessment datasets extend each strand without becoming lecture examples.

These sets are not mutually exclusive: CORAAL is both a corpus and a sociophonetic resource, while ManyBabies is both speech perception and developmental psycholinguistics. That overlap is desirable. The balance should be evaluated by the questions students ask, not by forcing every dataset into exactly one disciplinary bin.

### Migration from the current examples

The no-reuse rule requires changing some material that already exists, not merely assigning new datasets to new pages.

- Keep MALD only in the residual-criticism unit. Replace its current mixed-effects example with the English Lexicon Project, PS3 with Provo, and PS4 with CommitmentBank.
- Keep Hillenbrand only in PS1. Use Peterson and Barney for mixture models, VTR for acoustic-measure validation, and Wieling for dynamic phonetics.
- Keep the German UniMorph data only in PS1. Use WALS Feature 81A for the new multinomial page.
- Reserve VALEX for the MegaAcceptability analysis. If it currently anchors a Poisson or mixed-effects analysis, replace those uses; the English Lexicon Project supplies the mixed-effects replacement, and CHILDES supplies the count-model case.
- Treat brief references to an earlier result as callbacks, not analyses: no code, data reload, or second worked model.

This migration makes the registry describe the entire revised course rather than only the newly written pages.

## 5. Concrete worked analyses

### MALD: how a model fails

1. Fit a simple mean-response-time model.
2. Plot residual shape and variance against fitted values.
3. Identify influential lexical items.
4. Compare observed and predicted tail behavior.
5. Fit one better response model and state which failure it addresses.

Stop there. MALD does not reappear in cross-validation, mixed effects, or the assignments.

### VTR Formants: acoustic measurements are estimates

1. Generate automatic formant tracks with one frozen configuration.
2. Compare them with the manual reference trajectories.
3. Plot error by speaker, vowel, time point, and phonetic context.
4. Compare token-level and speaker-held-out error.
5. Refit one downstream model under plausible measurement perturbations.

### Natural Stories: what a split means

1. Define a prediction target.
2. Construct token, participant, sentence, and story folds.
3. Verify that grouping identifiers do not leak across folds.
4. Compare predictive scores and their uncertainty.
5. Explain why the scores differ.

### MegaVeridicality: estimate projection profiles

1. Plot *no/maybe/yes* responses by polarity and conditionality.
2. Derive what each environment diagnoses: positive polarity for veridicality, negation for factive projection, and a conditional antecedent for local accommodation.
3. Show the information lost by deleting or collapsing *maybe*.
4. Fit a partially pooled ordinal PP model with polarity, conditional embedding, and predicate-frame variation.
5. Plot the four predicted category distributions and predicate-specific changes across environments.
6. Check participant response style, the rare *no* category, and whether the proportional-odds restriction reproduces the observed condition profiles.

### Aspectual similarity: boundaries are outcomes

1. Construct the within-verb teaching extract from contentful-contentful test pairs.
2. Plot the 0--100 distribution, exact endpoints, and participant response styles.
3. Fit a Gaussian mixed benchmark with participant and sentence-pair intercepts.
4. Quantify the benchmark's predictive mass outside the legal response scale.
5. Fit an ordered-beta model with the same linear predictor.
6. Compare observed and posterior-predicted boundary mass, interior shape, and same-sense contrasts.
7. In the LING 414 extension, restore probabilistic same-sense and use the published interaction change to demonstrate pseudoreplication.

### ManyBabies 1: power follows the design

1. Diagram trials, infants, laboratories, methods, and language backgrounds.
2. Simulate laboratory and infant heterogeneity.
3. Add trials, infants, or laboratories in separate scenarios.
4. Plot power or interval coverage.
5. Explain which population each scenario improves coverage of.

### English Lexicon Project: the formula follows the units

1. Inspect trial, subject, word, site, session, and order identifiers.
2. Fit an aggregate word model.
3. Fit a crossed subject-word model.
4. Add a within-subject order effect.
5. Compare predictions for new subjects and new words.

### Grambank: the representation comes before the clustering

1. Select features and languages without using outcome labels.
2. Visualize unknown values and family/region composition.
3. Compare distances and clustering methods.
4. Assess stability under resampling.
5. Compare clusters with genealogy and geography.
6. State why agreement does not entail a discovered linguistic type.

### Peterson and Barney: components are not phonemes

1. Normalize speaker formants.
2. Fit mixtures with different covariance assumptions and component counts.
3. Plot soft assignments.
4. Compare components with vowel labels.
5. Inspect the vowels and speakers with uncertain membership.

### Buckeye: low-dimensional speaker profiles

1. Create a documented speaker-by-measure matrix.
2. Compare centered and standardized PCA.
3. Interpret scores and loadings jointly.
4. Reconstruct profiles at several ranks.
5. Check whether the apparent dimensions are driven by a small set of measures or speakers.

### MegaAcceptability and VALEX: test the distribution-to-selection mapping

1. Construct the VALEX verb-by-SCF count matrix and the MegaAcceptability verb-by-frame outcome matrix for the 958 shared verbs.
2. State the DDH and AH before fitting a model.
3. Hold out entire verbs and establish frame-mean and total-frequency baselines.
4. Predict the 50-frame outcome from a direct smoothed VALEX distribution with multivariate ridge regression.
5. Factor the VALEX matrix, infer held-out verb scores, and test whether the factor representation improves prediction.
6. Report pooled and frame-specific held-out performance for predeclared declarative/interrogative, object-plus-clause, and infinitival contrasts.
7. Inspect complete predicted profiles for held-out verbs and separate evidence for prediction, abstraction, and grammatical interpretation.

### UDS: model the annotators

1. Extract raw responses, normalized values, confidence, graph identifiers, and semantic attributes.
2. Compare raw disagreement with normalized point estimates.
3. Identify conditionally absent attributes.
4. Write an annotator-aware generative model.
5. Simulate prior predictions.
6. Fit a small subset and conduct parameter recovery.
7. Compare the raw-response analysis with one that treats normalized scores as fixed.

## 6. Assessment changes

The assessments should implement a **transfer-first assessment (TFA)** rule: students apply a method to a dataset that did not appear in the worked notes. The existing Hillenbrand analysis remains confined to PS1; no instructional page reuses it.

### PS3: predictive evaluation with the Provo Corpus

The [Provo Corpus](https://pubmed.ncbi.nlm.nih.gov/28523601/) combines eye-tracking data with word-level predictability norms, including orthographic, morphosyntactic, and semantic predictability measures. Students should:

1. state whether the target is a new participant, word, sentence, or passage;
2. construct at least two matching validation schemes;
3. compare models with lexical and predictability covariates;
4. diagnose one distributional failure;
5. report predictive uncertainty.

This tests transfer from MALD and Natural Stories without repeating either.

### PS4: Bayesian model criticism with CommitmentBank

[CommitmentBank](https://github.com/mcdm/CommitmentBank/) contains 1,200 naturally occurring discourses and participant-level projection judgments on a seven-point scale, together with embedding environment, predicate, genre, and contextual annotations. Students should:

1. fit a hierarchical ordinal or carefully justified alternative model;
2. conduct prior predictive checks;
3. check response-category, predicate, and embedding-environment predictions;
4. compare two models with LOO or WAIC and report uncertainty;
5. conduct one sensitivity analysis.

This provides Bayesian judgment modeling without repeating MegaVeridicality.

### PS5: latent structure with PHOIBLE

[PHOIBLE 2.0](https://phoible.org/) contains 3,020 phonological inventories representing 2,186 languages, with 3,183 segment types and distinctive-feature information. Students should work with a carefully sampled language-by-segment or language-by-feature matrix.

- **LING 214:** compare PCA or another projection with clustering; assess stability; interpret one dimension or group; and identify genealogical or areal confounds.
- **LING 414:** add a low-rank or probabilistic factorization, evaluate held-out cells, and compare results across sampling or preprocessing choices.

This tests the Week 12-13 methods in a phonological domain not used in lecture. Students must state how genealogical and areal sampling constrain any interpretation of the latent dimensions.

### LING 414 project

Require four checkpoints:

1. **design audit:** units, sampling or assignment, dependence, missingness, and exclusions;
2. **response audit:** support of the outcome and likelihood justification;
3. **generalization audit:** target population or unit and matching validation;
4. **model criticism:** one predictive check and one sensitivity analysis.

Students may use any approved public or properly authorized dataset, but the project should not duplicate one of the course's prepared teaching extracts without a substantively new research question.

## 7. Data engineering and reproducibility

The DRP increases the number of data sources, so data preparation must be standardized.

Every dataset should have:

    data/<dataset>/
      README.md
      CITATION.md
      LICENSE-or-TERMS.md
      fetch/
      raw/                   # gitignored unless redistribution is permitted
      derived/
        teaching.csv         # small, analysis-ready extract
      codebook.md
      provenance.yml

For each source:

- pin a release or record the retrieval date;
- retain identifiers needed for participants, items, speakers, documents, sites, annotators, languages, and families;
- write a deterministic preparation script;
- check row counts, identifier uniqueness, ranges, missingness, and joins;
- provide a small in-repository extract only when redistribution is permitted;
- freeze train/test masks and random seeds;
- store expensive fitted objects outside the ordinary site render;
- document every derived variable;
- include the requested citation and license on the rendered page.

The teaching extracts should be deliberately small. The goal is not to reproduce a project's entire data-engineering pipeline during class. Each extract should preserve the dependence and measurement structure needed for the statistical question, and it should omit irrelevant columns only after that decision is documented.

UDS requires a Python extraction script because the natural interface is decomp, while the course is R-centered. Prepare flat raw-annotation and normalized-annotation tables, then analyze those tables in R. Explain the graph-to-table projection on the page.

The aspectual-similarity laboratory requires a deterministic R extract from `data-similarity.csv`, the release commit and CC BY-SA 4.0 license, and a cached ordered-beta fit. Keep the 4,405-row within-verb teaching extract in the repository if share-alike redistribution is acceptable; otherwise provide the extraction script and checksum. The full three-experiment model and its roughly six-hour cold run belong in the LING 414 extension, not the ordinary site render.

CORAAL, Buckeye, and VTR Formants require source-specific licensing and ethical care. Do not commit audio or derived acoustic tables until redistribution has been checked for that source. The repository should prefer small, versioned measurement tables when permitted and provide deterministic scripts that authorized users can run locally when it is not. Documentation should preserve how speakers and communities are described by the source, state the limits of the sampling frame, and distinguish manual labels, phonetic annotations, and automatically estimated acoustic measures.

## 8. Page template

Every topical page should use the same structure to control the SCP:

1. **Linguistic question**
2. **Data anatomy:** response, predictors, units, dependence, missingness, and scale
3. **Why this dataset fits this method**
4. **Generative story**
5. **Probability model**
6. **Worked analysis**
7. **Model criticism**
8. **Licensed interpretation**
9. **Try it**
10. **LING 414 extension**
11. **Data, license, and citation**

The first plot should appear early. Domain background should be sufficient to interpret that plot, but it should not become a miniature literature review. Code should be folded after the first complete example.

Each page should end with two short prompts:

- What would count as a new observation for this claim?
- Which feature of this dataset would break a simpler model?

These recurring prompts provide conceptual continuity while the datasets change.

## 9. Build sequence

### Phase 1: establish the rotation and audit infrastructure

1. Add the common data-anatomy and source callouts.
2. Create the dataset directory template.
3. Add a registry that prevents accidental reuse of a primary dataset.
4. Prepare citation, license, and provenance checks.
5. Run and archive the required paper-first and data-pilot audit before moving a candidate into page production.

### Phase 2: close the scheduled gaps

1. Build MALD residual criticism, Natural Stories validation, and VTR measurement validation for Week 7.
2. Build ManyBabies power and CORAAL sociophonetic design for Week 10.
3. Build Grambank clustering and Peterson-Barney mixtures for Week 12.
4. Build Buckeye PCA and the VALEX-to-MegaAcceptability distributional-prediction analysis for Week 13.
5. Build the UDS custom-model capstone for Week 14.

### Phase 3: expand linguistic outcome coverage

1. Add the MegaVeridicality ordinal page.
2. Add the WALS multinomial page.
3. Add the aspectual-similarity bounded-response page.
4. Add the CHILDES count page.
5. Add the GECO positive-response page.
6. Add the Wieling GAMM page.

### Phase 4: strengthen design and dependence

1. Add the CORAAL corpus-sampling and causal-claims page.
2. Add the English Lexicon Project design-to-model page.
3. Add the Wordbank information-criteria/PPC page.

### Phase 5: align the assessment datasets

1. Keep Hillenbrand confined to PS1 and remove it from any instructional page.
2. Rebuild PS3 around Provo.
3. Rebuild PS4 around CommitmentBank.
4. Rebuild PS5 around PHOIBLE.
5. Add the LING 414 design, response, generalization, and criticism audits.

### Phase 6: integration and quality control

1. Add topical navigation without week or lecture numbers.
2. Render from a clean environment.
3. Verify source links, licenses, citations, and acknowledgments.
4. Run every exercise and solution against frozen extracts.
5. Confirm that no primary dataset appears twice in the rotation registry.
6. Confirm that LING 214 can omit LING 414 callouts without creating gaps.
7. Audit terminology, notation, plots, and response-scale predictions across pages.

## 10. Scope decisions

The following content should be core:

1. experimental and corpus design;
2. grouped model evaluation and predictive checks;
3. ordinal outcomes;
4. validation and uncertainty of derived acoustic measurements;
5. dependence at participant, item, speaker, document, site, and language levels;
6. clustering, mixtures, PCA, and factorization with evaluation;
7. annotation as measurement;
8. custom generative stories and prior prediction.

The following content should be shorter laboratories or LING 414 extensions:

1. multinomial, beta, hurdle, and zero-inflated models;
2. GAMMs and autocorrelation;
3. causal diagrams for corpus research;
4. annotator-specific measurement models;
5. simulation-based calibration;
6. genealogy-aware or spatial models.

The rotation should not become a collection of disconnected demos. The RLA, DAA, MAI, and CMV questions should appear on every page, and notation should remain stable across datasets. That is where continuity belongs.

No discipline should be confined to optional callouts. The core path should contain at least one sustained case from (i) phonetics or sociophonetics, (ii) psycholinguistics or acquisition, (iii) syntax or semantics, and (iv) corpus or typological research. VTR Formants and Wieling can remain shorter extensions if calendar pressure requires a cut because CORAAL, Peterson and Barney, and Buckeye already keep phonetic evidence on the core path.

## 11. Expected result

After this expansion, students should be able to do four things:

1. identify design, measurement, and dependence structures in unfamiliar linguistic datasets;
2. select and criticize a probability model that respects those structures;
3. match validation to the participant, item, speaker, document, site, language, or annotation claim at issue; and
4. transfer a method across judgment, processing, speech, corpus, developmental, typological, and semantic data.

The final site would match the syllabus, preserve its topical and finely divided organization, and keep the empirical material changing often enough that each statistical method has to be learned rather than merely replayed.

Three implementation choices remain live: which optional laboratories should enter the LING 214 path, which licensed sources permit an in-repository teaching extract, and how much custom-model implementation LING 414 students can complete before the final-project presentations. Those choices can be settled during the data-preparation phase without weakening the DRP.
