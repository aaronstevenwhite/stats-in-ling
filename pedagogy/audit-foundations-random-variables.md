# Pedagogy audit: foundations and random variables

This report audits all 50 `.qmd` pages directly under `foundations/` and
`random-variables-and-distributions/`. It applies the following explanatory-chain
rubric:

1. motivating linguistic problem;
2. data source, unit, example observation, measure definitions, preprocessing, and
   aggregation rationale when data appear;
3. links to the first full treatment of prerequisites plus a short in-place reminder;
4. rationale and assumptions for every distribution, model, parameter, and algorithm;
5. derivation with random-versus-observed notation and no algebraic leaps;
6. a visible bridge from formula to code and output;
7. interpretation and limits;
8. misconception-oriented checks, recap, and forward link.

No course-note page was edited during this audit.

## Cross-cutting diagnosis

The notes already have a strong shared skeleton: motivating question, definition,
executable code, plot, scope warning, exercises, and a forward link. The main problem
is not missing structure; it is missing explanatory glue at five recurring
transitions.

First, data are repeatedly reloaded without an adequate local reminder. Six datasets
need canonical **data dossiers** containing source, sampling unit, one concrete row or
sentence, every focal measure in plain language, preprocessing, dependence,
aggregation, and target population. Later pages should link back and repeat the two or
three facts needed locally.

Second, distribution choice often follows the pattern “name, formula, fit.” The family
pages need a named **observation-process argument**: what is random, what remains
fixed, why the support matches, which independence, exchangeability, or equal-rate
assumptions are required, what visible feature would falsify the choice, and why the
family is still useful when used only as a reference.

Third, several derivations state their decisive identity. The largest gaps are the
beta recurrences and maximum-likelihood fit, normal maximum-likelihood fit,
chi-squared variance statistic, Student-$t$ construction, inverse-transform proof for
a discrete CDF, geometric and negative-binomial likelihoods, and the transition from
a sampling model to code.

Fourth, random quantities and realized data are not consistently separated. Each
worked model should declare the random variables in capitals, the realized values in
lowercase, the parameter, the statistic, and the fitted value before moving among
formulas, R columns, and output.

Fifth, navigation is mostly forward-only. Each page should start with one backlink to
the first full treatment and a one- or two-sentence reminder, then end with a
misconception check, short recap, and explicit statement of what the next page adds.

The exercise sections are a good base, but many ask students to recompute rather than
diagnose a misconception. Add questions such as “Which assumption fails?”, “What
changed when the unit changed?”, “Is this quantity random before observation?”, and
“What claim remains unsupported?”

## Canonical backlink targets

The following existing anchors should become stable targets for later reminders.

- Unit, key, and aggregation:
  `foundations/linguistic-data.qmd#unit-and-observation-key`,
  `foundations/linguistic-data.qmd#what-aggregation-removes`, and
  `foundations/linguistic-data.qmd#raw-tokens-and-summaries`
- Response, comparison, and estimand:
  `foundations/making-sense-of-data.qmd#response-and-linguistic-contrast`,
  `foundations/making-sense-of-data.qmd#observations-being-compared`, and
  `foundations/making-sense-of-data.qmd#state-the-estimand`
- Sample space:
  `foundations/possibilities-and-events.qmd#outcomes-and-the-sample-space` and
  `foundations/possibilities-and-events.qmd#membership-and-granularity`
- Events: `foundations/events.qmd#intersection-union-and-complement`
- Sigma-algebras: `foundations/event-spaces.qmd#closure-requirements` and
  `foundations/event-spaces.qmd#two-generators-and-their-atoms`
- Generators: `foundations/generating-event-spaces.qmd#generators-and-atoms` and
  `foundations/generating-event-spaces.qmd#coarser-generators`
- Empirical measure: `foundations/probability-measures.qmd#the-empirical-measure` and
  `foundations/probability-measures.qmd#the-three-requirements`
- Joint and conditional probability:
  `foundations/joint-probability-of-events.qmd#the-four-joint-events`,
  `foundations/joint-probability-of-events.qmd#marginal-probabilities`, and
  `foundations/conditional-probability.qmd#conditioning-as-rescaling`
- Chain rule and dependence:
  `foundations/probability-factorization.qmd#three-event-and-general-chain-rules` and
  `foundations/probability-factorization.qmd#factorization-and-dependence`
- Independence:
  `foundations/independence.qmd#why-the-characterizations-are-equivalent` and
  `foundations/independence.qmd#independence-is-not-mutual-exclusivity`
