# Missing linguistic data

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Missing linguistic data

Source note: `missing-data/index.qmd`

Welcome to Missing linguistic data. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Missing data

Source note: `missing-data/index.qmd`

Now we turn to Missing data.

## Slide 3: Jacy: the empirical object

Source note: `missing-data/index.qmd`

The data source is Bond et al. (2008), Jacy. It provides Japanese analyses from the Jacy grammar over Tanaka examples.

## Slide 4: Missing data

Source note: `missing-data/index.qmd`

Missingness is a relation among a linguistic unit, an intended measurement, and its realized record. A blank cell does not identify that relation by itself. A missing-data analysis must state the unit, the measurement that should have been available, and the process that made an observed value unavailable.

## Slide 5: Missing data

Source note: `missing-data/index.qmd`

This module develops that specification with two audited linguistic resources. The first is the MIT-licensed Tanaka sentence collection in Jacy, whose Redwoods-style selection workflow is described by Tanaka et al. (2005) and Bond, Kuribayashi, and Hashimoto (2008). Its outcome is availability of a grammar-generated, human-selected analysis. The second is the nonimputed release of Hillenbrand et al.'s (1995) vowel measurements, distributed in a permissioned repository. Its missing values are unavailable F2 or F3 measurements for recorded vowel tokens.

## Slide 6: Missing data

Source note: `missing-data/index.qmd`

These two absences have different meanings. An unselected Jacy item lacks an accepted result from a grammar-and-selection pipeline; it is not thereby a sentence without meaning. A Hillenbrand `NA` marks an unavailable acoustic estimate, not 0 Hz and not the absence of the vowel token. This distinction governs every method that follows.

## Slide 7: What counts as missing?

Source note: `missing-data/index.qmd`

Several superficially similar absences still require different analyses.

## Slide 8: What counts as missing?

Source note: `missing-data/index.qmd`

- **An absent record:** a speaker who was never recruited or a corpus token that was never sampled has no row. This is a sampling or coverage problem, not a missing cell in the realized table. - **Planned missingness:** a counterbalanced experiment may deliberately leave some participant--item combinations unpresented. Those omissions belong to the design; they are not accidental nonresponses. - **An undefined measure:** a word skipped on first pass has an observed skipping outcome, but no first-pass fixation duration. Reading studies consequently analyze skipping and fixation-contingent durations as distinct measures (Rayner et al. 2011). Coding the duration as `NA` does not create an unseen fixation duration. - **Measurement or analysis failure:** the record exists, but a value that the protocol intended to recover is unavailable. The Hillenbrand formant cells belong here, though the release does not identify a cell-specific cause. - **Dropout:** a participant begins a longitudinal or multi-session study but supplies no later records. This is unit-level loss over time, not merely an empty acoustic cell.

## Slide 9: What counts as missing?

Source note: `missing-data/index.qmd`

These cases may all produce blanks after data are reshaped into a rectangle. But they imply different target populations, different observation processes, and different possible remedies. Imputation is relevant only after we have identified a value that was intended to be observed and is now unavailable.

## Slide 10: From locations to assumptions

Source note: `missing-data/index.qmd`

We proceed in two steps. First, missingness patterns represent which intended values are observed. The indicator describes locations; it does not explain them. Second, missingness mechanisms state how the probability of observation may depend on named observed and unobserved variables. The labels MCAR, MAR, and MNAR are incomplete unless those variables and the unit of analysis are specified.

## Slide 11: From locations to assumptions

Source note: `missing-data/index.qmd`

This distinction parallels the separation between a sampling design and an outcome model. The pattern is observed data. The mechanism is an assumption about the process that produced that pattern.

## Slide 12: Deletion, reconstruction, and checking

Source note: `missing-data/index.qmd`

Complete-case analysis retains rows observed on every variable required by a particular analysis. It thus defines a selection indicator. If selection depends on the response or a predictor, the retained rows may describe a different population from the eligible rows.

## Slide 13: Deletion, reconstruction, and checking

Source note: `missing-data/index.qmd`

Iterative PCA imputation takes a different route. It uses the rank-$K$ reconstruction of a completed matrix to update its missing cells while returning observed cells to their measured values. The resulting number is a model-based prediction under a low-rank assumption. It is not a recovered observation, and a single completed matrix does not propagate uncertainty about the prediction.

## Slide 14: Deletion, reconstruction, and checking

Source note: `missing-data/index.qmd`

Finally, validation by artificial masking hides some observed values, fits the full procedure without them, and compares the held-out reconstructions with their known values. This extends the earlier distinction between training and test data to matrix cells. It can reveal reconstruction failures under the tested masks, but it cannot reveal the values that were naturally missing.

## Slide 15: Deletion, reconstruction, and checking

Source note: `missing-data/index.qmd`

The order of the module follows the decisions an analysis requires: (i) specify what should have been observed, (ii) describe where it is absent, (iii) state assumptions about why, (iv) make deletion explicit, (v) define one reconstruction method, and (vi) test that method under registered artificial masks. A blank becomes statistically interpretable only after we name its unit, variable, and observation process.

