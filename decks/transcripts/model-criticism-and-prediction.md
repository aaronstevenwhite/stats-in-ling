# Model criticism and out-of-sample prediction

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Model criticism and out-of-sample prediction

Source note: `model-criticism-and-prediction/index.qmd`

Welcome to Model criticism and out-of-sample prediction. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Predicting observations the model did not see

Source note: `model-criticism-and-prediction/index.qmd`

The next topic is Predicting observations the model did not see.

## Slide 3: Natural Stories: the empirical object

Source note: `model-criticism-and-prediction/index.qmd`

The data source is Futrell et al., Natural Stories. It provides reader-by-word self-paced reading responses.

## Slide 4: Predicting observations the model did not see

Source note: `model-criticism-and-prediction/index.qmd`

The corrected Natural Stories release, described by Futrell et al. (2021), pairs self-paced reading times with lexical and contextual predictors in ten construction-enriched stories. The pinned data are distributed under CC BY-NC-SA 4.0. This unit begins with its participant-by-word-position responses.

## Slide 5: Predicting observations the model did not see

Source note: `model-criticism-and-prediction/index.qmd`

An observed-minus-fitted residual describes a response used to estimate a model. It does not tell us how the complete procedure will predict a response unavailable during fitting. In Natural Stories, unavailable can mean one response row, every response from one participant, or every position in one story. Predictive evaluation must therefore specify the unit held out during fitting.

## Slide 6: Predicting observations the model did not see

Source note: `model-criticism-and-prediction/index.qmd`

An observed-minus-fitted residual describes a response used to estimate a model. It does not tell us how the complete procedure will predict a response unavailable during fitting. In Natural Stories, unavailable can mean one response row, every response from one participant, or every position in one story. Predictive evaluation must therefore specify the unit held out during fitting.

## Slide 7: Predicting observations the model did not see

Source note: `model-criticism-and-prediction/index.qmd`

These targets are not interchangeable. A random row split cannot evaluate an absent participant or story because other rows from that group remain in training. Conversely, leave-one-story-out validation has only the released stories as transfer opportunities; the response-row count does not create that many independent text evaluations.

## Slide 8: Defining and scoring a prediction

Source note: `model-criticism-and-prediction/index.qmd`

Prediction targets state which responses or groups are new and which predictors remain available. Training and test data then enforce that separation, including training-only estimation of predictor transformations. A predictive loss scores each held-out prediction. The bias--variance tradeoff explains why a procedure can closely fit one training sample yet vary across samples.

## Slide 9: Defining and scoring a prediction

Source note: `model-criticism-and-prediction/index.qmd`

Cross-validation rotates a row-level split. Grouped cross-validation instead moves complete participants or stories together. These pages use the same Natural Stories population regression so that changing the split changes the predictive claim rather than the fitted predictor set. The teaching fit omits participant and story effects to expose those targets; it does not reproduce the source paper's validation models.

## Slide 10: Comparing models

Source note: `model-criticism-and-prediction/index.qmd`

Comparing predictive loss moves to MegaOrientation and evaluates additive and frame-specific ordinal models on verbs absent from fitting. This switch marks a conceptual break: the target becomes lexical transfer, and the response becomes ordered rather than continuous. The comparison thus follows the course's introduction to cumulative-logit regression. Its population fits omit participant and item heterogeneity, and the comparison remains conditional on the release's acceptability-selected predicate-frame inventory.

## Slide 11: Comparing models

Source note: `model-criticism-and-prediction/index.qmd`

The final pages return to the Provo passage summaries used earlier in the course. Likelihood-ratio tests compare nested Gaussian models; information criteria add fit penalties; leave-one-out cross-validation, PSIS-LOO, and WAIC use matched observations and pointwise log-likelihood contributions. Each comparison keeps the response rows and candidate model family fixed.

## Slide 12: Comparing models

Source note: `model-criticism-and-prediction/index.qmd`

Successful prediction does not by itself identify a processing mechanism. The module thus proceeds in one order: name the prediction unit, separate fitting from scoring, choose and aggregate the loss, rotate the separation, and only then compare models.

## Slide 13: What must be new at prediction time

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Next, we take up What must be new at prediction time.

## Slide 14: What must be new at prediction time

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

The earlier page on populations and samples required an inferential claim to specify the population represented by a sample. Predictive evaluation requires a related decision. We must say which responses were unavailable during fitting and what information is available when those responses are predicted. The module introduction describes this choice of held-out unit.

## Slide 15: What must be new at prediction time

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

**Out-of-sample prediction** predicts responses that did not contribute to fitting the model. Out-of-sample can mean a new response row, a new reader, or a new text; the distinction must be stated.

## Slide 16: Natural Stories

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

We use the corrected Natural Stories release, introduced and validated by Futrell et al. (2021), throughout the first six pages of this unit. The corpus contains English stories enriched for low-frequency syntactic constructions, self-paced reading times, and aligned lexical annotations. The corrected release fixes a one-position displacement in the reading-time records. Its preprocessing excludes reader-story passes with fewer than five correct comprehension answers and reading times outside the release's 100-to-3,000-ms window.

## Slide 17: Natural Stories

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

the calculation constructs the prediction table from the tracked release. One row is one retained button latency for one reader at one word position. It is a self-paced reading time, not an eye fixation.

## Slide 18: Natural Stories

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

This figure shows observed linguistic data for Natural Stories.

## Slide 19: Natural Stories

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

The prepared release has 848,875 response rows from 180 participants and 10 stories. Requiring finite word length, log unigram frequency, and GPT-3 surprisal retains 846,537 rows at 10,228 contextual word positions. The figure shows why a response row, participant, and story are not interchangeable units: the participant and story means vary, but there are only 10 story-level values.

## Slide 20: Three prediction targets

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

All three procedures used later fit the population regression

$$
\log RT_i
=
\beta_0+\beta_1z(L_i)+\beta_2z(F_i)+\beta_3z(S_i)+\epsilon_i,
$$

where $L_i$ is word length, $F_i$ is log unigram frequency, and $S_i$ is released GPT-3 surprisal.

## Slide 21: Three prediction targets

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

What changes is the **prediction unit**, the object excluded from training.

## Slide 22: Three prediction targets

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

where $L_i$ is word length, $F_i$ is log unigram frequency, and $S_i$ is released GPT-3 surprisal. What changes is the **prediction unit**, the object excluded from training.

## Slide 23: Three prediction targets

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

These separations ask different questions. A random row split evaluates another response from the represented collection of readers and stories. A participant split evaluates a reader absent from fitting. A story split evaluates one omitted member of these deliberately enriched texts.

## Slide 24: Three prediction targets

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

The story target needs especially narrow wording. The corpus supplies 10 opportunities to inspect an omitted story, not 846,537 independent story transfers. Leave-one-story-out results consequently describe these ten omissions; they do not estimate performance for an unrestricted population of English texts.

## Slide 25: The prediction information set

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Holding out a group does not by itself determine which information about it may be used. In these analyses, a held-out row keeps its word length, frequency, and surprisal because those predictors are available at prediction time. A held-out participant contributes no reading-time response to fitting. A held-out story contributes its lexical predictors but no response from any of its positions.

## Slide 26: The prediction information set

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

The preprocessing rule is part of the information set. Each predictor mean and standard deviation is estimated from training rows and then applied to test rows. A full-data center would let held-out predictor values affect the training representation. A separately estimated test center would place the test observations in a different coordinate system.

## Slide 27: Theory determines what should be held out

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

The most demanding split is not automatically the right one. A reading model used for an already represented reader may reasonably target another response row. A claim about transfer across readers requires participant folds. A claim about connected text requires story folds and enough story-level replication to support it.

## Slide 28: Theory determines what should be held out

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Successful prediction also does not establish a processing mechanism. Word surprisal can improve a held-out score without showing that readers internally represent the fitted language model's probabilities. Predictive evaluation establishes performance for a stated response, information set, split, and population; the mechanism requires additional evidence.

