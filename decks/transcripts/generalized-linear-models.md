# Generalized linear models

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Generalized linear models

Source note: `regression-models/why-generalized-linear-models.qmd`

Welcome to Generalized linear models. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: When ordinary linear regression cannot model the response

Source note: `regression-models/why-generalized-linear-models.qmd`

Now we turn to When ordinary linear regression cannot model the response.

## Slide 3: SuperTelicity: the empirical object

Source note: `regression-models/why-generalized-linear-models.qmd`

The data source is SuperTelicity cloze release. It provides participant-by-item cloze choices for aspectual inference.

## Slide 4: When ordinary linear regression cannot model the response

Source note: `regression-models/why-generalized-linear-models.qmd`

Ordinary linear regression lets a conditional mean range over the real line and treats residual variance as constant. A binary linguistic response violates both commitments. We can see the problem in the **SuperTelicity cloze data** of White, Cao, Grimm, and Glass's working manuscript, *The preservation of telicity under sense locality* (n.d.). The credential-gated source repository is pinned at commit `e45277ce466719c1a03629f6ccf1e12db9904421`; the immutable CC BY-SA teaching table makes the analyzed data public with sentence text removed. Each row records one participant's choice of *in* or *for* after an event description. It is not an independent participant-level summary.

## Slide 5: When ordinary linear regression cannot model the response

Source note: `regression-models/why-generalized-linear-models.qmd`

The duration comparison uses only rows with a selected temporal magnitude. Thus it describes 5380 of the 9160 cloze choices; missing durations keep it from representing the full experiment.

## Slide 6: The support problem in observed data

Source note: `regression-models/why-generalized-linear-models.qmd`

For $Y_i=1$ when participant $i$ chooses *in* and $Y_i=0$ otherwise,

$$
\mathbb{E}[Y_i\mid\mathbf x_i]=\mathbb{P}(Y_i=1\mid\mathbf x_i)=\pi_i,
\qquad
\operatorname{Var}[Y_i\mid\mathbf x_i]=\pi_i(1-\pi_i).
$$

## Slide 7: The support problem in observed data

Source note: `regression-models/why-generalized-linear-models.qmd`

A linear probability model, $\pi_i=\mathbf x_i^\mathsf T\boldsymbol\beta$, does not constrain $\pi_i$ to $[0,1]$. A logit model instead sets $\operatorname{logit}(\pi_i)=\mathbf x_i^\mathsf T\boldsymbol\beta$.

## Slide 8: The support problem in observed data

Source note: `regression-models/why-generalized-linear-models.qmd`

This figure shows observed linguistic data for The support problem in observed data.

## Slide 9: The support problem in observed data

Source note: `regression-models/why-generalized-linear-models.qmd`

Points are observed bin proportions; grey lines are linear-probability fits; blue lines are logistic fits. The fitted linear means range from -0.349 to 1.083, leaving the probability scale. The logistic curves remain inside it.

## Slide 10: The support problem in observed data

Source note: `regression-models/why-generalized-linear-models.qmd`

This is also a variance problem: Bernoulli variance is determined by the mean, rather than by one constant residual variance. A generalized linear model repairs both pieces by choosing a response family with the right support and a link that constrains the mean. These population fits expose that architecture; they do not reproduce the manuscript's Bayesian mixed model or account for repeated participants and sentences.

## Slide 11: Link functions

Source note: `regression-models/link-functions.qmd`

The next topic is Link functions.

## Slide 12: Link functions

Source note: `regression-models/link-functions.qmd`

A **link function** maps a constrained conditional mean to the real-valued linear predictor. We continue with SuperTelicity, where the response is an *in* choice and the first-use source and design are introduced on the preceding page.

## Slide 13: Link functions

Source note: `regression-models/link-functions.qmd`

For a Bernoulli mean $0<\pi_i<1$, the logit link and its inverse are

$$
g(\pi_i)=\log\frac{\pi_i}{1-\pi_i}=\eta_i,
\qquad
g^{-1}(\eta_i)=\frac{1}{1+e^{-\eta_i}}=\pi_i.
$$

## Slide 14: Link functions

Source note: `regression-models/link-functions.qmd`

The link acts on the conditional mean, not on the observed zeros and ones. The fitted SuperTelicity model supplies actual values on both scales.

## Slide 15: Link functions

Source note: `regression-models/link-functions.qmd`

`qlogis()` maps the empirical group probabilities to real numbers, and `plogis()` returns them to the probability scale. These functions implement the equations above without transforming any response row.

## Slide 16: The inverse link keeps predictions valid

Source note: `regression-models/link-functions.qmd`

This figure shows observed linguistic data for The inverse link keeps predictions valid.

## Slide 17: The inverse link keeps predictions valid

Source note: `regression-models/link-functions.qmd`

The model is additive in $\eta_i$ but curved in $\pi_i$. A constant coefficient is a constant change in log odds, not in probability. The link changes neither the Bernoulli support nor the observed response. It connects the linear predictor to the family mean.