- CMUdict dossier:
  `random-variables-and-distributions/why-random-variables.qmd#the-pronunciation-entry-outcomes`
- Random-variable definition:
  `random-variables-and-distributions/defining-random-variables.qmd#working-backward-with-a-preimage`
  and
  `random-variables-and-distributions/defining-random-variables.qmd#stating-measurability`
- Hillenbrand duration dossier:
  `random-variables-and-distributions/continuous-random-variables.qmd#hillenbrand-vowel-duration`
- Dative dossier:
  `random-variables-and-distributions/poisson-distribution.qmd#the-dative-data`
- Provo dossier:
  `random-variables-and-distributions/uniform-distribution.qmd#provo-modeled-predictability`
- UniMorph dossier:
  `random-variables-and-distributions/hypergeometric-distribution.qmd#a-finite-turkish-morphology-population`
- Joint and marginal distributions:
  `random-variables-and-distributions/joint-probability.qmd#definition` and
  `random-variables-and-distributions/marginal-distributions.qmd#marginalization`

Add stable headings, and then use them as canonical anchors, for the following pages.

- `foundations/probability-factorization.qmd#the-two-event-chain-rule`
- `foundations/bayes-rule.qmd#deriving-bayes-rule`
- `random-variables-and-distributions/expected-values.qmd#expectation-as-a-probability-weighted-average`
- `random-variables-and-distributions/variance-and-covariance.qmd#variance-as-expected-squared-distance`
- `random-variables-and-distributions/standard-deviation.qmd#definition`
- `random-variables-and-distributions/cumulative-distribution-functions.qmd#definition`

## Page-by-page audit: foundations

| Page | Severity | Missing moves and specific additions |
|---|---:|---|
| `foundations/index.qmd` | L | Add a short “how to use a page” protocol: identify the unit, read the random/observed notation box, inspect the code bridge, and answer the misconception check. Mark which pages are canonical treatments and which are applications. |
| `foundations/linguistic-data.qmd` | M | Add one literal source row and explain `duration_ms`, `f0_hz`, F1–F3, why steady-state formants are used, and which measurements are source versus derived. Walk through one audio-record-to-token-row transformation. Expand the aggregation section with a question for which each aggregation is appropriate. |
| `foundations/making-sense-of-data.qmd` | M | Work one named speaker’s two rows through $d_s$, then through $\bar d$. Briefly remind students what F1 measures and why the /ɪ/–/i/ comparison is linguistically meaningful. Contrast retaining speaker-level differences with collapsing to two vowel means. Backlink to the three aggregation anchors above. |
| `foundations/zipfs-law.qmd` | H | Explain one observed token count, type count, rank, and fitted probability numerically. Justify the 50/50 binomial split, tie-breaking, seed, multinomial likelihood, log parameterization, starting values, bounds, and L-BFGS-B. Derive the log likelihood from the multinomial PMF and map each term to code. |
| `foundations/possibilities-and-events.qmd` | H | Make this the canonical Turkish interrogative dossier: show a source sentence, translation or gloss, focal token, lemma, UD relation, register, and observation key. Explain why these three lemmas and two relations were retained, what `nsubj` and `obj` mean, why sampling a row uniformly is chosen, and why this differs from sampling Turkish usage. |
| `foundations/events.qmd` | M | Begin with a backlink and reminder of the 167-token experiment. Show one actual outcome that belongs to $N\cap O$ and one outside it before set notation. Explicitly map `intersect`, `union`, and `setdiff` to the mathematical operations. |
| `foundations/event-spaces.qmd` | M | Motivate why a model might deliberately represent fewer distinctions than $2^\Omega$. Walk closure from $\{N\}$ to all four events one forced addition at a time. Explain “atom” before using it and distinguish finite closure here from the countable requirement in general. |
| `foundations/generating-event-spaces.qmd` | M | Backlink to closure and give a complete two-generator worked construction before the six-atom case. Explain why “smallest” matters, why empty intersections are discarded, and how the code enumerates unions. Replace “therefore” with “thus.” |
| `foundations/probability-measures.qmd` | M | Justify uniform row mass as a chosen empirical experiment. Distinguish $\widehat{\mathbb P}$ from a population probability model and show a single event’s mass as a sum of singleton masses before code. |
| `foundations/probability-concepts.qmd` | M | Backlink to event operations and the empirical measure. Add a four-cell table that visibly connects disjointness, exhaustivity, and the union formula. Include the common misconception that mutually exclusive events are independent. |
| `foundations/joint-probability-of-events.qmd` | M | Begin from one four-cell count table and show count to normalized joint PMF to row and column margins. Remind students why the denominator is all 167 rows and link back to the empirical measure. |
| `foundations/conditional-probability.qmd` | M | Give the raw-count calculation $112/147$ before the abstract ratio. Name the **reference-event rescaling** operation and reuse that name. Add a visual or code bridge showing filter first, then divide. |
| `foundations/probability-factorization.qmd` | M | Add the proposed `#the-two-event-chain-rule` heading. Annotate the factorization as “reach $N$, then reach $O$ within $N$.” Derive the general rule with explicit intermediate substitutions and map each empirical factor to its count. |
| `foundations/bayes-rule.qmd` | M | Add `#deriving-bayes-rule`. Start from the concrete two-denominator question, then derive every step. Explain the numerator, original conditional, and both margins in words; distinguish algebraic reversal from a causal or sampling claim. |
| `foundations/independence.qmd` | M | Name and contrast three objects: event independence, independence of sampled rows, and causal independence. The current page handles parts of this distinction, but students need them together in one misconception box. Add a direct four-cell expected-count comparison. |