## Slide 16: Missingness patterns

Source note: `missing-data/missingness-patterns.qmd`

Now we turn to Missingness patterns.

## Slide 17: Missingness patterns

Source note: `missing-data/missingness-patterns.qmd`

The Tanaka corpus provides a useful first case because its absences arise inside a linguistic analysis pipeline, not from an invented table. In the Redwoods-style workflow described by Tanaka et al. (2005), the Jacy grammar generates analyses for a Japanese sentence and a human annotator selects among them using discriminants. Bond, Kuribayashi, and Hashimoto (2008) describe the Tanaka annotation cycle. A selected analysis carries a grammar-derived Minimal Recursion Semantics (MRS) representation; its predicates and links are thus not separate hand annotations.

## Slide 18: Missingness patterns

Source note: `missing-data/missingness-patterns.qmd`

We use the current profile extract from the official Jacy documentation and the pinned Jacy release. The row unit is one sentence in one `[incr tsdb()]` profile. This release is later than the annotation stage reported in the 2008 paper, so the empirical counts below describe the pinned release rather than reproducing the paper's table.

## Slide 19: Loading and checking the profile table

Source note: `missing-data/missingness-patterns.qmd`

The table has 15,000 items and 9,128 preference records. Those are different units: 333 items have more than one accepted result. Thus the selected-item count is 8,670, not the number of preference records.

## Slide 20: From a binary indicator to three observed states

Source note: `missing-data/missingness-patterns.qmd`

Let $Y_i$ denote a downstream quantity calculated from the selected MRS for item $i$. Its availability indicator is

$$
R_i=
\begin{cases}
1 & \text{if at least one analysis was selected},\\
0 & \text{if no analysis was selected}.
\end{cases}
$$

## Slide 21: From a binary indicator to three observed states

Source note: `missing-data/missingness-patterns.qmd`

The binary indicator records whether $Y_i$ is available, but it merges two observed pipeline outcomes. Some unselected items have positive parse readings, while others have no positive reading recorded. We therefore define a three-state categorical variable:

$$
C_i=
\begin{cases}
\text{selected analysis} & \text{if a preference record exists},\\
\text{parsed, unselected} & \text{if positive readings exist but none was selected},\\
\text{no positive reading} & \text{otherwise}.
\end{cases}
$$

## Slide 22: From a binary indicator to three observed states

Source note: `missing-data/missingness-patterns.qmd`

The release uses `-1` as a parser sentinel. It is not minus one analysis and should not enter an arithmetic count. The following recoding tests the positive-reading condition instead.

## Slide 23: From a binary indicator to three observed states

Source note: `missing-data/missingness-patterns.qmd`

The 8,670 selected items account for 57.8% of the release. Another 3,666 items were parsed but have no accepted preference record, and 2,664 have no positive reading. Thus a zero in $R_i$ does not identify one kind of failure.

## Slide 24: The pattern varies across profiles

Source note: `missing-data/missingness-patterns.qmd`

The same states can be summarized within each profile. This plot shows the observed composition directly; it does not attach a causal explanation to the differences.

## Slide 25: The pattern varies across profiles

Source note: `missing-data/missingness-patterns.qmd`

Observed linguistic data for The pattern varies across profiles.

## Slide 26: The pattern varies across profiles

Source note: `missing-data/missingness-patterns.qmd`

The three-state variable locates where a selected grammar analysis is and is not available. It does not show that an unselected sentence lacks a meaning, is ungrammatical, or is rare in Japanese usage. The three states do not identify why selection failed: the grammar may not span the sentence, available analyses may be rejected, or another stage may intervene.

## Slide 27: A pattern does not identify its mechanism

Source note: `missing-data/missingness-patterns.qmd`

A missingness pattern is observed data. A missingness mechanism is an assumption about the process that produced it. The profile differences above may challenge a description in which selected analyses are equally available everywhere, but they cannot establish why selection varies.

## Slide 28: A pattern does not identify its mechanism

Source note: `missing-data/missingness-patterns.qmd`

This boundary matters for downstream MRS analyses. Restricting attention to selected items changes the analyzed population to sentences for which this grammar-and-selection pipeline supplied an accepted analysis. That population may be appropriate for a narrowly stated grammar evaluation. It is not automatically a sample of all Japanese sentences.

## Slide 29: Inspecting the pattern

Source note: `missing-data/missingness-patterns.qmd`

Why are `preferred_analysis_count` and the number of selected items different units?

## Slide 30: Inspecting the pattern

Source note: `missing-data/missingness-patterns.qmd`

What information is lost when the three analysis states are collapsed to $R_i$?

## Slide 31: Inspecting the pattern

Source note: `missing-data/missingness-patterns.qmd`

Why must `parse_readings = -1` be treated as a sentinel rather than a count?

## Slide 32: Inspecting the pattern

Source note: `missing-data/missingness-patterns.qmd`

Which claims about Japanese sentences remain unsupported by the profile plot?

## Slide 33: Inspecting the pattern

Source note: `missing-data/missingness-patterns.qmd`

