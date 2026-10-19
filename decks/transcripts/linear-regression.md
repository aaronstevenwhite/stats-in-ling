# Ordinary linear regression

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Ordinary linear regression

Source note: `regression-models/index.qmd`

Welcome to Ordinary linear regression. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Regression models

Source note: `regression-models/index.qmd`

Our next step is Regression models.

## Slide 3: Provo: the empirical object

Source note: `regression-models/index.qmd`

The data source is Luke and Christianson (2018), Provo Corpus. It provides content-word positions aggregated across Provo readers.

## Slide 4: Regression models

Source note: `regression-models/index.qmd`

The Provo Corpus records eye-movement measures and predictability norms for words in short English passages (Luke and Christianson 2018; data source). The first regression sequence uses its audited content-word table. One row is a word position aggregated across readers, and positions remain grouped within passages.

## Slide 5: Regression models

Source note: `regression-models/index.qmd`

A regression model specifies which parameter of a response distribution depends on which observed predictors, and through which function. The response distribution states which measurements are possible and how they vary; the regression function states how its parameters change across predictor values represented in the data.

## Slide 6: Regression models

Source note: `regression-models/index.qmd`

This specification assumes the earlier distinction among an estimand, an estimator, and an estimate, along with the fact that a likelihood holds the observations fixed. The pages return to those objects when they do explanatory work rather than rederiving them for every model family.

## Slide 7: Linear regression

Source note: `regression-models/index.qmd`

The Provo run builds ordinary linear regression in stages. Conditional means state the target, simple linear regression restricts that mean to a line, and the fitting, uncertainty, residual, and diagnostic pages ask what this restriction licenses. Raw word-position summaries and fitted lines remain visible on the same response scale.

## Slide 8: Linear regression

Source note: `regression-models/index.qmd`

At the move to multiple regression, the running dataset changes to MALD auditory lexical-decision items. These item rows summarize correct retained trials and cannot recover participant effects. This natural break introduces multiple lexical and acoustic predictors, categorical coding, correlated predictors, regularization, influence, heteroscedasticity, and distributional regression without changing data on every page. Interactions use MegaOrientation's paired past and future means to define frame-specific differences in orientation shifts; the ordinal fit is deferred until cumulative-logit regression has been introduced.

## Slide 9: Generalized response distributions

Source note: `regression-models/index.qmd`

A Gaussian straight-line mean is not appropriate for every linguistic response. Binary choices, ordinal judgments, counts, and bounded sliders have different supports and patterns of variation. Generalized linear models retain a predictor-dependent parameter while changing the response family and link.

## Slide 10: Generalized response distributions

Source note: `regression-models/index.qmd`

Binary choices, ordinal labels, counts, and rates require distinct response models; a count becomes a rate only after representing exposure.

## Slide 11: Repeated units

Source note: `regression-models/index.qmd`

The structured-data page returns to connected MALD trials and distinguishes response rows from repeated listeners and spoken words. Random intercepts represent persistent modeled differences among sampled groups, while random slopes represent group variation in a predictor association.

## Slide 12: Repeated units

Source note: `regression-models/index.qmd`

The mixed-model sequence then extends the earlier response families: SuperTelicity supplies a crossed logistic model, MegaVeridicality an ordinal mixed model and an unseen-verb comparison, and paired French--English UCCA passages a count model with an exposure offset. These are teaching reductions of the source analyses, and each page states what its fitted coefficients can and cannot represent.

## Slide 13: Repeated units

Source note: `regression-models/index.qmd`

The chapter dependency graph displays the linear, generalized-linear, and mixed-effects branches. In each branch, the order is the same: identify the response and repeated units, state the conditional target, fit on the observed support, show data and fitted values together, and evaluate the restrictions the model added.

## Slide 14: Conditional means

Source note: `regression-models/regression-models.qmd`

Next, we take up Conditional means.

## Slide 15: Conditional means

Source note: `regression-models/regression-models.qmd`

Regression begins by naming a response distribution at each predictor value. Its first target is usually the **conditional mean function**

$$
m(x)\equiv\mathbb{E}[Y\mid X=x].
$$

## Slide 16: Conditional means

Source note: `regression-models/regression-models.qmd`

This function asks how the center of a response changes across observed linguistic contexts. It does not yet require the center to be a straight line.

## Slide 17: Provo word-position data

Source note: `regression-models/regression-models.qmd`

We develop this idea with data from the Provo Corpus. Luke and Christianson (2018) collected cloze norms and eye movements for 55 English passages; the Provo OSF release is available under CC BY 4.0. The course table retains complete content-word positions. A row is a word position nested in a passage after first-fixation durations have been aggregated across readers. It is not a participant trial.

## Slide 18: Provo word-position data

Source note: `regression-models/regression-models.qmd`

The release variable `OrthoMatchModel` is a fitted cloze probability that avoids exact zero and one. It is not a language-model probability. We call

$$
X_i=-\log_2(\widehat p_i)
$$

**modeled cloze surprisal**, and let $Y_i$ be the mean log first-fixation duration at position $i$.

## Slide 19: Provo word-position data

Source note: `regression-models/regression-models.qmd`

The retained table contains 1593 positions from 55 passages. Reader-level variation is no longer recoverable.

## Slide 20: Estimating a changing center

Source note: `regression-models/regression-models.qmd`

Exact predictor values are nearly continuous, so an empirical conditional mean at one exact value would usually contain few observations. Equal-count bins provide a descriptive estimate:

$$
\widehat m_b
\equiv
\frac{1}{n_b}\sum_{i:X_i\in B_b}Y_i,
$$

where $B_b$ is surprisal bin $b$ and $n_b$ is its observed number of positions.

## Slide 21: Estimating a changing center

Source note: `regression-models/regression-models.qmd`

The bins are a display device, not a fitted regression model.

## Slide 22: Estimating a changing center

Source note: `regression-models/regression-models.qmd`

Reader-aggregated Provo positions in gray and empirical conditional means in black. Bins contain approximately equal numbers of positions.

## Slide 23: Estimating a changing center

Source note: `regression-models/regression-models.qmd`

The bin means tend to increase with modeled cloze surprisal. This pattern licenses a question about the conditional mean of these position summaries. It does not by itself identify a processing mechanism or restore the repeated reader observations.

## Slide 24: Conditional means: question 1

Source note: `regression-models/regression-models.qmd`

What is the observational unit in the Provo analysis?

## Slide 25: Conditional means: answer 1

Source note: `regression-models/regression-models.qmd`

One observation is a retained content-word position within a Provo passage, with first-fixation duration already aggregated across readers.

## Slide 26: Conditional means: question 2

Source note: `regression-models/regression-models.qmd`

Why are the black points estimates rather than raw observations?

## Slide 27: Conditional means: answer 2

Source note: `regression-models/regression-models.qmd`

Each black point is a bin mean computed from many position summaries, so it estimates a conditional center rather than recording one raw observation.

## Slide 28: Conditional means: question 3

Source note: `regression-models/regression-models.qmd`

What information was lost when reader trials were aggregated?

## Slide 29: Conditional means: answer 3

Source note: `regression-models/regression-models.qmd`

Individual reader responses, reader identities, and reader-level variation and dependence were lost.

## Slide 30: Conditional means: question 4

Source note: `regression-models/regression-models.qmd`

Which part of the display suggests that a straight line might be useful?

## Slide 31: Conditional means: answer 4

Source note: `regression-models/regression-models.qmd`

The binned empirical means generally rise with modeled cloze surprisal; a straight line is a simple first approximation to that trend. The next page restricts the conditional mean to a straight line.

## Slide 32: A straight-line mean

Source note: `regression-models/simple-linear-regression.qmd`

The next topic is A straight-line mean.

## Slide 33: A straight-line mean

Source note: `regression-models/simple-linear-regression.qmd`

The conditional-mean page left $m(x)=\mathbb{E}[Y\mid X=x]$ unrestricted. **Simple linear regression** imposes

$$
m(x)=\beta_0+\beta_1x.
$$

## Slide 34: A straight-line mean

Source note: `regression-models/simple-linear-regression.qmd`

The word *simple* means that the model has one predictor. The word *linear* means that the coefficients enter as a weighted sum.

## Slide 35: Fitting the Provo regression line

Source note: `regression-models/simple-linear-regression.qmd`

We return to the Provo position summaries and center modeled cloze surprisal at its observed mean. Centering makes the intercept correspond to an observed reference point; the next page derives that equivalence.

## Slide 36: Fitting the Provo regression line

Source note: `regression-models/simple-linear-regression.qmd`

The fitted conditional mean is

$$
\widehat m(x_i)
=
\widehat\beta_0+\widehat\beta_1(x_i-\overline x).
$$

## Slide 37: Fitting the Provo regression line

Source note: `regression-models/simple-linear-regression.qmd`

At mean modeled cloze surprisal, the fitted mean log first-fixation duration is 5.2950. Each additional bit of modeled cloze surprisal is associated with a change of 0.0089 log milliseconds in the fitted position mean.

## Slide 38: Fitting the Provo regression line

Source note: `regression-models/simple-linear-regression.qmd`

The slope is a contrast between conditional means:

$$
m(x+1)-m(x)
=
\{\beta_0+\beta_1(x+1)\}
-\{\beta_0+\beta_1x\}
=\beta_1.
$$

## Slide 39: Fitting the Provo regression line

Source note: `regression-models/simple-linear-regression.qmd`

Thus the intercept locates the line, while the slope gives its change per predictor unit.

## Slide 40: Fitting the Provo regression line

Source note: `regression-models/simple-linear-regression.qmd`

This figure shows reader-aggregated Provo positions and the fitted straight-line conditional mean.

## Slide 41: Fitting the Provo regression line

Source note: `regression-models/simple-linear-regression.qmd`

The line summarizes an average item-position association. A potential worry is that the plotted cloud contains nested passages. That concern is well founded: ordinary standard errors do not represent passage clustering, and reader clustering cannot be recovered from this table. We address the remaining passage identifier on the uncertainty page.

## Slide 42: A straight-line mean: question 1

Source note: `regression-models/simple-linear-regression.qmd`

Which conditional means are compared by the slope?

## Slide 43: A straight-line mean: answer 1

Source note: `regression-models/simple-linear-regression.qmd`

The slope compares $m(x+1)$ with $m(x)$: fitted mean log FFD at predictor values one bit apart.

## Slide 44: A straight-line mean: question 2

Source note: `regression-models/simple-linear-regression.qmd`

Why does a one-bit increase have the same fitted change everywhere on the line?

## Slide 45: A straight-line mean: answer 2

Source note: `regression-models/simple-linear-regression.qmd`

The straight-line restriction makes $m(x+1)-m(x)=\beta_1$ for every $x$.

## Slide 46: A straight-line mean: question 3

Source note: `regression-models/simple-linear-regression.qmd`

Does the positive slope show that surprisal causes longer fixations?

## Slide 47: A straight-line mean: answer 3

Source note: `regression-models/simple-linear-regression.qmd`

No. The slope is an observational item-position association and does not identify a causal effect of surprisal.

## Slide 48: A straight-line mean: question 4

Source note: `regression-models/simple-linear-regression.qmd`

Which dependence structure remains visible in the table?

## Slide 49: A straight-line mean: answer 4

Source note: `regression-models/simple-linear-regression.qmd`

Passage membership remains visible through `Text_ID`; reader dependence cannot be recovered after aggregation. The next page changes the reference point without changing the fitted relation.

## Slide 50: Centering a predictor

Source note: `regression-models/centering-predictors.qmd`

Our next step is Centering a predictor.

## Slide 51: Centering a predictor

Source note: `regression-models/centering-predictors.qmd`

The intercept of a regression is the fitted conditional mean where every predictor equals zero. **Centering** changes that reference value while preserving all fitted comparisons.

## Slide 52: Reparameterizing the Provo regression

Source note: `regression-models/centering-predictors.qmd`

Let $X_i$ be modeled cloze surprisal and let $c$ be its observed sample mean. Define

$$
X_i^c=X_i-c.
$$

## Slide 53: Reparameterizing the Provo regression

Source note: `regression-models/centering-predictors.qmd`

The uncentered line can be rewritten as

$$
\begin{aligned}
m(X_i)
&=\beta_0+\beta_1X_i\\
&=\beta_0+\beta_1(X_i^c+c)\\
&=(\beta_0+\beta_1c)+\beta_1X_i^c.
\end{aligned}
$$

