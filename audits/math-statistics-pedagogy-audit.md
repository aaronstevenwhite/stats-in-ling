# Mathematics and statistics pedagogy audit

## Scope and standard

This audit covers every active Quarto notes page in `foundations`,
`random-variables-and-distributions`, `statistical-inference`,
`regression-models`, `model-criticism-and-prediction`,
`experimental-design`, `latent-structure`, `factorization`, `missing-data`, and
`custom-models`. It excludes the root index, slides, archived sources,
assignments, problem sets, generated HTML, and data documentation.

I evaluated each page for eight properties: (i) motivation before formalism,
(ii) retrieval of prerequisite concepts, (iii) notation introduced before use,
(iv) a visible derivation or formula-to-code bridge, (v) an empirical or
worked example, (vi) interpretation on the scale of the measurement, (vii)
explicit assumptions and likely misconceptions, and (viii) a recap, retrieval
question, or forward link.

I then applied a stricter **concept-dependency standard**. A technical term may
appear before its canonical treatment only if the prose marks the use as
provisional, supplies enough local meaning to continue, and links forward to
that treatment. Once the term has been taught, the first substantive reuse on a
later page must link back and briefly retrieve the meaning needed on the new
page. An adjacent “previous/next page” link does not satisfy this requirement
unless it actually retrieves the concept. The dependency ledger below records
566 minimum gaps across 190 pages: 44 forward-pointer gaps and 522 backlink
gaps for a controlled inventory of 31 course concepts. Because that inventory
is deliberately conservative, these are lower bounds.

I also audited recurring prose structures in context. Raw counts of *Thus*,
*This is*, and *does not* are not defects, and the characteristic pivots *A
potential worry is…*, *The basic idea is…*, and *The remaining question is…*
should remain when they introduce substantive reasoning. The actual problem is
the interchangeable label-versus-overclaim mold “X is Y, not Z,” together with
caveat paragraphs that only negate an interpretation. The active notes contain
181 copular comma-*not* instances on 115 pages. A small number state a genuine
mathematical category distinction efficiently; most should be replaced by the
measurement, sampling, or algebraic process that makes Y appropriate and blocks
Z.

“No material issue” in the original page ledger means that the page meets the
eight instructional aims well enough that adding more prose would likely repeat
rather than clarify. It does **not** override a dependency or recurring-structure
action recorded in the supplemental ledgers.

## Coverage

The audit inspected 214 of 214 scoped pages.

| Module | Pages inspected | Page-specific actions | Pages with dependency gaps | “X is Y, not Z” instances (pages) |
|---|---:|---:|---:|---:|
| Foundations | 15 | 1 | 12 | 9 (7) |
| Random variables and distributions | 35 | 6 | 32 | 15 (12) |
| Statistical inference | 43 | 0 | 40 | 36 (24) |
| Regression models | 64 | 7 | 54 | 50 (33) |
| Model criticism and prediction | 13 | 1 | 13 | 13 (9) |
| Experimental design | 8 | 0 | 8 | 8 (5) |
| Latent structure | 12 | 1 | 9 | 11 (8) |
| Factorization | 10 | 1 | 9 | 9 (6) |
| Missing data | 6 | 0 | 5 | 9 (5) |
| Custom models | 8 | 1 | 8 | 21 (6) |
| **Total** | **214** | **17** | **190** | **181 (115)** |

The pages already have unusually strong measurement grounding. In particular,
they tend to name the row unit, distinguish a source measurement from a derived
quantity, explain why a simplified model is being used, preserve the distinction
between description and generalization, and end with a misconception check.
The main remaining problems are consequently concentrated rather than diffuse.

## Priorities

1. **Repair two broken display-math regions before any further release.** In
   `regression-models/count-overdispersion.qmd` and
   `regression-models/overdispersion-and-random-effects.qmd`, prose and equations
   have been interleaved inside unmatched display regions. This can make the
   central derivation unreadable in the rendered notes.
2. **Repair the concept dependency graph.** The site has strong adjacent
   navigation but does not yet meet the requested first-definition and
   link-plus-reminder rule. Add a one- or two-sentence “Prerequisite retrieval”
   block near the first substantive reuse on each page, using the dependency
   ledger below; add explicit forward pointers for all 44 early uses.
3. **Bridge the early distribution fits to the later treatment of maximum
   likelihood.** Four distribution pages use likelihood optimization before the
   formal inference page defines probability versus likelihood, the optimization
   target, and the status of an estimate. The local calculations are mostly
   correct, but the sequence may teach optimization as a software operation
   rather than an inferential rule.
4. **Replace label-versus-label slogans with process explanations.** The
   “X is Y, not Z” mold appears 181 times. Retain it only for the short whitelist
   of genuine category errors below. Elsewhere, state how the row was created,
   what random operation is assumed, or which algebraic equality supplies the
   conclusion.
5. **Add one hand-worked numerical pass through the most abstract algorithms.**
   Expectation-maximization, ordered-beta regression, and WAIC all provide
   correct symbolic treatments. Each would benefit from one small numerical
   bridge before the full empirical computation.
6. **Distinguish a proof, a proof sketch, and a declared decision rule.** The SVD
   page presents a compressed argument as the Eckart--Young result, while the
   parameter-recovery page gives exact thresholds without explaining their
   calibration. Both should state the epistemic status of the displayed argument
   or cutoff.
7. **Repair one inline notation defect and two wholly isolated pages.** Two pages
   have no internal note link at all, and one sufficient-statistics sentence
   renders `n={}` before an inline R value. These are the most visible members of
   the broader dependency problem, not the entire link problem.

## Cross-cutting findings

### The measurement-to-model chain is now a major strength

The notes generally make the chain from source record to analysis row to random
variable to estimand visible. The Provo, Hillenbrand, MALD, ManyBabies, Natural
Stories, UDS, PHOIBLE, Peterson--Barney, Jacy, and Turkish resource dossiers
usually explain what one row means, which units repeat, what preprocessing has
removed, and which population claim remains unsupported. No global rewrite is
needed here. Future revisions should preserve this architecture.

### Retrieval practice is broad, but the concept graph is incomplete

Nearly every substantive page ends with a check and an answer. Index pages
appropriately use roadmaps rather than pretending to be exercises. The notes
also contain many useful links. But the links mainly provide adjacent
navigation; they do not consistently retrieve the exact prerequisite at the
moment it becomes operative. The controlled scan found 566 missing concept
links or forward pointers across 190 pages. For instance,
`random-variables-and-distributions/student-t-distribution.qmd` uses *sampling
distribution*, *standard error*, *confidence interval*, *posterior
distribution*, and *residual* before their canonical pages. Its local prose is
often enough to infer the intended contrast, but the requested dependency rule
requires explicit forward links and tells the student which ideas are only
provisional. At the other end of the course,
`experimental-design/power-by-simulation.qmd` reuses variance, standard
deviation, covariance, standard error, Monte Carlo, independence, events, and
residuals without a compact retrieval block.

The cleanest repair is a page-level **prerequisite retrieval block** rather than
a link on every repeated token. Put it immediately after the opening problem,
list only the concepts actually used on that page, link each to its canonical
first treatment, and remind the reader of the operative part in one clause. For
instance: “Recall that a standard error is the standard deviation of an
estimator's sampling distribution; [the standard-error page](...) derives that
distinction.” This meets the strict rule without turning every paragraph into a
glossary. The two wholly isolated pages,
`foundations/independence.qmd` and
`random-variables-and-distributions/hypergeometric-distribution.qmd`, still need
the P5 repairs even under this broader scheme.

### The appropriate unit of additional hand-holding is a worked transition

Most pages do not need longer introductions. They need a small number of
transitions that show what changes from one line to the next. The best existing
examples do this well: the Clopper--Pearson page reverses the two tails explicitly;
the K-means page works through one complete assignment and update; the Student-t
posterior page traces an eye movement to one passage contrast before deriving the
posterior. The actions below use those pages as the local standard.

### Software output should never carry the substantive conclusion by itself

Most pages already narrate their computed result after a code block. The Poisson
worked analysis is the main exception: it prints the fitted rate ratio and Wald
interval but does not state their numerical values and units in the prose. A
student should be able to read the inferential claim without reverse-engineering
an R table.

### Caveats should explain the positive data-generating or measurement process

The revised caveat in
`random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd`
is a useful positive control. It now says that several token rows may share a
sentence, explains why that sharing can induce dependence, states that the five
registers were selected rather than sampled from all Turkish use, and spells out
that the resulting proportions describe this release rather than Turkish as a
whole. That concrete chain is much better than the compressed formula “tokens
remain nested … not a probability sample … pinned corpus extract.”

Four pages still use the compressed form. In
`foundations/possibilities-and-events.qmd`, the paragraph beginning “This
restriction has a useful consequence” should say which rows receive equal
weight, how repeated sentence membership violates a sentence-sampling story,
and what inclusion mechanism would be needed for a Turkish-usage estimand. In
`statistical-inference/populations-and-samples.qmd`, “a census of the qualifying
rows in one pinned release” should be followed by a concrete contrast between
the probability of a row under uniform resampling of this file and the unknown
probability of a pronoun token in Turkish use. In
`random-variables-and-distributions/beta-distribution.qmd`, “a descriptive model
over first-stage fitted values” should explain that the beta likelihood treats
the fitted predictabilities as observed numbers and therefore omits uncertainty
from the first-stage cloze model. In
`model-criticism-and-prediction/information-criteria.qmd`, “does not license
reader-level or passage-level inference” should say that the input has one
aggregated row per position, so neither readers nor entire passages are the
independent held-out unit used by the criterion.

### The recurring label-versus-overclaim mold obscures explanations

The 181 “X is Y, not Z” instances are concentrated in statistical inference,
regression, and custom modeling. Their nouns are often interchangeable: “a
teaching prior, not a confirmatory analysis”; “a diagnostic, not a mechanism”;
“a computational choice, not a model assumption”; “a teaching bridge, not a
claim.” These slogans usually name the safe side of a distinction without
showing why it is safe.

Replace the slogan with the licensing process. For instance:

