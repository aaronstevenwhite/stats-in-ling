# Model criticism and out-of-sample prediction

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Model criticism and out-of-sample prediction

Source note: `model-criticism-and-prediction/index.qmd`

Welcome to Model criticism and out-of-sample prediction. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Predicting observations the model did not see

Source note: `model-criticism-and-prediction/index.qmd`

We now turn to Predicting observations the model did not see. The corrected Natural Stories release, described by Futrell et al. (2021), pairs self-paced reading times with lexical and contextual predictors in ten construction-enriched stories. The pinned data are distributed under CC BY-NC-SA 4.0. This unit begins with its participant-by-word-position responses.

## Slide 3: Provo: the empirical object

Source note: `model-criticism-and-prediction/index.qmd`

This is the first use of Provo in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 4: Predicting observations the model did not see

Source note: `model-criticism-and-prediction/index.qmd`

The corrected Natural Stories release, described by Futrell et al. (2021), pairs self-paced reading times with lexical and contextual predictors in ten construction-enriched stories. The pinned data are distributed under CC BY-NC-SA 4.0. This unit begins with its participant-by-word-position responses. An observed-minus-fitted residual describes a response used to estimate a model. It does not tell us how the complete procedure will predict a response unavailable during fitting. In Natural Stories, unavailable can mean one response row, every response from one participant, or every position in one story. This choice is the **prediction-unit problem (PUP)**. Keep the observational unit fixed while you interpret the result.

## Slide 5: Overview

Source note: `model-criticism-and-prediction/index.qmd`

Read the rows as observed summaries from the named dataset. An observed-minus-fitted residual describes a response used to estimate a model. It does not tell us how the complete procedure will predict a response unavailable during fitting. In Natural Stories, unavailable can mean one response row, every response from one participant, or every position in one story. This choice is the **prediction-unit problem (PUP)**.

## Slide 6: Defining and scoring a prediction

Source note: `model-criticism-and-prediction/index.qmd`

Prediction targets state which responses or groups are new and which predictors remain available. Training and test data then enforce that separation, including training-only estimation of predictor transformations. Cross-validation rotates a row-level split. Grouped cross-validation instead moves complete participants or stories together. These pages use the same Natural Stories population regression so that changing the split changes the predictive claim rather than the fitted predictor set. The teaching fit omits participant and story effects to expose those targets; it does not reproduce the source paper's validation models. The interpretation is conditional on the sampling and measurement design.

## Slide 7: Comparing models

Source note: `model-criticism-and-prediction/index.qmd`

Comparing predictive loss moves to MegaOrientation and evaluates additive and frame-specific ordinal models on verbs absent from fitting. This switch marks a conceptual break: the target becomes lexical transfer, and the response becomes ordered rather than continuous. The comparison thus follows the course's introduction to cumulative-logit regression. The final pages return to the Provo passage summaries used earlier in the course. Likelihood-ratio tests compare nested Gaussian models; information criteria add fit penalties; leave-one-out cross-validation, PSIS-LOO, and WAIC use matched observations and pointwise log-likelihood contributions. Each comparison keeps the response rows and candidate model family fixed. The interpretation is conditional on the sampling and measurement design.

## Slide 8: Interpretation

Source note: `model-criticism-and-prediction/index.qmd`

Successful prediction does not by itself identify a processing mechanism. The module thus proceeds in one order: name the prediction unit, separate fitting from scoring, choose and aggregate the loss, rotate the separation, and only then compare models. Now connect the notation back to the linguistic comparison.

## Slide 9: What must be new at prediction time

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

We now turn to What must be new at prediction time. The earlier page on populations and samples required an inferential claim to specify the population represented by a sample. Predictive evaluation requires a related decision. We must say which responses were unavailable during fitting and what information is available when those responses are predicted. This is the prediction-unit problem in operational form.

## Slide 10: Natural Stories: the empirical object

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

This is the first use of Natural Stories in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 11: What must be new at prediction time

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

The earlier page on populations and samples required an inferential claim to specify the population represented by a sample. Predictive evaluation requires a related decision. We must say which responses were unavailable during fitting and what information is available when those responses are predicted. This is the prediction-unit problem in operational form. **Out-of-sample prediction** predicts responses that did not contribute to fitting the model. This definition leaves an important question open: is the held-out response new only as a row, or is its reader or text also absent from training? Use the graph or equation to say the result in ordinary language.

## Slide 12: Natural Stories

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

We use the corrected Natural Stories release, introduced and validated by Futrell et al. (2021), throughout the first six pages of this unit. The corpus contains English stories enriched for low-frequency syntactic constructions, self-paced reading times, and aligned lexical annotations. The corrected release fixes a one-position displacement in the reading-time records. The code below constructs the prediction table from the tracked release. One row is one retained button latency for one reader at one word position. It is a self-paced reading time, not an eye fixation. Notice what is observed and what is supplied by the model.

## Slide 13: Three prediction targets

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

All three procedures used later fit the population regression where $L_i$ is word length, $F_i$ is log unigram frequency, and $S_i$ is released GPT-3 surprisal. What changes is the **prediction unit**, the object excluded from training. The interpretation is conditional on the sampling and measurement design.

## Slide 14: Three prediction targets

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Read the rows as observed summaries from the named dataset. where $L_i$ is word length, $F_i$ is log unigram frequency, and $S_i$ is released GPT-3 surprisal. What changes is the **prediction unit**, the object excluded from training.

## Slide 15: Three prediction targets

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

The displayed expression formalizes three prediction targets. All three procedures used later fit the population regression Keep track of what each term refers to in the linguistic dataset.

## Slide 16: The prediction information set

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Holding out a group does not by itself determine which information about it may be used. In these analyses, a held-out row keeps its word length, frequency, and surprisal because those predictors are available at prediction time. A held-out participant contributes no reading-time response to fitting. The preprocessing rule is part of the information set. Each predictor mean and standard deviation is estimated from training rows and then applied to test rows. A full-data center would let held-out predictor values affect the training representation. A separately estimated test center would place the test observations in a different coordinate system. Keep the observational unit fixed while you interpret the result.

## Slide 17: Theory determines what should be held out

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

The most demanding split is not automatically the right one. A reading model used for an already represented reader may reasonably target another response row. A claim about transfer across readers requires participant folds. A claim about connected text requires story folds and enough story-level replication to support it. Successful prediction also does not establish a processing mechanism. Word surprisal can improve a held-out score without showing that readers internally represent the fitted language model's probabilities. Predictive evaluation establishes performance for a stated response, information set, split, and population; the mechanism requires additional evidence. The interpretation is conditional on the sampling and measurement design.

## Slide 18: Checking the target

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

1. Which Natural Stories target keeps the same reader and story represented during fitting? 2. What must move together when the target is a reader absent during fitting? 3. Why do the retained response rows not provide that many independent evaluations of an omitted story? 4. Out-of-sample prediction requires a response excluded from fitting. A complete predictive question also states which groups are held out, which predictors remain available, and where the result should generalize. The previous page introduces this sequence; the next page implements one participant-held-out split and makes its training-only preprocessing visible. That distinction will matter again on the next slide.