## Slide 54: Reparameterizing the Provo regression

Source note: `regression-models/centering-predictors.qmd`

Thus centering changes the intercept from $\beta_0$ to $\beta_0+\beta_1c$. It leaves the slope and every fitted value unchanged.

## Slide 55: Reparameterizing the Provo regression

Source note: `regression-models/centering-predictors.qmd`

The observed center is 4.791 bits. After centering, the intercept is 5.2950, the fitted mean at that observed predictor average. The two slopes differ by only 8.7e-18, and the largest fitted-value difference is 2.7e-15.

## Slide 56: Reparameterizing the Provo regression

Source note: `regression-models/centering-predictors.qmd`

The Provo regression on the centered predictor scale. The vertical reference marks observed mean modeled cloze surprisal.

## Slide 57: Reparameterizing the Provo regression

Source note: `regression-models/centering-predictors.qmd`

Centering does not make the slope more causal, remove passage dependence, or change the data. It changes the coordinate system used to describe the same fitted line.

## Slide 58: Centering a predictor: question 1

Source note: `regression-models/centering-predictors.qmd`

Which original surprisal value receives centered value zero?

## Slide 59: Centering a predictor: answer 1

Source note: `regression-models/centering-predictors.qmd`

The observed sample mean of modeled cloze surprisal receives centered value zero.

## Slide 60: Centering a predictor: question 2

Source note: `regression-models/centering-predictors.qmd`

Why is the centered intercept more directly supported by the observations?

## Slide 61: Centering a predictor: answer 2

Source note: `regression-models/centering-predictors.qmd`

The centered intercept represents the fitted response at the observed mean surprisal, rather than at zero surprisal, which may be poorly supported by the data.

## Slide 62: Centering a predictor: question 3

Source note: `regression-models/centering-predictors.qmd`

Which fitted quantities must remain invariant under centering?

## Slide 63: Centering a predictor: answer 3

Source note: `regression-models/centering-predictors.qmd`

The slope, every fitted value, every residual, and predictions expressed at the same original predictor values must remain unchanged.

## Slide 64: Centering a predictor: question 4

Source note: `regression-models/centering-predictors.qmd`

Would dividing by a standard deviation still be centering alone?

## Slide 65: Centering a predictor: answer 4

Source note: `regression-models/centering-predictors.qmd`

No. Dividing by a standard deviation also rescales the predictor and changes the coefficient's unit. The next page changes the response scale rather than the predictor reference.

## Slide 66: Transforming a response

Source note: `regression-models/response-transformations.qmd`

Our next step is Transforming a response.

## Slide 67: Transforming a response

Source note: `regression-models/response-transformations.qmd`

The Provo regression response is a mean of log first-fixation durations. A **response transformation** changes the scale on which the model treats effects as additive. For a positive duration $T$,

$$
Y=\log T
$$

turns a multiplicative change in milliseconds into an additive change on the log scale.

## Slide 68: What the prepared response means

Source note: `regression-models/response-transformations.qmd`

For position $i$, the course table stores a reader-aggregated mean log duration, $\overline{\log T}_i$. Exponentiating it gives

$$
G_i
=
\exp\!\left(\overline{\log T}_i\right),
$$

the geometric mean duration among the retained reader measurements for that position.

## Slide 69: What the prepared response means

Source note: `regression-models/response-transformations.qmd`

It does not give the arithmetic mean duration.

## Slide 70: What the prepared response means

Source note: `regression-models/response-transformations.qmd`

Under the working model for the stored position summaries

$$
Y_i\mid x_i\sim\mathcal N(\mu_i,\sigma^2),
$$

two summaries of the back-transformed position response differ:

$$
\operatorname{Median}(T_i\mid x_i)=\exp(\mu_i)
$$

but

$$
\mathbb{E}[T_i\mid x_i]=\exp(\mu_i+\sigma^2/2).
$$

## Slide 71: What the prepared response means

Source note: `regression-models/response-transformations.qmd`

Without the variance term, back-transforming a fitted log mean targets the conditional median, not the arithmetic mean.

## Slide 72: What the prepared response means

Source note: `regression-models/response-transformations.qmd`

This figure shows observed position-level geometric mean durations and two back-transformed summaries from the fitted log-scale model.

## Slide 73: What the prepared response means

Source note: `regression-models/response-transformations.qmd`

At the observed predictor center, the fitted geometric mean is 199.3 ms, while the working lognormal arithmetic mean of position-level geometric means is 200.2 ms. The small difference is computed from the actual Provo regression residual scale.

## Slide 74: What the prepared response means

Source note: `regression-models/response-transformations.qmd`

A potential worry is that this page diagnoses raw reader-time skew. It cannot. The prepared response has already averaged log duration by position, so the page demonstrates transformation and back-transformation of the stored summaries only.

## Slide 75: Transforming a response: question 1

Source note: `regression-models/response-transformations.qmd`

Why is `exp(mean_log_ffd)` a geometric mean?

## Slide 76: Transforming a response: answer 1

Source note: `regression-models/response-transformations.qmd`

`exp(mean_log_ffd)` equals $\exp(\overline{\log T})$, the geometric mean of the retained positive durations.

## Slide 77: Transforming a response: question 2

Source note: `regression-models/response-transformations.qmd`

Which raw-scale summary includes the $\sigma^2/2$ term?

## Slide 78: Transforming a response: answer 2

Source note: `regression-models/response-transformations.qmd`

The conditional arithmetic mean under the lognormal working model is $\mathbb{E}[T\mid x]=\exp(\mu+\sigma^2/2)$.

## Slide 79: Transforming a response: question 3

Source note: `regression-models/response-transformations.qmd`

Does a linear effect on log duration imply a constant millisecond difference?

## Slide 80: Transforming a response: answer 3

Source note: `regression-models/response-transformations.qmd`

No. A constant additive change on the log scale is a constant multiplicative ratio on the millisecond scale, so the millisecond difference depends on the baseline.

## Slide 81: Transforming a response: question 4

Source note: `regression-models/response-transformations.qmd`

Why can this table not reveal the raw reader-level distribution?

## Slide 82: Transforming a response: answer 4

Source note: `regression-models/response-transformations.qmd`

The stored response already averages log durations over readers, so individual trial values and their distribution are unavailable. The next page derives the least-squares fit.

## Slide 83: Fitting a linear regression

Source note: `regression-models/frequentist-linear-regression.qmd`

Next, we take up Fitting a linear regression.

## Slide 84: Fitting a linear regression

Source note: `regression-models/frequentist-linear-regression.qmd`

The Provo regression specifies a straight-line conditional mean. We now need an estimation rule. **Ordinary least squares (OLS)** chooses the coefficients whose fitted values minimize the residual sum of squares.

## Slide 85: From discrepancies to an objective

Source note: `regression-models/frequentist-linear-regression.qmd`

For position $i$,

$$
\widehat y_i=\beta_0+\beta_1x_i
$$

and

$$
e_i=y_i-\widehat y_i.
$$

## Slide 86: From discrepancies to an objective

Source note: `regression-models/frequentist-linear-regression.qmd`

The OLS objective is

$$
\operatorname{SSE}(\beta_0,\beta_1)
=
\sum_{i=1}^n
\left(y_i-\beta_0-\beta_1x_i\right)^2.
$$

## Slide 87: From discrepancies to an objective

Source note: `regression-models/frequentist-linear-regression.qmd`

Differentiating with respect to the coefficients and setting both derivatives to zero gives

$$
\widehat\beta_1
=
\frac{\sum_i(x_i-\overline x)(y_i-\overline y)}
{\sum_i(x_i-\overline x)^2}
$$

and

$$
\widehat\beta_0=\overline y-\widehat\beta_1\overline x.
$$

## Slide 88: Computing the Provo regression estimate

Source note: `regression-models/frequentist-linear-regression.qmd`

The fitted slope is 0.008883 log milliseconds per bit. Squaring makes large vertical discrepancies count more heavily, which is one reason a few unusual responses may affect the fit.

## Slide 89: Computing the Provo regression estimate

Source note: `regression-models/frequentist-linear-regression.qmd`

If

$$
Y_i\mid x_i,\beta_0,\beta_1,\sigma
\sim
\mathcal N(\beta_0+\beta_1x_i,\sigma^2),
$$

then the log likelihood is

$$
\ell(\beta_0,\beta_1,\sigma)
=
-n\log\sigma
-\frac{1}{2\sigma^2}
\sum_i(y_i-\beta_0-\beta_1x_i)^2
+C.
$$

## Slide 90: Computing the Provo regression estimate

Source note: `regression-models/frequentist-linear-regression.qmd`

For fixed $\sigma$, maximizing this likelihood is equivalent to minimizing SSE. OLS and Gaussian maximum likelihood thus select the same coefficient estimates.

## Slide 91: Computing the Provo regression estimate

Source note: `regression-models/frequentist-linear-regression.qmd`

This figure shows reader-aggregated Provo positions and the OLS conditional mean.

## Slide 92: Computing the Provo regression estimate

Source note: `regression-models/frequentist-linear-regression.qmd`

OLS estimates the best line under its squared-error criterion. It does not establish that the line is an adequate description, nor does it account for the passage grouping. Those questions require uncertainty calculations and diagnostics.

## Slide 93: Fitting a linear regression: question 1

Source note: `regression-models/frequentist-linear-regression.qmd`

Which quantity does OLS minimize?

## Slide 94: Fitting a linear regression: answer 1

Source note: `regression-models/frequentist-linear-regression.qmd`

OLS minimizes the residual sum of squares, $\sum_i(y_i-\beta_0-\beta_1x_i)^2$.

## Slide 95: Fitting a linear regression: question 2

Source note: `regression-models/frequentist-linear-regression.qmd`

Why does the slope contain cross-products of centered $x$ and $y$?

## Slide 96: Fitting a linear regression: answer 2

Source note: `regression-models/frequentist-linear-regression.qmd`

The centered cross-products measure whether deviations in $x$ and $y$ have the same direction; dividing by centered $x$ variation converts that co-movement into change in $y$ per unit $x$.

## Slide 97: Fitting a linear regression: question 3

Source note: `regression-models/frequentist-linear-regression.qmd`

Under which response model does OLS coincide with maximum likelihood?

## Slide 98: Fitting a linear regression: answer 3

Source note: `regression-models/frequentist-linear-regression.qmd`

OLS coefficient estimates coincide with maximum likelihood under independent normal responses with linear means and a common variance.

## Slide 99: Fitting a linear regression: question 4

Source note: `regression-models/frequentist-linear-regression.qmd`

What feature of squared error makes influence worth checking later?

## Slide 100: Fitting a linear regression: answer 4

Source note: `regression-models/frequentist-linear-regression.qmd`

Squaring gives unusually large residuals disproportionate weight, so a few observations can strongly affect the fitted coefficients. The next page derives uncertainty in the fitted slope.

## Slide 101: Uncertainty in a fitted slope

Source note: `regression-models/linear-regression-uncertainty.qmd`

The next topic is Uncertainty in a fitted slope.

## Slide 102: Uncertainty in a fitted slope

Source note: `regression-models/linear-regression-uncertainty.qmd`

The fitted Provo regression slope is one estimate. **Regression uncertainty** describes how that estimator would vary under a repeated-sampling model.

## Slide 103: Conventional OLS uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

Write the linear model in matrix form:

$$
\mathbf Y=\mathbf X\boldsymbol\beta+\boldsymbol\varepsilon,
\qquad
\boldsymbol\varepsilon\sim\mathcal N(\mathbf 0,\sigma^2\mathbf I).
$$

## Slide 104: Conventional OLS uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

The OLS estimator is

$$
\widehat{\boldsymbol\beta}
=(\mathbf X^\top\mathbf X)^{-1}\mathbf X^\top\mathbf Y.
$$

Because a linear transformation of a normal vector is normal,

$$
\operatorname{Var}[\widehat{\boldsymbol\beta}\mid\mathbf X]
=
\sigma^2(\mathbf X^\top\mathbf X)^{-1}.
$$

## Slide 105: Conventional OLS uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

Replacing $\sigma^2$ with

$$
s^2=\frac{\sum_i e_i^2}{n-p}
$$

gives the conventional covariance estimate.