A selected-analysis indicator represents availability, while the three-state variable retains the observed distinction between parsing and selection outcomes. Neither object identifies its own cause. The next page asks what the association with observed profile length can and cannot establish.

## Slide 34: Inspecting the pattern

Source note: `missing-data/missingness-patterns.qmd`

Previous: Missing data · Next: Missingness mechanisms.

## Slide 35: Missingness mechanisms

Source note: `missing-data/missingness-mechanisms.qmd`

Next, we take up Missingness mechanisms.

## Slide 36: Missingness mechanisms

Source note: `missing-data/missingness-mechanisms.qmd`

The preceding page distinguished selected analyses, parsed but unselected items, and items with no positive reading. We now ask whether the binary outcome $S_i=1$ for a selected analysis is associated with two measurements observed for every profile item: its profile and its released token count. This is a descriptive question about the pinned release. It is not yet a diagnosis of why an analysis is unavailable.

## Slide 37: Missingness mechanisms

Source note: `missing-data/missingness-mechanisms.qmd`

A **missingness mechanism** states how an observation probability depends on observed and unobserved quantities. The three standard mechanisms make different conditional-dependence claims. They do not name three visual arrangements of blank cells.

## Slide 38: Separating observed and unobserved quantities

Source note: `missing-data/missingness-mechanisms.qmd`

Let $Y_i$ be an intended measurement that is unavailable when $R_i=0$, and let $X_i$ collect quantities observed regardless of availability. The observation mechanism concerns

$$
\mathbb{P}(R_i=1\mid X_i,Y_i).
$$

## Slide 39: Separating observed and unobserved quantities

Source note: `missing-data/missingness-mechanisms.qmd`

The labels MCAR, MAR, and MNAR restrict which named quantities that probability may depend on.

## Slide 40: Separating observed and unobserved quantities

Source note: `missing-data/missingness-mechanisms.qmd`

Values are **missing completely at random (MCAR)** when the observation probability depends on neither the observed covariates nor the unobserved measurement:

$$
\mathbb{P}(R_i=1\mid X_i,Y_i)=\mathbb{P}(R_i=1).
$$

## Slide 41: Separating observed and unobserved quantities

Source note: `missing-data/missingness-mechanisms.qmd`

Under this account, observed rows form a random subset with respect to the variables in the statement. Failure to find a visible association would not establish MCAR, because a finite dataset contains no direct information about the missing $Y_i$ values.

## Slide 42: Separating observed and unobserved quantities

Source note: `missing-data/missingness-mechanisms.qmd`

Values are **missing at random (MAR)** when observation may depend on observed measurements but does not additionally depend on the unavailable value after conditioning on them:

$$
\mathbb{P}(R_i=1\mid X_i,Y_i)=\mathbb{P}(R_i=1\mid X_i).
$$

## Slide 43: Separating observed and unobserved quantities

Source note: `missing-data/missingness-mechanisms.qmd`

MAR may thus produce systematic, visible missingness. The claim is conditional: once the stated $X_i$ is held fixed, $Y_i$ supplies no further information about observation.

## Slide 44: Separating observed and unobserved quantities

Source note: `missing-data/missingness-mechanisms.qmd`

Values are **missing not at random (MNAR)** when observation still depends on the unavailable value after the observed quantities have been considered:

$$
\mathbb{P}(R_i=1\mid X_i,Y_i)
\neq \mathbb{P}(R_i=1\mid X_i).
$$

## Slide 45: Separating observed and unobserved quantities

Source note: `missing-data/missingness-mechanisms.qmd`

The observed data generally do not identify this residual dependence. Domain knowledge about the data-producing process and sensitivity analyses are needed to study plausible MNAR departures.

## Slide 46: Loading the Jacy availability outcome

Source note: `missing-data/missingness-mechanisms.qmd`

The row unit and sources are documented on the Jacy pattern page. Here $S_i$ marks whether at least one grammar analysis has an accepted preference record, $L_i$ is standardized released token count, and $P_i$ is profile.

## Slide 47: Loading the Jacy availability outcome

Source note: `missing-data/missingness-mechanisms.qmd`

The descriptive model is

$$
S_i\sim\operatorname{Bernoulli}(\pi_i),
\qquad
\operatorname{logit}(\pi_i)
=\alpha+\beta_1L_i+\beta_2L_i^2+\gamma_{P_i}.
$$

## Slide 48: Loading the Jacy availability outcome

Source note: `missing-data/missingness-mechanisms.qmd`

The profile terms represent differences among the 10 observed profiles. The linear and quadratic length terms represent the curvature visible in the empirical length proportions. They do not turn token count into a causal explanation.

## Slide 49: Loading the Jacy availability outcome

Source note: `missing-data/missingness-mechanisms.qmd`

The estimated length terms are -0.570 and -0.112 on the log-odds scale. Adding them to the profile-only model reduces deviance by 1271.39 on 2 degrees of freedom. These quantities summarize an association in this release.

## Slide 50: Raw proportions and the fitted model

Source note: `missing-data/missingness-mechanisms.qmd`

