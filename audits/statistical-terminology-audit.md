# Statistical terminology, conventions, and dependency audit

## Scope and audit standard

This audit covers all 214 active `.qmd` notes pages in the course order declared in `_quarto.yml`: foundations, random variables and distributions, statistical inference, regression models, model criticism and prediction, experimental design, latent structure, factorization, missing data, and custom models. It excludes the root index, slides and slide archives, problem sets, assignments, source dossiers, generated documentation, and rendered HTML. The audit reflects the working tree on 21 October 2026; in particular, it evaluates the already revised categorical-distribution page rather than an earlier version of that page.

I applied four tests to every page. First, is each probability or inferential claim correct under the assumptions actually stated? Second, does the page follow ordinary statistical terminology, including the distinctions among a parameter, an estimator, and an estimate; a probability and a density; a standard deviation and a standard error; a confidence statement and a posterior statement; and a residual and an error? Third, does the first use of a term either define it or explicitly defer its treatment with a forward link? Fourth, when a term reappears, does the page link back to its canonical treatment and give the short reminder required to make that link useful?

Severity labels have the following meanings.

- **Correctness**: a formula, inferential claim, or interpretation is wrong or is right only under an assumption the prose contradicts.
- **Terminology**: the calculation may be right, but its name conflicts with standard statistical usage.
- **Pedagogy**: the statement is too compressed to show why a conclusion follows or where it stops.
- **Convention**: the statement departs from common textbook practice in a way that may create avoidable confusion.

## Prioritized findings

First, three issues should be corrected before the affected pages are taught. The Fisher page currently treats sampling without replacement from a finite resource as the reason that Fisher's conditional hypergeometric distribution is natural. That sampling distribution and Fisher's fixed-margin null distribution are different probability constructions. The latent-structure pages call a standard deviation divided by the square root of 76 a description of dispersion among the 76 observed speakers; the standard deviation has that descriptive interpretation, while the quotient is a standard error only under an additional repeated-sampling model. And the custom-model sequence first declares independent normal item and annotator effects, then implements mean-centered raw normal vectors. Centering changes both the dependence and the marginal variance, so the written generative model and the fitted model do not coincide.

Second, several equations are malformed in source. These are not merely typographic blemishes because the broken displays occur inside derivations students are expected to follow: the normal equations, the negative-binomial likelihood, the Laplace underbraces, the Pearson dispersion estimate, the lognormal random-effect moments, the sufficient-statistic example, and the chi-squared expected-count derivation.

Third, the notes need a course-wide **terminology dependency rule (TDR)**. A term may appear before its canonical page only if the local passage gives a usable definition, says that the full treatment comes later, and links forward. A later use should link back at first substantive use and add one sentence recalling the operative definition. A bare link is insufficient when the page relies on a distinction students could reasonably have forgotten.

Fourth, a small set of passages uses the mold “X is Y, not Z” where the two labels stand in for statistical reasoning. This is not a word-count problem. Many contrasts in the notes are specific, economical, and pedagogically useful. Revision is warranted only where the prose should instead name the data-generating or estimating operation and derive what the quantity can support. The already revised categorical page now does this well: it defines the empirical probability from a fixed table, states the additional independent categorical sampling model that would make the same vector a maximum-likelihood estimate, and links forward to the maximum-likelihood page.

## Correction register

The page ledger below refers to these identifiers.

### C01. Separate Fisher conditioning from finite-population sampling

**Severity: correctness and terminology.** `statistical-inference/fishers-exact-test.qmd` opens by saying that Fisher's test is especially natural for a fixed sample drawn without replacement from a finite resource, and later uses the sampling fraction to motivate the conditional analysis. A simple random sample of 120 rows from 588 induces a design-based multivariate-hypergeometric distribution over sample cell counts, but it does not fix both margins. Fisher's reference distribution arises after conditioning on both observed margins under a null odds ratio of one. These two uses of the hypergeometric family should not be merged.

Replace the opening explanation with:

> Fisher's exact test evaluates association in a two-by-two table by conditioning on both observed margins. Under a null odds ratio of one, the remaining free cell has a hypergeometric distribution. This conditional reference distribution is distinct from the multivariate-hypergeometric randomness induced by drawing 120 lexemes without replacement from the 588-row resource: the sampling design does not itself fix the two sample margins.

Then replace the sampling-fraction paragraph with:

> The calculation conditions on the table margins after the 120 rows have been sampled. It supplies an exact conditional reference distribution under the null model. The without-replacement design still matters for claims about repeated samples from the 588-row resource, but its finite sampling fraction is not what produces Fisher's fixed-margin distribution.

### C02. Use the standard name and qualify discreteness on the Clopper--Pearson page

**Severity: terminology and correctness.** In `statistical-inference/exact-binomial-intervals.qmd`, “the exact conditional interval” should be “the Clopper--Pearson exact binomial interval.” Conditional is not the defining adjective here. Also replace “in general, no rejection region has probability exactly $\alpha/2$” with “because the binomial distribution is discrete, a nonrandomized rejection region generally cannot be chosen to have probability exactly $\alpha/2$ for every candidate $p$.” The latter states both the source of conservatism and the relevant qualification.

### C03. Do not call posterior hyperparameters estimates

**Severity: terminology.** In `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`, $(b_n,V_n,a_n,d_n)$ are analytically updated posterior hyperparameters after conditioning on a training set. Replace “are posterior hyperparameter estimates” with “are the posterior hyperparameters determined by the realized training vector.” Reserve *estimate* for a statistic used to estimate a target or the realized value of such a statistic.

### C04. Repair seven derivations at source

**Severity: correctness.** Make the following literal corrections.

1. In `regression-models/frequentist-linear-regression.qmd`, change `+widehat\beta_1` to `+\widehat\beta_1`.
2. In `random-variables-and-distributions/negative-binomial-distribution.qmd`, change `+left(\sum_i x_i\right)` to `+\left(\sum_i x_i\right)`.
3. In `regression-models/laplace-approximation.qmd`, change both tab-prefixed `ext{...}` underbrace labels to `\text{...}`.
4. In `regression-models/count-overdispersion.qmd`, put the displayed Pearson estimate immediately after its introduction:

   $$
   \widehat\phi_P
   =\frac{1}{n-p}\sum_{i=1}^n
   \frac{(y_i-\widehat\lambda_i)^2}{\widehat\lambda_i}.
   $$

   The current source opens a display, inserts prose and a second display, and places the defining formula after the denominator explanation.
5. In `regression-models/overdispersion-and-random-effects.qmd`, replace the broken sequence after “Because $B\sim\mathcal N(0,\tau_p^2)$” with one aligned display:

   $$
   \begin{aligned}
   M_B(t)&=\exp(t^2\tau_p^2/2),\\
   \operatorname E[e^B]&=M_B(1)=e^{\tau_p^2/2},\\
   \operatorname E[e^{2B}]&=M_B(2)=e^{2\tau_p^2},\\
   \operatorname{Var}(e^B)&=e^{2\tau_p^2}-e^{\tau_p^2}.
   \end{aligned}
   $$