## Slide 18: The inverse link keeps predictions valid

Source note: `regression-models/link-functions.qmd`

For count means the analogous construction uses $\log\lambda_i=\eta_i$ and $\lambda_i=e^{\eta_i}>0$. Thus the choice of link follows the support of the conditional mean. It is not a device for making a histogram look normal.

## Slide 19: Generalized linear models

Source note: `regression-models/generalized-linear-models.qmd`

Next, we take up Generalized linear models.

## Slide 20: Generalized linear models

Source note: `regression-models/generalized-linear-models.qmd`

A **generalized linear model (GLM)** has three distinct parts: (i) a response distribution, (ii) a linear predictor, and (iii) a link between the distribution's conditional mean and that predictor. The SuperTelicity *in* versus *for* response makes each part observable.

## Slide 21: Generalized linear models

Source note: `regression-models/generalized-linear-models.qmd`

The response component is $Y_i\mid\pi_i\sim\operatorname{Bernoulli}(\pi_i)$, the systematic component is

$$
\eta_i=\beta_0+\beta_1\operatorname{result}_i,
$$

and the link gives

$$
\log\frac{\pi_i}{1-\pi_i}=\eta_i,
\qquad
\pi_i=\frac{1}{1+\exp[-(\beta_0+\beta_1\operatorname{result}_i)]}.
$$

## Slide 22: Generalized linear models

Source note: `regression-models/generalized-linear-models.qmd`

This figure shows observed linguistic data for Overview.

## Slide 23: Generalized linear models

Source note: `regression-models/generalized-linear-models.qmd`

The fitted values coincide with the two raw group proportions because a two-parameter model is saturated for two group means. This agreement does not erase the row structure: the likelihood is built from 9160 binary choices contributed by repeated participants and sentences.

## Slide 24: Generalized linear models

Source note: `regression-models/generalized-linear-models.qmd`

The population GLM is useful for exposing the machinery. It is not the SuperTelicity paper's inferential model, which includes supported participant and item dependence. Thus the model describes the observed population contrast but does not authorize participant-independent standard errors or a causal interpretation of verb type.

## Slide 25: The exponential family

Source note: `regression-models/exponential-family.qmd`

Next, we take up The exponential family.

## Slide 26: The exponential family

Source note: `regression-models/exponential-family.qmd`

Many GLM response distributions share the **exponential-family form**. For a discrete member, write the PMF as

$$
p(y\mid\theta,\phi)=\exp\left\{\frac{y\theta-b(\theta)}{a(\phi)}+c(y,\phi)\right\}.
$$

## Slide 27: The exponential family

Source note: `regression-models/exponential-family.qmd`

For an absolutely continuous member, the same form is written as a PDF (f(y\mid\theta,\phi)). We use (p) only for the discrete Bernoulli member below.

## Slide 28: The exponential family

Source note: `regression-models/exponential-family.qmd`

Here $\theta$ is the canonical parameter, $b(\theta)$ determines the mean and variance, and $\phi$ supplies dispersion when the family has one. To make those roles concrete, we derive the Bernoulli member from the observed SuperTelicity choices.

## Slide 29: The exponential family

Source note: `regression-models/exponential-family.qmd`

For $y_i\in\{0,1\}$,

$$
p(y_i\mid\pi_i)=\pi_i^{y_i}(1-\pi_i)^{1-y_i}.
$$

## Slide 30: The exponential family

Source note: `regression-models/exponential-family.qmd`

Set $\theta_i=\log[\pi_i/(1-\pi_i)]$. Because $\pi_i=e^{\theta_i}/(1+e^{\theta_i})$,

$$
\log p(y_i\mid\theta_i)=y_i\theta_i-\log(1+e^{\theta_i}).
$$

## Slide 31: The exponential family

Source note: `regression-models/exponential-family.qmd`

Thus $b(\theta)=\log(1+e^\theta)$ and $a(\phi)=1$. Differentiating $b$ recovers $b'(\theta)=\pi$ and $b''(\theta)=\pi(1-\pi)$.

## Slide 32: The exponential family

Source note: `regression-models/exponential-family.qmd`

The shared form links distributions to GLM computation, but it does not make the families interchangeable. Bernoulli, Poisson, and normal models retain different supports and mean-variance relations. The exponential-family notation organizes those distinctions; it does not remove them.

## Slide 33: Sufficient statistics

Source note: `regression-models/sufficient-statistics.qmd`

The next topic is Sufficient statistics.

## Slide 34: Sufficient statistics

Source note: `regression-models/sufficient-statistics.qmd`

A statistic is **sufficient** for a parameter when, under the stated model, it retains all sample information about that parameter. For an intercept-only Bernoulli model of the SuperTelicity choices, the sufficient information is the row count and number of *in* responses.

## Slide 35: Sufficient statistics