- In `statistical-inference/beyond-conjugacy.qmd`, replace “This is an
  empirically calibrated teaching prior, not a confirmatory analysis” with:
  “The prior location and scale were chosen after inspecting the observed FFD
  scale so that the grid calculation remains numerically useful. Because the
  outcomes helped set those values, the resulting posterior cannot be presented
  as an analysis based on pre-data prior commitments.”
- In `regression-models/count-overdispersion.qmd`, replace “It is a diagnosis,
  not a mechanism” by tracing the many-to-one mapping: the same large Pearson
  ratio can arise from an omitted mean term, unmodeled clustering, latent rate
  heterogeneity, or excess zeros, so the statistic cannot select among those
  processes.
- In `custom-models/parameter-recovery.qmd`, replace “an audited model
  simulation, not a substitute for linguistic data” with the operation that was
  performed: parameters generate synthetic annotations under the fitted model,
  and refitting tests whether the procedure recovers those parameters; because
  no observed annotation distribution enters that check, it supplies no
  evidence that the model describes actual annotators.
- In `missing-data/index.qmd`, replace “a sampling or coverage problem, not a
  missing cell” by saying that excluded Jacy sentences never become rows in the
  realized matrix, whereas a missing cell occurs only after a row exists and one
  intended measurement is unavailable.

Retain the construction only where the two labels mark an immediate mathematical
category error and the surrounding text already supplies the reason. Strong
instances include the comma-as-intersection statement in
`foundations/joint-probability-of-events.qmd`, integration-versus-density height
in `random-variables-and-distributions/probability-density-functions.qmd`, the
sampling-probability-versus-posterior-probability distinction in
`statistical-inference/confidence-intervals.qmd`, the p-value distinction in
`statistical-inference/null-hypotheses-and-test-statistics.qmd`, response versus
parameter in `regression-models/generalized-linear-models.qmd`, and odds ratio
versus probability ratio in `regression-models/logistic-regression.qmd`.

The recurrence of *A potential worry is…* is not a problem. In the inspected
instances it introduces an actual objection and a bounded reply, which is a
deliberate voice marker. The same is true of *The basic idea is…* and *The
remaining question is…*. Sentence-initial *Thus* generally follows a displayed
derivation; only `statistical-inference/beyond-conjugacy.qmd` uses it once to
move from data aggregation to row interpretation without an inferential step,
and that instance can simply begin “After this aggregation…”.

### Roadmaps should remain, but their architecture should vary with the problem

The site uses an opening “We first…, then…, and finally…” or “This page first…”
roadmap on 114 pages: 38 of 43 inference pages and 51 of 64 regression pages.
The signposting is useful, but the repeated three-stage syntax makes independent
pages sound generated from one template. Preserve detailed roadmaps for long
derivations and algorithms. On shorter pages, begin with the unresolved
question and let the headings carry the sequence. For instance,
`regression-models/correlated-predictors.qmd` can open with the coefficient
identification problem created by overlapping predictors;
`regression-models/deviance-residuals.qmd` can begin with why a Bernoulli raw
residual has an asymmetric scale; and
`statistical-inference/independent-sampling.qmd` can begin with two concrete
rows that are identically distributed but dependent. This retains signposting
without making every page announce the same three verbs.

### Repository provenance should be translated into student-facing objects

The active notes use *pinned* or *committed sample/resource/table* 59 times on
34 pages. These terms are useful to a maintainer because they imply a fixed
commit or immutable artifact. They do not tell a student which table exists,
how many rows it contains, or what operation produced the next table. Replace
them in instructional prose with the concrete object and action; keep a commit
hash or version tag only in a short provenance sentence or link.

The most urgent instance is
`statistical-inference/predictive-distributions.qmd`: “The actual committed
sample removed its rows from the pinned resource” should become “The 120
lexeme–paradigm rows already drawn were removed from the 588-row UniMorph
table.” Likewise, “remaining committed resource” should become “the remaining
468 UniMorph rows.” Other recurring repairs are:

- `random-variables-and-distributions/why-random-variables.qmd`,
  `defining-random-variables.qmd`, `discrete-random-variables.qmd`,
  `probability-mass-functions.qmd`, `expected-values.qmd`,
  `expectation-of-functions.qmd`, `joint-probability.qmd`, and `covariance.qmd`:
  say “the prepared
  CMUdict 0.7b course table” or “the 133,854 pronunciation-entry rows,” depending
  on what the sentence needs.
- `random-variables-and-distributions/hypergeometric-distribution.qmd`,
  `statistical-inference/populations-and-samples.qmd`,
  `posterior-distributions.qmd`, `posterior-summaries.qmd`,
  `prior-predictive-distributions.qmd`, `conjugate-priors.qmd`,
  `fishers-exact-test.qmd`, and `chi-squared-test.qmd`: say “the 588-row Turkish
  UniMorph table analyzed here,” “the 120 rows drawn without replacement,” or
  the exact remaining-row count. Put commit `6c179ac` once in provenance.
- `statistical-inference/paired-observations.qmd` and
  `paired-mean-inference.qmd`: say “the UCCA v2 passage graphs analyzed here” and
  distinguish them from the 2015 article's numerical release.
- `missing-data/missingness-patterns.qmd` and
  `missingness-mechanisms.qmd`: say “the analyzed Jacy release” or name the
  profiles and row counts; `complete-case-analysis.qmd` should say “the
  Hillenbrand table at the linked source revision.”
- `custom-models/index.qmd`, `generative-stories.qmd`,
  `uds-measurement-model.qmd`, and `annotations-as-measurements.qmd`: use “UD
  English EWT 1.2,” “`decomp` 0.3.2,” or “the privacy-sanitized Turkish PropBank
  course table.”
- `foundations/zipfs-law.qmd`, `regression-models/why-generalized-linear-models.qmd`,
  `generalized-linear-mixed-models.qmd`, `multiple-regression.qmd`,
  `ordinal-regression.qmd`, `model-criticism-and-prediction/index.qmd`,
  `factorization/index.qmd`, and `factorization/data-matrices.qmd`: replace the
  maintenance adjective with the named release, analyzed CSV, or preparation
  rule already available on the page.

This revision is not cosmetic. Concrete nouns expose the sampling frame and
make later finite-population calculations checkable.

## Action register

### P1. Repair the count-overdispersion derivation

- **File and location:** `regression-models/count-overdispersion.qmd`, beginning
  with “The estimator is” and ending after the displayed definition of
  \(\widehat\phi\).
- **Weak point:** An opening `$$` occurs before the prose “The numerator is …,”
  another display opens inside it, and the formula for \(\widehat\phi\) appears
  only after the prose about the denominator. The complete explanation is thus
  inside one malformed display region.
- **Pedagogical risk:** This is the page's central definition. A student may see
  missing prose, unrendered TeX, or a formula whose numerator and denominator
  appear in the wrong order. The later distinction between a diagnostic and a
  mechanism cannot compensate for a broken diagnostic definition.
- **Concrete fix:** Close the first display immediately after the complete
  \(\widehat\phi\) formula. Then explain the Pearson residual numerator, derive
  \(\sum_i(r_i^P)^2\), and explain the approximate \(n-p\) denominator in prose.
  End with one substitution using the fitted Nettle model: report the numerator,
  residual degrees of freedom, and their ratio. Keep the existing mechanism
  table.

### P2. Repair the marginal-dispersion moment derivation

- **File and location:** `regression-models/overdispersion-and-random-effects.qmd`,
  the section “Averaging over the passage-pair population,” around the sentence
  “This identity follows from the normal moment-generating function.”
- **Weak point:** A display opens after “Because \(b\sim\mathcal N(0,\tau_p^2)\),”
  but prose and a second display are inserted before the first expression is
  completed. The intended identity
  \(\operatorname E[\exp(B)]=\exp(\tau_p^2/2)\) appears after a stray display
  close.
- **Pedagogical risk:** The law-of-total-variance argument depends on this
  lognormal moment. If the identity is visually detached from its justification,
  students may treat the marginal overdispersion formula as an unexplained fact.
- **Concrete fix:** Present the moment-generating-function reminder in prose;
  then use one aligned display containing \(M_B(t)\), \(M_B(1)\), \(M_B(2)\), and
  \(\operatorname{Var}(e^B)\). Continue immediately to the marginal mean and
  variance. Add a one-sentence check that setting \(\tau_p=0\) recovers the
  conditional Poisson mean--variance equality.

### P3. Add a provisional maximum-likelihood bridge in the distribution module

- **Files and locations:**
  `random-variables-and-distributions/geometric-distribution.qmd` at “The
  maximum-likelihood estimate is”; `beta-distribution.qmd` at
  “Maximum-likelihood fit”; `normal-distribution.qmd` at “For observations
  \(x_1,\ldots,x_n\), maximum likelihood gives”; and
  `poisson-distribution.qmd` at its fit and final “fitted its Poisson mean by
  maximum likelihood” summary.
- **Weak point:** These pages estimate parameters before
  `statistical-inference/maximum-likelihood.qmd` formally distinguishes
  \(p(X=x\mid\theta)\) from \(L(\theta;x)\) and derives an optimizer.
- **Pedagogical risk:** Students may infer that “fit a distribution” means call
  `optim()` or accept a printed estimate. That interpretation hides what is held
  fixed, what varies, and why the empirical mean or frequency solves the
  optimization.
- **Concrete fix:** On the first use, add a short box: after observing
  \(\mathbf x\), likelihood is the joint probability or density of those fixed
  observations viewed as a function of the unknown parameter; an MLE is the
  parameter value maximizing that function. Link forward to
  `../statistical-inference/maximum-likelihood.qmd`. On the geometric, normal,
  and Poisson pages, retain the score derivations and add a one-line reminder
  linking forward to the formal treatment. On the beta page, show at least one
  directional check on the fitted objective, such as the fitted log likelihood
  versus a nearby shape pair, so `optim()` is visibly solving the declared
  problem.

### P4. Make the lost degree of freedom visible before using the chi-squared result

- **File and location:**
  `random-variables-and-distributions/chi-squared-distribution.qmd`, the paragraph
  that moves from the normal sample to
  \((n-1)S^2/\sigma^2\sim\chi^2_{n-1}\).