## Slide 29: Checking the target

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Which Natural Stories target keeps the same reader and story represented during fitting?

## Slide 30: Checking the target

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

What must move together when the target is a reader absent during fitting?

## Slide 31: Checking the target

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Why do the retained response rows not provide that many independent evaluations of an omitted story?

## Slide 32: Checking the target

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Which predictor transformations must be estimated without the held-out responses?

## Slide 33: Checking the target

Source note: `model-criticism-and-prediction/prediction-targets.qmd`

Out-of-sample prediction requires a response excluded from fitting. A complete predictive question also states which groups are held out, which predictors remain available, and where the result should generalize. The previous page introduces this sequence; the next page implements one participant-held-out split and makes its training-only preprocessing visible.

## Slide 34: Training and test data

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The next topic is Training and test data.

## Slide 35: Training and test data

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The prediction-target page fixed three meanings of *new* for the corrected Natural Stories data. We now make one participant-held-out separation observable. The **training set** estimates every fitted quantity; the **test set** is used only to evaluate the resulting predictions.

## Slide 36: Training and test data

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The residuals of a fitted regression are observed-minus-fitted discrepancies on the observations used to estimate its coefficients. A flexible model can reduce those residuals by following features of the training responses that will not recur. Training fit thus cannot by itself estimate predictive loss for a reader absent during fitting.

## Slide 37: The separation rule

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

Let $D_{\mathrm{train}}$ and $D_{\mathrm{test}}$ be disjoint collections of observations. A fitted predictor is

$$
\widehat{f}_{\mathrm{train}}
=
\operatorname{Fit}(D_{\mathrm{train}}),
$$

and test loss is

$$
\widehat{R}_{\mathrm{test}}
=
\frac{1}{|D_{\mathrm{test}}|}
\sum_{i\in D_{\mathrm{test}}}
L\left(y_i,\widehat{f}_{\mathrm{train}}(x_i)\right).
$$

## Slide 38: The separation rule

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The subscript on $\widehat f$ is essential. Test responses must not influence the coefficients, predictor transformations, model choice, or any other fitted quantity used to produce their predictions.

## Slide 39: A participant-held-out Natural Stories split

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The data and their source are introduced on the prediction-target page. The following code independently loads the tracked release, recreates the frozen participant folds, learns all transformations from the training rows, and predicts the first held-out fold.

## Slide 40: A participant-held-out Natural Stories split

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

This figure shows observed linguistic data for A participant-held-out Natural Stories split.

## Slide 41: A participant-held-out Natural Stories split

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The training set contains 680,544 responses from 144 readers. The test set contains 165,993 responses from 36 readers. All 10 stories remain represented on both sides, so the target is a new reader of these stories rather than a new text.

## Slide 42: A participant-held-out Natural Stories split

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The gray points show a reproducible display sample of raw held-out responses. The blue points and intervals summarize those responses within prediction deciles. This combines the raw test outcomes and the fitted model without using test responses to estimate the regression.

## Slide 43: Leakage through preprocessing

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

**Data leakage** occurs when information from the test set influences a fitted decision that should have been made without it. Directly fitting on a test response is one case, but preprocessing can leak more quietly.

## Slide 44: Leakage through preprocessing

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

- Centering a predictor using the complete dataset lets held-out predictor values affect the training representation. - Imputing a missing test response from a full-data mean uses held-out responses. - Selecting predictors by their full-data response correlation consults the test set. - Choosing a model because it has the best test score turns the test data into selection data. - Averaging reading times over readers before holding readers out carries their responses into the target.

## Slide 45: Leakage through preprocessing

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

For a standardized predictor, the training mean $\overline{x}_{\mathrm{train}}$ and standard deviation $s_{\mathrm{train}}$ define

$$
z_i=\frac{x_i-\overline{x}_{\mathrm{train}}}{s_{\mathrm{train}}}
$$

for both training and test observations.

## Slide 46: Leakage through preprocessing

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The test data are not standardized separately, because that would change the coordinate system. The complete-data moments are also excluded, because they would make the training representation depend on held-out rows.

## Slide 47: One split and repeated decisions

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

A single split combines model performance with the composition of one test set. Increasing the test fraction provides more evaluation responses but fewer fitting responses; decreasing it has the opposite effect. Cross-validation rotates the test role so that every observation receives a held-out prediction.

## Slide 48: One split and repeated decisions

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

The test set is also not a renewable source of decisions. If several specifications are compared on these responses and the best is selected, its reported score is optimistic. A three-way split or nested cross-validation keeps final test responses outside both coefficient fitting and model selection.

## Slide 49: Checking the separation

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

Which participants contribute responses to both sets in this split?

## Slide 50: Checking the separation

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

Which moments define the test-set predictor transformation?

## Slide 51: Checking the separation

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

Why does the calibration figure not estimate an omitted-story target?

## Slide 52: Checking the separation

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

What changes if the test responses guide model selection?

## Slide 53: Checking the separation

Source note: `model-criticism-and-prediction/training-and-test-data.qmd`

Separating training and test data allows parameters and preprocessing to be estimated without the responses on which predictive loss is computed. The previous page fixed the prediction unit; the next page defines the numerical consequence assigned to these participant-held-out errors.

## Slide 54: Predictive loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Our next step is Predictive loss.

## Slide 55: Predictive loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The training-and-test page produced predictions for readers absent during fitting. An evaluation still needs a loss function and an averaging unit. These choices determine which misses receive the most weight and which empirical units receive equal influence.

## Slide 56: Predictive loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

A **loss function** $L(y,\widehat y)$ assigns a nonnegative cost to predicting $\widehat y$ when the observed response is $y$. The **predictive risk** is expected loss on new responses from the population under study. A held-out mean loss estimates that expectation for the split and averaging unit stated by the analysis.

## Slide 57: Squared and absolute loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The **squared-error loss** is

$$
L_{\mathrm{SE}}(y,\widehat y)=(y-\widehat y)^2.
$$

## Slide 58: Squared and absolute loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Over $N$ held-out predictions, mean squared error and root mean squared error are

$$
\operatorname{MSE}
=
\frac{1}{N}\sum_{i=1}^N(y_i-\widehat y_i)^2,
\qquad
\operatorname{RMSE}=\sqrt{\operatorname{MSE}}.
$$

## Slide 59: Squared and absolute loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Squaring gives large errors disproportionate influence. Taking the root returns the score to the response scale. For Natural Stories, that scale is log reading time, not milliseconds. The conditional mean is the optimal point prediction under squared loss.

## Slide 60: Squared and absolute loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The **absolute-error loss** is

$$
L_{\mathrm{AE}}(y,\widehat y)=|y-\widehat y|,
$$

with held-out average

$$
\operatorname{MAE}
=
\frac{1}{N}\sum_{i=1}^N|y_i-\widehat y_i|.
$$

## Slide 61: Squared and absolute loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Absolute loss grows linearly, and the conditional median is its optimal point prediction. Reporting RMSE and MAE can expose sensitivity to large errors, but the analysis should still designate a primary loss before comparing models.

## Slide 62: Computing loss for held-out Natural Stories readers

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

the calculation reconstructs participant fold 1 from the Natural Stories run, fits the same fold-local regression, and computes the errors. It then averages squared and absolute loss in two ways: once over response rows and once within readers before averaging readers.

## Slide 63: Computing loss for held-out Natural Stories readers

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

This figure shows observed linguistic data for Computing loss for held-out Natural Stories readers.

## Slide 64: Computing loss for held-out Natural Stories readers

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

The row-weighted RMSE is 0.4140 and MAE is 0.3331. Giving each held-out reader equal weight yields RMSE 0.4370 and MAE 0.3468. The calculations use the same predictions. They differ because the second estimand first averages loss within each of the 36 readers.