Source note: `regression-models/sufficient-statistics.qmd`

The joint likelihood is

$$
L(\pi;\mathbf y)=\prod_{i=1}^{n}\pi^{y_i}(1-\pi)^{1-y_i}
=\pi^{\sum_i y_i}(1-\pi)^{n-\sum_i y_i}.
$$

## Slide 36: Sufficient statistics

Source note: `regression-models/sufficient-statistics.qmd`

For these data, R computes $n={}$ 9160 and $\sum_i y_i={}$ 4876. Every arrangement of those responses has the same likelihood for the intercept-only $\pi$.

## Slide 37: Sufficient statistics

Source note: `regression-models/sufficient-statistics.qmd`

The combinatorial term in the binomial mass does not involve $\pi$; removing it gives the same parameter-dependent log likelihood as the row product.

## Slide 38: Sufficient statistics

Source note: `regression-models/sufficient-statistics.qmd`

This compression is model-specific. Once verb type, contentfulness, participant, or sentence enters the model, the allocation of responses across those units matters. Sufficiency for one intercept thus does not license deleting participant and sentence identifiers. It states exactly what the intercept-only Bernoulli likelihood uses and no more.

## Slide 39: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

Now we turn to Iteratively reweighted least squares.

## Slide 40: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

Logistic regression has no ordinary least-squares solution because the inverse logit makes the likelihood nonlinear in the coefficients. **Iteratively reweighted least squares (IRLS)** solves a sequence of local weighted least-squares problems. We can follow that sequence for the SuperTelicity verb-type model.

## Slide 41: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

At iteration $t$, let

$$
\boldsymbol\eta^{(t)}=\mathbf X\boldsymbol\beta^{(t)},\quad
\boldsymbol\mu^{(t)}=\operatorname{logit}^{-1}(\boldsymbol\eta^{(t)}),
$$

$$
w_i^{(t)}=\mu_i^{(t)}[1-\mu_i^{(t)}],\quad
z_i^{(t)}=\eta_i^{(t)}+\frac{y_i-\mu_i^{(t)}}{w_i^{(t)}}.
$$

## Slide 42: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

The update is

$$
\boldsymbol\beta^{(t+1)}=(\mathbf X^\mathsf T\mathbf W^{(t)}\mathbf X)^{-1}
\mathbf X^\mathsf T\mathbf W^{(t)}\mathbf z^{(t)}.
$$

## Slide 43: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

This figure shows observed linguistic data for Overview.

## Slide 44: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

The plotted path records successive local weighted-least-squares solutions. The working response $\mathbf z$ is algorithmic, whereas the observed response remains the original vector of *in* and *for* choices; the final coefficients agree with `glm()` to the asserted tolerance. Thus IRLS is local least squares, not a claim that the Bernoulli data have become Gaussian.

## Slide 45: Deviance

Source note: `regression-models/deviance.qmd`

Next, we take up Deviance.

## Slide 46: Deviance

Source note: `regression-models/deviance.qmd`

**Deviance** measures how far a fitted likelihood is from the saturated model, which assigns one fitted mean to each observation. If $\ell(\widehat\theta)$ is the fitted log likelihood and $\ell_{\mathrm{sat}}$ is the saturated log likelihood,

$$
D=2\{\ell_{\mathrm{sat}}-\ell(\widehat\theta)\}.
$$

## Slide 47: Deviance

Source note: `regression-models/deviance.qmd`

For Bernoulli rows, the saturated contribution is zero, so residual deviance is $-2\ell(\widehat\theta)$. We compare four population models for the same SuperTelicity rows.

## Slide 48: Deviance

Source note: `regression-models/deviance.qmd`

This figure shows observed linguistic data for Overview.

## Slide 49: Deviance

Source note: `regression-models/deviance.qmd`

For nested models fit to identical rows with the same family, the deviance difference is

$$
\Delta D=2\{\ell(\widehat\theta_{\mathrm{larger}})-
\ell(\widehat\theta_{\mathrm{smaller}})\}.
$$

## Slide 50: Deviance

Source note: `regression-models/deviance.qmd`

It is a likelihood-ratio statistic under the usual regularity conditions. The sequence shows how much each added structure improves row-level fit. It does not correct repeated participant and sentence dependence, and comparisons across different response families or different row sets generally do not have this interpretation.

## Slide 51: Odds and log odds

Source note: `regression-models/odds-and-log-odds.qmd`

The next topic is Odds and log odds.

## Slide 52: Odds and log odds

Source note: `regression-models/odds-and-log-odds.qmd`

For a probability $p$, the **odds** and **log odds** are

$$
\operatorname{odds}(p)=\frac{p}{1-p},
\qquad
\operatorname{logit}(p)=\log\frac{p}{1-p}.
$$

## Slide 53: Odds and log odds

Source note: `regression-models/odds-and-log-odds.qmd`

Their interpretation is easiest to anchor in the observed SuperTelicity group probabilities.