6. In `regression-models/sufficient-statistics.qmd`, replace the literal placeholders with “For these data, R computes $n=$ `r n` and $s=\sum_i y_i=$ `r s`.”
7. In `statistical-inference/chi-squared-test.qmd`, replace the two dangling sentences with “Multiplying the fitted marginal shares and then multiplying by $N$ gives the expected count” followed directly by the displayed formula.

### C05. Distinguish empirical spread from a standard error

**Severity: correctness and terminology.** `latent-structure/unsupervised-validation.qmd` and `latent-structure/validating-a-mixture.qmd` compute the sample standard deviation of speaker-level losses divided by $\sqrt{76}$, then say that the result describes dispersion among the observed historical speakers. The sample standard deviation describes that dispersion. Its quotient by $\sqrt{76}$ is a standard error only under a repeated-sampling model that treats the 76 speaker summaries as independent draws from a target population. Moreover, speaker losses share fitted training folds, which makes the usual independent-mean calculation a working approximation.

The preferred repair is to report the speaker-level standard deviation, median, and quantiles as descriptive uncertainty. If the quotient is retained, label it explicitly:

> The reported quotient is a naive independent-speaker standard error: it treats the 76 speaker-level losses as independent draws from a population while holding the fold construction fixed. Because speakers in a fold share centroids estimated from the same training folds, that working calculation does not propagate fold-fit uncertainty. The speaker standard deviation and paired loss plot provide the direct description of heterogeneity in this historical sample.

Apply the same distinction in `experimental-design/within-participant-designs.qmd`. Either omit the standard error when the target is only the included release, or call it “the usual independent-infant standard error under a superpopulation working model” and state the population of infants to which that model refers.

### C06. Align the custom-model generative story with the centered implementation

**Severity: correctness and terminology.** `custom-models/generative-stories.qmd` declares mutually independent $u_i\sim\mathcal N(0,\sigma_{\text{item}}^2)$ and $a_j\sim\mathcal N(0,\sigma_{\text{annotator}}^2)$. The fitted pages instead use

$$
u_i=\sigma_{\text{item}}(z_i-\bar z),
\qquad z_i\overset{\mathrm{iid}}\sim\mathcal N(0,1),
$$

and the analogous annotator construction. The centered effects sum to zero, are dependent, and satisfy

