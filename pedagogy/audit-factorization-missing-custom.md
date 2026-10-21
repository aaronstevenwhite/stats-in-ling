# Pedagogy audit: factorization, missing data, and custom models

This report audits all 24 `.qmd` pages directly under `factorization/`,
`missing-data/`, and `custom-models/`. It applies the following explanatory-chain
rubric:

1. motivating linguistic problem;
2. data source, unit, example observation, measure definitions, preprocessing, and
   aggregation rationale when data appear;
3. links to the first full treatment of prerequisites plus a short in-place reminder;
4. rationale and assumptions for every transformation, distribution, model, link,
   parameter, validation target, and algorithm;
5. derivation with random-versus-observed notation and no algebraic or algorithmic
   leaps;
6. a visible bridge from formula to code and output;
7. interpretation and limits;
8. misconception-oriented checks, recap, and forward link.

Severity has a narrow pedagogical meaning. **H** marks a page that cannot yet support
the intended inference without a substantial data dossier, derivation, or repair to
the model-to-estimand connection. **M** marks a page whose main chain is sound but
omits one or more important explanatory moves. **L** marks a page that needs a small
worked example, reminder, or convention note. No course-note page was edited during
this audit.

## Cross-cutting diagnosis

These modules have a strong base. They routinely distinguish observed responses from
latent quantities, preserve train--validation--test separation, state limitations,
and end with checks. The custom-model sequence is especially careful about not
treating an annotation as direct access to linguistic truth. The principal problem is
not absence of rigor. It is that the rigor is sometimes visible only after a student
already knows how the data, mathematics, and code fit together.

First, the six recurring resources need **measurement dossiers** that are concrete
enough to support the later mathematics. Each dossier should show one linguistic
object, one source record, one course-facing row, every relevant measure, and the
transformations between those representations.

- **PHOIBLE** already receives careful provenance and a good explanation of
  “not listed” versus phonological absence. It still needs one real inventory row,
  one segment-membership record, and the resulting matrix cell. The choices to retain
  segments appearing in at least 20 training inventories, sample one inventory per
  Glottocode, and construct a 15/15 macroarea split also need scientific or
  computational rationales.
- **VALEX/MegaAcceptability** needs an actual verb, two syntactic frames, the
  corresponding sentence stimuli, the response scale, one participant response, the
  within-participant normalization, and the resulting verb-by-frame cell. Without
  this chain, “frame profile” and “acceptability profile” remain formal matrix labels.
- **Jacy** needs one Japanese sentence or safe gloss, one profile identifier, the
  parse-reading count, the preferred-analysis field, and the three resulting observed
  states. Students should see why “no positive parse reading,” “readings but no
  selected analysis,” and “selected analysis” are different pipeline outcomes.
- **Hillenbrand** needs one `/hVd/` elicitation word and speaker-token row, a brief
  account of the steady-state measurement window, and definitions of F0 and F1--F3.
  The notes should say why the steady-state measures are analyzed, which contour
  measurements remain outside the matrix, and why complete-case deletion or PCA
  imputation changes the scientific target.
- **Turkish PropBank** needs one privacy-safe sentence or gloss, the predicate and
  candidate argument, the candidate role descriptions, one worker selection, and the
  adjudicated description. It also needs a linguistic definition of the teaching
  `core`/`adjunct` grouping. The retained CSV contains useful role-description rows,
  but the page does not show one.
- **UDS** needs one sentence, its predicate span or node, the exact natural-parts
  prompt, and two or three raw responses. The current “observed item” table contains
  only graph and node identifiers, so it does not yet make the item linguistically
  intelligible. If the pinned extract cannot recover sentence text safely, augment it
  from the pinned UDS graph release rather than inventing an illustration.

Second, the modules need a **choice register**. Before a long implementation, classify
each choice as (i) a mathematical consequence, (ii) a scientific design decision,
(iii) a computational approximation or default, or (iv) a display choice. The notes
currently present frequency cutoffs, split sizes, rank grids, fold counts, mask
fractions, convergence tolerances, priors, generating values, recovery thresholds,
chain lengths, `adapt_delta`, optimizers, and clipping constants with uneven
justification. Naming the class of choice would prevent a seed or plotting level from
appearing to carry the same status as a likelihood assumption.