## Slide 54: Odds and log odds

Source note: `regression-models/odds-and-log-odds.qmd`

The probability ratio and odds ratio are different quantities.

## Slide 55: Odds and log odds

Source note: `regression-models/odds-and-log-odds.qmd`

The result-to-manner empirical odds ratio is 4.674. This says that the odds of an *in* completion are multiplied by that amount; it does not say that the probability is multiplied by the same amount.

## Slide 56: Odds and log odds

Source note: `regression-models/odds-and-log-odds.qmd`

This figure shows observed linguistic data for Overview.

## Slide 57: Odds and log odds

Source note: `regression-models/odds-and-log-odds.qmd`

Log odds are unbounded and additive, which is why logistic regression uses them. Probabilities remain the scale for substantive interpretation. The PS3 page applies this distinction to fitted contrasts.

## Slide 58: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

Next, we take up Logistic regression.

## Slide 59: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

Logistic regression combines a Bernoulli response with the logit link. For the SuperTelicity verb-type contrast,

$$
Y_i\sim\operatorname{Bernoulli}(\pi_i),
\qquad
\log\frac{\pi_i}{1-\pi_i}=\beta_0+\beta_1\operatorname{result}_i.
$$

## Slide 60: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

The intercept is the manner-verb log odds. The result coefficient is the result-minus-manner log odds difference, so

$$
e^{\beta_1}
=\frac{\pi_{\mathrm{result}}/(1-\pi_{\mathrm{result}})}
        {\pi_{\mathrm{manner}}/(1-\pi_{\mathrm{manner}})}.
$$

## Slide 61: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

The fitted coefficient is 1.542 and its exponential is 4.674. The latter is an odds ratio, not a probability ratio.

## Slide 62: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

This figure shows observed linguistic data for Overview.

## Slide 63: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

The two fitted probabilities equal the two observed proportions because this model has one parameter for each group mean. In richer models, interpret coefficients with response-scale predictions because the same log-odds change produces different probability changes at different baselines.

## Slide 64: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

This population model remains a teaching simplification. The SuperTelicity analysis uses a Bayesian logistic mixed model; repeated participants and sentences make the row-independent standard errors here unsuitable for confirmatory inference.

## Slide 65: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

Next, we take up A logistic-regression analysis.

## Slide 66: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

We now carry the SuperTelicity one-predictor analysis from raw counts to fitted probabilities. The scientific question is descriptive: how does *in* completion use differ between manner and result verbs in this sample?

## Slide 67: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

The fit reproduces the higher sample probability for result verbs, and the plot places that raw contrast beside the row-independent GLM intervals. On the link scale, the likelihood is

$$
\ell(\boldsymbol\beta)=\sum_i\left[y_i\eta_i-
\log(1+e^{\eta_i})\right],
\qquad \eta_i=\beta_0+\beta_1\operatorname{result}_i.
$$

## Slide 68: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

This figure shows observed linguistic data for Overview.

## Slide 69: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

Maximizing it yields the coefficient estimates printed below.

## Slide 70: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

The intervals shown are the row-independent GLM intervals and are included to expose the mechanics. They are not the inferential result of the source paper. The rows reuse participants and sentence materials, and the original analysis models that dependence. Nor does the observed contrast show that verb type causes a completion choice.

## Slide 71: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

Now we turn to Logistic regression with multiple predictors.

## Slide 72: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

Multiple-predictor logistic regression can represent whether the SuperTelicity verb-type contrast changes across contentfulness classes. The additive model states one common verb-type log odds difference; the interaction model allows it to vary.

## Slide 73: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

The additive linear predictor is

$$
\eta_i=\beta_0+\beta_1\operatorname{result}_i+
\beta_2\operatorname{bleached}_i+
\beta_3\operatorname{templatic}_i.
$$

## Slide 74: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

The interaction model adds products between verb type and the contentfulness indicators. Those product coefficients are differences between log odds differences, not raw probability differences.

## Slide 75: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

The six points below are raw cell probabilities, whereas the lines are interaction-model predictions on the same scale. The likelihood-ratio calculation then compares that interaction with the additive restriction.

## Slide 76: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

This figure shows observed linguistic data for Overview.

## Slide 77: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

A partial coefficient is meaningful only because the observed design supplies overlap among the represented cells. This population model still omits participant and sentence dependence and does not replace the paper's mixed analysis. The PS3 page asks students to interpret related fitted contrasts.

## Slide 78: Deviance residuals

Source note: `regression-models/deviance-residuals.qmd`

Now we turn to Deviance residuals.

## Slide 79: Deviance residuals

Source note: `regression-models/deviance-residuals.qmd`

A deviance residual assigns each observation a signed share of model deviance. For Bernoulli logistic regression,

$$
r_i^{D}=\operatorname{sign}(y_i-\widehat\pi_i)
\sqrt{2\left[y_i\log\frac{y_i}{\widehat\pi_i}+
(1-y_i)\log\frac{1-y_i}{1-\widehat\pi_i}\right]},
$$

