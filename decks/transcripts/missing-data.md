# Missing linguistic data

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Missing linguistic data

Source note: `missing-data/index.qmd`

Welcome to Missing linguistic data. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Missing data

Source note: `missing-data/index.qmd`

We now turn to Missing data. Missingness is a relation among a linguistic unit, an intended measurement, and its realized record. A blank cell does not identify that relation by itself. The **missing-data specification (MDS)** names the unit, the measurement that should have been available, and the process that made an observed value unavailable.

## Slide 3: Hillenbrand et al. (1995): the empirical object

Source note: `missing-data/index.qmd`

This is the first use of Hillenbrand et al. (1995) in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 4: Missing data

Source note: `missing-data/index.qmd`

Missingness is a relation among a linguistic unit, an intended measurement, and its realized record. A blank cell does not identify that relation by itself. The **missing-data specification (MDS)** names the unit, the measurement that should have been available, and the process that made an observed value unavailable. This module develops the MDS with two audited linguistic resources. The first is the MIT-licensed Tanaka sentence collection in Jacy, whose Redwoods-style selection workflow is described by Tanaka et al. (2005) and Bond, Kuribayashi, and Hashimoto (2008). Its outcome is availability of a grammar-generated, human-selected analysis. Keep the observational unit fixed while you interpret the result.

## Slide 5: What counts as missing?

Source note: `missing-data/index.qmd`

Several superficially similar absences still require different analyses. - **An absent record:** a speaker who was never recruited or a corpus token that was never sampled has no row. This is a sampling or coverage problem, not a missing cell in the realized table. - **Planned missingness:** a counterbalanced experiment may deliberately leave some participant--item combinations unpresented. Those omissions belong to the design; they are not accidental nonresponses. Use the graph or equation to say the result in ordinary language.

## Slide 6: From locations to assumptions

Source note: `missing-data/index.qmd`

We proceed in two steps. First, missingness patterns represent which intended values are observed. The indicator describes locations; it does not explain them. Second, missingness mechanisms state how the probability of observation may depend on named observed and unobserved variables. This distinction parallels the separation between a sampling design and an outcome model. The pattern is observed data. The mechanism is an assumption about the process that produced that pattern. Notice what is observed and what is supplied by the model.

## Slide 7: Deletion, reconstruction, and checking

Source note: `missing-data/index.qmd`

Complete-case analysis retains rows observed on every variable required by a particular analysis. It thus defines a selection indicator. If selection depends on the response or a predictor, the retained rows may describe a different population from the eligible rows. Iterative PCA imputation takes a different route. It uses the rank-$K$ reconstruction of a completed matrix to update its missing cells while returning observed cells to their measured values. The resulting number is a model-based prediction under a low-rank assumption. It is not a recovered observation, and a single completed matrix does not propagate uncertainty about the prediction. Notice what is observed and what is supplied by the model.

## Slide 8: Interpretation

Source note: `missing-data/index.qmd`

The order of the module follows the decisions an analysis requires: (i) specify what should have been observed, (ii) describe where it is absent, (iii) state assumptions about why, (iv) make deletion explicit, (v) define one reconstruction method, and (vi) test that method under registered artificial masks. Now connect the notation back to the linguistic comparison.

## Slide 9: Missingness patterns

Source note: `missing-data/missingness-patterns.qmd`

We now turn to Missingness patterns. The Tanaka corpus provides a useful first case because its absences arise inside a linguistic analysis pipeline, not from an invented table. In the Redwoods-style workflow described by Tanaka et al. (2005), the Jacy grammar generates analyses for a Japanese sentence and a human annotator selects among them using discriminants. Bond, Kuribayashi, and Hashimoto (2008) describe the Tanaka annotation cycle.

## Slide 10: Jacy: the empirical object

Source note: `missing-data/missingness-patterns.qmd`

This is the first use of Jacy in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 11: Missingness patterns

Source note: `missing-data/missingness-patterns.qmd`

