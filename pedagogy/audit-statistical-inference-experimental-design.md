## Audit result

I audited all 51 `.qmd` pages directly under `statistical-inference/` and `experimental-design/`. I made no edits.

The central problem is **explanatory-chain truncation (ECT)**: a page names an object, states a formula, runs substantial code, gives a caveat, and asks four questions, but often omits the steps that let a student reconstruct why the object, formula, and code belong together.

Two related problems recur:

- **Data-ladder omission (DLO):** the path from source record → measured variable → filtered row → aggregate → modeled observation is usually compressed into one paragraph.
- **First-treatment drift (FTD):** later pages link to the preceding page rather than to the first full treatment of a prerequisite. Across these 51 pages I found 108 `.qmd` links and zero links to heading anchors.

The notes’ strongest feature is interpretation and limitation. Most pages carefully distinguish the file from a broader population, computation from evidence, and descriptive from causal claims. The weakest parts are motivation, choice justification, derivation, and formula-to-code bridges.

Severity means:

- **H:** a student cannot reconstruct a core object, choice, or derivation without oral explanation.
- **M:** the object is present, but one or more rationale, reminder, or code-bridge steps are missing.
- **L:** the page is mostly self-contained and needs targeted examples, backlinks, or recap.

## Canonical anchors

These should be treated as the first full treatments. Later pages should link to the exact anchor and include a two- or three-sentence reminder.

- Data and targets:
  - `../foundations/linguistic-data.qmd#unit-and-observation-key`
  - `../foundations/linguistic-data.qmd#what-aggregation-removes`
  - `../foundations/linguistic-data.qmd#measurement-analysis-and-generalization`
  - `../foundations/making-sense-of-data.qmd#state-the-estimand`
- Random variables and dependence:
  - `../random-variables-and-distributions/defining-random-variables.qmd#distinguishing-the-two-spaces`
  - `../foundations/independence.qmd#why-the-characterizations-are-equivalent`
  - `../random-variables-and-distributions/linearity-of-expectation.qmd#stating-the-general-rule`
  - `../random-variables-and-distributions/variance-and-covariance.qmd#covariance-and-a-variance-decomposition`
  - `../random-variables-and-distributions/expectation-of-functions.qmd#transforming-first-then-averaging`
- Distribution families:
  - `../random-variables-and-distributions/bernoulli-distribution.qmd#mass-expectation-and-variance`
  - `../random-variables-and-distributions/binomial-distribution.qmd#definition`
  - `../random-variables-and-distributions/poisson-distribution.qmd#definition-and-fit`
  - `../random-variables-and-distributions/normal-distribution.qmd#definition`
  - `../random-variables-and-distributions/student-t-distribution.qmd#construction`
  - `../random-variables-and-distributions/chi-squared-distribution.qmd#definition`
  - `../random-variables-and-distributions/beta-distribution.qmd#definition`
  - `../random-variables-and-distributions/hypergeometric-distribution.qmd#mass-mean-and-variance`
- Frequentist inference:
  - `populations-and-samples.qmd#defining-the-objects`
  - `independent-sampling.qmd#identical-distributions-and-independence`
  - `maximum-likelihood.qmd#probability-and-likelihood`
  - `properties-of-estimators.qmd#estimators-are-random-variables`
  - `standard-errors.qmd#deriving-the-standard-error-of-a-mean`
  - `confidence-intervals.qmd#normal-and-t-procedures`
  - `null-hypotheses-and-test-statistics.qmd#the-null-and-statistic`
  - `paired-observations.qmd#pairing-changes-the-variance`
  - `fishers-exact-test.qmd#the-conditional-probability`
  - `chi-squared-test.qmd#expected-counts-under-independence`
- Bayesian inference:
  - `../foundations/bayes-rule.qmd`
  - `posterior-distributions.qmd#updating-a-continuous-parameter`
  - `posterior-summaries.qmd#credible-intervals-and-directional-probabilities`
  - `conjugate-priors.qmd#collecting-powers`
  - `conjugate-priors.qmd#the-normalizing-constant`
  - `prior-predictive-distributions.qmd#from-a-parameter-prior-to-possible-counts`
  - `predictive-distributions.qmd#two-sources-of-posterior-predictive-variation`
  - `beyond-conjugacy.qmd#a-robust-location-scale-model`