## Slide 19: What must be new at prediction time

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for What must be new at prediction time. Read the pattern before attaching a model interpretation to it.

## Slide 20: Training and test data

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

We now turn to Training and test data. The prediction-target page fixed three meanings of *new* for the corrected Natural Stories data. We now make one participant-held-out separation observable. The **training set** estimates every fitted quantity; the **test set** is used only to evaluate the resulting predictions.

## Slide 21: Training and test data

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The prediction-target page fixed three meanings of *new* for the corrected Natural Stories data. We now make one participant-held-out separation observable. The **training set** estimates every fitted quantity; the **test set** is used only to evaluate the resulting predictions. The residuals of a fitted regression are observed-minus-fitted discrepancies on the observations used to estimate its coefficients. A flexible model can reduce those residuals by following features of the training responses that will not recur. Training fit thus cannot by itself estimate predictive loss for a reader absent during fitting. That distinction will matter again on the next slide.

## Slide 22: The separation rule

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

Let $D_{\mathrm{train}}$ and $D_{\mathrm{test}}$ be disjoint collections of observations. A fitted predictor is and test loss is Notice what is observed and what is supplied by the model.

## Slide 23: The separation rule: equation 1

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The displayed expression formalizes the separation rule: equation 1. Let $D_{\mathrm{train}}$ and $D_{\mathrm{test}}$ be disjoint collections of observations. A fitted predictor is Keep track of what each term refers to in the linguistic dataset.

## Slide 24: The separation rule: equation 2

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The displayed expression formalizes the separation rule: equation 2. and test loss is Keep track of what each term refers to in the linguistic dataset.

## Slide 25: A participant-held-out Natural Stories split

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The data and their source are introduced on the prediction-target page. The following code independently loads the tracked release, recreates the frozen participant folds, learns all transformations from the training rows, and predicts the first held-out fold. The training set contains observed responses from observed readers. The test set contains observed responses from observed readers. All observed stories remain represented on both sides, so the target is a new reader of these stories rather than a new text. Keep the observational unit fixed while you interpret the result.

## Slide 26: Leakage through preprocessing

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

**Data leakage** occurs when information from the test set influences a fitted decision that should have been made without it. Directly fitting on a test response is one case, but preprocessing can leak more quietly. - Centering a predictor using the complete dataset lets held-out predictor values affect the training representation. - Imputing a missing test response from a full-data mean uses held-out responses. - Selecting predictors by their full-data response correlation consults the test set. - Choosing a model because it has the best test score turns the test data into selection data. That distinction will matter again on the next slide.

## Slide 27: Leakage through preprocessing

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The displayed expression formalizes leakage through preprocessing. **Data leakage** occurs when information from the test set influences a fitted decision that should have been made without it. Directly fitting on a test response is one case, but preprocessing can leak more quietly. Keep track of what each term refers to in the linguistic dataset.

## Slide 28: One split and repeated decisions

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

A single split combines model performance with the composition of one test set. Increasing the test fraction provides more evaluation responses but fewer fitting responses; decreasing it has the opposite effect. Cross-validation rotates the test role so that every observation receives a held-out prediction. The test set is also not a renewable source of decisions. If several specifications are compared on these responses and the best is selected, its reported score is optimistic. A three-way split or nested cross-validation keeps final test responses outside both coefficient fitting and model selection. Now connect the notation back to the linguistic comparison.

## Slide 29: Checking the separation

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

1. Which participants contribute responses to both sets in this split? 2. Which moments define the test-set predictor transformation? 3. Why does the calibration figure not estimate an omitted-story target? 4. What changes if the test responses guide model selection? Separating training and test data allows parameters and preprocessing to be estimated without the responses on which predictive loss is computed. The previous page fixed the prediction unit; the next page defines the numerical consequence assigned to these participant-held-out errors. That distinction will matter again on the next slide.

## Slide 30: Training and test data

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Training and test data. Read the pattern before attaching a model interpretation to it.

## Slide 31: Predictive loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

We now turn to Predictive loss. The training-and-test page produced predictions for readers absent during fitting. An evaluation still needs a numerical definition of error and an averaging unit. These choices form the **error-consequence problem**: they determine which misses receive the most weight and which empirical units receive equal influence.

## Slide 32: Predictive loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The training-and-test page produced predictions for readers absent during fitting. An evaluation still needs a numerical definition of error and an averaging unit. These choices form the **error-consequence problem**: they determine which misses receive the most weight and which empirical units receive equal influence. A **loss function** $L(y,\widehat y)$ assigns a nonnegative cost to predicting $\widehat y$ when the observed response is $y$. The **predictive risk** is expected loss on new responses from the population under study. A held-out mean loss estimates that expectation for the split and averaging unit stated by the analysis. Now connect the notation back to the linguistic comparison.

## Slide 33: Squared and absolute loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The **squared-error loss** is Over $N$ held-out predictions, mean squared error and root mean squared error are Notice what is observed and what is supplied by the model.

## Slide 34: Squared and absolute loss: equation 1

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The displayed expression formalizes squared and absolute loss: equation 1. The **squared-error loss** is Keep track of what each term refers to in the linguistic dataset.

## Slide 35: Squared and absolute loss: equation 2

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The displayed expression formalizes squared and absolute loss: equation 2. Over $N$ held-out predictions, mean squared error and root mean squared error are Keep track of what each term refers to in the linguistic dataset.

## Slide 36: Squared and absolute loss: equation 3

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The displayed expression formalizes squared and absolute loss: equation 3. Squaring gives large errors disproportionate influence. Taking the root returns the score to the response scale. For Natural Stories, that scale is log reading time, not milliseconds. The conditional mean is the optimal point prediction under squared loss. Keep track of what each term refers to in the linguistic dataset.

## Slide 37: Squared and absolute loss: equation 4

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The displayed expression formalizes squared and absolute loss: equation 4. The **absolute-error loss** is Keep track of what each term refers to in the linguistic dataset.

## Slide 38: Computing loss for held-out Natural Stories readers

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The code reconstructs participant fold 1 from the Natural Stories run, fits the same fold-local regression, and computes the errors. It then averages squared and absolute loss in two ways: once over response rows and once within readers before averaging readers. The row-weighted RMSE is observed and MAE is observed. Giving each held-out reader equal weight yields RMSE observed and MAE observed. The calculations use the same predictions. They differ because the second estimand first averages loss within each of the observed readers. Now connect the notation back to the linguistic comparison.

## Slide 39: Loss is not explanatory adequacy

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Lower predictive loss does not show that a predictor is causal or that a reader internally computes the fitted predictor. In this regression, lower loss from GPT-3 surprisal would not isolate lexical expectation from correlated properties of words and contexts. Conversely, a theoretically meaningful coefficient can contribute little to held-out prediction. A small, stable association may be estimable while accounting for little response variation. Predictive loss thus addresses an additional question rather than replacing parameter interpretation. That distinction will matter again on the next slide.

