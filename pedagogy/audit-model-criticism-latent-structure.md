# Pedagogy audit: model criticism, prediction, and latent structure

This report audits all 25 `.qmd` pages directly under
`model-criticism-and-prediction/` and `latent-structure/`. It applies the following
explanatory-chain rubric:

1. motivating linguistic problem;
2. data source, unit, example observation, measure definitions, preprocessing, and
   aggregation rationale when data appear;
3. links to the first full treatment of prerequisites plus a short in-place reminder;
4. rationale and assumptions for every distribution, model, parameter, validation
   target, and algorithm;
5. derivation with random-versus-observed notation and no algebraic or algorithmic
   leaps;
6. a visible bridge from formula to code and output;
7. interpretation and limits;
8. misconception-oriented checks, recap, and forward link.

No course-note page was edited during this audit.

## Cross-cutting diagnosis

These modules are stronger than a schematic slide sequence. Nearly every page names a
target, uses real data, exposes executable code, retains raw observations in a plot,
states limits, and ends with checks. The main weaknesses occur at the interfaces among
data, predictive claim, and algorithm.

First, the four recurring datasets are not yet fully intelligible from their canonical
introduction. Natural Stories needs one story and response-row example plus definitions
of self-paced reading time, word length, frequency, and GPT-3 surprisal. Provo needs an
example passage position, a definition of first-fixation duration, an account of why
that measure is used, and a visible explanation of the reader-to-position aggregation.
MegaOrientation needs an actual sentence pair, frame glosses, and a response-row
example. Peterson-Barney needs an elicitation-word/token example, vowel-code key, and
plain-language definitions of F0 and F1–F3. Later pages should link to these dossiers
and repeat the two or three facts needed locally.

Second, the notes correctly emphasize that the **validation unit** determines the
claim, but this principle is not given one compact reusable name and decision
procedure. Each validation page should state, before code: (i) the empirical unit that
moves as a block, (ii) the unit receiving equal weight in the final score, (iii) what
information about a held-out unit remains available, (iv) what is re-estimated inside
the fold, and (v) the population to which the result might transfer. This five-part
statement may be called the **validation-target specification (VTS)**.

Third, the distinction between a **split unit** and a **score-aggregation unit** needs
more repetition. Holding out participants while averaging over response rows does not
give participants equal influence. Likewise, fitting token-level mixture likelihoods
in speaker folds does not make tokens independent speakers. Several pages explain
this point, but a stable backlink plus a local reminder would make the chain easier to
follow.

Fourth, algorithmic updates are unevenly derived. K-means derives the mean update and
checks it against fitted values. EM, exact normal-inverse-gamma LOO, PSIS, WAIC, AIC,
BIC, and the chi-squared calibration of the likelihood-ratio statistic move more
quickly from objective to formula or code. Students need the constrained optimization,
posterior algebra, importance-weight normalization, and approximation arguments that
produce those updates.

Fifth, several software settings are declared but not justified: fold counts and
balancing, seeds, 999 bootstrap draws, ordinal optimizer tolerances, posterior draw
counts, Pareto-$k$ threshold, K-means starts, the $K$ grids, covariance-family grids,
EM tolerance and variance floor, and 90% component ellipses. Not every setting needs a
theorem, but each should be labeled as mathematical necessity, scientifically chosen
design, computational default, or display choice.

Finally, the checks are generally good but lean toward reproducing calculations. Add
misconception checks that ask whether a result concerns a new row, participant, story,
passage, verb, speaker panel, or isolated token; whether test information entered
preprocessing; and whether a component, centroid, or posterior membership has acquired
an unsupported linguistic interpretation.

## Canonical backlink targets

The following existing anchors should become stable targets for later reminders.

### Prediction and model criticism

- Natural Stories data dossier:
  `model-criticism-and-prediction/prediction-targets.qmd#natural-stories`
- Prediction units:
  `model-criticism-and-prediction/prediction-targets.qmd#three-prediction-targets`
- Prediction information set:
  `model-criticism-and-prediction/prediction-targets.qmd#the-prediction-information-set`
- Training-test separation:
  `model-criticism-and-prediction/training-and-test-data.qmd#the-separation-rule`
- Preprocessing leakage:
  `model-criticism-and-prediction/training-and-test-data.qmd#leakage-through-preprocessing`
- Loss definitions:
  `model-criticism-and-prediction/predictive-loss.qmd#squared-and-absolute-loss`
- Repeated-training-sample setup and decomposition:
  `model-criticism-and-prediction/bias-variance-tradeoff.qmd#beginning-with-repeated-training-samples`
  and
  `model-criticism-and-prediction/bias-variance-tradeoff.qmd#deriving-the-decomposition`
