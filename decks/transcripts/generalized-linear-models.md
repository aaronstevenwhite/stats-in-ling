# Generalized linear models

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Generalized linear models

Source note: `regression-models/why-generalized-linear-models.qmd`

Welcome to Generalized linear models. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: When ordinary linear regression cannot model the response

Source note: `regression-models/why-generalized-linear-models.qmd`

We now turn to When ordinary linear regression cannot model the response. Ordinary linear regression lets a conditional mean range over the real line and treats residual variance as constant. A binary linguistic response violates both commitments. We can see the problem in the **SuperTelicity cloze data** of White, Cao, Grimm, and Glass's working manuscript, *The preservation of telicity under sense locality* (n.d.).

## Slide 3: SuperTelicity: the empirical object

Source note: `regression-models/why-generalized-linear-models.qmd`

This is the first use of SuperTelicity in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 4: When ordinary linear regression cannot model the response

Source note: `regression-models/why-generalized-linear-models.qmd`

Ordinary linear regression lets a conditional mean range over the real line and treats residual variance as constant. A binary linguistic response violates both commitments. We can see the problem in the **SuperTelicity cloze data** of White, Cao, Grimm, and Glass's working manuscript, *The preservation of telicity under sense locality* (n.d.). The duration comparison uses only rows with a selected temporal magnitude. Thus it describes observed of the observed cloze choices; missing durations keep it from representing the full experiment. The interpretation is conditional on the sampling and measurement design.

## Slide 5: The support problem in observed data

Source note: `regression-models/why-generalized-linear-models.qmd`

For $Y_i=1$ when participant $i$ chooses *in* and $Y_i=0$ otherwise, A linear probability model, $\pi_i=\mathbf x_i^\mathsf T\boldsymbol\beta$, does not constrain $\pi_i$ to $[0,1]$. A logit model instead sets $\operatorname{logit}(\pi_i)=\mathbf x_i^\mathsf T\boldsymbol\beta$. That distinction will matter again on the next slide.

## Slide 6: The support problem in observed data

Source note: `regression-models/why-generalized-linear-models.qmd`

The displayed expression formalizes the support problem in observed data. For $Y_i=1$ when participant $i$ chooses *in* and $Y_i=0$ otherwise, Keep track of what each term refers to in the linguistic dataset.

## Slide 7: When ordinary linear regression cannot model the response

Source note: `regression-models/why-generalized-linear-models.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for When ordinary linear regression cannot model the response. Read the pattern before attaching a model interpretation to it.

## Slide 8: When ordinary linear regression cannot model the response

Source note: `regression-models/why-generalized-linear-models.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for When ordinary linear regression cannot model the response. Read the pattern before attaching a model interpretation to it.

## Slide 9: Interpretation

Source note: `regression-models/why-generalized-linear-models.qmd`

This is also a variance problem: Bernoulli variance is determined by the mean, rather than by one constant residual variance. A generalized linear model repairs both pieces by choosing a response family with the right support and a link that constrains the mean. Notice what is observed and what is supplied by the model.

## Slide 10: Link functions

Source note: `regression-models/link-functions.qmd`

We now turn to Link functions. A **link function** maps a constrained conditional mean to the real-valued linear predictor. We continue with SuperTelicity, where the response is an *in* choice and the first-use source and design are introduced on the preceding page.

## Slide 11: Link functions

Source note: `regression-models/link-functions.qmd`

A **link function** maps a constrained conditional mean to the real-valued linear predictor. We continue with SuperTelicity, where the response is an *in* choice and the first-use source and design are introduced on the preceding page. For a Bernoulli mean $0<\pi_i<1$, the logit link and its inverse are That distinction will matter again on the next slide.

## Slide 12: Overview

Source note: `regression-models/link-functions.qmd`

The displayed expression formalizes overview. A **link function** maps a constrained conditional mean to the real-valued linear predictor. We continue with SuperTelicity, where the response is an *in* choice and the first-use source and design are introduced on the preceding page. Keep track of what each term refers to in the linguistic dataset.

## Slide 13: The inverse link keeps predictions valid

Source note: `regression-models/link-functions.qmd`

The model is additive in $\eta_i$ but curved in $\pi_i$. A constant coefficient is a constant change in log odds, not in probability. The link changes neither the Bernoulli support nor the observed response. It connects the linear predictor to the family mean. For count means the analogous construction uses $\log\lambda_i=\eta_i$ and $\lambda_i=e^{\eta_i}>0$. Thus the choice of link follows the support of the conditional mean. It is not a device for making a histogram look normal. Now connect the notation back to the linguistic comparison.

## Slide 14: Link functions