## Slide 106: Conventional OLS uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

Here $p$ is the number of fitted coefficients, including the intercept.

## Slide 107: Conventional OLS uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

The conventional slope standard error is 0.000918; the passage-clustered HC1 sensitivity estimate is 0.000939. The latter allows arbitrary residual dependence within the observed passages while treating passages as independent clusters.

## Slide 108: Conventional OLS uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

This sensitivity calculation does not recover reader variation. The raw readers were removed by aggregation, so neither uncertainty estimate substitutes for a participant-by-item model.

## Slide 109: Mean and response uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

At predictor row $\mathbf x_0$, uncertainty in the fitted conditional mean is

$$
\widehat{\operatorname{Var}}(\widehat\mu_0)
=
s^2\mathbf x_0^\top(\mathbf X^\top\mathbf X)^{-1}\mathbf x_0.
$$

## Slide 110: Mean and response uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

A new response includes additional observation variance:

$$
\widehat{\operatorname{Var}}(Y_0-\widehat\mu_0)
=
s^2\left\{1+\mathbf x_0^\top(\mathbf X^\top\mathbf X)^{-1}\mathbf x_0\right\}.
$$

## Slide 111: Mean and response uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

Thus a prediction interval is wider than a confidence interval for the mean.

## Slide 112: Mean and response uncertainty

Source note: `regression-models/linear-regression-uncertainty.qmd`

This figure shows provo positions, the OLS mean, its confidence band, and the wider response prediction limits.

## Slide 113: Uncertainty in a fitted slope: question 1

Source note: `regression-models/linear-regression-uncertainty.qmd`

Which assumption yields the factor $\sigma^2\mathbf I$?

## Slide 114: Uncertainty in a fitted slope: answer 1

Source note: `regression-models/linear-regression-uncertainty.qmd`

Independent, homoscedastic errors with common variance $\sigma^2$ yield $\operatorname{Var}[\boldsymbol\varepsilon\mid\mathbf X]=\sigma^2\mathbf I$.

## Slide 115: Uncertainty in a fitted slope: question 2

Source note: `regression-models/linear-regression-uncertainty.qmd`

Why does the response prediction variance contain an extra $1$?

## Slide 116: Uncertainty in a fitted slope: answer 2

Source note: `regression-models/linear-regression-uncertainty.qmd`

A new response contains both uncertainty in the fitted mean and a new observation error with variance $\sigma^2$, represented by the extra $1$.

## Slide 117: Uncertainty in a fitted slope: question 3

Source note: `regression-models/linear-regression-uncertainty.qmd`

Which grouping unit does the clustered sensitivity analysis retain?

## Slide 118: Uncertainty in a fitted slope: answer 3

Source note: `regression-models/linear-regression-uncertainty.qmd`

The passage-clustered HC1 sensitivity analysis retains the Provo passage as the clustering unit through `Text_ID`.

## Slide 119: Uncertainty in a fitted slope: question 4

Source note: `regression-models/linear-regression-uncertainty.qmd`

Why can it not represent reader-level uncertainty?

## Slide 120: Uncertainty in a fitted slope: answer 4

Source note: `regression-models/linear-regression-uncertainty.qmd`

The item-position table has already aggregated away reader identities and trial-level responses, so reader covariance cannot be estimated. The next page measures the reduction in squared error relative to a mean-only baseline.

## Slide 121: The coefficient of determination

Source note: `regression-models/coefficient-of-determination.qmd`

Now we turn to The coefficient of determination.

## Slide 122: The coefficient of determination

Source note: `regression-models/coefficient-of-determination.qmd`

The OLS line minimizes squared error. The **coefficient of determination**, $R^2$, compares that error with the error from predicting every Provo position by the same sample mean.

## Slide 123: Two sums of squares

Source note: `regression-models/coefficient-of-determination.qmd`

The total sum of squares is

$$
\operatorname{SST}
=
\sum_{i=1}^n(y_i-\overline y)^2.
$$

## Slide 124: Two sums of squares

Source note: `regression-models/coefficient-of-determination.qmd`

The fitted model leaves the error sum of squares

$$
\operatorname{SSE}
=
\sum_{i=1}^n(y_i-\widehat y_i)^2.
$$

## Slide 125: Two sums of squares

Source note: `regression-models/coefficient-of-determination.qmd`

Their proportional reduction is

$$
R^2
=
1-\frac{\operatorname{SSE}}{\operatorname{SST}}.
$$

## Slide 126: Computing $R^2$ for the Provo regression

Source note: `regression-models/coefficient-of-determination.qmd`

The straight line reduces squared error by 5.56 percent relative to the mean-only predictor for these retained position summaries. The remaining proportion, 94.44 percent, is not automatically measurement error. It includes lexical, contextual, passage, reader-aggregation, and functional-form variation that this one-predictor line does not represent.

## Slide 127: Computing $R^2$ for the Provo regression

Source note: `regression-models/coefficient-of-determination.qmd`

For an OLS model with an intercept,

$$
\operatorname{SST}
=
\operatorname{SSR}+\operatorname{SSE},
$$

where $\operatorname{SSR}=\sum_i(\widehat y_i-\overline y)^2$.

## Slide 128: Computing $R^2$ for the Provo regression

Source note: `regression-models/coefficient-of-determination.qmd`

This decomposition yields the equivalent expression

$$
R^2=\frac{\operatorname{SSR}}{\operatorname{SST}}.
$$

## Slide 129: Computing $R^2$ for the Provo regression

Source note: `regression-models/coefficient-of-determination.qmd`

This figure shows provo positions, the mean-only baseline, and the fitted Provo regression line.

## Slide 130: Computing $R^2$ for the Provo regression

Source note: `regression-models/coefficient-of-determination.qmd`

$R^2$ is a within-sample descriptive comparison on the modeled response scale. It is not a predictive evaluation on new passages, and a larger $R^2$ does not by itself license a stronger linguistic explanation.

## Slide 131: The coefficient of determination: question 1

Source note: `regression-models/coefficient-of-determination.qmd`

What is the baseline model in the $R^2$ calculation?

## Slide 132: The coefficient of determination: answer 1

Source note: `regression-models/coefficient-of-determination.qmd`

The baseline predicts every retained Provo position by the same sample mean response.

## Slide 133: The coefficient of determination: question 2

Source note: `regression-models/coefficient-of-determination.qmd`

Why is $R^2$ tied to the response scale?

## Slide 134: The coefficient of determination: answer 2

Source note: `regression-models/coefficient-of-determination.qmd`

Both SSE and SST are computed after choosing a response transformation; changing that scale changes squared distances and their ratio.

## Slide 135: The coefficient of determination: question 3

Source note: `regression-models/coefficient-of-determination.qmd`

What does the unexplained proportion contain?

## Slide 136: The coefficient of determination: answer 3

Source note: `regression-models/coefficient-of-determination.qmd`

The unexplained proportion contains lexical, contextual, passage, reader-aggregation, functional-form, and other variation omitted by the one-predictor line.

## Slide 137: The coefficient of determination: question 4

Source note: `regression-models/coefficient-of-determination.qmd`

Why is this not a new-passage prediction score?

## Slide 138: The coefficient of determination: answer 4

Source note: `regression-models/coefficient-of-determination.qmd`

The reported $R^2$ is calculated on the same positions used to fit the model, with no held-out passages or other out-of-sample prediction target. The next page inspects the observation-level discrepancies that make up SSE.

## Slide 139: Residuals

Source note: `regression-models/residuals.qmd`

Next, we take up Residuals.

## Slide 140: Residuals

Source note: `regression-models/residuals.qmd`

The Provo regression line assigns each word position a fitted conditional mean. A **residual** is the observed response minus that fitted value:

$$
e_i=y_i-\widehat y_i.
$$

## Slide 141: Residuals

Source note: `regression-models/residuals.qmd`

A positive residual marks a position above the fitted line; a negative residual marks one below it. The residual is observable after fitting. It is not the unobserved population error $\varepsilon_i$.

## Slide 142: Computing the Provo regression residuals

Source note: `regression-models/residuals.qmd`

With an intercept, the normal equations include

$$
\frac{\partial\operatorname{SSE}}{\partial\beta_0}
=
-2\sum_i(y_i-\beta_0-\beta_1x_i)=0.
$$

## Slide 143: Computing the Provo regression residuals

Source note: `regression-models/residuals.qmd`

At the OLS solution, this gives

$$
\sum_i e_i=0.
$$

## Slide 144: Computing the Provo regression residuals

Source note: `regression-models/residuals.qmd`

The Provo regression residuals sum to -5.33e-15. That algebraic property is not evidence that positive and negative discrepancies are equally plausible in every region of the predictor.

## Slide 145: Computing the Provo regression residuals

Source note: `regression-models/residuals.qmd`

This figure shows observed Provo position summaries with the fitted line, followed by the same discrepancies on a residual scale.

## Slide 146: Computing the Provo regression residuals

Source note: `regression-models/residuals.qmd`

Provo regression residuals against fitted values. The blue curve is a descriptive loess smooth.

## Slide 147: Computing the Provo regression residuals

Source note: `regression-models/residuals.qmd`

The smooth bends modestly rather than remaining perfectly horizontal. This pattern motivates a functional-form check; it does not by itself establish which alternative model is correct.

## Slide 148: Residuals: question 1

Source note: `regression-models/residuals.qmd`

Why does a positive residual place an observation above the line?

## Slide 149: Residuals: answer 1

Source note: `regression-models/residuals.qmd`

Because $e_i=y_i-\widehat y_i$, a positive value means $y_i>\widehat y_i$ and the point lies above the fitted line.

## Slide 150: Residuals: question 2

Source note: `regression-models/residuals.qmd`

Why must OLS residuals sum to zero when the model has an intercept?

## Slide 151: Residuals: answer 2

Source note: `regression-models/residuals.qmd`

The intercept normal equation sets the derivative with respect to $\beta_0$ to zero, which requires $\sum_i e_i=0$.

## Slide 152: Residuals: question 3

Source note: `regression-models/residuals.qmd`

Is a residual the same object as an error term?

## Slide 153: Residuals: answer 3

Source note: `regression-models/residuals.qmd`

No. A residual is an observed post-fit discrepancy; an error term is an unobserved random quantity in the population model.

## Slide 154: Residuals: question 4

Source note: `regression-models/residuals.qmd`

What model restriction does curvature challenge?

## Slide 155: Residuals: answer 4

Source note: `regression-models/residuals.qmd`

Curvature challenges the restriction that the conditional mean is a straight line in modeled cloze surprisal. The next page turns residual patterns into explicit model checks.

## Slide 156: Checking a linear regression

Source note: `regression-models/checking-linear-regression.qmd`

Now we turn to Checking a linear regression.

## Slide 157: Checking a linear regression

Source note: `regression-models/checking-linear-regression.qmd`

A **regression check** compares a model prediction with an observable pattern. The aim is not to certify the model as true. It is to locate failures that matter for the linguistic comparison.

## Slide 158: Checking a linear regression

Source note: `regression-models/checking-linear-regression.qmd`

For the Provo regression, we check a linear conditional mean, stable residual location across passages, and approximately normal residual shape.

## Slide 159: Linear form and passage structure

Source note: `regression-models/checking-linear-regression.qmd`

Adding the squared observed predictor changes $R^2$ from 0.0556 to 0.0592. This is a diagnostic sensitivity, not automatic evidence for a quadratic processing mechanism.

## Slide 160: Linear form and passage structure

Source note: `regression-models/checking-linear-regression.qmd`

This figure shows provo positions with the linear fit in blue and the quadratic diagnostic in black.

## Slide 161: Linear form and passage structure

Source note: `regression-models/checking-linear-regression.qmd`

This figure shows mean residual for each Provo passage, ordered from lowest to highest.

## Slide 162: Linear form and passage structure

Source note: `regression-models/checking-linear-regression.qmd`

The passage means show location differences that the single line does not represent. Their ordering is descriptive; the plot does not treat adjacent ranks as linguistically adjacent passages.

## Slide 163: Residual shape

Source note: `regression-models/checking-linear-regression.qmd`

If the normal working model were exact, ordered standardized residuals would track normal quantiles. A quantile plot makes tail departures visible without reducing the check to one test statistic.

## Slide 164: Residual shape

Source note: `regression-models/checking-linear-regression.qmd`

