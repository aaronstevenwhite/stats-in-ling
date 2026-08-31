# Course revamp specification

This document is the controlling specification for the new notes and problem sets. It replaces the candidate sequencing in `CONTENT-EXPANSION-PLAN.md` whenever the two conflict. The older document remains useful as a dataset-research notebook, but a proposed dataset or analysis is not part of the course until it passes the gates below.

## What the revamp is meant to repair

The current materials have three separable problems. First, many note pages identify a statistical object but stop before developing the object through a linguistic problem, a formal definition, an implementation, and a diagnostic. Second, the site currently ends at mixed-effects models even though the syllabus continues through model evaluation, experimental design, latent structure, and custom model design. Third, several assignments ask students to run an analysis whose empirical behavior does not support the intended lesson.

I refer to the joint repair as the **notes--assessment alignment requirement (NAAR)**. A topic belongs in the course only when (i) its page has no forward dependency, (ii) its linguistic application uses a defensible unit and estimand, and (iii) any assignment depending on it has been run end to end and produces the intended contrast.

## Fixed design constraints

The rebuild has seven nonnegotiable constraints.

1. **Topical organization.** Chapters receive topical titles, not lecture numbers. A class meeting may traverse several short pages, and a page may support more than one meeting.
2. **One-new-concept rule.** A concept page introduces one principal statistical object or technique. It may use earlier material, but it may not rely on a method introduced later.
3. **Application separation.** An application page may combine methods that have already been introduced. It may not introduce an additional method under cover of a dataset example.
4. **Theory-bearing predictors.** Predictors must encode a linguistic hypothesis, a design contrast, or a specific source of measurement variation. Convenience columns are not sufficient merely because they improve fit.
5. **Fresh-dataset rule.** Each released dataset receives one substantial course use. A later page may make a short callback to a result, but it may not refit the data or ask a second graded analysis of them.
6. **Empirical validation.** No assignment ships from a plausible analysis plan. Its source, preprocessing, fitted results, robustness, runtime, and answer key must all be frozen first.
7. **Structural notation.** Use $\langle\cdot\rangle$ when defining a formally assembled structure, including a probability space, measurable space, observation key, structured outcome, or model specification. Reserve $(\cdot)$ for coordinate points, parameter vectors, intervals, and ordinary realized value tuples.

## Course dependency spine

The modules form the following prerequisite spine. Branches within a module are recorded on the public dependency page.

| Module | Focal question | Entry dependency | Exit capability | Assessment checkpoint |
|---|---|---|---|---|
| Data and probability | What would count as an outcome of the linguistic process? | linguistic background | construct a probability space for a represented linguistic object | none |
| Random variables and distributions | How can a property of an outcome be measured and modeled? | probability measures | choose a distribution whose support and variation match a response | none |
| Statistical inference | What can a sample tell us about an unknown quantity? | distributions and expectation | state an estimand and quantify sampling or posterior uncertainty | PS1 |
| Regression relationships | How does an expected response vary with linguistic predictors? | inference and conditional expectation | specify and interpret linear and generalized regressions | PS3 after the generalized branch |
| Model criticism and prediction | Where does a fitted model fail, and for which new observations should it predict? | fitted regression models | define a prediction target, diagnose failure, and compare models without leakage | PS2 |
| Experimental design | Which comparisons identify the intended linguistic contrast? | uncertainty and regression | distinguish manipulation, blocking, sampling, and measurement decisions | none |
| Grouped and multilevel data | How should repeated speakers, items, languages, and sites enter a model? | regression and experimental design | specify partial pooling for a named dependence structure | PS4 |
| Latent structure | Can observed variables be represented by unobserved groups or dimensions? | joint distributions, regression, and model evaluation | fit and criticize clustering, mixture, and factor models in dependency order | PS5 |
| Custom model design | What measurement process could have generated the annotations? | outcome models, multilevel models, and computation | translate a linguistic annotation process into a generative model | none |

Model criticism follows regression because residuals and predictions require a fitted model. Experimental design then names the comparisons that multilevel models must preserve. Within latent structure, clustering and mixtures are introduced before factorization, and no page uses principal components, singular-value decomposition, or latent factors before the factorization branch begins.

## The page contract

Each concept page must do enough work for a student to reconstruct the object, rather than merely recognize its name. The default page therefore contains the following moves, with sections merged only when the concept is genuinely small.