Source note: `regression-models/link-functions.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Link functions. Read the pattern before attaching a model interpretation to it.

## Slide 15: Interpretation

Source note: `regression-models/link-functions.qmd`

For count means the analogous construction uses $\log\lambda_i=\eta_i$ and $\lambda_i=e^{\eta_i}>0$. Thus the choice of link follows the support of the conditional mean. It is not a device for making a histogram look normal. Notice what is observed and what is supplied by the model.

## Slide 16: Generalized linear models

Source note: `regression-models/generalized-linear-models.qmd`

We now turn to Generalized linear models. A **generalized linear model (GLM)** has three distinct parts: (i) a response distribution, (ii) a linear predictor, and (iii) a link between the distribution's conditional mean and that predictor. The SuperTelicity *in* versus *for* response makes each part observable.

## Slide 17: Generalized linear models

Source note: `regression-models/generalized-linear-models.qmd`

A **generalized linear model (GLM)** has three distinct parts: (i) a response distribution, (ii) a linear predictor, and (iii) a link between the distribution's conditional mean and that predictor. The SuperTelicity *in* versus *for* response makes each part observable. The response component is $Y_i\mid\pi_i\sim\operatorname{Bernoulli}(\pi_i)$, the systematic component is Now connect the notation back to the linguistic comparison.

## Slide 18: Overview: equation 1

Source note: `regression-models/generalized-linear-models.qmd`

The displayed expression formalizes overview: equation 1. A **generalized linear model (GLM)** has three distinct parts: (i) a response distribution, (ii) a linear predictor, and (iii) a link between the distribution's conditional mean and that predictor. The SuperTelicity *in* versus *for* response makes each part observable. Keep track of what each term refers to in the linguistic dataset.

## Slide 19: Overview: equation 2

Source note: `regression-models/generalized-linear-models.qmd`

The displayed expression formalizes overview: equation 2. The response component is $Y_i\mid\pi_i\sim\operatorname{Bernoulli}(\pi_i)$, the systematic component is Keep track of what each term refers to in the linguistic dataset.

## Slide 20: Generalized linear models

Source note: `regression-models/generalized-linear-models.qmd`

Start with the axes and the observed values. The population GLM is useful for exposing the machinery. It is not the SuperTelicity paper's inferential model, which includes supported participant and item dependence. Read the pattern before attaching a model interpretation to it.

## Slide 21: Interpretation

Source note: `regression-models/generalized-linear-models.qmd`

The population GLM is useful for exposing the machinery. It is not the SuperTelicity paper's inferential model, which includes supported participant and item dependence. The interpretation is conditional on the sampling and measurement design.

## Slide 22: The exponential family

Source note: `regression-models/exponential-family.qmd`

We now turn to The exponential family. Many GLM response distributions share the **exponential-family form**

## Slide 23: The exponential family

Source note: `regression-models/exponential-family.qmd`

Many GLM response distributions share the **exponential-family form** Here $\theta$ is the canonical parameter, $b(\theta)$ determines the mean and variance, and $\phi$ supplies dispersion when the family has one. To make those roles concrete, we derive the Bernoulli member from the observed SuperTelicity choices. The interpretation is conditional on the sampling and measurement design.

## Slide 24: Overview: equation 1

Source note: `regression-models/exponential-family.qmd`

The displayed expression formalizes overview: equation 1. Many GLM response distributions share the **exponential-family form** Keep track of what each term refers to in the linguistic dataset.

## Slide 25: Overview: equation 2

Source note: `regression-models/exponential-family.qmd`

The displayed expression formalizes overview: equation 2. Here $\theta$ is the canonical parameter, $b(\theta)$ determines the mean and variance, and $\phi$ supplies dispersion when the family has one. To make those roles concrete, we derive the Bernoulli member from the observed SuperTelicity choices. Keep track of what each term refers to in the linguistic dataset.

## Slide 26: Overview: equation 3

Source note: `regression-models/exponential-family.qmd`

The displayed expression formalizes overview: equation 3. For $y_i\in\{0,1\}$, Keep track of what each term refers to in the linguistic dataset.

## Slide 27: Interpretation

Source note: `regression-models/exponential-family.qmd`

The shared form links distributions to GLM computation, but it does not make the families interchangeable. Bernoulli, Poisson, and normal models retain different supports and mean-variance relations. The exponential-family notation organizes those distinctions; it does not remove them. That distinction will matter again on the next slide.

## Slide 28: Sufficient statistics

Source note: `regression-models/sufficient-statistics.qmd`

We now turn to Sufficient statistics. A statistic is **sufficient** for a parameter when, under the stated model, it retains all sample information about that parameter. For an intercept-only Bernoulli model of the SuperTelicity choices, the sufficient information is the row count and number of *in* responses.

## Slide 29: Sufficient statistics

Source note: `regression-models/sufficient-statistics.qmd`

A statistic is **sufficient** for a parameter when, under the stated model, it retains all sample information about that parameter. For an intercept-only Bernoulli model of the SuperTelicity choices, the sufficient information is the row count and number of *in* responses. The joint likelihood is Use the graph or equation to say the result in ordinary language.

## Slide 30: Overview

Source note: `regression-models/sufficient-statistics.qmd`

The displayed expression formalizes overview. A statistic is **sufficient** for a parameter when, under the stated model, it retains all sample information about that parameter. For an intercept-only Bernoulli model of the SuperTelicity choices, the sufficient information is the row count and number of *in* responses. Keep track of what each term refers to in the linguistic dataset.

## Slide 31: Interpretation

Source note: `regression-models/sufficient-statistics.qmd`

This compression is model-specific. Once verb type, contentfulness, participant, or sentence enters the model, the allocation of responses across those units matters. Sufficiency for one intercept thus does not license deleting participant and sentence identifiers. Use the graph or equation to say the result in ordinary language.

## Slide 32: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

We now turn to Iteratively reweighted least squares. Logistic regression has no ordinary least-squares solution because the inverse logit makes the likelihood nonlinear in the coefficients. **Iteratively reweighted least squares (IRLS)** solves a sequence of local weighted least-squares problems. We can follow that sequence for the SuperTelicity verb-type model.

## Slide 33: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

Logistic regression has no ordinary least-squares solution because the inverse logit makes the likelihood nonlinear in the coefficients. **Iteratively reweighted least squares (IRLS)** solves a sequence of local weighted least-squares problems. We can follow that sequence for the SuperTelicity verb-type model. At iteration $t$, let Keep the observational unit fixed while you interpret the result.

## Slide 34: Overview: equation 1

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

The displayed expression formalizes overview: equation 1. Logistic regression has no ordinary least-squares solution because the inverse logit makes the likelihood nonlinear in the coefficients. **Iteratively reweighted least squares (IRLS)** solves a sequence of local weighted least-squares problems. We can follow that sequence for the SuperTelicity verb-type model. Keep track of what each term refers to in the linguistic dataset.

## Slide 35: Overview: equation 2

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

The displayed expression formalizes overview: equation 2. At iteration $t$, let Keep track of what each term refers to in the linguistic dataset.

## Slide 36: Overview: equation 3

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

The displayed expression formalizes overview: equation 3. The update is Keep track of what each term refers to in the linguistic dataset.

## Slide 37: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

Start with the axes and the observed values. The plotted path records successive local weighted-least-squares solutions. The working response $\mathbf z$ is algorithmic, whereas the observed response remains the original vector of *in* and *for* choices; the final coefficients agree with `glm()` to the asserted tolerance. Read the pattern before attaching a model interpretation to it.

## Slide 38: Iteratively reweighted least squares

Source note: `regression-models/iteratively-reweighted-least-squares.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Iteratively reweighted least squares. Read the pattern before attaching a model interpretation to it.