- Computation:
  - `monte-carlo-integration.qmd#expectations-as-integrals`
  - `markov-chains.qmd#transition-and-stationary-distributions`
  - `markov-chain-monte-carlo.qmd#chain-averages`
  - `metropolis-hastings.qmd#proposal-and-acceptance`
  - `hamiltonian-monte-carlo.qmd#potential-kinetic-and-total-energy`
  - `hamiltonian-monte-carlo.qmd#leapfrog-integration`
  - `mass-matrix-geometry.qmd#general-kinetic-energy`
  - `no-u-turn-sampler.qmd#growing-and-stopping-a-trajectory`
  - `stan.qmd#the-complete-program`
  - `checking-markov-chains.qmd#production-traces`
  - `rhat.qmd#the-basic-variance-ratio`
  - `effective-sample-size.qmd#from-autocorrelation-to-ess`
  - `divergent-transitions.qmd#energy-error-and-geometry`
  - `generated-quantities.qmd#three-passage-level-student-t-model-outputs`
  - `posterior-predictive-checks.qmd#replication-under-the-fitted-passage-level-student-t-model`
- Experimental design:
  - `units-of-assignment.qmd#assignment-and-measurement-are-different-maps`
  - `random-assignment.qmd#the-assignment-mechanism-is-a-probability-rule`
  - `within-participant-designs.qmd#each-infant-supplies-a-register-contrast`
  - `between-participant-designs.qmd#a-group-contrast-over-assigned-order`
  - `counterbalancing.qmd#reconstructing-the-order-templates`
  - `exclusion-rules.qmd#retention-enters-the-estimand`
  - `../regression-models/response-transformations.qmd#what-the-prepared-response-means`
  - `../regression-models/random-intercepts.qmd#deriving-the-induced-covariance`

## Special audit: the Provo passage-level Student-t sequence

`beyond-conjugacy.qmd` needs to become the canonical data-and-model page for every later Provo computation page.

### The missing data ladder

The actual preparation is:

1. Start with reader-by-word eye-tracking rows.
2. Retain complete content-word rows with positive `IA_FIRST_FIXATION_DURATION`.
3. Define **first-fixation duration (FFD)** as the duration, in milliseconds, of the first recorded fixation in a word’s interest area.
4. Log each positive reader-level FFD.
5. Average those log durations over readers at each word position, producing `mean_log_ffd`.
6. Within each passage, average position summaries separately over nouns and verbs.
7. Subtract the verb average from the noun average to obtain one `y_j`.
8. Give each of the 55 passages one observation in the Student-t model.

The current page begins near step 6. It must explain that FFD is an early, local eye-movement measure; why it was chosen over gaze duration or total reading time; that skipped words do not contribute positive FFDs; and that `mean_log_ffd` is the **mean of logged durations**, not the log of the arithmetic mean.

The page also needs to define the other retained columns: word length, POS, word and sentence position, orthographic cloze match, POS match, LSA response match, and `n_fixations`. Even if the model uses only POS and FFD, students should be able to read the table.

### Required concrete example

The notes-owned table omits surface words and complete passage text. Thus the current materials cannot show the requested sentence without extending the preparation pipeline. Add a short, attributed, license-compatible excerpt from one Provo passage and preserve surface word or sentence text in a teaching example table.

For `Text_ID = 1`, show:

- the original sentence or short passage excerpt;
- several word-position rows with surface word, POS, reader-level FFD interpretation, `n_fixations`, and `mean_log_ffd`;
- the actual passage summary row: 33 retained positions, 16 nouns, 13 verbs, noun mean `5.32325`, verb mean `5.21567`, and contrast `0.10758`.

This creates a visible raw trial → position → passage ladder.

### Why aggregate?

The rationale should be explicit:

- The computational sequence needs a two-parameter target that can be normalized on a grid and reused across algorithms.
- Passage aggregation gives each passage equal influence and makes the contrast interpretable.
- It does **not** recover participant inference.
- It treats unequal noun counts, verb counts, and fixation counts as if the resulting passage summaries were measured with equal precision.
- It removes reader variation, word-level variation, reader-by-POS variation, and the possibility of fitting crossed reader/item effects.
- A raw-data hierarchical model would answer a different and richer question.

Link to `../foundations/linguistic-data.qmd#what-aggregation-removes` and briefly restate that aggregation deletes variation before the model sees it.

### Why Student-t?

The model assumes:

1. passage contrasts are conditionally independent;
2. they share one location, scale, and tail parameter;
3. their distribution is symmetric around `mu`;
4. `sigma` is a Student-t scale, not its standard deviation;
5. no passage covariates explain systematic heterogeneity;
6. each aggregated contrast is treated as observed without passage-specific measurement error.