The Tanaka corpus provides a useful first case because its absences arise inside a linguistic analysis pipeline, not from an invented table. In the Redwoods-style workflow described by Tanaka et al. (2005), the Jacy grammar generates analyses for a Japanese sentence and a human annotator selects among them using discriminants. We use the current profile extract from the official Jacy documentation and the pinned Jacy release. The row unit is one sentence in one `[incr tsdb()]` profile. This release is later than the annotation stage reported in the 2008 paper, so the empirical counts below describe the pinned release rather than reproducing the paper's table. That distinction will matter again on the next slide.

## Slide 12: Loading and checking the profile table

Source note: `missing-data/missingness-patterns.qmd`

The table has observed items and observed preference records. Those are different units: observed items have more than one accepted result. Thus the selected-item count is observed, not the number of preference records. The Tanaka corpus provides a useful first case because its absences arise inside a linguistic analysis pipeline, not from an invented table. In the Redwoods-style workflow described by Tanaka et al. (2005), the Jacy grammar generates analyses for a Japanese sentence and a human annotator selects among them using discriminants. Bond, Kuribayashi, and Hashimoto (2008) describe the Tanaka annotation cycle. That distinction will matter again on the next slide.

## Slide 13: From a binary indicator to three observed states

Source note: `missing-data/missingness-patterns.qmd`

Let $Y_i$ denote a downstream quantity calculated from the selected MRS for item $i$. Its availability indicator is The binary indicator records whether $Y_i$ is available, but it merges two observed pipeline outcomes. Some unselected items have positive parse readings, while others have no positive reading recorded. We thus define the **selected-analysis availability pattern (SAAP)** as Keep the observational unit fixed while you interpret the result.

## Slide 14: From a binary indicator to three observed states: equation 1

Source note: `missing-data/missingness-patterns.qmd`

The displayed expression formalizes from a binary indicator to three observed states: equation 1. Let $Y_i$ denote a downstream quantity calculated from the selected MRS for item $i$. Its availability indicator is Keep track of what each term refers to in the linguistic dataset.

## Slide 15: From a binary indicator to three observed states: equation 2

Source note: `missing-data/missingness-patterns.qmd`

The displayed expression formalizes from a binary indicator to three observed states: equation 2. The binary indicator records whether $Y_i$ is available, but it merges two observed pipeline outcomes. Some unselected items have positive parse readings, while others have no positive reading recorded. We thus define the **selected-analysis availability pattern (SAAP)** as Keep track of what each term refers to in the linguistic dataset.

## Slide 16: The pattern varies across profiles

Source note: `missing-data/missingness-patterns.qmd`

The same states can be summarized within each profile. This plot shows the observed composition directly; it does not attach a causal explanation to the differences. The SAAP locates where a selected grammar analysis is and is not available. It does not show that an unselected sentence lacks a meaning, is ungrammatical, or is rare in Japanese usage. Keep the observational unit fixed while you interpret the result.

## Slide 17: A pattern does not identify its mechanism

Source note: `missing-data/missingness-patterns.qmd`

A missingness pattern is observed data. A missingness mechanism is an assumption about the process that produced it. The profile differences above may challenge a description in which selected analyses are equally available everywhere, but they cannot establish why selection varies. This boundary matters for downstream MRS analyses. Restricting attention to selected items changes the analyzed population to sentences for which this grammar-and-selection pipeline supplied an accepted analysis. That population may be appropriate for a narrowly stated grammar evaluation. It is not automatically a sample of all Japanese sentences. That distinction will matter again on the next slide.

## Slide 18: Inspecting the pattern

Source note: `missing-data/missingness-patterns.qmd`

1. Why are `preferred_analysis_count` and the number of selected items different units? 2. What information is lost when the three SAAP states are collapsed to $R_i$? 3. Why must `parse_readings = -1` be treated as a sentinel rather than a count? 4. A selected-analysis indicator represents availability, while the three-state SAAP retains the observed distinction between parsing and selection outcomes. Neither object identifies its own cause. The next page asks what the association with observed profile length can and cannot establish. Notice what is observed and what is supplied by the model.

## Slide 19: Missingness patterns

Source note: `missing-data/missingness-patterns.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Missingness patterns. Read the pattern before attaching a model interpretation to it.

## Slide 20: Missingness patterns

Source note: `missing-data/missingness-patterns.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Missingness patterns. Read the pattern before attaching a model interpretation to it.