## Slide 39: Deviance

Source note: `regression-models/deviance.qmd`

We now turn to Deviance. **Deviance** measures how far a fitted likelihood is from the saturated model, which assigns one fitted mean to each observation. If $\ell(\widehat\theta)$ is the fitted log likelihood and $\ell_{\mathrm{sat}}$ is the saturated log likelihood,

## Slide 40: Deviance

Source note: `regression-models/deviance.qmd`

**Deviance** measures how far a fitted likelihood is from the saturated model, which assigns one fitted mean to each observation. If $\ell(\widehat\theta)$ is the fitted log likelihood and $\ell_{\mathrm{sat}}$ is the saturated log likelihood, For Bernoulli rows, the saturated contribution is zero, so residual deviance is $-2\ell(\widehat\theta)$. We compare four population models for the same SuperTelicity rows. That distinction will matter again on the next slide.

## Slide 41: Overview: equation 1

Source note: `regression-models/deviance.qmd`

The displayed expression formalizes overview: equation 1. **Deviance** measures how far a fitted likelihood is from the saturated model, which assigns one fitted mean to each observation. If $\ell(\widehat\theta)$ is the fitted log likelihood and $\ell_{\mathrm{sat}}$ is the saturated log likelihood, Keep track of what each term refers to in the linguistic dataset.

## Slide 42: Overview: equation 2

Source note: `regression-models/deviance.qmd`

The displayed expression formalizes overview: equation 2. For Bernoulli rows, the saturated contribution is zero, so residual deviance is $-2\ell(\widehat\theta)$. We compare four population models for the same SuperTelicity rows. Keep track of what each term refers to in the linguistic dataset.

## Slide 43: Deviance

Source note: `regression-models/deviance.qmd`

Start with the axes and the observed values. It is a likelihood-ratio statistic under the usual regularity conditions. The sequence shows how much each added structure improves row-level fit. Read the pattern before attaching a model interpretation to it.

## Slide 44: Odds and log odds

Source note: `regression-models/odds-and-log-odds.qmd`

We now turn to Odds and log odds. For a probability $p$, the **odds** and **log odds** are

## Slide 45: Odds and log odds

Source note: `regression-models/odds-and-log-odds.qmd`

For a probability $p$, the **odds** and **log odds** are Their interpretation is easiest to anchor in the observed SuperTelicity group probabilities. Notice what is observed and what is supplied by the model.

## Slide 46: Overview

Source note: `regression-models/odds-and-log-odds.qmd`

The displayed expression formalizes overview. For a probability $p$, the **odds** and **log odds** are Keep track of what each term refers to in the linguistic dataset.

## Slide 47: Interpretation

Source note: `regression-models/odds-and-log-odds.qmd`

Log odds are unbounded and additive, which is why logistic regression uses them. Probabilities remain the scale for substantive interpretation. The PS3 page applies this distinction to fitted contrasts. Now connect the notation back to the linguistic comparison.

## Slide 48: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

We now turn to Logistic regression. Logistic regression combines a Bernoulli response with the logit link. For the SuperTelicity verb-type contrast,

## Slide 49: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

Logistic regression combines a Bernoulli response with the logit link. For the SuperTelicity verb-type contrast, The intercept is the manner-verb log odds. The result coefficient is the result-minus-manner log odds difference, so Notice what is observed and what is supplied by the model.

## Slide 50: Overview: equation 1

Source note: `regression-models/logistic-regression.qmd`

The displayed expression formalizes overview: equation 1. Logistic regression combines a Bernoulli response with the logit link. For the SuperTelicity verb-type contrast, Keep track of what each term refers to in the linguistic dataset.

## Slide 51: Overview: equation 2

Source note: `regression-models/logistic-regression.qmd`

The displayed expression formalizes overview: equation 2. The intercept is the manner-verb log odds. The result coefficient is the result-minus-manner log odds difference, so Keep track of what each term refers to in the linguistic dataset.