- Cross-validation algorithm:
  `model-criticism-and-prediction/cross-validation.qmd#the-algorithm`
- Group construction and weighting:
  `model-criticism-and-prediction/grouped-cross-validation.qmd#constructing-grouped-folds`
  and
  `model-criticism-and-prediction/grouped-cross-validation.qmd#group-weighted-scores`
- MegaOrientation dossier:
  `model-criticism-and-prediction/comparing-predictive-loss.qmd#megaorientation`
- Provo dossier:
  `model-criticism-and-prediction/likelihood-ratio-tests.qmd#provo-corpus`
- Likelihood-ratio derivation:
  `model-criticism-and-prediction/likelihood-ratio-tests.qmd#from-a-likelihood-ratio-to-a-difference`
- AIC and BIC definitions:
  `model-criticism-and-prediction/information-criteria.qmd#aic-fit-plus-a-parameter-count-penalty`
  and
  `model-criticism-and-prediction/information-criteria.qmd#bic-a-different-penalty-and-motivation`
- Exact position-level LOO and its unit:
  `model-criticism-and-prediction/leave-one-out-cross-validation.qmd#exact-bayesian-loo-for-the-provo-models`
  and
  `model-criticism-and-prediction/leave-one-out-cross-validation.qmd#what-one-means-here`
- PSIS identity and diagnostic:
  `model-criticism-and-prediction/psis-loo.qmd#relating-the-omitted-posterior-to-the-full-posterior`
- WAIC components:
  `model-criticism-and-prediction/waic.qmd#fitted-posterior-predictive-density`
  and
  `model-criticism-and-prediction/waic.qmd#the-pointwise-optimism-correction`

### Latent structure

- Peterson-Barney dossier and object definition:
  `latent-structure/representing-objects.qmd#loading-and-auditing-the-production-table`
  and
  `latent-structure/representing-objects.qmd#defining-the-represented-objects`
- Aggregation target:
  `latent-structure/representing-objects.qmd#repeated-rows-change-the-target`
- Geometry and adaptation information set:
  `latent-structure/distance-and-scaling.qmd#euclidean-distance` and
  `latent-structure/distance-and-scaling.qmd#the-prediction-information-set`
- K-means objective and update:
  `latent-structure/k-means.qmd#assignments-centroids-and-loss` and
  `latent-structure/k-means.qmd#why-the-update-is-a-mean`
- Training compactness:
  `latent-structure/within-cluster-loss.qmd#loss-at-a-declared-centroid-count`
- Silhouette definition:
  `latent-structure/silhouette-scores.qmd#cohesion-and-the-nearest-alternative`
- Held-out centroid target:
  `latent-structure/unsupervised-validation.qmd#predicting-a-held-out-token` and
  `latent-structure/unsupervised-validation.qmd#the-calibration-panel-target`
- Gaussian component and mixture:
  `latent-structure/gaussian-mixtures.qmd#one-gaussian-component` and
  `latent-structure/gaussian-mixtures.qmd#combining-components`
- Component interpretation limit:
  `latent-structure/gaussian-mixtures.qmd#components-are-not-phonemes`
- Posterior membership:
  `latent-structure/posterior-membership.qmd#conditioning-on-an-unobserved-component`
- EM objective and steps:
  `latent-structure/expectation-maximization.qmd#complete-and-observed-data`,
  `latent-structure/expectation-maximization.qmd#the-expectation-step`, and
  `latent-structure/expectation-maximization.qmd#the-maximization-step`
- Mixture BIC convention:
  `latent-structure/choosing-a-mixture.qmd#bic-and-its-sign-convention`
- Held-out mixture target:
  `latent-structure/validating-a-mixture.qmd#held-out-log-loss` and
  `latent-structure/validating-a-mixture.qmd#information-set-and-dependence-limits`

Add stable headings, and then use them as canonical anchors, for the following missing
targets.

- `model-criticism-and-prediction/predictive-loss.qmd#the-averaging-unit-is-part-of-the-target`
- `model-criticism-and-prediction/leave-one-out-cross-validation.qmd#normal-inverse-gamma-posterior-and-predictive-update`
- `model-criticism-and-prediction/psis-loo.qmd#pareto-smoothing-the-importance-ratios`
- `model-criticism-and-prediction/waic.qmd#why-posterior-variance-corrects-optimism`
- `latent-structure/distance-and-scaling.qmd#three-coordinate-systems`
- `latent-structure/expectation-maximization.qmd#deriving-the-maximization-updates`