## Slide 21: Interpretation

Source note: `missing-data/missingness-patterns.qmd`

Previous: Missing data · Next: Missingness mechanisms The interpretation is conditional on the sampling and measurement design.

## Slide 22: Missingness mechanisms

Source note: `missing-data/missingness-mechanisms.qmd`

We now turn to Missingness mechanisms. The preceding page introduced the Jacy selected-analysis availability pattern (SAAP). We now ask whether the binary outcome $S_i=1$ for a selected analysis is associated with two measurements observed for every profile item: its profile and its released token count. This is a descriptive question about the pinned release. It is not yet a diagnosis of why an analysis is unavailable.

## Slide 23: Missingness mechanisms

Source note: `missing-data/missingness-mechanisms.qmd`

The preceding page introduced the Jacy selected-analysis availability pattern (SAAP). We now ask whether the binary outcome $S_i=1$ for a selected analysis is associated with two measurements observed for every profile item: its profile and its released token count. This is a descriptive question about the pinned release. A **missingness mechanism** states how an observation probability depends on observed and unobserved quantities. The three standard mechanisms make different conditional-dependence claims. They do not name three visual arrangements of blank cells. Use the graph or equation to say the result in ordinary language.

## Slide 24: Separating observed and unobserved quantities

Source note: `missing-data/missingness-mechanisms.qmd`

Let $Y_i$ be an intended measurement that is unavailable when $R_i=0$, and let $X_i$ collect quantities observed regardless of availability. The observation mechanism concerns The labels MCAR, MAR, and MNAR restrict which named quantities that probability may depend on. Keep the observational unit fixed while you interpret the result.

## Slide 25: Separating observed and unobserved quantities: equation 1

Source note: `missing-data/missingness-mechanisms.qmd`

The displayed expression formalizes separating observed and unobserved quantities: equation 1. Let $Y_i$ be an intended measurement that is unavailable when $R_i=0$, and let $X_i$ collect quantities observed regardless of availability. The observation mechanism concerns Keep track of what each term refers to in the linguistic dataset.

## Slide 26: Separating observed and unobserved quantities: equation 2

Source note: `missing-data/missingness-mechanisms.qmd`

The displayed expression formalizes separating observed and unobserved quantities: equation 2. The labels MCAR, MAR, and MNAR restrict which named quantities that probability may depend on. Keep track of what each term refers to in the linguistic dataset.

## Slide 27: Separating observed and unobserved quantities: equation 3

Source note: `missing-data/missingness-mechanisms.qmd`

The displayed expression formalizes separating observed and unobserved quantities: equation 3. Values are **missing completely at random (MCAR)** when the observation probability depends on neither the observed covariates nor the unobserved measurement: Keep track of what each term refers to in the linguistic dataset.

## Slide 28: Separating observed and unobserved quantities: equation 4

Source note: `missing-data/missingness-mechanisms.qmd`

The displayed expression formalizes separating observed and unobserved quantities: equation 4. Under this account, observed rows form a random subset with respect to the variables in the statement. Failure to find a visible association would not establish MCAR, because a finite dataset contains no direct information about the missing $Y_i$ values. Keep track of what each term refers to in the linguistic dataset.

## Slide 29: Loading the Jacy availability outcome

Source note: `missing-data/missingness-mechanisms.qmd`

The row unit and sources are documented on the Jacy pattern page. Here $S_i$ marks whether at least one grammar analysis has an accepted preference record, $L_i$ is standardized released token count, and $P_i$ is profile. The descriptive model is Keep the observational unit fixed while you interpret the result.

## Slide 30: Loading the Jacy availability outcome

Source note: `missing-data/missingness-mechanisms.qmd`

The displayed expression formalizes loading the jacy availability outcome. The row unit and sources are documented on the Jacy pattern page. Here $S_i$ marks whether at least one grammar analysis has an accepted preference record, $L_i$ is standardized released token count, and $P_i$ is profile. Keep track of what each term refers to in the linguistic dataset.