We plot the raw selection proportion at each released token count together with the model's mean fitted probability among items of that length. Point size records the number of items but is left unlabelled to keep the graph focused.

## Slide 51: Raw proportions and the fitted model

Source note: `missing-data/missingness-mechanisms.qmd`

This figure shows observed linguistic data for Raw proportions and the fitted model.

## Slide 52: Raw proportions and the fitted model

Source note: `missing-data/missingness-mechanisms.qmd`

The raw and fitted quantities decrease as released token count increases, conditional on the model's profile terms. This pattern challenges an equal-availability description with respect to these observed covariates. It does not show that longer Japanese sentences are intrinsically less grammatical, meaningful, or frequent.

## Slide 53: Why the association does not classify the mechanism

Source note: `missing-data/missingness-mechanisms.qmd`

If a downstream MRS property is the intended $Y_i$, selection is its availability indicator. But for an item with no acceptable grammar analysis, the counterfactual value of that property may itself require a more precise definition. Thus a mechanism label is meaningful only after the missing quantity and target population have been specified.

## Slide 54: Why the association does not classify the mechanism

Source note: `missing-data/missingness-mechanisms.qmd`

Even under such a specification, the plot contains $S_i$, profile, and length, not the unavailable $Y_i$. The association is compatible with an MAR account based on observed pipeline covariates. It is also compatible with an MNAR account involving properties of an unavailable acceptable analysis. And profile or length may stand in for unrecorded stages of parsing and annotation. The model cannot adjudicate among these accounts.

## Slide 55: Why the association does not classify the mechanism

Source note: `missing-data/missingness-mechanisms.qmd`

Mechanisms can also differ by level. A sentence outside the corpus has no profile row; a profile item with no positive reading has a row but no positive parse; and a parsed item may remain unselected. Treating all three as the same blank would merge a coverage problem with two observed pipeline states.

## Slide 56: Classifying the claim

Source note: `missing-data/missingness-mechanisms.qmd`

Which dependence is removed by MCAR but permitted by MAR?

## Slide 57: Classifying the claim

Source note: `missing-data/missingness-mechanisms.qmd`

Why does the fitted length association challenge equal availability without establishing MAR?

## Slide 58: Classifying the claim

Source note: `missing-data/missingness-mechanisms.qmd`

What additional dependence would make the mechanism MNAR for a defined downstream MRS quantity?

## Slide 59: Classifying the claim

Source note: `missing-data/missingness-mechanisms.qmd`

Why is a sentence absent from the corpus not a missing profile item?

## Slide 60: Classifying the claim

Source note: `missing-data/missingness-mechanisms.qmd`

A missingness mechanism restricts how availability may depend on named observed and unavailable quantities. The Jacy model establishes an association with observed profile length and profile in the pinned release; it does not identify a causal mechanism. The next page turns to a raw acoustic table in which the intended measurements and complete rows are directly defined.

## Slide 61: Classifying the claim

Source note: `missing-data/missingness-mechanisms.qmd`

Previous: Missingness patterns · Next: Complete-case analysis.

## Slide 62: Complete-case analysis

Source note: `missing-data/complete-case-analysis.qmd`

Now we turn to Complete-case analysis.

## Slide 63: Hillenbrand et al. (1995): the empirical object

Source note: `missing-data/complete-case-analysis.qmd`

The data source is Hillenbrand et al. (1995). It provides American English /hVd/ vowel tokens with acoustic measurements.

## Slide 64: Complete-case analysis

Source note: `missing-data/complete-case-analysis.qmd`

Hillenbrand et al. (1995) recorded men, women, and children producing American English vowels in /hVd/ words. They measured formant contours from LPC spectra with interactive editing and selected the steady-state sample by visual inspection. We use the pinned raw-data release, whose table retains unavailable formant measurements as `NA`.

## Slide 65: Complete-case analysis

Source note: `missing-data/complete-case-analysis.qmd`

The row unit is one speaker-by-vowel token. The exact missing-cell pattern is a property of the released table, not a count reported in the 1995 article. An `NA` means that this release contains no usable numeric estimate in the intended cell; it does not mean 0 Hz, and the release does not name a cell-specific cause.

## Slide 66: Defining the analysis set

Source note: `missing-data/complete-case-analysis.qmd`

**Complete-case analysis**, also called listwise deletion, retains only rows observed on every variable required by an analysis. Let $J$ be that set of variables. For token $i$,

$$
C_i=\prod_{j\in J}R_{ij}.
$$

Because each $R_{ij}$ is zero or one, $C_i=1$ only when every required value is observed.

## Slide 67: Defining the analysis set

Source note: `missing-data/complete-case-analysis.qmd`

A complete-case estimate of a mean is

$$
\bar Y_{C=1}
=\frac{\sum_{i=1}^{n}C_iY_i}{\sum_{i=1}^{n}C_i}.
$$

## Slide 68: Defining the analysis set

Source note: `missing-data/complete-case-analysis.qmd`

This is a mean over complete rows. It equals the mean over all eligible rows only under additional conditions on the missingness mechanism and the estimand.