## Slide 40: Checking the loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

1. Which score is more sensitive to a small number of large errors? 2. On what response scale are the reported Natural Stories scores? 3. Why do row-weighted and participant-weighted losses differ when their prediction vector is identical? 4. Can a nonzero coefficient fail to improve held-out loss? A loss function defines the consequence of each error, while the averaging unit determines what receives equal weight. The previous page constructed the split. The next page uses an empirically calibrated simulation to separate prediction bias and prediction variance. That distinction will matter again on the next slide.

## Slide 41: Predictive loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Predictive loss. Read the pattern before attaching a model interpretation to it.

## Slide 42: Prediction bias and prediction variance

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

We now turn to Prediction bias and prediction variance. The earlier pages defined estimator bias, estimator variance, and their contribution to mean squared error. Here the estimator is a fitted prediction at a specified predictor vector. The same decomposition concerns prediction bias and prediction variance across repeated training samples.

## Slide 43: Prediction bias and prediction variance

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The earlier pages defined estimator bias, estimator variance, and their contribution to mean squared error. Here the estimator is a fitted prediction at a specified predictor vector. The same decomposition concerns prediction bias and prediction variance across repeated training samples. A linear reading-time model may miss curvature in the association among length, frequency, surprisal, and mean response. A more flexible model may instead follow sample-specific variation. The **bias-variance decomposition** separates these two failure modes. Now connect the notation back to the linguistic comparison.

## Slide 44: Beginning with repeated training samples

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

At a fixed predictor vector $x$, let the response be generated by where $f(x)=\mathbb E[Y\mid X=x]$ and Use the graph or equation to say the result in ordinary language.

## Slide 45: Beginning with repeated training samples: equation 1

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The displayed expression formalizes beginning with repeated training samples: equation 1. At a fixed predictor vector $x$, let the response be generated by Keep track of what each term refers to in the linguistic dataset.

## Slide 46: Beginning with repeated training samples: equation 2

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The displayed expression formalizes beginning with repeated training samples: equation 2. where $f(x)=\mathbb E[Y\mid X=x]$ and Keep track of what each term refers to in the linguistic dataset.

## Slide 47: Beginning with repeated training samples: equation 3

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The displayed expression formalizes beginning with repeated training samples: equation 3. Repeatedly drawing a comparable training sample and applying the same complete fitting procedure produces a different $\widehat f(x)$ on each repetition. Prediction variance describes variation among those learned predictions. It does not describe variation among observed responses with the same predictors. Keep track of what each term refers to in the linguistic dataset.

## Slide 48: Beginning with repeated training samples: equation 4

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The displayed expression formalizes beginning with repeated training samples: equation 4. The bias and prediction variance are Keep track of what each term refers to in the linguistic dataset.

## Slide 49: Deriving the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

We want expected squared error for a new response at the fixed predictor vector: Add and subtract both $f(x)$ and $\mathbb E[\widehat f(x)]$: Now connect the notation back to the linguistic comparison.

## Slide 50: Deriving the decomposition: equation 1

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The displayed expression formalizes deriving the decomposition: equation 1. We want expected squared error for a new response at the fixed predictor vector: Keep track of what each term refers to in the linguistic dataset.

## Slide 51: Deriving the decomposition: equation 2

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The displayed expression formalizes deriving the decomposition: equation 2. Add and subtract both $f(x)$ and $\mathbb E[\widehat f(x)]$: Keep track of what each term refers to in the linguistic dataset.

## Slide 52: Deriving the decomposition: equation 3

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The displayed expression formalizes deriving the decomposition: equation 3. After squaring, the expected cross-products are zero because the response noise has mean zero and the fitted predictions are centered around their own expectation. Thus, Keep track of what each term refers to in the linguistic dataset.

## Slide 53: An empirically calibrated Natural Stories simulation

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

True bias is not identified from one observed corpus. We thus use the only simulation in this module and label its assumptions. The code loads the Natural Stories data, averages responses and predictors to observed story positions, fits a cubic reference surface, and declares that fitted surface to be the simulation truth. The target is also an observed position rather than an invented predictor vector. It is the position closest to the observed 90th percentile of surprisal and the median frequency and length. Notice what is observed and what is supplied by the model.

## Slide 54: What the simulation establishes

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

This calibration demonstrates the decomposition using observed predictor values, response scale, and residuals. It does not estimate the unknown Natural Stories data-generating process. The cubic reference surface is assumed true for the exercise; another calibrated truth could change the comparison. The example also shows why coefficient count is not a definition of prediction variance. Regularization, sample size, preprocessing, and the predictor distribution all affect how much a procedure changes across training samples. Held-out loss can evaluate their combined consequence, but it cannot identify separate bias and variance terms without an assumption about $f(x)$. Keep the observational unit fixed while you interpret the result.

## Slide 55: Checking the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

1. Across which repetitions is $\operatorname{Var}(\widehat f(x))$ defined? 2. Which procedure has smaller squared bias at the selected Natural Stories position? 3. Which procedure has smaller expected squared error under the declared simulation? 4. Why is the horizontal line an assumed truth rather than an estimate of the unknown response process? The bias-variance decomposition explains why a procedure that follows training data more closely need not predict a new response better. The previous page defined held-out loss. The next page rotates the training and test roles to obtain predictions for every retained response. Keep the observational unit fixed while you interpret the result.

## Slide 56: Prediction bias and prediction variance

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Prediction bias and prediction variance. Read the pattern before attaching a model interpretation to it.

## Slide 57: Cross-validation

Source note: `model-criticism-and-prediction/cross-validation.qmd`

We now turn to Cross-validation. The training-and-test page separated one training set from one test set. **$K$-fold cross-validation (CV)** reduces dependence on a single partition by rotating which fold serves as the test set.

## Slide 58: Cross-validation

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The training-and-test page separated one training set from one test set. **$K$-fold cross-validation (CV)** reduces dependence on a single partition by rotating which fold serves as the test set. The output is one out-of-fold prediction for every observation. Each prediction comes from a fit that excluded that response. This does not make its reader or story new as well; the fold construction determines which units cross the training-test boundary. That distinction will matter again on the next slide.

## Slide 59: The algorithm

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Partition observation indices into disjoint folds $F_1,\ldots,F_K$. For fold $k$: 1. fit the complete procedure to observations outside $F_k$; 2. use that fitted procedure to predict observations in $F_k$; and 3. store the predictions in their original rows. That distinction will matter again on the next slide.

## Slide 60: The algorithm

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The displayed expression formalizes the algorithm. Partition observation indices into disjoint folds $F_1,\ldots,F_K$. For fold $k$: Keep track of what each term refers to in the linguistic dataset.

## Slide 61: Random-row validation in Natural Stories

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The following code independently loads the corrected Natural Stories data, assigns retained responses to five random folds with the frozen seed, fits the same standardized regression inside each fold, and stores every held-out prediction. Predictor moments are recomputed from the training rows of each fold. The five fold RMSEs range from observed to observed. Every held-out fold contains responses from all observed stories and observed represented participants. The estimand is thus a new retained response when its story and reader remain represented in training. That distinction will matter again on the next slide.