## Slide 31: Raw proportions and the fitted model

Source note: `missing-data/missingness-mechanisms.qmd`

We plot the raw selection proportion at each released token count together with the model's mean fitted probability among items of that length. Point size records the number of items but is left unlabelled to keep the graph focused. The raw and fitted quantities decrease as released token count increases, conditional on the model's profile terms. This pattern challenges an equal-availability description with respect to these observed covariates. It does not show that longer Japanese sentences are intrinsically less grammatical, meaningful, or frequent. Now connect the notation back to the linguistic comparison.

## Slide 32: Why the association does not classify the mechanism

Source note: `missing-data/missingness-mechanisms.qmd`

If a downstream MRS property is the intended $Y_i$, selection is its availability indicator. But for an item with no acceptable grammar analysis, the counterfactual value of that property may itself require a more precise definition. Even under such a specification, the plot contains $S_i$, profile, and length, not the unavailable $Y_i$. The association is compatible with an MAR account based on observed pipeline covariates. It is also compatible with an MNAR account involving properties of an unavailable acceptable analysis. And profile or length may stand in for unrecorded stages of parsing and annotation. The interpretation is conditional on the sampling and measurement design.

## Slide 33: Classifying the claim

Source note: `missing-data/missingness-mechanisms.qmd`

1. Which dependence is removed by MCAR but permitted by MAR? 2. Why does the fitted length association challenge equal availability without establishing MAR? 3. What additional dependence would make the mechanism MNAR for a defined downstream MRS quantity? 4. A missingness mechanism restricts how availability may depend on named observed and unavailable quantities. The Jacy model establishes an association with observed profile length and profile in the pinned release; it does not identify a causal mechanism. The next page turns to a raw acoustic table in which the intended measurements and complete rows are directly defined. Notice what is observed and what is supplied by the model.

## Slide 34: Missingness mechanisms

Source note: `missing-data/missingness-mechanisms.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Missingness mechanisms. Read the pattern before attaching a model interpretation to it.

## Slide 35: Missingness mechanisms

Source note: `missing-data/missingness-mechanisms.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Missingness mechanisms. Read the pattern before attaching a model interpretation to it.

## Slide 36: Interpretation

Source note: `missing-data/missingness-mechanisms.qmd`

Previous: Missingness patterns · Next: Complete-case analysis Keep the observational unit fixed while you interpret the result.

## Slide 37: Complete-case analysis

Source note: `missing-data/complete-case-analysis.qmd`

We now turn to Complete-case analysis. Hillenbrand et al. (1995) recorded men, women, and children producing American English vowels in /hVd/ words. They measured formant contours from LPC spectra with interactive editing and selected the steady-state sample by visual inspection. We use the pinned raw-data release, whose table retains unavailable formant measurements as `NA`.

## Slide 38: Complete-case analysis

Source note: `missing-data/complete-case-analysis.qmd`

Hillenbrand et al. (1995) recorded men, women, and children producing American English vowels in /hVd/ words. They measured formant contours from LPC spectra with interactive editing and selected the steady-state sample by visual inspection. We use the pinned raw-data release, whose table retains unavailable formant measurements as `NA`. The row unit is one speaker-by-vowel token. The exact missing-cell pattern is a property of the released table, not a count reported in the 1995 article. An `NA` means that this release contains no usable numeric estimate in the intended cell; it does not mean 0 Hz, and the release does not name a cell-specific cause. That distinction will matter again on the next slide.

## Slide 39: Defining the analysis set

Source note: `missing-data/complete-case-analysis.qmd`

**Complete-case analysis**, also called listwise deletion, retains only rows observed on every variable required by an analysis. Let $J$ be that set of variables. For token $i$, Because each $R_{ij}$ is zero or one, $C_i=1$ only when every required value is observed. A complete-case estimate of a mean is Now connect the notation back to the linguistic comparison.

## Slide 40: Defining the analysis set: equation 1

Source note: `missing-data/complete-case-analysis.qmd`

The displayed expression formalizes defining the analysis set: equation 1. **Complete-case analysis**, also called listwise deletion, retains only rows observed on every variable required by an analysis. Let $J$ be that set of variables. For token $i$, Keep track of what each term refers to in the linguistic dataset.