## Slide 69: Defining the analysis set

Source note: `missing-data/complete-case-analysis.qmd`

We define $J$ using duration, F0, and the steady F1--F3 measurements.

## Slide 70: Defining the analysis set

Source note: `missing-data/complete-case-analysis.qmd`

The analysis retains 1,617 of 1,668 recorded tokens and removes 51. The complete-case indicator is stored in the table rather than left to a modeling function’s implicit row deletion.

## Slide 71: Which steady measurements are absent?

Source note: `missing-data/complete-case-analysis.qmd`

Duration, F0, and steady F1 are observed for every token. 10 tokens lack steady F2 while retaining steady F3; 41 lack steady F3 while retaining steady F2; none lacks both. Thus the 51 incomplete tokens are the union of two disjoint patterns in this five-variable analysis.

## Slide 72: Deletion changes the observed composition

Source note: `missing-data/complete-case-analysis.qmd`

Duration, F0, and F1 remain observed for both analysis sets, so they can expose selection without pretending to reveal the missing F2 or F3 values.

## Slide 73: Deletion changes the observed composition

Source note: `missing-data/complete-case-analysis.qmd`

The incomplete tokens average 304.73 ms, while the complete tokens average 273.72 ms. The corresponding F0 means are 209.20 and 196.64 Hz. These differences show that deletion selects on measurements we can inspect. They do not identify why F2 or F3 is unavailable.

## Slide 74: Deletion changes the observed composition

Source note: `missing-data/complete-case-analysis.qmd`

The selection also varies by vowel label.

## Slide 75: Deletion changes the observed composition

Source note: `missing-data/complete-case-analysis.qmd`

This figure shows observed linguistic data for Deletion changes the observed composition.

## Slide 76: Deletion changes the observed composition

Source note: `missing-data/complete-case-analysis.qmd`

The released `er` category has 15 incomplete tokens. By contrast, the released `eh`, `ih`, and `oo` categories have none. This is an empirical composition difference, not a diagnosis of the signal or the tracking procedure.

## Slide 77: Several columns determine joint retention

Source note: `missing-data/complete-case-analysis.qmd`

Even high marginal availability does not determine the complete-case rate. In general,

$$
\mathbb{P}(C_i=1)
=\mathbb{P}\left(\bigcap_{j\in J}\{R_{ij}=1\}\right).
$$

## Slide 78: Several columns determine joint retention

Source note: `missing-data/complete-case-analysis.qmd`

If the indicators were independent, this joint probability would equal $\prod_{j\in J}\mathbb{P}(R_{ij}=1)$. The released data let us compare that independence calculation with the observed joint rate without inventing marginal probabilities.

## Slide 79: Several columns determine joint retention

Source note: `missing-data/complete-case-analysis.qmd`

The product is 96.96%, while the observed complete-case rate is 96.94%. Their proximity here is a feature of this release’s marginal rates and F2/F3 pattern; it is not a general property of complete-case deletion.

## Slide 80: When does deletion preserve a target?

Source note: `missing-data/complete-case-analysis.qmd`

Under MCAR with respect to the variables in a stated analysis, complete rows form a random subset, so familiar complete-case estimates may preserve their full-data targets. MAR does not provide this guarantee automatically. If formant availability depends on observed duration or vowel and these variables are related to the estimand, unadjusted deletion may change the relevant distribution.

## Slide 81: When does deletion preserve a target?

Source note: `missing-data/complete-case-analysis.qmd`

The condition also depends on the estimand. Missingness in a response and missingness in a predictor do not have identical consequences for every estimate. Thus a report should state which variables define $J$, how many rows remain, and which complete-row population the estimate describes.

## Slide 82: When does deletion preserve a target?

Source note: `missing-data/complete-case-analysis.qmd`

Complete-case analysis may be reasonable when missingness is rare, the retained sample remains adequate, and the selection assumptions are plausible for the target. These are substantive conditions, not properties conferred by `complete.cases()`.

## Slide 83: When does deletion preserve a target?

Source note: `missing-data/complete-case-analysis.qmd`

Store the complete-case indicator. Report the variables used to define it, the numbers retained and removed, and observed differences between the two sets.

## Slide 84: Checking the deletion claim

Source note: `missing-data/complete-case-analysis.qmd`

Which five measurements define $J$ here?

## Slide 85: Checking the deletion claim

Source note: `missing-data/complete-case-analysis.qmd`

What does the F2-by-F3 pattern show that the two column totals do not?

## Slide 86: Checking the deletion claim

Source note: `missing-data/complete-case-analysis.qmd`

Which observed measurements distinguish the complete and incomplete sets?

## Slide 87: Checking the deletion claim

Source note: `missing-data/complete-case-analysis.qmd`

Why can those differences expose selection without identifying the missing F2 or F3 values?

## Slide 88: Checking the deletion claim

Source note: `missing-data/complete-case-analysis.qmd`