## Slide 65: Computing loss for held-out Natural Stories readers

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Changing the averaging unit changes the estimand. Row weighting describes a randomly selected retained response from the fold. Participant weighting describes first selecting uniformly among held-out readers and then averaging that reader's responses. Neither is neutral, and neither becomes a story-level estimate merely because all stories occur in the data.

## Slide 66: Loss is not explanatory adequacy

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Lower predictive loss does not show that a predictor is causal or that a reader internally computes the fitted predictor. In this regression, lower loss from GPT-3 surprisal would not isolate lexical expectation from correlated properties of words and contexts. Prediction evaluates a specified mapping from available information to responses under a stated separation.

## Slide 67: Loss is not explanatory adequacy

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Conversely, a theoretically meaningful coefficient can contribute little to held-out prediction. A small, stable association may be estimable while accounting for little response variation. Predictive loss thus addresses an additional question rather than replacing parameter interpretation.

## Slide 68: Checking the loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Which score is more sensitive to a small number of large errors?

## Slide 69: Checking the loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

On what response scale are the reported Natural Stories scores?

## Slide 70: Checking the loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Why do row-weighted and participant-weighted losses differ when their prediction vector is identical?

## Slide 71: Checking the loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

Can a nonzero coefficient fail to improve held-out loss?

## Slide 72: Checking the loss

Source note: `model-criticism-and-prediction/predictive-loss.qmd`

A loss function defines the consequence of each error, while the averaging unit determines what receives equal weight. The previous page constructed the split. The next page uses an empirically calibrated simulation to separate prediction bias and prediction variance.

## Slide 73: Prediction bias and prediction variance

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

Our next step is Prediction bias and prediction variance.

## Slide 74: Prediction bias and prediction variance

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The earlier pages defined estimator bias, estimator variance, and their contribution to mean squared error. Here the estimator is a fitted prediction at a specified predictor vector. The same decomposition concerns prediction bias and prediction variance across repeated training samples.

## Slide 75: Prediction bias and prediction variance

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

A linear reading-time model may miss curvature in the association among length, frequency, surprisal, and mean response. A more flexible model may instead follow sample-specific variation. The **bias-variance decomposition** separates these two failure modes.

## Slide 76: Beginning with repeated training samples

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

At a fixed predictor vector $x$, let the response be generated by

$$
Y=f(x)+\varepsilon,
$$

where $f(x)=\mathbb{E}[Y\mid X=x]$ and

$$
\mathbb{E}[\varepsilon\mid X=x]=0,
\qquad
\operatorname{Var}[\varepsilon\mid X=x]=\sigma^2.
$$

## Slide 77: Beginning with repeated training samples

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

Repeatedly drawing a comparable training sample and applying the same complete fitting procedure produces a different $\widehat f(x)$ on each repetition. Prediction variance describes variation among those learned predictions. It does not describe variation among observed responses with the same predictors.

## Slide 78: Beginning with repeated training samples

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The bias and prediction variance are

$$
\operatorname{Bias}(\widehat f(x))
=
\mathbb{E}[\widehat f(x)]-f(x)
$$

and

$$
\operatorname{Var}[\widehat f(x)]
=
\mathbb{E}\left[
  \left(\widehat f(x)-\mathbb{E}[\widehat f(x)]\right)^2
\right].
$$

## Slide 79: Deriving the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

We want expected squared error for a new response at the fixed predictor vector:

$$
\mathbb{E}\left[(Y-\widehat f(x))^2\right].
$$

## Slide 80: Deriving the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

Add and subtract both $f(x)$ and $\mathbb{E}[\widehat f(x)]$:

$$
Y-\widehat f(x)
=
\underbrace{Y-f(x)}_{\text{response noise}}
+
\underbrace{f(x)-\mathbb{E}[\widehat f(x)]}_{\text{negative bias}}
+
\underbrace{\mathbb{E}[\widehat f(x)]-\widehat f(x)}_{\text{training-sample variation}}.
$$

## Slide 81: Deriving the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

After squaring, the expected cross-products are zero because the response noise has mean zero and the fitted predictions are centered around their own expectation. Thus,

$$
\mathbb{E}\left[(Y-\widehat f(x))^2\right]
=
\sigma^2
+
\operatorname{Bias}(\widehat f(x))^2
+
\operatorname{Var}[\widehat f(x)].
$$

## Slide 82: Deriving the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The first term is **irreducible error** under the declared data-generating process. The other two terms depend on the complete learning procedure.

## Slide 83: An empirically calibrated Natural Stories simulation

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

True bias is not identified from one observed corpus. We thus use the only simulation in this module and label its assumptions. the calculation loads the Natural Stories data, averages responses and predictors to observed story positions, fits a cubic reference surface, and declares that fitted surface to be the simulation truth. Each repetition samples actual positions with replacement and adds a residual resampled from that empirical fit.

## Slide 84: An empirically calibrated Natural Stories simulation

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The target is also an observed position rather than an invented predictor vector. It is the position closest to the observed 90th percentile of surprisal and the median frequency and length.

## Slide 85: An empirically calibrated Natural Stories simulation

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

This figure shows observed linguistic data for An empirically calibrated Natural Stories simulation.

## Slide 86: An empirically calibrated Natural Stories simulation

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

At observed position 1:887, the declared mean is 5.74287 and the residual variance is 0.007422. The cubic procedure has squared bias 0.000000 and prediction variance 0.000111. The linear procedure has squared bias 0.000012 and variance 0.000066.

## Slide 87: An empirically calibrated Natural Stories simulation

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The flexible procedure reduces squared bias but increases prediction variance. Under this declared simulation, its expected squared error is 0.007534, compared with 0.007501 for the linear procedure. The gray violins show all repeated predictions, the blue points show their means, and the horizontal line shows the assumed truth.

## Slide 88: What the simulation establishes

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

This calibration demonstrates the decomposition using observed predictor values, response scale, and residuals. It does not estimate the unknown Natural Stories data-generating process. The cubic reference surface is assumed true for the exercise; another calibrated truth could change the comparison.

## Slide 89: What the simulation establishes

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The example also shows why coefficient count is not a definition of prediction variance. Regularization, sample size, preprocessing, and the predictor distribution all affect how much a procedure changes across training samples. Held-out loss can evaluate their combined consequence, but it cannot identify separate bias and variance terms without an assumption about $f(x)$.

## Slide 90: Checking the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

Across which repetitions is $\operatorname{Var}[\widehat f(x)]$ defined?

## Slide 91: Checking the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

Which procedure has smaller squared bias at the selected Natural Stories position?

## Slide 92: Checking the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

Which procedure has smaller expected squared error under the declared simulation?

## Slide 93: Checking the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

Why is the horizontal line an assumed truth rather than an estimate of the unknown response process?

## Slide 94: Checking the decomposition

Source note: `model-criticism-and-prediction/bias-variance-tradeoff.qmd`

The bias-variance decomposition explains why a procedure that follows training data more closely need not predict a new response better. The previous page defined held-out loss. The next page rotates the training and test roles to obtain predictions for every retained response.

## Slide 95: Cross-validation

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Now we turn to Cross-validation.

## Slide 96: Cross-validation

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The training-and-test page separated one training set from one test set. **$K$-fold cross-validation (CV)** reduces dependence on a single partition by rotating which fold serves as the test set.

## Slide 97: Cross-validation

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The output is one out-of-fold prediction for every observation. Each prediction comes from a fit that excluded that response. This does not make its reader or story new as well; the fold construction determines which units cross the training-test boundary.

## Slide 98: Cross-validation

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Nicenboim, Schad, and Vasishth, *Cross-validation*, in *An Introduction to Bayesian Data Analysis for Cognitive Science*.

## Slide 99: Cross-validation

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Read the chapter opening and Section 14.2 through Equation 14.6. These passages distinguish training data from held-out data and derive the rotation used here.