## Slide 41: Defining the analysis set: equation 2

Source note: `missing-data/complete-case-analysis.qmd`

The displayed expression formalizes defining the analysis set: equation 2. Because each $R_{ij}$ is zero or one, $C_i=1$ only when every required value is observed. A complete-case estimate of a mean is Keep track of what each term refers to in the linguistic dataset.

## Slide 42: Which steady measurements are absent?

Source note: `missing-data/complete-case-analysis.qmd`

Duration, F0, and steady F1 are observed for every token. observed tokens lack steady F2 while retaining steady F3; observed lack steady F3 while retaining steady F2; none lacks both. Thus the observed incomplete tokens are the union of two disjoint patterns in this five-variable analysis. Hillenbrand et al. (1995) recorded men, women, and children producing American English vowels in /hVd/ words. They measured formant contours from LPC spectra with interactive editing and selected the steady-state sample by visual inspection. We use the pinned raw-data release, whose table retains unavailable formant measurements as `NA`. Notice what is observed and what is supplied by the model.

## Slide 43: Deletion changes the observed composition

Source note: `missing-data/complete-case-analysis.qmd`

Duration, F0, and F1 remain observed for both analysis sets, so they can expose selection without pretending to reveal the missing F2 or F3 values. The incomplete tokens average observed ms, while the complete tokens average observed ms. The corresponding F0 means are observed and observed Hz. These differences show that deletion selects on measurements we can inspect. They do not identify why F2 or F3 is unavailable. Notice what is observed and what is supplied by the model.

## Slide 44: Several columns determine joint retention

Source note: `missing-data/complete-case-analysis.qmd`

Even high marginal availability does not determine the complete-case rate. In general, If the indicators were independent, this joint probability would equal $\prod_{j\in J}P(R_{ij}=1)$. The released data let us compare that independence calculation with the observed joint rate without inventing marginal probabilities. That distinction will matter again on the next slide.

## Slide 45: Several columns determine joint retention

Source note: `missing-data/complete-case-analysis.qmd`

The displayed expression formalizes several columns determine joint retention. Even high marginal availability does not determine the complete-case rate. In general, Keep track of what each term refers to in the linguistic dataset.

## Slide 46: When does deletion preserve a target?

Source note: `missing-data/complete-case-analysis.qmd`

Under MCAR with respect to the variables in a stated analysis, complete rows form a random subset, so familiar complete-case estimates may preserve their full-data targets. MAR does not provide this guarantee automatically. The condition also depends on the estimand. Missingness in a response and missingness in a predictor do not have identical consequences for every estimate. Thus a report should state which variables define $J$, how many rows remain, and which complete-row population the estimate describes. Now connect the notation back to the linguistic comparison.

## Slide 47: Checking the deletion claim

Source note: `missing-data/complete-case-analysis.qmd`

1. Which five measurements define $J$ here? 2. What does the F2-by-F3 pattern show that the two column totals do not? 3. Which observed measurements distinguish the complete and incomplete sets? 4. Why can those differences expose selection without identifying the missing F2 or F3 values? Complete-case analysis retains rows observed on every required variable. In the Hillenbrand release, it removes observed tokens and changes the observed composition of the analysis set. Iterative PCA imputation instead predicts missing matrix entries under a low-rank assumption; it changes the modeling assumptions rather than recovering an unobserved measurement. Now connect the notation back to the linguistic comparison.

## Slide 48: Complete-case analysis

Source note: `missing-data/complete-case-analysis.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Complete-case analysis. Read the pattern before attaching a model interpretation to it.

## Slide 49: Complete-case analysis

Source note: `missing-data/complete-case-analysis.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Complete-case analysis. Read the pattern before attaching a model interpretation to it.

## Slide 50: Interpretation

Source note: `missing-data/complete-case-analysis.qmd`

Previous: Missingness mechanisms · Next: Iterative PCA imputation That distinction will matter again on the next slide.

## Slide 51: Iterative PCA imputation

Source note: `missing-data/pca-imputation.qmd`