This figure shows normal quantiles against ordered Provo regression residuals. The line passes through the empirical quartiles.

## Slide 165: Residual shape

Source note: `regression-models/checking-linear-regression.qmd`

The checks point to modest curvature and some tail departure. They do not repair passage or reader dependence. This limit matters: changing the mean function cannot recreate a missing sampling unit.

## Slide 166: Checking a linear regression: question 1

Source note: `regression-models/checking-linear-regression.qmd`

Which restriction does the quadratic diagnostic probe?

## Slide 167: Checking a linear regression: answer 1

Source note: `regression-models/checking-linear-regression.qmd`

The quadratic diagnostic probes the straight-line restriction on the conditional mean by allowing a squared surprisal term.

## Slide 168: Checking a linear regression: question 2

Source note: `regression-models/checking-linear-regression.qmd`

Why is a better in-sample $R^2$ not enough to select the quadratic model?

## Slide 169: Checking a linear regression: answer 2

Source note: `regression-models/checking-linear-regression.qmd`

Adding a parameter cannot by itself establish a processing mechanism, and in-sample fit does not measure new-passage performance or account for complexity.

## Slide 170: Checking a linear regression: question 3

Source note: `regression-models/checking-linear-regression.qmd`

What pattern would an exact normal residual model predict in the quantile plot?

## Slide 171: Checking a linear regression: answer 3

Source note: `regression-models/checking-linear-regression.qmd`

The ordered residuals would track the reference line across the center and tails, apart from ordinary sampling fluctuation.

## Slide 172: Checking a linear regression: question 4

Source note: `regression-models/checking-linear-regression.qmd`

Which dependence problem survives both checks?

## Slide 173: Checking a linear regression: answer 4

Source note: `regression-models/checking-linear-regression.qmd`

Passage dependence remains, and missing reader-level dependence cannot be checked or repaired from the aggregated table. The next page asks which observed predictor positions have unusual capacity to affect the line.

## Slide 174: Leverage

Source note: `regression-models/leverage-and-influence.qmd`

Our next step is Leverage.

## Slide 175: Leverage

Source note: `regression-models/leverage-and-influence.qmd`

Residual size describes a response discrepancy. **Leverage** instead describes how unusual an observation's predictor row is within the fitted design.

## Slide 176: The hat matrix

Source note: `regression-models/leverage-and-influence.qmd`

OLS fitted values can be written as

$$
\widehat{\mathbf Y}
=
\mathbf X(\mathbf X^\top\mathbf X)^{-1}\mathbf X^\top\mathbf Y
=
\mathbf H\mathbf Y.
$$

## Slide 177: The hat matrix

Source note: `regression-models/leverage-and-influence.qmd`

The matrix $\mathbf H$ maps observed responses to fitted values. Its diagonal element

$$
h_{ii}
=
\mathbf x_i^\top(\mathbf X^\top\mathbf X)^{-1}\mathbf x_i
$$

is observation $i$'s leverage.

## Slide 178: The hat matrix

Source note: `regression-models/leverage-and-influence.qmd`

For a simple regression with an intercept,

$$
h_{ii}
=
\frac{1}{n}
+
\frac{(x_i-\overline x)^2}
{\sum_j(x_j-\overline x)^2}.
$$

## Slide 179: The hat matrix

Source note: `regression-models/leverage-and-influence.qmd`

The formula makes the source of leverage explicit: predictor values far from the observed center have more capacity to determine the fitted line.

## Slide 180: The hat matrix

Source note: `regression-models/leverage-and-influence.qmd`

The leverage values sum to 2, the number of fitted coefficients. The conventional twice-average threshold marks 53 observed positions for inspection; it is not a deletion rule.

## Slide 181: The hat matrix

Source note: `regression-models/leverage-and-influence.qmd`

Provo leverage across observed modeled cloze surprisal. Black points exceed twice the average leverage.

## Slide 182: The hat matrix

Source note: `regression-models/leverage-and-influence.qmd`

High leverage is a design property. A high-leverage point can lie exactly on the fitted line and have little case-deletion effect. The next page combines leverage with residual size.

## Slide 183: Leverage: question 1

Source note: `regression-models/leverage-and-influence.qmd`

Why does leverage not use the observed response?

## Slide 184: Leverage: answer 1

Source note: `regression-models/leverage-and-influence.qmd`

Leverage depends only on the predictor row and the design matrix, not on the observed response value.

## Slide 185: Leverage: question 2

Source note: `regression-models/leverage-and-influence.qmd`

Why do the diagonal values sum to the number of coefficients?

## Slide 186: Leverage: answer 2

Source note: `regression-models/leverage-and-influence.qmd`

The hat matrix is an idempotent projection with trace equal to its rank, which is the number of estimable coefficients.

## Slide 187: Leverage: question 3

Source note: `regression-models/leverage-and-influence.qmd`

What makes a predictor value high leverage in simple regression?

## Slide 188: Leverage: answer 3

Source note: `regression-models/leverage-and-influence.qmd`

A value far from the observed predictor mean relative to the total predictor spread has high leverage.

## Slide 189: Leverage: question 4

Source note: `regression-models/leverage-and-influence.qmd`

Why is a threshold not an automatic exclusion rule?

## Slide 190: Leverage: answer 4

Source note: `regression-models/leverage-and-influence.qmd`

The twice-average leverage threshold is a screening convention, not evidence of error; a high-leverage observation can be valid and have little influence when its residual is small.

## Slide 191: Influence

Source note: `regression-models/influence.qmd`

Next, we take up Influence.

## Slide 192: Influence

Source note: `regression-models/influence.qmd`

Leverage measures unusual predictor position. **Influence** asks how much the fitted result changes when an observation, or a scientifically meaningful group of observations, is removed.

## Slide 193: Cook's distance and grouped deletion

Source note: `regression-models/influence.qmd`

For a Gaussian linear model with $p$ coefficients and residual variance estimate $s^2$, Cook's distance for position $i$ is

$$
D_i
=
\frac{e_i^2}{ps^2}
\frac{h_{ii}}{(1-h_{ii})^2}.
$$

## Slide 194: Cook's distance and grouped deletion

Source note: `regression-models/influence.qmd`

Large residuals and high leverage can jointly produce a large $D_i$. But the Provo regression retains passages as a grouping unit, so deleting one position is not the only relevant perturbation. We also refit after deleting each whole passage.

## Slide 195: Cook's distance and grouped deletion

Source note: `regression-models/influence.qmd`

The largest whole-passage deletion changes the slope by -0.000317 log milliseconds per bit. This change is computed by removing passage 2, not by inventing a perturbation.

## Slide 196: Cook's distance and grouped deletion

Source note: `regression-models/influence.qmd`

This figure shows observed Provo positions with the full fit in blue and the fit after deleting the most slope-influential passage in black.

## Slide 197: Cook's distance and grouped deletion

Source note: `regression-models/influence.qmd`

The two lines remain close. That stability is specific to the fitted Provo regression slope under these passage deletions. It does not show that the missing reader-level grouping is unimportant.

## Slide 198: Influence: question 1

Source note: `regression-models/influence.qmd`

Why does Cook's distance combine residual size and leverage?

## Slide 199: Influence: answer 1

Source note: `regression-models/influence.qmd`

Residual size measures disagreement with the fitted line, while leverage measures capacity to move it; Cook's distance is large when those features act together.

## Slide 200: Influence: question 2

Source note: `regression-models/influence.qmd`

Which deletion unit matches the remaining Provo regression grouping structure?

## Slide 201: Influence: answer 2

Source note: `regression-models/influence.qmd`

Deleting a whole passage matches the remaining grouping structure marked by `Text_ID`.

## Slide 202: Influence: question 3

Source note: `regression-models/influence.qmd`

What would a large passage-level slope change imply?

## Slide 203: Influence: answer 3

Source note: `regression-models/influence.qmd`

A large passage-level slope change would show that the fitted surprisal slope is sensitive to evidence concentrated in that passage.

## Slide 204: Influence: question 4

Source note: `regression-models/influence.qmd`

Why is influence a diagnostic rather than a deletion command?

## Slide 205: Influence: answer 4

Source note: `regression-models/influence.qmd`

Influence identifies consequential observations or groups for investigation; deletion requires a separate measurement or design justification. The next page places a posterior distribution over the same line.

## Slide 206: Bayesian linear regression

Source note: `regression-models/bayesian-linear-regression.qmd`

The next topic is Bayesian linear regression.

## Slide 207: Bayesian linear regression

Source note: `regression-models/bayesian-linear-regression.qmd`

The Provo Gaussian linear model can be combined with a prior to produce a posterior distribution over regression lines. The response model remains

$$
\mathbf Y\mid\boldsymbol\beta,\sigma^2
\sim
\mathcal N(\mathbf X\boldsymbol\beta,\sigma^2\mathbf I).
$$

## Slide 208: Bayesian linear regression

Source note: `regression-models/bayesian-linear-regression.qmd`

What changes is that uncertainty about $\boldsymbol\beta$ and $\sigma^2$ is represented before and after observing the responses.

## Slide 209: A conjugate prior specification

Source note: `regression-models/bayesian-linear-regression.qmd`

We use the normal--inverse-gamma specification

$$
\boldsymbol\beta\mid\sigma^2
\sim
\mathcal N(\mathbf b_0,\sigma^2\mathbf V_0)
$$

and

$$
\sigma^2\sim\operatorname{InverseGamma}(a_0,d_0).
$$

## Slide 210: A conjugate prior specification

Source note: `regression-models/bayesian-linear-regression.qmd`

The posterior is again normal--inverse-gamma, with

$$
\mathbf V_n
=
(\mathbf V_0^{-1}+\mathbf X^\top\mathbf X)^{-1},
$$

$$
\mathbf b_n
=
\mathbf V_n
(\mathbf V_0^{-1}\mathbf b_0+\mathbf X^\top\mathbf y),
$$

$$
a_n=a_0+\frac n2,
$$

and

$$
d_n
=
d_0+\frac12
\left(
\mathbf y^\top\mathbf y
+\mathbf b_0^\top\mathbf V_0^{-1}\mathbf b_0
-\mathbf b_n^\top\mathbf V_n^{-1}\mathbf b_n
\right).
$$

## Slide 211: Computing the posterior

Source note: `regression-models/bayesian-linear-regression.qmd`

The posterior mean slope is 0.008872, with a central interval from 0.007099 to 0.010686.

## Slide 212: Computing the posterior

Source note: `regression-models/bayesian-linear-regression.qmd`

The coefficient-prior location and scale use the observed Provo response and predictor scales. The inverse-gamma shape is one plus the observed design dimension, and its scale sets the prior mean of $\sigma^2$ to the OLS residual variance. These data-dependent priors are useful for connecting conjugate algebra to regression, but they are not independently specified confirmatory priors.

## Slide 213: Computing the posterior

Source note: `regression-models/bayesian-linear-regression.qmd`

This figure shows provo positions with the posterior mean line and a central posterior interval for the conditional mean.

## Slide 214: Computing the posterior

Source note: `regression-models/bayesian-linear-regression.qmd`

The posterior represents uncertainty under the same aggregated position likelihood. Bayesian updating does not restore participant observations or make the association causal.

## Slide 215: Bayesian linear regression: question 1

Source note: `regression-models/bayesian-linear-regression.qmd`

Which part of the model is shared with OLS?

## Slide 216: Bayesian linear regression: answer 1

Source note: `regression-models/bayesian-linear-regression.qmd`

The Gaussian linear response model, including the straight conditional mean and common independent residual variance, is shared with OLS.

## Slide 217: Bayesian linear regression: question 2

Source note: `regression-models/bayesian-linear-regression.qmd`

Why is this not a confirmatory prior analysis?

## Slide 218: Bayesian linear regression: answer 2

Source note: `regression-models/bayesian-linear-regression.qmd`

The coefficient and variance priors are calibrated from the observed predictor, response, and OLS residual scales rather than specified independently before seeing the data.

## Slide 219: Bayesian linear regression: question 3

Source note: `regression-models/bayesian-linear-regression.qmd`

Why are predictions computed for every posterior draw?

## Slide 220: Bayesian linear regression: answer 3

Source note: `regression-models/bayesian-linear-regression.qmd`