The rationale is robustness to an extreme passage while retaining the measured contrast scale. The page should compare a normal likelihood with `t_4`, show how the likelihood contribution of an extreme residual differs, and distinguish this use of Student-t as an observation model from its earlier use as the sampling distribution of a standardized mean.

### Why `nu = 4`?

At present, “less sensitive to an extreme passage” is insufficient. State that four is a teaching choice, not a value implied by the corpus. It provides finite variance but very heavy tails; fixing it keeps the posterior two-dimensional and makes grid normalization possible. Then run or preview a sensitivity comparison for `nu = 3, 4, 7`, and a normal limit. If no substantive argument selects four, say so.

### Why these priors?

Explain separately:

- `mu ~ Normal(0, (2s_y)^2)`: zero centers “no average noun–verb contrast”; `2s_y` is intended to be broad relative to observed contrasts.
- `sigma ~ HalfNormal(0, 2s_y)`: enforces positive scale and regularizes implausibly large between-passage spread.
- Because `s_y` is computed from the same outcomes, this is a data-calibrated teaching prior. It is not an ex ante confirmatory prior and involves empirical calibration that should be acknowledged as such.
- Show prior-predictive implications on the response scale before presenting posterior results.

### Posterior derivation

Derive it without skips:

1. Distinguish random `Y_j` from observed `y_j`.
2. Write the full Student-t density with its normalizing constant.
3. Use conditional independence to write the likelihood product.
4. write both normalized prior densities and supports;
5. apply continuous Bayes’ rule with the evidence integral;
6. multiply likelihood and priors;
7. take logs term by term;
8. define `lambda = log(sigma)`;
9. derive `d sigma / d lambda = exp(lambda) = sigma`;
10. add the log-Jacobian `lambda`;
11. map each mathematical term to its R line and later Stan statement.

Also explain that the `321 × 321` grid uses equal cell spacing, so the cell-area constant cancels in normalized weights; an approximation to the absolute normalizing constant would need that area factor. Explain why the grid is centered on a mode/Hessian approximation, why it extends seven local standard deviations, and what the boundary-mass check does.

## Statistical-inference pages