with zero-times-log-zero terms defined as zero.

## Slide 80: Deviance residuals

Source note: `regression-models/deviance-residuals.qmd`

We compute these residuals from the SuperTelicity interaction fit.

## Slide 81: Deviance residuals

Source note: `regression-models/deviance-residuals.qmd`

The squared residuals sum to the model deviance. Binary row residuals are necessarily discrete-looking because each row contains only zero or one. Aggregating by verb is useful for calibration display, though the aggregation is not the likelihood that was fit.

## Slide 82: Deviance residuals

Source note: `regression-models/deviance-residuals.qmd`

This figure shows observed linguistic data for Overview.

## Slide 83: Deviance residuals

Source note: `regression-models/deviance-residuals.qmd`

Large gaps identify verbs for inspection, not automatically erroneous observations. They may indicate omitted lexical structure, dependence, or a mean specification that is too coarse. Because verbs, sentences, and participants recur, residual patterns should motivate a richer model rather than deletion based on a fixed threshold.

## Slide 84: Ordinal regression

Source note: `regression-models/ordinal-regression.qmd`

Now we turn to Ordinal regression.

## Slide 85: MegaVeridicality: the empirical object

Source note: `regression-models/ordinal-regression.qmd`

The data source is White and Rawlins (2018), MegaVeridicality. It provides ordinal inference judgments crossed with verb and respondent.

## Slide 86: Ordinal regression

Source note: `regression-models/ordinal-regression.qmd`

An ordinal response has ordered categories but no defensible numerical spacing. We use **MegaVeridicality v1**, the *no*-*maybe*-*yes* veridicality judgments described by White and Rawlins (2018 paper; CC BY-SA project release). Each row is one judgment for a verb, polarity, task, item, and task-specific respondent. The direct and conditional tasks recruited separate samples; the task prefix on `respondent_id` prevents 29 reused numeric labels from becoming false repeated measurements.

## Slide 87: Cumulative logits

Source note: `regression-models/ordinal-regression.qmd`

For ordered cutpoints $\kappa_1<\kappa_2$ and linear predictor $\eta_i$,

$$
\operatorname{logit}\mathbb{P}(Y_i\leq c)=\kappa_c-\eta_i,
\qquad c\in\{1,2\}.
$$

With the logistic CDF $F$, the category probabilities are

$$
\mathbb{P}(Y_i=\text{no})=F(\kappa_1-\eta_i),
$$

$$
\mathbb{P}(Y_i=\text{maybe})=F(\kappa_2-\eta_i)-F(\kappa_1-\eta_i),
$$

$$
\mathbb{P}(Y_i=\text{yes})=1-F(\kappa_2-\eta_i).
$$

## Slide 88: Cumulative logits

Source note: `regression-models/ordinal-regression.qmd`

The model preserves order without assigning equal distances to the labels.

## Slide 89: Interpreting one coefficient at both boundaries

Source note: `regression-models/ordinal-regression.qmd`

A positive coefficient increases the linear predictor and shifts probability toward higher responses. Under proportional odds, the same coefficient applies to *maybe* or *yes* versus *no* and to *yes* versus *no* or *maybe*. It does not imply an equal change in each category probability, which is why the complete fitted distribution remains the primary interpretation.

## Slide 90: Interpreting one coefficient at both boundaries

Source note: `regression-models/ordinal-regression.qmd`

This figure shows observed linguistic data for Interpreting one coefficient at both boundaries.

## Slide 91: Checking the shared-shift restriction

Source note: `regression-models/ordinal-regression.qmd`

The proportional-odds model requires the same predictor shift at both boundaries. Two binary regressions expose how strained that restriction is here.

## Slide 92: Checking the shared-shift restriction

Source note: `regression-models/ordinal-regression.qmd`

The negative-polarity and polarity-by-task coefficients differ across boundaries, so one shared location shift is a useful baseline but an imperfect description. The fit is a population teaching model, not the paper's responsivity analysis and not a latent verb classification. It also omits respondent and verb dependence, which the later ordinal mixed-model page addresses.

## Slide 93: Poisson regression

Source note: `regression-models/poisson-regression.qmd`

Now we turn to Poisson regression.

## Slide 94: Nettle: the empirical object

Source note: `regression-models/poisson-regression.qmd`

The data source is Nettle (1999) teaching extract. It provides language-level population and climate counts.

## Slide 95: Poisson regression

Source note: `regression-models/poisson-regression.qmd`

Poisson regression models a nonnegative count with a positive conditional mean. We use Nettle's (1998) country-level study of language diversity and climate. One row is one country; the response is its reported language count, mean growing season (MGS) is the ecological predictor, and area measures geographic opportunity. The teaching table comes from Bodo Winter's course-data repository. That repository states no data license, so these notes do not redistribute it.