Evaluating the fitted mean within every joint draw propagates posterior covariance among coefficients into uncertainty about the prediction.

## Slide 221: Bayesian linear regression: question 4

Source note: `regression-models/bayesian-linear-regression.qmd`

Which data limitation survives the Bayesian formulation?

## Slide 222: Bayesian linear regression: answer 4

Source note: `regression-models/bayesian-linear-regression.qmd`

The data still contain reader-aggregated position summaries, so participant-level responses and dependence remain unavailable. The next page switches to MALD and adds several item predictors.

## Slide 223: Adding predictors

Source note: `regression-models/multiple-regression.qmd`

Now we turn to Adding predictors.

## Slide 224: MALD: the empirical object

Source note: `regression-models/multiple-regression.qmd`

The data source is Tucker et al. (2019), MALD. It provides participant-by-word auditory lexical-decision trials.

## Slide 225: Adding predictors

Source note: `regression-models/multiple-regression.qmd`

Simple regression compares conditional means across one predictor. **Multiple regression** lets several observed predictors contribute to the same conditional mean, so each slope becomes a partial comparison.

## Slide 226: MALD word-item data

Source note: `regression-models/multiple-regression.qmd`

We now use data from the Massive Auditory Lexical Decision database (MALD). Tucker et al. (2019) describe the database and analyze lexical frequency as a predictor of response time. The MALD 1.1 release is available under CC BY-NC 4.0.

## Slide 227: MALD word-item data

Source note: `regression-models/multiple-regression.qmd`

The course table contains word items summarized over correct retained trials whose response times and frequency satisfy the documented filters. One row is one word item, not one participant response. The table retains the number and dispersion of contributing trials, but it cannot recover participant effects. We model mean log auditory lexical-decision time from SUBTLEX frequency, acoustic duration, and phone count.

## Slide 228: MALD word-item data

Source note: `regression-models/multiple-regression.qmd`

The table contains 23756 distinct word items. The conditional mean is

$$
\mu_i
=
\beta_0
+\beta_fF_i^c
+\beta_dD_i^c
+\beta_pP_i^c,
$$

where $F_i^c$ is centered log SUBTLEX frequency, $D_i^c$ is centered log acoustic duration, and $P_i^c$ is centered phone count.

## Slide 229: MALD word-item data

Source note: `regression-models/multiple-regression.qmd`

Holding acoustic duration and phone count fixed, a one-unit increase in log frequency is associated with -0.0172 log response-time units. Holding the other two predictors fixed is a model comparison, not an experimental intervention.

## Slide 230: MALD word-item data

Source note: `regression-models/multiple-regression.qmd`

This figure shows mALD item summaries and the fitted frequency relation at observed mean duration and phone count.

## Slide 231: MALD word-item data

Source note: `regression-models/multiple-regression.qmd`

The fitted MALD regression explains 29.3 percent of item-level squared variation under this specification. That quantity concerns correct-trial summaries. It is not a participant-level model and should not be presented as a reproduction of Tucker et al.’s crossed mixed-effects analysis.

## Slide 232: Adding predictors: question 1

Source note: `regression-models/multiple-regression.qmd`

What is one observation in the MALD analysis?

## Slide 233: Adding predictors: answer 1

Source note: `regression-models/multiple-regression.qmd`

One observation is one MALD word item summarized over its retained correct trials.

## Slide 234: Adding predictors: question 2

Source note: `regression-models/multiple-regression.qmd`

Which variables are held fixed when reading the frequency coefficient?

## Slide 235: Adding predictors: answer 2

Source note: `regression-models/multiple-regression.qmd`

Acoustic duration and phone count are held fixed when the log-frequency coefficient is read.

## Slide 236: Adding predictors: question 3

Source note: `regression-models/multiple-regression.qmd`

Why is the displayed line conditional rather than marginal?

## Slide 237: Adding predictors: answer 3

Source note: `regression-models/multiple-regression.qmd`

The line sets the other predictors to their observed means, so it describes the fitted frequency relation at those fixed values rather than averaging over their observed joint distribution.

## Slide 238: Adding predictors: question 4

Source note: `regression-models/multiple-regression.qmd`

Which dependence structure cannot be recovered from this table?

## Slide 239: Adding predictors: answer 4

Source note: `regression-models/multiple-regression.qmd`

Participant-level dependence cannot be recovered because the table omits individual trials and participant identifiers. The next page shows how these observation-specific equations become one matrix calculation.

## Slide 240: Design matrices

Source note: `regression-models/design-matrices.qmd`

Our next step is Design matrices.

## Slide 241: Design matrices

Source note: `regression-models/design-matrices.qmd`

A regression formula is converted into a numeric **design matrix**. Each row represents one observed MALD item; each column gives that item's multiplier for one coefficient.

## Slide 242: From equations to a matrix

Source note: `regression-models/design-matrices.qmd`

The MALD regression can be written

$$
\mathbf y=\mathbf X\boldsymbol\beta+\boldsymbol\varepsilon.
$$

## Slide 243: From equations to a matrix

Source note: `regression-models/design-matrices.qmd`

For item $i$, the design row is

$$
\mathbf x_i^\top
=
\begin{bmatrix}
1 & F_i^c & D_i^c & P_i^c
\end{bmatrix}.
$$

## Slide 244: From equations to a matrix

Source note: `regression-models/design-matrices.qmd`

Its fitted mean is the inner product

$$
\widehat y_i=\mathbf x_i^\top\widehat{\boldsymbol\beta}.
$$

## Slide 245: Inspecting observed rows

Source note: `regression-models/design-matrices.qmd`

Three observed MALD items near the 10th, 50th, and 90th frequency quantiles anchor the matrix calculation in attested predictor combinations.

## Slide 246: Inspecting observed rows

Source note: `regression-models/design-matrices.qmd`

Observed MALD item means and their fitted multiple-regression values. The diagonal marks exact agreement.

## Slide 247: Inspecting observed rows

Source note: `regression-models/design-matrices.qmd`

The complete MALD design matrix has one intercept column and three columns of observed centered item properties.

## Slide 248: Inspecting observed rows

Source note: `regression-models/design-matrices.qmd`

The OLS solution follows by differentiating

$$
(\mathbf y-\mathbf X\boldsymbol\beta)^\top
(\mathbf y-\mathbf X\boldsymbol\beta)
$$

with respect to $\boldsymbol\beta$.

## Slide 249: Inspecting observed rows

Source note: `regression-models/design-matrices.qmd`

Setting the gradient to zero gives the normal equations

$$
\mathbf X^\top\mathbf X\widehat{\boldsymbol\beta}
=
\mathbf X^\top\mathbf y,
$$

and, when $\mathbf X^\top\mathbf X$ is invertible,

$$
\widehat{\boldsymbol\beta}
=(\mathbf X^\top\mathbf X)^{-1}\mathbf X^\top\mathbf y.
$$

## Slide 250: Inspecting observed rows

Source note: `regression-models/design-matrices.qmd`

The design matrix makes coefficient meaning auditable. It also exposes a failure: if one column is an exact linear combination of others, the inverse does not exist. The correlated-predictor pages return to this issue with the observed MALD design.

## Slide 251: Design matrices: question 1

Source note: `regression-models/design-matrices.qmd`

What does one row of $\mathbf X$ represent?

## Slide 252: Design matrices: answer 1

Source note: `regression-models/design-matrices.qmd`

One row represents one observed MALD item and gives its multiplier for each coefficient.

## Slide 253: Design matrices: question 2

Source note: `regression-models/design-matrices.qmd`

Why is the intercept column constant?

## Slide 254: Design matrices: answer 2

Source note: `regression-models/design-matrices.qmd`

A constant column of ones makes its coefficient contribute the same intercept to every fitted item mean.

## Slide 255: Design matrices: question 3

Source note: `regression-models/design-matrices.qmd`

How does a row produce one fitted value?

## Slide 256: Design matrices: answer 3

Source note: `regression-models/design-matrices.qmd`

The inner product $\mathbf x_i^\mathsf T\widehat{\boldsymbol\beta}$ multiplies each row entry by its coefficient and sums the products.

## Slide 257: Design matrices: question 4

Source note: `regression-models/design-matrices.qmd`

What matrix property fails under exact collinearity?

## Slide 258: Design matrices: answer 4

Source note: `regression-models/design-matrices.qmd`

$\mathbf X^\mathsf T\mathbf X$ loses full rank and becomes noninvertible under exact collinearity. The next page constructs design columns for a categorical item property.

## Slide 259: Coding a categorical predictor

Source note: `regression-models/coding-categorical-predictors.qmd`

Next, we take up Coding a categorical predictor.

## Slide 260: Coding a categorical predictor

Source note: `regression-models/coding-categorical-predictors.qmd`

A categorical predictor has labels rather than intrinsic numerical distances. **Contrast coding** constructs numeric design columns that make declared comparisons estimable.

## Slide 261: Treatment coding in MALD

Source note: `regression-models/coding-categorical-predictors.qmd`

We restrict this page to the three largest lexical part-of-speech classes in the MALD regression: noun, verb, and adjective. MALD's part-of-speech field is a word-form summary from SUBTLEX, not a token annotation in sentential context.

## Slide 262: Treatment coding in MALD

Source note: `regression-models/coding-categorical-predictors.qmd`

With noun as the reference, treatment coding uses

$$
\begin{array}{c|cc}
&V&A\\\hline
\text{noun}&0&0\\
\text{verb}&1&0\\
\text{adjective}&0&1
\end{array}.
$$

## Slide 263: Treatment coding in MALD

Source note: `regression-models/coding-categorical-predictors.qmd`

The fitted mean is

$$
\mu_i
=
\beta_0+\beta_VV_i+\beta_AA_i
+\beta_fF_i^c+\beta_dD_i^c+\beta_pP_i^c.
$$

## Slide 264: Treatment coding in MALD

Source note: `regression-models/coding-categorical-predictors.qmd`

At the centered numeric predictors, $\beta_0$ is the fitted noun mean, $\beta_V$ is the verb-minus-noun contrast, and $\beta_A$ is the adjective-minus-noun contrast.

## Slide 265: Treatment coding in MALD

Source note: `regression-models/coding-categorical-predictors.qmd`

The fitted verb-minus-noun contrast is -0.0002 log response-time units at the same modeled numeric predictors. The adjective-minus-noun contrast is 0.0095.

## Slide 266: Treatment coding in MALD

Source note: `regression-models/coding-categorical-predictors.qmd`

This figure shows observed MALD item summaries and adjusted part-of-speech means at observed mean frequency, duration, and phone count.

## Slide 267: Treatment coding in MALD

Source note: `regression-models/coding-categorical-predictors.qmd`

Changing the reference category changes the coefficient labels, not the fitted value for any item. The next page demonstrates this invariance with a different basis.

## Slide 268: Coding a categorical predictor: question 1

Source note: `regression-models/coding-categorical-predictors.qmd`

What does the intercept represent under noun-reference coding?

## Slide 269: Coding a categorical predictor: answer 1

Source note: `regression-models/coding-categorical-predictors.qmd`

Under noun-reference coding, the intercept is the fitted noun mean at mean log frequency, mean log duration, and mean phone count.

## Slide 270: Coding a categorical predictor: question 2

Source note: `regression-models/coding-categorical-predictors.qmd`

Which categories does the verb coefficient compare?

## Slide 271: Coding a categorical predictor: answer 2

Source note: `regression-models/coding-categorical-predictors.qmd`

The verb coefficient compares the fitted verb mean with the fitted noun mean at the same numeric predictor values.

## Slide 272: Coding a categorical predictor: question 3

Source note: `regression-models/coding-categorical-predictors.qmd`

Why is the category variable not intrinsically numeric?

## Slide 273: Coding a categorical predictor: answer 3

Source note: `regression-models/coding-categorical-predictors.qmd`

The category variable's labels define groups but provide no intrinsic spacing, order, or arithmetic operation; those properties must come from declared contrasts.

## Slide 274: Coding a categorical predictor: question 4

Source note: `regression-models/coding-categorical-predictors.qmd`

Which quantities should remain unchanged under recoding?

## Slide 275: Coding a categorical predictor: answer 4

Source note: `regression-models/coding-categorical-predictors.qmd`

Fitted values, residuals, SSE, and predictions for the same observed conditions should remain unchanged under full-rank recoding.

## Slide 276: Sum coding