## Slide 62: Every fitted decision stays inside the loop

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Cross-validation evaluates the complete procedure, not just its final coefficient formula. Centering, scaling, feature selection, imputation, and penalty tuning must be repeated using only each training portion. A tuning parameter requires an inner validation loop if it adapts to responses; the outer prediction then evaluates the complete selection rule. This nesting is unnecessary when the specification is fixed in advance. The Natural Stories code has no tuning step: its predictor set and fold seed are fixed, but its training moments and regression coefficients remain fold-specific. Use the graph or equation to say the result in ordinary language.

## Slide 63: What $K$ changes

Source note: `model-criticism-and-prediction/cross-validation.qmd`

With larger $K$, each model uses a larger training fraction and a smaller test fold. Leave-one-out CV sets $K=N$ for row-level omission. Fewer folds cost less computation but fit on less of the data for each prediction. Fold count is a design setting, not a probability law. If the scientific target is an omitted story, the ten story identifiers naturally define ten held-out groups. Randomly creating more row folds cannot manufacture additional story-level replication. Keep the observational unit fixed while you interpret the result.

## Slide 64: Fold scores are not independent experiments

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The five fits reuse most of their training rows. Their losses are consequently not five independent studies. A test applied to fold means would treat computational partitions as if they were sampling units. Predictive differences should instead be returned to the groups specified by the claim. For an omitted-story claim, that means story-level losses even when several stories share one computational fold. The next page changes the fold assignment while retaining the same fitting algorithm. Use the graph or equation to say the result in ordinary language.

## Slide 65: Checking the split

Source note: `model-criticism-and-prediction/cross-validation.qmd`

1. Why is each stored prediction out of sample for its response? 2. Which quantities are re-estimated inside every Natural Stories fold? 3. Why does this random-row procedure not evaluate a reader or story absent from fitting? 4. Why are the five fold scores not independent experiments? $K$-fold CV rotates training and test roles to obtain one held-out prediction per response. The previous page described repeated training samples; the next page keeps complete participants and stories together when those groups must be absent during fitting. Now connect the notation back to the linguistic comparison.

## Slide 66: Cross-validation

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Cross-validation. Read the pattern before attaching a model interpretation to it.

## Slide 67: Grouped cross-validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

We now turn to Grouped cross-validation. The cross-validation page placed response rows into random folds. The same reader and story consequently occurred in both training and test data. **Grouped $K$-fold cross-validation** instead assigns every row from a group to the same fold.

## Slide 68: Grouped cross-validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

The cross-validation page placed response rows into random folds. The same reader and story consequently occurred in both training and test data. **Grouped $K$-fold cross-validation** instead assigns every row from a group to the same fold. The Natural Stories introduction fixed participant and story as two candidate grouping units. Holding out participants evaluates new readers of the represented stories. Holding out a story evaluates one omitted member of the ten construction-enriched texts. The interpretation is conditional on the sampling and measurement design.

## Slide 69: Constructing grouped folds

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Let $g(i)$ be the group containing observation $i$. Grouped validation requires The group controls both the split and the interpretation. Moving story rows together removes its sentences and word positions automatically; splitting sentences cannot evaluate an omitted story if other sentences from the same story remain in training. Use the graph or equation to say the result in ordinary language.

## Slide 70: Constructing grouped folds

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

The displayed expression formalizes constructing grouped folds. Let $g(i)$ be the group containing observation $i$. Grouped validation requires Keep track of what each term refers to in the linguistic dataset.

## Slide 71: Participant and story validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

The code fits the same population regression under two grouped designs. Participants receive five frozen folds. Stories use leave-one-story-out validation. For the story comparison, a base model includes length and frequency, while an expanded model adds GPT-3 surprisal. Each training fold estimates its own predictor moments. Participant-fold RMSE ranges from observed to observed. Story-fold RMSE ranges from observed to observed. These ranges should not be treated as a difficulty ranking because the held-out groups differ in size and composition. They show that predictive performance is a property of the validation target. Notice what is observed and what is supplied by the model.

## Slide 72: Group-weighted scores

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

For group $g$ with $n_g$ responses, define A group-weighted score is The interpretation is conditional on the sampling and measurement design.

## Slide 73: Group-weighted scores: equation 1

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

The displayed expression formalizes group-weighted scores: equation 1. For group $g$ with $n_g$ responses, define Keep track of what each term refers to in the linguistic dataset.

## Slide 74: Group-weighted scores: equation 2

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

The displayed expression formalizes group-weighted scores: equation 2. A group-weighted score is Keep track of what each term refers to in the linguistic dataset.

## Slide 75: Group leakage and limits

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Moving rows together does not prevent leakage from a response-derived predictor constructed before the split. A word-position mean reading time computed across all participants would contain the test participants' responses. For that reason, this analysis retains participant-level response rows and fits predictor transformations inside folds. The participant model remains a population regression without participant or story effects. It is designed to expose the difference among targets, not to reproduce the mixed-effects validation in Futrell et al. The story results concern ten omitted enriched texts. They do not license generalization to arbitrary English stories. The interpretation is conditional on the sampling and measurement design.

## Slide 76: Checking the grouping variable

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

1. Why is a sentence split insufficient for an omitted-story target? 2. Which assertion verifies that participants do not cross folds? 3. Why can row-weighted and group-weighted losses answer different questions? 4. What does the story-difference plot show that a pooled RMSE change would hide? Grouped cross-validation makes a complete empirical group absent during fitting. The previous page evaluated new rows from represented readers and stories. The next page switches to MegaOrientation and compares ordinal models on entirely unseen verbs. Use the graph or equation to say the result in ordinary language.

## Slide 77: Grouped cross-validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Grouped cross-validation. Read the pattern before attaching a model interpretation to it.

## Slide 78: Grouped cross-validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Grouped cross-validation. Read the pattern before attaching a model interpretation to it.

## Slide 79: Comparing predictive loss

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

We now turn to Comparing predictive loss. The grouped-validation page returned held-out losses to the groups omitted during fitting. Comparing two procedures requires pairing their predictions on those same groups. We now use an ordinal response and hold out complete verb types, which makes both the loss and the transfer target visible.

## Slide 80: Comparing predictive loss

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The grouped-validation page returned held-out losses to the groups omitted during fitting. Comparing two procedures requires pairing their predictions on those same groups. We now use an ordinal response and hold out complete verb types, which makes both the loss and the transfer target visible. The interpretation is conditional on the sampling and measurement design.

## Slide 81: MegaOrientation

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

Moon and White (2020) constructed sentence pairs that force past- or future-oriented interpretations by combining matrix tense or modality with an incompatible embedded temporal adverb. Participants rated the sentences on a 1-to-7 acceptability scale. The original paper fits latent lexical, structural, and mixed models with participant-specific ordinal cutpoints. The teaching comparison is narrower. It restricts the release to verbs attested in at least two frames, fits population cumulative-logit models, and holds out every response from a verb together. Keep the observational unit fixed while you interpret the result.