## Slide 100: The algorithm

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Partition observation indices into disjoint folds $F_1,\ldots,F_K$. For fold $k$: fit the complete procedure to observations outside $F_k$. use that fitted procedure to predict observations in $F_k$; and store the predictions in their original rows.

## Slide 101: The algorithm

Source note: `model-criticism-and-prediction/cross-validation.qmd`

After every fold has been processed,

$$
\widehat R_{\mathrm{CV}}
=
\frac{1}{N}
\sum_{k=1}^K
\sum_{i\in F_k}
L\left(y_i,\widehat f_{-k}(x_i)\right),
$$

where $\widehat f_{-k}$ is fit without fold $k$.

## Slide 102: The algorithm

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The fitted model changes across folds, but the procedure remains fixed.

## Slide 103: Random-row validation in Natural Stories

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The following code independently loads the corrected Natural Stories data, assigns retained responses to five random folds with the frozen seed, fits the same standardized regression inside each fold, and stores every held-out prediction. Predictor moments are recomputed from the training rows of each fold.

## Slide 104: Random-row validation in Natural Stories

Source note: `model-criticism-and-prediction/cross-validation.qmd`

This figure shows observed linguistic data for Random-row validation in Natural Stories.

## Slide 105: Random-row validation in Natural Stories

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The five fold RMSEs range from 0.3794 to 0.3801. Every held-out fold contains responses from all 10 stories and 179 to 180 represented participants. The estimand is thus a new retained response when its story and reader remain represented in training.

## Slide 106: Random-row validation in Natural Stories

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The stored prediction vector is more useful than the fold means alone. It permits prespecified inspection by response range, story, reader, or linguistic category and permits paired model comparisons on identical rows. A category discovered only after inspecting its errors supplies exploratory evidence.

## Slide 107: Every fitted decision stays inside the loop

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Cross-validation evaluates the complete procedure, not just its final coefficient formula. Centering, scaling, feature selection, imputation, and penalty tuning must be repeated using only each training portion. A tuning parameter requires an inner validation loop if it adapts to responses; the outer prediction then evaluates the complete selection rule.

## Slide 108: Every fitted decision stays inside the loop

Source note: `model-criticism-and-prediction/cross-validation.qmd`

This nesting is unnecessary when the specification is fixed in advance. The Natural Stories code has no tuning step: its predictor set and fold seed are fixed, but its training moments and regression coefficients remain fold-specific.

## Slide 109: What $K$ changes

Source note: `model-criticism-and-prediction/cross-validation.qmd`

With larger $K$, each model uses a larger training fraction and a smaller test fold. Leave-one-out CV sets $K=N$ for row-level omission. Fewer folds cost less computation but fit on less of the data for each prediction.

## Slide 110: What $K$ changes

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Fold count is a design setting, not a probability law. If the scientific target is an omitted story, the ten story identifiers naturally define ten held-out groups. Randomly creating more row folds cannot manufacture additional story-level replication.

## Slide 111: Fold scores are not independent experiments

Source note: `model-criticism-and-prediction/cross-validation.qmd`

The five fits reuse most of their training rows. Their losses are consequently not five independent studies. A test applied to fold means would treat computational partitions as if they were sampling units.

## Slide 112: Fold scores are not independent experiments

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Predictive differences should instead be returned to the groups specified by the claim. For an omitted-story claim, that means story-level losses even when several stories share one computational fold. The next page changes the fold assignment while retaining the same fitting algorithm.

## Slide 113: Checking the split

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Why is each stored prediction out of sample for its response?

## Slide 114: Checking the split

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Which quantities are re-estimated inside every Natural Stories fold?

## Slide 115: Checking the split

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Why does this random-row procedure not evaluate a reader or story absent from fitting?

## Slide 116: Checking the split

Source note: `model-criticism-and-prediction/cross-validation.qmd`

Why are the five fold scores not independent experiments?

## Slide 117: Checking the split

Source note: `model-criticism-and-prediction/cross-validation.qmd`

$K$-fold CV rotates training and test roles to obtain one held-out prediction per response. The previous page described repeated training samples; the next page keeps complete participants and stories together when those groups must be absent during fitting.

## Slide 118: Grouped cross-validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Our next step is Grouped cross-validation.

## Slide 119: Grouped cross-validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

The cross-validation page placed response rows into random folds. The same reader and story consequently occurred in both training and test data. **Grouped $K$-fold cross-validation** instead assigns every row from a group to the same fold.

## Slide 120: Grouped cross-validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

The Natural Stories introduction fixed participant and story as two candidate grouping units. Holding out participants evaluates new readers of the represented stories. Holding out a story evaluates one omitted member of the ten construction-enriched texts.

## Slide 121: Constructing grouped folds

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Let $g(i)$ be the group containing observation $i$. Grouped validation requires

$$
g(i)=g(j)
\quad\Longrightarrow\quad
\operatorname{fold}(i)=\operatorname{fold}(j).
$$

## Slide 122: Constructing grouped folds

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

The group controls both the split and the interpretation. Moving story rows together removes its sentences and word positions automatically; splitting sentences cannot evaluate an omitted story if other sentences from the same story remain in training.

## Slide 123: Participant and story validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

the calculation fits the same population regression under two grouped designs. Participants receive five frozen folds. Stories use leave-one-story-out validation. For the story comparison, a base model includes length and frequency, while an expanded model adds GPT-3 surprisal. Each training fold estimates its own predictor moments.

## Slide 124: Participant and story validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

This figure shows observed linguistic data for Participant and story validation.

## Slide 125: Participant and story validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Participant-fold RMSE ranges from 0.3489 to 0.4140. Story-fold RMSE ranges from 0.3601 to 0.3966. These ranges should not be treated as a difficulty ranking because the held-out groups differ in size and composition. They show that predictive performance is a property of the validation target.

## Slide 126: Participant and story validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Adding surprisal lowers leave-one-story-out RMSE for stories 1, 3, 4, 5, 7 and raises it for stories 2, 6, 8, 9, 10. The changes range from -0.000145 to 0.000205 log-time units. Showing all story points prevents a pooled claim from concealing this heterogeneity.

## Slide 127: Group-weighted scores

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

For group $g$ with $n_g$ responses, define

$$
\overline L_g
=
\frac{1}{n_g}
\sum_{i:g(i)=g}L(y_i,\widehat y_i).
$$

## Slide 128: Group-weighted scores

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

A group-weighted score is

$$
\frac{1}{G}\sum_{g=1}^G\overline L_g.
$$

## Slide 129: Group-weighted scores

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Each group receives equal weight. A row-weighted score instead pools all responses before averaging. The latter may be useful for corpus prediction, but its uncertainty cannot treat positions from one story as independent story transfers.

## Slide 130: Group leakage and limits

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Moving rows together does not prevent leakage from a response-derived predictor constructed before the split. A word-position mean reading time computed across all participants would contain the test participants' responses. For that reason, this analysis retains participant-level response rows and fits predictor transformations inside folds.

## Slide 131: Group leakage and limits

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

The participant model remains a population regression without participant or story effects. It is designed to expose the difference among targets, not to reproduce the mixed-effects validation in Futrell et al. The story results concern ten omitted enriched texts. They do not license generalization to arbitrary English stories.

## Slide 132: Checking the grouping variable

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Why is a sentence split insufficient for an omitted-story target?

## Slide 133: Checking the grouping variable

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Which assertion verifies that participants do not cross folds?

## Slide 134: Checking the grouping variable

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Why can row-weighted and group-weighted losses answer different questions?

## Slide 135: Checking the grouping variable

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

What does the story-difference plot show that a pooled RMSE change would hide?

## Slide 136: Checking the grouping variable

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

Grouped cross-validation makes a complete empirical group absent during fitting. The previous page evaluated new rows from represented readers and stories. The next page switches to MegaOrientation and compares ordinal models on entirely unseen verbs.