| Page | Sev. | Missing moves and required additions/backlinks |
|---|---:|---|
| `autocorrelation.qmd` | M | The population ACF is stated, but the sample ACF and its code are not derived. Work one eight-draw lag-1 calculation; link to `../random-variables-and-distributions/correlation.qmd#definition` and `markov-chains.qmd#transition-and-stationary-distributions`; remind students that this is dependence among computation states, not Provo observations. |
| `beyond-conjugacy.qmd` | H | Add the complete Provo data ladder, an actual sentence/row/passage example, FFD definition and rationale, aggregation tradeoffs, Student-t assumptions, `nu=4` rationale and sensitivity, prior implications, and the line-by-line posterior/Jacobian derivation above. Backlink to `../foundations/linguistic-data.qmd#what-aggregation-removes`, `../random-variables-and-distributions/student-t-distribution.qmd#construction`, and `posterior-distributions.qmd#updating-a-continuous-parameter`. |
| `bootstrap-confidence-intervals.qmd` | H | The four-step recipe does not explain the bootstrap world, why sampling is with replacement, or why empirical quantiles approximate endpoint behavior. Show a five-speaker hand bootstrap; distinguish observed statistic, bootstrap statistic, bootstrap distribution, and sampling distribution. Discuss percentile-interval assumptions, bias/skewness/discreteness, and link to `properties-of-estimators.qmd#estimators-are-random-variables` and `confidence-intervals.qmd#normal-and-t-procedures`. |
| `checking-markov-chains.qmd` | M | Define why multiple overdispersed chains are used, how pooled ranks are formed, and what warmup accomplished before the saved traces. Add one good/one bad schematic interpretation and a “what this cannot prove” objection. Backlink to `markov-chain-monte-carlo.qmd#chain-averages`, `stan.qmd#fitting-the-exact-model`, and forward-link to `rhat.qmd#the-basic-variance-ratio`. |
| `chi-squared-test.qmd` | H | Independence jumps directly to `E_ij=O_i+O_+j/N`. Derive product-of-marginals expected counts, explain fitted margins, derive degrees of freedom as free cells after constraints, and motivate the chi-squared approximation and expected-count condition. Backlink to `../foundations/independence.qmd#why-the-characterizations-are-equivalent` and `../random-variables-and-distributions/chi-squared-distribution.qmd#definition`. |
| `confidence-intervals.qmd` | H | Add the user’s random-endpoint pedagogy: `L(X),U(X)` before observation versus `L(x),U(x)` after; derive coverage, explain `P_theta`, and distinguish a procedure’s coverage from one interval’s status. Show where `z` and `t` critical values come from. Backlink to `standard-errors.qmd#deriving-the-standard-error-of-a-mean` and `../random-variables-and-distributions/student-t-distribution.qmd#construction`. |
| `conjugate-priors.qmd` | M | The algebra is comparatively strong, but “kernel,” normalization, and prior choice need reminders. Show constants before dropping them, explain why data order disappears, and state why `Beta(1,1)` is support-compatible but not uniquely neutral. Backlink to `../random-variables-and-distributions/beta-distribution.qmd#definition`, `maximum-likelihood.qmd#probability-and-likelihood`, and `posterior-distributions.qmd#updating-a-continuous-parameter`. |
| `divergent-transitions.qmd` | M | The funnel example appears without preparation and the stress settings look arbitrary. Derive energy error from the HMC acceptance correction, explain each deliberate degradation, and give a response decision tree: locate → rescale/reparameterize → refit → recheck. Backlink to `hamiltonian-monte-carlo.qmd#leapfrog-integration` and `mass-matrix-geometry.qmd#general-kinetic-energy`. |
| `effective-sample-size.qmd` | M | Derive the ESS denominator from the variance of a correlated mean; explain paired autocorrelation truncation and why modern bulk/tail ESS differ from the displayed textbook value. Work a short repeated-state chain. Backlink to `autocorrelation.qmd` and `monte-carlo-integration.qmd#two-uncertainties`. |
| `estimator-bias.qmd` | M | The target-specific point is good, but the expectation remains abstract. Enumerate a tiny sample space and calculate bias exactly before simulation; distinguish random `T(X)`, realized `T(x)`, realized error, and expected error. Backlink to `properties-of-estimators.qmd#estimators-are-random-variables` and `../random-variables-and-distributions/expected-values.qmd`. |
| `exact-binomial-intervals.qmd` | H | Replace the two-equation sketch with the full Clopper–Pearson construction supplied by the user: random endpoints, two noncoverage events, tail allocation, candidate-parameter inversion, boundary cases, beta-CDF identity, and quantile formulas. Keep `K` random and `k` observed throughout. Backlink to `confidence-intervals.qmd`, `../random-variables-and-distributions/binomial-distribution.qmd#definition`, and `../random-variables-and-distributions/beta-distribution.qmd#definition`. |
| `fishers-exact-test.qmd` | M | Show how fixed margins leave one free cell, enumerate several possible tables, and derive the hypergeometric numerator/denominator combinatorially. Explain R’s two-sided convention before displaying it. Backlink to `../random-variables-and-distributions/hypergeometric-distribution.qmd#mass-mean-and-variance`. Replace the lone “and therefore” in the answer with “and thus.” |
| `generated-quantities.qmd` | M | Explain why generated quantities are evaluated conditionally on each joint posterior draw and why this preserves dependence among derived outputs. Add a three-column code/math/meaning crosswalk and distinguish deterministic transforms, replications, and log-score evaluations. Backlink to `stan.qmd#the-complete-program` and `posterior-predictive-checks.qmd#replication-under-the-fitted-passage-level-student-t-model`. |
| `hamiltonian-monte-carlo.qmd` | H | The physics vocabulary arrives before intuition. Begin with the random-walk problem, give a one-dimensional slope analogy, derive the gradient of the actual Provo log target, then walk through one leapfrog step numerically. Justify `epsilon=.20`, `L=12`, and whitening as teaching settings. Backlink to `metropolis-hastings.qmd#proposal-and-acceptance` and `beyond-conjugacy.qmd#a-robust-location-scale-model`. |
| `importance-sampling.qmd` | H | Derive the change-of-measure identity with support conditions, distinguish ordinary and self-normalized estimators, and explain finite-sample bias. Justify the `t_5` proposal, its center, and `1.5 Sigma`; compare a deliberately bad proposal. Backlink to `monte-carlo-integration.qmd#expectations-as-integrals` and `beyond-conjugacy.qmd#the-missing-normalizer`. |
| `independent-means.qmd` | M | Explain why Welch is the default, derive the variance sum including the covariance term that independence sets to zero, and motivate the Satterthwaite degrees of freedom. Add an equal-variance objection/rebuttal and map each formula term to the two R vectors. Backlink to `standard-errors.qmd#deriving-the-standard-error-of-a-mean` and `../random-variables-and-distributions/variance-and-covariance.qmd#covariance-and-a-variance-decomposition`. |
| `independent-sampling.qmd` | M | Add a concrete table of several token rows sharing a sentence/register, then separate identical distribution, pairwise independence, and mutual independence. Explain why corpus order and document structure threaten the factorization. Backlink to `../foundations/independence.qmd#why-the-characterizations-are-equivalent` and `../random-variables-and-distributions/bernoulli-distribution.qmd#mass-expectation-and-variance`. |
| `index.qmd` | M | The roadmap is accurate but not a prerequisite map. Add “what you should already know,” name the repeated datasets and units, and link every prerequisite to its first-treatment anchor. Also flag the backward computational dependencies described below. |
| `markov-chain-monte-carlo.qmd` | H | “Ergodic” is doing too much work. Distinguish target distribution, transition kernel, iteration distribution, and empirical distribution; explain stationarity versus convergence. The page runs a full random-walk sampler before deriving MH. Either reorder or replace this code with a transparent finite-state chain. Backlink to `markov-chains.qmd#transition-and-stationary-distributions`, then forward to `metropolis-hastings.qmd#proposal-and-acceptance`. |
| `markov-chains.qmd` | H | The Markov-property display reuses `eta_s=eta_s`, obscuring random variables versus values. Use distinct uppercase/lowercase notation, begin with a small finite chain and transition matrix, then move to Provo. Do not execute an undeclared MH correction here. Link to `../foundations/conditional-probability.qmd#conditioning-as-rescaling`. |
| `mass-matrix-geometry.qmd` | H | Explain the mass/inverse-mass convention carefully, derive velocity covariance one line at a time, and show a two-dimensional ellipse before/after whitening. The HMC page currently uses whitening before this page explains it; move this treatment earlier or insert a full reminder there. Backlink to `hamiltonian-monte-carlo.qmd#potential-kinetic-and-total-energy`. |
| `maximum-likelihood.qmd` | M | The derivation is good, but add why logs preserve the maximizer, define the score, handle `k=0` and `k=n`, and distinguish the random estimator from the observed estimate. Map the analytic expression to `negative_log_likelihood()` and `optimize()`. Backlink to `independent-sampling.qmd#identical-distributions-and-independence`. |
| `mean-squared-error.qmd` | L | The decomposition is strong. Add a numerical row that verifies variance + squared bias = MSE in units of ms², remind students why squaring changes the loss, and link back to `estimator-bias.qmd` and `properties-of-estimators.qmd#estimators-are-random-variables`. |
| `metropolis-hastings.qmd` | H | Explain why the Hastings correction preserves the target, preferably with a two-state or two-region flow calculation before the general ratio. Work one numerical proposal/acceptance step and map it to `log(runif()) < min(0, log_ratio)`. Justify the `2.38²/d` proposal scale as a computational heuristic, not a model assumption. |
| `monte-carlo-integration.qmd` | H | Separate continuous-posterior integration error, grid discretization/truncation error, and finite-draw Monte Carlo error. Explain why sampling grid cells approximates draws from a continuous target and derive MCSE from variance of an average. Justify `20,000` draws by a precision target. Backlink to `../random-variables-and-distributions/expected-values.qmd` and `beyond-conjugacy.qmd#the-missing-normalizer`. |
| `no-u-turn-sampler.qmd` | H | Add a one-dimensional trajectory diagram or table showing tree depths 0–3, endpoint dot products, and the retained candidate. Explain why internal states are not draws and how multinomial selection differs from taking the endpoint. Justify `adapt_delta=.90` and `max_treedepth=10`. The actual Stan run is introduced on the next page; move the empirical diagnostics after `stan.qmd` or split concept from evidence. |
| `null-hypotheses-and-test-statistics.qmd` | H | The page computes a p value before deriving its reference distribution. Start with random `T(D)` under `H0`, then the observed `t_obs`, then define the two-sided tail event. State assumptions and show the R tail mapping. Backlink to `standard-errors.qmd`, `../random-variables-and-distributions/student-t-distribution.qmd#construction`, and forward to `one-sample-t-inference.qmd`. |
| `one-sample-t-inference.qmd` | H | The transition from normal and chi-square statements to a t statistic is one line. Explain independence of sample mean and sample variance under normal sampling, why `n-1`, substitution of `S`, interval inversion, and robustness limits. Maintain random `T` versus observed `t`. Backlink to `../random-variables-and-distributions/student-t-distribution.qmd#construction` and `confidence-intervals.qmd`. |
| `paired-mean-inference.qmd` | M | Explain why the scientific target is absolute agreement rather than signed bias, what information absolute values discard, and why the re-pairing distribution is a descriptive baseline rather than a null. Show one aligned and one arbitrary pair. Backlink to `paired-observations.qmd#pairing-changes-the-variance`. |
| `paired-observations.qmd` | M | The source description is good. Add one concrete English/French graph pair with the Scene-counting rule, show the two rows joined by `pair_id`, and derive the covariance identity from `Var(Y_fr-Y_en)`. Backlink to `../random-variables-and-distributions/variance-and-covariance.qmd#covariance-and-a-variance-decomposition`. |
| `parameter-pair-plots.qmd` | M | Explain how marginally acceptable parameters can form a problematic joint geometry, show a simple ellipse/funnel interpretation, and map the stress divergence indicator to the overplot. Backlink to `mass-matrix-geometry.qmd#geometry-of-the-passage-level-student-t-model` and `divergent-transitions.qmd#energy-error-and-geometry`. |
| `poisson-maximum-likelihood.qmd` | H | Motivate Poisson from the sentence-count question: common exposure, independent increments/events as a working approximation, support, and mean=variance implication. Derive the log likelihood including the dropped `log(y_i!)` term, explain why zero sentences matter, and link the observed overdispersion to model inadequacy. Backlink to `../random-variables-and-distributions/poisson-distribution.qmd#definition-and-fit` and `maximum-likelihood.qmd#deriving-the-estimator`. |
| `populations-and-samples.qmd` | L | This is among the strongest pages. Add one actual source row and a sampling-frame diagram; make the finite-release versus usage-process contrast into an explicit misconception box. Backlink to `../foundations/linguistic-data.qmd#measurement-analysis-and-generalization`. |
| `posterior-distributions.qmd` | H | As the first Bayesian inference page, it needs a slower random-parameter/observed-data setup, normalized prior and likelihood, explicit evidence integral, and a complete constant-preserving derivation before using proportionality. Justify `Beta(1,1)` and distinguish “uniform on theta” from “uninformative.” Backlink to `../foundations/bayes-rule.qmd`, `../random-variables-and-distributions/beta-distribution.qmd#definition`, and `maximum-likelihood.qmd#probability-and-likelihood`. |
| `posterior-predictive-checks.qmd` | M | Explain the replication algorithm with one posterior draw and one 55-value replicate. Distinguish a pointwise predictive-density band from a predictive interval for observations. Explain why discrepancy selection should be scientifically motivated and why passing four checks is not global validation. Backlink to `generated-quantities.qmd` and `predictive-distributions.qmd`. |
| `posterior-summaries.qmd` | M | Move the loss-function rationale out of the answer key and into the prose. Show code-to-integral mappings for means, quantiles, and directional probabilities. Explain equal-tail versus highest-density intervals and transform-then-summarize with one numerical example. Backlink to `../random-variables-and-distributions/expectation-of-functions.qmd#transforming-first-then-averaging`. |
| `predictive-distributions.qmd` | H | Derive the beta-binomial integral rather than only stating it; distinguish a future draw from a future block; derive the two total-variance terms using conditional expectation. The finite-resource comparison is good but needs a row-level sampling story. Backlink to `prior-predictive-distributions.qmd#from-a-parameter-prior-to-possible-counts` and `../random-variables-and-distributions/hypergeometric-distribution.qmd#mass-mean-and-variance`. |
| `prior-predictive-distributions.qmd` | H | Derive the beta-binomial mass line by line, explain why one theta is shared by the block, and show what drawing a fresh theta per cell would imply. Justify the prior before simulating from it and add a prior-predictive inadequacy check. Backlink to `conjugate-priors.qmd#collecting-powers` and `../random-variables-and-distributions/beta-distribution.qmd#definition`. |
| `pronoun-case-example.qmd` | M | Add an actual token/sentence example and explain that the indicator is a deterministic recoding of annotation while Bernoulli randomness belongs to the sampling model. Distinguish fitted Bernoulli variance from sample variance. Backlink to `../random-variables-and-distributions/bernoulli-distribution.qmd#mass-expectation-and-variance` and `independent-sampling.qmd`. |
| `properties-of-estimators.qmd` | M | Explain why this bootstrap approximates an empirical sampling distribution, why speakers are sampled with replacement, and how it differs from repeated recruitment. Add a three-column random estimator / realized estimate / target table. Backlink to `populations-and-samples.qmd#defining-the-objects`. |
| `rhat.qmd` | M | Define chain means and variances from a tiny example, derive the basic ratio’s intuition, then explain why modern rank-normalized split/folded R-hat is not the displayed formula. Give action thresholds as workflow, not theorem. Backlink to `checking-markov-chains.qmd#production-traces`. |
| `stan.qmd` | H | The program is readable, but the long initialization code overwhelms the model. Add a line-by-line crosswalk from prior/likelihood/posterior to Stan, explain support transformations and Jacobians, and justify four chains, 750 warmup, 1,000 sampling, `adapt_delta=.90`, and depth 10. Move grid-derived initialization to a collapsible appendix. Backlink to `beyond-conjugacy.qmd#a-robust-location-scale-model` and `no-u-turn-sampler.qmd#growing-and-stopping-a-trajectory`. |
| `standard-errors.qmd` | M | Adopt the screenshot’s explicit pedagogy: standard deviation applies to a random variable; standard error is the SD of a particular estimator. Expand `Var(sum)` to include covariance terms before independence removes them, and distinguish sigma from its estimate `s`. Backlink to `properties-of-estimators.qmd#estimators-are-random-variables` and `../random-variables-and-distributions/standard-deviation.qmd#what-standard-deviation-summarizes`. |