## Slide 82: MegaOrientation: equation 1

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The displayed expression formalizes megaorientation: equation 1. Moon and White (2020) constructed sentence pairs that force past- or future-oriented interpretations by combining matrix tense or modality with an incompatible embedded temporal adverb. Participants rated the sentences on a 1-to-7 acceptability scale. The corrected MegaOrientation v1.1 release changes the released participant and verb inventories after items with irregular-inflection errors were rerun. Keep track of what each term refers to in the linguistic dataset.

## Slide 83: MegaOrientation: equation 2

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The displayed expression formalizes megaorientation: equation 2. The original paper fits latent lexical, structural, and mixed models with participant-specific ordinal cutpoints. The teaching comparison is narrower. It restricts the release to verbs attested in at least two frames, fits population cumulative-logit models, and holds out every response from a verb together. Keep track of what each term refers to in the linguistic dataset.

## Slide 84: Held-out-verb comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The code loads the tracked response table and frozen verb folds, fits both ordinal models in every fold, and extracts the probability assigned to each observed rating. It first averages log scores within verbs and only then averages the observed verbs, preventing verbs with more judgment rows from receiving greater weight. The interaction improves the verb-weighted mean log score by observed, with a conditional verb-bootstrap interval of [observed, observed]. The row-weighted gain is observed, and observed of observed folds favor the interaction. The gray points show all held-out verb differences; the blue points show fold means. Keep the observational unit fixed while you interpret the result.

## Slide 85: Raw responses and the descriptive fit

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The predictive comparison uses held-out verbs. A full-data interaction fit serves a different purpose: it lets us check fitted ordinal probabilities against the empirical rating distribution in each represented frame-orientation cell. The tracked comparison contains observed judgments from observed multi-frame verbs and observed predicate-frame pairs. Points are empirical category probabilities; lines are the descriptive full-data interaction fit. Those fitted lines do not supply the held-out comparison numbers. That distinction will matter again on the next slide.

## Slide 86: Scope of the gain

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The conditional bootstrap resamples the stored verb differences while holding the fitted cross-validation predictions fixed. It respects verb as the resampling unit, but it does not reproduce participant, item, or refitting uncertainty. The population models also omit participant and sentence-item effects. The interaction gain suggests that frame-specific orientation patterns help predict ratings for unseen verbs within this selected inventory. It does not turn acceptability into a directly observed temporal-orientation label, reproduce Moon and White's lexical-versus-structural theory comparison, or generalize to unrestricted English embedding verbs. Keep the observational unit fixed while you interpret the result.

## Slide 87: Checking the comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

1. Why does a positive difference favor the interaction model? 2. Why are log scores averaged within verbs before the primary mean is taken? 3. What does the full-data probability plot check, and what does it not estimate? 4. Which omitted sources of dependence limit the bootstrap interval? A paired comparison evaluates two models on identical held-out groups and returns their differences to the unit specified by the scientific claim. The previous page developed grouped splitting with Natural Stories. The next page begins a five-page Provo sequence using two fixed Gaussian mean models. Use the graph or equation to say the result in ordinary language.

## Slide 88: Comparing predictive loss

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Comparing predictive loss. Read the pattern before attaching a model interpretation to it.

## Slide 89: Comparing predictive loss

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Comparing predictive loss. Read the pattern before attaching a model interpretation to it.

## Slide 90: Comparing nested likelihoods

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

We now turn to Comparing nested likelihoods. The earlier maximum-likelihood page compared parameter values within one model. A likelihood-ratio test compares two models when one is a restricted version of the other. We begin a five-page sequence with one fixed response table and one fixed pair of Gaussian models so that the comparison criterion, rather than the empirical object, changes from page to page.

## Slide 91: Comparing nested likelihoods

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The earlier maximum-likelihood page compared parameter values within one model. A likelihood-ratio test compares two models when one is a restricted version of the other. The earlier maximum-likelihood page compared parameter values within one model. A likelihood-ratio test compares two models when one is a restricted version of the other. We begin a five-page sequence with one fixed response table and one fixed pair of Gaussian models so that the comparison criterion, rather than the empirical object, changes from page to page. The interpretation is conditional on the sampling and measurement design.

## Slide 92: Provo Corpus

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Luke and Christianson (2018) released cloze norms for each word in English passages and eye-movement measurements from readers of those passages. The OSF release includes `OrthoMatchModel`, an orthographic-match cloze estimate from a logit mixed model with word intercepts. It is a fitted cloze estimate, not a language-model probability. The tracked course table retains complete content-word positions from all passages and averages first-fixation duration across readers at each position. One row is thus a position summary, not one reader's fixation. The analyses below cannot recover reader-level dependence from that aggregation. Notice what is observed and what is supplied by the model.

## Slide 93: Provo Corpus: equation 1

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The displayed expression formalizes provo corpus: equation 1. Luke and Christianson (2018) released cloze norms for each word in English passages and eye-movement measurements from readers of those passages. The OSF release includes `OrthoMatchModel`, an orthographic-match cloze estimate from a logit mixed model with word intercepts. It is a fitted cloze estimate, not a language-model probability. Keep track of what each term refers to in the linguistic dataset.

## Slide 94: Provo Corpus: equation 2

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The displayed expression formalizes provo corpus: equation 2. The tracked course table retains complete content-word positions from all passages and averages first-fixation duration across readers at each position. One row is thus a position summary, not one reader's fixation. The analyses below cannot recover reader-level dependence from that aggregation. Keep track of what each term refers to in the linguistic dataset.

## Slide 95: From a likelihood ratio to a difference

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Let $\widehat L_L$ and $\widehat L_Q$ be the maximized likelihoods. Since the expanded model can reproduce the restricted fit, The likelihood-ratio statistic is Keep the observational unit fixed while you interpret the result.

## Slide 96: From a likelihood ratio to a difference: equation 1

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The displayed expression formalizes from a likelihood ratio to a difference: equation 1. Let $\widehat L_L$ and $\widehat L_Q$ be the maximized likelihoods. Since the expanded model can reproduce the restricted fit, Keep track of what each term refers to in the linguistic dataset.

## Slide 97: From a likelihood ratio to a difference: equation 2

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The displayed expression formalizes from a likelihood ratio to a difference: equation 2. The likelihood-ratio statistic is Keep track of what each term refers to in the linguistic dataset.

## Slide 98: From a likelihood ratio to a difference: equation 3

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The displayed expression formalizes from a likelihood ratio to a difference: equation 3. When the expanded model adds regular parameters and the usual large-sample conditions hold, Keep track of what each term refers to in the linguistic dataset.

## Slide 99: Fitting the Provo models

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The code reads the tracked position table, constructs surprisal, fits both models to exactly the same rows, computes the LRT, and plots every position with both fitted means. The common analysis table has observed positions from observed passages. The linear and quadratic log likelihoods are observed and observed. Thus, Use the graph or equation to say the result in ordinary language.