Third, several transformations and algorithms begin one step too late. Students need
the Lagrange-multiplier step from variance maximization to the PCA eigenproblem; the
least-squares statement behind truncated SVD; the algebra from ridge regression to
singular-value shrinkage; the observed/missing-set updates and stopping rule for
iterative PCA imputation; and the full prior-times-likelihood construction of the UDS
posterior. The same rule applies to software: display a compact symbol-to-code map
before the implementation rather than asking students to infer the correspondence
from 100 or more lines of R or Stan.

Fourth, the use of squared error needs sharper scope. A centered binary PHOIBLE matrix
can be approximated by least squares as a descriptive geometry, but reconstructed
values are not automatically probabilities. `factorization/reconstruction.qmd`
clips those values and scores a Brier-type loss. That move requires a probabilistic
calibration argument or a different label for the loss. Likewise, iterative PCA
imputation supplies deterministic point reconstructions. It does not propagate
missing-value uncertainty into later analyses.

Fifth, validation targets are usually present but dispersed. Every held-out analysis
should state, before code: (i) the split or mask unit, (ii) the score-aggregation unit,
(iii) what information about a target remains available, (iv) what is re-estimated
inside each split, and (v) the population or missingness pattern to which performance
might transfer. This **validation-target specification (VTS)** is especially important
for held-out PHOIBLE cells, nested verb prediction, and artificially masked
Hillenbrand cells.

Finally, backlinks are common but often bare. A link should be followed by a
one- or two-sentence reminder of the exact prerequisite needed locally. The reminder
should say, for instance, that the Bernoulli likelihood contributes
$\pi^y(1-\pi)^{1-y}$, that a random intercept partially pools group locations under a
population distribution, or that test cells may not affect centering, scaling, rank
selection, or stopping. Students should not have to reopen an entire earlier module
to identify the one fact on which the current step depends.

## Canonical backlink targets

The following existing pages should become stable targets. Add the proposed headings
where an exact anchor does not yet exist, then use the anchor with a short local
reminder on every downstream page.

### Factorization

- PHOIBLE source, unit, and matrix-cell dossier:
  `factorization/data-matrices.qmd#phoible-measurement-dossier`.
- Row/column/cell notation:
  `factorization/data-matrices.qmd#defining-the-array-and-its-indices`.
- Centering, scaling, and training-fitted transformations:
  `factorization/centering-and-scaling.qmd#applying-a-fitted-transformation`.
- Rank-one outer products and residual structure:
  `factorization/rank-one-structure.qmd#constructing-one-outer-product`.
- Reduced SVD and truncated least-squares result:
  `factorization/singular-value-decomposition.qmd#stating-the-reduced-decomposition`
  and the proposed
  `factorization/singular-value-decomposition.qmd#why-truncation-is-the-best-rank-k-approximation`.
- PCA variance objective and SVD connection:
  `factorization/principal-component-analysis.qmd#beginning-with-variation-around-column-means`
  and `factorization/principal-component-analysis.qmd#connecting-pca-to-the-svd`.
- Score and loading conventions:
  `factorization/scores-and-loadings.qmd#scores-locate-row-objects` and
  `factorization/scores-and-loadings.qmd#loadings-describe-column-directions`.
- Partially observed row reconstruction:
  `factorization/reconstruction.qmd#reconstructing-partially-observed-inventories`.
- Train--validation--test rank selection:
  `factorization/choosing-components.qmd#separating-fitting-selection-and-evaluation`.
- VALEX/MegaAcceptability measurement dossier and nested target:
  `factorization/valex-megaacceptability.qmd#valex-megaacceptability-measurement-dossier`
  and `factorization/valex-megaacceptability.qmd#keeping-every-fitted-choice-inside-training-data`.

### Missing data

- Missing-value taxonomy:
  `missing-data/index.qmd#what-counts-as-missing`.