We now turn to Iterative PCA imputation. The complete-case analysis discarded a Hillenbrand token whenever one of five steady measurements was unavailable. We now retain the tokens and ask whether the other acoustic measurements predict an unavailable formant estimate. This is the **formant reconstruction target (FRT)**: a prediction of a released acoustic cell, not a recovered observation from the recording.

## Slide 52: Iterative PCA imputation

Source note: `missing-data/pca-imputation.qmd`

The complete-case analysis discarded a Hillenbrand token whenever one of five steady measurements was unavailable. We now retain the tokens and ask whether the other acoustic measurements predict an unavailable formant estimate. **Iterative PCA imputation** repeatedly uses a rank-$K$ reconstruction to update missing cells while returning observed cells to their measured values. Principal components and matrix reconstruction have already been introduced; the new object is the update procedure. That distinction will matter again on the next slide.

## Slide 53: Constructing the acoustic matrix

Source note: `missing-data/pca-imputation.qmd`

The source and measurement process are introduced on the preceding page. We use the full continuous acoustic matrix: duration, F0, and the steady plus contour samples for F1--F3. The matrix has observed token rows and observed acoustic columns. Its observed naturally missing cells occur in observed F2 or F3 columns. Duration, F0, and all F1 columns are complete. Use the graph or equation to say the result in ordinary language.

## Slide 54: Defining the standardized update

Source note: `missing-data/pca-imputation.qmd`

Let $\mathbf{Y}$ be the incomplete acoustic matrix and let $M$ contain the cells treated as missing in a particular fit. Each fit estimates a center $\widehat\mu_j$ and scale $\widehat s_j$ from its observed training cells, then forms where $Y_{ij}$ is available. Missing standardized cells begin at zero, which is the training-column mean after standardization. At iteration $t$, the rank-$K$ reconstruction is Use the graph or equation to say the result in ordinary language.

## Slide 55: Defining the standardized update: equation 1

Source note: `missing-data/pca-imputation.qmd`

The displayed expression formalizes defining the standardized update: equation 1. Let $\mathbf{Y}$ be the incomplete acoustic matrix and let $M$ contain the cells treated as missing in a particular fit. Each fit estimates a center $\widehat\mu_j$ and scale $\widehat s_j$ from its observed training cells, then forms Keep track of what each term refers to in the linguistic dataset.

## Slide 56: Defining the standardized update: equation 2

Source note: `missing-data/pca-imputation.qmd`

The displayed expression formalizes defining the standardized update: equation 2. where $Y_{ij}$ is available. Missing standardized cells begin at zero, which is the training-column mean after standardization. At iteration $t$, the rank-$K$ reconstruction is Keep track of what each term refers to in the linguistic dataset.

## Slide 57: Defining the standardized update: equation 3

Source note: `missing-data/pca-imputation.qmd`

The displayed expression formalizes defining the standardized update: equation 3. One update is Keep track of what each term refers to in the linguistic dataset.

## Slide 58: Defining the standardized update: equation 4

Source note: `missing-data/pca-imputation.qmd`

The displayed expression formalizes defining the standardized update: equation 4. Thus only the missing cells change. We stop when their relative squared change is below $10^{-6}$, Keep track of what each term refers to in the linguistic dataset.

## Slide 59: Implementing the algorithm in base R

Source note: `missing-data/pca-imputation.qmd`

The function returns the completed matrix, training centers and scales, and convergence diagnostics. Rank zero is the training-column-mean reference. The code estimates $\widehat\mu_j$ and $\widehat s_j$ before filling cells. A masked target thus cannot affect its own center or scale. Keep the observational unit fixed while you interpret the result.

## Slide 60: Choosing rank with registered masks

Source note: `missing-data/pca-imputation.qmd`

The number of retained components controls which relations can inform a missing cell. We compare $K\in\{0,1,2,3,4,5,8,10,12,15,20\}$ using eight registered validation masks. Each mask hides 5% of the naturally observed cells in every fallible column. The masks are generated sequentially, so no cell appears in more than one. The following function scores only a validation mask, after also removing the entire test union. Keep the observational unit fixed while you interpret the result.