Source note: `regression-models/sum-coding.qmd`

Our next step is Sum coding.

## Slide 277: Sum coding

Source note: `regression-models/sum-coding.qmd`

Treatment coding makes one observed category the reference. **Sum coding** instead makes the intercept the unweighted mean of the fitted category means at the numeric predictor reference values.

## Slide 278: A different basis for the same MALD means

Source note: `regression-models/sum-coding.qmd`

For three levels, R's sum-coding matrix is

$$
\begin{array}{c|rr}
&S_1&S_2\\\hline
\text{noun}&1&0\\
\text{verb}&0&1\\
\text{adjective}&-1&-1
\end{array}.
$$

## Slide 279: A different basis for the same MALD means

Source note: `regression-models/sum-coding.qmd`

The category-specific fitted means at centered numeric predictors are

$$
\mu_N=\beta_0+\beta_1,
\qquad
\mu_V=\beta_0+\beta_2,
\qquad
\mu_A=\beta_0-\beta_1-\beta_2.
$$

## Slide 280: A different basis for the same MALD means

Source note: `regression-models/sum-coding.qmd`

Averaging them gives

$$
\frac{\mu_N+\mu_V+\mu_A}{3}=\beta_0.
$$

## Slide 281: Verifying fitted-value invariance

Source note: `regression-models/sum-coding.qmd`

The largest fitted-value difference is 8.8e-14. The coefficients differ because the bases differ, but the column spaces and fitted item means are the same.

## Slide 282: Verifying fitted-value invariance

Source note: `regression-models/sum-coding.qmd`

This figure shows observed MALD item summaries and fitted category means. Recoding changes coefficients, not these fitted means.

## Slide 283: Verifying fitted-value invariance

Source note: `regression-models/sum-coding.qmd`

The sum-coded intercept gives equal weight to the three fitted category means, not to the unequal numbers of noun, verb, and adjective items. That distinction should be named whenever the categories are unbalanced.

## Slide 284: Sum coding: question 1

Source note: `regression-models/sum-coding.qmd`

Why does the sum-coded intercept equal an unweighted category mean?

## Slide 285: Sum coding: answer 1

Source note: `regression-models/sum-coding.qmd`

The three coded category deviations cancel, leaving the intercept equal to $(\mu_N+\mu_V+\mu_A)/3$.

## Slide 286: Sum coding: question 2

Source note: `regression-models/sum-coding.qmd`

Why can coefficients change while fitted values do not?

## Slide 287: Sum coding: answer 2

Source note: `regression-models/sum-coding.qmd`

A full-rank recoding changes the basis used to name coefficients while preserving the same design-matrix column space.

## Slide 288: Sum coding: question 3

Source note: `regression-models/sum-coding.qmd`

Does the intercept weight categories by their observed sample sizes?

## Slide 289: Sum coding: answer 3

Source note: `regression-models/sum-coding.qmd`

No. The sum-coded intercept gives each fitted category mean weight one third, regardless of the observed number of items in that category.

## Slide 290: Sum coding: question 4

Source note: `regression-models/sum-coding.qmd`

What property of the design matrix is invariant under a full-rank recoding?

## Slide 291: Sum coding: answer 4

Source note: `regression-models/sum-coding.qmd`

The column space, and thus the projection onto fitted values, is invariant. The next page uses ordered syllable bands to define successive comparisons.

## Slide 292: Helmert coding

Source note: `regression-models/helmert-coding.qmd`

Our next step is Helmert coding.

## Slide 293: Helmert coding

Source note: `regression-models/helmert-coding.qmd`

Some categorical predictors have an order that licenses planned comparisons. **Helmert coding** compares each later level with the average of earlier levels.

## Slide 294: Ordered syllable bands in MALD

Source note: `regression-models/helmert-coding.qmd`

We group item syllable counts into one, two, three, and four-or-more syllables. The open top band is internally heterogeneous, so these contrasts do not represent equal one-syllable steps.

## Slide 295: Ordered syllable bands in MALD

Source note: `regression-models/helmert-coding.qmd`

R's Helmert matrix for the observed band order is

$$
\begin{array}{c|rrr}
&H_1&H_2&H_3\\\hline % dqr-allow: symbolic-derivation
1&-1&-1&-1\\
2&1&-1&-1\\
3&0&2&-1\\ % dqr-allow: symbolic-derivation
4+&0&0&3 % dqr-allow: symbolic-derivation
\end{array}.
$$

## Slide 296: Ordered syllable bands in MALD

Source note: `regression-models/helmert-coding.qmd`

The columns compare two versus one, three versus the earlier-band average, and four-or-more versus the earlier-band average. Because the columns are not divided by their squared lengths, coefficient magnitude depends on this displayed scaling.

## Slide 297: Ordered syllable bands in MALD

Source note: `regression-models/helmert-coding.qmd`

The first Helmert coefficient is -0.0168. Under the displayed scaling, twice this coefficient equals the fitted two-band minus one-band contrast at mean frequency and duration.

## Slide 298: Ordered syllable bands in MALD

Source note: `regression-models/helmert-coding.qmd`

This figure shows observed MALD item summaries and adjusted means for ordered syllable-count bands.

## Slide 299: Ordered syllable bands in MALD

Source note: `regression-models/helmert-coding.qmd`

Orthogonality of the coding columns is an algebraic property. It does not make the observed item groups balanced, independent, or causally interpretable.

## Slide 300: Helmert coding: question 1

Source note: `regression-models/helmert-coding.qmd`

Which fitted means does the first Helmert column compare?

## Slide 301: Helmert coding: answer 1

Source note: `regression-models/helmert-coding.qmd`

The first Helmert column compares the fitted two-syllable mean with the fitted one-syllable mean.

## Slide 302: Helmert coding: question 2

Source note: `regression-models/helmert-coding.qmd`

Why must coefficient magnitude be read from the displayed scaling?

## Slide 303: Helmert coding: answer 2

Source note: `regression-models/helmert-coding.qmd`

The coefficient multiplies the displayed contrast column; because the column is not unit-normalized, the actual mean difference is twice the first coefficient.

## Slide 304: Helmert coding: question 3

Source note: `regression-models/helmert-coding.qmd`

Why is the four-or-more band not a one-unit step?

## Slide 305: Helmert coding: answer 3

Source note: `regression-models/helmert-coding.qmd`

The four-or-more-syllable band contains every item with at least four syllables, so its members differ internally and the boundary comparison is not a fixed one-syllable increment.

## Slide 306: Helmert coding: question 4

Source note: `regression-models/helmert-coding.qmd`

Does orthogonal coding make the linguistic predictors independent?

## Slide 307: Helmert coding: answer 4

Source note: `regression-models/helmert-coding.qmd`

No. Orthogonality is a property of the coding columns; it does not make observed item properties or groups statistically independent. The next page reverses the direction of the successive grouping.

## Slide 308: Earlier-versus-later Helmert contrasts

Source note: `regression-models/inverse-helmert-coding.qmd`

Our next step is Earlier-versus-later Helmert contrasts.

## Slide 309: Earlier-versus-later Helmert contrasts

Source note: `regression-models/inverse-helmert-coding.qmd`

**Reverse Helmert coding** compares each earlier level with the average of the levels that follow it. The matrix, rather than the label, determines the comparison.

## Slide 310: Reversing the MALD syllable comparisons

Source note: `regression-models/inverse-helmert-coding.qmd`

For the MALD syllable bands, use

$$
\mathbf C=
\begin{bmatrix}
3&0&0\\ % dqr-allow: symbolic-derivation
-1&2&0\\
-1&-1&1\\
-1&-1&-1
\end{bmatrix},
$$

with rows ordered as one, two, three, and four-or-more syllables.

## Slide 311: Reversing the MALD syllable comparisons

Source note: `regression-models/inverse-helmert-coding.qmd`

The orthogonal columns encode one versus the later-band average, two versus the later-two average, and three versus four-or-more. Under this scaling, those three mean differences are respectively four, three, and two times their fitted coefficients.

## Slide 312: Reversing the MALD syllable comparisons

Source note: `regression-models/inverse-helmert-coding.qmd`

The fitted values agree to within 1.7e-12. Reverse Helmert coding has changed the coordinate system for the category effects, not the fitted conditional means.

## Slide 313: Reversing the MALD syllable comparisons

Source note: `regression-models/inverse-helmert-coding.qmd`

This figure shows observed MALD item summaries and the fitted syllable-band means preserved by reverse Helmert coding.

## Slide 314: Reversing the MALD syllable comparisons

Source note: `regression-models/inverse-helmert-coding.qmd`

The top band remains open-ended. Thus the final coefficient compares two observed bands, but it does not estimate the effect of adding exactly one syllable.

## Slide 315: Earlier-versus-later Helmert contrasts: question 1

Source note: `regression-models/inverse-helmert-coding.qmd`

Which rows receive nonzero weights in the first contrast?

## Slide 316: Earlier-versus-later Helmert contrasts: answer 1

Source note: `regression-models/inverse-helmert-coding.qmd`

All four rows receive nonzero weights: 3 for the one-syllable band and -1 for each later band.

## Slide 317: Earlier-versus-later Helmert contrasts: question 2

Source note: `regression-models/inverse-helmert-coding.qmd`

Why do treatment and reverse Helmert coding preserve fitted values?

## Slide 318: Earlier-versus-later Helmert contrasts: answer 2

Source note: `regression-models/inverse-helmert-coding.qmd`

Both are full-rank bases for the same category-mean subspace, so they change coefficients but preserve fitted conditional means.

## Slide 319: Earlier-versus-later Helmert contrasts: question 3

Source note: `regression-models/inverse-helmert-coding.qmd`

What does the final contrast compare?

## Slide 320: Earlier-versus-later Helmert contrasts: answer 3

Source note: `regression-models/inverse-helmert-coding.qmd`

The final reverse Helmert contrast compares the fitted three-syllable mean with the fitted four-or-more-syllable mean; under the displayed scaling, that difference is twice the coefficient.

## Slide 321: Earlier-versus-later Helmert contrasts: question 4

Source note: `regression-models/inverse-helmert-coding.qmd`

Why is that contrast not a one-syllable causal effect?

## Slide 322: Earlier-versus-later Helmert contrasts: answer 4

Source note: `regression-models/inverse-helmert-coding.qmd`

The upper band is open-ended and membership is observational, so the contrast neither adds exactly one syllable nor identifies a causal intervention. The next page uses paired MegaOrientation judgments to define a difference in orientation shifts.

## Slide 323: Interaction contrasts

Source note: `regression-models/interactions.qmd`

The next topic is Interaction contrasts.

## Slide 324: MegaOrientation: the empirical object

Source note: `regression-models/interactions.qmd`

The data source is Moon and White (2020), MegaOrientation v1.1. It provides ordinal attitude reports grouped by embedded verb.

## Slide 325: Interaction contrasts

Source note: `regression-models/interactions.qmd`

An **interaction** states that one contrast changes across the levels of another variable. We introduce that idea with paired raw judgments, without fitting a linear model to an ordinal response.

## Slide 326: MegaOrientation and temporal interpretation

Source note: `regression-models/interactions.qmd`

Moon and White (2020) study whether the temporal orientation of English nonfinite complements is associated with clause-embedding predicates, complement structures, or both. The corrected MegaOrientation v1.1 release is available under CC BY-SA 4.0. Version 1.1 filters and reruns lists containing incorrectly inflected irregular verbs; the paper reports counts for version 1, while every number below comes from the corrected release.

## Slide 327: MegaOrientation and temporal interpretation

Source note: `regression-models/interactions.qmd`

One row is one native-speaker rating on the documented 1--7 acceptability scale. Each represented predicate--frame pair has a forced-past and a forced-future sentence item, with repeated judgments from participants. The pairs were selected upstream using acceptability evidence from MegaAcceptability, so this is an acceptability-selected portion of the clause-embedding lexicon.

## Slide 328: MegaOrientation and temporal interpretation

Source note: `regression-models/interactions.qmd`

The corrected release contains 44160 judgments from 862 participant identifiers. The paired table contains 2208 predicate-frame pairs.

## Slide 329: A difference in orientation shifts

Source note: `regression-models/interactions.qmd`

For frame $f$, define the observed orientation shift

$$
\Delta_f
=
\overline Y_{f,\text{future}}
-
\overline Y_{f,\text{past}}.
$$