- Jacy measurement and pipeline dossier:
  `missing-data/missingness-patterns.qmd#jacy-measurement-dossier`.
- Observed-state construction:
  `missing-data/missingness-patterns.qmd#from-a-binary-indicator-to-three-observed-states`.
- MCAR, MAR, and MNAR definitions:
  `missing-data/missingness-mechanisms.qmd#separating-observed-and-unobserved-quantities`.
- Hillenbrand acoustic-measurement dossier:
  `missing-data/complete-case-analysis.qmd#hillenbrand-measurement-dossier`.
- Complete-case estimand and preservation conditions:
  `missing-data/complete-case-analysis.qmd#when-does-deletion-preserve-a-target`.
- Iterative PCA-imputation update:
  `missing-data/pca-imputation.qmd#defining-the-standardized-update`.
- Artificial-mask validation target:
  `missing-data/validating-imputation.qmd#what-this-validation-targets`.
- General training--test separation:
  `model-criticism-and-prediction/training-and-test-data.qmd#the-separation-rule`.

### Custom models

- UDS measurement dossier and observed process:
  `custom-models/generative-stories.qmd#uds-natural-parts-measurement-dossier` and
  `custom-models/generative-stories.qmd#stating-one-step-at-a-time`.
- Product rule and observed-pair likelihood:
  `custom-models/writing-a-joint-model.qmd#translating-steps-into-factors`.
- Recovery generator, estimands, and decision criteria:
  `custom-models/parameter-recovery.qmd#the-exact-recovery-generator-and-fitting-call`
  and `custom-models/parameter-recovery.qmd#evaluating-parameter-recovery`.
- Turkish PropBank measurement dossier and agreement target:
  `custom-models/annotations-as-measurements.qmd#turkish-propbank-measurement-dossier`
  and `custom-models/annotations-as-measurements.qmd#keeping-three-agreement-quantities-distinct`.
- Annotator-location effect and zero-sum identification:
  `custom-models/annotator-effects.qmd#adding-one-location-term` and
  `custom-models/annotator-effects.qmd#fixing-the-coordinate-system`.
- Complete UDS likelihood, priors, and posterior:
  `custom-models/uds-measurement-model.qmd#writing-the-complete-model` and the
  proposed `custom-models/uds-measurement-model.qmd#from-prior-and-likelihood-to-posterior`.
- Gated observed-data likelihood:
  `custom-models/gated-annotations.qmd#factoring-the-gate-and-follow-up-response`.
- Bernoulli/logit reminder:
  `regression-models/logistic-regression.qmd` and
  `regression-models/link-functions.qmd`.
- Crossed random effects and partial pooling:
  `regression-models/generalized-linear-mixed-models.qmd` and
  `regression-models/random-effects.qmd`.
- Exact binomial intervals:
  `statistical-inference/exact-binomial-intervals.qmd`.
- Posterior construction, prior predictive checks, Stan, chain checks, and posterior
  predictive checks: `statistical-inference/posterior-distributions.qmd`,
  `statistical-inference/prior-predictive-distributions.qmd`,
  `statistical-inference/stan.qmd`,
  `statistical-inference/checking-markov-chains.qmd`, and
  `statistical-inference/posterior-predictive-checks.qmd`.

## Page-by-page audit: factorization