## Experimental-design pages

| Page | Sev. | Missing moves and required additions/backlinks |
|---|---:|---|
| `between-participant-designs.qmd` | M | Define looking time and the log transformation, show one infant’s 16 possible rows becoming one `Y_i`, and explain why infant averaging gives equal infant weight. Clarify that “assigned order” is recorded assignment, not verified randomization. Backlink to `units-of-assignment.qmd#assignment-and-measurement-are-different-maps`, `within-participant-designs.qmd#each-infant-supplies-a-register-contrast`, and `../regression-models/response-transformations.qmd#what-the-prepared-response-means`. |
| `counterbalancing.qmd` | M | Show one complete order row with actual positions, register, and paired stimulus IDs before the summary checks. Explain pseudorandom constraints, why the mode reconstructs a template, and what a deviation row looks like. Backlink to `random-assignment.qmd#the-assignment-mechanism-is-a-probability-rule` and `within-participant-designs.qmd#order-can-modify-a-within-infant-contrast`. |
| `exclusion-rules.qmd` | H | Add a flow diagram from recruitment through participant/session/trial exclusions and row completion. Show one example of each of the three row states and define both indicators. Connect selection to missing-data assumptions without claiming the final file identifies a mechanism. Backlink to `units-of-assignment.qmd`, `within-participant-designs.qmd`, and `../missing-data/missingness-mechanisms.qmd#separating-observed-and-unobserved-quantities`. |
| `index.qmd` | M | Add a concrete trial story: infant, IDS/ADS stimulus, looking-time measurement, order, lab, and possible missing row. The phrase “observed second-session grouping” does not match `between-participant-designs.qmd`, which analyzes the four order groups; replace it. Add explicit prerequisites and a per-page learning roadmap. |
| `power-by-simulation.qmd` | H | The hierarchical model appears without reminding students how random intercepts induce dependence. Explain the log response, each fixed/random term, exchangeability and normality assumptions, why the fitted effect is used, why the design grid has 4/8/16 labs and 4/8/16 trials, and why 200 simulations may be too imprecise for a final design decision. Explain the Wald cutoff, singular fits, Type I check, and every omitted process. Backlink to `../regression-models/random-intercepts.qmd#deriving-the-induced-covariance`, `../regression-models/fixed-and-random-effects.qmd#beginning-with-the-scientific-target`, and `exclusion-rules.qmd#retention-enters-the-estimand`. |
| `random-assignment.qmd` | H | Potential-outcome notation appears only here and is not taught. Either derive it locally or avoid it. Explain `Y_i(z)`, why only one is observed, conditional independence within laboratory, the relabeling reference set, the statistic choice, and why preserving realized counts matters. Backlink to `units-of-assignment.qmd#assignment-and-measurement-are-different-maps`; add a concrete four-infant allocation example. |
| `units-of-assignment.qmd` | M | The five-role distinction is strong, but students need an actual row and trial timeline. Define looking time, trial metadata, paired stimulus, and completed opportunity. Show how the same row participates in the row→infant→lab and row→stimulus maps. Backlink to `../foundations/linguistic-data.qmd#unit-and-observation-key`. |
| `within-participant-designs.qmd` | M | Define the looking-time procedure and show one infant’s ADS and IDS rows becoming two means and one difference. Explain why the chosen unweighted infant average answers an infant-level question and what unequal counts do to precision. Backlink to `units-of-assignment.qmd` and `../random-variables-and-distributions/variance-and-covariance.qmd#covariance-and-a-variance-decomposition`. |