## Slide 137: Grouped cross-validation

Source note: `model-criticism-and-prediction/grouped-cross-validation.qmd`

This figure shows observed data and fitted quantities for Grouped cross-validation.

## Slide 138: Comparing predictive loss

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

Next, we take up Comparing predictive loss.

## Slide 139: MegaOrientation: the empirical object

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The data source is Moon and White (2020), MegaOrientation v1.1. It provides ordinal attitude reports grouped by embedded verb.

## Slide 140: Comparing predictive loss

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The grouped-validation page returned held-out losses to the groups omitted during fitting. Comparing two procedures requires pairing their predictions on those same groups. We now use an ordinal response and hold out complete verb types, which makes both the loss and the new-verb prediction task visible.

## Slide 141: MegaOrientation

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

Moon and White (2020) constructed sentence pairs that force past- or future-oriented interpretations by combining matrix tense or modality with an incompatible embedded temporal adverb. Participants rated the sentences on a 1-to-7 acceptability scale. The corrected MegaOrientation v1.1 release changes the released participant and verb inventories after items with irregular-inflection errors were rerun.

## Slide 142: MegaOrientation

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The original paper fits latent lexical, structural, and mixed models with participant-specific ordinal cutpoints. The teaching comparison is narrower. It restricts the release to verbs attested in at least two frames, fits population cumulative-logit models, and holds out every response from a verb together. Thus, the target is an unseen verb within the selected multi-frame inventory, not a reproduction of the paper's latent-type comparison.

## Slide 143: MegaOrientation

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The two models are

$$
\begin{aligned}
M_0 &: \text{response}\sim\text{orientation}+\text{frame},\\
M_1 &: \text{response}\sim\text{orientation}*\text{frame}.
\end{aligned}
$$

## Slide 144: MegaOrientation

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

For response $y_i$, the ordinal log score is

$$
L_i(M)=-\log p_M(Y_i=y_i\mid x_i).
$$

## Slide 145: MegaOrientation

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

Equivalently, we can compare the log probability itself, where larger values are better. The sign convention below reports $\log p_{M_1}-\log p_{M_0}$, so positive values favor the interaction.

## Slide 146: Held-out-verb comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

the calculation loads the tracked response table and frozen verb folds, fits both ordinal models in every fold, and extracts the probability assigned to each observed rating. It first averages log scores within verbs and only then averages the 662 verbs, preventing verbs with more judgment rows from receiving greater weight.

## Slide 147: Held-out-verb comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

This figure shows observed linguistic data for Held-out-verb comparison.

## Slide 148: Held-out-verb comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The interaction improves the verb-weighted mean log score by 0.00973, with a conditional verb-bootstrap interval of [0.00818, 0.01145]. The row-weighted gain is 0.00883, and 5 of 5 folds favor the interaction. The gray points show all held-out verb differences; the blue points show fold means.

## Slide 149: Raw responses and the descriptive fit

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The predictive comparison uses held-out verbs. A full-data interaction fit serves a different purpose: it lets us check fitted ordinal probabilities against the empirical rating distribution in each represented frame-orientation cell.

## Slide 150: Raw responses and the descriptive fit

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

This figure shows observed linguistic data for Raw responses and the descriptive fit.

## Slide 151: Raw responses and the descriptive fit

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The tracked comparison contains 39,440 judgments from 662 multi-frame verbs and 1972 predicate-frame pairs. Points are empirical category probabilities; lines are the descriptive full-data interaction fit. Those fitted lines do not supply the held-out comparison numbers.

## Slide 152: Scope of the gain

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The conditional bootstrap resamples the stored verb differences while holding the fitted cross-validation predictions fixed. It respects verb as the resampling unit, but it does not reproduce participant, item, or refitting uncertainty. The population models also omit participant and sentence-item effects. Thus, the interval is useful for the paired-loss lesson, not a full confirmatory analysis of the experiment.

## Slide 153: Scope of the gain

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

The interaction gain suggests that frame-specific orientation patterns help predict ratings for unseen verbs within this selected inventory. It does not turn acceptability into a directly observed temporal-orientation label, reproduce Moon and White's lexical-versus-structural theory comparison, or generalize to unrestricted English embedding verbs.

## Slide 154: Checking the comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

Why does a positive difference favor the interaction model?

## Slide 155: Checking the comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

Why are log scores averaged within verbs before the primary mean is taken?

## Slide 156: Checking the comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

What does the full-data probability plot check, and what does it not estimate?

## Slide 157: Checking the comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

Which omitted sources of dependence limit the bootstrap interval?

## Slide 158: Checking the comparison

Source note: `model-criticism-and-prediction/comparing-predictive-loss.qmd`

A paired comparison evaluates two models on identical held-out groups and returns their differences to the unit specified by the scientific claim. The previous page developed grouped splitting with Natural Stories. The next page begins a five-page Provo sequence using two fixed Gaussian mean models.

## Slide 159: Comparing nested likelihoods

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Now we turn to Comparing nested likelihoods.

## Slide 160: Provo: the empirical object

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The data source is Luke and Christianson (2018), Provo Corpus. It provides content-word positions aggregated across Provo readers.

## Slide 161: Comparing nested likelihoods

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The earlier maximum-likelihood page compared parameter values within one model. A likelihood-ratio test compares two models when one is a restricted version of the other. Across five pages, one response table and two nested Gaussian models stay fixed while the comparison criterion changes.

## Slide 162: Provo Corpus

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Luke and Christianson (2018) released cloze norms for each word in English passages and eye-movement measurements from readers of those passages. The OSF release includes `OrthoMatchModel`, an orthographic-match cloze estimate from a logit mixed model with word intercepts. It is a fitted cloze estimate, not a language-model probability.

## Slide 163: Provo Corpus

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The tracked course table retains complete content-word positions from all passages and averages first-fixation duration across readers at each position. One row is thus a position summary, not one reader's fixation. The analyses below cannot recover reader-level dependence from that aggregation.

## Slide 164: Provo Corpus

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Let $y_i$ be mean log first-fixation duration and let

$$
x_i=-\log_2(\texttt{OrthoMatchModel}_i)
$$

be modeled cloze surprisal in bits.

## Slide 165: Provo Corpus

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The restricted and expanded models are

$$
\begin{aligned}
M_L &: y_i=\beta_0+\beta_1x_i+\epsilon_i,\\
M_Q &: y_i=\beta_0+\beta_1x_i+\beta_2x_i^2+\epsilon_i,
\qquad \epsilon_i\sim\operatorname{Normal}(0,\sigma^2).
\end{aligned}
$$

## Slide 166: Provo Corpus

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Setting $\beta_2=0$ in $M_Q$ gives $M_L$, so $M_L\subset M_Q$. This nesting statement also requires identical response rows, response distribution, variance specification, and likelihood definition.

## Slide 167: From a likelihood ratio to a difference

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Let $\widehat L_L$ and $\widehat L_Q$ be the maximized likelihoods. Since the expanded model can reproduce the restricted fit,

$$
\widehat L_Q\geq\widehat L_L.
$$

## Slide 168: From a likelihood ratio to a difference

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The likelihood-ratio statistic is

$$
\begin{aligned}
\Lambda
&=-2\log\left(\frac{\widehat L_L}{\widehat L_Q}\right)\\
&=-2(\log\widehat L_L-\log\widehat L_Q)\\
&=2(\ell_Q-\ell_L).
\end{aligned}
$$

When the expanded model adds regular parameters and the usual large-sample conditions hold,

$$
\Lambda\overset{\cdot}{\sim}\chi^2_{k_Q-k_L}
$$

under the restricted model.

## Slide 169: From a likelihood ratio to a difference

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The degrees of freedom equal the difference in freely estimated regular parameters.

## Slide 170: Fitting the Provo models

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

the calculation reads the tracked position table, constructs surprisal, fits both models to exactly the same rows, computes the LRT, and plots every position with both fitted means.