| Page | Severity | Missing moves and exact additions/backlinks |
|---|---:|---|
| `factorization/index.qmd` | M | The overview names PHOIBLE and the VALEX/MegaAcceptability application, but the inventories and rating matrices remain abstract. Add a miniature running example containing one language, three segments, one verb, two frames, and two sentence judgments. Use it to distinguish an observed cell, an unobserved cell, and a derived aggregate. Link PHOIBLE to `data-matrices.qmd#phoible-measurement-dossier` and the acceptability application to `valex-megaacceptability.qmd#valex-megaacceptability-measurement-dossier`, each with a one-sentence reminder of the row and column units. End with an explicit roadmap stating which page constructs, decomposes, interprets, reconstructs, and validates the matrix. |
| `factorization/data-matrices.qmd` | M | The row/column/cell notation and the warning about “not listed” are strong. Make this the canonical PHOIBLE dossier: print one pinned CLDF inventory/segment record, define `InventoryID`, Glottocode, segment, source contribution, and macroarea, then trace that record to one $X_{ij}$. Explain why one inventory is sampled per Glottocode, what variation is discarded, why the seed is fixed, why the segment-frequency threshold is 20, and why 15 inventories per macroarea are selected. Label the threshold and balanced sample as teaching-design choices rather than properties of PHOIBLE. Link later matrix pages back here. |
| `factorization/centering-and-scaling.qmd` | L | The conceptual distinction between origin and unit is good. Add one binary-column calculation showing $\bar x_j=p_j$ and $s_j\approx\sqrt{p_j(1-p_j)}$, then standardize one 0 cell and one 1 cell by hand. State which rows determine $\bar x_j$ and $s_j$, how equal cell weighting induces frequency-sensitive column influence, and why zero-variance columns cannot be scaled. Link to `random-variables-and-distributions/standard-deviation.qmd` with a short reminder and back to the PHOIBLE dossier for cell meaning. |
| `factorization/rank-one-structure.qmd` | M | Add a $2\times3$ numeric outer product, perturb one cell, and compute the residual matrix and squared loss. Explain why a least-squares rank-one pattern is used as descriptive geometry for centered binary data and what assumption that choice does not make. Preview the best-rank result rather than presenting empirical SVD output as a software fact, then link forward to `singular-value-decomposition.qmd#why-truncation-is-the-best-rank-k-approximation`. Add a symbol-to-code table for $\mathbf u_1$, $d_1$, $\mathbf v_1$, fitted cells, and residuals. |
| `factorization/singular-value-decomposition.qmd` | M | The dimensions, orthogonality, rank-one expansion, sign indeterminacy, and empirical spectrum are well stated. Add a tiny hand-computed SVD or geometric two-dimensional example. State the optimization problem $\min_{\operatorname{rank}(B)\le K}\lVert X-B\rVert_F^2$ and explain why keeping the first $K$ singular terms solves it; students need at least the orthogonal-residual argument even if a full proof is deferred. Derive why $d_k^2$ is the sum of squares captured by term $k$, distinguish full from reduced SVD, and map `svd()` fields directly to the displayed matrices. |
| `factorization/principal-component-analysis.qmd` | M | The covariance-to-SVD identity is useful, but the move from “maximize variance” to an eigenvector is compressed. Add the unit-norm constrained objective, Lagrangian, derivative, and eigenvalue equation. Explain the $1/(n-1)$ covariance convention and why it does not change directions. Compute one row score and one explained-variance proportion by hand. Remind students that macroarea is added after fitting and thus does not define the components; link to the score/loading anchors and name post-hoc component interpretation as a hypothesis rather than a recovered linguistic category. |
| `factorization/scores-and-loadings.qmd` | L | Add one hand calculation of a row score from standardized cells and a loading vector. State the competing conventions called “loadings” in software: $V$, correlations with components, and scaled loadings such as $V D/\sqrt{n-1}$. Explain that sign changes preserve the fitted matrix and that nearby singular values can make individual directions unstable. Add a resampling or split-stability question to the misconception checks, then backlink to the PHOIBLE cell dossier and SVD sign discussion. |
| `factorization/reconstruction.qmd` | H | The held-out-cell target is important, but the page needs to name its score estimator precisely. Filling hidden standardized cells with zero and projecting onto training loadings is a one-step mean-filled projection, not the fully observed score and not an iterative missing-data optimum. Derive that update and map it to code. More seriously, truncated-SVD reconstructions of centered binary cells are unbounded real values; clipping them to $[0,1]$ does not by itself make calibrated probabilities. Either use squared reconstruction error and call it that, or introduce and validate a probabilistic low-rank Bernoulli model before using Brier loss. Justify three listed and three unlisted masked cells per row, the candidate ranks, macroarea split, clipping constant, and the implied weighting. State what information about each partly observed inventory remains available. |
| `factorization/choosing-components.qmd` | M | The fitting/selection/evaluation separation is strong. Add a VTS box listing inventory split, cell score, visible cells, fold-local transformations, and transfer target. Explain the rank grid, mask construction, loss, seed, and tie rule. Show one candidate rank moving through fit, validation, selection, refit, and final test. State that one fixed split does not measure split-to-split uncertainty and that the final test is valid only if every earlier threshold, mask rule, and candidate set was fixed without inspecting it. Backlink to reconstruction for the exact partially observed row algorithm and resolve the probability-versus-reconstruction-loss issue there. |
| `factorization/valex-megaacceptability.qmd` | H | Build the canonical VALEX/MegaAcceptability dossier before the nested code. Show one verb, its corpus counts in two linguistically glossed VALEX frames, two corresponding MegaAcceptability sentence items, the response-scale anchors, one participant response, within-participant normalization, and the aggregated verb-by-frame target. Explain why aggregation is used, what participant/item variation it discards, and which matrix cells are missing. Derive ridge from the penalized objective to $(X^\top X+\lambda I)^{-1}X^\top y$, then derive the SVD shrinkage factors used by `ridge_prediction`. State why the comparison is verb-held-out, why folds are grouped, and why all centering, rank, and $\lambda$ selection must be nested. Justify the rank/$\lambda$ grids, five outer folds, ten inner folds, seeds, and tie handling. Separate the frozen registered analysis from the pedagogical rerun so students know which output is reproduced and which merely illustrates the procedure. |