## Page-by-page audit: model criticism and prediction

| Page | Severity | Missing moves and specific additions |
|---|---:|---|
| `model-criticism-and-prediction/index.qmd` | M | The overview correctly distinguishes rows, participants, and stories, but it loads data before giving a concrete observation. Add one Natural Stories sentence and response row, define the four focal columns, and link directly to the canonical dossier. Replace “therefore” with “thus.” Add the five-part validation-target specification as the module’s recurring checklist. |
| `model-criticism-and-prediction/prediction-targets.qmd` | H | Expand the canonical Natural Stories dossier with a story excerpt, one word-position row, and the self-paced reading procedure. Define `log_rt`, `word_length`, `log_unigram_frequency`, and `gpt3_surprisal`, including log base or units. Explain why the 100–3,000 ms filter and comprehension threshold are used, which exclusions are source-defined, and what the corrected one-position displacement means for a row. |
| `model-criticism-and-prediction/training-and-test-data.qmd` | M | The separation and leakage treatment are strong. Before code, state the full validation-target specification: participant split, response-row scoring, available story predictors, fold-local transformations, and target population. Justify five folds and the participant-balancing algorithm, explain the calibration-bin intervals, and identify display sampling as display-only. |
| `model-criticism-and-prediction/predictive-loss.qmd` | M | Add the proposed averaging-unit anchor. Derive why the conditional mean minimizes expected squared loss and the conditional median minimizes expected absolute loss. Work one held-out error by hand and then show row-weighted versus participant-weighted aggregation numerically. Explain why averaging MSE within participants and then taking one root differs from averaging participant RMSEs. |
| `model-criticism-and-prediction/bias-variance-tradeoff.qmd` | H | State explicitly that the new response noise is independent of the repeated training sample, then expand every cross-product in the decomposition and show why its expectation is zero. In the simulation, justify position-level aggregation, the cubic “truth,” residual resampling, the 90th-percentile target, 400 training positions, and 300 repetitions. Draw a sharp line between a declared simulation truth and an estimated Natural Stories mechanism. |
| `model-criticism-and-prediction/cross-validation.qmd` | M | The algorithm is clear. Add a small five-observation, two-fold hand rotation before the full code, justify random row folds and $K=5$ for this lesson, and map each formula subscript to code objects. Repeat the distinction among fold, held-out unit, and score-aggregation unit before reporting fold RMSEs. |
| `model-criticism-and-prediction/grouped-cross-validation.qmd` | M | Add the validation-target specification separately for participant and story designs. Explain why participants use five folds while stories use leave-one-story-out, how type-balanced participant folds relate to the claim, and why the plotted fold ranges are descriptive rather than uncertainty intervals. Make the group-weighted versus row-weighted formulas concrete with one unequal-size example. |
| `model-criticism-and-prediction/comparing-predictive-loss.qmd` | H | Expand the MegaOrientation dossier with one past/future sentence pair, gloss the forced-orientation manipulation, define each `frame_code`, and show one participant-by-item rating row. Explain the corrected v1.1 reruns and why verbs attested in at least two frames define the teaching subset. Remind students how cumulative-logit thresholds generate seven category probabilities before the custom prediction function. Justify fold count, optimizer tolerances, 999 verb-bootstrap draws, and the conditional scope of that interval. |
| `model-criticism-and-prediction/likelihood-ratio-tests.qmd` | H | Make this the canonical Provo dossier. Show a passage excerpt and focal word position; define first fixation as the duration of the first fixation on a word during first pass, distinguish it from gaze duration and total time, explain why it is selected here, and define content-word filtering. Show reader-level fixations before averaging, justify aggregation to position means, explain the log transform, and name the information lost. Derive the one-degree-of-freedom difference including the residual scale count, and give more support for the Wilks chi-squared approximation. |
| `model-criticism-and-prediction/information-criteria.qmd` | H | Backlink to the complete Provo dossier with a short reminder. Derive or motivate AIC’s $2k$ optimism correction and BIC’s Laplace/model-evidence approximation at the level appropriate for the course, rather than only stating formulas. Explain exactly which $n$ enters and why position summaries are a questionable independence unit. Add a table separating coefficient count, likelihood parameter count, and empirical grouping units. |
| `model-criticism-and-prediction/leave-one-out-cross-validation.qmd` | H | Add the proposed normal-inverse-gamma update section. State the prior parameterization, derive $V_n$, $b_n$, $a_n$, and $d_n$, then integrate $\beta$ and $\sigma^2$ to obtain the Student-$t$ predictive density. Explain each prior hyperparameter, why the study bounds imply the selected variance, and why $a_0=3$ is chosen. Map every matrix subtraction in the efficient code to omission of row $i$. |
| `model-criticism-and-prediction/psis-loo.qmd` | H | Derive normalized importance weights and the harmonic-mean form of the LOO predictive density from the displayed posterior identity. Add the proposed Pareto-smoothing section: which ratios enter the tail, how generalized-Pareto smoothing replaces extremes, why truncation is used, and how $k$ controls moment existence and approximation stability. Explain the 0.7 reference, 4,000 draws, and why `r_eff=1` follows from independent conjugate draws. |
| `model-criticism-and-prediction/waic.qmd` | H | Derive stable log-mean-exp from the lppd expression and add the proposed explanation of why posterior variance estimates optimism. Clarify sample variance versus population variance across draws, the pointwise additivity assumption, and conditions under which WAIC approximates LOO. The duplicated conjugate code should backlink to the full derivation and locally map the reused quantities instead of requiring students to reverse-engineer it again. |