## Slide 330: A difference in orientation shifts

Source note: `regression-models/interactions.qmd`

An additive restriction would require the same $\Delta_f$ for every frame. The interaction contrast between frames $f$ and $g$ is the difference in differences

$$
\Delta_f-\Delta_g
=
(\overline Y_{f,\text{future}}-\overline Y_{f,\text{past}})
-
(\overline Y_{g,\text{future}}-\overline Y_{g,\text{past}}).
$$

## Slide 331: A difference in orientation shifts

Source note: `regression-models/interactions.qmd`

The observed future-minus-past shift ranges from 1.102 to 2.464 rating points across frames. The corresponding difference in shifts is 1.362 points.

## Slide 332: A difference in orientation shifts

Source note: `regression-models/interactions.qmd`

Past- and future-oriented mean ratings for each predicate--frame pair. The diagonal marks equal paired means.

## Slide 333: A difference in orientation shifts

Source note: `regression-models/interactions.qmd`

The response is ordinal, and participant and item dependence is repeated. Thus we do not fit `lm(response ~ orientation * frame_code)`. A later page, after cumulative-logit models and grouped prediction have been introduced, will fit the approved ordinal interaction and compare it on unseen verbs. This page licenses only the raw paired interaction contrast; it does not reproduce Moon and White's latent-type analysis or distinguish lexical from structural sources by itself.

## Slide 334: Interaction contrasts: question 1

Source note: `regression-models/interactions.qmd`

What is paired when $\Delta_f$ is computed?

## Slide 335: Interaction contrasts: answer 1

Source note: `regression-models/interactions.qmd`

The forced-future and forced-past mean ratings are paired within the same predicate--frame combination.

## Slide 336: Interaction contrasts: question 2

Source note: `regression-models/interactions.qmd`

What equality would an additive restriction impose?

## Slide 337: Interaction contrasts: answer 2

Source note: `regression-models/interactions.qmd`

An additive restriction requires $\Delta_f=\Delta_g$ for every pair of frames, that is, the same future-minus-past shift in every frame.

## Slide 338: Interaction contrasts: question 3

Source note: `regression-models/interactions.qmd`

Why is a difference in shifts an interaction contrast?

## Slide 339: Interaction contrasts: answer 3

Source note: `regression-models/interactions.qmd`

A difference in shifts compares one orientation effect with another: $(\text{future}-\text{past})_f-(\text{future}-\text{past})_g$.

## Slide 340: Interaction contrasts: question 4

Source note: `regression-models/interactions.qmd`

Why is ordinary linear regression not fitted to these ratings here?

## Slide 341: Interaction contrasts: answer 4

Source note: `regression-models/interactions.qmd`

The 1--7 response is ordinal, with repeated participant and item dependence; an ordinary linear model of raw ratings would ignore both features. The next page returns to MALD and examines overlap among its item predictors.

## Slide 342: Correlated predictors

Source note: `regression-models/correlated-predictors.qmd`

Now we turn to Correlated predictors.

## Slide 343: Correlated predictors

Source note: `regression-models/correlated-predictors.qmd`

We now return to the MALD word-item data. A partial coefficient compares items that differ in one predictor while holding the others fixed. **Predictor collinearity** arises when the observed design contains relatively few such comparisons because predictor columns move together.

## Slide 344: Overlap in the MALD item design

Source note: `regression-models/correlated-predictors.qmd`

Longer spoken words tend to contain more phones and syllables. That empirical relation makes it harder to separate their partial associations with item-mean lexical-decision time.

## Slide 345: Overlap in the MALD item design

Source note: `regression-models/correlated-predictors.qmd`

For centered predictor columns $\mathbf x_j$ and $\mathbf x_k$, the sample correlation is

$$
r_{jk}
=
\frac{\mathbf x_j^\top\mathbf x_k}
{\sqrt{(\mathbf x_j^\top\mathbf x_j)
(\mathbf x_k^\top\mathbf x_k)}}.
$$

## Slide 346: Overlap in the MALD item design

Source note: `regression-models/correlated-predictors.qmd`

This normalized inner product is computed from observed MALD item properties. The phone-syllable correlation is 0.867.

## Slide 347: Overlap in the MALD item design

Source note: `regression-models/correlated-predictors.qmd`

This figure shows observed MALD phone and syllable counts with their fitted item-level relation.

## Slide 348: Overlap in the MALD item design

Source note: `regression-models/correlated-predictors.qmd`

If two design columns were exact multiples, $\mathbf X^\top\mathbf X$ would be singular and their separate coefficients would be unidentified. Here the relation is strong but not exact. OLS still returns unique coefficients, though their sampling variances may be inflated.

## Slide 349: Overlap in the MALD item design

Source note: `regression-models/correlated-predictors.qmd`

A potential worry is that correlation makes multiple regression invalid. Correlation alone does not do that. It changes which partial comparisons the design supports and how precisely they can be estimated. The scientific response is to inspect the overlap and align interpretation with it.

## Slide 350: Correlated predictors: question 1

Source note: `regression-models/correlated-predictors.qmd`

Which observed item properties overlap most strongly?

## Slide 351: Correlated predictors: answer 1

Source note: `regression-models/correlated-predictors.qmd`

Phone count and syllable count overlap most strongly in the observed MALD items.

## Slide 352: Correlated predictors: question 2

Source note: `regression-models/correlated-predictors.qmd`

Why does predictor overlap weaken a partial comparison?

## Slide 353: Correlated predictors: answer 2

Source note: `regression-models/correlated-predictors.qmd`

When predictors move together, few observed items vary in one while holding the other fixed, so the partial coefficient relies on limited comparisons and becomes less precise.

## Slide 354: Correlated predictors: question 3

Source note: `regression-models/correlated-predictors.qmd`

What happens under exact linear dependence?

## Slide 355: Correlated predictors: answer 3

Source note: `regression-models/correlated-predictors.qmd`

The design loses rank, $\mathbf X^\mathsf T\mathbf X$ becomes singular, and the separate coefficients are unidentified.

## Slide 356: Correlated predictors: question 4

Source note: `regression-models/correlated-predictors.qmd`

Why is a correlated design not automatically unusable?

## Slide 357: Correlated predictors: answer 4

Source note: `regression-models/correlated-predictors.qmd`

Imperfect correlation can still leave enough independent variation for unique, scientifically interpretable partial comparisons, though uncertainty may increase. The next page quantifies the coefficient-variance cost of this overlap.

## Slide 358: Variance inflation from correlated predictors

Source note: `regression-models/variance-inflation-factors.qmd`

Next, we take up Variance inflation from correlated predictors.

## Slide 359: Variance inflation from correlated predictors

Source note: `regression-models/variance-inflation-factors.qmd`

A **variance inflation factor (VIF)** compares coefficient uncertainty in the observed multivariable design with uncertainty under an orthogonal reference design.

## Slide 360: Auxiliary regressions

Source note: `regression-models/variance-inflation-factors.qmd`

For predictor $X_j$, regress it on all other model predictors and record the auxiliary $R_j^2$. Then

$$
\operatorname{VIF}_j
=
\frac{1}{1-R_j^2}.
$$

## Slide 361: Auxiliary regressions

Source note: `regression-models/variance-inflation-factors.qmd`

The corresponding standard-error multiplier is

$$
\sqrt{\operatorname{VIF}_j}.
$$

## Slide 362: Auxiliary regressions

Source note: `regression-models/variance-inflation-factors.qmd`

If the other columns explain none of $X_j$, then $R_j^2=0$ and the multiplier is one. As the auxiliary $R_j^2$ approaches one, the design supplies less independent information about coefficient $j$.

## Slide 363: Auxiliary regressions

Source note: `regression-models/variance-inflation-factors.qmd`

Phone count has the largest VIF, 5.22, inflating its conventional standard error by a factor of 2.28.

## Slide 364: Auxiliary regressions

Source note: `regression-models/variance-inflation-factors.qmd`

This figure shows variance inflation factors computed from the observed MALD item-predictor matrix.

## Slide 365: Auxiliary regressions

Source note: `regression-models/variance-inflation-factors.qmd`

No universal threshold turns a VIF into a scientific verdict. The relevant question is whether the design estimates the comparison that the coefficient is claimed to represent. The phone and syllable columns overlap substantially, so their separate slopes should be interpreted as partial item-property associations supported by the exceptions to that relation.

## Slide 366: Variance inflation from correlated predictors: question 1

Source note: `regression-models/variance-inflation-factors.qmd`

What does the auxiliary regression predict?

## Slide 367: Variance inflation from correlated predictors: answer 1

Source note: `regression-models/variance-inflation-factors.qmd`

The auxiliary regression for $X_j$ predicts that predictor from all the other predictors in the fitted design.

## Slide 368: Variance inflation from correlated predictors: question 2

Source note: `regression-models/variance-inflation-factors.qmd`

Why can a VIF never be below one in this calculation?

## Slide 369: Variance inflation from correlated predictors: answer 2

Source note: `regression-models/variance-inflation-factors.qmd`

Because $0\le R_j^2\le1$, $1/(1-R_j^2)\ge1$ whenever the auxiliary regression is well defined.

## Slide 370: Variance inflation from correlated predictors: question 3

Source note: `regression-models/variance-inflation-factors.qmd`

How does VIF relate to a standard-error multiplier?

## Slide 371: Variance inflation from correlated predictors: answer 3

Source note: `regression-models/variance-inflation-factors.qmd`

Holding residual variance and the predictor's total variation fixed, its coefficient standard error is multiplied by $\sqrt{\operatorname{VIF}_j}$.

## Slide 372: Variance inflation from correlated predictors: question 4

Source note: `regression-models/variance-inflation-factors.qmd`

Why is a threshold not a substitute for inspecting the design?

## Slide 373: Variance inflation from correlated predictors: answer 4

Source note: `regression-models/variance-inflation-factors.qmd`

A threshold does not show which item comparisons identify the coefficient or whether that partial contrast answers the linguistic question. The next page changes the estimation rule by shrinking overlapping coefficients.

## Slide 374: Shrinking correlated coefficients

Source note: `regression-models/ridge-regression.qmd`

Next, we take up Shrinking correlated coefficients.

## Slide 375: Shrinking correlated coefficients

Source note: `regression-models/ridge-regression.qmd`

**Ridge regression** adds a squared-coefficient penalty to the least-squares objective:

$$
\widehat{\boldsymbol\beta}^{\,\text{ridge}}(\lambda)
=
\arg\min_{\beta_0,\boldsymbol\beta}
\left[
\sum_i
\left(y_i-\beta_0-\mathbf x_i^\top\boldsymbol\beta\right)^2
+\lambda\sum_j\beta_j^2
\right].
$$

## Slide 376: Shrinking correlated coefficients

Source note: `regression-models/ridge-regression.qmd`

The intercept is left unpenalized. When predictors are on different scales, standardization must be estimated from the training data so that the penalty is comparable across columns.

## Slide 377: New-item validation in MALD

Source note: `regression-models/ridge-regression.qmd`

We use log frequency, log duration, phone count, and syllable count to predict a new MALD item summary. Every item occurs once in the table, so assigning folds by item is also a row split. `glmnet` estimates standardization separately inside each training-fold fit.

## Slide 378: New-item validation in MALD

Source note: `regression-models/ridge-regression.qmd`

The minimum-error penalty is 4.826e-05, while the one-standard-error penalty is 0.01844. The new-item RMSE is 0.110575 for the one-SE ridge fit and 0.109999 for OLS.

## Slide 379: New-item validation in MALD

Source note: `regression-models/ridge-regression.qmd`

New-item validation error across the ridge penalty grid. The solid and dashed lines mark the minimum-error and one-standard-error choices.

## Slide 380: New-item validation in MALD

Source note: `regression-models/ridge-regression.qmd`

Ridge does not beat OLS in this comparison. That outcome is part of the lesson: shrinkage changes the bias--variance tradeoff, but it does not guarantee lower predictive loss in a particular dataset.

## Slide 381: Shrinking correlated coefficients: question 1

Source note: `regression-models/ridge-regression.qmd`

Which coefficients are penalized?

## Slide 382: Shrinking correlated coefficients: answer 1

Source note: `regression-models/ridge-regression.qmd`

All non-intercept predictor coefficients are penalized; the intercept is left unpenalized.