## Slide 171: Fitting the Provo models

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

This figure shows observed linguistic data for Fitting the Provo models.

## Slide 172: Fitting the Provo models

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The common analysis table has 1,593 positions from 55 passages. The linear and quadratic log likelihoods are 1490.543 and 1493.619. Thus,

$$
\Lambda
=
2\left(1493.619-
1490.543\right)
=
6.152.
$$

## Slide 173: Fitting the Provo models

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The expanded model adds 1 likelihood parameter, giving $p = 0.0131$ under the usual $\chi^2$ approximation. The plot keeps the raw position summaries visible with both fitted mean functions. The curvature is slight, which makes the criterion comparisons on the following pages substantively readable.

## Slide 174: Interpreting the restriction narrowly

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The null hypothesis is

$$
H_0:\beta_2=0.
$$

## Slide 175: Interpreting the restriction narrowly

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Rejecting this restriction suggests that the quadratic term improves fitted likelihood conditional on this response, sample, and Gaussian specification. It does not show that the quadratic model is true, that cloze surprisal causes fixation-duration differences, or that readers internally represent `OrthoMatchModel`.

## Slide 176: Interpreting the restriction narrowly

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The LRT also does not evaluate a new passage. All positions contribute to fitting and comparison, and the response has already been aggregated across readers. The result concerns fitted position summaries under a nested mean restriction.

## Slide 177: When the reference distribution may fail

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The $\chi^2$ approximation assumes that the null value is an interior, regular point and that parameters are sufficiently identified. Testing a random-effect variance against zero violates this condition because zero is a boundary. Mixture models can lose component identification under a null restriction. In such cases, a simulation-based reference distribution or a method derived for the boundary problem may be needed.

## Slide 178: When the reference distribution may fail

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The likelihood difference remains a description of fitted improvement when these conditions fail. What becomes unreliable is the simple $\chi^2$ calibration.

## Slide 179: Likelihood comparison and predictive validation

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The LRT uses the same responses to estimate and compare the models. Cross-validation asks how the complete procedures predict responses excluded from fitting. A quadratic term can pass an LRT while changing held-out prediction only slightly, or a proxy can improve prediction without supporting its proposed mechanism. These are different pieces of evidence.

## Slide 180: Checking the nested comparison

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Which parameter restriction makes the quadratic model reduce to the linear model?

## Slide 181: Checking the nested comparison

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Why can the expanded model not have a lower maximized likelihood?

## Slide 182: Checking the nested comparison

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Why must both fits use the same position rows and response scale?

## Slide 183: Checking the nested comparison

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

Why does the reported tail probability not evaluate an omitted passage?

## Slide 184: Checking the nested comparison

Source note: `model-criticism-and-prediction/likelihood-ratio-tests.qmd`

The LRT measures the fitted likelihood gained by relaxing a nested restriction and calibrates that gain when the regularity conditions hold. The previous page evaluated unseen verbs. The next page applies two different penalties to these same Provo fits.

## Slide 185: Penalizing in-sample fit

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The next topic is Penalizing in-sample fit.

## Slide 186: Penalizing in-sample fit

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The likelihood-ratio page fixed a Provo position table and two nested Gaussian mean models. Information criteria use those same likelihoods but replace null-hypothesis calibration with a penalty for estimated flexibility. This lets the penalty, rather than a change in data or response, explain any disagreement.

## Slide 187: Penalizing in-sample fit

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The **optimism of training error** is the fact that performance on observations used for fitting tends to be better than expected performance on new observations. An **information criterion** estimates a correction by combining fitted likelihood with a complexity penalty. Its score is relative to compatible candidates; the absolute value has no standalone linguistic unit.

## Slide 188: AIC: fit plus a parameter-count penalty

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Let $\ell$ be maximized log likelihood and $k$ the number of likelihood parameters. The **Akaike information criterion (AIC)** is

$$
\operatorname{AIC}=2k-2\ell
=
\underbrace{-2\ell}_{\text{lack of fitted likelihood}}
+
\underbrace{2k}_{\text{complexity penalty}}.
$$

## Slide 189: AIC: fit plus a parameter-count penalty

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Greater maximized log likelihood lowers the first term; additional parameters increase the second. Lower AIC is preferred. The penalty is motivated as an approximation to relative expected predictive discrepancy, not as a significance threshold.

## Slide 190: BIC: a different penalty and motivation

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The **Bayesian information criterion (BIC)** is

$$
\operatorname{BIC}=k\log n-2\ell,
$$

where $n$ is the sample size supplied to the approximation.

## Slide 191: BIC: a different penalty and motivation

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Its penalty grows with $\log n$. BIC is not merely a universally stricter AIC: it arises from a different approximation connected to model evidence under additional assumptions.

## Slide 192: BIC: a different penalty and motivation

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Repeated linguistic data can make the meaning of $n$ delicate. The Provo teaching table contains position summaries rather than reader-level observations, so its criterion calculation uses the number of retained positions. It cannot convert those positions into independent readers or passages.

## Slide 193: The Provo criterion disagreement

Source note: `model-criticism-and-prediction/information-criteria.qmd`

the calculation reloads the Provo table introduced on the preceding page, refits the identical linear and quadratic models, and computes both criteria. The likelihood parameter count returned by `logLik()` includes the residual scale parameter.

## Slide 194: The Provo criterion disagreement

Source note: `model-criticism-and-prediction/information-criteria.qmd`

This figure shows observed linguistic data for The Provo criterion disagreement.

## Slide 195: The Provo criterion disagreement

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Both criteria use the same 1,593 position summaries. AIC prefers the Quadratic model; the other model is worse by 4.152 AIC points. BIC prefers the Linear model; the other model is worse by 1.221 BIC points. The empirical disagreement follows from applying different penalties to a modest fitted-likelihood gain.

## Slide 196: The Provo criterion disagreement

Source note: `model-criticism-and-prediction/information-criteria.qmd`

This is more informative than declaring either criterion decisive. The candidates are close enough that a defensible change in approximation can reverse the ordering. The plot shows only each model's distance from the preferred score; it does not add thresholds or labels that the criteria do not supply.

## Slide 197: Keeping responses and observations fixed

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Information criteria compare models only when their likelihoods concern the same observed responses. A model of raw duration and a model of log duration assign density to different response variables. Their printed values are not directly comparable without accounting for the transformation.

## Slide 198: Keeping responses and observations fixed

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Candidate models can also silently use different rows when an added predictor has missing values. the calculation thus checks the row names in both model frames. Equal row counts alone would not establish that the same positions were used.

## Slide 199: What the criteria do not encode

Source note: `model-criticism-and-prediction/information-criteria.qmd`

AIC approximates observation-level expected performance under its regularity conditions. It does not create held-out predictions or know which linguistic group should be new. BIC likewise cannot distinguish another position in an observed passage from a position in a passage absent during fitting.

## Slide 200: What the criteria do not encode

Source note: `model-criticism-and-prediction/information-criteria.qmd`

The position count also does not license reader-level or passage-level inference. Direct grouped validation is preferable when prediction for a wholly new passage is the target. Here the criteria compare two compatible likelihood models for the fixed aggregated position table.

## Slide 201: What the criteria do not encode

Source note: `model-criticism-and-prediction/information-criteria.qmd`

An information-criterion difference is not a conventional significance threshold. It ranks specified candidates under its approximation. It does not certify that the preferred candidate is an adequate explanation of the response process.

## Slide 202: Checking the penalized comparison

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Which term rewards fitted likelihood in AIC, and which term penalizes flexibility?

## Slide 203: Checking the penalized comparison

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Why can AIC and BIC prefer different Provo models while using identical fits?

## Slide 204: Checking the penalized comparison

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Why must both candidates use the same response rows and response scale?

## Slide 205: Checking the penalized comparison

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Which held-out unit is not represented by either criterion calculation?