## Page-by-page audit: missing data

| Page | Severity | Missing moves and exact additions/backlinks |
|---|---:|---|
| `missing-data/index.qmd` | M | The taxonomy usefully distinguishes protocol absence, undefined quantities, failure, and dropout. Ground it before the inventory table with one Jacy parsing item and one Hillenbrand vowel token. Show the intended quantity, the recorded field, and what a blank means in each resource. Link those examples to `missingness-patterns.qmd#jacy-measurement-dossier` and `complete-case-analysis.qmd#hillenbrand-measurement-dossier`. Add a module roadmap that distinguishes description of locations, assumptions about mechanisms, deletion, deterministic reconstruction, and validation. |
| `missing-data/missingness-patterns.qmd` | M | Make this the canonical Jacy dossier. Show one Japanese sentence or safe gloss, its profile identifier, token length, positive parse-reading count, preferred-analysis field, and final availability status. Explain what a Jacy profile is, what one parse reading represents, and why zero readings differs from readings with no selected analysis. Trace one row through the binary and three-state recodes before summarizing profiles. State whether length is characters, tokens, or another unit and which preprocessing created the course table. Add a small pipeline diagram and answer at least one check with a worked row. |
| `missing-data/missingness-mechanisms.qmd` | M | The MCAR/MAR/MNAR definitions are strong and appropriately separate a pattern from a mechanism. Add one numeric conditional-probability example for each definition and remind students which quantities are observed versus unobserved. Before the Jacy model, justify logistic regression for the binary availability outcome, show why the length-squared term is needed rather than merely asserting curvature, define the profile fixed effects, and link to logistic regression and likelihood-ratio tests. State the nested-model and large-sample assumptions behind the test. Add a sensitivity analysis or conceptual MNAR alternative so the final warning has an operational consequence. |
| `missing-data/complete-case-analysis.qmd` | H | Make this the canonical Hillenbrand dossier: give one speaker/vowel/repetition row and `/hVd/` word, define speaker-group codes, steady-state measurement location, F0, and F1--F3, and distinguish the contour measurements not used here. Explain why the selected steady columns form one multivariate target. Repair the displayed complete-case formula so it does not multiply an undefined $Y_i$ by zero; write the estimator as a sum over $\{i:C_i=1\}$ and derive its conditional estimand. State the conditions under which deletion preserves the particular mean or regression target, rather than suggesting MCAR is the only possible preservation condition. Show one row excluded because one of several required measures is missing and explain the compositional shift. Link to the missingness-mechanism anchor. |
| `missing-data/pca-imputation.qmd` | H | The algorithm is unusually visible, but it needs the mathematical update from observed/missing index sets to initialization, rank-$K$ reconstruction, replacement of missing cells only, and convergence. Work one two-iteration toy matrix. Explain that the displayed relative-change denominator can be zero at initialization and align the mathematical stopping rule with the code's epsilon safeguard. Justify the rank grid, eight 5% validation masks, four 1.25% test masks, fallible-column restriction, tolerance, iteration cap, and initialization. Discuss nonconvergence, dependence on initialization, and multiple fixed points. State whether centering/scaling is transductive over all visible cells, and name deterministic single imputation and absent uncertainty propagation as central limitations. |
| `missing-data/validating-imputation.qmd` | H | The artificial-mask target is well distinguished from natural missingness. Add a VTS box naming the masked cell, token/speaker dependence, other visible cells, fold-local preprocessing, and the target missingness distribution. Explain why the chosen mask fractions and replicate counts provide a useful test and why masks are disjoint. The current cell-wise random masks can understate uncertainty when measurements from the same speaker or vowel are dependent; add grouped or stratified sensitivity checks and interval estimates across speakers or mask replicates. State exactly whether non-target test-mask cells remain visible in each final fit. Replace the repeated full algorithm with a backlink plus a compact symbol-to-code map unless repetition is needed for executable independence. End by separating interpolation skill under the artificial masking law from performance on naturally missing cells. |

