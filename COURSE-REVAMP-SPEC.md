# Course revamp specification

This document is the controlling specification for the new notes and problem sets. It replaces the candidate sequencing in `CONTENT-EXPANSION-PLAN.md` whenever the two conflict. The older document remains useful as a dataset-research notebook, but a proposed dataset or analysis is not part of the course until it passes the gates below.

## What the revamp is meant to repair

The current materials have three separable problems. First, many note pages identify a statistical object but stop before developing the object through a linguistic problem, a formal definition, an implementation, and a diagnostic. Second, the site currently ends at mixed-effects models even though the syllabus continues through model evaluation, experimental design, latent structure, and custom model design. Third, several assignments ask students to run an analysis whose empirical behavior does not support the intended lesson.

I refer to the joint repair as the **notes--assessment alignment requirement (NAAR)**. A topic belongs in the course only when (i) its page has no forward dependency, (ii) its linguistic application uses a defensible unit and estimand, and (iii) any assignment depending on it has been run end to end and produces the intended contrast.

## Fixed design constraints

The rebuild has ten nonnegotiable constraints.

1. **Topical organization.** Chapters receive topical titles, not lecture numbers. A class meeting may traverse several short pages, and a page may support more than one meeting.
2. **One-new-concept rule.** A concept page introduces one principal statistical object or technique. It may use earlier material, but it may not rely on a method introduced later.
3. **Application separation.** An application page may combine methods that have already been introduced. It may not introduce an additional method under cover of a dataset example.
4. **Theory-bearing predictors.** Predictors must encode a linguistic hypothesis, a design contrast, or a specific source of measurement variation. Convenience columns are not sufficient merely because they improve fit.
5. **Coherent-run rule.** Dataset use is organized into named empirical runs rather than one-off page examples. A run may occupy adjacent pages or include a dependency-linked return declared in the dataset manifest when every segment preserves the same observational units, preprocessing, and empirical target. A new question, a new preprocessing pipeline, or a graded task constitutes a new run and requires its own audit gate. Assignments use transfer datasets unless the frozen assignment map explicitly reserves a notes dataset.
6. **Empirical validation.** No assignment ships from a plausible analysis plan. Its source, preprocessing, fitted results, robustness, runtime, and answer key must all be frozen first.
7. **Structural notation.** Use $\langle\cdot\rangle$ when defining a formally assembled structure, including a probability space, measurable space, observation key, structured outcome, or model specification. Reserve $(\cdot)$ for coordinate points, parameter vectors, intervals, and ordinary realized value tuples.
8. **Data-derived quantities.** Symbolic definitions and derivations may remain general. Every displayed probability, expectation, variance, fitted parameter, interval, test statistic, loss, and other worked numerical quantity must be computed from an identified linguistic dataset by visible R code. We refer to this requirement as the **data-derived quantity rule (DQR)**.
9. **Restrained scientific plots.** Every empirical plot must expose the observations or empirical mass relevant to the claim. When a model and observations share a meaningful scale, the plot must show them together. Graphics use direct axis labels with units, neutral observations, no more than one accent color unless grouping requires more, and only the annotation needed to identify the focal statistic, threshold, held-out boundary, selected rank, or influential observation.
10. **Paper-first analysis.** Before a dataset can support notes prose, the developer must read its primary paper, release documentation, representation or annotation guidelines, and original analysis code when available. An evidence card then states what the released observations encode, reconciles paper and release counts, records the source pin and license, and bounds the claims that a simplified classroom analysis may support. A source-aligned pilot must pass before a proposed analysis becomes an approved empirical run.

## Course dependency spine

The modules form the following prerequisite spine. Branches within a module are recorded on the public dependency page.