## Sequence problems

Several pages explain a device after already using it:

1. `markov-chains.qmd` executes an MH-like transition before `metropolis-hastings.qmd` derives the correction.
2. `markov-chain-monte-carlo.qmd` runs the complete random-walk algorithm before the MH page.
3. `hamiltonian-monte-carlo.qmd` whitens the target before `mass-matrix-geometry.qmd` explains whitening.
4. `no-u-turn-sampler.qmd` reports diagnostics from a Stan run introduced on the next page.

The conceptual order can remain, but the empirical code should not depend on an unexplained later page. Use small transparent examples for the concept pages, then introduce the full Provo computation after the corresponding algorithm has been derived.

## ASW voice and slop findings

Lexical slop is low. The scan found none of the banned buzzwords, no unearned boosters, and no decorative em dashes. The only connective violation I found was one “therefore” in the Fisher answer.

The larger style problem is structural:

- Most pages use the same compact template: assertion → equation → long code block → result caveat → four questions.
- The pages rarely use the pedagogical transitions visible in the supplied posts: “Suppose…,” “So first, remember…,” “To connect…,” “The remaining question is…,” and “Now consider….”
- Named objects and caveats are strong, but anticipated misconceptions usually appear only in the final check rather than being raised and resolved in the exposition.
- Paragraphs often end on limitations, which is useful, but they need intermediate “This…” bridges and short upshot sentences.
- The repeated “Check your understanding” blocks should remain, but questions should increasingly target misconceptions and choice justification rather than recall.
- Introductions need explicit “First… Second…” roadmaps; endings need numbered recaps plus the forward link.