## Slide 52: Logistic regression

Source note: `regression-models/logistic-regression.qmd`

Start with the axes and the observed values. This population model remains a teaching simplification. The SuperTelicity analysis uses a Bayesian logistic mixed model; repeated participants and sentences make the row-independent standard errors here unsuitable for confirmatory inference. Read the pattern before attaching a model interpretation to it.

## Slide 53: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

We now turn to A logistic-regression analysis. We now carry the SuperTelicity one-predictor analysis from raw counts to fitted probabilities. The scientific question is descriptive: how does *in* completion use differ between manner and result verbs in this sample?

## Slide 54: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

We now carry the SuperTelicity one-predictor analysis from raw counts to fitted probabilities. The scientific question is descriptive: how does *in* completion use differ between manner and result verbs in this sample? The fit reproduces the higher sample probability for result verbs, and the plot places that raw contrast beside the row-independent GLM intervals. On the link scale, the likelihood is Now connect the notation back to the linguistic comparison.

## Slide 55: Overview

Source note: `regression-models/logistic-regression-example.qmd`

The displayed expression formalizes overview. We now carry the SuperTelicity one-predictor analysis from raw counts to fitted probabilities. The scientific question is descriptive: how does *in* completion use differ between manner and result verbs in this sample? Keep track of what each term refers to in the linguistic dataset.

## Slide 56: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

Start with the axes and the observed values. The intervals shown are the row-independent GLM intervals and are included to expose the mechanics. They are not the inferential result of the source paper. Read the pattern before attaching a model interpretation to it.

## Slide 57: A logistic-regression analysis

Source note: `regression-models/logistic-regression-example.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for A logistic-regression analysis. Read the pattern before attaching a model interpretation to it.

## Slide 58: Interpretation

Source note: `regression-models/logistic-regression-example.qmd`

The intervals shown are the row-independent GLM intervals and are included to expose the mechanics. They are not the inferential result of the source paper. The rows reuse participants and sentence materials, and the original analysis models that dependence. Notice what is observed and what is supplied by the model.

## Slide 59: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

We now turn to Logistic regression with multiple predictors. Multiple-predictor logistic regression can represent whether the SuperTelicity verb-type contrast changes across contentfulness classes. The additive model states one common verb-type log odds difference; the interaction model allows it to vary.

## Slide 60: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

Multiple-predictor logistic regression can represent whether the SuperTelicity verb-type contrast changes across contentfulness classes. The additive model states one common verb-type log odds difference; the interaction model allows it to vary. The additive linear predictor is Use the graph or equation to say the result in ordinary language.

## Slide 61: Overview

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

The displayed expression formalizes overview. Multiple-predictor logistic regression can represent whether the SuperTelicity verb-type contrast changes across contentfulness classes. The additive model states one common verb-type log odds difference; the interaction model allows it to vary. Keep track of what each term refers to in the linguistic dataset.

## Slide 62: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

Start with the axes and the observed values. A partial coefficient is meaningful only because the observed design supplies overlap among the represented cells. This population model still omits participant and sentence dependence and does not replace the paper's mixed analysis. Read the pattern before attaching a model interpretation to it.

## Slide 63: Logistic regression with multiple predictors

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Logistic regression with multiple predictors. Read the pattern before attaching a model interpretation to it.

## Slide 64: Interpretation

Source note: `regression-models/logistic-regression-with-multiple-predictors.qmd`

A partial coefficient is meaningful only because the observed design supplies overlap among the represented cells. This population model still omits participant and sentence dependence and does not replace the paper's mixed analysis. The PS3 page asks students to interpret related fitted contrasts. Keep the observational unit fixed while you interpret the result.

## Slide 65: Deviance residuals

Source note: `regression-models/deviance-residuals.qmd`

We now turn to Deviance residuals. A deviance residual assigns each observation a signed share of model deviance. For Bernoulli logistic regression,

## Slide 66: Deviance residuals

Source note: `regression-models/deviance-residuals.qmd`

A deviance residual assigns each observation a signed share of model deviance. For Bernoulli logistic regression, with zero-times-log-zero terms defined as zero. We compute these residuals from the SuperTelicity interaction fit. Now connect the notation back to the linguistic comparison.

## Slide 67: Overview

Source note: `regression-models/deviance-residuals.qmd`

The displayed expression formalizes overview. A deviance residual assigns each observation a signed share of model deviance. For Bernoulli logistic regression, Keep track of what each term refers to in the linguistic dataset.

## Slide 68: Deviance residuals

Source note: `regression-models/deviance-residuals.qmd`

Start with the axes and the observed values. Large gaps identify verbs for inspection, not automatically erroneous observations. They may indicate omitted lexical structure, dependence, or a mean specification that is too coarse. Read the pattern before attaching a model interpretation to it.

## Slide 69: Ordinal regression

Source note: `regression-models/ordinal-regression.qmd`

We now turn to Ordinal regression. An ordinal response has ordered categories but no defensible numerical spacing. We use **MegaVeridicality v1**, the *no*-*maybe*-*yes* veridicality judgments described by White and Rawlins (2018 paper; CC BY-SA project release). Each row is one judgment for a verb, polarity, task, item, and task-specific respondent.

## Slide 70: MegaVeridicality: the empirical object

Source note: `regression-models/ordinal-regression.qmd`

This is the first use of MegaVeridicality in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 71: Ordinal regression

Source note: `regression-models/ordinal-regression.qmd`

An ordinal response has ordered categories but no defensible numerical spacing. We use **MegaVeridicality v1**, the *no*-*maybe*-*yes* veridicality judgments described by White and Rawlins (2018 paper; CC BY-SA project release). Each row is one judgment for a verb, polarity, task, item, and task-specific respondent. The interpretation is conditional on the sampling and measurement design.

## Slide 72: Cumulative logits

Source note: `regression-models/ordinal-regression.qmd`

For ordered cutpoints $\kappa_1<\kappa_2$ and linear predictor $\eta_i$, With the logistic CDF $F$, the category probabilities are Notice what is observed and what is supplied by the model.

## Slide 73: Cumulative logits: equation 1

Source note: `regression-models/ordinal-regression.qmd`

The displayed expression formalizes cumulative logits: equation 1. For ordered cutpoints $\kappa_1<\kappa_2$ and linear predictor $\eta_i$, Keep track of what each term refers to in the linguistic dataset.

## Slide 74: Cumulative logits: equation 2

Source note: `regression-models/ordinal-regression.qmd`

The displayed expression formalizes cumulative logits: equation 2. With the logistic CDF $F$, the category probabilities are Keep track of what each term refers to in the linguistic dataset.

## Slide 75: Cumulative logits: equation 3

Source note: `regression-models/ordinal-regression.qmd`

The displayed expression formalizes cumulative logits: equation 3. The model preserves order without assigning equal distances to the labels. Keep track of what each term refers to in the linguistic dataset.

## Slide 76: Cumulative logits: equation 4

Source note: `regression-models/ordinal-regression.qmd`

The displayed expression formalizes cumulative logits: equation 4. The model preserves order without assigning equal distances to the labels. Keep track of what each term refers to in the linguistic dataset.

## Slide 77: Interpreting one coefficient at both boundaries

Source note: `regression-models/ordinal-regression.qmd`

A positive coefficient increases the linear predictor and shifts probability toward higher responses. Under proportional odds, the same coefficient applies to *maybe* or *yes* versus *no* and to *yes* versus *no* or *maybe*. An ordinal response has ordered categories but no defensible numerical spacing. We use **MegaVeridicality v1**, the *no*-*maybe*-*yes* veridicality judgments described by White and Rawlins (2018 paper; CC BY-SA project release). Each row is one judgment for a verb, polarity, task, item, and task-specific respondent. Keep the observational unit fixed while you interpret the result.

## Slide 78: Checking the shared-shift restriction

Source note: `regression-models/ordinal-regression.qmd`

The proportional-odds model requires the same predictor shift at both boundaries. Two binary regressions expose how strained that restriction is here. The negative-polarity and polarity-by-task coefficients differ across boundaries, so one shared location shift is a useful baseline but an imperfect description. The fit is a population teaching model, not the paper's responsivity analysis and not a latent verb classification. It also omits respondent and verb dependence, which the later ordinal mixed-model page addresses. Now connect the notation back to the linguistic comparison.

## Slide 79: Ordinal regression

Source note: `regression-models/ordinal-regression.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Ordinal regression. Read the pattern before attaching a model interpretation to it.