$$
\operatorname{Var}(u_i)
=\sigma_{\text{item}}^2\left(1-\frac1I\right),
\qquad
\operatorname{Cov}(u_i,u_{i'})=-\frac{\sigma_{\text{item}}^2}{I}
\quad(i\ne i').
$$

Choose one of two coherent conventions. Either rescale the centered vector by $\sqrt{I/(I-1)}$ and $\sqrt{J/(J-1)}$ so that the marginal variances equal the named scale parameters, or describe $\sigma_{\text{item}}$ and $\sigma_{\text{annotator}}$ as raw-deviation scales and state the realized centered-effect variance. In either case, rewrite the generative story using the exact finite-population parameterization that Stan fits.

The factorization in `custom-models/uds-measurement-model.qmd` should also be written over the raw latent vectors, for instance $p(\mathbf z^{\text{item}})p(\mathbf z^{\text{annotator}})$ followed by deterministic definitions of $\mathbf u$ and $\mathbf a$. Writing ordinary full-dimensional densities $p(\mathbf u\mid\sigma)$ and $p(\mathbf a\mid\sigma)$ hides that their induced distributions lie on zero-sum subspaces.

### C07. Explain the common-random-number shift in the power simulation

**Severity: pedagogy and convention.** `experimental-design/power-by-simulation.qmd` simulates once with an IDS coefficient of zero, fits the model, and obtains an empirical-effect estimate by adding the target coefficient to the null estimate. This shortcut is valid for the Gaussian linear mixed model because replacing $\mathbf y$ by $\mathbf y+\mathbf X\mathbf c$ shifts the fitted fixed-effect coefficient by $\mathbf c$ while leaving REML residuals, estimated variance components, and the corresponding standard error unchanged, provided the same fixed-effect column is present. It is not a generic power-simulation identity for nonlinear models or generalized linear mixed models.

Add that derivation before the code, name the device a **common-random-number coefficient shift**, state its scope, and verify one replicate by regenerating and refitting at the nonzero effect. Otherwise, generate and fit each nonzero scenario directly.

### C08. Reserve one acronym for one concept

**Severity: convention and terminology.** `latent-structure/unsupervised-validation.qmd` defines **validation-target specification (VTS)**. `missing-data/validating-imputation.qmd` later defines **validation--test separation (VTS)**. Retain VTS for the former and call the latter the “validation/test split” or “validation--test separation principle” without an acronym.

### C09. Use empirical-variance notation for PCA scores

**Severity: terminology and convention.** In `factorization/principal-component-analysis.qmd`, the vector $\mathbf t=\mathbf Z\mathbf v$ is realized. Replace “Their sample variance is $\operatorname{Var}[\mathbf t]=(n-1)^{-1}\mathbf t^T\mathbf t$” with

$$
s_t^2
=\widehat{\operatorname{Var}}_{\text{rows}}(\mathbf t)
=\frac{1}{n-1}\mathbf t^{\mathsf T}\mathbf t,
$$

and call this the empirical variance across row scores. Reserve $\operatorname{Var}(T)$ for the variance of a random variable under a probability model.

### C10. Correct the sum-coding column count

**Severity: correctness.** In `regression-models/generalized-linear-mixed-models.qmd`, `contr.sum(3)` creates two columns, not three. Replace “the three contentfulness columns likewise compare levels” with “the two contentfulness contrast columns compare the three levels around the coding center.”

### C11. Make the Eckart--Young argument a proof or a proof sketch

**Severity: correctness and pedagogy.** `factorization/singular-value-decomposition.qmd` proves orthogonality of the SVD terms, then asserts that an arbitrary rank-$K$ matrix can retain at most $K$ directions. That sentence does not establish the lower bound for all rank-$K$ approximants. Either label the passage “proof sketch” and invoke unitary invariance plus the Eckart--Young--Mirsky theorem, or add the missing bound

$$
\|\mathbf Z-\mathbf B\|_F^2
\ge \sum_{k>K}d_k^2
\qquad
\text{for every }\operatorname{rank}(\mathbf B)\le K,
$$

with a projection or singular-value argument. The truncated SVD then attains the bound.

### C12. Repair the information-criteria heading hierarchy

**Severity: convention.** `model-criticism-and-prediction/information-criteria.qmd` has an empty `## Information criteria compared` immediately followed by `## AIC`. Either remove the empty heading or make AIC and BIC third-level subsections under it.

### C13. Broaden the purpose of exponential-family notation

**Severity: pedagogy and terminology.** `regression-models/exponential-family.qmd` says “The point of this notation is computational.” Replace it with:

> One immediate use of this notation is computational: derivatives of the cumulant function supply the mean and variance used in the score and Hessian. The same representation also identifies natural parameters and sufficient statistics, clarifies conjugate-prior constructions, and makes relationships among response families visible.

This keeps the page's computational focus without teaching an unnecessarily narrow definition.

### C14. Distinguish empirical proportions from model parameters

**Severity: terminology.** The main prose in `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd` now handles this distinction well, but answer 2 calls $147/167$ “the empirical Bernoulli parameter.” Replace it with:

> The empirical probability, or sample proportion, is $147/167=0.880240$. Under an IID Bernoulli sampling model, the same number is the maximum-likelihood estimate of the model parameter $p$.

In `random-variables-and-distributions/poisson-distribution.qmd`, replace “observed zero probability” with “observed zero proportion” unless the sentence explicitly defines the empirical distribution.

### C15. Call the Pearson ratio an estimate under an enlarged variance model, or a diagnostic under Poisson

**Severity: terminology.** The Poisson model fixes $\operatorname{Var}(Y_i\mid x_i)=\lambda_i$ and has no free dispersion parameter. On `regression-models/count-overdispersion.qmd`, use “Pearson dispersion ratio” or “Pearson dispersion diagnostic.” If $\widehat\phi_P$ is called an estimate, state that it estimates a dispersion multiplier in a quasi-Poisson variance model, not a parameter of the fitted Poisson likelihood.

### C16. State the status of recovery thresholds

**Severity: convention and pedagogy.** The thresholds in `custom-models/parameter-recovery.qmd` are presented as prespecified but not justified by estimand scale or intended decision. Call them **teaching acceptance criteria**, explain the consequence of each cutoff in the measurement scale, and show whether the verdict changes under at least one stricter reasonable set. Prespecification protects against selecting a favorable cutoff after seeing results; it does not make the cutoff a disciplinary standard.

### C17. Qualify “exact” intervals in crossed annotation data

**Severity: terminology and correctness.** `custom-models/annotations-as-measurements.qmd` and `custom-models/annotator-effects.qmd` use raw Clopper--Pearson intervals alongside crossed models. Say “Clopper--Pearson intervals under an independent common-probability binomial working model.” They are exact for that model's coverage calculation, not assumption-free intervals under heterogeneous item probabilities and repeated annotators.

### C18. Replace only the statistically empty contrast slogans

**Severity: pedagogy and convention.** The following passages use a binary label contrast where students need the operation that licenses the narrower claim.

- `regression-models/count-overdispersion.qmd`: replace “It is a diagnosis, not a mechanism” with “A large Pearson ratio shows that conditional variability exceeds the fitted Poisson variance. Omitted predictors, dependence, latent heterogeneity, and a different count family can all produce that result, so the statistic by itself does not select among those explanations.”
- `statistical-inference/predictive-distributions.qmd`: replace “This hypergeometric distribution is not a posterior” with “All 588 resource labels are known in this calculation. Randomness enters only through which rows a future without-replacement sample would contain, so the hypergeometric law is a sampling distribution over future counts; no unknown parameter is assigned a posterior distribution.”
- `statistical-inference/confidence-intervals.qmd`: after contrasting coverage and posterior probability, add “Across repeated samples, the endpoints vary while the parameter remains fixed. A posterior interval reverses that conditioning by holding the observed data fixed and assigning probability through a posterior distribution on the parameter.”
- `regression-models/random-effects.qmd`: replace “a consequence of the joint model, not a correction applied afterward” with “The likelihood supplies group-specific evidence and the shared normal distribution supplies information about the population of group effects. Conditioning on both produces posterior or empirical-Bayes group estimates between the unpooled estimate and the population mean; no separate correction step is applied.”
- `custom-models/parameter-recovery.qmd`: replace the opening “simulation, not a substitute” slogan with “The audit generates responses from the proposed model on the observed incidence graph and asks whether the complete fitting procedure recovers the known generating quantities. Success thus checks computation and design information conditional on that generator; evidence that real annotations follow the generator must come from measurement arguments and posterior predictive checks.”

The exact sentence “This is a corpus proportion, not an estimate from independent sentence sampling” is absent from the current tree. Its replacement on the categorical page is substantively better because it defines the fixed-table empirical distribution and states the additional operation required for a sampling-model estimate. Preserve ordinary uses of “This is,” “does not,” and “Thus,” as well as the intentional voice markers “A potential worry is…,” “The basic idea is…,” and “The remaining question is….” They should be revised only when the statistical explanation that follows is itself incomplete.

### C19. Replace Git and build-state jargon with dataset names and statistical operations

**Severity: pedagogy and convention.** Words such as *pinned* and *committed* describe repository state rather than data, sampling, or conditioning. They are especially opaque in phrases such as “committed sample,” “pinned resource,” “pinned table,” and “pinned lexicon.” A commit hash may remain inside a provenance link, but the visible prose should call it the **exact analyzed version** and should then name the dataset and operation directly.

Apply these replacements consistently:

- “release pinned at commit [hash]” → “the [exact analyzed version] of the release”; keep the hash in the link target or provenance note rather than the teaching sentence;
- “committed 120-row sample” or “committed sample” → “the fixed 120-row simple random sample drawn without replacement from the 588 UniMorph lexeme--paradigm rows”;
- “complete pinned resource” or “pinned-resource share” → “the complete 588-row Turkish UniMorph table” or the explicit quantity “$200/588$ of the analyzed UniMorph rows”;
- “pinned CMUdict lexicon/table/rows” → “the CMUdict 0.7b pronunciation-entry table” or “the pronunciation entries retained from CMUdict 0.7b”;
- “pinned table” in an empirical claim → the actual table name, row definition, and relevant filtering operation;
- “pinned release” in a result claim → the named analyzed version and, where relevant, the exact profile, graph, or measurement rows included.

For instance, replace the posterior-distribution passage with:

> The course first drew 120 of the 588 Turkish UniMorph lexeme--paradigm rows by simple random sampling without replacement. The independent Bernoulli superpopulation model does not reproduce that sampling operation: its observations are conditionally independent draws from an indefinitely extensible population.

And replace the corresponding answer with:

> The complete 588-row UniMorph table is observed, so its 200 focal rows and its proportion $200/588$ are fixed features of the analyzed table. Posterior uncertainty is instead assigned to the counterfactual Bernoulli superpopulation parameter $\Theta$.

The sentence “The actual committed sample removed its rows from the pinned resource” is absent from the current tree, but its statistical content should be expressed as: “After selecting the fixed 120-row sample without replacement, the finite-population prediction concerns a new sample drawn from the remaining 468 UniMorph rows.” This wording names the set subtraction and the future sampling operation.

Pages requiring C19 revision are: `random-variables-and-distributions/why-random-variables.qmd`, `defining-random-variables.qmd`, `discrete-random-variables.qmd`, `probability-mass-functions.qmd`, `expected-values.qmd`, `expectation-of-functions.qmd`, `hypergeometric-distribution.qmd`, `covariance.qmd`, and `joint-probability.qmd`; `statistical-inference/posterior-distributions.qmd`, `posterior-summaries.qmd`, `conjugate-priors.qmd`, `prior-predictive-distributions.qmd`, `fishers-exact-test.qmd`, `chi-squared-test.qmd`, `paired-observations.qmd`, and `paired-mean-inference.qmd`; `regression-models/multiple-regression.qmd`, `ordinal-regression.qmd`, `why-generalized-linear-models.qmd`, and `generalized-linear-mixed-models.qmd`; `model-criticism-and-prediction/index.qmd`; `factorization/index.qmd` and `data-matrices.qmd`; `missing-data/missingness-patterns.qmd`, `missingness-mechanisms.qmd`, and `complete-case-analysis.qmd`; and `custom-models/index.qmd`, `generative-stories.qmd`, `annotations-as-measurements.qmd`, and `uds-measurement-model.qmd`.

## Terminology dependency and backlink ledger

The following ledger applies the strict first-use rule to the course order in `_quarto.yml`. “Forward” means that the term occurs before its canonical page; “backlink” means that the term occurs later but its first substantive use on that page does not return students to the canonical treatment. These lists are curricular findings rather than raw string matches; algebraic uses of *residual* in factorization, for instance, are not treated as uses of the regression residual concept.

### Likelihood and maximum likelihood

- **Canonical treatment:** `statistical-inference/maximum-likelihood.qmd`.
- **Forward-definition required:** `foundations/zipfs-law.qmd`; `random-variables-and-distributions/beta-distribution.qmd`, `geometric-distribution.qmd`, `negative-binomial-distribution.qmd`, `normal-distribution.qmd`, `poisson-distribution.qmd`, `student-t-distribution.qmd`, and `when-expectations-fail.qmd`; `statistical-inference/independent-sampling.qmd`.
- **Backlink plus reminder required:** `statistical-inference/poisson-maximum-likelihood.qmd`, `conjugate-priors.qmd`, `beyond-conjugacy.qmd`, `monte-carlo-integration.qmd`, `importance-sampling.qmd`, `markov-chain-monte-carlo.qmd`, `hamiltonian-monte-carlo.qmd`, `stan.qmd`, `divergent-transitions.qmd`, and `generated-quantities.qmd`; `regression-models/bayesian-linear-regression.qmd`, `generalized-linear-models.qmd`, `exponential-family.qmd`, `deviance-residuals.qmd`, `deviance.qmd`, `distributional-regression.qmd`, `laplace-approximation.qmd`, `logistic-regression-example.qmd`, `logistic-regression-with-multiple-predictors.qmd`, `ordered-beta-regression.qmd`, `ordinal-regression.qmd`, `why-not-beta-sliders.qmd`, and the mixed-model likelihood pages; all likelihood-based information-criterion and mixture-selection pages; `missing-data/missingness-mechanisms.qmd`; and the custom-model pages that write or interpret a likelihood.
- **Required local reminder:** “For fixed observed data, the likelihood is the model mass or density viewed as a function of the unknown parameter; maximizing that function yields the maximum-likelihood estimator.” Early pages should then say that the general treatment comes later and link forward.

### Parameter, estimator, and estimate

- **Canonical treatment:** `statistical-inference/properties-of-estimators.qmd`.
- **Forward-definition required:** `foundations/making-sense-of-data.qmd`; `random-variables-and-distributions/normal-distribution.qmd`, `standard-deviation.qmd`, `student-t-distribution.qmd`, `variance-and-covariance.qmd`, `covariance.qmd`, and `correlation.qmd`; `statistical-inference/populations-and-samples.qmd`, `independent-sampling.qmd`, `maximum-likelihood.qmd`, and `poisson-maximum-likelihood.qmd`.
- **Backlink plus reminder required:** `statistical-inference/standard-errors.qmd`, `estimator-bias.qmd`, `mean-squared-error.qmd`, `null-hypotheses-and-test-statistics.qmd`, `paired-mean-inference.qmd`, `monte-carlo-integration.qmd`, and `effective-sample-size.qmd`; `regression-models/linear-regression-uncertainty.qmd` and `count-overdispersion.qmd`; `model-criticism-and-prediction/cross-validation.qmd` and `leave-one-out-cross-validation.qmd`; `custom-models/parameter-recovery.qmd`.
- **Required local reminder:** “An estimator is the random function of a sample before observation; its realized numerical value is an estimate of a fixed model or population quantity.” Because maximum likelihood precedes the canonical estimator page, its first use needs this local definition and a forward link.

### Standard deviation and standard error

- **Canonical treatments:** `random-variables-and-distributions/standard-deviation.qmd` for standard deviation; `statistical-inference/standard-errors.qmd` for standard error.
- **Forward-definition required:** `random-variables-and-distributions/standard-deviation.qmd` when it previews standard error, and `student-t-distribution.qmd`.
- **Backlink plus reminder required:** `statistical-inference/bootstrap-confidence-intervals.qmd`, `one-sample-t-inference.qmd`, `independent-means.qmd`, and `monte-carlo-integration.qmd`; `regression-models/simple-linear-regression.qmd`, `generalized-linear-models.qmd`, `logistic-regression.qmd`, `heteroscedasticity.qmd`, `ridge-regression.qmd`, and `variance-inflation-factors.qmd`; `model-criticism-and-prediction/training-and-test-data.qmd`; `experimental-design/power-by-simulation.qmd` and `within-participant-designs.qmd`; `latent-structure/unsupervised-validation.qmd` and `validating-a-mixture.qmd`.
- **Required local reminder:** “A standard deviation describes variation in a random variable; a standard error is the standard deviation of a specified estimator under a specified repeated-sampling model.” A page reporting `sd(x)/sqrt(n)` must name both the estimator and the sampling unit.

### Confidence and credible intervals

- **Canonical treatments:** `statistical-inference/confidence-intervals.qmd` and `statistical-inference/posterior-summaries.qmd`.
- **Forward-definition required:** `random-variables-and-distributions/student-t-distribution.qmd` for confidence intervals; `statistical-inference/properties-of-estimators.qmd` if interval language is retained before the canonical page.
- **Backlink plus reminder required:** `statistical-inference/exact-binomial-intervals.qmd`, `bootstrap-confidence-intervals.qmd`, and later frequentist interval pages; `missing-data/validating-imputation.qmd` and `custom-models/parameter-recovery.qmd` when they use coverage; any later page reporting a credible interval should link to `posterior-summaries.qmd`.
- **Required local reminder:** “Coverage is a long-run property of a random interval procedure. Posterior probability conditions on the realized data and integrates a posterior distribution over parameter values.”

### Prior, posterior, and posterior prediction

- **Canonical treatments:** `statistical-inference/posterior-distributions.qmd`, `posterior-summaries.qmd`, `prior-predictive-distributions.qmd`, and `posterior-predictive-checks.qmd`.
- **Forward-definition required:** `random-variables-and-distributions/student-t-distribution.qmd`; any earlier distribution page that uses a prior or posterior as motivation.
- **Backlink plus reminder required:** the subsequent Bayesian computation pages from `conjugate-priors.qmd` through `generated-quantities.qmd`; `regression-models/bayesian-linear-regression.qmd`, `linear-regression-uncertainty.qmd`, `random-effects.qmd`, and `influence.qmd`; `model-criticism-and-prediction/information-criteria.qmd`, `leave-one-out-cross-validation.qmd`, `psis-loo.qmd`, and `waic.qmd`; `latent-structure/gaussian-mixtures.qmd`, `posterior-membership.qmd`, and the module index; and all custom-model pages that summarize a posterior.
- **Required local reminder:** “The posterior is proportional to likelihood times prior and is a conditional distribution of unknown quantities given the observed data.” When *posterior predictive* is used, add that it averages a future-data distribution over that posterior.

### Residual and error

- **Canonical treatment:** `regression-models/residuals.qmd` for regression residuals. `factorization/reconstruction.qmd` should remain the canonical page for matrix reconstruction residuals because that is a distinct concept.
- **Forward-definition required:** `foundations/zipfs-law.qmd`; `regression-models/centering-predictors.qmd`, `frequentist-linear-regression.qmd`, `linear-regression-uncertainty.qmd`, and `coefficient-of-determination.qmd`.
- **Backlink plus reminder required:** `regression-models/checking-linear-regression.qmd`, `leverage-and-influence.qmd`, `influence.qmd`, `heteroscedasticity.qmd`, `deviance-residuals.qmd`, `count-overdispersion.qmd`, and the mixed-model diagnostic pages.
- **Required local reminder:** “The model error is an unobserved random deviation in the data-generating equation. A residual is computed after fitting by subtracting a fitted value from an observed response.” Reconstruction errors in PCA and SVD should be named as such and should not link to the regression page merely because the word *residual* appears.

### Fixed and random effects

- **Canonical treatment:** `regression-models/fixed-and-random-effects.qmd`.
- **Forward-definition required:** `model-criticism-and-prediction/likelihood-ratio-tests.qmd` and `regression-models/count-overdispersion.qmd` if they retain random-effect language before the structured-data sequence.
- **Backlink plus reminder required:** `regression-models/random-effects.qmd`, `random-intercepts.qmd`, `intraclass-correlation.qmd`, `random-effect-estimates.qmd`, `random-slopes.qmd`, `random-effect-correlations.qmd`, `singular-fits.qmd`, `generalized-linear-mixed-models.qmd`, `ordinal-mixed-models.qmd`, `aspectual-similarity-example.qmd`, `laplace-approximation.qmd`, `poisson-mixed-models.qmd`, and `overdispersion-and-random-effects.qmd`; `custom-models/annotations-as-measurements.qmd`, `writing-a-joint-model.qmd`, and the later crossed-effects pages.
- **Required local reminder:** “A fixed-effect coefficient describes a systematic predictor contrast. A random-effect term introduces a probability distribution for level-specific deviations associated with a grouping factor.” Avoid defining the distinction as “fixed levels versus randomly sampled levels,” which is not general enough for current mixed-model practice.

### Prediction, cross-validation, and information criteria

- **Canonical treatments:** `model-criticism-and-prediction/prediction-targets.qmd`, `cross-validation.qmd`, and `information-criteria.qmd`.
- **Forward-definition required:** none if the present module order is retained; the index may preview the terms provided that it links forward and says which page develops each.
- **Backlink plus reminder required:** `model-criticism-and-prediction/grouped-cross-validation.qmd`, `comparing-predictive-loss.qmd`, `likelihood-ratio-tests.qmd`, `leave-one-out-cross-validation.qmd`, `psis-loo.qmd`, and `waic.qmd`; `regression-models/aspectual-similarity-example.qmd`; `latent-structure/unsupervised-validation.qmd`, `choosing-a-mixture.qmd`, and `validating-a-mixture.qmd`; `factorization/choosing-components.qmd` and `valex-megaacceptability.qmd`; `missing-data/validating-imputation.qmd`.
- **Required local reminders:** “A prediction target names the unit and outcome to be held out.” “Cross-validation refits the complete procedure on training folds and evaluates a prespecified loss on held-out units.” “AIC and BIC rank a specified candidate set using different approximations and penalties; neither is a model-adequacy test.”

### Principal components and missingness mechanisms

- **Canonical treatments:** `factorization/principal-component-analysis.qmd` and `missing-data/missingness-mechanisms.qmd`.
- **Backlink plus reminder required for PCA:** `factorization/scores-and-loadings.qmd`, `reconstruction.qmd`, `choosing-components.qmd`, and `valex-megaacceptability.qmd`; `missing-data/pca-imputation.qmd` and `validating-imputation.qmd`.
- **Backlink plus reminder required for missingness:** `missing-data/complete-case-analysis.qmd`, `pca-imputation.qmd`, and `validating-imputation.qmd` whenever MCAR, MAR, or MNAR assumptions carry an interpretation.
- **Required local reminders:** “PCA finds orthogonal score directions that successively maximize empirical variance in a centered matrix.” “MCAR, MAR, and MNAR are claims about the conditional distribution of missingness indicators, not visible labels attached to cells.”

## Page-by-page ledger

`No material issue` means that I found no statistical terminology or usage problem requiring revision beyond the course-wide backlink rule. A `TDR` mark points to the dependency ledger. Correction identifiers point to the exact replacement above.

### Foundations

- `foundations/index.qmd` — no material issue.
- `foundations/linguistic-data.qmd` — no material issue; its row-unit contrasts are concrete and should be preserved.
- `foundations/making-sense-of-data.qmd` — TDR: define *estimator* locally or forward-link to the estimator page.
- `foundations/zipfs-law.qmd` — TDR: likelihood, estimator, and regression residual precede their canonical treatments; define each locally and link forward.
- `foundations/possibilities-and-events.qmd` — no material issue.
- `foundations/events.qmd` — no material issue.
- `foundations/event-spaces.qmd` — no material issue.
- `foundations/generating-event-spaces.qmd` — no material issue.
- `foundations/probability-measures.qmd` — no material issue.
- `foundations/probability-concepts.qmd` — no material issue.
- `foundations/joint-probability-of-events.qmd` — no material issue.
- `foundations/conditional-probability.qmd` — no material issue.
- `foundations/probability-factorization.qmd` — no material issue.
- `foundations/bayes-rule.qmd` — no material issue.
- `foundations/independence.qmd` — no material issue.

### Random variables and distributions

- `random-variables-and-distributions/index.qmd` — no material issue.
- `random-variables-and-distributions/why-random-variables.qmd` — C19.
- `random-variables-and-distributions/defining-random-variables.qmd` — C19.
- `random-variables-and-distributions/discrete-random-variables.qmd` — C19.
- `random-variables-and-distributions/probability-mass-functions.qmd` — C19.
- `random-variables-and-distributions/continuous-random-variables.qmd` — no material issue.
- `random-variables-and-distributions/probability-density-functions.qmd` — no material issue; the probability/density distinction follows common usage.
- `random-variables-and-distributions/cumulative-distribution-functions.qmd` — no material issue.
- `random-variables-and-distributions/expected-values.qmd` — C19.
- `random-variables-and-distributions/expectation-of-functions.qmd` — C19.
- `random-variables-and-distributions/linearity-of-expectation.qmd` — no material issue.
- `random-variables-and-distributions/when-expectations-fail.qmd` — TDR: likelihood appears before the canonical treatment.
- `random-variables-and-distributions/variance-and-covariance.qmd` — TDR: distinguish a population variance functional from its sample estimator and link forward.
- `random-variables-and-distributions/standard-deviation.qmd` — TDR: standard error and estimator are previewed before their canonical pages.
- `random-variables-and-distributions/central-moments.qmd` — no material issue.
- `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd` — C14; the revised first-use handling of maximum likelihood is otherwise a model for the course.
- `random-variables-and-distributions/bernoulli-distribution.qmd` — no material issue.
- `random-variables-and-distributions/binomial-distribution.qmd` — no material issue.
- `random-variables-and-distributions/hypergeometric-distribution.qmd` — C19; later pages must distinguish this sampling construction from Fisher conditioning.
- `random-variables-and-distributions/geometric-distribution.qmd` — TDR: maximum likelihood appears before its canonical page.
- `random-variables-and-distributions/negative-binomial-distribution.qmd` — C04 and TDR.
- `random-variables-and-distributions/poisson-distribution.qmd` — C14 and TDR.
- `random-variables-and-distributions/uniform-distribution.qmd` — no material issue.
- `random-variables-and-distributions/beta-distribution.qmd` — TDR: likelihood and maximum likelihood need a forward definition/link.
- `random-variables-and-distributions/normal-distribution.qmd` — TDR: likelihood and estimator need forward definitions/links.
- `random-variables-and-distributions/chi-squared-distribution.qmd` — no material issue.
- `random-variables-and-distributions/student-t-distribution.qmd` — TDR: standard errors, confidence intervals, likelihood, priors, and posteriors all precede their canonical treatments; add a compact forward-link box.
- `random-variables-and-distributions/inverse-transform-sampling.qmd` — no material issue.
- `random-variables-and-distributions/random-seeds.qmd` — no material issue.
- `random-variables-and-distributions/joint-probability.qmd` — C19.
- `random-variables-and-distributions/marginal-distributions.qmd` — no material issue.
- `random-variables-and-distributions/conditional-independence.qmd` — no material issue.
- `random-variables-and-distributions/conditional-expectation.qmd` — no material issue.
- `random-variables-and-distributions/covariance.qmd` — C19 and TDR: identify the sample covariance as an estimator and link forward.
- `random-variables-and-distributions/correlation.qmd` — TDR: identify the sample correlation as an estimator and link forward.

### Statistical inference

- `statistical-inference/index.qmd` — no material issue if each preview link remains explicit.
- `statistical-inference/populations-and-samples.qmd` — TDR: define estimator locally because its canonical page occurs later.
- `statistical-inference/independent-sampling.qmd` — TDR: define the product likelihood locally and forward-link to maximum likelihood.
- `statistical-inference/pronoun-case-example.qmd` — no material issue.
- `statistical-inference/maximum-likelihood.qmd` — TDR: define estimator versus estimate locally and forward-link to `properties-of-estimators.qmd`.
- `statistical-inference/poisson-maximum-likelihood.qmd` — TDR: backlink and one-sentence likelihood reminder.
- `statistical-inference/properties-of-estimators.qmd` — no material issue; canonical page.
- `statistical-inference/standard-errors.qmd` — no material issue; canonical page and its SD/SE distinction is standard.
- `statistical-inference/estimator-bias.qmd` — no material issue beyond TDR backlink.
- `statistical-inference/mean-squared-error.qmd` — no material issue beyond TDR backlink.
- `statistical-inference/confidence-intervals.qmd` — C18; the substantive distinction is right but should show which quantity varies under each conditioning scheme.
- `statistical-inference/exact-binomial-intervals.qmd` — C02 and TDR backlink.
- `statistical-inference/bootstrap-confidence-intervals.qmd` — TDR: backlink confidence interval and standard error.
- `statistical-inference/null-hypotheses-and-test-statistics.qmd` — no material issue beyond estimator backlink.
- `statistical-inference/one-sample-t-inference.qmd` — TDR: standard-error reminder/link.
- `statistical-inference/paired-observations.qmd` — C19.
- `statistical-inference/paired-mean-inference.qmd` — C19 and estimator backlink.
- `statistical-inference/independent-means.qmd` — TDR: standard-error reminder/link.
- `statistical-inference/fishers-exact-test.qmd` — C01 and C19.
- `statistical-inference/chi-squared-test.qmd` — C04 and C19.
- `statistical-inference/posterior-distributions.qmd` — C19; otherwise the canonical page is careful about the counterfactual superpopulation model.
- `statistical-inference/posterior-summaries.qmd` — C19; otherwise no material issue on the canonical credible-summary page.
- `statistical-inference/conjugate-priors.qmd` — C19 and TDR: backlink likelihood and posterior with reminders.
- `statistical-inference/prior-predictive-distributions.qmd` — C19 and posterior backlink.
- `statistical-inference/predictive-distributions.qmd` — C18 and TDR.
- `statistical-inference/beyond-conjugacy.qmd` — no material statistical issue; its fixed-$\nu=4$ explanation and sensitivity check are appropriately qualified. Add TDR links.
- `statistical-inference/monte-carlo-integration.qmd` — TDR: estimator, SE, likelihood, and posterior reminders/links.
- `statistical-inference/importance-sampling.qmd` — no material issue beyond TDR posterior/likelihood backlinks.
- `statistical-inference/markov-chains.qmd` — no material issue beyond posterior backlink.
- `statistical-inference/markov-chain-monte-carlo.qmd` — no material issue beyond posterior/likelihood backlinks.
- `statistical-inference/metropolis-hastings.qmd` — no material issue beyond posterior backlink.
- `statistical-inference/hamiltonian-monte-carlo.qmd` — no material issue beyond posterior/likelihood backlinks.
- `statistical-inference/mass-matrix-geometry.qmd` — no material issue beyond posterior backlink.
- `statistical-inference/no-u-turn-sampler.qmd` — no material issue beyond posterior backlink.
- `statistical-inference/stan.qmd` — no material issue beyond posterior/likelihood backlinks.
- `statistical-inference/checking-markov-chains.qmd` — no material issue beyond posterior backlink.
- `statistical-inference/rhat.qmd` — no material issue; its convergence limitations follow common usage. Add posterior backlink.
- `statistical-inference/autocorrelation.qmd` — no material issue beyond posterior backlink.
- `statistical-inference/effective-sample-size.qmd` — no material issue; it distinguishes Monte Carlo and posterior uncertainty. Add estimator/posterior backlinks.
- `statistical-inference/divergent-transitions.qmd` — no material issue beyond likelihood/posterior backlinks.
- `statistical-inference/parameter-pair-plots.qmd` — no material issue beyond posterior backlink.
- `statistical-inference/generated-quantities.qmd` — no material issue beyond likelihood/posterior backlinks.
- `statistical-inference/posterior-predictive-checks.qmd` — no material issue; canonical page. Add a posterior reminder/link at first use.

### Regression models

- `regression-models/index.qmd` — no material statistical issue; its response-family contrasts are substantive rather than empty slogans.
- `regression-models/regression-models.qmd` — no material issue.
- `regression-models/simple-linear-regression.qmd` — TDR: standard-error backlink/reminder where used.
- `regression-models/centering-predictors.qmd` — TDR: residual precedes the canonical residual page.
- `regression-models/response-transformations.qmd` — no material issue.
- `regression-models/frequentist-linear-regression.qmd` — C04; estimator backlink already present.
- `regression-models/linear-regression-uncertainty.qmd` — TDR: estimator, residual, posterior, and uncertainty terms need canonical links/reminders.
- `regression-models/coefficient-of-determination.qmd` — TDR: define residual locally and forward-link.
- `regression-models/residuals.qmd` — no material issue; canonical page.
- `regression-models/checking-linear-regression.qmd` — no material issue beyond residual backlink.
- `regression-models/leverage-and-influence.qmd` — no material issue beyond residual backlink.
- `regression-models/influence.qmd` — no material issue beyond residual/posterior backlinks.
- `regression-models/bayesian-linear-regression.qmd` — no material issue beyond likelihood/posterior backlinks.
- `regression-models/multiple-regression.qmd` — C19.
- `regression-models/design-matrices.qmd` — no material issue.
- `regression-models/coding-categorical-predictors.qmd` — no material issue.
- `regression-models/sum-coding.qmd` — no material issue.
- `regression-models/helmert-coding.qmd` — no material issue.
- `regression-models/inverse-helmert-coding.qmd` — no material issue.
- `regression-models/interactions.qmd` — no material issue.
- `regression-models/correlated-predictors.qmd` — no material issue.
- `regression-models/variance-inflation-factors.qmd` — no material issue beyond standard-error backlink.
- `regression-models/ridge-regression.qmd` — no material issue beyond standard-error backlink.
- `regression-models/residualizing-a-predictor.qmd` — no material issue; distinguish this algebraic operation from the response residual at first use.
- `regression-models/heteroscedasticity.qmd` — no material issue beyond residual/standard-error backlinks.
- `regression-models/distributional-regression.qmd` — no material issue beyond likelihood and prediction-target backlinks.
- `regression-models/why-generalized-linear-models.qmd` — C19.
- `regression-models/link-functions.qmd` — no material issue.
- `regression-models/generalized-linear-models.qmd` — no material issue beyond likelihood and standard-error backlinks.
- `regression-models/exponential-family.qmd` — C13 and TDR likelihood backlink.
- `regression-models/sufficient-statistics.qmd` — C04.
- `regression-models/iteratively-reweighted-least-squares.qmd` — no material issue; the working-response distinction is statistically substantive.
- `regression-models/deviance.qmd` — no material issue beyond likelihood backlink.
- `regression-models/odds-and-log-odds.qmd` — no material issue.
- `regression-models/logistic-regression.qmd` — no material issue beyond standard-error backlink.
- `regression-models/logistic-regression-example.qmd` — no material issue beyond likelihood backlink.
- `regression-models/logistic-regression-with-multiple-predictors.qmd` — no material issue beyond likelihood backlink.
- `regression-models/deviance-residuals.qmd` — no material issue beyond likelihood/residual backlinks.
- `regression-models/ordinal-regression.qmd` — C19 and likelihood backlink.
- `regression-models/poisson-regression.qmd` — no material issue.
- `regression-models/exposure-offsets.qmd` — no material issue.
- `regression-models/poisson-regression-example.qmd` — no material issue.
- `regression-models/count-overdispersion.qmd` — C04, C15, C18, and TDR for residual/random-effect language.
- `regression-models/quasi-poisson.qmd` — no material issue; its statement that quasi-likelihood does not define an ordinary AIC likelihood is standard. Add information-criteria backlink.
- `regression-models/zero-inflated-counts.qmd` — no material issue; it appropriately avoids inferring a structural-zero process from excess zeros alone.
- `regression-models/negative-binomial-regression.qmd` — no material issue.
- `regression-models/bounded-responses.qmd` — no material issue.
- `regression-models/why-not-beta-sliders.qmd` — no material issue beyond likelihood backlink.
- `regression-models/ordered-beta-regression.qmd` — no material issue beyond likelihood backlink.
- `regression-models/structured-data.qmd` — no material issue.
- `regression-models/fixed-and-random-effects.qmd` — no material issue; canonical page.
- `regression-models/random-effects.qmd` — C18 and TDR backlink.
- `regression-models/random-intercepts.qmd` — no material issue beyond fixed/random-effects backlink.
- `regression-models/intraclass-correlation.qmd` — no material issue beyond fixed/random-effects backlink.
- `regression-models/random-effect-estimates.qmd` — no material issue beyond fixed/random-effects backlink.
- `regression-models/random-slopes.qmd` — no material issue beyond fixed/random-effects backlink.
- `regression-models/random-effect-correlations.qmd` — no material issue beyond fixed/random-effects backlink.
- `regression-models/singular-fits.qmd` — no material issue beyond fixed/random-effects backlink.
- `regression-models/generalized-linear-mixed-models.qmd` — C10, C19, and TDR likelihood/fixed-effect backlinks.
- `regression-models/ordinal-mixed-models.qmd` — no material issue beyond likelihood/fixed-effect backlinks.
- `regression-models/aspectual-similarity-example.qmd` — no material issue beyond cross-validation/likelihood/fixed-effect backlinks.
- `regression-models/laplace-approximation.qmd` — C04 and TDR likelihood/fixed-effect backlinks.
- `regression-models/poisson-mixed-models.qmd` — no material issue beyond likelihood/fixed-effect backlinks.
- `regression-models/overdispersion-and-random-effects.qmd` — C04 and TDR fixed/random-effects backlink.

### Model criticism and prediction

- `model-criticism-and-prediction/index.qmd` — C19 and TDR: preview links should carry one-clause definitions of prediction target, cross-validation, and information criterion.
- `model-criticism-and-prediction/prediction-targets.qmd` — no material issue; canonical page.
- `model-criticism-and-prediction/training-and-test-data.qmd` — no material issue beyond prediction-target and standard-error backlinks.
- `model-criticism-and-prediction/predictive-loss.qmd` — no material issue.
- `model-criticism-and-prediction/bias-variance-tradeoff.qmd` — no material issue beyond cross-validation backlink.
- `model-criticism-and-prediction/cross-validation.qmd` — no material issue; canonical page. Link estimator terminology when defining risk estimates.
- `model-criticism-and-prediction/grouped-cross-validation.qmd` — no material issue beyond cross-validation, confidence-interval, and prediction-target backlinks.
- `model-criticism-and-prediction/comparing-predictive-loss.qmd` — no material issue beyond cross-validation/likelihood backlinks.
- `model-criticism-and-prediction/likelihood-ratio-tests.qmd` — TDR: cross-validation and random effects require links; also define the maximized likelihood as a realized likelihood value, which the current page largely does.
- `model-criticism-and-prediction/information-criteria.qmd` — C12 and TDR likelihood/posterior/prediction backlinks.
- `model-criticism-and-prediction/leave-one-out-cross-validation.qmd` — C03 and TDR.
- `model-criticism-and-prediction/psis-loo.qmd` — no material issue beyond cross-validation, prediction-target, likelihood, and posterior backlinks.
- `model-criticism-and-prediction/waic.qmd` — no material issue beyond cross-validation, information-criteria, likelihood, and posterior backlinks.

### Experimental design

- `experimental-design/index.qmd` — no material issue.
- `experimental-design/units-of-assignment.qmd` — no material issue; assignment-unit and measurement-unit distinctions are standard.
- `experimental-design/random-assignment.qmd` — no material issue.
- `experimental-design/within-participant-designs.qmd` — C05 and TDR standard-error backlink.
- `experimental-design/between-participant-designs.qmd` — no material issue.
- `experimental-design/counterbalancing.qmd` — no material issue.
- `experimental-design/exclusion-rules.qmd` — no material issue.
- `experimental-design/power-by-simulation.qmd` — C07 and TDR standard-error backlink; its Monte Carlo SE formula is otherwise standard.

### Latent structure

- `latent-structure/index.qmd` — TDR: likelihood, posterior, and information-criterion previews need explicit links/reminders.
- `latent-structure/representing-objects.qmd` — no material issue.
- `latent-structure/distance-and-scaling.qmd` — no material issue.
- `latent-structure/k-means.qmd` — no material issue.
- `latent-structure/within-cluster-loss.qmd` — no material issue.
- `latent-structure/silhouette-scores.qmd` — no material issue.
- `latent-structure/unsupervised-validation.qmd` — C05, C08, and TDR cross-validation/standard-error backlinks.
- `latent-structure/gaussian-mixtures.qmd` — no material issue beyond likelihood/posterior backlinks.
- `latent-structure/posterior-membership.qmd` — TDR: link to posterior distributions and state that this is a conditional component-membership probability under the mixture model.
- `latent-structure/expectation-maximization.qmd` — no material issue beyond likelihood and information-criterion backlinks.
- `latent-structure/choosing-a-mixture.qmd` — TDR: backlink to information criteria and remind students that BIC's penalty is $k\log n$.
- `latent-structure/validating-a-mixture.qmd` — C05 and TDR cross-validation, standard-error, and information-criterion backlinks.

### Factorization

- `factorization/index.qmd` — C19 and TDR: PCA preview should link forward and state the variance-maximization target.
- `factorization/data-matrices.qmd` — C19.
- `factorization/centering-and-scaling.qmd` — no material issue.
- `factorization/rank-one-structure.qmd` — no material issue.
- `factorization/singular-value-decomposition.qmd` — C11.
- `factorization/principal-component-analysis.qmd` — C09; canonical PCA page.
- `factorization/scores-and-loadings.qmd` — no material issue beyond PCA backlink.
- `factorization/reconstruction.qmd` — no material issue; keep reconstruction residual terminology distinct from regression residuals.
- `factorization/choosing-components.qmd` — TDR: PCA and cross-validation backlinks/reminders.
- `factorization/valex-megaacceptability.qmd` — TDR: PCA and cross-validation backlinks/reminders.

### Missing data

- `missing-data/index.qmd` — TDR: preview PCA and missingness mechanisms with links and one-clause reminders.
- `missing-data/missingness-patterns.qmd` — C19.
- `missing-data/missingness-mechanisms.qmd` — C19; otherwise no material issue on the canonical mechanism page. Add likelihood/fixed-effect backlinks where those terms carry the argument.
- `missing-data/complete-case-analysis.qmd` — C19 and TDR: missingness-mechanism and PCA backlinks/reminders.
- `missing-data/pca-imputation.qmd` — TDR: PCA and missingness-mechanism backlinks/reminders.
- `missing-data/validating-imputation.qmd` — C08 and TDR for PCA, cross-validation, prediction targets, confidence coverage, and missingness mechanisms.

### Custom models

- `custom-models/index.qmd` — C19 and TDR: likelihood, posterior, and fixed/random-effect previews need canonical links/reminders.
- `custom-models/generative-stories.qmd` — C06, C19, and TDR.
- `custom-models/writing-a-joint-model.qmd` — C06 and TDR likelihood/fixed-effect backlinks.
- `custom-models/parameter-recovery.qmd` — C06, C16, C18, and TDR estimator/posterior/coverage backlinks.
- `custom-models/annotations-as-measurements.qmd` — C17, C19, and TDR likelihood/fixed-effect backlinks.
- `custom-models/annotator-effects.qmd` — C06, C17, and TDR likelihood/posterior/fixed-effect backlinks.
- `custom-models/uds-measurement-model.qmd` — C06, C19, and TDR likelihood/posterior backlinks.
- `custom-models/gated-annotations.qmd` — C06 and TDR likelihood/posterior backlinks.

## Recommended implementation order

1. Correct C01 and C04--C07, then rerender every affected page. These changes alter claims or derivations students may otherwise learn incorrectly.
2. Align the custom-model parameterization across the generative story, Stan code explanation, recovery targets, and posterior factorization before making prose-only refinements.
3. Apply C02--C03 and C08--C17, which standardize names and prevent common inferential misreadings.
4. Implement the TDR systematically. Begin with the early distribution pages because their forward definitions determine what later backlinks can sensibly summarize.
5. Revise only the C18 passages whose binary contrast currently replaces an explanation. Preserve statistically informative contrasts elsewhere.
6. Run a final source check for unmatched display delimiters, malformed LaTeX commands, duplicate acronyms, and first-use terms without local definitions or links.

The live pedagogical possibility is to make the dependency system visible rather than merely compliant. A short “Recall” sentence at the first substantive reuse of a term can tell students both where the concept was developed and which part of it matters now. That structure would turn the notes from a sequence of individually careful pages into a cumulative statistical argument.