## Page-by-page audit: random variables and distributions

| Page | Severity | Missing moves and specific additions |
|---|---:|---|
| `random-variables-and-distributions/index.qmd` | L | Add a notation legend for random variable, value, parameter, statistic, and estimate, and identify the canonical data dossiers. Explicitly say that later pages should be read as observation-process arguments, not as a family catalog. |
| `random-variables-and-distributions/why-random-variables.qmd` | L | This is a strong canonical page. Add one fully interpreted CMUdict row, explain ARPAbet and stress digits locally, and distinguish orthographic word, pronunciation entry, and running-speech token with one alternate-pronunciation example. |
| `random-variables-and-distributions/defining-random-variables.qmd` | M | Explain why measurability can fail with a small non-power-set example rather than only saying it becomes substantive later. Add a prose or diagrammatic chain from value-set to preimage to event to probability. |
| `random-variables-and-distributions/discrete-random-variables.qmd` | L | Add a backlink reminder distinguishing codomain, range, and support; range is otherwise left implicit. Include an ordinal-score counterexample to “numeric means continuous.” |
| `random-variables-and-distributions/probability-mass-functions.qmd` | L | The formula-to-code bridge is strong. Add a literal row-count derivation for one mass and an explicit reminder that the hat denotes the empirical PMF. Link the nonoverlapping-value sum to the foundations event-additivity anchor. |
| `random-variables-and-distributions/continuous-random-variables.qmd` | M | Explain the measurement process for duration, the stored rounding resolution, and why positive real support is a useful idealization. The abstract two-dimensional measurability example needs a slower bridge from the observed duration/F1 pair. |
| `random-variables-and-distributions/probability-density-functions.qmd` | H | Justify the KDE, kernel and bandwidth defaults, grid extent, interpolation, and numerical integration. Separate an estimated density from a parametric probability model. Show how R’s density height, one-millisecond interval area, and empirical bin proportion differ. |
| `random-variables-and-distributions/cumulative-distribution-functions.qmd` | L | Add a `#definition` anchor and a hand-worked three-value ECDF before the 45-row result. Explain right-continuity and why $F(b)-F(a)$ corresponds specifically to $(a,b]$. |
| `random-variables-and-distributions/expected-values.qmd` | H | Add the proposed canonical definition heading. Introduce random-versus-observed notation before $\widehat{\mathbb E}$. The geometric and beta calculations appear before the family pages; either move them or supply the geometric-series and beta-recurrence steps locally. |
| `random-variables-and-distributions/expectation-of-functions.qmd` | M | Add a worked three-point PMF showing “transform then weight.” Introduce Jensen’s inequality only as an optional forward pointer, but explain why squaring makes the two orders differ. |
| `random-variables-and-distributions/linearity-of-expectation.qmd` | M | Derive the general rule from sums or integrals rather than state it. Link indicator expectation back to event probabilities and include a misconception check contrasting linearity with factorization of products. |
| `random-variables-and-distributions/when-expectations-fail.qmd` | M | The divergence argument is strong. Explain why a Cauchy reference is chosen, derive or label the MLE as numerical, and justify the optimizer starts, histogram bin rule, 5,000 draws, and eight paths. Distinguish bootstrap randomness from Cauchy-model randomness before code. |
| `random-variables-and-distributions/variance-and-covariance.qmd` | M | Add the proposed variance anchor and a three-observation hand calculation. Clarify why this page introduces covariance as a decomposition term while the later covariance page treats it as the focal joint summary. |
| `random-variables-and-distributions/standard-deviation.qmd` | L | Add the canonical definition anchor and a short comparison among SD, mean absolute deviation, and standard error. Identify standard error explicitly as the SD of an estimator, not of raw observations. |
| `random-variables-and-distributions/central-moments.qmd` | M | Explain why moments three and four are standardized, distinguish kurtosis from excess kurtosis, and give a concrete pair of shapes sharing lower moments. Add backlinks to variance and SD with in-place reminders. |
| `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd` | M | Show one categorical row and its binary recoding. Derive the categorical and Bernoulli MLEs or link to a later likelihood treatment. Explain why a Bernoulli coding is justified only by a genuinely binary question. |
| `random-variables-and-distributions/bernoulli-distribution.qmd` | L | Add one observation-level mapping $O_i(\omega_i)$, then separate $O_i$, observed $o_i$, $p$, and $\hat p$. Backlink to expectation and variance with one-sentence reminders. |
| `random-variables-and-distributions/binomial-distribution.qmd` | H | Name the fixed-$n$, iid, constant-$p$ assumptions before the PMF and derive the binomial coefficient. Explain why the corpus example intentionally violates the literal sampling story and what the reference curve can still teach. Separate fitting $p$ from assessing fit with the same count. |
| `random-variables-and-distributions/hypergeometric-distribution.qmd` | H | Explain how the 120-lemma sample was produced, whether it was random, and why 120 was chosen. Show a lemma/form row and define `t_initial`. Derive the combinatorial PMF and finite-population correction in words before formulas. |
| `random-variables-and-distributions/geometric-distribution.qmd` | H | Explain the ordered phone process and why “vowel = success” is a coding decision. Derive the likelihood and MLE in the main text, not only an answer. Show one pronunciation and its waiting count, then enumerate the constant-$p$, independence, and memorylessness assumptions. |
| `random-variables-and-distributions/negative-binomial-distribution.qmd` | H | Explain why the third vowel is chosen and show one entry’s count. Derive the combinatorial term and MLE, distinguish the common negative-binomial parameterizations, and foreground selection on at least three vowels. |
| `random-variables-and-distributions/poisson-distribution.qmd` | H | Expand this into the canonical dative dossier: include a source sentence, NP/PP realization, recipient and theme spans, length measures, modality, speaker and verb IDs, and preprocessing. Explain why subtracting one creates the count, why one token is the exposure, and why equal mean and variance follow from the Poisson process story. |
| `random-variables-and-distributions/uniform-distribution.qmd` | H | Expand the Provo dossier with one passage/word-position example, the raw cloze task, eye-movement measures, construction of `OrthoMatchModel`, and why the page uses a first-stage prediction rather than raw responses. Explain why the unit-uniform is a baseline rather than a plausible generative model. |
| `random-variables-and-distributions/beta-distribution.qmd` | H | Derive the beta-function recurrences and variance. Explain mean–concentration parameterization and what $\alpha,\beta<1$ imply. Derive the likelihood, method-of-moments start, log transformation, optimizer, and endpoint restriction; map every code object to the formulas. |
| `random-variables-and-distributions/normal-distribution.qmd` | H | Give the observation-process argument for a normal reference and its assumptions. Explain why /i/ and speaker-specific groups are used. Derive the MLEs, distinguish MLE variance from unbiased sample variance, and add residual or QQ diagnostics rather than relying on histogram overlays. |
| `random-variables-and-distributions/chi-squared-distribution.qmd` | H | Derive $(n-1)S^2/\sigma^2\sim\chi^2_{n-1}$: standardize normal observations, project out the fitted mean, and explain the lost degree of freedom. Distinguish the abstract $Q$ construction, the random variance statistic, and a realized value. |
| `random-variables-and-distributions/student-t-distribution.qmd` | H | Derive the statistic from the normal mean and chi-squared variance components, including why they are independent under normal sampling. Explain why $n-1=138$, where a posterior does **not** enter, and how a reference distribution differs from a posterior. Add a concrete null value, tail calculation, interval inversion, and assumption diagnostic. |
| `random-variables-and-distributions/inverse-transform-sampling.qmd` | H | Prove the generalized-inverse result for step CDFs rather than only “at continuity points.” Walk several explicit uniforms across category intervals. Explain `findInterval()` boundary behavior and why the computational category order is arbitrary. |
| `random-variables-and-distributions/random-seeds.qmd` | M | State that the numerical seeds are arbitrary labels, explain generator state versus independent statistical observations, and show why setting a seed inside a reusable function can be undesirable. Link back to Monte Carlo error. |
| `random-variables-and-distributions/joint-probability.qmd` | H | Although it links to the Poisson page, add a compact dative reminder and one source sentence locally. Map a single row to $\langle R,T\rangle$, then show how repeated rows create one joint cell. Distinguish ordered pairs from event intersections. |
| `random-variables-and-distributions/marginal-distributions.qmd` | M | Backlink to the joint-distribution definition and remind students what information is removed. Work one row sum numerically before aggregate code and contrast marginalization with conditioning using the same joint table. |
| `random-variables-and-distributions/conditional-independence.qmd` | H | Define recipient pronominality, NP/PP realization, spoken/written modality, and their codings with example tokens. Derive expected cell counts from conditional factorization. Explain the Pearson contribution and why it is descriptive here. |
| `random-variables-and-distributions/conditional-expectation.qmd` | H | Add the dative reminder and example and define $X$ and $Y$ before the formulas. Derive the total-expectation identity one equality at a time, map each mixture weight to code, and distinguish a conditional mean function from a causal response. |
| `random-variables-and-distributions/covariance.qmd` | M | Add the dative backlink and reminder and one paired token. Show quadrant contributions numerically, clarify empirical-population versus estimator notation, and connect `cov()`’s $n-1$ convention visibly to the displayed formulas. |
| `random-variables-and-distributions/correlation.qmd` | M | Add the dative reminder, derive the standardized-product identity, and explain the bound without merely naming Cauchy–Schwarz. Give a concrete zero-correlation dependent example or simulation. End with a forward bridge to inference rather than only closing the chapter. |