## Slide 80: Interpretation

Source note: `regression-models/ordinal-regression.qmd`

The negative-polarity and polarity-by-task coefficients differ across boundaries, so one shared location shift is a useful baseline but an imperfect description. The fit is a population teaching model, not the paper's responsivity analysis and not a latent verb classification. Now connect the notation back to the linguistic comparison.

## Slide 81: Poisson regression

Source note: `regression-models/poisson-regression.qmd`

We now turn to Poisson regression. Poisson regression models a nonnegative count with a positive conditional mean. We use Nettle's (1998) country-level study of language diversity and climate. One row is one country; the response is its reported language count, mean growing season (MGS) is the ecological predictor, and area measures geographic opportunity. The teaching table comes from Bodo Winter's course-data repository.

## Slide 82: Nettle: the empirical object

Source note: `regression-models/poisson-regression.qmd`

This is the first use of Nettle in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 83: Poisson regression

Source note: `regression-models/poisson-regression.qmd`

Poisson regression models a nonnegative count with a positive conditional mean. We use Nettle's (1998) country-level study of language diversity and climate. One row is one country; the response is its reported language count, mean growing season (MGS) is the ecological predictor, and area measures geographic opportunity. The model is That distinction will matter again on the next slide.

## Slide 84: Overview: equation 1

Source note: `regression-models/poisson-regression.qmd`

The displayed expression formalizes overview: equation 1. Poisson regression models a nonnegative count with a positive conditional mean. We use Nettle's (1998) country-level study of language diversity and climate. One row is one country; the response is its reported language count, mean growing season (MGS) is the ecological predictor, and area measures geographic opportunity. The teaching table comes from Bodo Winter's course-data repository. Keep track of what each term refers to in the linguistic dataset.

## Slide 85: Overview: equation 2

Source note: `regression-models/poisson-regression.qmd`

The displayed expression formalizes overview: equation 2. The model is Keep track of what each term refers to in the linguistic dataset.

## Slide 86: Poisson regression

Source note: `regression-models/poisson-regression.qmd`

Start with the axes and the observed values. A one-month increase in MGS multiplies the fitted rate by observed, conditional on the teaching specification. Nettle instead estimated the log-area coefficient. Read the pattern before attaching a model interpretation to it.

## Slide 87: Interpretation