## Slide 61: Predicting the naturally missing cells

Source note: `missing-data/pca-imputation.qmd`

After rank selection, we fit rank observed to the original matrix. Observed cells are copied back exactly. The remaining values are labeled predictions. The final fit supplies predictions for all observed natural omissions. The table deliberately calls them `predicted_value_hz`; there is no observed target against which to calculate their error. Keep the observational unit fixed while you interpret the result.

## Slide 62: Imputed values remain estimates

Source note: `missing-data/pca-imputation.qmd`

A completed matrix may look indistinguishable from an observed matrix in software. The two kinds of cells are not epistemically equivalent. An observed cell contains an estimate obtained from the recorded signal. Using one completed matrix in a later analysis treats these predictions as fixed and may understate the uncertainty created by the missing measurements. A procedure that propagates imputation uncertainty requires more machinery than this single reconstruction. The completed data should thus retain the observation indicator. Keep the observational unit fixed while you interpret the result.

## Slide 63: Checking the reconstruction

Source note: `missing-data/pca-imputation.qmd`

1. Which cells may change after each rank-$K$ reconstruction? 2. Where are the centers and scales estimated in the validation procedure? 3. Why is rank zero a column-mean reference on the standardized scale? 4. What does the final fit establish about the observed natural omissions, and what remains unknown? Iterative PCA imputation alternates between rank-$K$ reconstruction and replacement of cells treated as missing. It preserves observed cells, but its predictions depend on a low-rank model and a validation-selected component count. We next test that selected procedure by masking values that were actually observed. Notice what is observed and what is supplied by the model.

## Slide 64: Iterative PCA imputation

Source note: `missing-data/pca-imputation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Iterative PCA imputation. Read the pattern before attaching a model interpretation to it.

## Slide 65: Iterative PCA imputation

Source note: `missing-data/pca-imputation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Iterative PCA imputation. Read the pattern before attaching a model interpretation to it.

## Slide 66: Interpretation

Source note: `missing-data/pca-imputation.qmd`

Previous: Complete-case analysis · Next: Validating imputation Notice what is observed and what is supplied by the model.

## Slide 67: Validating an imputation procedure

Source note: `missing-data/validating-imputation.qmd`

We now turn to Validating an imputation procedure. The values of the naturally missing Hillenbrand formant cells are unavailable. No direct error can compare their PCA predictions with unseen measurements. We can ask a narrower question: when an available F2 or F3 estimate is hidden on purpose, how accurately does the complete procedure reconstruct it?

## Slide 68: Validating an imputation procedure

Source note: `missing-data/validating-imputation.qmd`

The values of the naturally missing Hillenbrand formant cells are unavailable. No direct error can compare their PCA predictions with unseen measurements. We can ask a narrower question: when an available F2 or F3 estimate is hidden on purpose, how accurately does the complete procedure reconstruct it? **Holdout validation by artificial masking** turns observed cells into artificial missing cells, fits the imputation without those values, and compares their reconstructions with the values set aside. This applies training and test separation to matrix cells. The masking creates known targets while preserving the rule that a target cannot guide its own prediction. Notice what is observed and what is supplied by the model.

## Slide 69: Defining the validation error

Source note: `missing-data/validating-imputation.qmd`

Let $O$ be the naturally observed cells and let $M_r\subset O$ be the cells hidden in mask replicate $r$. After fitting without $M_r$, the reconstruction of cell $(i,j)$ is $\widehat y_{ij}^{(-M_r)}$. Its mean squared reconstruction error is The superscript $(-M_r)$ records that the targets did not enter fitting. Because the acoustic columns have different scales, rank selection uses training-standardized error, The interpretation is conditional on the sampling and measurement design.

## Slide 70: Defining the validation error: equation 1

Source note: `missing-data/validating-imputation.qmd`

The displayed expression formalizes defining the validation error: equation 1. Let $O$ be the naturally observed cells and let $M_r\subset O$ be the cells hidden in mask replicate $r$. After fitting without $M_r$, the reconstruction of cell $(i,j)$ is $\widehat y_{ij}^{(-M_r)}$. Its mean squared reconstruction error is Keep track of what each term refers to in the linguistic dataset.

