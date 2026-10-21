# Data-grounded notes plan

## Status and controlling rule

This plan records the synthesis of the read-only planning swarm completed on
2026-10-18. It governs the replacement of schematic numerical examples in the
rendered course notes.

> Symbolic definitions and derivations may remain general. Every displayed
> probability, expectation, variance, fitted parameter, interval, test statistic,
> loss, or other worked numerical quantity must be computed from an identified
> linguistic dataset by visible R code.

This requirement changes the earlier fresh-dataset rule. A dataset may anchor a coherent
run of adjacent pages when those pages develop one empirical object through a
sequence of concepts. It should not reappear as a second, disconnected
application after the course has switched to another empirical question. Problem
sets should still use transfer datasets unless the instructor explicitly changes
that assessment policy.

Before an empirical run may
enter the notes, its developer must read the primary paper, release documentation,
annotation or representation guidelines, and original analysis code when that
code is available. The resulting evidence card must distinguish what the released
rows encode from what the paper sampled or inferred, reconcile differences in
reported and released counts, record the license and source pin, and state which
claims the simplified classroom analysis can and cannot support. Column names and
README summaries are not substitutes for this work. A promising dataset remains
blocked until a source-aligned pilot has passed.

All course-facing prose must use established statistical and linguistic terminology
and notation for technical objects. A recurring local problem, mechanism,
phenomenon, or framework may receive a transparent pedagogical name when the name
is defined immediately and then used consistently. Give an abbreviation on first
use only when it will recur, and do not present a local name as an established
technical term.

## Page contract

Each empirical page must satisfy the following requirements.

1. Retain the existing mathematical definition and derivation.
2. Name the empirical question before substituting values into the mathematics.
3. On first use, introduce the dataset, observational units, focal variables,
   original study, pinned source, license or terms, and relevant preprocessing.
4. Show all R code needed to load the data, define the analysis subset, transform
   variables, calculate or fit the target, and draw the figure. No page may depend
   on an object silently created on another page.
5. Generate reported numbers from code and add assertions for central results.
6. Show raw observations or empirical masses. When a model is fitted, show the
   raw data and fitted model together whenever they share a meaningful scale.
7. Use a restrained scientific style: gray or black raw observations, at most one
   accent color unless grouping requires more, direct axis labels with units,
   sparse or absent grid lines, no decorative icons, and no prose-heavy internal
   callouts. Annotations are reserved for a focal observed statistic, threshold,
   held-out boundary, selected rank, or influential observation.
8. Fix and report seeds, folds, masks, candidate grids, and package versions when
   stochastic computation or validation is involved.
9. Fit preprocessing inside training folds or masks. Preserve participant, item,
   speaker, document, language, family, site, and annotator identifiers needed to
   represent dependence.
10. End with the licensed empirical interpretation and one limitation of the
    analysis.

## Dataset rotation