## Slide 96: Poisson regression

Source note: `regression-models/poisson-regression.qmd`

The model is

$$
Y_i\sim\operatorname{Poisson}(\lambda_i),\qquad
\mathbb{E}[Y_i]=\operatorname{Var}[Y_i]=\lambda_i,
$$

$$
\log\lambda_i=\log A_i+\beta_0+\beta_1\operatorname{MGS}_i.
$$

## Slide 97: Poisson regression

Source note: `regression-models/poisson-regression.qmd`

Thus $\lambda_i/A_i=\exp(\beta_0+\beta_1\operatorname{MGS}_i)$ is the fitted language rate per square kilometer.

## Slide 98: Poisson regression

Source note: `regression-models/poisson-regression.qmd`

This figure shows observed linguistic data for Overview.

## Slide 99: Poisson regression

Source note: `regression-models/poisson-regression.qmd`

A one-month increase in MGS multiplies the fitted rate by 1.284, conditional on the teaching specification. Nettle instead estimated the log-area coefficient. Fixing it to one narrows the question and does not reproduce the paper or support a causal ecological claim.

## Slide 100: Exposure offsets

Source note: `regression-models/exposure-offsets.qmd`

The next topic is Exposure offsets.

## Slide 101: Exposure offsets

Source note: `regression-models/exposure-offsets.qmd`

A count is inseparable from its opportunity window. For Nettle's country data, area is a proposed exposure: larger countries provide more geographic space in which languages are counted. An **offset** fixes the exposure coefficient rather than estimating it.

## Slide 102: Exposure offsets

Source note: `regression-models/exposure-offsets.qmd`

If $A_i$ is area and $r_i$ is the expected language rate per unit area, then

$$
\lambda_i=A_i r_i,
$$

so

$$
\log\lambda_i=\log A_i+\log r_i
=\log A_i+\beta_0+\beta_1\operatorname{MGS}_i.
$$

## Slide 103: Exposure offsets

Source note: `regression-models/exposure-offsets.qmd`

The offset is $\log A_i$ with coefficient fixed at one.

## Slide 104: Exposure offsets

Source note: `regression-models/exposure-offsets.qmd`

This figure shows observed linguistic data for Overview.

## Slide 105: Exposure offsets

Source note: `regression-models/exposure-offsets.qmd`

The source `Area` column is base-10 logarithmic. A Poisson log link uses natural logarithms, hence the explicit conversion $\log A_i=\log(10)\log_{10}A_i$. Treating area as exposure assumes proportionality between expected count and area. Nettle's paper estimates the area coefficient, so this fixed-one version is a teaching model rather than a reproduced analysis.

## Slide 106: A Poisson-regression analysis

Source note: `regression-models/poisson-regression-example.qmd`

Our next step is A Poisson-regression analysis.

## Slide 107: A Poisson-regression analysis

Source note: `regression-models/poisson-regression-example.qmd`

The Nettle language-rate model makes the log-base requirement visible: the primary fit uses natural-log area as a fixed exposure offset, while the diagnostic inserts the source's base-10 column directly. Because the upstream course repository states no license, the fallback below downloads and verifies the exact source.

## Slide 108: A Poisson-regression analysis

Source note: `regression-models/poisson-regression-example.qmd`

The mismatch changes the coefficient because it no longer encodes $\lambda_i=A_i r_i$ with an exposure coefficient of one.

## Slide 109: A Poisson-regression analysis

Source note: `regression-models/poisson-regression-example.qmd`

This figure shows observed linguistic data for Overview.

## Slide 110: A Poisson-regression analysis

Source note: `regression-models/poisson-regression-example.qmd`

The fitted positive association answers a conditional, descriptive question under a fixed-area-exposure assumption. Countries are not experimental units assigned to climates; area is not literally observation time; and Nettle's original specification estimated its coefficient. None of these fits supports a causal ecological claim.

## Slide 111: Count overdispersion

Source note: `regression-models/count-overdispersion.qmd`

Now we turn to Count overdispersion.

## Slide 112: Count overdispersion

Source note: `regression-models/count-overdispersion.qmd`

Poisson regression requires conditional mean and variance to be equal. **Overdispersion** occurs when the remaining variation is larger than that requirement permits. We diagnose it in the Nettle teaching model with Pearson residuals.

## Slide 113: Count overdispersion

Source note: `regression-models/count-overdispersion.qmd`

The estimator is

$$
\widehat\phi=\frac{1}{n-p}\sum_i
\frac{(y_i-\widehat\lambda_i)^2}{\widehat\lambda_i}.
$$

## Slide 114: Count overdispersion

Source note: `regression-models/count-overdispersion.qmd`

A Poisson model expects a value near one. The observed value is 207.99, so the conditional variance restriction fails badly for this specification.

## Slide 115: Count overdispersion

Source note: `regression-models/count-overdispersion.qmd`

This figure shows observed linguistic data for Overview.