## Slide 383: Shrinking correlated coefficients: question 2

Source note: `regression-models/ridge-regression.qmd`

Why must standardization be learned inside each training fold?

## Slide 384: Shrinking correlated coefficients: answer 2

Source note: `regression-models/ridge-regression.qmd`

Full-data standardization uses held-out predictor values to set the penalty scale, so validation no longer evaluates a purely training-fitted new-item procedure and its error estimate may be biased.

## Slide 385: Shrinking correlated coefficients: question 3

Source note: `regression-models/ridge-regression.qmd`

What is the held-out unit?

## Slide 386: Shrinking correlated coefficients: answer 3

Source note: `regression-models/ridge-regression.qmd`

One MALD word item is held out; because every item appears once, the item split is also a row split.

## Slide 387: Shrinking correlated coefficients: question 4

Source note: `regression-models/ridge-regression.qmd`

What does the observed OLS--ridge comparison show?

## Slide 388: Shrinking correlated coefficients: answer 4

Source note: `regression-models/ridge-regression.qmd`

In these fixed folds, one-SE ridge has higher new-item RMSE than OLS, so shrinkage does not improve this observed prediction comparison. The next page gives another representation of a partial coefficient.

## Slide 389: Residualizing a predictor

Source note: `regression-models/residualizing-a-predictor.qmd`

The next topic is Residualizing a predictor.

## Slide 390: Residualizing a predictor

Source note: `regression-models/residualizing-a-predictor.qmd`

**Residualizing a predictor** subtracts the part linearly predicted by declared controls. The resulting residual is sample- and model-dependent; it is not a purified linguistic measurement.

## Slide 391: The MALD phone-count coefficient

Source note: `regression-models/residualizing-a-predictor.qmd`

First regress phone count on syllable count, log duration, and log frequency:

$$
P_i
=
\alpha_0+\alpha_sS_i+\alpha_dD_i+\alpha_fF_i+R_{Pi}.
$$

Then retain the same controls in the response model:

$$
Y_i
=
\gamma_0+\gamma_pR_{Pi}
+\gamma_sS_i+\gamma_dD_i+\gamma_fF_i+\varepsilon_i.
$$

## Slide 392: The MALD phone-count coefficient

Source note: `regression-models/residualizing-a-predictor.qmd`

The Frisch--Waugh--Lovell result implies that $\widehat\gamma_p$ equals the phone-count coefficient in the original multiple regression containing $P_i$ and the same controls.

## Slide 393: The MALD phone-count coefficient

Source note: `regression-models/residualizing-a-predictor.qmd`

This figure shows mALD response residuals against phone-count residuals. The line represents the same partial phone coefficient as the original multiple regression.

## Slide 394: Residualization inside validation folds

Source note: `regression-models/residualizing-a-predictor.qmd`

If residualized predictors are used for prediction, the residualizer must be fitted on training items only. Otherwise held-out predictor information leaks into preprocessing.

## Slide 395: Residualization inside validation folds

Source note: `regression-models/residualizing-a-predictor.qmd`

The maximum foldwise prediction difference is 1.7e-14. This equality depends on retaining the same controls. Dropping them after residualization generally changes the fitted subspace and the estimand.

## Slide 396: Residualizing a predictor: question 1

Source note: `regression-models/residualizing-a-predictor.qmd`

Why is the phone residual not a directly observed phonological property?

## Slide 397: Residualizing a predictor: answer 1

Source note: `regression-models/residualizing-a-predictor.qmd`

The phone residual is the remainder from a sample-fitted linear model using syllables, duration, and frequency, so it depends on those controls and this MALD sample.

## Slide 398: Residualizing a predictor: question 2

Source note: `regression-models/residualizing-a-predictor.qmd`

Which controls must be retained for the coefficient equivalence?

## Slide 399: Residualizing a predictor: answer 2

Source note: `regression-models/residualizing-a-predictor.qmd`

The response model must retain syllable count, log duration, and log frequency, the same controls used in the phone residualizer.

## Slide 400: Residualizing a predictor: question 3

Source note: `regression-models/residualizing-a-predictor.qmd`

Why is full-data residualization leakage during validation?

## Slide 401: Residualizing a predictor: answer 3

Source note: `regression-models/residualizing-a-predictor.qmd`

The full-data residualizer uses held-out predictor values to define the preprocessing transformation before prediction.

## Slide 402: Residualizing a predictor: question 4

Source note: `regression-models/residualizing-a-predictor.qmd`

What exactly agrees across the two foldwise models?

## Slide 403: Residualizing a predictor: answer 4

Source note: `regression-models/residualizing-a-predictor.qmd`

The two models produce the same held-out fitted predictions within each fold, and their corresponding partial phone coefficients agree when the same controls are retained. The next page examines changing residual spread across MALD frequency.

## Slide 404: Changing conditional variance

Source note: `regression-models/heteroscedasticity.qmd`

The next topic is Changing conditional variance.

## Slide 405: Changing conditional variance

Source note: `regression-models/heteroscedasticity.qmd`

Ordinary linear regression assumes one conditional residual variance. **Heteroscedasticity** means that this spread changes across observations:

$$
\operatorname{Var}[Y_i\mid\mathbf x_i]=\sigma_i^2
$$

rather than

$$
\operatorname{Var}[Y_i\mid\mathbf x_i]=\sigma^2.
$$

## Slide 406: Residual spread across MALD frequency

Source note: `regression-models/heteroscedasticity.qmd`

The MALD regression provides two related spread measurements: absolute residuals from the item-mean model and the stored within-item standard deviation of correct log response times.

## Slide 407: Residual spread across MALD frequency

Source note: `regression-models/heteroscedasticity.qmd`

This figure shows absolute MALD residuals with equal-count-bin means in blue.

## Slide 408: Residual spread across MALD frequency

Source note: `regression-models/heteroscedasticity.qmd`

This figure shows observed within-item log-response-time standard deviations and their equal-count-bin means.

## Slide 409: Residual spread across MALD frequency

Source note: `regression-models/heteroscedasticity.qmd`

HC3 changes the covariance estimate while preserving the OLS coefficients and fitted means. It is a sensitivity analysis for coefficient uncertainty, not a model of why spread changes. The next page instead gives conditional scale its own regression equation.

## Slide 410: Residual spread across MALD frequency

Source note: `regression-models/heteroscedasticity.qmd`

The within-item spread is computed across retained correct trials. Because the item table lacks participant identifiers, neither plot separates participant heterogeneity from residual trial variation.

## Slide 411: Changing conditional variance: question 1

Source note: `regression-models/heteroscedasticity.qmd`

Which ordinary regression assumption does heteroscedasticity violate?

## Slide 412: Changing conditional variance: answer 1

Source note: `regression-models/heteroscedasticity.qmd`

Heteroscedasticity violates the ordinary regression assumption that $\operatorname{Var}[Y_i\mid\mathbf x_i]=\sigma^2$ is constant across observations.

## Slide 413: Changing conditional variance: question 2

Source note: `regression-models/heteroscedasticity.qmd`

Why do robust standard errors leave fitted means unchanged?

## Slide 414: Changing conditional variance: answer 2

Source note: `regression-models/heteroscedasticity.qmd`

Robust standard errors replace the coefficient covariance estimate after OLS minimizes the same SSE, so the coefficients and fitted means remain unchanged.

## Slide 415: Changing conditional variance: question 3

Source note: `regression-models/heteroscedasticity.qmd`

What does `sd_log_rt` summarize?

## Slide 416: Changing conditional variance: answer 3

Source note: `regression-models/heteroscedasticity.qmd`

`sd_log_rt` summarizes the standard deviation of retained correct log response times within each MALD word item.

## Slide 417: Changing conditional variance: question 4

Source note: `regression-models/heteroscedasticity.qmd`

Which source of dependence remains unavailable?

## Slide 418: Changing conditional variance: answer 4

Source note: `regression-models/heteroscedasticity.qmd`

Participant-level dependence and participant heterogeneity remain unavailable because the item table omits participant identifiers. The next page models frequency-dependent scale directly.

## Slide 419: Modeling conditional scale

Source note: `regression-models/distributional-regression.qmd`

Next, we take up Modeling conditional scale.

## Slide 420: Modeling conditional scale

Source note: `regression-models/distributional-regression.qmd`

**Distributional regression** gives more than one response-distribution parameter a predictor equation. For MALD correct log response times, we use

$$
Y_{ij}\sim\mathcal N(\mu_i,\sigma_i^2),
$$

with

$$
\mu_i
=
\beta_0+\beta_fF_i^c+\beta_dD_i^c+\beta_pP_i^c
$$

and

$$
\log\sigma_i
=
\gamma_0+\gamma_fF_i^c.
$$

## Slide 421: Modeling conditional scale

Source note: `regression-models/distributional-regression.qmd`

The log link keeps every fitted standard deviation positive.

## Slide 422: A likelihood for grouped item summaries

Source note: `regression-models/distributional-regression.qmd`

For item $i$, the table retains only $n_i$, $\overline y_i$, and $s_i^2$. The identity.

$$
\sum_{j=1}^{n_i}(y_{ij}-\mu_i)^2
=
(n_i-1)s_i^2+n_i(\overline y_i-\mu_i)^2
$$

allows the Gaussian likelihood to be evaluated exactly from these sufficient summaries, conditional on the independence approximation.

## Slide 423: A likelihood for grouped item summaries

Source note: `regression-models/distributional-regression.qmd`

The frequency coefficient in the mean equation is -0.0157; the frequency coefficient in the log-scale equation is -0.0082. Thus greater observed frequency is associated with both a lower item mean and a lower fitted conditional spread in this grouped specification.

## Slide 424: A likelihood for grouped item summaries

Source note: `regression-models/distributional-regression.qmd`

Allowing frequency-dependent scale changes AIC from 842.81 to 730.91. This comparison uses the same grouped Gaussian likelihood and the same item summaries.

## Slide 425: A likelihood for grouped item summaries

Source note: `regression-models/distributional-regression.qmd`

This figure shows mALD item means and within-item standard deviations with fitted mean and scale relations at observed mean duration and phone count.

## Slide 426: A likelihood for grouped item summaries

Source note: `regression-models/distributional-regression.qmd`

This figure shows observed within-item log-RT standard deviations and the fitted frequency-dependent scale.

## Slide 427: A likelihood for grouped item summaries

Source note: `regression-models/distributional-regression.qmd`

The likelihood treats retained correct trials as conditionally independent. Because the summaries omit participant identifiers, the fitted scale may combine trial noise with participant heterogeneity and cannot recover participant effects. The model demonstrates separate mean and scale equations; it is not a replacement for the crossed analysis used in the MALD paper.

## Slide 428: Modeling conditional scale: question 1

Source note: `regression-models/distributional-regression.qmd`

Why is log used for the scale equation?

## Slide 429: Modeling conditional scale: answer 1

Source note: `regression-models/distributional-regression.qmd`

Modeling $\log\sigma_i$ allows an unconstrained linear predictor while ensuring $\sigma_i=\exp(\cdot)>0$.

## Slide 430: Modeling conditional scale: question 2

Source note: `regression-models/distributional-regression.qmd`

Which sufficient summaries enter the grouped likelihood?

## Slide 431: Modeling conditional scale: answer 2

Source note: `regression-models/distributional-regression.qmd`

Each item's retained-trial count $n_i$, mean $\overline y_i$, and variance $s_i^2$ enter the grouped Gaussian likelihood.

## Slide 432: Modeling conditional scale: question 3

Source note: `regression-models/distributional-regression.qmd`

What does the scale-frequency coefficient describe?

## Slide 433: Modeling conditional scale: answer 3

Source note: `regression-models/distributional-regression.qmd`

The scale-frequency coefficient describes the change in fitted log conditional standard deviation for a one-unit increase in centered log frequency, holding the scale model's other terms fixed.

## Slide 434: Modeling conditional scale: question 4

Source note: `regression-models/distributional-regression.qmd`

Why can the model not separate participant heterogeneity from trial variation?

## Slide 435: Modeling conditional scale: answer 4

Source note: `regression-models/distributional-regression.qmd`

Only grouped item summaries remain, so the fitted scale combines trial noise and participant heterogeneity without identifiers that could separate them. The next module turns from fitting equations to prediction targets and model criticism.