## Page-by-page audit: custom models

| Page | Severity | Missing moves and exact additions/backlinks |
|---|---:|---|
| `custom-models/index.qmd` | M | The measurement stance and licensing qualifications are strong, but counts arrive before an intelligible record. Add one UDS sentence/predicate/prompt/response and one Turkish predicate/argument/role-selection record, then identify row, item, annotator or worker, and response for each. Link to the two proposed measurement-dossier anchors. Preserve the existing prerequisite links, but add local reminders: Bernoulli for binary responses, logit for an unconstrained additive predictor, crossed random intercepts for repeated items and annotators, and posterior predictive checks for features of replicated response matrices. Add an explicit roadmap from protocol to DGP, joint model, recovery, released-data fit, and gated extension. |
| `custom-models/generative-stories.qmd` | H | This should be the canonical UDS dossier, but the current “observed item” consists only of graph/node IDs and anonymized responses. Add the sentence text, marked predicate, exact natural-parts question and response options, and an explanation of what “natural subparts” means under the protocol. Show a mixed-response item without selecting it invisibly by outcome, or state why selection is display-only before code. Then justify each DGP choice: Bernoulli support, logit mapping, normal item/annotator populations, additive effects, exchangeability, and conditional independence. A table separating recorded $y_{ij}$, fixed identifiers, latent effects, probability, and population parameters would make the random-versus-observed distinction explicit. Backlink locally to Bernoulli, link functions, and random effects. |
| `custom-models/writing-a-joint-model.qmd` | M | The product over observed pairs and the warning against double-counting item means are excellent. Add the conditional-independence statements that license the product, expand one two-item likelihood by hand, and distinguish random variables $(\mathbf Y,\boldsymbol\Theta)$ from observed values $(\mathbf y,\boldsymbol\theta)$. Explain why the item-only model is introduced, what bias may result from omitting annotator effects, and how integrating over normal item effects produces the marginal likelihood optimized by `glmer`. Link to logistic regression, random intercepts, and likelihood, with local reminders. Justify `bobyqa`, `maxfun`, and the singularity tolerance as computational settings. |
| `custom-models/parameter-recovery.qmd` | H | The full generator, incidence preservation, seeds, Stan program, cache hashes, and limits are commendably explicit. The substantive settings still appear from nowhere: justify or vary $\alpha=-2.1$, both scales at 1.6, 12 replicates, two chains, 400 warmup/sampling iterations, `adapt_delta=.95`, priors, and every success threshold. Use several generating regimes, including weaker and stronger item/annotator variation and rarer yes responses, so recovery is not certified only near one favorable point. Derive the relative-error and latent-correlation targets, show uncertainty across replicates, and explain why 12 fits offer limited evidence about a pass rate. Link each $\widehat R$/divergence criterion to the chain-diagnostic anchor. State that passing prespecified cutoffs is evidence about this procedure under declared simulations, not a binary proof of identifiability. |
| `custom-models/annotations-as-measurements.qmd` | H | Make this the canonical Turkish PropBank dossier. Print and translate one privacy-safe retained row: sentence or gloss, predicate lemma/sense, candidate argument, selected role description, adjudicated role description, and `correct`. Define predicate-specific numbered core roles, general adjunct-like descriptions, the construction of `role_group`, and why nonarguments/special cases are excluded. Then justify Bernoulli/logit, normal crossed intercepts, additive role contrast, and conditional independence. Link to the canonical GLMM, likelihood-ratio, and exact-binomial pages with local reminders. Explain why the raw exact intervals and model-based Wald intervals answer different questions, state LRT assumptions, and interpret the coefficient on both log-odds and probability scales for a named reference item/worker. |
| `custom-models/annotator-effects.qmd` | M | The coordinate-system argument and warning against interpreting location as quality are strong. Add a reminder of the complete Bernoulli-logit likelihood and the priors that generated the cached posterior summaries; at present the cache is loaded before students have seen the released-data fit. Explain why annotators are treated as exchangeable random effects rather than 12 fixed coefficients, why a normal location distribution is chosen, and how connectedness of the item--annotator graph enables separation. Link the raw Clopper--Pearson intervals to `statistical-inference/exact-binomial-intervals.qmd` and explain that their coverage claim concerns each annotator's assigned items, not item-adjusted behavior. Include one posterior log-odds-to-probability calculation. |
| `custom-models/uds-measurement-model.qmd` | H | The likelihood, priors, fitting call, convergence summaries, partial pooling, two predictive checks, and six limitations form a good capstone skeleton. Add the missing Bayesian chain: write the likelihood over $\mathcal O$, multiply by every prior, state the normalizing integral, and explain that cached draws approximate the resulting posterior. Justify the Normal(0, 2.5) and half-Normal(2) priors on the logit scale with prior-predictive probabilities; show the prior predictive check before fitting. Explain the non-centered, realized-zero-sum construction and its induced dependence among effects. Justify four chains, 800/800 iterations, `adapt_delta=.95`, and thinning to 400 teaching draws, linking to Stan and chain-check anchors. Reintroduce one actual UDS sentence/predicate, expand predictive checks beyond two aggregate rates if the intended uses require it, and distinguish the zero-annotator probability from a probability integrated over annotators with a numerical example. |
| `custom-models/gated-annotations.qmd` | M | The distinction between structural absence and a recorded zero is excellent. Add one protocol diagram with the exact gate and follow-up prompts, scale anchors, and a hypothetical record for each branch. Derive the observed-data likelihood carefully: for a negative gate the unavailable branch contributes no density because it is outside the sample space or has been integrated out, not because an arbitrary $f_Y(y)$ is harmless when raised to zero. Link to the missing-data taxonomy with a local reminder. State candidate distributions for future branch responses only as design options, together with their support assumptions. Explain why the overall gate-rate predictive check is weak and add the within-item-disagreement check already used in the capstone. |