| Module | Focal question | Entry dependency | Exit capability | Assessment checkpoint |
|---|---|---|---|---|
| Data and probability | What would count as an outcome of the linguistic process? | linguistic background | construct a probability space for a represented linguistic object | none |
| Random variables and distributions | How can a property of an outcome be measured and modeled? | probability measures | choose a distribution whose support and variation match a response | none |
| Statistical inference | What can a sample tell us about an unknown quantity? | distributions and expectation | state an estimand and quantify sampling or posterior uncertainty | PS1–PS2 |
| Regression relationships | How does an expected response vary with linguistic predictors? | inference and conditional expectation | specify and interpret linear and generalized regressions | PS3 after the generalized branch |
| Model criticism and prediction | Where does a fitted model fail, and for which new observations should it predict? | fitted regression models | define a prediction target, diagnose failure, and compare models without leakage | later problem sets and the final project |
| Experimental design | Which comparisons identify the intended linguistic contrast? | uncertainty and regression | distinguish manipulation, blocking, sampling, and measurement decisions | none |
| Grouped and multilevel data | How should repeated speakers, items, languages, and sites enter a model? | regression and experimental design | specify partial pooling for a named dependence structure | PS4 |
| Latent structure | Can observed variables be represented by unobserved groups or dimensions? | joint distributions, regression, and model evaluation | fit and criticize clustering, mixture, and factor models in dependency order | PS5 |
| Custom model design | What measurement process could have generated the annotations? | outcome models, multilevel models, and computation | translate a linguistic annotation process into a generative model | none |

Model criticism follows regression because residuals and predictions require a fitted model. Experimental design then names the comparisons that multilevel models must preserve. Within latent structure, clustering and mixtures are introduced before factorization, and no page uses principal components, singular-value decomposition, or latent factors before the factorization branch begins.

## The page contract

Each concept page must do enough work for a student to reconstruct the object, rather than merely recognize its name. The default page thus contains the following moves, with sections merged only when the concept is genuinely small.

1. **Linguistic problem.** Begin with a concrete representational or inferential problem.
2. **Naming move.** Name the new object and state what problem it solves.
3. **Formal statement.** Give the definition, model, or algorithm using only established notation.
4. **Worked derivation.** Work through the mathematics using quantities computed from the page's linguistic dataset. A symbolic derivation may precede substitution, but a schematic numerical example may not.
5. **Implementation.** Show all R code needed to load the source, define the analysis subset, transform variables, compute or fit the target, and draw the figure. Connect each step to the formal statement; no page may depend on hidden in-memory state from another page.
6. **Interpretation.** State what the resulting number, interval, coefficient, or prediction means for the motivating question.
7. **Failure or objection.** Show one way the object can be misapplied, and state what later concept will repair the failure when the repair has not yet been introduced.
8. **Checks.** Include short questions that require students to identify units, predictions, or consequences, not merely reproduce vocabulary.
9. **Summing up.** End with the new capability and a link to the next dependency.

On a dataset's first use, the page briefly introduces the observational units, focal variables, original study, pinned source, license or terms, and relevant preprocessing. Later pages in the same empirical run recall the dataset in one sentence and link back to that introduction. Computed results receive assertions for the quantities that carry the lesson. Seeds, fold identifiers, validation masks, candidate grids, package versions, and grouping identifiers are fixed and reported when they affect the result.

The notes retain all mathematical definitions and derivations. Figures provide a second route through those arguments: distributions show observed masses or measurements; fitted-model figures show raw observations and fitted values on a shared scale whenever that comparison is meaningful; validation figures identify the held-out unit; and uncertainty appears as intervals or bands rather than prose-heavy callouts. An annotation is warranted only when the pedagogical target would otherwise be difficult to locate. Decorative icons, gradients, infographic panels, redundant legends, and paragraph-length labels are not part of the course's graphical vocabulary.

Most pages will likely require 800--1,800 words, though length is not itself a success criterion. A definition that needs 500 words should not be inflated; an application that needs 2,500 words should not be split in a way that destroys the argument. The operative constraint is one conceptual center, not uniform page length.

## Build and fit-cache policy