| Run | Natural page span | Main variable types | Source and status |
|---|---|---|---|
| UD Turkish BOUN corpus and WH annotations | `foundations/zipfs-law.qmd` through `foundations/independence.qmd`; selected categorical pages | 104,426 non-punctuation word tokens and 33,876 lowercased form types; categorical WH lemma and dependency relation; binary object indicator | [UD Turkish BOUN](https://universaldependencies.org/treebanks/tr_boun/), release 2.18, CC BY-SA 4.0; the teaching WH extract contains 167 `hangi`/`kim`/`ne` core arguments |
| CMU Pronouncing Dictionary | random-variable definitions, PMFs, moments, geometric and negative-binomial families | orthographic entry; phone sequence; phone and vowel counts | [CMUdict](https://github.com/cmusphinx/cmudict); pin release/commit during preparation |
| Hillenbrand vowels | continuous-variable and reference-distribution pages; elementary estimation and paired inference | repeated speaker-by-vowel duration and F0--F3 measurements | [Hillenbrand et al. 1995](https://doi.org/10.1121/1.411872); use raw permissioned release for missingness and an audited teaching table elsewhere |
| Turkish UniMorph | finite-population sampling, contingency inference, and beta-binomial updating | lemma and past-tense suffix-final sequence in the verified verb paradigm | [UniMorph Turkish](https://github.com/unimorph/tur), CC BY-SA 3.0; restrict inference to the manually checked verb analysis described by the release paper |
| English dative alternation | count and joint-distribution pages; missingness diagnosis | construction, modality, verb and argument properties, word counts, speaker availability | [Bresnan et al. 2007](https://web.stanford.edu/~bresnan/qs-submit.pdf); prepared from `languageR` |
| Provo Corpus | bounded distribution examples, Bayesian computation, and initial linear regression | bounded predictability scores, POS, word length, reading-time summaries, passage identifiers | [Luke and Christianson 2018](https://doi.org/10.3758/s13428-017-0908-4), [OSF source](https://osf.io/sjefs/) |
| UD Turkish BOUN personal pronouns | sampling and likelihood opening | pronoun form, eight morphological case values, register, sentence and token IDs | same pinned Turkish BOUN 2.18 release; 2,128 retained personal-pronoun tokens |
| MALD | multiple regression, diagnostics, heteroscedasticity, and distributional regression | trial or item RT, accuracy, duration, phones, syllables, frequency, POS, participant/item IDs | [Tucker et al. 2019](https://doi.org/10.3758/s13428-018-1056-1), [data DOI](https://doi.org/10.7939/r3-kh0r-r116) |
| SuperTelicity | Bernoulli GLMs and selected mixed GLMs | binary temporal-preposition response; participant, verb, clause, and condition factors | [companion repository](https://github.com/SuperMereo/supertelicity), pinned commit `e45277c`, CC BY-SA 4.0; the teaching GLMs are simplified population fits, not reproductions of the source Bayesian mixed model |
| Nettle linguistic diversity | Poisson means, exposure, and initial dispersion diagnosis | country language counts, population, area, climate | [course source](https://github.com/bodowinter/applied_statistics_book_data/blob/master/nettle_1999_climate.csv) |
| Storme liaison | zero patterns and negative-binomial regression | reconstructed word counts, liaison status, final consonant, exposure | [Storme 2024](https://doi.org/10.1007/s11525-024-09429-8), [Zenodo](https://doi.org/10.5281/zenodo.12733801) |
| MegaVeridicality | empirical categorical probabilities, ordinal regression, and ordinal mixed models | ordered `no < maybe < yes` judgments crossed by verb, polarity, task, item, and task-specific participant | **pilot passed** on the 14,951-row active/native v1 subset; [White and Rawlins 2018](https://aclanthology.org/L18-1261/) and the [release](http://megaattitude.io/projects/mega-veridicality/) |
| MegaOrientation | interaction structure and grouped predictive comparison | 1--7 orientation judgments; paired past/future items, predicate frame, verb, participant | **pilot passed** for raw paired plots and population ordinal interaction with grouped-by-verb prediction; [MegaOrientation v1.1](http://megaattitude.io/projects/mega-orientation/). Do not reproduce the paper's latent-type model with the teaching fit |
| CommitmentBank | PS4 transfer dataset, not the default notes anchor | -3--3 ratings; annotator, discourse, predicate, embedding and genre variables | [CommitmentBank](https://github.com/mcdm/CommitmentBank), [de Marneffe et al. 2019](https://doi.org/10.18148/sub/2019.v23i2.601) |
| MegaNegRaising v1.1 | bounded and ordered-beta responses | paired 0--1 neg-raising and ease sliders; voice, subject, verb, sentence, participant | [An and White 2020](https://aclanthology.org/2020.scil-1.45/), [official release](https://megaattitude.io/projects/mega-negraising/), CC BY-SA 4.0; use the audited balanced past-tense eventive-infinitival subset |
| Aspectual-similarity judgments | blocked reference evidence only | 0--100 dissimilarity, endpoints, sense relation, participant, verb, sentence pair | local CC BY-SA 4.0 extract; do not deploy until the public paper/data source and title mismatch are reconciled |
| English Lexicon Project or an approved connected replacement | linear mixed-model sequence | trial RT and accuracy; participant, item, trial order, lexical predictors | [Balota et al. 2007](https://doi.org/10.3758/BF03193014); redistribution must be resolved before committing an extract |
| Natural Stories | prediction targets through grouped predictive loss | RT, participant, story, sentence, word position, frequency, surprisal | [Natural Stories](https://github.com/languageMIT/naturalstories), pin corrected commit `4700daad696e942f5aba23c957a7423d0de66612` |
| ManyBabies 1 | experimental-design sequence | trial looking time; infant, lab, stimulus, register, age, method, validity and exclusions | [ManyBabies 1](https://manybabies.org/MB1/), [OSF](https://osf.io/re95x/), [ManyBabies Consortium 2020](https://doi.org/10.1177/2515245919900809) |
| UCCA French--English 20K v2 | paired-observation and paired-mean inference pages | aligned passage graphs; primary/remote/implicit edges and graph-derived Scene counts | **pilot passed** on 154 source-order pairs. Use v2 only; [Sulem, Abend, and Rappoport 2015](https://aclanthology.org/W15-3502/) provides the original question, but the current release does not reproduce its counts |
| ITU/IMST Turkish PropBank | short annotation-measurement bridge only | candidate argument, semantic role, worker judgment, adjudicated label, core/adjunct status | **pilot passed** for a privacy-sanitized 55,207-judgment extract. [Şahin and Adalı 2018](https://doi.org/10.1007/s10579-017-9390-y); agreement is with adjudication, not independent linguistic truth |
| Jacy/Tanaka Japanese MRS profiles | missingness-pattern and grammar-coverage pages only | profile item, sentence length, profile, and presence of a human-selected preferred analysis | **pilot passed** for 15,000 items and 8,670 selected items at Jacy pin `82c282e`. The 9,128 preference rows are not distinct items; preferred analyses are grammar outputs, not usage-frequency observations |
| Peterson--Barney vowels | all latent-structure pages | F1/F2 acoustics; vowel, speaker, sex, repetition | [Peterson and Barney 1952](https://doi.org/10.1121/1.1906875); load `phonTools::pb52` without vendoring |
| PHOIBLE 2.0, then VALEX + MegaAcceptability | factorization through component selection, then the distributional-prediction application | sparse binary inventory matrix; corpus frame counts/proportions; ordinal judgments | [PHOIBLE 2.0](https://zenodo.org/records/2593234), [VALEX](https://ilexir.co.uk/valex/index.html), [MegaAcceptability](https://megaattitude.io/projects/mega-acceptability/) |
| UDS event structure | custom joint models, annotator effects, recovery, and capstone | sparse crossed binary natural-parts judgments; item and annotator effects | [White et al. 2020](https://aclanthology.org/2020.lrec-1.699/), pinned `decomp` 0.3.2 extract, CC BY-SA 4.0 |

## Page mapping by conceptual run

### Data and probability

- `foundations/linguistic-data.qmd` and `making-sense-of-data.qmd`: introduce
  speaker-by-vowel rows, keys, dependence, aggregation, and the empirical paired
  F1 contrast.
- `foundations/zipfs-law.qmd`: use the full Turkish BOUN word-form inventory for a
  paper-aligned replication of Piantadosi's rank-frequency measurement lesson.
  The page fits the finite-support multinomial Zipf--Mandelbrot model and names the
  difference from the paper's restricted ANC analysis; it does not use a toy
  equal-probability simulation or claim to reproduce the paper numerically.
- `foundations/possibilities-and-events.qmd` through `independence.qmd`: use the
  pinned Turkish BOUN 3-by-2 WH-lemma-by-dependency table for outcomes, events, generated
  event spaces, empirical measures, unions/intersections, joint and conditional
  probability, factorization, Bayes' rule, and comparison with the
  product-of-marginals table.

### Random variables and distributions

- `why-random-variables.qmd` through `probability-mass-functions.qmd`: define phone
  count and vowel-phone count over CMUdict pronunciation entries and build the
  empirical PMF.
- `continuous-random-variables.qmd` through `cumulative-distribution-functions.qmd`:
  use Hillenbrand vowel duration for the distinction among stored measurements,
  continuous models, histogram density, and empirical CDFs.
- `expected-values.qmd` through `central-moments.qmd`: compute expectations,
  transformed expectations, tail-sum linearity, variance, standard deviation, and
  higher moments from the CMUdict phone-count PMF. Retain the Cauchy nonexistence
  proof but anchor its location and scale to the observed vowel distribution.
- `bernoulli-and-categorical-distributions.qmd` through
  `binomial-distribution.qmd`: return to the empirical Turkish UD WH distribution.
- `hypergeometric-distribution.qmd`: use the full audited Turkish UniMorph verb population
  and fixed teaching sample.
- `geometric-distribution.qmd` and `negative-binomial-distribution.qmd`: use
  consonants before the first or third vowel phone in CMUdict, showing empirical
  PMFs against fitted families.
- `poisson-distribution.qmd`: use recipient length beyond the first word in the
  dative data and show the observed failure of the equal-mean-variance model.
- `uniform-distribution.qmd` and `beta-distribution.qmd`: use bounded Provo
  predictability scores, showing the raw distribution beside the reference/fitted
  density.
- `normal-distribution.qmd` through `student-t-distribution.qmd`: use actual
  Hillenbrand vowel measurements and paired speaker differences.
- `inverse-transform-sampling.qmd` and `random-seeds.qmd`: sample from the empirical
  Turkish UD WH-lemma PMF; seeds remain computational settings, not invented linguistic
  probabilities.
- `joint-probability.qmd` through `correlation.qmd`: use the dative table for joint,
  marginal, conditional, covariance, and correlation quantities.

### Statistical inference

- UD Turkish BOUN personal pronouns anchor populations/samples, sampling units, a corpus proportion,
  Bernoulli likelihood, and maximum likelihood. The audited WH dependency table
  anchors Poisson maximum likelihood and lack of fit.
- Hillenbrand paired speaker differences anchor resampling distributions, standard
  errors, estimator bias/MSE, intervals, tests, and a declared independent-group
  comparison. UCCA French--English aligned passage graphs anchor the paired-
  observation and paired-mean pages only if graph-aware extraction reconciles the
  paper and v2 release counts.
- Turkish UniMorph anchors Fisher/chi-squared tables and the beta-binomial Bayesian update,
  including prior and posterior predictive counts.
- Provo passage or participant summaries anchor nonconjugate posteriors, Monte
  Carlo integration, importance sampling, Markov chains, MH, HMC/NUTS, Stan,
  diagnostics, generated quantities, and posterior predictive checks. Every
  algorithmic trajectory must target this empirical posterior rather than a toy
  normal density.

### Regression and generalized models

- Provo anchors conditional means, simple regression, centering, transformation,
  OLS, uncertainty, fitted-versus-observed plots, and residuals.
- MALD anchors multiple regression, design matrices, categorical coding,
  collinearity, ridge/residualization, influence, heteroscedasticity, and
  distributional regression. MegaOrientation supplies the raw paired
  orientation-by-frame interaction contrast; ordinal fitting is deferred until
  its response model and grouped validation target have been introduced.
- SuperTelicity anchors the Bernoulli GLM sequence from link functions through
  deviance residuals.
- Nettle anchors Poisson regression, offsets, and the first dispersion check;
  Storme anchors zero-pattern diagnosis and negative-binomial regression.
- MegaVeridicality anchors empirical response-category probabilities, ordinal
  regression, and ordinal mixed modeling if its pilot preserves task-specific
  participant identifiers and passes grouped-by-verb validation. MegaOrientation
  then anchors interactions and grouped predictive comparison if its paired
  predicate-frame structure passes its pilot. CommitmentBank remains the PS4
  transfer dataset rather than a repeated notes example. The public
  MegaNegRaising release anchors the bounded-response and ordered-beta pages;
  the aspectual-similarity fit remains blocked reference evidence.
- The licensed connected MALD trials anchor the continuous crossed-model sequence.
  SuperTelicity supplies the Bernoulli continuation and Laplace calculation,
  MegaVeridicality supplies the ordinal continuation with task-qualified
  respondent identifiers and unseen-verb evaluation, and paired French--English
  UCCA passages supply Scene counts with word exposure and passage-pair grouping.
  The language contrast is descriptive within this release, and the fitted count
  model is underdispersed. ELP and the blocked aspectual-similarity source remain
  excluded.

### Prediction and design

- Natural Stories anchors new-row/new-participant/new-story targets, predictive
  loss, train/test separation, K-fold and leave-one-out prediction, grouped folds,
  and model comparison. Folds and preprocessing must be stored and fit within
  training data.
- Provo posterior log likelihood anchors likelihood-ratio, AIC/BIC, PSIS-LOO, and
  WAIC where the same observations and model family are required.
- ManyBabies anchors the complete design run: assignment units, within-infant
  contrasts, counterbalancing, exclusions, and hierarchical design simulation.
  A between-participant page must use a documented randomized between-unit factor;
  laboratory method may appear only as an observational grouping variable.

### Latent structure and factorization

- Peterson--Barney anchors representation, scaling, K-means, loss, silhouettes,
  speaker-held-out validation, Gaussian mixtures, posterior membership, EM, BIC,
  and grouped mixture validation. Labels remain external metadata unless a page
  explicitly evaluates alignment.
- PHOIBLE anchors matrix construction, binary centering, rank-one structure, SVD,
  PCA, scores/loadings, reconstruction, and masked rank selection.
- VALEX + MegaAcceptability anchors the final factorization application, with all
  participant normalization, ridge tuning, PCA, rank selection, and held-out verb
  scoring performed inside folds.

### Missing data and custom models

- Jacy/Tanaka profile data anchor missingness patterns and mechanisms after the
  completed pilot confirmed the preferred-analysis relation and reconciled item
  counts with the published annotation cycle. The pages interpret absence as
  grammar/parse-selection coverage, never as a Japanese usage frequency.
- Raw Hillenbrand formants anchor iterative PCA imputation. Artificial validation
  masks may be applied only to originally observed cells; natural missing cells
  have no known truth.
- The privacy-sanitized Turkish PropBank extract supplies one short annotation-
  measurement bridge after the completed pilot reconciled candidate counts and
  preserved worker-by-item dependence. Raw IP addresses, locations, timestamps,
  email fields, and free-text identifiers may never enter the repository.
- The audited UDS natural-parts extract anchors binary generative stories, joint
  modeling, annotator effects, recovery, and the measurement-model capstone. The
  gated-annotations page may analyze the observed natural-parts gate, but the
  conditional response branches and raw confidence field remain blocked until a
  branch-bearing extract, likelihood, and recovery study pass a new audit.

## Dependency-ordered deployment

1. **Governance and build infrastructure.** Reconcile the dataset ledger with the
   DQR; add a source/version/license/checksum manifest; establish the restrained
   plot style; enable page execution with frozen or cached outputs; add a guard that
   detects schematic markers and unexplained numerical literals.
2. **Prepared data and pilots.** Freeze Turkish UD/CMUdict/Turkish UniMorph/dative/Provo loaders;
   prepare connected MALD and mixed-model data; pin corrected Natural Stories;
   normalize ManyBabies; verify SuperTelicity, Storme, CommitmentBank, and
   aspectual-similarity provenance; prepare PB52, PHOIBLE, VALEX/Mega, raw
   Hillenbrand, and UDS inputs. Then complete the paper-first UCCA, Jacy,
   Turkish-PropBank, MegaVeridicality, and MegaOrientation pilots; do not begin
   their note prose until their representation and release gates pass.
3. **Reference analyses.** For each run, save the source checks, exact exclusions,
   computed summaries, fold/mask IDs, seeds, fitted objects where expensive, and
   plotting data. Pages still show the complete analysis code.
4. **Foundational chains.** Implement foundations and random variables in sidebar
   order, then frequentist and Bayesian inference. Later pages may depend on the
   data objects and notation introduced earlier, but not on hidden in-memory state.
5. **Model chains.** Implement linear models before GLMs, GLMs before mixed models,
   and fitted models before their predictive-comparison pages.
6. **Design, latent, factorization, missingness, and custom models.** Implement each
   run in sidebar order. The UDS gated page remains blocked unless its additional
   audit passes.
7. **Integration.** Revise indexes and navigation after the empirical runs have
   stabilized. Update source introductions so each dataset is fully introduced only
   on first use and briefly recalled thereafter.
8. **Release QA.** Execute from a clean session, render every page, inspect every
   figure at desktop and narrow widths, verify all visible numbers against computed
   output, run the schematic-number guard, and complete ASW style, slop, dependency,
   empirical, and citation-integrity audits.

### Writing-swarm waves

The implementation swarm works in the following order. Agents within one wave own
disjoint files; a later wave begins only after the listed empirical and conceptual
dependencies pass.

| Wave | Files | Entry gate | Exit check |
|---|---|---|---|
| A1 | all non-index pages in `foundations/` | Turkish BOUN and Hillenbrand inputs validated | every worked number is computed; Turkish BOUN is introduced once; probability plots show empirical mass |
| A2 | random-variable pages through `central-moments.qmd` | CMUdict and Hillenbrand inputs validated; A1 notation stable | discrete and continuous summaries reproduce from clean sessions; moment pages retain their symbolic derivations |
| A3 | remaining random-variable pages | Turkish UniMorph, Provo, dative, and A2 outputs validated | every family is compared with an observed distribution; simulation pages sample an empirical PMF |
| B1 | frequentist statistical-inference pages | A2--A3 distribution definitions stable; UCCA pilot passed for its two reserved pages | resampling unit and estimand are named; UCCA graph counts are not reduced to token labels |
| B2 | Bayesian and posterior-computation pages | B1 likelihood notation stable; Provo analysis target frozen | algorithms target one identified posterior; diagnostic figures use actual chains and observations |
| C1 | linear-regression pages through distributional regression | Provo and MALD inputs validated | raw observations and fitted relations share each model figure; transformations and coding are data-derived |
| C2 | generalized/count/bounded models | SuperTelicity, Nettle, Storme, MegaVeridicality, and MegaNegRaising pilots passed for their declared uses; the MegaOrientation raw interaction is already stable in C1 | response support matches the likelihood; empirical and fitted outcome scales appear together |
| C3 | grouped and multilevel models | design pages C2 relies on are conceptually stable; connected crossed dataset approved | grouping identifiers survive preprocessing; marginal and conditional predictions are distinguished |
| D1 | model criticism and prediction | C1 fitted targets and corrected Natural Stories input stable | every loss names a new-observation target; grouped folds and within-fold preprocessing are visible |
| D2 | experimental design | ManyBabies input stable; inference and regression vocabulary stable | assignment, sampling, measurement, exclusion, and clustering units remain distinct |
| E1 | latent structure and factorization | PB52, PHOIBLE, and VALEX--MegaAcceptability pilots passed | validation holds out speakers, cells, or verbs as specified; no labels leak into unsupervised fitting |
| E2 | missing data and custom models | Jacy pilot and raw Hillenbrand input passed; Turkish PropBank and UDS pilots passed for their reserved uses | missingness is tied to the data-producing process; annotation models preserve item-by-annotator structure |
| F | indexes, learning path, cross-links, and release QA | all content waves pass page-level renders | site-wide clean render, zero unallowlisted schematic-number findings, citation and style audits pass |

PS1 and PS2 are outside every wave and remain read-only. PS3--PS5 may be revised
only when a notes change creates a concrete mismatch with their frozen analysis
specification; permission to edit them is not a requirement to do so.

## Release blockers that must not be hidden

- The global project currently disables execution. The notes cannot satisfy the
  graph requirement until page execution or a checked figure build is enabled.
- The public aspectual-similarity repository currently does not resolve, and the
  local citation and paper titles disagree. The local licensed extract may be
  analyzed as reference evidence, but it is not a publication target; the
  bounded-response notes use the public MegaNegRaising release instead.
- ELP redistribution and identifier repair must be resolved before a connected
  extract is committed. If that fails, the mixed-model run needs an approved
  connected replacement.
- Natural Stories must use the corrected alignment commit, and its ten-story basis
  limits story-level generalization.
- Participant-level Provo redistribution must be checked before participant-transfer
  claims are added.
- CORAAL filled-pause models are not approved and are not required by this plan.
- UDS gated follow-ups remain outside the existing binary-model audit.
- UCCA v2 has 492 sentence-level units where the original paper reports 583. The
  graph-aware pilot passed for 154 current-release passage pairs, but the notes
  must not attribute v2 counts or means to the 2015 release.
- Turkish PropBank's 20,060 candidates reconcile to 19,988 adjudicated rows after
  accounting for 72 duplicated gold/ordinary keys. Only the pseudonymized,
  text-free extract may be used; raw platform exports remain prohibited.
- Jacy/Tanaka preferred analyses reflect grammar coverage after human parse
  selection. Any proposed use as a frequency distribution is rejected.
- Universal PropBank 2.0 is rejected as a source of natural non-Indo-European
  role distributions because its relevant layers are projected or model-generated
  silver data. The unavailable or restrictively licensed Vietnamese, Chinese, and
  Korean PropBanks remain outside the course release.
- MegaVeridicality's grouped unseen-verb interaction gain is small but positive in
  every frozen fold; its notes use should present the raw category probabilities
  alongside the cumulative-link mixed fit and keep the modest predictive gain in
  view. MegaOrientation's approved teaching model is a population cumulative-logit
  comparison for unseen verbs, not Moon and White's latent lexical/structural-type
  model; the maximal mixed fit is outside the course build.