## ASW voice and slop audit

The prose is generally cautious, concrete, and disciplined about inferential scope.
The strongest ASW-like passages name a misconception, concede what a method can do,
and end on the narrower positive claim. Examples include the distinction between an
annotation and its target property, between a gate blank and a zero, and between
successful recovery and truth of the real-data generator.

The banned-expression scan found one direct connective violation:
“therefore” in `missing-data/missingness-patterns.qmd:46`; replace it with “thus.” It
found no other banned buzzword or throat-clearing expression in scope. No em dashes
occur, so there are no decorative em-dash violations.

The larger voice risks are structural.

- Sixteen transitions begin with generic phrases such as “The following,” “This
  model,” “This analysis,” or “This comparison.” Most are serviceable, but several
  should name the object that bears the inference: *observed-pair likelihood*,
  *one-step projection*, *artificial-mask target*, or *annotator-location contrast*.
- The recurring sequence of short introduction, large code block, output paragraph,
  limitation, and five-question callout is predictable. Keep the navigation, but let
  the explanatory need determine section length and place a hand-worked example
  before code when a new representation is introduced.
- Limitations often arrive only after the empirical result. Anticipate the central
  objection at the choice point: “A potential worry is that clipped SVD values are
  probabilities,” “A potential worry is that artificial missingness represents
  natural missingness,” or “A potential worry is that annotator location measures
  quality.” Then answer it and state the residual limit.