Complete-case analysis retains rows observed on every required variable. In the Hillenbrand release, it removes 51 tokens and changes the observed composition of the analysis set. Iterative PCA imputation instead predicts missing matrix entries under a low-rank assumption; it changes the modeling assumptions rather than recovering an unobserved measurement.

## Slide 89: Checking the deletion claim

Source note: `missing-data/complete-case-analysis.qmd`

Previous: Missingness mechanisms · Next: Iterative PCA imputation.

## Slide 90: Iterative PCA imputation

Source note: `missing-data/pca-imputation.qmd`

Now we turn to Iterative PCA imputation.

## Slide 91: Iterative PCA imputation

Source note: `missing-data/pca-imputation.qmd`

The complete-case analysis discarded a Hillenbrand token whenever one of five steady measurements was unavailable. We now retain the tokens and ask whether the other acoustic measurements predict an unavailable formant estimate. The result is a prediction of a released acoustic cell, not a recovered observation from the recording.

## Slide 92: Iterative PCA imputation

Source note: `missing-data/pca-imputation.qmd`

**Iterative PCA imputation** repeatedly uses a rank-$K$ reconstruction to update missing cells while returning observed cells to their measured values. Principal components and matrix reconstruction have already been introduced; the new object is the update procedure.

## Slide 93: Iterative PCA imputation

Source note: `missing-data/pca-imputation.qmd`

Review centering and scaling, principal component analysis, and rank-$K$ reconstruction. The treatment of choosing the number of components supplies the holdout logic used below.

## Slide 94: Constructing the acoustic matrix

Source note: `missing-data/pca-imputation.qmd`

The source and measurement process are introduced on the preceding page. We use the full continuous acoustic matrix: duration, F0, and the steady plus contour samples for F1--F3.

## Slide 95: Constructing the acoustic matrix

Source note: `missing-data/pca-imputation.qmd`

The matrix has 1,668 token rows and 29 acoustic columns. Its 379 naturally missing cells occur in 14 F2 or F3 columns. Duration, F0, and all F1 columns are complete.

## Slide 96: Defining the standardized update

Source note: `missing-data/pca-imputation.qmd`

Let $\mathbf{Y}$ be the incomplete acoustic matrix and let $M$ contain the cells treated as missing in a particular fit. Each fit estimates a center $\widehat\mu_j$ and scale $\widehat s_j$ from its observed training cells, then forms

$$
Z_{ij}=\frac{Y_{ij}-\widehat\mu_j}{\widehat s_j}
$$

where $Y_{ij}$ is available.

## Slide 97: Defining the standardized update

Source note: `missing-data/pca-imputation.qmd`

Missing standardized cells begin at zero, which is the training-column mean after standardization. At iteration $t$, the rank-$K$ reconstruction is

$$
\widehat{\mathbf Z}^{(t)}_K
=\mathbf U^{(t)}_K\mathbf D^{(t)}_K
\mathbf V_K^{(t)\mathsf T}.
$$

## Slide 98: Defining the standardized update

Source note: `missing-data/pca-imputation.qmd`

One update is

$$
Z_{ij}^{(t+1)}=
\begin{cases}
Z_{ij} & \text{if }(i,j)\notin M,\\
\widehat Z_{K,ij}^{(t)} & \text{if }(i,j)\in M.
\end{cases}
$$

## Slide 99: Defining the standardized update

Source note: `missing-data/pca-imputation.qmd`

Thus only the missing cells change. We stop when their relative squared change is below $10^{-6}$,

$$
\frac{
  \sum_{(i,j)\in M}
  \left(Z_{ij}^{(t+1)}-Z_{ij}^{(t)}\right)^2
}{
  \sum_{(i,j)\in M}\left(Z_{ij}^{(t)}\right)^2
}<10^{-6},
$$

or after 1,000 iterations.

## Slide 100: Implementing the algorithm in base R

Source note: `missing-data/pca-imputation.qmd`

The function returns the completed matrix, training centers and scales, and convergence diagnostics. Rank zero is the training-column-mean reference.

## Slide 101: Implementing the algorithm in base R

Source note: `missing-data/pca-imputation.qmd`

the calculation estimates $\widehat\mu_j$ and $\widehat s_j$ before filling cells. A masked target thus cannot affect its own center or scale.

## Slide 102: Choosing rank with registered masks

Source note: `missing-data/pca-imputation.qmd`

The number of retained components controls which relations can inform a missing cell. We compare $K\in\{0,1,2,3,4,5,8,10,12,15,20\}$ using eight registered validation masks. Each mask hides 5% of the naturally observed cells in every fallible column. Four smaller test masks are created afterward; their union is removed from every validation fit, so rank choice cannot use any test target directly or through preprocessing.

## Slide 103: Choosing rank with registered masks

Source note: `missing-data/pca-imputation.qmd`

The masks are generated sequentially, so no cell appears in more than one. The following function scores only a validation mask, after also removing the entire test union.

## Slide 104: Choosing rank with registered masks

Source note: `missing-data/pca-imputation.qmd`

This figure shows observed linguistic data for Choosing rank with registered masks.

## Slide 105: Choosing rank with registered masks

Source note: `missing-data/pca-imputation.qmd`