- **Weak point:** The page says that estimating the mean “removes one free
  direction,” but the first concrete calculation uses the full Hillenbrand
  sample.
- **Pedagogical risk:** Students often memorize \(n-1\) as a correction rather
  than seeing the constraint \(\sum_i(X_i-\overline X)=0\). That makes the later
  Student-t construction look like a convention rather than a consequence of
  centering.
- **Concrete fix:** Insert a three-observation example. Write the centered
  deviations as \(d_1,d_2,d_3\), show that \(d_3=-(d_1+d_2)\), and then return to
  the projection statement for general \(n\). Link directly to the Student-t
  construction where this \(n-1\) enters the denominator.

### P5. Add concept-retrieval links on the two isolated pages

- **Files and locations:** `foundations/independence.qmd`, at “Why the
  characterizations are equivalent” and its final paragraph; and
  `random-variables-and-distributions/hypergeometric-distribution.qmd`, in the
  opening contrast with binomial sampling and the final forward route.
- **Weak point:** Neither page contains an internal QMD link. The independence
  page reuses conditional probability and factorization without linking to their
  canonical treatments. The hypergeometric page contrasts sampling with and
  without replacement without linking to the binomial page.
- **Pedagogical risk:** A student who has forgotten which assumption licenses the
  product or why without-replacement draws are dependent has no immediate route
  back to the explanation.
- **Concrete fix:** Link the conditional criterion to
  `conditional-probability.qmd`, the product criterion to
  `probability-factorization.qmd`, and the chapter transition to
  `../random-variables-and-distributions/why-random-variables.qmd`. Link the
  hypergeometric opening to `binomial-distribution.qmd` and its finite-population
  correction to the later sampling discussion in
  `../statistical-inference/populations-and-samples.qmd`.

### P6. Stage the exponential-family derivation

- **File and location:** `regression-models/exponential-family.qmd`, from the
  normalizing integral through the second derivative, and the family table.
- **Weak point:** The page moves from one abstract density with respect to
  \(d\nu(y)\) to differentiation under the integral and then to a table of three
  families. Bernoulli is derived, but the role of the carrier term and dispersion
  parameter remains abstract for the other rows.
- **Pedagogical risk:** Students may be able to differentiate \(b(\theta)\) while
  remaining unable to place a familiar PMF into the template. The notation may
  consequently feel like classification for its own sake.