## Slide 116: Count overdispersion

Source note: `regression-models/count-overdispersion.qmd`

Overdispersion may arise from omitted heterogeneity, dependence, an inadequate mean formula, or a different count distribution. It is a diagnosis, not a mechanism. The next page changes the variance used for uncertainty while retaining the fitted mean.

## Slide 117: Quasi-Poisson regression

Source note: `regression-models/quasi-poisson.qmd`

Next, we take up Quasi-Poisson regression.

## Slide 118: Quasi-Poisson regression

Source note: `regression-models/quasi-poisson.qmd`

Quasi-Poisson regression keeps the Poisson mean function but allows

$$
\operatorname{Var}[Y_i\mid\mathbf x_i]=\phi\mu_i.
$$

## Slide 119: Quasi-Poisson regression

Source note: `regression-models/quasi-poisson.qmd`

It thus changes uncertainty, not fitted means. The Nettle data show the distinction directly.

## Slide 120: Quasi-Poisson regression

Source note: `regression-models/quasi-poisson.qmd`

The MGS coefficient and every fitted rate are identical, while the standard error expands from 0.005 to 0.0726. The estimated dispersion is 207.99.

## Slide 121: Quasi-Poisson regression

Source note: `regression-models/quasi-poisson.qmd`

This figure shows observed linguistic data for Overview.

## Slide 122: Quasi-Poisson regression

Source note: `regression-models/quasi-poisson.qmd`

Quasi-likelihood does not define a complete probability mass function, so ordinary likelihood comparisons such as AIC are unavailable. It repairs the variance used for standard errors, not omitted structure, country dependence, or the exposure assumption.

## Slide 123: Zeros in count data

Source note: `regression-models/zero-inflated-counts.qmd`

Next, we take up Zeros in count data.

## Slide 124: Storme: the empirical object

Source note: `regression-models/zero-inflated-counts.qmd`

The data source is Storme (2024). It provides French liaison counts with repeated lexical contexts.

## Slide 125: Zeros in count data

Source note: `regression-models/zero-inflated-counts.qmd`

More observed zeros than a Poisson model predicts do not by themselves establish a separate zero-generating process. We examine this ambiguity in Storme's (2024) French liaison study and its Zenodo release. One prepared row is a final-morpheme, final-consonant, and liaison-status combination. Following the released code, the response is integer truncation of 100 times summed `freqfilms2`, not a direct token tally. The Zenodo record states no separate data license, so these notes do not redistribute it.

## Slide 126: Zeros in count data

Source note: `regression-models/zero-inflated-counts.qmd`

We fit additive Poisson and negative-binomial baselines with the same mean formula. The negative binomial allows

$$
\operatorname{Var}[Y_i\mid\mu_i]=\mu_i+\frac{\mu_i^2}{\theta},
$$

so ordinary heterogeneity can increase both tails, including zero mass.

## Slide 127: Zeros in count data

Source note: `regression-models/zero-inflated-counts.qmd`

This figure shows observed linguistic data for Overview.

## Slide 128: Zeros in count data

Source note: `regression-models/zero-inflated-counts.qmd`

The Poisson model assigns almost no zero mass, while the negative binomial moves toward the observed proportions without a structural-zero component. We thus do not fit a zero-inflated model here. Such a model requires a linguistically motivated process that makes some morpheme cells deterministically absent, not merely a conspicuous zero bar.

## Slide 129: Negative-binomial regression

Source note: `regression-models/negative-binomial-regression.qmd`

Our next step is Negative-binomial regression.

## Slide 130: Negative-binomial regression

Source note: `regression-models/negative-binomial-regression.qmd`

The negative-binomial distribution relaxes the Poisson mean-variance equality while retaining nonnegative integer support. We continue with Storme's French liaison counts and use the paper-aligned liaison-by-final-consonant interaction.

## Slide 131: Negative-binomial regression

Source note: `regression-models/negative-binomial-regression.qmd`

With mean $\mu_i$ and size $\theta$,

$$
\mathbb{E}[Y_i]=\mu_i,
\qquad
\operatorname{Var}[Y_i]=\mu_i+\frac{\mu_i^2}{\theta}.
$$

## Slide 132: Negative-binomial regression

Source note: `regression-models/negative-binomial-regression.qmd`

The log link keeps $\mu_i$ positive. The additive model's liaison coefficient is a common-ratio restriction: Storme's analysis includes the interaction, so a single common liaison ratio is not the paper-aligned result.

## Slide 133: Negative-binomial regression

Source note: `regression-models/negative-binomial-regression.qmd`

This figure shows observed linguistic data for Overview.

## Slide 134: Negative-binomial regression

Source note: `regression-models/negative-binomial-regression.qmd`

Liaison cells have higher fitted means for each represented consonant, but the ratios are strongly consonant-specific. The response is reconstructed from frequency values, and lexical rows may remain dependent. Thus this population fit illustrates the paper's formula without reproducing its Bayesian uncertainty or establishing an independent causal liaison effect.