Rank 10 has the lowest validation RMSE, 0.095. The curve falls from 0.997 at rank zero before rising again beyond the selected rank. This selection uses only validation targets; the next page evaluates the choice on the untouched test masks.

## Slide 106: Predicting the naturally missing cells

Source note: `missing-data/pca-imputation.qmd`

After rank selection, we fit rank 10 to the original matrix. Observed cells are copied back exactly. The remaining values are labeled predictions.

## Slide 107: Predicting the naturally missing cells

Source note: `missing-data/pca-imputation.qmd`

The final fit supplies predictions for all 379 natural omissions. The table deliberately calls them `predicted_value_hz`; there is no observed target against which to calculate their error.

## Slide 108: Imputed values remain estimates

Source note: `missing-data/pca-imputation.qmd`

A completed matrix may look indistinguishable from an observed matrix in software. The two kinds of cells are not epistemically equivalent. An observed cell contains an estimate obtained from the recorded signal. An imputed cell contains a prediction under a linear low-rank assumption, training centers and scales, the selected rank, and an initialization rule.

## Slide 109: Imputed values remain estimates

Source note: `missing-data/pca-imputation.qmd`

Using one completed matrix in a later analysis treats these predictions as fixed and may understate the uncertainty created by the missing measurements. A procedure that propagates imputation uncertainty requires more machinery than this single reconstruction. The completed data should thus retain the observation indicator.

## Slide 110: Imputed values remain estimates

Source note: `missing-data/pca-imputation.qmd`

PCA imputation may also pull unusual but real measurements toward the leading linear components. A rare vowel category, a nonlinear acoustic relation, or an extreme value can be reconstructed poorly even when the algorithm converges. Numerical convergence diagnoses the update, not the substantive adequacy of the low-rank representation.

## Slide 111: Checking the reconstruction

Source note: `missing-data/pca-imputation.qmd`

Which cells may change after each rank-$K$ reconstruction?

## Slide 112: Checking the reconstruction

Source note: `missing-data/pca-imputation.qmd`

Where are the centers and scales estimated in the validation procedure?

## Slide 113: Checking the reconstruction

Source note: `missing-data/pca-imputation.qmd`

Why is rank zero a column-mean reference on the standardized scale?

## Slide 114: Checking the reconstruction

Source note: `missing-data/pca-imputation.qmd`

What does the final fit establish about the 379 natural omissions, and what remains unknown?

## Slide 115: Checking the reconstruction

Source note: `missing-data/pca-imputation.qmd`

Iterative PCA imputation alternates between rank-$K$ reconstruction and replacement of cells treated as missing. It preserves observed cells, but its predictions depend on a low-rank model and a validation-selected component count. We next test that selected procedure by masking values that were actually observed.

## Slide 116: Checking the reconstruction

Source note: `missing-data/pca-imputation.qmd`

Previous: Complete-case analysis · Next: Validating imputation.

## Slide 117: Validating an imputation procedure

Source note: `missing-data/validating-imputation.qmd`

Now we turn to Validating an imputation procedure.

## Slide 118: Validating an imputation procedure

Source note: `missing-data/validating-imputation.qmd`

The values of the naturally missing Hillenbrand formant cells are unavailable. No direct error can compare their PCA predictions with unseen measurements. We can ask a narrower question: when an available F2 or F3 estimate is hidden on purpose, how accurately does the complete procedure reconstruct it?

## Slide 119: Validating an imputation procedure

Source note: `missing-data/validating-imputation.qmd`

**Holdout validation by artificial masking** turns observed cells into artificial missing cells, fits the imputation without those values, and compares their reconstructions with the values set aside. This applies training and test separation to matrix cells. The masking creates known targets while preserving the rule that a target cannot guide its own prediction.

## Slide 120: Defining the validation error

Source note: `missing-data/validating-imputation.qmd`

Let $O$ be the naturally observed cells and let $M_r\subset O$ be the cells hidden in mask replicate $r$. After fitting without $M_r$, the reconstruction of cell $(i,j)$ is $\widehat y_{ij}^{(-M_r)}$. Its mean squared reconstruction error is

$$
\operatorname{MSE}(M_r)
=\frac{1}{|M_r|}
\sum_{(i,j)\in M_r}
\left(y_{ij}-\widehat y_{ij}^{(-M_r)}\right)^2.
$$

## Slide 121: Defining the validation error

Source note: `missing-data/validating-imputation.qmd`

The superscript $(-M_r)$ records that the targets did not enter fitting. Because the acoustic columns have different scales, rank selection uses training-standardized error,

$$
\operatorname{RMSE}_{z}
=\sqrt{
  \frac{1}{\sum_r|M_r|}
  \sum_r\sum_{(i,j)\in M_r}
  \left(
    \frac{y_{ij}-\widehat y_{ij}^{(-M_r)}}
         {\widehat s_j^{(-M_r)}}
  \right)^2
},
$$

where $\widehat s_j^{(-M_r)}$ is estimated after masking.

## Slide 122: Defining the validation error

Source note: `missing-data/validating-imputation.qmd`

