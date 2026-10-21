# Audit of explanatory support in the course notes

## Scope and verdict

This audit covers all 214 instructional `.qmd` pages in the ten note collections
listed in the course sidebar. It excludes assignments, problem sets, answer keys,
exams, generated HTML, and slide sources. Those materials matter for release
testing, but they do not define the explanatory sequence of the notes.

The notes have a strong empirical and computational base. They identify real
linguistic datasets, expose analysis code, report limitations, and usually end
with useful questions. But they often compress the part of the explanation that
students most need. A typical page names a statistical object, states its formal
definition, runs a substantial code block, and reports a careful caveat. What is
missing is the chain that connects those pieces.

I refer to that missing chain as the **explanatory-chain gap**. The complete chain
is:

1. What linguistic observation are we trying to understand?
2. What was measured, on which unit, and by what procedure?
3. What random quantity and estimand correspond to that question?
4. Why is this distribution, model, or algorithm a plausible choice?
5. Which assumptions license that choice, and what would their failure look like?
6. How does the displayed result follow, one step at a time?
7. Where does each mathematical object appear in the code and output?
8. What can the result support, and what remains outside the analysis?

The audit classified 94 pages as high priority, 105 as medium priority, and 15 as
low priority. Thus 199 of 214 pages need more than copyediting. The main problem is
not lexical AI slop. It is structural compression.

## What the audit found

### 1. The data become abstract too early

On first use, a dataset is often introduced by its row count and a list of
columns. That is not enough for a student to imagine the observation. Each
empirical run needs a canonical **measurement dossier** containing:

- one actual linguistic object, such as a sentence, word, pronunciation, vowel
  token, annotation prompt, infant trial, or language inventory;
- the source observation and its observation key;
- plain-language definitions of every focal measure, including units;
- the path from the source record through filtering, transformation, and
  aggregation to the course-facing row;
- the dependence that remains and the variation that aggregation removes; and
- the population or prediction target the resulting table can and cannot
  represent.

Later pages should link to that dossier, then repeat the two or three facts needed
for the current argument. A bare backlink is not a reminder.

### 2. Model choice is stated rather than argued for

Many distribution and model pages follow the sequence “family name, formula,
fit.” They need an explicit **observation-process argument**. That argument should
identify the support, the source of variation, the independence or exchangeability
claim, the meaning of each parameter, and the observable feature that would make
the choice doubtful. It should also distinguish a probability model for data from
a reference distribution, a sampling distribution, a posterior distribution, and
a computational proposal.

The same rule applies to apparently small decisions. A fixed degree of freedom, a
link function, a prior scale, an optimizer, a fold definition, a mask, a threshold,
or a sampler control should be classified as a mathematical, scientific,
computational, or display choice and justified at that level.

### 3. The decisive derivation step is often omitted

The notes usually contain the right equation, but several pages merely state the
identity that carries the explanation rather than deriving it. High-priority
examples include the Student-t
construction, the Clopper-Pearson inversion, beta and beta-binomial recurrences,
normal and count likelihoods, ordinary least squares and its uncertainty,
iteratively reweighted least squares, deviance, the Frisch-Waugh-Lovell identity,
PCA/SVD relationships, iterative imputation, and the posterior for custom
measurement models.

Each repaired derivation should use the same sequence:

1. declare the random variables, observed values, parameters, and statistic;
2. write the complete starting expression, including constants when they explain
   the result;
3. make one algebraic or probabilistic move per displayed line;
4. state the assumption or identity that licenses that move;
5. give the verbal interpretation of the resulting term; and
6. map the term to the corresponding data column, R expression, or Stan statement.

This is the mathematical analogue of showing one's work.

### 4. Random objects and observed values drift together

The supplied teaching examples repeatedly distinguish a random variable from its
realized value: $K(\mathbf X)$ from $K(\mathbf x)=k$, or an estimator
$T(\mathbf X)$ from the estimate $T(\mathbf x)$. The notes do this
inconsistently. That inconsistency is especially costly in pages on standard
errors, confidence intervals, likelihoods, posterior distributions, test
statistics, and predictive checks.

Every such page should include a short notation ledger before the derivation. The
ledger should say what is random before observation, what is fixed after
conditioning on the data, which distribution is being studied, and what the code
has actually computed.

### 5. Navigation follows adjacency rather than conceptual origin

The notes contain many previous/next links, but later pages rarely point to the
first full treatment of a prerequisite. The statistical-inference and
experimental-design audit found 108 `.qmd` links and no links to heading anchors.
This is first-treatment drift: a student who needs to remember conditional
probability, standard error, a Student-t density, or a grouped prediction target is
sent to a neighboring application instead of the canonical explanation.

The revision should establish stable anchors for definitions, derivations,
measurement dossiers, and limitations. Every non-index page should then begin
with a prerequisite reminder that links to the relevant anchor and states the
part of the concept used here.

### 6. The checks are regular but too often test recall

The four-question blocks are a useful base. They should increasingly ask students
to diagnose the tempting error:

- Which quantity is random before the data are observed?
- Which assumption licenses this factorization?
- What changed when the observational unit changed?
- Why would the neighboring model answer a different question?
- Which interpretation remains unsupported even if the computation is correct?