## Slide 100: Fitting the Provo models

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The displayed expression formalizes fitting the provo models. The code reads the tracked position table, constructs surprisal, fits both models to exactly the same rows, computes the LRT, and plots every position with both fitted means. Keep track of what each term refers to in the linguistic dataset.

## Slide 101: Interpreting the restriction narrowly

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The null hypothesis is Rejecting this restriction suggests that the quadratic term improves fitted likelihood conditional on this response, sample, and Gaussian specification. It does not show that the quadratic model is true, that cloze surprisal causes fixation-duration differences, or that readers internally represent `OrthoMatchModel`. The interpretation is conditional on the sampling and measurement design.

## Slide 102: Interpreting the restriction narrowly

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The displayed expression formalizes interpreting the restriction narrowly. The null hypothesis is Keep track of what each term refers to in the linguistic dataset.

## Slide 103: When the reference distribution may fail

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The $\chi^2$ approximation assumes that the null value is an interior, regular point and that parameters are sufficiently identified. Testing a random-effect variance against zero violates this condition because zero is a boundary. Mixture models can lose component identification under a null restriction. The likelihood difference remains a description of fitted improvement when these conditions fail. What becomes unreliable is the simple $\chi^2$ calibration. Now connect the notation back to the linguistic comparison.

## Slide 104: Likelihood comparison and predictive validation

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The LRT uses the same responses to estimate and compare the models. Cross-validation asks how the complete procedures predict responses excluded from fitting. A quadratic term can pass an LRT while changing held-out prediction only slightly, or a proxy can improve prediction without supporting its proposed mechanism. The earlier maximum-likelihood page compared parameter values within one model. A likelihood-ratio test compares two models when one is a restricted version of the other. We begin a five-page sequence with one fixed response table and one fixed pair of Gaussian models so that the comparison criterion, rather than the empirical object, changes from page to page. Notice what is observed and what is supplied by the model.

## Slide 105: Checking the nested comparison

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

1. Which parameter restriction makes the quadratic model reduce to the linear model? 2. Why can the expanded model not have a lower maximized likelihood? 3. Why must both fits use the same position rows and response scale? 4. Why does the reported tail probability not evaluate an omitted passage? The LRT measures the fitted likelihood gained by relaxing a nested restriction and calibrates that gain when the regularity conditions hold. The previous page evaluated unseen verbs. The next page applies two different penalties to these same Provo fits. Now connect the notation back to the linguistic comparison.

## Slide 106: Comparing nested likelihoods

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Comparing nested likelihoods. Read the pattern before attaching a model interpretation to it.

## Slide 107: Penalizing in-sample fit

Source note: `model-criticism-and-prediction/information-criteria.qmd`

We now turn to Penalizing in-sample fit. The likelihood-ratio page fixed a Provo position table and two nested Gaussian mean models. Information criteria use those same likelihoods but replace null-hypothesis calibration with a penalty for estimated flexibility. This lets the penalty, rather than a change in data or response, explain any disagreement.

## Slide 108: Penalizing in-sample fit

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The likelihood-ratio page fixed a Provo position table and two nested Gaussian mean models. Information criteria use those same likelihoods but replace null-hypothesis calibration with a penalty for estimated flexibility. This lets the penalty, rather than a change in data or response, explain any disagreement. The **optimism of training error** is the fact that performance on observations used for fitting tends to be better than expected performance on new observations. An **information criterion** estimates a correction by combining fitted likelihood with a complexity penalty. Its score is relative to compatible candidates; the absolute value has no standalone linguistic unit. Now connect the notation back to the linguistic comparison.

## Slide 109: AIC: fit plus a parameter-count penalty

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Let $\ell$ be maximized log likelihood and $k$ the number of likelihood parameters. The **Akaike information criterion (AIC)** is Greater maximized log likelihood lowers the first term; additional parameters increase the second. Lower AIC is preferred. The penalty is motivated as an approximation to relative expected predictive discrepancy, not as a significance threshold. Now connect the notation back to the linguistic comparison.

## Slide 110: AIC: fit plus a parameter-count penalty

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The displayed expression formalizes aic: fit plus a parameter-count penalty. Let $\ell$ be maximized log likelihood and $k$ the number of likelihood parameters. The **Akaike information criterion (AIC)** is Keep track of what each term refers to in the linguistic dataset.

## Slide 111: BIC: a different penalty and motivation

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The **Bayesian information criterion (BIC)** is where $n$ is the sample size supplied to the approximation. Its penalty grows with $\log n$. BIC is not merely a universally stricter AIC: it arises from a different approximation connected to model evidence under additional assumptions. Notice what is observed and what is supplied by the model.

## Slide 112: BIC: a different penalty and motivation

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The displayed expression formalizes bic: a different penalty and motivation. The **Bayesian information criterion (BIC)** is Keep track of what each term refers to in the linguistic dataset.

## Slide 113: The Provo criterion disagreement

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The code reloads the Provo table introduced on the preceding page, refits the identical linear and quadratic models, and computes both criteria. The likelihood parameter count returned by `logLik()` includes the residual scale parameter. Both criteria use the same observed position summaries. AIC prefers the observed model; the other model is worse by observed AIC points. BIC prefers the observed model; the other model is worse by observed BIC points. The empirical disagreement follows from applying different penalties to a modest fitted-likelihood gain. Use the graph or equation to say the result in ordinary language.

## Slide 114: Keeping responses and observations fixed

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Information criteria compare models only when their likelihoods concern the same observed responses. A model of raw duration and a model of log duration assign density to different response variables. Their printed values are not directly comparable without accounting for the transformation. Candidate models can also silently use different rows when an added predictor has missing values. The code thus checks the row names in both model frames. Equal row counts alone would not establish that the same positions were used. Now connect the notation back to the linguistic comparison.

## Slide 115: What the criteria do not encode

Source note: `model-criticism-and-prediction/information-criteria.qmd`

AIC approximates observation-level expected performance under its regularity conditions. It does not create held-out predictions or know which linguistic group should be new. BIC likewise cannot distinguish another position in an observed passage from a position in a passage absent during fitting. The position count also does not license reader-level or passage-level inference. Direct grouped validation is preferable when prediction for a wholly new passage is the target. Here the criteria compare two compatible likelihood models for the fixed aggregated position table. Use the graph or equation to say the result in ordinary language.

## Slide 116: Checking the penalized comparison

Source note: `model-criticism-and-prediction/information-criteria.qmd`

1. Which term rewards fitted likelihood in AIC, and which term penalizes flexibility? 2. Why can AIC and BIC prefer different Provo models while using identical fits? 3. Why must both candidates use the same response rows and response scale? 4. Which held-out unit is not represented by either criterion calculation? Information criteria combine fitted likelihood with an approximation-specific complexity penalty. The previous page calibrated the nested restriction; the next page obtains exact omitted-position predictions under a fixed Bayesian specification. That distinction will matter again on the next slide.

## Slide 117: Penalizing in-sample fit

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Penalizing in-sample fit. Read the pattern before attaching a model interpretation to it.

## Slide 118: Leaving out one unit at a time

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