- **Concrete fix:** Add a “map one distribution” subsection for Poisson. Starting
  from \(e^{-\lambda}\lambda^y/y!\), substitute \(\theta=\log\lambda\) and label
  \(b(\theta)=e^\theta\), \(a(\phi)=1\), and \(c(y)=-\log(y!)\). Then compute
  \(b'\) and \(b''\) numerically at one fitted Nettle mean. Label the general
  differentiation as a derivation under a regularity condition, and tell students
  that the table is a cross-check, not a new set of formulas to memorize.

### P7. Work one observation through the ordered-beta likelihood

- **File and location:** `regression-models/ordered-beta-regression.qmd`, after
  the piecewise likelihood and before the optimizer.
- **Weak point:** The three-region likelihood is symbolically complete, but no
  actual MegaNegRaising response is carried through \(\eta_i\), the two cutpoints,
  the region probability, and the final likelihood contribution.
- **Pedagogical risk:** The shared-location assumption is the page's substantive
  point. Without a worked row, students may not see that the same \(\eta_i\)
  governs both endpoint selection and the interior beta mean.
- **Concrete fix:** Choose one retained row and one fitted parameter vector.
  Calculate \(p_{0i}\), \(p_{mi}\), \(p_{1i}\), and \(\mu_i\). Show the
  contribution for an exact endpoint and for an interior response with the same
  predictors. Follow with a small table showing how a positive shift in \(\eta\)
  changes all four quantities. Split the current long run into “Three region
  probabilities,” “Interior density,” “One observed contribution,” and “Fitting
  and checking.”

### P8. State the fitted Poisson result in prose

- **File and location:** `regression-models/poisson-regression-example.qmd`, after
  `nettle-rate-ratio-uncertainty` and before “The mismatch changes the
  coefficient.”
- **Weak point:** The code prints the rate ratio and interval, but the prose gives
  only their abstract interpretation.
- **Pedagogical risk:** Students must read an R data frame and supply its unit and
  conditioning statement themselves. That makes the worked application less
  worked than the conceptual pages that precede it.
- **Concrete fix:** Add a sentence with the rendered estimate and interval: “For
  one additional month of mean growing season, the fitted language rate per
  square kilometer is multiplied by …, with a row-independent 95% Wald interval
  of ….” Then use two observed MGS values at one common area to calculate two
  expected counts and their ratio. End by restating why this is not a causal
  climate effect.

### P9. Repair and show the sufficient-statistics substitution

- **File and location:** `regression-models/sufficient-statistics.qmd`, the
  sentence “For these data, R computes \(n={}\) ….”
- **Weak point:** The literal `n={}` and `\sum_i y_i={}` appear before inline R
  values. The page then moves directly from the factorization to the claim that
  every arrangement has the same likelihood.
- **Pedagogical risk:** The malformed notation distracts at the exact point where
  the abstract factorization theorem is supposed to meet the observed data.
- **Concrete fix:** Render the values inside complete expressions, for instance
  `\(n=`r n`\)` and `\(s=\sum_i y_i=`r s`\)`. Substitute them into
  \(\pi^s(1-\pi)^{n-s}\), and show two four-row sequences with the same count
  before showing why a predictor makes their likelihoods differ.

### P10. Put an arithmetic example before the WAIC cumulant argument

- **File and location:** `model-criticism-and-prediction/waic.qmd`, between “The
  pointwise optimism correction” and “Why posterior variance corrects optimism.”
- **Weak point:** The page defines lppd and \(p_{\mathrm{waic}}\), then immediately
  motivates the correction with a cumulant-generating-function expansion.
- **Pedagogical risk:** The expansion is mathematically appropriate but does not
  first establish what varies across draws for one observation. Students may
  confuse variance across posterior draws with variance across data rows despite
  the later warning.
- **Concrete fix:** For one Provo position and three selected posterior draws,
  display the three log likelihoods, exponentiate and average them for lppd,
  compute their sample variance, and subtract it. Then name the indices: \(i\)
  stays fixed while \(s\) varies. Retain the cumulant expansion as the explanation
  of why this arithmetic is a second-order approximation.

### P11. Add one complete numerical EM iteration

- **File and location:** `latent-structure/expectation-maximization.qmd`, between
  “The maximization step” and “Deriving the maximization updates.”
- **Weak point:** The page derives responsibilities and weighted updates, then
  moves to a full diagonal-covariance acoustic implementation. It verifies one
  fitted component later, but students never see one small E-step and M-step from
  start to finish.
- **Pedagogical risk:** The alternation can remain procedural: “software computes
  responsibilities, then software updates parameters.” The distinction between
  a hard label, an expected indicator, and an effective component count is easier
  to learn from arithmetic than from the full matrix.
- **Concrete fix:** Use two one-dimensional observations and two components with
  declared starting weights, means, and variances. Calculate both normalized
  responsibility pairs, check that each row sums to one, compute \(N_1,N_2\),
  and update the weights and means. Then point to the empirical code objects that
  perform the same operations. Keep the full covariance derivation afterward.

### P12. Label the Eckart--Young argument as a proof sketch or supply the missing step

- **File and location:** `factorization/singular-value-decomposition.qmd`, “Why
  truncation is the best rank-\(K\) approximation.”
- **Weak point:** The page correctly shows orthogonality of the singular terms and
  the residual error of truncated SVD. It then states that a rank-\(K\) matrix can
  retain at most \(K\) independent directions and concludes global optimality.
  That last sentence does not by itself show that an arbitrary rank-\(K\) matrix
  cannot combine directions to obtain smaller Frobenius error.
- **Pedagogical risk:** Students may learn that an intuitive dimensionality
  statement is a complete proof. This matters because the page explicitly names
  the Eckart--Young result.
- **Concrete fix:** Either label the section “Why truncation is optimal: proof
  sketch” and state the missing theorem, or add the standard unitary-invariance
  argument that bounds the captured squared norm by \(\sum_{k\le K}d_k^2\).
  Preserve the existing \(2\times2\) example and state that optimality concerns
  squared reconstruction only.

### P13. Explain the status of the parameter-recovery thresholds

- **File and location:** `custom-models/parameter-recovery.qmd`, the paragraph
  beginning “The audit used medians and recovery correlations because …” and the
  following threshold table.
- **Weak point:** The page says the thresholds were prespecified, but it does not
  explain why `.25`, `.15`, `.60`, `.90`, and `.65` count as adequate for this
  design.
- **Pedagogical risk:** Students may treat preregistration as a source of validity
  for an otherwise arbitrary cutoff. Prespecification prevents outcome-dependent
  threshold selection; it does not make a threshold scientifically meaningful.
- **Concrete fix:** Call these **teaching acceptance criteria** and give the scale
  interpretation of each. Explain which error would materially change a later
  conclusion, distinguish a calibration target from a universal standard, and
  report the full replicate distribution even when the median passes. Add a
  sensitivity row showing whether a reasonable stricter threshold would change
  the pass/fail summary.

### P14. Add forward pointers at every deliberate early use

- **Files and locations:** The dependency ledger marks 44 concept uses before
  the canonical page. The highest-stakes cases are
  `random-variables-and-distributions/student-t-distribution.qmd` (sampling
  distribution, standard error, confidence interval, posterior distribution,
  and residual), the four distribution-fit pages in P3 (maximum likelihood),
  `statistical-inference/importance-sampling.qmd` and `rhat.qmd` (effective
  sample size), `regression-models/linear-regression-uncertainty.qmd` (design
  matrix), and `model-criticism-and-prediction/training-and-test-data.qmd`
  (cross-validation). The complete file-to-concept list appears below.
- **Weak point:** The local prose often gives enough context for a strong reader,
  but it does not tell a student that the named object will receive its formal
  treatment later. Some early uses, especially *residual*, also shift meaning:
  a centered deviation in a variance derivation is not yet an observed-minus-
  fitted regression residual.
- **Pedagogical risk:** A novice cannot distinguish “you should already know
  this” from “this is a preview.” That ambiguity encourages memorizing a formula
  without knowing which definition is currently licensed.
- **Concrete fix:** At the first early use, mark the term as provisional, give
  the one-clause meaning required now, and link forward. Do not call every
  centered deviation a residual before the regression definition. For the
  Student-t page, either move it after the standard-error and confidence-
  interval pages or explicitly say that it is developing the distributional
  machinery that those later pages will use.

### P15. Add link-plus-reminder retrieval blocks for later reuse

- **Files and locations:** The dependency ledger records 522 missing canonical
  backlinks across 190 pages. The most frequent concepts are independence (104
  pages), variance (77), outcome/sample space/event (62), residual (36),
  standard deviation (34), covariance (32), expectation (30), and conditional
  probability (24).
- **Weak point:** Pages often use the concept correctly and may link to an
  adjacent page, but the first substantive reuse does not point back to the
  concept's canonical treatment and retrieve the part needed now.
- **Pedagogical risk:** Students must reconstruct the prerequisite chain from
  memory or site navigation. This is especially costly when the same word has a
  nearby but different object: variance of observations versus variance of an
  estimator, empirical correlation versus a random-effect correlation,
  independence of units versus independence of chains, and residuals for a
  Gaussian response versus deviance residuals for a GLM.
- **Concrete fix:** Add a compact prerequisite-retrieval block after each page's
  opening problem. One clause per concept is enough. For instance, a mixed-model
  page can retrieve covariance as the expected product of centered variables
  and then say that the current covariance is over group-specific deviations.
  The dependency ledger supplies the minimum concepts for each page. After the
  prose repair, add a lint rule that checks for a canonical filename whenever a
  controlled concept appears outside its canonical page.

### P16. Replace generic “X is Y, not Z” contrasts with the licensing reason

- **Files and locations:** 181 instances occur on 115 pages. The largest module
  counts are 50 instances on 33 regression pages, 36 on 24 inference pages, and
  21 on six custom-model pages. Representative weak instances are
  `statistical-inference/beyond-conjugacy.qmd` (“an empirically calibrated
  teaching prior, not a confirmatory analysis”),
  `regression-models/count-overdispersion.qmd` (“a diagnosis, not a
  mechanism”), `missing-data/index.qmd` (“a sampling or coverage problem, not a
  missing cell”), and `custom-models/parameter-recovery.qmd` (“an audited model
  simulation, not a substitute for linguistic data”).
- **Weak point:** The safe label and rejected label can be swapped across many
  pages without changing the paragraph's logic. The sentence states the
  conclusion of a distinction without giving the operation, assumption, or
  derivation that produces it.
- **Pedagogical risk:** Students may learn the instructor's preferred label but
  not how to decide whether a new case belongs under that label. The pattern is
  especially unhelpful for sampling and causal caveats, where the missing piece
  is precisely the selection or assignment process.
- **Concrete fix:** Replace most instances with a positive process story. Name
  what was sampled, conditioned on, transformed, optimized, held out, or
  simulated; then derive the blocked interpretation from that fact. Preserve the
  short whitelist in the cross-cutting discussion where the direct contrast is
  the most economical way to prevent a mathematical category error.

### P17. Vary the repeated three-stage roadmap architecture

- **Files and locations:** An opening “We first…, then…, and finally…” or “This
  page first…” occurs on 114 pages, including 38 of 43 pages in
  `statistical-inference/` and 51 of 64 pages in `regression-models/`. Dense runs
  include `statistical-inference/independent-sampling.qmd` through
  `statistical-inference/chi-squared-test.qmd`, and
  `regression-models/coding-categorical-predictors.qmd` through
  `regression-models/distributional-regression.qmd`.
- **Weak point:** The content of the roadmaps is accurate, but the same
  first/then/finally shell recurs regardless of whether a page contains a long
  algorithm, one definition, or a single empirical contrast.
- **Pedagogical risk:** Repetition makes the opening prose skimmable in the wrong
  way: students learn that the paragraph merely restates the headings and stop
  using it to form a problem representation.
- **Concrete fix:** Keep explicit roadmaps on module indexes and long derivation
  pages. On atomic pages, replace the roadmap with a concrete unresolved
  question, a two-row counterexample, or the empirical mismatch that the new
  concept resolves. Do not rewrite the intentional ASW pivots *A potential worry
  is…*, *The basic idea is…*, or *The remaining question is…* merely because
  they recur; inspect whether their content does real work.

### P18. Remove repository jargon from instructional prose

- **Files and locations:** 59 uses on the 34 pages listed in the
  “Repository provenance” section above. The sharpest instance is
  `statistical-inference/predictive-distributions.qmd`, at “The actual committed
  sample removed its rows from the pinned resource.”
- **Weak point:** *Pinned* and *committed* identify repository state for a
  developer but do not name a statistical population, realized sample, or data
  transformation for a student.
- **Pedagogical risk:** The phrasing hides exactly the quantities needed for the
  hypergeometric calculation and makes a file-management property sound like a
  sampling-design property.
- **Concrete fix:** Name the release or prepared table, the row counts, and the
  operation. Keep version numbers and commit links in compact provenance
  sentences, described as the version analyzed. Add a prose lint check for
  `pinned` and `committed sample/resource/table` outside code and provenance
  callouts.

## Strict concept-dependency ledger

The ledger below is intentionally mechanical only at the **detection** stage.
Each hit was checked against the page's prose. “Forward” means that the page
uses the concept before its canonical treatment without both a forward link and
an explicit statement that fuller treatment is deferred. “Back” means that a
later page has no canonical link for the concept; the repair must also include a
brief reminder, not only a hyperlink. A page-level retrieval block may discharge
several back actions at once.

| Code | Concept | Canonical first treatment |
|---|---|---|
| EV | outcome, sample space, event | `foundations/possibilities-and-events.qmd` |
| SIG | sigma-algebra | `foundations/event-spaces.qmd` |
| CP | conditional probability | `foundations/conditional-probability.qmd` |
| IND | independence / IID | `foundations/independence.qmd` |
| RV | random variable | `random-variables-and-distributions/why-random-variables.qmd` |
| PMF/PDF/CDF | mass, density, cumulative distribution functions | the correspondingly named pages in `random-variables-and-distributions/` |
| EXP | expectation / expected value | `random-variables-and-distributions/expected-values.qmd` |
| VAR/COV | variance / covariance | `random-variables-and-distributions/variance-and-covariance.qmd` |
| SD | standard deviation | `random-variables-and-distributions/standard-deviation.qmd` |
| COR | correlation | `random-variables-and-distributions/correlation.qmd` |
| SAMP | sampling distribution | `statistical-inference/properties-of-estimators.qmd` |
| MLE | maximum likelihood | `statistical-inference/maximum-likelihood.qmd` |
| SE/CI | standard error / confidence interval | the correspondingly named pages in `statistical-inference/` |
| POST/PPD | posterior / posterior-predictive distribution | `posterior-distributions.qmd` / `predictive-distributions.qmd` |
| MC/MARKOV/ESS | Monte Carlo / Markov chain / effective sample size | the correspondingly named pages in `statistical-inference/` |
| RES/DM/LINK/DEV/RE | residual / design matrix / link / deviance / random effect | the correspondingly named pages in `regression-models/` |
| LOSS/CV | predictive loss / cross-validation | the correspondingly named pages in `model-criticism-and-prediction/` |
| PCA | principal component | `factorization/principal-component-analysis.qmd` |
| MAR | missing at random | `missing-data/missingness-mechanisms.qmd` |

### Foundations dependency actions

- `foundations/linguistic-data.qmd` — forward: IND.
- `foundations/making-sense-of-data.qmd` — forward: IND.
- `foundations/zipfs-law.qmd` — forward: CP, IND, RES.
- `foundations/event-spaces.qmd` — back: EV.
- `foundations/generating-event-spaces.qmd` — back: EV.
- `foundations/probability-measures.qmd` — back: EV, SIG.
- `foundations/probability-concepts.qmd` — forward: IND; back: EV.
- `foundations/joint-probability-of-events.qmd` — forward: PMF; back: EV.
- `foundations/conditional-probability.qmd` — back: EV.
- `foundations/probability-factorization.qmd` — forward: IND; back: EV, CP.
- `foundations/bayes-rule.qmd` — forward: RV; back: EV, CP.
- `foundations/independence.qmd` — back: EV, CP.
- No audited gap: `foundations/index.qmd`,
  `foundations/possibilities-and-events.qmd`, and `foundations/events.qmd`.

### Random-variables dependency actions

- `random-variables-and-distributions/index.qmd` — back: EV.
- `random-variables-and-distributions/defining-random-variables.qmd` — back: EV.
- `random-variables-and-distributions/discrete-random-variables.qmd` — back: EV.
- `random-variables-and-distributions/probability-mass-functions.qmd` — back: EV.
- `random-variables-and-distributions/continuous-random-variables.qmd` — back: SIG, RV.
- `random-variables-and-distributions/cumulative-distribution-functions.qmd` — back: EV.
- `random-variables-and-distributions/expected-values.qmd` — back: EV, IND.
- `random-variables-and-distributions/expectation-of-functions.qmd` — back: EV, PMF.
- `random-variables-and-distributions/linearity-of-expectation.qmd` — forward: COV; back: EV, IND, RV, PMF, EXP.
- `random-variables-and-distributions/variance-and-covariance.qmd` — back: EV, PMF.
- `random-variables-and-distributions/standard-deviation.qmd` — forward: SAMP, SE; back: EV, PMF.
- `random-variables-and-distributions/central-moments.qmd` — back: EXP.
- `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd` — back: PMF, EXP, VAR.
- `random-variables-and-distributions/bernoulli-distribution.qmd` — back: EV, IND, RV, PMF.
- `random-variables-and-distributions/binomial-distribution.qmd` — back: EV, IND, PMF, EXP, VAR, SD.
- `random-variables-and-distributions/hypergeometric-distribution.qmd` — back: IND, EXP, VAR.
- `random-variables-and-distributions/geometric-distribution.qmd` — forward: MLE; back: EV, IND, VAR.
- `random-variables-and-distributions/negative-binomial-distribution.qmd` — back: EV, IND, RV, VAR.
- `random-variables-and-distributions/poisson-distribution.qmd` — forward: MLE; back: EV, IND, VAR.
- `random-variables-and-distributions/uniform-distribution.qmd` — back: IND, CDF.
- `random-variables-and-distributions/beta-distribution.qmd` — forward: MLE; back: VAR.
- `random-variables-and-distributions/normal-distribution.qmd` — forward: MLE, RES; back: IND, VAR, SD.
- `random-variables-and-distributions/chi-squared-distribution.qmd` — forward: RES; back: IND, VAR.
- `random-variables-and-distributions/student-t-distribution.qmd` — forward: SAMP, SE, CI, POST, RES; back: IND, CDF, VAR, SD.
- `random-variables-and-distributions/inverse-transform-sampling.qmd` — back: PMF, CDF.
- `random-variables-and-distributions/random-seeds.qmd` — back: IND, PMF, SD.
- `random-variables-and-distributions/joint-probability.qmd` — back: EV, IND, PMF.
- `random-variables-and-distributions/marginal-distributions.qmd` — back: PMF, VAR.
- `random-variables-and-distributions/conditional-independence.qmd` — back: CP, IND, EXP.
- `random-variables-and-distributions/conditional-expectation.qmd` — back: EV, CP, RV, PMF, EXP, COV.
- `random-variables-and-distributions/covariance.qmd` — back: RV, EXP, COV.
- `random-variables-and-distributions/correlation.qmd` — forward: SAMP; back: IND, EXP, SD, COV.
- No audited gap: `random-variables-and-distributions/why-random-variables.qmd`,
  `random-variables-and-distributions/probability-density-functions.qmd`, and
  `random-variables-and-distributions/when-expectations-fail.qmd`.

### Statistical-inference dependency actions

- `statistical-inference/index.qmd` — forward: ESS; back: RV.
- `statistical-inference/populations-and-samples.qmd` — back: EV, IND.
- `statistical-inference/independent-sampling.qmd` — back: EV, EXP, VAR.
- `statistical-inference/pronoun-case-example.qmd` — back: IND, RV, VAR.
- `statistical-inference/maximum-likelihood.qmd` — back: EV, IND.
- `statistical-inference/poisson-maximum-likelihood.qmd` — back: IND, RV, VAR, MLE.
- `statistical-inference/properties-of-estimators.qmd` — forward: CI; back: RV, EXP, VAR.
- `statistical-inference/standard-errors.qmd` — back: IND, RV, SD.
- `statistical-inference/estimator-bias.qmd` — back: EXP, VAR.
- `statistical-inference/mean-squared-error.qmd` — back: EXP, VAR.
- `statistical-inference/confidence-intervals.qmd` — back: EV, IND, RV, SD.
- `statistical-inference/exact-binomial-intervals.qmd` — back: EV, IND, RV, CDF.
- `statistical-inference/bootstrap-confidence-intervals.qmd` — back: IND, SD, SE.
- `statistical-inference/null-hypotheses-and-test-statistics.qmd` — back: IND.
- `statistical-inference/one-sample-t-inference.qmd` — back: EV, IND, VAR, SE.
- `statistical-inference/paired-observations.qmd` — back: COR.
- `statistical-inference/paired-mean-inference.qmd` — back: IND, COV.
- `statistical-inference/independent-means.qmd` — back: IND, VAR, COV, SE.
- `statistical-inference/fishers-exact-test.qmd` — back: CP, IND, VAR.
- `statistical-inference/chi-squared-test.qmd` — forward: RES; back: SD.
- `statistical-inference/posterior-distributions.qmd` — back: CP, IND.
- `statistical-inference/posterior-summaries.qmd` — back: CP, IND, EXP, VAR, CI.
- `statistical-inference/conjugate-priors.qmd` — back: IND.
- `statistical-inference/prior-predictive-distributions.qmd` — back: EV, CP, IND, EXP, VAR.
- `statistical-inference/predictive-distributions.qmd` — back: EV, CP, IND, EXP, VAR, SAMP.
- `statistical-inference/beyond-conjugacy.qmd` — forward: MARKOV; back: EV, CP, IND, VAR, SD, COV, SAMP.
- `statistical-inference/monte-carlo-integration.qmd` — back: CP, IND, VAR, SE, POST.
- `statistical-inference/importance-sampling.qmd` — forward: ESS; back: IND, EXP.
- `statistical-inference/markov-chains.qmd` — back: CP, IND, COV, MC.
- `statistical-inference/markov-chain-monte-carlo.qmd` — back: IND, EXP, COV, POST, MARKOV.
- `statistical-inference/metropolis-hastings.qmd` — back: POST.
- `statistical-inference/hamiltonian-monte-carlo.qmd` — back: POST, MC.
- `statistical-inference/mass-matrix-geometry.qmd` — back: COV, COR.
- `statistical-inference/stan.qmd` — back: IND, COV, MC.
- `statistical-inference/checking-markov-chains.qmd` — forward: RES; back: VAR.
- `statistical-inference/rhat.qmd` — forward: ESS; back: VAR.
- `statistical-inference/autocorrelation.qmd` — back: IND.
- `statistical-inference/effective-sample-size.qmd` — back: IND, VAR, SD, MC.
- `statistical-inference/divergent-transitions.qmd` — back: COR, ESS.
- `statistical-inference/posterior-predictive-checks.qmd` — back: IND, SD.
- No audited gap: `statistical-inference/no-u-turn-sampler.qmd`,
  `statistical-inference/parameter-pair-plots.qmd`, and
  `statistical-inference/generated-quantities.qmd`.

### Regression dependency actions

- `regression-models/index.qmd` — forward: RES, LINK; back: IND, EXP, VAR.
- `regression-models/regression-models.qmd` — back: RV, EXP.
- `regression-models/simple-linear-regression.qmd` — back: IND, VAR, SE.
- `regression-models/centering-predictors.qmd` — forward: RES; back: SD.
- `regression-models/response-transformations.qmd` — forward: RES; back: EXP, VAR.
- `regression-models/frequentist-linear-regression.qmd` — forward: RES; back: IND, VAR.
- `regression-models/linear-regression-uncertainty.qmd` — forward: RES, DM; back: IND, VAR, COV.
- `regression-models/checking-linear-regression.qmd` — back: RES.
- `regression-models/leverage-and-influence.qmd` — back: RES.
- `regression-models/influence.qmd` — back: VAR, POST, RES.
- `regression-models/bayesian-linear-regression.qmd` — back: IND, VAR, COV, MC, RES.
- `regression-models/multiple-regression.qmd` — back: IND.
- `regression-models/coding-categorical-predictors.qmd` — back: RES.
- `regression-models/sum-coding.qmd` — back: DM.
- `regression-models/helmert-coding.qmd` — back: IND.
- `regression-models/correlated-predictors.qmd` — back: IND, VAR, COR, RES.
- `regression-models/variance-inflation-factors.qmd` — back: IND, VAR, SE, RES.
- `regression-models/ridge-regression.qmd` — forward: LOSS; back: EV, IND, VAR, SE.
- `regression-models/residualizing-a-predictor.qmd` — back: VAR, RES.
- `regression-models/heteroscedasticity.qmd` — back: VAR, SD, COV, SE, RES.
- `regression-models/distributional-regression.qmd` — back: IND, VAR, SD, RES.
- `regression-models/why-generalized-linear-models.qmd` — back: EV, CP, IND, VAR, SAMP, RES.
- `regression-models/generalized-linear-models.qmd` — back: CP, IND, RV, VAR, SE.
- `regression-models/exponential-family.qmd` — back: PDF, EXP, VAR.
- `regression-models/sufficient-statistics.qmd` — back: IND, PMF.
- `regression-models/deviance.qmd` — back: EV, IND, RES.
- `regression-models/logistic-regression.qmd` — back: IND, SE.
- `regression-models/logistic-regression-example.qmd` — back: IND.
- `regression-models/logistic-regression-with-multiple-predictors.qmd` — back: IND.
- `regression-models/deviance-residuals.qmd` — back: EV, IND, SD, RES.
- `regression-models/ordinal-regression.qmd` — back: CDF, VAR.
- `regression-models/poisson-regression.qmd` — back: IND, VAR.
- `regression-models/poisson-regression-example.qmd` — back: IND, VAR.
- `regression-models/count-overdispersion.qmd` — forward: RE; back: IND, VAR.
- `regression-models/quasi-poisson.qmd` — forward: RE; back: PMF, VAR, COV.
- `regression-models/negative-binomial-regression.qmd` — back: IND, EXP, VAR, RES.
- `regression-models/bounded-responses.qmd` — back: VAR, SD, RES.
- `regression-models/why-not-beta-sliders.qmd` — back: EV, PDF.
- `regression-models/ordered-beta-regression.qmd` — back: CDF, VAR, MLE.
- `regression-models/structured-data.qmd` — back: IND, RES.
- `regression-models/fixed-and-random-effects.qmd` — back: IND, VAR, SD, COV, RES.
- `regression-models/random-effects.qmd` — back: VAR, SD, RES.
- `regression-models/random-intercepts.qmd` — back: IND, COV, RES.
- `regression-models/intraclass-correlation.qmd` — back: IND, VAR, SD, COV, COR, RES, RE.
- `regression-models/random-effect-estimates.qmd` — back: VAR, SD, COV.
- `regression-models/random-slopes.qmd` — back: SD, COV, RE.
- `regression-models/random-effect-correlations.qmd` — back: IND, VAR, SD, COV, COR.
- `regression-models/singular-fits.qmd` — back: VAR, SD, COV, COR, RES, RE.
- `regression-models/generalized-linear-mixed-models.qmd` — back: EV, CP, IND, VAR, COV, RE.
- `regression-models/ordinal-mixed-models.qmd` — back: EV, RE.
- `regression-models/aspectual-similarity-example.qmd` — back: CP, IND, RE.
- `regression-models/laplace-approximation.qmd` — back: SD, COV, RE.
- `regression-models/poisson-mixed-models.qmd` — back: CP, VAR.
- `regression-models/overdispersion-and-random-effects.qmd` — back: IND, EXP, RES, RE.
- No audited gap: `regression-models/coefficient-of-determination.qmd`,
  `regression-models/residuals.qmd`, `regression-models/design-matrices.qmd`,
  `regression-models/inverse-helmert-coding.qmd`,
  `regression-models/interactions.qmd`, `regression-models/link-functions.qmd`,
  `regression-models/iteratively-reweighted-least-squares.qmd`,
  `regression-models/odds-and-log-odds.qmd`,
  `regression-models/exposure-offsets.qmd`, and
  `regression-models/zero-inflated-counts.qmd`.

### Model-criticism dependency actions

- `model-criticism-and-prediction/index.qmd` — back: IND, VAR, RES.
- `model-criticism-and-prediction/prediction-targets.qmd` — back: IND, SD.
- `model-criticism-and-prediction/training-and-test-data.qmd` — forward: CV; back: EV, SD, COR, SE.
- `model-criticism-and-prediction/predictive-loss.qmd` — back: CDF, EXP, VAR.
- `model-criticism-and-prediction/bias-variance-tradeoff.qmd` — back: IND, VAR, MC, RES.
- `model-criticism-and-prediction/cross-validation.qmd` — back: IND, VAR.
- `model-criticism-and-prediction/grouped-cross-validation.qmd` — back: IND, CI.
- `model-criticism-and-prediction/comparing-predictive-loss.qmd` — back: EV, CP, MC.
- `model-criticism-and-prediction/likelihood-ratio-tests.qmd` — forward: RE; back: IND, VAR, RES, CV.
- `model-criticism-and-prediction/information-criteria.qmd` — back: IND, EXP, MLE, RES.
- `model-criticism-and-prediction/leave-one-out-cross-validation.qmd` — back: IND, VAR, SD, COV, RES, DM, CV.
- `model-criticism-and-prediction/psis-loo.qmd` — back: IND, VAR, MC, MARKOV, ESS.
- `model-criticism-and-prediction/waic.qmd` — back: IND, VAR, PPD, DEV.
- Every page in this module has at least one audited dependency action.

### Experimental-design dependency actions

- `experimental-design/index.qmd` — back: EV.
- `experimental-design/units-of-assignment.qmd` — back: EV, IND.
- `experimental-design/random-assignment.qmd` — back: EV, IND.
- `experimental-design/within-participant-designs.qmd` — back: SD, SE.
- `experimental-design/between-participant-designs.qmd` — back: EV.
- `experimental-design/counterbalancing.qmd` — back: IND.
- `experimental-design/exclusion-rules.qmd` — back: EV, VAR.
- `experimental-design/power-by-simulation.qmd` — back: EV, IND, VAR, SD, COV, SE, MC, RES.
- Every page in this module has at least one audited dependency action.

### Latent-structure dependency actions

- `latent-structure/index.qmd` — back: EV, RV, EXP.
- `latent-structure/representing-objects.qmd` — back: IND, COV.
- `latent-structure/distance-and-scaling.qmd` — back: IND, SD.
- `latent-structure/unsupervised-validation.qmd` — back: SD, SE.
- `latent-structure/gaussian-mixtures.qmd` — back: IND, VAR, COV, POST.
- `latent-structure/posterior-membership.qmd` — back: CP, EXP, COV, POST.
- `latent-structure/expectation-maximization.qmd` — back: CP, EXP, VAR, COV, RES.
- `latent-structure/choosing-a-mixture.qmd` — back: IND, COV.
- `latent-structure/validating-a-mixture.qmd` — back: CP, IND, SE.
- No audited gap: `latent-structure/k-means.qmd`,
  `latent-structure/within-cluster-loss.qmd`, and
  `latent-structure/silhouette-scores.qmd`.

### Factorization dependency actions

- `factorization/index.qmd` — back: VAR, COV.
- `factorization/centering-and-scaling.qmd` — forward: PCA; back: EV, VAR.
- `factorization/rank-one-structure.qmd` — back: IND, RES.
- `factorization/singular-value-decomposition.qmd` — back: IND, RES.
- `factorization/principal-component-analysis.qmd` — back: VAR, COV.
- `factorization/scores-and-loadings.qmd` — back: IND.
- `factorization/reconstruction.qmd` — back: RES.
- `factorization/choosing-components.qmd` — back: VAR, PCA.
- `factorization/valex-megaacceptability.qmd` — back: EV, IND, RES, CV, PCA.
- No audited gap: `factorization/data-matrices.qmd`.

### Missing-data dependency actions

- `missing-data/index.qmd` — back: EV, PCA.
- `missing-data/missingness-patterns.qmd` — back: EV, IND.
- `missing-data/missingness-mechanisms.qmd` — back: EV, CP, RES, DEV.
- `missing-data/complete-case-analysis.qmd` — back: IND, PCA.
- `missing-data/validating-imputation.qmd` — back: SAMP, CI, RES, PCA.
- No audited gap: `missing-data/pca-imputation.qmd`.

### Custom-model dependency actions

- `custom-models/index.qmd` — back: EV, MC, MARKOV.
- `custom-models/generative-stories.qmd` — back: EV, IND.
- `custom-models/writing-a-joint-model.qmd` — back: IND, VAR, SD.
- `custom-models/parameter-recovery.qmd` — back: EV, COR, CI, MC, ESS.
- `custom-models/annotations-as-measurements.qmd` — back: EV, IND, RES.
- `custom-models/annotator-effects.qmd` — back: CP, IND.
- `custom-models/uds-measurement-model.qmd` — back: EV, IND, SD, COR, ESS.
- `custom-models/gated-annotations.qmd` — back: EV, EXP.
- Every page in this module has at least one audited dependency action.

## Label-versus-overclaim structure ledger

Counts in parentheses are the copular comma-*not* candidates on that page. This
is a revision queue, not an instruction to delete every contrast; use the P16
test and preserve the whitelisted mathematical distinctions.

- **Foundations:** `generating-event-spaces.qmd` (1), `independence.qmd` (1),
  `joint-probability-of-events.qmd` (1), `linguistic-data.qmd` (2),
  `probability-concepts.qmd` (1), `probability-factorization.qmd` (1),
  `zipfs-law.qmd` (1).
- **Random variables and distributions:**
  `bernoulli-and-categorical-distributions.qmd` (1),
  `binomial-distribution.qmd` (1), `conditional-independence.qmd` (1),
  `continuous-random-variables.qmd` (1), `geometric-distribution.qmd` (1),
  `hypergeometric-distribution.qmd` (2), `inverse-transform-sampling.qmd` (1),
  `poisson-distribution.qmd` (1), `probability-density-functions.qmd` (3),
  `standard-deviation.qmd` (1), `uniform-distribution.qmd` (1), and
  `why-random-variables.qmd` (1).
- **Statistical inference:** `autocorrelation.qmd` (1),
  `beyond-conjugacy.qmd` (5), `bootstrap-confidence-intervals.qmd` (1),
  `checking-markov-chains.qmd` (1), `confidence-intervals.qmd` (1),
  `conjugate-priors.qmd` (2), `divergent-transitions.qmd` (1),
  `effective-sample-size.qmd` (1), `estimator-bias.qmd` (1),
  `exact-binomial-intervals.qmd` (1), `fishers-exact-test.qmd` (2),
  `generated-quantities.qmd` (1), `importance-sampling.qmd` (1),
  `independent-sampling.qmd` (2), `metropolis-hastings.qmd` (1),
  `no-u-turn-sampler.qmd` (2), `null-hypotheses-and-test-statistics.qmd` (1),
  `paired-mean-inference.qmd` (1), `paired-observations.qmd` (2),
  `posterior-distributions.qmd` (4), `predictive-distributions.qmd` (1),
  `prior-predictive-distributions.qmd` (1), `rhat.qmd` (1), and `stan.qmd` (1).
- **Regression:** `aspectual-similarity-example.qmd` (1),
  `bayesian-linear-regression.qmd` (1), `bounded-responses.qmd` (3),
  `checking-linear-regression.qmd` (2), `coding-categorical-predictors.qmd` (2),
  `coefficient-of-determination.qmd` (1), `count-overdispersion.qmd` (1),
  `deviance-residuals.qmd` (1), `exposure-offsets.qmd` (1),
  `generalized-linear-mixed-models.qmd` (1), `generalized-linear-models.qmd` (1),
  `heteroscedasticity.qmd` (1), `influence.qmd` (1),
  `iteratively-reweighted-least-squares.qmd` (2), `laplace-approximation.qmd` (1),
  `link-functions.qmd` (1), `logistic-regression-with-multiple-predictors.qmd` (1),
  `logistic-regression.qmd` (2), `multiple-regression.qmd` (3),
  `odds-and-log-odds.qmd` (1), `ordered-beta-regression.qmd` (2),
  `ordinal-mixed-models.qmd` (2), `ordinal-regression.qmd` (3),
  `overdispersion-and-random-effects.qmd` (1), `poisson-mixed-models.qmd` (5),
  `random-effect-correlations.qmd` (2), `random-effects.qmd` (1),
  `random-intercepts.qmd` (1), `regression-models.qmd` (1),
  `singular-fits.qmd` (1), `structured-data.qmd` (1),
  `why-not-beta-sliders.qmd` (1), and `zero-inflated-counts.qmd` (1).
- **Model criticism and prediction:** `bias-variance-tradeoff.qmd` (1),
  `comparing-predictive-loss.qmd` (3), `cross-validation.qmd` (1),
  `grouped-cross-validation.qmd` (1), `information-criteria.qmd` (1),
  `leave-one-out-cross-validation.qmd` (2), `likelihood-ratio-tests.qmd` (2),
  `prediction-targets.qmd` (1), and `predictive-loss.qmd` (1).
- **Experimental design:** `exclusion-rules.qmd` (1),
  `power-by-simulation.qmd` (3), `random-assignment.qmd` (1),
  `units-of-assignment.qmd` (2), and `within-participant-designs.qmd` (1).
- **Latent structure:** `distance-and-scaling.qmd` (1),
  `expectation-maximization.qmd` (1), `gaussian-mixtures.qmd` (1),
  `posterior-membership.qmd` (1), `representing-objects.qmd` (2),
  `silhouette-scores.qmd` (2), `unsupervised-validation.qmd` (1), and
  `validating-a-mixture.qmd` (2).
- **Factorization:** `choosing-components.qmd` (1), `data-matrices.qmd` (1),
  `index.qmd` (3), `principal-component-analysis.qmd` (1),
  `rank-one-structure.qmd` (1), and `valex-megaacceptability.qmd` (2).
- **Missing data:** `complete-case-analysis.qmd` (3), `index.qmd` (2),
  `missingness-mechanisms.qmd` (1), `pca-imputation.qmd` (2), and
  `validating-imputation.qmd` (1).
- **Custom models:** `annotations-as-measurements.qmd` (3),
  `annotator-effects.qmd` (1), `index.qmd` (3), `parameter-recovery.qmd` (4),
  `uds-measurement-model.qmd` (5), and `writing-a-joint-model.qmd` (5).

## Page-by-page ledger

### Foundations

- `foundations/bayes-rule.qmd` — no material issue.
- `foundations/conditional-probability.qmd` — no material issue.
- `foundations/event-spaces.qmd` — no material issue.
- `foundations/events.qmd` — no material issue.
- `foundations/generating-event-spaces.qmd` — no material issue.
- `foundations/independence.qmd` — action: P5.
- `foundations/index.qmd` — no material issue.
- `foundations/joint-probability-of-events.qmd` — no material issue.
- `foundations/linguistic-data.qmd` — no material issue.
- `foundations/making-sense-of-data.qmd` — no material issue.
- `foundations/possibilities-and-events.qmd` — no material issue.
- `foundations/probability-concepts.qmd` — no material issue.
- `foundations/probability-factorization.qmd` — no material issue.
- `foundations/probability-measures.qmd` — no material issue.
- `foundations/zipfs-law.qmd` — no material issue.

### Random variables and distributions

- `random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd` — no additional page-specific issue.
- `random-variables-and-distributions/bernoulli-distribution.qmd` — no material issue.
- `random-variables-and-distributions/beta-distribution.qmd` — action: P3.
- `random-variables-and-distributions/binomial-distribution.qmd` — no material issue.
- `random-variables-and-distributions/central-moments.qmd` — no material issue.
- `random-variables-and-distributions/chi-squared-distribution.qmd` — action: P4.
- `random-variables-and-distributions/conditional-expectation.qmd` — no material issue.
- `random-variables-and-distributions/conditional-independence.qmd` — no material issue.
- `random-variables-and-distributions/continuous-random-variables.qmd` — no material issue.
- `random-variables-and-distributions/correlation.qmd` — no material issue.
- `random-variables-and-distributions/covariance.qmd` — no material issue.
- `random-variables-and-distributions/cumulative-distribution-functions.qmd` — no material issue.
- `random-variables-and-distributions/defining-random-variables.qmd` — no material issue.
- `random-variables-and-distributions/discrete-random-variables.qmd` — no material issue.
- `random-variables-and-distributions/expectation-of-functions.qmd` — no material issue.
- `random-variables-and-distributions/expected-values.qmd` — no material issue.
- `random-variables-and-distributions/geometric-distribution.qmd` — action: P3.
- `random-variables-and-distributions/hypergeometric-distribution.qmd` — action: P5.
- `random-variables-and-distributions/index.qmd` — no material issue.
- `random-variables-and-distributions/inverse-transform-sampling.qmd` — no material issue.
- `random-variables-and-distributions/joint-probability.qmd` — no material issue.
- `random-variables-and-distributions/linearity-of-expectation.qmd` — no material issue.
- `random-variables-and-distributions/marginal-distributions.qmd` — no material issue.
- `random-variables-and-distributions/negative-binomial-distribution.qmd` — no additional page-specific issue.
- `random-variables-and-distributions/normal-distribution.qmd` — action: P3.
- `random-variables-and-distributions/poisson-distribution.qmd` — action: P3.
- `random-variables-and-distributions/probability-density-functions.qmd` — no material issue.
- `random-variables-and-distributions/probability-mass-functions.qmd` — no material issue.
- `random-variables-and-distributions/random-seeds.qmd` — no material issue.
- `random-variables-and-distributions/standard-deviation.qmd` — no material issue.
- `random-variables-and-distributions/student-t-distribution.qmd` — no material issue.
- `random-variables-and-distributions/uniform-distribution.qmd` — no material issue.
- `random-variables-and-distributions/variance-and-covariance.qmd` — no material issue.
- `random-variables-and-distributions/when-expectations-fail.qmd` — no material issue.
- `random-variables-and-distributions/why-random-variables.qmd` — no material issue.

### Statistical inference

- `statistical-inference/autocorrelation.qmd` — no material issue.
- `statistical-inference/beyond-conjugacy.qmd` — no material issue.
- `statistical-inference/bootstrap-confidence-intervals.qmd` — no material issue.
- `statistical-inference/checking-markov-chains.qmd` — no material issue.
- `statistical-inference/chi-squared-test.qmd` — no material issue.
- `statistical-inference/confidence-intervals.qmd` — no material issue.
- `statistical-inference/conjugate-priors.qmd` — no material issue.
- `statistical-inference/divergent-transitions.qmd` — no material issue.
- `statistical-inference/effective-sample-size.qmd` — no material issue.
- `statistical-inference/estimator-bias.qmd` — no material issue.
- `statistical-inference/exact-binomial-intervals.qmd` — no material issue.
- `statistical-inference/fishers-exact-test.qmd` — no material issue.
- `statistical-inference/generated-quantities.qmd` — no material issue.
- `statistical-inference/hamiltonian-monte-carlo.qmd` — no material issue.
- `statistical-inference/importance-sampling.qmd` — no material issue.
- `statistical-inference/independent-means.qmd` — no material issue.
- `statistical-inference/independent-sampling.qmd` — no material issue.
- `statistical-inference/index.qmd` — no material issue.
- `statistical-inference/markov-chain-monte-carlo.qmd` — no material issue.
- `statistical-inference/markov-chains.qmd` — no material issue.
- `statistical-inference/mass-matrix-geometry.qmd` — no material issue.
- `statistical-inference/maximum-likelihood.qmd` — no material issue.
- `statistical-inference/mean-squared-error.qmd` — no material issue.
- `statistical-inference/metropolis-hastings.qmd` — no material issue.
- `statistical-inference/monte-carlo-integration.qmd` — no material issue.
- `statistical-inference/no-u-turn-sampler.qmd` — no material issue.
- `statistical-inference/null-hypotheses-and-test-statistics.qmd` — no material issue.
- `statistical-inference/one-sample-t-inference.qmd` — no material issue.
- `statistical-inference/paired-mean-inference.qmd` — no material issue.
- `statistical-inference/paired-observations.qmd` — no material issue.
- `statistical-inference/parameter-pair-plots.qmd` — no material issue.
- `statistical-inference/poisson-maximum-likelihood.qmd` — no material issue.
- `statistical-inference/populations-and-samples.qmd` — no material issue.
- `statistical-inference/posterior-distributions.qmd` — no material issue.
- `statistical-inference/posterior-predictive-checks.qmd` — no material issue.
- `statistical-inference/posterior-summaries.qmd` — no material issue.
- `statistical-inference/predictive-distributions.qmd` — no material issue.
- `statistical-inference/prior-predictive-distributions.qmd` — no material issue.
- `statistical-inference/pronoun-case-example.qmd` — no material issue.
- `statistical-inference/properties-of-estimators.qmd` — no material issue.
- `statistical-inference/rhat.qmd` — no material issue.
- `statistical-inference/stan.qmd` — no material issue.
- `statistical-inference/standard-errors.qmd` — no material issue.

### Regression models

- `regression-models/aspectual-similarity-example.qmd` — no material issue.
- `regression-models/bayesian-linear-regression.qmd` — no material issue.
- `regression-models/bounded-responses.qmd` — no material issue.
- `regression-models/centering-predictors.qmd` — no material issue.
- `regression-models/checking-linear-regression.qmd` — no material issue.
- `regression-models/coding-categorical-predictors.qmd` — no material issue.
- `regression-models/coefficient-of-determination.qmd` — no material issue.
- `regression-models/correlated-predictors.qmd` — no material issue.
- `regression-models/count-overdispersion.qmd` — action: P1.
- `regression-models/design-matrices.qmd` — no material issue.
- `regression-models/deviance-residuals.qmd` — no material issue.
- `regression-models/deviance.qmd` — no material issue.
- `regression-models/distributional-regression.qmd` — no material issue.
- `regression-models/exponential-family.qmd` — action: P6.
- `regression-models/exposure-offsets.qmd` — no material issue.
- `regression-models/fixed-and-random-effects.qmd` — no material issue.
- `regression-models/frequentist-linear-regression.qmd` — no material issue.
- `regression-models/generalized-linear-mixed-models.qmd` — no material issue.
- `regression-models/generalized-linear-models.qmd` — no material issue.
- `regression-models/helmert-coding.qmd` — no material issue.
- `regression-models/heteroscedasticity.qmd` — no material issue.
- `regression-models/index.qmd` — no material issue.
- `regression-models/influence.qmd` — no material issue.
- `regression-models/interactions.qmd` — no material issue.
- `regression-models/intraclass-correlation.qmd` — no material issue.
- `regression-models/inverse-helmert-coding.qmd` — no material issue.
- `regression-models/iteratively-reweighted-least-squares.qmd` — no material issue.
- `regression-models/laplace-approximation.qmd` — no material issue.
- `regression-models/leverage-and-influence.qmd` — no material issue.
- `regression-models/linear-regression-uncertainty.qmd` — no material issue.
- `regression-models/link-functions.qmd` — no material issue.
- `regression-models/logistic-regression-example.qmd` — no material issue.
- `regression-models/logistic-regression-with-multiple-predictors.qmd` — no material issue.
- `regression-models/logistic-regression.qmd` — no material issue.
- `regression-models/multiple-regression.qmd` — no material issue.
- `regression-models/negative-binomial-regression.qmd` — no material issue.
- `regression-models/odds-and-log-odds.qmd` — no material issue.
- `regression-models/ordered-beta-regression.qmd` — action: P7.
- `regression-models/ordinal-mixed-models.qmd` — no material issue.
- `regression-models/ordinal-regression.qmd` — no material issue.
- `regression-models/overdispersion-and-random-effects.qmd` — action: P2.
- `regression-models/poisson-mixed-models.qmd` — no material issue.
- `regression-models/poisson-regression-example.qmd` — action: P8.
- `regression-models/poisson-regression.qmd` — no material issue.
- `regression-models/quasi-poisson.qmd` — no material issue.
- `regression-models/random-effect-correlations.qmd` — no material issue.
- `regression-models/random-effect-estimates.qmd` — no material issue.
- `regression-models/random-effects.qmd` — no material issue.
- `regression-models/random-intercepts.qmd` — no material issue.
- `regression-models/random-slopes.qmd` — no material issue.
- `regression-models/regression-models.qmd` — no material issue.
- `regression-models/residualizing-a-predictor.qmd` — no material issue.
- `regression-models/residuals.qmd` — no material issue.
- `regression-models/response-transformations.qmd` — no material issue.
- `regression-models/ridge-regression.qmd` — no material issue.
- `regression-models/simple-linear-regression.qmd` — no material issue.
- `regression-models/singular-fits.qmd` — no material issue.
- `regression-models/structured-data.qmd` — no material issue.
- `regression-models/sufficient-statistics.qmd` — action: P9.
- `regression-models/sum-coding.qmd` — no material issue.
- `regression-models/variance-inflation-factors.qmd` — no material issue.
- `regression-models/why-generalized-linear-models.qmd` — no material issue.
- `regression-models/why-not-beta-sliders.qmd` — no material issue.
- `regression-models/zero-inflated-counts.qmd` — no material issue.

### Model criticism and prediction

- `model-criticism-and-prediction/bias-variance-tradeoff.qmd` — no material issue.
- `model-criticism-and-prediction/comparing-predictive-loss.qmd` — no material issue.
- `model-criticism-and-prediction/cross-validation.qmd` — no material issue.
- `model-criticism-and-prediction/grouped-cross-validation.qmd` — no material issue.
- `model-criticism-and-prediction/index.qmd` — no material issue.
- `model-criticism-and-prediction/information-criteria.qmd` — no material issue.
- `model-criticism-and-prediction/leave-one-out-cross-validation.qmd` — no material issue.
- `model-criticism-and-prediction/likelihood-ratio-tests.qmd` — no material issue.
- `model-criticism-and-prediction/prediction-targets.qmd` — no material issue.
- `model-criticism-and-prediction/predictive-loss.qmd` — no material issue.
- `model-criticism-and-prediction/psis-loo.qmd` — no material issue.
- `model-criticism-and-prediction/training-and-test-data.qmd` — no material issue.
- `model-criticism-and-prediction/waic.qmd` — action: P10.

### Experimental design

- `experimental-design/between-participant-designs.qmd` — no material issue.
- `experimental-design/counterbalancing.qmd` — no material issue.
- `experimental-design/exclusion-rules.qmd` — no material issue.
- `experimental-design/index.qmd` — no material issue.
- `experimental-design/power-by-simulation.qmd` — no material issue.
- `experimental-design/random-assignment.qmd` — no material issue.
- `experimental-design/units-of-assignment.qmd` — no material issue.
- `experimental-design/within-participant-designs.qmd` — no material issue.

### Latent structure

- `latent-structure/choosing-a-mixture.qmd` — no material issue.
- `latent-structure/distance-and-scaling.qmd` — no material issue.
- `latent-structure/expectation-maximization.qmd` — action: P11.
- `latent-structure/gaussian-mixtures.qmd` — no material issue.
- `latent-structure/index.qmd` — no material issue.
- `latent-structure/k-means.qmd` — no material issue.
- `latent-structure/posterior-membership.qmd` — no material issue.
- `latent-structure/representing-objects.qmd` — no material issue.
- `latent-structure/silhouette-scores.qmd` — no material issue.
- `latent-structure/unsupervised-validation.qmd` — no material issue.
- `latent-structure/validating-a-mixture.qmd` — no material issue.
- `latent-structure/within-cluster-loss.qmd` — no material issue.

### Factorization

- `factorization/centering-and-scaling.qmd` — no material issue.
- `factorization/choosing-components.qmd` — no material issue.
- `factorization/data-matrices.qmd` — no material issue.
- `factorization/index.qmd` — no material issue.
- `factorization/principal-component-analysis.qmd` — no material issue.
- `factorization/rank-one-structure.qmd` — no material issue.
- `factorization/reconstruction.qmd` — no material issue.
- `factorization/scores-and-loadings.qmd` — no material issue.
- `factorization/singular-value-decomposition.qmd` — action: P12.
- `factorization/valex-megaacceptability.qmd` — no material issue.

### Missing data

- `missing-data/complete-case-analysis.qmd` — no material issue.
- `missing-data/index.qmd` — no material issue.
- `missing-data/missingness-mechanisms.qmd` — no material issue.
- `missing-data/missingness-patterns.qmd` — no material issue.
- `missing-data/pca-imputation.qmd` — no material issue.
- `missing-data/validating-imputation.qmd` — no material issue.

### Custom models

- `custom-models/annotations-as-measurements.qmd` — no material issue.
- `custom-models/annotator-effects.qmd` — no material issue.
- `custom-models/gated-annotations.qmd` — no material issue.
- `custom-models/generative-stories.qmd` — no material issue.
- `custom-models/index.qmd` — no material issue.
- `custom-models/parameter-recovery.qmd` — action: P13.
- `custom-models/uds-measurement-model.qmd` — no material issue.
- `custom-models/writing-a-joint-model.qmd` — no material issue.

## Recommended implementation sequence

First, repair P1 and P2 and render those two pages. Second, implement the P14
forward pointers, because an undefined early term cannot be repaired by a later
backlink. Third, add the P3 maximum-likelihood bridge and make its four uses
consistent. Fourth, implement the P15 prerequisite-retrieval blocks in sidebar
order, beginning with the foundations and distribution concepts that many later
pages share. Add the concept-link lint only after those prose blocks exist.

Next, implement P4, P6, P7, P10, and P11 as worked transitions; these additions
carry most of the remaining page-specific pedagogical value. Then make the
status edits in P12 and P13 and complete P5, P8, and P9. Run P16, P17, and P18
as prose batches after the mathematical additions: the new explanations may
already replace some “X is Y, not Z” slogans, while concrete data-table nouns
can be shared across neighboring pages. Preserve the identified mathematical
contrasts and ASW voice markers rather than applying a blind search-and-replace.

Finally, run the full link, lexical-dependency, jargon, and render checks, then
reread the pages in sidebar order. The acceptance test is functional: every
technical term is defined or explicitly deferred at first use; every later page
retrieves its canonical treatment and operative meaning; and every caveat gives
the positive measurement, sampling, or inferential reason that blocks the
overclaim.

## Second-pass calculus, linear-algebra, and voice audit

The first implementation pass exposed a limitation of the controlled
31-concept inventory: it found the course-wide dependencies but missed some
mathematical vocabulary that an instructor might take for granted. I therefore
ran a second page-by-page audit for calculus, linear algebra, Bayesian algebra,
statistical regularity conditions, and corpus-specific terminology. This pass
found 40 residual first-use problems. The main clusters were logarithms and
derivatives; Jacobians, Hessians, and Riemann sums; projections, inverses,
eigenvalues, singular values, and Cholesky factors; likelihood, exchangeability,
and identification; and several Provo, MALD, and PHOIBLE measures.

The revisions now give these ideas canonical homes. The main retrieval targets
are:

- `foundations/zipfs-law.qmd#likelihoods-and-logarithms` for logarithms in a
  likelihood calculation;
- `random-variables-and-distributions/expected-values.qmd#derivatives-as-local-rates-of-change`
  for derivatives as local slopes;
- `random-variables-and-distributions/variance-and-covariance.qmd#vectors-matrices-and-covariance`
  for vectors, matrix multiplication, inverses, covariance matrices, and
  quadratic forms;
- `random-variables-and-distributions/beta-distribution.qmd#density-rescaling`
  for one-dimensional change of variables and Jacobians;
- `statistical-inference/beyond-conjugacy.qmd#hessian-as-local-curvature` for
  Hessians and inverse-curvature approximations;
- `statistical-inference/posterior-distributions.qmd#exchangeability-and-iid`
  for exchangeability and its relation to IID sampling;
- `regression-models/design-matrices.qmd#projection-as-fitted-plus-residual` for
  geometric projection;
- `factorization/principal-component-analysis.qmd#eigenvectors-as-preserved-directions`
  for eigenvectors and eigenvalues; and
- `factorization/rank-one-structure.qmd#rank-one-reconstruction-picture` for
  low-rank reconstruction.

The second pass also compared the new explanations with the supplied
Clopper--Pearson and matrix Zulip posts. That comparison changed the order of
several sections. The matrix primer now proceeds from a scalar linear map to
vectors and then matrices; the chi-squared page works a three-value deviation
example before stating the theorem; the beta page shows concrete shapes before
introducing its normalizing functions; EM begins with a one-dimensional update;
the ordered-beta page works one observation before assembling the likelihood;
and the AIC and BIC discussions start with one-dimensional approximations before
introducing trace or determinant notation.

Several canonical explanations now include a small geometric figure. The
Jacobian figure shows equal log-scale widths becoming unequal positive-scale
widths; the Hessian figure connects contour width to local curvature; the matrix
figure shows a linear transformation of a grid; and the projection, eigenvector,
Cholesky, singular-fit, and SVD figures give the corresponding algebra a visible
two-dimensional case. These figures do explanatory work before the compact
notation appears. They are not decorative summaries of a derivation students
have already been asked to accept.