Source note: `regression-models/poisson-regression.qmd`

A one-month increase in MGS multiplies the fitted rate by observed, conditional on the teaching specification. Nettle instead estimated the log-area coefficient. Fixing it to one narrows the question and does not reproduce the paper or support a causal ecological claim. Now connect the notation back to the linguistic comparison.

## Slide 88: Exposure offsets

Source note: `regression-models/exposure-offsets.qmd`

We now turn to Exposure offsets. A count is inseparable from its opportunity window. For Nettle's country data, area is a proposed exposure: larger countries provide more geographic space in which languages are counted. An **offset** fixes the exposure coefficient rather than estimating it.

## Slide 89: Exposure offsets

Source note: `regression-models/exposure-offsets.qmd`

A count is inseparable from its opportunity window. For Nettle's country data, area is a proposed exposure: larger countries provide more geographic space in which languages are counted. An **offset** fixes the exposure coefficient rather than estimating it. If $A_i$ is area and $r_i$ is the expected language rate per unit area, then That distinction will matter again on the next slide.

## Slide 90: Overview: equation 1

Source note: `regression-models/exposure-offsets.qmd`

The displayed expression formalizes overview: equation 1. A count is inseparable from its opportunity window. For Nettle's country data, area is a proposed exposure: larger countries provide more geographic space in which languages are counted. An **offset** fixes the exposure coefficient rather than estimating it. Keep track of what each term refers to in the linguistic dataset.

## Slide 91: Overview: equation 2

Source note: `regression-models/exposure-offsets.qmd`

The displayed expression formalizes overview: equation 2. If $A_i$ is area and $r_i$ is the expected language rate per unit area, then Keep track of what each term refers to in the linguistic dataset.

## Slide 92: Exposure offsets

Source note: `regression-models/exposure-offsets.qmd`

Start with the axes and the observed values. The source `Area` column is base-10 logarithmic. A Poisson log link uses natural logarithms, hence the explicit conversion $\log A_i=\log(10)\log_{10}A_i$. Treating area as exposure assumes proportionality between expected count and area. Read the pattern before attaching a model interpretation to it.

## Slide 93: A Poisson-regression analysis

Source note: `regression-models/poisson-regression-example.qmd`

We now turn to A Poisson-regression analysis. The Nettle language-rate model makes the log-base requirement visible: the primary fit uses natural-log area as a fixed exposure offset, while the diagnostic inserts the source's base-10 column directly. Because the upstream course repository states no license, the fallback below downloads and verifies the exact source.

## Slide 94: A Poisson-regression analysis

Source note: `regression-models/poisson-regression-example.qmd`

The Nettle language-rate model makes the log-base requirement visible: the primary fit uses natural-log area as a fixed exposure offset, while the diagnostic inserts the source's base-10 column directly. Because the upstream course repository states no license, the fallback below downloads and verifies the exact source. The mismatch changes the coefficient because it no longer encodes $\lambda_i=A_i r_i$ with an exposure coefficient of one. Now connect the notation back to the linguistic comparison.

## Slide 95: A Poisson-regression analysis

Source note: `regression-models/poisson-regression-example.qmd`

Start with the axes and the observed values. The fitted positive association answers a conditional, descriptive question under a fixed-area-exposure assumption. Countries are not experimental units assigned to climates; area is not literally observation time; and Nettle's original specification estimated its coefficient. Read the pattern before attaching a model interpretation to it.

## Slide 96: A Poisson-regression analysis