## Slide 135: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

Our next step is Bounded responses.

## Slide 136: MegaNegRaising: the empirical object

Source note: `regression-models/bounded-responses.qmd`

The data source is An and White (2020), MegaNegRaising. It provides bounded acceptability responses for neg-raising configurations.

## Slide 137: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

A slider response on $[0,1]$ is bounded, can use exact endpoints, and may have a nonconstant variance. We use the public **MegaNegRaising** release described by An and White (2020 paper; CC BY-SA data and documentation). The archive filename says v1, while its internal README identifies v1.1, released 2020-08-29.

## Slide 138: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

Each raw row contains paired judgments: how likely matrix negation conveys embedded negation and how easy it is to imagine someone uttering the matrix-negated sentence. An and White call the ease response acceptability while noting the simplification. We use the prespecified balanced teaching subset: native-American-English responses to past-tense active and passive eventive infinitivals, first- and third-person subjects, and the verbs present in all four cells.

## Slide 139: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

An ordinary Gaussian model assigns positive probability outside the response support. We fit the neg-raising benchmark with participant and verb intercepts, then calculate that illegal probability from its fitted population means and residual standard deviation.

## Slide 140: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

This figure shows observed linguistic data for Overview.

## Slide 141: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

The Gaussian benchmark assigns 4.38% of its predictive mass outside $[0,1]$. The endpoint bars are genuine data, not rounding errors.

## Slide 142: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

The source paper uses the ease response to weight a KL loss in a latent lexical-and-structural model with participant-specific scale and shift terms. Our subset remains acceptability-selected upstream, but we never filter individual trials by ease. The benchmark is thus diagnostic, not a reproduction of that analysis.

## Slide 143: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

Now we turn to Why ordinary beta regression does not fit endpoint sliders.

## Slide 144: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

The beta density has support $0<y<1$. MegaNegRaising contains exact zeros and ones on both recorded sliders, so ordinary beta regression assigns those observations zero probability.

## Slide 145: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

For $0<y<1$, a mean-precision beta parameterization is

$$
Y_i\sim\operatorname{Beta}(\mu_i\phi,(1-\mu_i)\phi),
$$

with

$$
\mathbb{E}[Y_i]=\mu_i,
\qquad
\operatorname{Var}[Y_i]=\frac{\mu_i(1-\mu_i)}{1+\phi}.
$$

## Slide 146: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

Neither density value at an endpoint is a probability mass. A common workaround nudges every observation with

$$
y_i^*=\frac{y_i(n-1)+1/2}{n}.
$$

## Slide 147: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

The consequence is data-dependent and should be computed, not illustrated with chosen values.

## Slide 148: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

This figure shows observed linguistic data for Overview.

## Slide 149: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

For the 7651 retained judgments, zero becomes 6.53509e-05 and one becomes 0.999935. The transformation makes the sample size part of the measurement model: adding unrelated rows moves the transformed endpoints. It also replaces observed endpoint events with extremely interior values.

## Slide 150: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

A likelihood that contains explicit endpoint probabilities is more faithful to the recorded response. The next page uses ordered-beta regression for both sliders without changing or filtering either outcome.

## Slide 151: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

Our next step is Ordered-beta regression.

## Slide 152: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

**Ordered-beta regression** represents three observable regions: $Y_i=0$, $0<Y_i<1$, and $Y_i=1$. We fit the same population formula to both MegaNegRaising sliders, as prespecified in the dataset audit.

## Slide 153: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

For ordered cutpoints $\kappa_0<\kappa_1$ and $\eta_i=\mathbf x_i^\mathsf T\boldsymbol\beta$,

$$
\mathbb{P}(Y_i=0)=F(\kappa_0-\eta_i),
$$

$$
\mathbb{P}(0<Y_i<1)=F(\kappa_1-\eta_i)-F(\kappa_0-\eta_i),
$$

$$
\mathbb{P}(Y_i=1)=1-F(\kappa_1-\eta_i).
$$

## Slide 154: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

Conditional on the interior,

$$
Y_i\sim\operatorname{Beta}(\mu_i\phi,(1-\mu_i)\phi),
\qquad \mu_i=F(\eta_i).
$$

## Slide 155: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

The visible likelihood below constrains the cutpoint gap and precision to be positive.

## Slide 156: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

This figure shows observed linguistic data for Overview.

## Slide 157: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

The fitted passive coefficient is -0.095, a shift on the ordered location scale. Interpretation belongs in the full predictive distribution above, not in that coefficient alone.

## Slide 158: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

These are fixed population fits. They omit participant and verb dependence and do not reproduce An and White's acceptability-weighted latent model. Ease remains a companion response, never a trial-level filter. The ordering also assumes that predictors move endpoint use and interior location through one latent dimension; condition-specific discrepancies in the plot are the relevant check.