Test results are then reported in hertz separately for F2 and F3.

## Slide 123: Loading the matrix and the imputation function

Source note: `missing-data/validating-imputation.qmd`

This page runs independently. It reloads the raw Hillenbrand release introduced earlier, rebuilds the full acoustic matrix, and defines the same standardized iterative PCA algorithm used on the preceding page.

## Slide 124: Recreating the disjoint masks

Source note: `missing-data/validating-imputation.qmd`

Seeds `20261018` through `20261025` identify eight validation masks, each hiding 5% of observed cells within every fallible column. Seeds `20261026` through `20261029` identify four test masks, each hiding 1.25% per fallible column. Masks are created sequentially so that their targets are disjoint.

## Slide 125: Recreating the disjoint masks

Source note: `missing-data/validating-imputation.qmd`

Every artificial target is thus an observed value in the source table, and no target appears in two replicates. The split contains 9,128 validation cells and 1,120 test cells.

## Slide 126: Selecting rank without test leakage

Source note: `missing-data/validating-imputation.qmd`

The validation fits remove both the current validation mask and the entire test union. Thus no test value contributes to a validation prediction, a column center or scale, a component direction, or the selected rank.

## Slide 127: Selecting rank without test leakage

Source note: `missing-data/validating-imputation.qmd`

The validation criterion selects rank 10, with standardized RMSE 0.095. The test cells remain untouched until this choice is fixed.

## Slide 128: Evaluating the selected rank on untouched cells

Source note: `missing-data/validating-imputation.qmd`

Each test fit hides its registered test mask. We compare rank 10 with rank zero, the training-column-mean reference.

## Slide 129: Evaluating the selected rank on untouched cells

Source note: `missing-data/validating-imputation.qmd`

On 560 untouched F2 cells, rank 10 has RMSE 41.43 Hz, compared with 574.60 Hz for the column-mean reference. On the same number of F3 cells, the corresponding RMSEs are 38.79 and 438.03 Hz. Mean signed error under rank 10 is 2.72 Hz for F2 and 1.89 Hz for F3.

## Slide 130: Evaluating the selected rank on untouched cells

Source note: `missing-data/validating-imputation.qmd`

This figure shows observed linguistic data for Evaluating the selected rank on untouched cells.

## Slide 131: Evaluating the selected rank on untouched cells

Source note: `missing-data/validating-imputation.qmd`

The raw held-out measurements and model predictions appear in the same figure. The diagonal is an identity reference, not a fitted regression line.

## Slide 132: What this validation targets

Source note: `missing-data/validating-imputation.qmd`

This is cell-level, transductive validation. The other measurements from the same token remain available because the intended use is to fill isolated F2 or F3 cells in an existing acoustic matrix. The results do not estimate prediction for a new speaker, a new vowel inventory, or a token with an entire contour absent.

## Slide 133: What this validation targets

Source note: `missing-data/validating-imputation.qmd`

The masks are random within the 14 naturally fallible columns. They preserve the measurement columns but do not reproduce the observed dependence of natural missingness on vowel or value. Low test error thus supports interpolation under these registered masks. It does not establish unbiased reconstruction of the 379 naturally missing cells.

## Slide 134: What this validation targets

Source note: `missing-data/validating-imputation.qmd`

Using the full matrix to calculate centers, scales, components, or rank would give held-out values an indirect path into their predictions. This is leakage through preprocessing. the calculation above prevents it by estimating every preprocessing quantity after masking and by excluding the test union throughout rank selection.

## Slide 135: What this validation targets

Source note: `missing-data/validating-imputation.qmd`

An overall error may still hide poor reconstruction for a vowel, speaker group, or measurement column. The prediction table retains token, vowel, formant, and measurement identifiers so those errors can be inspected at the level of a later linguistic claim.

## Slide 136: Auditing the validation

Source note: `missing-data/validating-imputation.qmd`

Why can the naturally missing cells not supply a direct reconstruction error?

## Slide 137: Auditing the validation

Source note: `missing-data/validating-imputation.qmd`

Which quantities are estimated after the target cells are masked?

## Slide 138: Auditing the validation

Source note: `missing-data/validating-imputation.qmd`

Why is the entire test union removed from every validation fit?

## Slide 139: Auditing the validation

Source note: `missing-data/validating-imputation.qmd`

Which prediction target is represented by leaving other measurements from the same token available?

## Slide 140: Auditing the validation

Source note: `missing-data/validating-imputation.qmd`

What does low error under these masks fail to establish about the natural omissions?

## Slide 141: Auditing the validation

Source note: `missing-data/validating-imputation.qmd`

Holdout validation by artificial masking evaluates an imputation procedure on observed values made unavailable during fitting. Under the registered masks, rank 10 predicts held-out F2 and F3 cells more accurately than the column-mean reference. This result supports one cell-reconstruction target; it does not turn predictions for naturally missing cells into measurements.

## Slide 142: Auditing the validation

Source note: `missing-data/validating-imputation.qmd`

Previous: Iterative PCA imputation · Next: Custom models.