Source note: `regression-models/poisson-regression-example.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for A Poisson-regression analysis. Read the pattern before attaching a model interpretation to it.

## Slide 97: Interpretation

Source note: `regression-models/poisson-regression-example.qmd`

The fitted positive association answers a conditional, descriptive question under a fixed-area-exposure assumption. Countries are not experimental units assigned to climates; area is not literally observation time; and Nettle's original specification estimated its coefficient. None of these fits supports a causal ecological claim. Use the graph or equation to say the result in ordinary language.

## Slide 98: Count overdispersion

Source note: `regression-models/count-overdispersion.qmd`

We now turn to Count overdispersion. Poisson regression requires conditional mean and variance to be equal. **Overdispersion** occurs when the remaining variation is larger than that requirement permits. We diagnose it in the Nettle teaching model with Pearson residuals.

## Slide 99: Count overdispersion

Source note: `regression-models/count-overdispersion.qmd`

Poisson regression requires conditional mean and variance to be equal. **Overdispersion** occurs when the remaining variation is larger than that requirement permits. We diagnose it in the Nettle teaching model with Pearson residuals. The estimator is Use the graph or equation to say the result in ordinary language.

## Slide 100: Overview

Source note: `regression-models/count-overdispersion.qmd`

The displayed expression formalizes overview. Poisson regression requires conditional mean and variance to be equal. **Overdispersion** occurs when the remaining variation is larger than that requirement permits. We diagnose it in the Nettle teaching model with Pearson residuals. Keep track of what each term refers to in the linguistic dataset.

## Slide 101: Count overdispersion

Source note: `regression-models/count-overdispersion.qmd`

Start with the axes and the observed values. Overdispersion may arise from omitted heterogeneity, dependence, an inadequate mean formula, or a different count distribution. It is a diagnosis, not a mechanism. The next page changes the variance used for uncertainty while retaining the fitted mean. Read the pattern before attaching a model interpretation to it.

## Slide 102: Interpretation

Source note: `regression-models/count-overdispersion.qmd`

A Poisson model expects a value near one. The observed value is observed, so the conditional variance restriction fails badly for this specification. Use the graph or equation to say the result in ordinary language.

## Slide 103: Quasi-Poisson regression

Source note: `regression-models/quasi-poisson.qmd`

We now turn to Quasi-Poisson regression. Quasi-Poisson regression keeps the Poisson mean function but allows

## Slide 104: Quasi-Poisson regression

Source note: `regression-models/quasi-poisson.qmd`

Quasi-Poisson regression keeps the Poisson mean function but allows It thus changes uncertainty, not fitted means. The Nettle data show the distinction directly. The interpretation is conditional on the sampling and measurement design.

## Slide 105: Overview

Source note: `regression-models/quasi-poisson.qmd`

The displayed expression formalizes overview. Quasi-Poisson regression keeps the Poisson mean function but allows Keep track of what each term refers to in the linguistic dataset.

## Slide 106: Quasi-Poisson regression

Source note: `regression-models/quasi-poisson.qmd`

Start with the axes and the observed values. Quasi-likelihood does not define a complete probability mass function, so ordinary likelihood comparisons such as AIC are unavailable. It repairs the variance used for standard errors, not omitted structure, country dependence, or the exposure assumption. Read the pattern before attaching a model interpretation to it.

## Slide 107: Zeros in count data

Source note: `regression-models/zero-inflated-counts.qmd`

We now turn to Zeros in count data. More observed zeros than a Poisson model predicts do not by themselves establish a separate zero-generating process. We examine that **zero-pattern ambiguity** in Storme's (2024) French liaison study and its Zenodo release. One prepared row is a final-morpheme, final-consonant, and liaison-status combination. Following the released code, the response is integer truncation of 100 times summed `freqfilms2`, not a direct token tally.

## Slide 108: Storme: the empirical object

Source note: `regression-models/zero-inflated-counts.qmd`

This is the first use of Storme in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 109: Zeros in count data

Source note: `regression-models/zero-inflated-counts.qmd`

More observed zeros than a Poisson model predicts do not by themselves establish a separate zero-generating process. We examine that **zero-pattern ambiguity** in Storme's (2024) French liaison study and its Zenodo release. One prepared row is a final-morpheme, final-consonant, and liaison-status combination. We fit additive Poisson and negative-binomial baselines with the same mean formula. The negative binomial allows The interpretation is conditional on the sampling and measurement design.

## Slide 110: Overview

Source note: `regression-models/zero-inflated-counts.qmd`

The displayed expression formalizes overview. More observed zeros than a Poisson model predicts do not by themselves establish a separate zero-generating process. We examine that **zero-pattern ambiguity** in Storme's (2024) French liaison study and its Zenodo release. One prepared row is a final-morpheme, final-consonant, and liaison-status combination. Following the released code, the response is integer truncation of 100 times summed `freqfilms2`, not a direct token tally. Keep track of what each term refers to in the linguistic dataset.

## Slide 111: Zeros in count data

Source note: `regression-models/zero-inflated-counts.qmd`

Start with the axes and the observed values. The Poisson model assigns almost no zero mass, while the negative binomial moves toward the observed proportions without a structural-zero component. We thus do not fit a zero-inflated model here. Read the pattern before attaching a model interpretation to it.

## Slide 112: Negative-binomial regression

Source note: `regression-models/negative-binomial-regression.qmd`

We now turn to Negative-binomial regression. The negative-binomial distribution relaxes the Poisson mean-variance equality while retaining nonnegative integer support. We continue with Storme's French liaison counts and use the paper-aligned liaison-by-final-consonant interaction.

## Slide 113: Negative-binomial regression

Source note: `regression-models/negative-binomial-regression.qmd`

The negative-binomial distribution relaxes the Poisson mean-variance equality while retaining nonnegative integer support. We continue with Storme's French liaison counts and use the paper-aligned liaison-by-final-consonant interaction. With mean $\mu_i$ and size $\theta$, That distinction will matter again on the next slide.

## Slide 114: Overview

Source note: `regression-models/negative-binomial-regression.qmd`

The displayed expression formalizes overview. The negative-binomial distribution relaxes the Poisson mean-variance equality while retaining nonnegative integer support. We continue with Storme's French liaison counts and use the paper-aligned liaison-by-final-consonant interaction. Keep track of what each term refers to in the linguistic dataset.

## Slide 115: Negative-binomial regression

Source note: `regression-models/negative-binomial-regression.qmd`

Start with the axes and the observed values. Liaison cells have higher fitted means for each represented consonant, but the ratios are strongly consonant-specific. The response is reconstructed from frequency values, and lexical rows may remain dependent. Read the pattern before attaching a model interpretation to it.

## Slide 116: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

We now turn to Bounded responses. A slider response on $[0,1]$ is bounded, can use exact endpoints, and may have a nonconstant variance. We use the public **MegaNegRaising** release described by An and White (2020 paper; CC BY-SA data and documentation). The archive filename says v1, while its internal README identifies v1.1, released 2020-08-29.

## Slide 117: MegaNegRaising: the empirical object

Source note: `regression-models/bounded-responses.qmd`

This is the first use of MegaNegRaising in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 118: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

A slider response on $[0,1]$ is bounded, can use exact endpoints, and may have a nonconstant variance. We use the public **MegaNegRaising** release described by An and White (2020 paper; CC BY-SA data and documentation). The archive filename says v1, while its internal README identifies v1.1, released 2020-08-29. Each raw row contains paired judgments: how likely matrix negation conveys embedded negation and how easy it is to imagine someone uttering the matrix-negated sentence. An and White call the ease response acceptability while noting the simplification. That distinction will matter again on the next slide.

## Slide 119: Bounded responses

Source note: `regression-models/bounded-responses.qmd`

Start with the axes and the observed values. The source paper uses the ease response to weight a KL loss in a latent lexical-and-structural model with participant-specific scale and shift terms. Our subset remains acceptability-selected upstream, but we never filter individual trials by ease. Read the pattern before attaching a model interpretation to it.

## Slide 120: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

We now turn to Why ordinary beta regression does not fit endpoint sliders. The beta density has support $0<y<1$. MegaNegRaising contains exact zeros and ones on both recorded sliders, so ordinary beta regression assigns those observations zero probability.

## Slide 121: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

The beta density has support $0<y<1$. MegaNegRaising contains exact zeros and ones on both recorded sliders, so ordinary beta regression assigns those observations zero probability. For $0<y<1$, a mean-precision beta parameterization is Keep the observational unit fixed while you interpret the result.

## Slide 122: Overview: equation 1

Source note: `regression-models/why-not-beta-sliders.qmd`

The displayed expression formalizes overview: equation 1. The beta density has support $0<y<1$. MegaNegRaising contains exact zeros and ones on both recorded sliders, so ordinary beta regression assigns those observations zero probability. Keep track of what each term refers to in the linguistic dataset.

## Slide 123: Overview: equation 2

Source note: `regression-models/why-not-beta-sliders.qmd`

The displayed expression formalizes overview: equation 2. For $0<y<1$, a mean-precision beta parameterization is Keep track of what each term refers to in the linguistic dataset.

## Slide 124: Overview: equation 3

Source note: `regression-models/why-not-beta-sliders.qmd`

The displayed expression formalizes overview: equation 3. with Keep track of what each term refers to in the linguistic dataset.

## Slide 125: Why ordinary beta regression does not fit endpoint sliders

Source note: `regression-models/why-not-beta-sliders.qmd`

Start with the axes and the observed values. A likelihood that contains explicit endpoint probabilities is more faithful to the recorded response. The next page uses ordered-beta regression for both sliders without changing or filtering either outcome. Read the pattern before attaching a model interpretation to it.

## Slide 126: Interpretation

Source note: `regression-models/why-not-beta-sliders.qmd`

For the observed retained judgments, zero becomes observed and one becomes observed. The transformation makes the sample size part of the measurement model: adding unrelated rows moves the transformed endpoints. It also replaces observed endpoint events with extremely interior values. Notice what is observed and what is supplied by the model.

## Slide 127: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

We now turn to Ordered-beta regression. **Ordered-beta regression** represents three observable regions: $Y_i=0$, $0<Y_i<1$, and $Y_i=1$. We fit the same population formula to both MegaNegRaising sliders, as prespecified in the dataset audit.

## Slide 128: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

**Ordered-beta regression** represents three observable regions: $Y_i=0$, $0<Y_i<1$, and $Y_i=1$. We fit the same population formula to both MegaNegRaising sliders, as prespecified in the dataset audit. For ordered cutpoints $\kappa_0<\kappa_1$ and $\eta_i=\mathbf x_i^\mathsf T\boldsymbol\beta$, Use the graph or equation to say the result in ordinary language.

## Slide 129: Overview: equation 1

Source note: `regression-models/ordered-beta-regression.qmd`

The displayed expression formalizes overview: equation 1. **Ordered-beta regression** represents three observable regions: $Y_i=0$, $0<Y_i<1$, and $Y_i=1$. We fit the same population formula to both MegaNegRaising sliders, as prespecified in the dataset audit. Keep track of what each term refers to in the linguistic dataset.

## Slide 130: Overview: equation 2

Source note: `regression-models/ordered-beta-regression.qmd`

The displayed expression formalizes overview: equation 2. For ordered cutpoints $\kappa_0<\kappa_1$ and $\eta_i=\mathbf x_i^\mathsf T\boldsymbol\beta$, Keep track of what each term refers to in the linguistic dataset.

## Slide 131: Overview: equation 3

Source note: `regression-models/ordered-beta-regression.qmd`

The displayed expression formalizes overview: equation 3. Conditional on the interior, Keep track of what each term refers to in the linguistic dataset.

## Slide 132: Overview: equation 4

Source note: `regression-models/ordered-beta-regression.qmd`

The displayed expression formalizes overview: equation 4. The visible likelihood below constrains the cutpoint gap and precision to be positive. Keep track of what each term refers to in the linguistic dataset.

## Slide 133: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

Start with the axes and the observed values. These are fixed population fits. They omit participant and verb dependence and do not reproduce An and White's acceptability-weighted latent model. Ease remains a companion response, never a trial-level filter. Read the pattern before attaching a model interpretation to it.

## Slide 134: Ordered-beta regression

Source note: `regression-models/ordered-beta-regression.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Ordered-beta regression. Read the pattern before attaching a model interpretation to it.

## Slide 135: Interpretation

Source note: `regression-models/ordered-beta-regression.qmd`

These are fixed population fits. They omit participant and verb dependence and do not reproduce An and White's acceptability-weighted latent model. Ease remains a companion response, never a trial-level filter. Keep the observational unit fixed while you interpret the result.