We now turn to Leaving out one unit at a time. The information-criteria page approximated predictive discrepancy without constructing omitted-data predictions. **Leave-one-out cross-validation (LOO-CV)** instead makes one unit the test set at a time. The word *one* matters: here it means one Provo content-word position summary, conditional on all other positions, including positions from the same passage.

## Slide 119: Leaving out one unit at a time

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

The information-criteria page approximated predictive discrepancy without constructing omitted-data predictions. **Leave-one-out cross-validation (LOO-CV)** instead makes one unit the test set at a time. The word *one* matters: here it means one Provo content-word position summary, conditional on all other positions, including positions from the same passage. That distinction will matter again on the next slide.

## Slide 120: Defining the rotation

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Let the data contain $N$ position summaries. For each position $i$, fit the complete procedure to the data with $i$ removed. Write the fitted predictor as and its prediction as Now connect the notation back to the linguistic comparison.

## Slide 121: Defining the rotation: equation 1

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

The displayed expression formalizes defining the rotation: equation 1. Let the data contain $N$ position summaries. For each position $i$, fit the complete procedure to the data with $i$ removed. Write the fitted predictor as Keep track of what each term refers to in the linguistic dataset.

## Slide 122: Defining the rotation: equation 2

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

The displayed expression formalizes defining the rotation: equation 2. and its prediction as Keep track of what each term refers to in the linguistic dataset.

## Slide 123: Defining the rotation: equation 3

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

The displayed expression formalizes defining the rotation: equation 3. For a chosen loss $L$, the leave-one-out risk estimate is Keep track of what each term refers to in the linguistic dataset.

## Slide 124: Exact Bayesian LOO for the Provo models

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

We use the same Provo position table and Gaussian mean models as on the preceding pages. The Bayesian calculation fixes a normal-inverse-gamma prior before any position is omitted. The source paper reports excluding fixations shorter than 80 ms and longer than 800 ms. Their log-scale midpoint sets the prior intercept mean; slope means are zero. The expected residual variance treats four standard deviations as spanning those study bounds, and each coefficient's conditional prior variance multiplier is derived from the same span. That distinction will matter again on the next slide.

## Slide 125: What one means here

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

One omitted unit is a content-word position summary. Other positions from the same passage remain in the training data, and the response already averages over readers. The target is thus one position summary conditional on the remaining position table. It is not a new passage, reader, participant response, or word type. The distinction persists even though every position receives an out-of-sample prediction. Summing pointwise scores within a passage would not retroactively remove that passage from fitting. A passage target requires leave-one-passage-out validation from the start. The interpretation is conditional on the sampling and measurement design.

## Slide 126: Computation, tuning, and overlap

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Literal LOO usually requires $N$ fits, which can be expensive. Conjugacy makes all observed Provo calculations available analytically. The next page evaluates whether posterior draws from the full fit can approximate these exact omitted-position quantities. Any response-adaptive tuning would still have to occur within each (N-1) training set. Fixing a transformation or penalty after consulting all responses would let the omitted response influence its own prediction. Now connect the notation back to the linguistic comparison.

## Slide 127: Checking the omitted unit

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

1. What empirical object does one Provo LOO unit represent? 2. Which data remain available when a position is omitted? 3. Why is this not an omitted-passage analysis? 4. Which part of the prior uses the source-study measurement bounds? LOO-CV gives every position a prediction from a fit that excluded it. The previous page used an in-sample approximation; the next page approximates these exact Bayesian omitted-position densities using full-posterior draws. Use the graph or equation to say the result in ordinary language.

## Slide 128: Leaving out one unit at a time

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Leaving out one unit at a time. Read the pattern before attaching a model interpretation to it.

## Slide 129: Pareto-smoothed importance sampling leave-one-out cross-validation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

We now turn to Pareto-smoothed importance sampling leave-one-out cross-validation. The exact LOO page computed every omitted-position posterior directly under a conjugate Provo model. **Pareto-smoothed importance sampling leave-one-out cross-validation (PSIS-LOO)** approximates those omitted-data posteriors using draws from the posterior fit to all observations. Because exact values are available here, approximation error becomes observable.

## Slide 130: Pareto-smoothed importance sampling leave-one-out cross-validation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The exact LOO page computed every omitted-position posterior directly under a conjugate Provo model. **Pareto-smoothed importance sampling leave-one-out cross-validation (PSIS-LOO)** approximates those omitted-data posteriors using draws from the posterior fit to all observations. Because exact values are available here, approximation error becomes observable. Notice what is observed and what is supplied by the model.

## Slide 131: Exact Bayesian leave-one-out prediction

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Let $y_{-i}$ contain all responses except $y_i$. Given a factorized likelihood and prior $p(\theta)$, The exact predictive density is The interpretation is conditional on the sampling and measurement design.

## Slide 132: Exact Bayesian leave-one-out prediction: equation 1

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The displayed expression formalizes exact bayesian leave-one-out prediction: equation 1. Let $y_{-i}$ contain all responses except $y_i$. Given a factorized likelihood and prior $p(\theta)$, Keep track of what each term refers to in the linguistic dataset.

## Slide 133: Exact Bayesian leave-one-out prediction: equation 2

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The displayed expression formalizes exact bayesian leave-one-out prediction: equation 2. The exact predictive density is Keep track of what each term refers to in the linguistic dataset.

## Slide 134: Exact Bayesian leave-one-out prediction: equation 3

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The displayed expression formalizes exact bayesian leave-one-out prediction: equation 3. Summing its logarithm gives expected log pointwise predictive density: Keep track of what each term refers to in the linguistic dataset.

## Slide 135: Relating the omitted posterior to the full posterior

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Given draws $\theta^{(1)},\ldots,\theta^{(S)}$ from removing the (i\)th contribution gives Keep the observational unit fixed while you interpret the result.

## Slide 136: Relating the omitted posterior to the full posterior: equation 1

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The displayed expression formalizes relating the omitted posterior to the full posterior: equation 1. Given draws $\theta^{(1)},\ldots,\theta^{(S)}$ from Keep track of what each term refers to in the linguistic dataset.

## Slide 137: Relating the omitted posterior to the full posterior: equation 2

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The displayed expression formalizes relating the omitted posterior to the full posterior: equation 2. removing the (i\)th contribution gives Keep track of what each term refers to in the linguistic dataset.

## Slide 138: Relating the omitted posterior to the full posterior: equation 3

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The displayed expression formalizes relating the omitted posterior to the full posterior: equation 3. The raw importance ratio is consequently Keep track of what each term refers to in the linguistic dataset.

## Slide 139: PSIS and exact LOO on the same Provo positions

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The code reloads the Provo position table, reconstructs the fixed study-calibrated priors, draws independently from both conjugate posteriors, and preserves one log-likelihood column per position. It also recomputes exact LOO so the PSIS totals can be checked directly. The independent posterior draws make the relative effective sample size one for every position. PSIS-LOO gives ELPD observed for the linear model and observed for the quadratic model. The differences from exact conjugate LOO are observed and observed. Keep the observational unit fixed while you interpret the result.