## Slide 206: Checking the penalized comparison

Source note: `model-criticism-and-prediction/information-criteria.qmd`

Information criteria combine fitted likelihood with an approximation-specific complexity penalty. The previous page calibrated the nested restriction; the next page obtains exact omitted-position predictions under a fixed Bayesian specification.

## Slide 207: Leaving out one unit at a time

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Now we turn to Leaving out one unit at a time.

## Slide 208: Leaving out one unit at a time

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

The information-criteria page approximated predictive discrepancy without constructing omitted-data predictions. **Leave-one-out cross-validation (LOO-CV)** instead makes one unit the test set at a time. The word *one* matters: here it means one Provo content-word position summary, conditional on all other positions, including positions from the same passage.

## Slide 209: Defining the rotation

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Let the data contain $N$ position summaries. For each position $i$, fit the complete procedure to the data with $i$ removed. Write the fitted predictor as

$$
\widehat f_{-i}
$$

and its prediction as

$$
\widehat y_{-i}=\widehat f_{-i}(x_i).
$$

## Slide 210: Defining the rotation

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

For a chosen loss $L$, the leave-one-out risk estimate is

$$
\widehat R_{\mathrm{LOO}}
=
\frac{1}{N}
\sum_{i=1}^N
L(y_i,\widehat y_{-i}).
$$

## Slide 211: Defining the rotation

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Each response is absent from its own fit. The fits still overlap extensively, so they are not independent replications of the study.

## Slide 212: Exact Bayesian LOO for the Provo models

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

We use the same Provo position table and Gaussian mean models as on the preceding pages. The Bayesian calculation fixes a normal-inverse-gamma prior before any position is omitted.

## Slide 213: Exact Bayesian LOO for the Provo models

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

The source paper reports excluding fixations shorter than 80 ms and longer than 800 ms. Their log-scale midpoint sets the prior intercept mean; slope means are zero. The expected residual variance treats four standard deviations as spanning those study bounds, and each coefficient's conditional prior variance multiplier is derived from the same span. The inverse-gamma shape is a fixed computational setting, and its rate follows from the declared residual-variance mean.

## Slide 214: Exact Bayesian LOO for the Provo models

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

This prior is calibrated to study-level measurement bounds, not to the observed Provo response values. It is a teaching prior, not a prior proposed by Luke and Christianson.

## Slide 215: Exact Bayesian LOO for the Provo models

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

This figure shows observed linguistic data for Exact Bayesian LOO for the Provo models.

## Slide 216: Exact Bayesian LOO for the Provo models

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Conjugacy gives a Student-$t$ predictive density for every omitted position. Exact ELPD is 1484.689 for the linear model and 1486.702 for the quadratic model. The corresponding RMSEs are 0.09506 and 0.09494 on the mean log-duration scale.

## Slide 217: Exact Bayesian LOO for the Provo models

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

The raw points and LOO predictive means remain on the same axes. This matters because a small aggregate advantage can otherwise hide where the two fitted functions differ.

## Slide 218: What one means here

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

One omitted unit is a content-word position summary. Other positions from the same passage remain in the training data, and the response already averages over readers. The target is thus one position summary conditional on the remaining position table. It is not a new passage, reader, participant response, or word type.

## Slide 219: What one means here

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

The distinction persists even though every position receives an out-of-sample prediction. Summing pointwise scores within a passage would not retroactively remove that passage from fitting. A passage target requires leave-one-passage-out validation from the start.

## Slide 220: Computation, tuning, and overlap

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Literal LOO usually requires $N$ fits, which can be expensive. Conjugacy makes all 1593 Provo calculations available analytically. The next page evaluates whether posterior draws from the full fit can approximate these exact omitted-position quantities.

## Slide 221: Computation, tuning, and overlap

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Any response-adaptive tuning would still have to occur within each (N-1) training set. Fixing a transformation or penalty after consulting all responses would let the omitted response influence its own prediction.

## Slide 222: Computation, tuning, and overlap

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

The training sets also overlap. Two LOO fits share all but their two distinct omitted positions. This dependence does not invalidate the mean score, but it rules out treating the position fits as independent study replications.

## Slide 223: Checking the omitted unit

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

What empirical object does one Provo LOO unit represent?

## Slide 224: Checking the omitted unit

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Which data remain available when a position is omitted?

## Slide 225: Checking the omitted unit

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Why is this not an omitted-passage analysis?

## Slide 226: Checking the omitted unit

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

Which part of the prior uses the source-study measurement bounds?

## Slide 227: Checking the omitted unit

Source note: `model-criticism-and-prediction/leave-one-out-cross-validation.qmd`

LOO-CV gives every position a prediction from a fit that excluded it. The previous page used an in-sample approximation; the next page approximates these exact Bayesian omitted-position densities using full-posterior draws.

## Slide 228: Pareto-smoothed importance sampling leave-one-out cross-validation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Next, we take up Pareto-smoothed importance sampling leave-one-out cross-validation.

## Slide 229: Pareto-smoothed importance sampling leave-one-out cross-validation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The exact LOO page computed every omitted-position posterior directly under a conjugate Provo model. **Pareto-smoothed importance sampling leave-one-out cross-validation (PSIS-LOO)** approximates those omitted-data posteriors using draws from the posterior fit to all observations. Because exact values are available here, approximation error becomes observable.

## Slide 230: Exact Bayesian leave-one-out prediction

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Let $y_{-i}$ contain all responses except $y_i$. Given a factorized likelihood and prior density $f(\theta)$,

$$
f(\theta\mid y_{-i})
\propto
f(\theta)\prod_{j\neq i}f(y_j\mid\theta).
$$

## Slide 231: Exact Bayesian leave-one-out prediction

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The exact predictive density is

$$
f(y_i\mid y_{-i})
=
\int f(y_i\mid\theta)f(\theta\mid y_{-i})\,\mathrm d\theta.
$$

## Slide 232: Exact Bayesian leave-one-out prediction

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Summing its logarithm gives expected log pointwise predictive density:

$$
\operatorname{elpd}_{\mathrm{loo}}
=
\sum_{i=1}^N\log f(y_i\mid y_{-i}).
$$

## Slide 233: Exact Bayesian leave-one-out prediction

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Larger values indicate greater predictive density for the omitted positions.

## Slide 234: Relating the omitted posterior to the full posterior

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Given draws $\theta^{(1)},\ldots,\theta^{(S)}$ from

$$
f(\theta\mid y)
\propto
f(\theta)\prod_{j=1}^Nf(y_j\mid\theta),
$$

removing the $i$th contribution gives

$$
f(\theta\mid y_{-i})
\propto
\frac{f(\theta\mid y)}{f(y_i\mid\theta)}.
$$

## Slide 235: Relating the omitted posterior to the full posterior

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The raw importance ratio is consequently

$$
r_i^{(s)}\propto\frac{1}{f(y_i\mid\theta^{(s)})}.
$$

## Slide 236: Relating the omitted posterior to the full posterior

Source note: `model-criticism-and-prediction/psis-loo.qmd`

This inverse weighting is both the shortcut and its weakness. A few enormous ratios can make full-posterior draws a poor representation of the omitted posterior.

## Slide 237: Relating the omitted posterior to the full posterior

Source note: `model-criticism-and-prediction/psis-loo.qmd`

PSIS fits a generalized Pareto distribution to the largest ratios and replaces extreme values with smoothed ones. The **Pareto $k$ diagnostic** reports the fitted tail shape for each position. Large $k$ warns about the approximation; it does not establish that an observation is erroneous or should be removed.

## Slide 238: PSIS and exact LOO on the same Provo positions

Source note: `model-criticism-and-prediction/psis-loo.qmd`

the calculation reloads the Provo position table, reconstructs the fixed study-calibrated priors, draws independently from both conjugate posteriors, and preserves one log-likelihood column per position. It also recomputes exact LOO so the PSIS totals can be checked directly.