The routine course build is staged by dependency prefix. `scripts/render_staged_notes.py --through linear-regression` renders exactly the notes used by the first four decks; it does not expand the broader `regression-models/*.qmd` project pattern. Each successful staged render writes source and HTML hashes to `decks/note-render-receipts.json`. The slide generator rejects a note whose source or rendered HTML no longer matches that receipt, and the alignment check authenticates the same hashes independently.

Project-level `freeze: auto` and knitr caching reuse unchanged computations in the current checkout. A model whose cold fit is slow enough to impede routine builds also needs an explicit fit cache. Its signature must include hashes of every input table, the analysis subset, the model formula and fitting controls, the R version, and relevant package versions. A cache is reused only when the complete signature matches.

When a full-data fit remains too slow for classroom development, the teaching analysis may use a fixed subset only if the sampling unit preserves the dependence structure needed by the model. The selection rule must be fixed without looking at the modeled response, and the notes and slides must state (i) the full and retained sample sizes, (ii) the retained groups and design cells, (iii) the computational reason for the subset, and (iv) the narrower population to which its estimates apply. Row-wise convenience samples that break speakers, items, languages, or lexical paradigms are not permitted. A teaching subset does not convert its estimates into full-data estimates or reproduce the original paper's analysis.

## Application and dataset ledger

A **substantial use** includes any fitted model, extended visualization sequence, graded exercise, or interpretation on which a later claim depends. The machine-readable manifest in `research/dataset-audits/dataset-manifest.json` registers each dataset, its source and version, its license status, and every planned empirical run. This manifest is the source of truth for whether a return is part of an existing run or an unreviewed reuse.

A coherent run should normally last long enough for students to learn the dataset's units and variables, but it should end at a natural conceptual break. A short interlude using a second dataset to contrast variable types does not close a run when the manifest declares the return in advance. Once a run has closed, a later use is permitted only if it is registered as a new run with a distinct teaching target and passes the relevant audit. Thus the course can reuse a dataset efficiently without turning every page into a new source introduction or quietly asking the same observations to support unrelated claims.

The planned rotation distributes applications across subfields.

| Area | Planned substantial uses |
|---|---|
| Corpus linguistics | UD Turkish BOUN for rank, probability, and corpus likelihood; Natural Stories for grouped prediction |
| Phonetics and sociophonetics | Hillenbrand for continuous measurements, paired inference, and imputation; Peterson--Barney for latent vowel structure |
| Psycholinguistics and acquisition | Provo for lexical probabilities, Bayesian computation, linear modeling, and model comparison; MALD for multiple-regression criticism and Gaussian mixed models; Natural Stories for prediction targets; ManyBabies for design and power |
| Syntax and lexical semantics | the English dative alternation for joint distributions; the pinned CC BY-SA SuperTelicity release for Bernoulli models; VALEX with MegaAcceptability for distributional prediction; privacy-safe Turkish PropBank for annotation agreement |
| Semantic representation and grammar engineering | graph-aware UCCA French--English for paired structural counts; Jacy/Tanaka Japanese MRS for grammar-analysis coverage, never usage frequency; both paper-first gates have passed for these narrow uses |
| Semantics and pragmatics | MegaVeridicality and MegaOrientation for ordinal models, interactions, and unseen-verb evaluation; CommitmentBank as the PS4 transfer dataset; the public MegaNegRaising balanced subset for bounded models; UDS for the binary annotator-aware measurement capstone; aspectual similarity remains blocked reference evidence until its public source and title are reconciled |
| Phonology and typology | CMUdict for discrete random variables and waiting counts; Turkish UniMorph for finite populations and contingency inference; PHOIBLE 2.0 for factorization |

This table is a reservation, not an approval. The audited registry remains the source of truth for whether a planned use has passed its empirical gate.

## Assignment validation gate

Every problem set receives a **frozen analysis specification (FAS)** before the student notebook is written. The FAS must record the following information.

### Scientific target