## Page-by-page audit: latent structure

| Page | Severity | Missing moves and specific additions |
|---|---:|---|
| `latent-structure/index.qmd` | M | Add one fully interpreted Peterson-Barney row before the inventory and backlink to the canonical dossier. Define F1 and F2 briefly and state why labels are withheld during fitting. Give the hard-clustering versus mixture contrast as a table of assignment, objective, uncertainty, and validation target. |
| `latent-structure/representing-objects.qmd` | H | Expand this into the canonical Peterson-Barney dossier. Give one elicitation word and token, decode the vowel labels, explain speaker-type and sex codes, define F0 and F1–F3 in plain phonetic terms, and explain the steady-state measurement region. State why there are two repetitions, what “speaker” uniquely identifies across groups, which historical sampling limitations remain, and why F1/F2 are chosen while F0/F3 are excluded. |
| `latent-structure/distance-and-scaling.qmd` | H | Add the proposed three-coordinate-systems anchor and a hand calculation for the same two tokens under raw, global-$z$, and within-speaker-$z$ geometry. Explain the substantive assumptions of each scale, why within-speaker standardization is preferred for the teaching question, and what anatomy-related versus sociolinguistic variation it removes. Contrast this calibration-panel target with a deployable first-token target before any validation page. |
| `latent-structure/k-means.qmd` | M | The mean update is well derived and checked. Add the assignment-step proof and a one-iteration hand example. Explain Hartigan-Wong relative to the displayed Lloyd-style alternation, why 100 starts and 200 iterations are chosen, how empty clusters are handled, and why seed 1952 is only a reproducibility label. |
| `latent-structure/within-cluster-loss.qmd` | M | Backlink to the K-means objective with a one-sentence reminder. Explain why duplicating a centroid establishes a nested-capacity argument even if software disallows identical final centers. Justify the 1–15 grid and seed policy, and include a misconception check distinguishing monotone training loss from improved held-out category recovery. |
| `latent-structure/silhouette-scores.qmd` | M | The token-level reconstruction is strong. Add a three-cluster toy calculation before the 1,520-row result, explain the singleton convention, and justify mean rather than median silhouette as the selection summary. Explicitly distinguish reuse of training distances for intrinsic validation from held-out prediction. |
| `latent-structure/unsupervised-validation.qmd` | M | The held-out information set is unusually explicit. Add the full validation-target specification before code: speaker split, speaker-weighted score, complete unlabeled panel available, fold-local centroids, and transfer to similarly calibrated speakers. Explain why folds are balanced by speaker type, why five folds are used, and why standard-error bars across the 76 speakers are descriptive under this historical sample. |
| `latent-structure/gaussian-mixtures.qmd` | H | Give the observation-process argument for Gaussian components: conditional independence, elliptical component shape, and token-level likelihood. Explain why ten components and `EVI` are pedagogically selected before fitting, derive what equal volume and varying diagonal shape constrain algebraically, and compare the Gaussian-mixture objective with K-means’ limiting geometry. Explain the 90% ellipse construction and its display-only level. |
| `latent-structure/posterior-membership.qmd` | M | The Bayes derivation and direct code check are strong. Add a two-component numeric example before the ten-component table, distinguish a latent model variable from an ontological vowel identity, and explain why plug-in responsibilities omit parameter and model-choice uncertainty. Justify the 0.2 descriptive uncertainty threshold or remove its apparent special status. |
| `latent-structure/expectation-maximization.qmd` | H | Add the proposed derivation section. Derive the E-step as the conditional expectation of the complete log likelihood and derive weight, mean, and covariance M-step updates using a Lagrange multiplier and weighted derivatives. Explain how the page’s `VVI` diagonal update differs from the unrestricted formula and from the central `EVI` model. Justify K-means initialization, six starts, tolerance, iteration limit, and variance floor, and explain why the current convergence check uses the pre-update trace. |
| `latent-structure/choosing-a-mixture.qmd` | H | Define all four covariance families (`EEI`, `EVI`, `VEV`, `VVI`) in a common volume-shape-orientation table. Justify the 2–16 component grid and why other families are excluded. Derive the relevant parameter counts and reconstruct at least one BIC row by hand. Explain how mixture singularities and nonregularity qualify BIC’s Laplace approximation, not merely its linguistic interpretation. |
| `latent-structure/validating-a-mixture.qmd` | M | Add the validation-target specification before code and link to the calibration-panel anchor with a short reminder. Derive held-out mixture log density from weighted component densities, explain why density rather than hard-label accuracy is primary, and show one speaker’s token-to-speaker aggregation. Clarify what the across-speaker standard error can and cannot mean for the historical sample. |