## Slide 239: PSIS and exact LOO on the same Provo positions

Source note: `model-criticism-and-prediction/psis-loo.qmd`

This figure shows observed linguistic data for PSIS and exact LOO on the same Provo positions.

## Slide 240: PSIS and exact LOO on the same Provo positions

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The independent posterior draws make the relative effective sample size one for every position. PSIS-LOO gives ELPD 1484.685 for the linear model and 1486.736 for the quadratic model. The differences from exact conjugate LOO are -0.004 and 0.034.

## Slide 241: PSIS and exact LOO on the same Provo positions

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Maximum Pareto $k$ is 0.089 for the linear model and 0.132 for the quadratic model. 0 positions exceed the plotted reference value. Thus the approximation is accurate for this fitted pair, and the exact calculation provides the evidence for saying so.

## Slide 242: The pointwise likelihood fixes the target

Source note: `model-criticism-and-prediction/psis-loo.qmd`

The log-likelihood matrices have 1593 position columns and 4000 posterior-draw rows. A vector of total log likelihoods cannot support omission because it discards the pointwise contributions.

## Slide 243: The pointwise likelihood fixes the target

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Default PSIS-LOO omits one such contribution. Here that contribution is one aggregated content-word position. Other positions from the same passage remain in the full posterior, so summing position scores by passage cannot create leave-one-passage-out validation. A new-passage target would require a grouped likelihood and validation design from the start.

## Slide 244: The pointwise likelihood fixes the target

Source note: `model-criticism-and-prediction/psis-loo.qmd`

When $k$ is large, responses include exact refitting, moment matching, or a different validation design. Removing the position solely because it is difficult would confuse a computational warning with a data-quality judgment.

## Slide 245: Checking the approximation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Why are raw importance ratios inversely related to the held-out likelihood contribution?

## Slide 246: Checking the approximation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

What does Pareto $k$ diagnose?

## Slide 247: Checking the approximation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Why is exact LOO available as a decisive check in this example?

## Slide 248: Checking the approximation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

Which prediction target is fixed by one column of the log-likelihood matrix?

## Slide 249: Checking the approximation

Source note: `model-criticism-and-prediction/psis-loo.qmd`

PSIS-LOO uses full-posterior draws to approximate omitted-position predictive density and supplies a diagnostic for that approximation. The previous page computed the exact target; the next page applies a posterior-variance correction to the same pointwise likelihood matrices.

## Slide 250: The widely applicable information criterion

Source note: `model-criticism-and-prediction/waic.qmd`

Now we turn to The widely applicable information criterion.

## Slide 251: The widely applicable information criterion

Source note: `model-criticism-and-prediction/waic.qmd`

The PSIS-LOO page used full-posterior draws to approximate omitted-position posteriors. The **widely applicable information criterion (WAIC)** instead corrects fitted pointwise posterior predictive density using posterior variation. Both calculations require the same pointwise likelihood matrix, but their approximations differ.

## Slide 252: Fitted posterior predictive density

Source note: `model-criticism-and-prediction/waic.qmd`

For observation $i$, the **log pointwise predictive density (lppd)** is

$$
\operatorname{lppd}_i
=
\log\left[
\frac{1}{S}
\sum_{s=1}^S
f(y_i\mid\theta^{(s)})
\right].
$$

## Slide 253: Fitted posterior predictive density

Source note: `model-criticism-and-prediction/waic.qmd`

The average integrates the likelihood of $y_i$ over posterior uncertainty. But $y_i$ helped determine the posterior, so this remains a fitted predictive quantity. Summing gives

$$
\operatorname{lppd}=\sum_{i=1}^N\operatorname{lppd}_i.
$$

## Slide 254: The pointwise optimism correction

Source note: `model-criticism-and-prediction/waic.qmd`

WAIC estimates effective flexibility from the posterior variance of each pointwise log likelihood:

$$
p_{\mathrm{waic},i}
=
\operatorname{Var}_s\left[
\log f(y_i\mid\theta^{(s)})
\right],
$$

and

$$
p_{\mathrm{waic}}
=
\sum_{i=1}^Np_{\mathrm{waic},i}.
$$

## Slide 255: The pointwise optimism correction

Source note: `model-criticism-and-prediction/waic.qmd`

The effective count depends on the fitted posterior, not merely on the number of regression coefficients. WAIC's expected log predictive density is

$$
\operatorname{elpd}_{\mathrm{waic}}
=
\operatorname{lppd}-p_{\mathrm{waic}}.
$$

## Slide 256: The pointwise optimism correction

Source note: `model-criticism-and-prediction/waic.qmd`

Larger values are preferred. The deviance-scale quantity is

$$
\operatorname{WAIC}=-2\operatorname{elpd}_{\mathrm{waic}},
$$

for which smaller is preferred.

## Slide 257: WAIC and exact LOO for the Provo models

Source note: `model-criticism-and-prediction/waic.qmd`

the calculation independently reloads the Provo data, reconstructs the fixed conjugate posteriors, and generates the same independent posterior draws used for PSIS. It computes WAIC both manually and with `loo::waic()`, then compares each pointwise WAIC contribution with exact LOO.

## Slide 258: WAIC and exact LOO for the Provo models

Source note: `model-criticism-and-prediction/waic.qmd`

This figure shows observed linguistic data for WAIC and exact LOO for the Provo models.

## Slide 259: WAIC and exact LOO for the Provo models

Source note: `model-criticism-and-prediction/waic.qmd`

WAIC gives ELPD 1484.688 with $p_{\mathrm{waic}} = 3.087$ for the linear model. The quadratic values are 1486.741 and $p_{\mathrm{waic}} = 4.214$. The manual pointwise implementation and `loo::waic()` agree to the asserted numerical tolerance.

## Slide 260: WAIC and exact LOO for the Provo models

Source note: `model-criticism-and-prediction/waic.qmd`

The figure shows the approximation rather than another abstract score: every point is one Provo position's WAIC contribution minus its exact LOO contribution. Most differences cluster near zero, but the display preserves their relation to modeled cloze surprisal.

## Slide 261: What the correction does not change

Source note: `model-criticism-and-prediction/waic.qmd`

WAIC is tied to the unit represented by one likelihood column. Here that unit is an aggregated content-word position. The correction does not create prediction for a wholly new reader, word type, or passage. Other positions from the same passage remain part of the fitted posterior used to calculate each contribution.

## Slide 262: What the correction does not change

Source note: `model-criticism-and-prediction/waic.qmd`

Large posterior variance in a pointwise log likelihood can warn that WAIC is unreliable for that position. The warning concerns the approximation; it does not license discarding a linguistically surprising point. PSIS-LOO is often easier to diagnose because Pareto $k$ targets its importance-sampling approximation directly.

## Slide 263: What the correction does not change

Source note: `model-criticism-and-prediction/waic.qmd`

Finally, WAIC ranks compatible candidate models. It does not establish that the preferred predictor causes the reading response or explains the linguistic process that produced it.

## Slide 264: Checking the correction

Source note: `model-criticism-and-prediction/waic.qmd`

Why is lppd a fitted rather than omitted-data quantity?

## Slide 265: Checking the correction

Source note: `model-criticism-and-prediction/waic.qmd`

Which posterior quantity supplies WAIC's optimism correction?

## Slide 266: Checking the correction

Source note: `model-criticism-and-prediction/waic.qmd`

Why can $p_{\mathrm{waic}}$ differ from a coefficient count?

## Slide 267: Checking the correction

Source note: `model-criticism-and-prediction/waic.qmd`

What is the empirical unit of one point in the final figure?

## Slide 268: Checking the correction

Source note: `model-criticism-and-prediction/waic.qmd`

WAIC subtracts a posterior-variance correction from fitted pointwise predictive density. The previous page approximated omitted-position posteriors with importance sampling. Return to the module overview to place both approximations within the full model-evaluation sequence.