## Slide 71: Defining the validation error: equation 2

Source note: `missing-data/validating-imputation.qmd`

The displayed expression formalizes defining the validation error: equation 2. The superscript $(-M_r)$ records that the targets did not enter fitting. Because the acoustic columns have different scales, rank selection uses training-standardized error, Keep track of what each term refers to in the linguistic dataset.

## Slide 72: Loading the matrix and the imputation function

Source note: `missing-data/validating-imputation.qmd`

This page runs independently. It reloads the raw Hillenbrand release introduced earlier, rebuilds the full acoustic matrix, and defines the same standardized iterative PCA algorithm used on the preceding page. The values of the naturally missing Hillenbrand formant cells are unavailable. No direct error can compare their PCA predictions with unseen measurements. We can ask a narrower question: when an available F2 or F3 estimate is hidden on purpose, how accurately does the complete procedure reconstruct it? Keep the observational unit fixed while you interpret the result.

## Slide 73: Recreating the disjoint masks

Source note: `missing-data/validating-imputation.qmd`

Seeds `20261018` through `20261025` identify eight validation masks, each hiding 5% of observed cells within every fallible column. Seeds `20261026` through `20261029` identify four test masks, each hiding 1.25% per fallible column. Masks are created sequentially so that their targets are disjoint. Every artificial target is thus an observed value in the source table, and no target appears in two replicates. The split contains observed validation cells and observed test cells. That distinction will matter again on the next slide.

## Slide 74: Selecting rank without test leakage

Source note: `missing-data/validating-imputation.qmd`

Take a minute before we move on. The validation fits remove both the current validation mask and the entire test union. Thus no test value contributes to a validation prediction, a column center or scale, a component direction, or the selected rank. State the answer in terms of the dataset and the unit of analysis.

## Slide 75: Evaluating the selected rank on untouched cells

Source note: `missing-data/validating-imputation.qmd`

Each test fit hides its registered test mask. We compare rank observed with rank zero, the training-column-mean reference. On observed untouched F2 cells, rank observed has RMSE observed Hz, compared with observed Hz for the column-mean reference. On the same number of F3 cells, the corresponding RMSEs are observed and observed Hz. Mean signed error under rank observed is observed Hz for F2 and observed Hz for F3. Notice what is observed and what is supplied by the model.

## Slide 76: What this validation targets

Source note: `missing-data/validating-imputation.qmd`

This is cell-level, transductive validation. The other measurements from the same token remain available because the intended use is to fill isolated F2 or F3 cells in an existing acoustic matrix. The masks are random within the observed naturally fallible columns. They preserve the measurement columns but do not reproduce the observed dependence of natural missingness on vowel or value. Low test error thus supports interpolation under these registered masks. It does not establish unbiased reconstruction of the observed naturally missing cells. The interpretation is conditional on the sampling and measurement design.

## Slide 77: Auditing the validation

Source note: `missing-data/validating-imputation.qmd`

1. Why can the naturally missing cells not supply a direct reconstruction error? 2. Which quantities are estimated after the target cells are masked? 3. Why is the entire test union removed from every validation fit? 4. Which prediction target is represented by leaving other measurements from the same token available? 5. Holdout validation by artificial masking evaluates an imputation procedure on observed values made unavailable during fitting. Under the registered masks, rank observed predicts held-out F2 and F3 cells more accurately than the column-mean reference. This result supports one cell-reconstruction target; it does not turn predictions for naturally missing cells into measurements. Keep the observational unit fixed while you interpret the result.

## Slide 78: Validating an imputation procedure

Source note: `missing-data/validating-imputation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Validating an imputation procedure. Read the pattern before attaching a model interpretation to it.

## Slide 79: Validating an imputation procedure

Source note: `missing-data/validating-imputation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Validating an imputation procedure. Read the pattern before attaching a model interpretation to it.

## Slide 80: Interpretation

Source note: `missing-data/validating-imputation.qmd`

Previous: Iterative PCA imputation · Next: Custom models Notice what is observed and what is supplied by the model.