- Check callouts mostly test recall of statements already made. Add answers, perhaps
  in collapsed solution blocks, and include at least one tempting wrong
  interpretation per page. Good targets are treating “not listed” as absence, a
  loading as a phonological feature, a reconstructed binary cell as a probability, a
  MAR model as a verified mechanism, an imputed value as observed, `correct` as
  truth, and an item effect as a lexical category.
- Long technical paragraphs are often followed by another paragraph of similar
  length. Use a short sentence to land the upshot after a derivation or model-choice
  comparison. The resulting rhythm would be closer to the supplied teaching voice.

The requested `scripts/style_metrics.py` is not present in this repository or the
installed ASW skill, so this voice assessment is qualitative.

## Prioritized implementation batches

1. **Canonical measurement dossiers.** Expand PHOIBLE in `data-matrices.qmd`,
   VALEX/MegaAcceptability in `valex-megaacceptability.qmd`, Jacy in
   `missingness-patterns.qmd`, Hillenbrand in `complete-case-analysis.qmd`, UDS in
   `generative-stories.qmd`, and Turkish PropBank in
   `annotations-as-measurements.qmd`. Add real linguistic objects, source and
   course-facing rows, measure definitions, preprocessing, aggregation, dependence,
   exclusions, and target populations. Land these anchors before downstream edits.

2. **High-risk model-to-target repairs.** Resolve the use of clipped SVD values as
   probabilities in `reconstruction.qmd`; repair the complete-case estimand notation;
   state the transductive information set and uncertainty limitation of deterministic
   PCA imputation; and derive the gated observed-data likelihood without invoking an
   undefined branch value.

3. **Core mathematical and algorithmic derivations.** Add the truncated-SVD
   least-squares argument, PCA Lagrangian, ridge/SVD shrinkage, iterative-imputation
   updates and stopping rule, observed-pair joint likelihood, and UDS
   prior-times-likelihood posterior. Put a toy calculation and symbol-to-code table
   before each full implementation.

4. **Choice register and validation-target specifications.** Classify every threshold,
   grid, fold, mask, seed, tolerance, prior, recovery cutoff, sampler setting, and
   plotting constant. Add the five-part VTS to PHOIBLE reconstruction/rank selection,
   VALEX nested validation, and Hillenbrand artificial-mask validation.

5. **Recovery, prior, and predictive checks.** Extend UDS recovery across multiple
   generating regimes, justify thresholds and computation, add UDS prior predictive
   checks, and expand posterior predictive summaries when they are meant to support
   more than overall response rate and disagreement.

6. **Backlinks, local reminders, and misconception checks.** After the canonical
   pages stabilize, add exact anchors and one- or two-sentence reminders on every
   downstream page. Supply answerable check solutions and replace calculation-only
   prompts with measurement, target, leakage, and interpretation misconceptions.

7. **ASW voice and render pass.** Replace the one “therefore,” strengthen generic
   “This …” subjects, move central objections to the point of choice, vary the
   repeated template where it suppresses the argument, render all 24 pages, and test
   every internal anchor and executable example.

A safe implementation swarm would assign one owner to factorization and PHOIBLE, one
to Jacy/Hillenbrand and missing-data algorithms, and one to Turkish PropBank/UDS custom
models. The six dossier anchors and the high-risk target repairs should land before
the workers add downstream backlinks, since those later edits depend on shared terms
and examples.