## ASW voice and slop audit

The prose is generally concrete, cautious, and strong at naming contrasts. Claims are
usually hedged to the represented data, and the repeated statements about prediction
targets prevent causal and population overreach.

The banned-expression scan found one direct connective violation:
“therefore” in `model-criticism-and-prediction/index.qmd:44`; it should be “thus.” It
found no other banned buzzword or throat-clearing expression in scope. There are no
em dashes, decorative or otherwise.

The larger style risks are structural.

- Many pages use the same sequence: backlink, formula, long code block, numerical
  report, limitation paragraph, five checks. The regularity helps navigation but can
  make the module read like generated templates when transitions do not explain why
  the next object is needed.
- Long code blocks sometimes interrupt the argumentative chain. A short
  symbol-to-code table before each block would let the prose retain control of the
  explanation.
- “This distinction,” “This comparison,” and “This calculation” are usually
  load-bearing, but some could name the object more precisely: validation-target
  specification, split-score mismatch, calibration-panel target, component-label
  fallacy, or approximation diagnostic.
- Limitation paragraphs repeatedly use “does not establish.” The caution is
  warranted, though the page endings would sound more like ASW if each limitation
  were followed by the positive, precisely scoped claim that remains licensed.
- The notes rarely anticipate a student objection in the explicit “A potential
  worry …” form. The material contains many such worries, but they should be named
  and answered at the point of the relevant choice.

The requested `scripts/style_metrics.py` is not present in this repository or the
installed ASW skill, so this voice assessment is qualitative.

## Prioritized implementation batches

1. **Canonical data dossiers and stable anchors.** Expand
   `prediction-targets.qmd`, `comparing-predictive-loss.qmd`,
   `likelihood-ratio-tests.qmd`, and `representing-objects.qmd`. Add real linguistic
   examples, response and predictor definitions, observation keys, preprocessing,
   aggregation rationale, dependence, and target population. Land these anchors
   before downstream edits.

2. **Validation-target specification.** Add the five-part VTS to the module index and
   instantiate it on `training-and-test-data`, `predictive-loss`, `cross-validation`,
   `grouped-cross-validation`, `unsupervised-validation`, and
   `validating-a-mixture`. Make split unit, score unit, information set, fold-local
   fitting, and transfer population visible before code.

3. **Predictive-comparison derivations.** Revise bias-variance, the Provo LRT and
   information-criterion pages, exact conjugate LOO, PSIS, and WAIC. Add every
   intermediate algebraic step, random-versus-observed notation, and symbol-to-code
   mapping.

4. **Latent-algorithm derivations.** Revise distance/scaling, K-means, Gaussian
   mixtures, EM, and mixture BIC. Derive the optimization updates and parameter
   counts, classify every algorithm setting, and distinguish fitting geometry from
   linguistic interpretation.

5. **Backlinks, local reminders, and misconception checks.** Once the canonical
   pages are stable, update every downstream page with a short reminder rather than
   a bare link. Replace at least one reproduction question per page with a target,
   leakage, or interpretation misconception.

6. **ASW voice and render pass.** Replace the lone “therefore,” vary repeated page
   architecture where it obscures the argument, name recurring pedagogical problems,
   turn generic limitation endings into scoped positive claims, then render and test
   all anchors and code outputs.

A safe swarm split is: (i) Natural Stories prediction pages; (ii) MegaOrientation and
the Provo comparison sequence; and (iii) the full Peterson-Barney latent-structure
sequence. The dossier-and-anchor batch should land first so every worker targets the
same definitions and does not duplicate incompatible introductions.