- the linguistic question and named theoretical contrast;
- the unit of observation, sampling or grouping units, and target population;
- the estimand or prediction target;
- the response and theoretically motivated predictors; and
- the claim that the result may support, together with claims it cannot support.

### Data provenance

- the primary paper and release documentation;
- a frozen release, retrieval procedure, and checksum;
- the license and course redistribution decision;
- all exclusions, transformations, derived variables, and missing-data decisions; and
- a schema check that fails when an upstream release changes.

### Empirical behavior

- a minimal analysis and the intended repair or extension;
- the numerical contrast that carries the lesson;
- sensitivity to preprocessing choices that a reasonable student might make;
- stability across relevant random seeds, folds, participant or item resamples, and optimizer starts; and
- a declared interpretation when instability is itself the lesson.

The intended result need not be a small *p* value or a preferred model. But it must be interpretable. If the task is meant to show that grouped validation changes a model comparison, that change must occur reliably enough to teach; if the task is meant to show instability, the pilot must quantify that instability rather than accidentally discover it in the classroom.

### Pedagogical behavior

- every required technique must appear earlier in the dependency map;
- the assignment must have one focal technique, even when it integrates earlier ones;
- code scaffolding must leave the statistical decision to the student rather than hiding it in setup code;
- every problem set must present one common sequence of required tasks, without course-number-specific extensions;
- a clean environment must run the complete answer key within the stated time; and
- visible outputs in the key must match the prose, figures, and grading rubric.

An assignment is **approved** only after all four groups of checks pass. “Promising” means that the resource may be piloted; it does not authorize a release.

## Frozen assignment map

The following map fixes the disciplinary rotation and focal methods for development. PS1 and PS2 have passed their empirical and clean-run gates; the later assignments remain blocked from release until their pilots pass.

| Assignment | Discipline | Dataset | Focal method | Theoretical target | Current state |
|---|---|---|---|---|---|
| PS1 | phonetics | Hillenbrand vowels | guided paired-t and exact-sign inference | the magnitude and directional consistency of the within-speaker F1 contrast between /i/ and /ɪ/ | **revised; local data preparation required** |
| PS2 | psycholinguistics | Provo Corpus | Bayesian normal inference with a guided one-dimensional normal–normal derivation, plus application of the beta–Bernoulli update | the magnitude and directional consistency of a within-passage noun–verb log-FFD contrast | **revised** |
| PS3 | syntax and discourse | dative alternation | logistic regression | how information status and constituent properties constrain dative choice | **released** |
| PS4 | semantics and pragmatics | CommitmentBank | multilevel ordinal modeling | how embedding environment and discourse status structure commitment judgments | **pilot and redistribution decision required** |
| PS5 | phonology and typology | PHOIBLE 2.0 | latent factorization | which inventory dimensions reconstruct held-out segment patterns without merely recovering family or area | **pilot required** |

PS1 and PS2 remain read-only. PS3--PS5 may be revised only if the rewritten notes create a concrete mismatch with an assignment's frozen analysis; the present audit does not treat permission to edit them as a requirement to do so.

## Definition of done

The revamp is complete only when all of the following conditions hold.

1. Every syllabus topic appears in the topical sidebar and public dependency map.
2. Every concept page satisfies the page contract and introduces no forward dependency.
3. Every substantial dataset use belongs to exactly one declared empirical run in the manifest and links to its source and analysis record.
4. Every problem set has an approved FAS, a student version, a tested answer key, a rubric, and cached expected outputs.
5. Every code block and assignment runs in a clean environment, with nondeterminism checked rather than hidden by one seed.
6. The complete Quarto site renders without missing links, duplicate identifiers, or broken figures at desktop and narrow widths.
7. The data-grounding guard reports no unallowlisted schematic marker or unexplained worked number.
8. A final dependency audit, empirical audit, ASW style audit, slop check, and citation check have no unresolved release blockers.

This definition makes the order of work consequential. The opening chapters and PS1 can be rebuilt while later pilots run, but candidate analyses will not be written into polished notes or student notebooks before they pass.