## ASW voice and slop audit

The prose is generally restrained, concrete, and well hedged. The banned-word scan
found one direct connective violation: “therefore” in
`foundations/generating-event-spaces.qmd:5`, which should be “thus.” It found no other
banned buzzword or throat-clearing expression in scope.

The larger style risk is structural rather than lexical.

- “Basically … More specifically …” recurs formulaically on seven pages.
- Many pages use nearly identical paragraph geometry: definition, code, one limit
  paragraph, and four questions.
- “Pinned table,” “data-calibrated reference,” and similar phrases are useful but
  repeated often enough to sound templated.
- The notes name mathematical objects well, but they do not consistently name the
  recurring pedagogical problems. Useful reusable names include **unit mismatch**,
  **support-match fallacy**, **reference-model gap**, **random–realized distinction**,
  and **aggregation loss**.
- There are no decorative em dashes in scope.

The requested `scripts/style_metrics.py` is not present in this repository or the
installed ASW skill, so this voice assessment is qualitative.

## Prioritized implementation batches

1. **Canonical data dossiers and stable anchors.** Expand `linguistic-data`,
   `possibilities-and-events`, `why-random-variables`, `poisson`, `uniform`, and
   `hypergeometric`; add real rows or sentences, measure glossaries, preprocessing,
   aggregation rationale, and stable anchors.

2. **High-severity model and derivation pages.** Revise Zipf, PDF/KDE, expected
   value, binomial, geometric, negative binomial, beta, normal, chi-squared,
   Student-$t$, inverse transform, and the high-severity dative pages. Each gets a
   “why this model?” section, assumptions, full derivation, random/observed notation,
   and formula-to-code table.

3. **Dependency-aware backlinks and local reminders.** Work in chapter order so
   every downstream page links to the now-stable canonical anchor and repeats only
   what is needed locally.

4. **Code/output bridges and misconception checks.** After each displayed
   derivation, add a short mapping from symbols to columns, functions, and output.
   Replace at least one recomputation exercise per page with an assumption or
   misconception diagnostic.

5. **ASW voice and consistency pass.** Remove the lone “therefore,” vary repetitive
   “Basically/More specifically” openings, name recurring pedagogical problems,
   verify hedging and paragraph upshots, then render and test all cross-references.

A safe swarm split is: (i) foundations and the Turkish BOUN sequence; (ii) CMUdict
representation, moments, and count families; and (iii) Hillenbrand, Provo, and dative
continuous and joint families. The canonical-anchor batch should land first so all
three workers target the same links.