Each page should close with a short numbered recap of the new capability, then
state exactly what the next page adds.

## The Provo passage-level Student-t sequence

The page `statistical-inference/beyond-conjugacy.qmd` is the most concentrated
instance of the explanatory-chain gap. It should become the canonical treatment
for every later page that targets this posterior.

First, the data ladder must begin with reader-by-word eye-tracking records. A
first-fixation duration is the duration, in milliseconds, of the first recorded
fixation in a word's interest area. The source also distinguishes gaze duration,
total reading time, skipping, and regressions. The page should explain why an early
local measure is used here, while acknowledging that positive-duration filtering
makes the analysis conditional on a fixation.

Second, the transformation must be visible. The preparation retains complete
content-word rows with positive first-fixation durations, logs each reader-level
duration, averages those logs over readers at a word position, averages the
position summaries separately over nouns and verbs within a passage, and subtracts
the verb mean from the noun mean. Thus one modeled observation is a passage-level
noun-minus-verb contrast, not a reader response or a raw word fixation.

The page should include the short example used in the source article, one
course-facing position row, and one passage summary. It should also explain that
aggregation keeps the posterior two-dimensional and gives each passage one
contrast, while removing reader variation, word-level variation, reader-by-word
class variation, and passage-specific measurement precision. A raw hierarchical
model would answer a richer and different question.

Third, the Student-t likelihood needs an argument. It treats the 55 contrasts as
conditionally independent draws from a common symmetric location-scale family and
allows an extreme passage to have less influence than under a normal likelihood.
The fixed four degrees of freedom are a teaching choice: they give finite variance
and heavy tails while keeping the posterior two-dimensional. They do not follow
from the corpus. The notes should show a sensitivity comparison for degrees of
freedom 3, 4, and 7 and the normal limit.

Fourth, the priors need separate justifications. The normal prior on the location
centers no average noun-verb difference; the half-normal prior keeps the scale
positive and regularizes very large between-passage variation. Because both scales
use the observed $s_y$, these are data-calibrated teaching priors rather than ex
ante confirmatory priors. Their prior-predictive consequences should appear before
the posterior.

Finally, the posterior should be derived from normalized pieces. The page should
write the full Student-t density, construct the likelihood product, write both
prior densities and supports, apply continuous Bayes' rule, take logs term by term,
transform $\sigma$ to $\log\sigma$, derive the Jacobian, and map every term to
the grid code and later Stan program. The grid construction also needs an
explanation of its mode/Hessian center, seven-standard-deviation extent, equal cell
spacing, and boundary-mass check.

## Course-wide revision contract

Every revised concept page should contain the following moves, merged only when the
concept is genuinely small.

1. A concrete linguistic question and a one-clause roadmap.
2. A prerequisite backlink to the first treatment and a local reminder.
3. An observation card with one actual example and a raw-to-modeled data ladder.
4. A notation ledger separating random objects, observed values, parameters,
   statistics, and estimates.
5. A reason for the statistical choice, followed by its assumptions and a live
   alternative.
6. A derivation with one licensed move per line.
7. A mathematics-to-code-to-output crosswalk.
8. An interpretation on the measurement scale.
9. A potential worry, a response, and the limit of that response.
10. Misconception-oriented questions with answers.
11. A numbered recap and a precise forward link.

The prose should follow the supplied pedagogy examples: “Suppose…,” “So first,
remember…,” “To connect…,” “The remaining question is…,” and “Now consider…” are
useful when they mark real steps. The revision should vary paragraph and sentence
shape, end paragraphs on the upshot, and avoid turning this contract into identical
callout boilerplate.

## Implementation order

The dependencies determine the safe order of revision.

1. Establish the measurement dossiers and stable anchors in foundations and the
   distribution chapters.
2. Repair the canonical inference pages: standard errors, confidence intervals,
   exact binomial intervals, posterior distributions, conjugacy, and the Provo
   Student-t target.
3. Repair the regression derivation spine before revising GLMs and mixed models.
4. Add prediction-target and validation-unit explanations before extending model
   comparison, design, latent-structure, factorization, missing-data, and custom
   model pages.
5. Add local reminders, misconception checks, numbered recaps, and forward links
   only after the canonical anchors are stable.
6. Remove the slide navigation, sources, generated outputs, alignment machinery,
   and release checks that exist only to support slides.
7. Render and inspect each dependency branch, then run link, data-grounding,
   terminology, prose, slop, and citation-integrity checks.

## Page-by-page appendices

Every page has a severity rating and a specific remediation entry in the following
appendices:

- [Foundations and random variables](pedagogy/audit-foundations-random-variables.md)
- [Statistical inference and experimental design](pedagogy/audit-statistical-inference-experimental-design.md)
- [Regression models](pedagogy/regression-models-audit.md)
- [Model criticism, prediction, and latent structure](pedagogy/audit-model-criticism-latent-structure.md)
- [Factorization, missing data, and custom models](pedagogy/audit-factorization-missing-custom.md)

These appendices are the implementation checklist. A page is complete only when
its listed gaps have been repaired, its prerequisite links resolve to the canonical
anchors, its code still reproduces the reported result, and its interpretation
remains within the data and model actually used.