1. **Linguistic problem.** Begin with a concrete representational or inferential problem.
2. **Naming move.** Name the new object and state what problem it solves.
3. **Formal statement.** Give the definition, model, or algorithm using only established notation.
4. **Worked derivation.** Work through a small linguistic example by hand before using software.
5. **Implementation.** Show how the object is computed and connect each line of code to the formal statement.
6. **Interpretation.** State what the resulting number, interval, coefficient, or prediction means for the motivating question.
7. **Failure or objection.** Show one way the object can be misapplied, and state what later concept will repair the failure when the repair has not yet been introduced.
8. **Checks.** Include short questions that require students to identify units, predictions, or consequences, not merely reproduce vocabulary.
9. **Summing up.** End with the new capability and a link to the next dependency.

Most pages will likely require 800--1,800 words, though length is not itself a success criterion. A definition that needs 500 words should not be inflated; an application that needs 2,500 words should not be split in a way that destroys the argument. The operative constraint is one conceptual center, not uniform page length.

## Application and dataset ledger

A **substantial use** includes any fitted model, extended visualization sequence, graded exercise, or interpretation on which a later claim depends. The public notes will maintain a ledger so that a dataset is not quietly recycled.

The planned rotation distributes applications across subfields.

| Area | Planned substantial uses |
|---|---|
| Corpus linguistics | written ANC for the opening rank--frequency application; Natural Stories for grouped prediction |
| Phonetics and sociophonetics | aspectual-similarity data are not placed here; Hillenbrand is reserved for PS1, Peterson--Barney for mixtures, and a separate dynamic-phonetics resource for trajectories if its pilot passes |
| Psycholinguistics and acquisition | Provo for PS2; MALD for response-distribution criticism; ManyBabies for design and power |
| Syntax and lexical semantics | a dative-alternation resource for PS3; MegaAcceptability with VALEX for factor-based distributional prediction |
| Semantics and pragmatics | the aspectual-similarity Experiment 2 data for bounded responses; MegaVeridicality for projection profiles; CommitmentBank for PS4 |
| Phonology and typology | PHOIBLE for PS5; a separate typological resource only if it supports a distinct, nonoverlapping target |
| Annotation and measurement | UDS for custom measurement-model design |

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
- LING 214 and LING 414 requirements must be separated explicitly;
- a clean environment must run the complete answer key within the stated time; and
- visible outputs in the key must match the prose, figures, and grading rubric.

An assignment is **approved** only after all four groups of checks pass. “Promising” means that the resource may be piloted; it does not authorize a release.

## Frozen assignment map

The following map fixes the disciplinary rotation and focal methods for development. PS1 and PS2 have passed their empirical and clean-run gates; the later assignments remain blocked from release until their pilots pass.

| Assignment | Discipline | Dataset | Focal method | Theoretical target | Current state |
|---|---|---|---|---|---|
| PS1 | phonetics | Hillenbrand vowels | paired/repeated-measures inference | the within-speaker F1 contrast between /i/ and /ɪ/ | **released; local data preparation required** |
| PS2 | psycholinguistics | Provo Corpus | grouped predictive evaluation | generalization across passages and lexical positions | **released** |
| PS3 | syntax and discourse | dative alternation | logistic regression | how information status and constituent properties constrain dative choice | **released** |
| PS4 | semantics and pragmatics | CommitmentBank | multilevel ordinal modeling | how embedding environment and discourse status structure commitment judgments | **pilot and redistribution decision required** |
| PS5 | phonology and typology | PHOIBLE 2.0 | latent factorization | which inventory dimensions reconstruct held-out segment patterns without merely recovering family or area | **pilot required** |

The old MALD PS3/PS4 sequence and Malayalam PS5 are legacy materials. They remain read-only evidence for the audit; they will not be patched into the new course because their current analyses do not pass the FAS gate.

## Definition of done

The revamp is complete only when all of the following conditions hold.

1. Every syllabus topic appears in the topical sidebar and public dependency map.
2. Every concept page satisfies the page contract and introduces no forward dependency.
3. Every substantial dataset use appears once in the ledger and links to its source and analysis record.
4. Every problem set has an approved FAS, a student version, a tested answer key, a rubric, and cached expected outputs.
5. Every code block and assignment runs in a clean environment, with nondeterminism checked rather than hidden by one seed.
6. The complete Quarto site renders without missing links, duplicate identifiers, or broken figures at desktop and narrow widths.
7. A final dependency audit, empirical audit, ASW style audit, slop check, and citation check have no unresolved release blockers.

This definition makes the order of work consequential. The opening chapters and PS1 can be rebuilt while later pilots run, but candidate analyses will not be written into polished notes or student notebooks before they pass.