The `style_metrics.py` script referenced by the skill is absent from both the repository and installed skill directory, so this portion is qualitative rather than metric-based.

## Prioritized implementation plan

1. **Establish a shared page scaffold.** Every empirical page gets: linguistic question; observation card; one concrete row; target; model/procedure rationale; assumptions; derivation; equation-to-code crosswalk; result; limits; misconception check; numbered recap; forward link.
2. **Repair the canonical pages first.** Start with `confidence-intervals.qmd`, `exact-binomial-intervals.qmd`, `posterior-distributions.qmd`, and `beyond-conjugacy.qmd`. Later pages should backlink rather than repeat incomplete versions.
3. **Rebuild the Provo sequence.** Extend the prepared example data to include surface words or sentence text, then add the raw-reader → word-position → passage ladder and the full Student-t posterior derivation.
4. **Repair computational ordering.** Use toy chains before Provo MH; explain mass geometry before whitening; introduce the Stan run before reporting its NUTS diagnostics.
5. **Add stable heading anchors.** Replace file-only prerequisite links with exact first-treatment anchors and a short in-place reminder. A lint check can require at least one anchor backlink on every non-index page.
6. **Add formula-to-code crosswalks.** Keep the executable code, but precede long blocks with a table mapping mathematical object, data column, and R/Stan expression.
7. **Upgrade checks.** Retain the answer-bearing checks, but add “What tempting interpretation is wrong?” and “Which assumption licenses this step?” questions.
8. **Run the ASW pass.** Vary paragraph and sentence shape, add explicit transitions and objection/rebuttal moves, replace the lone “therefore,” and avoid turning the new hand-holding into repetitive callout boilerplate.
9. **Remove slide infrastructure after note expansion.** In this scope, `decks/statistical-inference/index.qmd` and `decks/experimental-design/index.qmd` duplicate the notes. The site also retains a “Course slides” link in `_quarto.yml`; remove that navigation and archive/delete the deck outputs as part of the user-authorized slide removal.
10. **Verify.** Render all 51 pages; check links and anchors; run data assertions; inspect all tables/figures; then run style, slop, and citation checks before shipping.