## Slide 140: The pointwise likelihood fixes the target

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The log-likelihood matrices have observed position columns and observed posterior-draw rows. A vector of total log likelihoods cannot support omission because it discards the pointwise contributions. Default PSIS-LOO omits one such contribution. Here that contribution is one aggregated content-word position. Other positions from the same passage remain in the full posterior, so summing position scores by passage cannot create leave-one-passage-out validation. A new-passage target would require a grouped likelihood and validation design from the start. The interpretation is conditional on the sampling and measurement design.

## Slide 141: Checking the approximation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

1. Why are raw importance ratios inversely related to the held-out likelihood contribution? 2. What does Pareto $k$ diagnose? 3. Why is exact LOO available as a decisive check in this example? 4. Which prediction target is fixed by one column of the log-likelihood matrix? PSIS-LOO uses full-posterior draws to approximate omitted-position predictive density and supplies a diagnostic for that approximation. The previous page computed the exact target; the next page applies a posterior-variance correction to the same pointwise likelihood matrices. Keep the observational unit fixed while you interpret the result.

## Slide 142: Pareto-smoothed importance sampling leave-one-out cross-validation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Pareto-smoothed importance sampling leave-one-out cross-validation. Read the pattern before attaching a model interpretation to it.

## Slide 143: The widely applicable information criterion

Source note: `model-criticism-and-prediction/waic.qmd`

We now turn to The widely applicable information criterion. The PSIS-LOO page used full-posterior draws to approximate omitted-position posteriors. The **widely applicable information criterion (WAIC)** instead corrects fitted pointwise posterior predictive density using posterior variation. Both calculations require the same pointwise likelihood matrix, but their approximations differ.

## Slide 144: The widely applicable information criterion

Source note: `model-criticism-and-prediction/waic.qmd`

The PSIS-LOO page used full-posterior draws to approximate omitted-position posteriors. The **widely applicable information criterion (WAIC)** instead corrects fitted pointwise posterior predictive density using posterior variation. Both calculations require the same pointwise likelihood matrix, but their approximations differ. Now connect the notation back to the linguistic comparison.

## Slide 145: Fitted posterior predictive density

Source note: `model-criticism-and-prediction/waic.qmd`

For observation $i$, the **log pointwise predictive density (lppd)** is The average integrates the likelihood of $y_i$ over posterior uncertainty. But $y_i$ helped determine the posterior, so this remains a fitted predictive quantity. Summing gives Keep the observational unit fixed while you interpret the result.

## Slide 146: Fitted posterior predictive density: equation 1

Source note: `model-criticism-and-prediction/waic.qmd`

The displayed expression formalizes fitted posterior predictive density: equation 1. For observation $i$, the **log pointwise predictive density (lppd)** is Keep track of what each term refers to in the linguistic dataset.

## Slide 147: Fitted posterior predictive density: equation 2

Source note: `model-criticism-and-prediction/waic.qmd`

The displayed expression formalizes fitted posterior predictive density: equation 2. The average integrates the likelihood of $y_i$ over posterior uncertainty. But $y_i$ helped determine the posterior, so this remains a fitted predictive quantity. Summing gives Keep track of what each term refers to in the linguistic dataset.

## Slide 148: The pointwise optimism correction

Source note: `model-criticism-and-prediction/waic.qmd`

WAIC estimates effective flexibility from the posterior variance of each pointwise log likelihood: and Keep the observational unit fixed while you interpret the result.

## Slide 149: The pointwise optimism correction: equation 1

Source note: `model-criticism-and-prediction/waic.qmd`

The displayed expression formalizes the pointwise optimism correction: equation 1. WAIC estimates effective flexibility from the posterior variance of each pointwise log likelihood: Keep track of what each term refers to in the linguistic dataset.

## Slide 150: The pointwise optimism correction: equation 2

Source note: `model-criticism-and-prediction/waic.qmd`

The displayed expression formalizes the pointwise optimism correction: equation 2. and Keep track of what each term refers to in the linguistic dataset.

## Slide 151: The pointwise optimism correction: equation 3

Source note: `model-criticism-and-prediction/waic.qmd`

The displayed expression formalizes the pointwise optimism correction: equation 3. The effective count depends on the fitted posterior, not merely on the number of regression coefficients. WAIC's expected log predictive density is Keep track of what each term refers to in the linguistic dataset.

## Slide 152: The pointwise optimism correction: equation 4

Source note: `model-criticism-and-prediction/waic.qmd`

The displayed expression formalizes the pointwise optimism correction: equation 4. Larger values are preferred. The deviance-scale quantity is Keep track of what each term refers to in the linguistic dataset.

## Slide 153: WAIC and exact LOO for the Provo models

Source note: `model-criticism-and-prediction/waic.qmd`

The code independently reloads the Provo data, reconstructs the fixed conjugate posteriors, and generates the same independent posterior draws used for PSIS. It computes WAIC both manually and with `loo::waic()`, then compares each pointwise WAIC contribution with exact LOO. WAIC gives ELPD observed with $p_{\mathrm{waic}} = observed$ for the linear model. The quadratic values are observed and $p_{\mathrm{waic}} = observed$. The manual pointwise implementation and `loo::waic()` agree to the asserted numerical tolerance. The interpretation is conditional on the sampling and measurement design.

## Slide 154: What the correction does not change

Source note: `model-criticism-and-prediction/waic.qmd`

WAIC is tied to the unit represented by one likelihood column. Here that unit is an aggregated content-word position. The correction does not create prediction for a wholly new reader, word type, or passage. Other positions from the same passage remain part of the fitted posterior used to calculate each contribution. Large posterior variance in a pointwise log likelihood can warn that WAIC is unreliable for that position. The warning concerns the approximation; it does not license discarding a linguistically surprising point. PSIS-LOO is often easier to diagnose because Pareto $k$ targets its importance-sampling approximation directly. Use the graph or equation to say the result in ordinary language.

## Slide 155: Checking the correction

Source note: `model-criticism-and-prediction/waic.qmd`

1. Why is lppd a fitted rather than omitted-data quantity? 2. Which posterior quantity supplies WAIC's optimism correction? 3. Why can $p_{\mathrm{waic}}$ differ from a coefficient count? 4. What is the empirical unit of one point in the final figure? WAIC subtracts a posterior-variance correction from fitted pointwise predictive density. The previous page approximated omitted-position posteriors with importance sampling. Return to the module overview to place both approximations within the full model-evaluation sequence. Keep the observational unit fixed while you interpret the result.

## Slide 156: The widely applicable information criterion

Source note: `model-criticism-and-prediction/waic.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for The widely applicable information criterion. Read the pattern before attaching a model interpretation to it.

## Slide 157: Interpretation

Source note: `model-criticism-and-prediction/waic.qmd`

WAIC subtracts a posterior-variance correction from fitted pointwise predictive density. The previous page approximated omitted-position posteriors with importance sampling. Return to the module overview to place both approximations within the full model-evaluation sequence. Use the graph or equation to say the result in ordinary language.
