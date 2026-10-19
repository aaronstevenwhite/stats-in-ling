# Mixed-effects models

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Mixed-effects models

Source note: `regression-models/structured-data.qmd`

Welcome to Mixed-effects models. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Repeated units in linguistic data

Source note: `regression-models/structured-data.qmd`

Now we turn to Repeated units in linguistic data.

## Slide 3: MALD: the empirical object

Source note: `regression-models/structured-data.qmd`

The data source is Tucker et al. (2019), MALD. It provides participant-by-word auditory lexical-decision trials.

## Slide 4: Repeated units in linguistic data

Source note: `regression-models/structured-data.qmd`

The chapter on independent sampling separated the number of recorded observations from the assumptions that make those observations independent. Linguistic experiments commonly contain repeated participants and items, so rows inherit dependence from the design.

## Slide 5: Repeated units in linguistic data

Source note: `regression-models/structured-data.qmd`

We examine that structure in the **MALD connected-trial extract**. MALD is an auditory lexical-decision database described by Tucker et al. (2019); the later MALD 1.1 release expanded the participant inventory. The paper reports 231 listeners, whereas release 1.1 contains 440. These totals describe different versions and should not be combined.

## Slide 6: Examining repetition in the MALD table

Source note: `regression-models/structured-data.qmd`

The prepared extract is response-blind: participants and words were selected without using correctness or response time. It is not the full release. One row records one real-word trial from one participant, including the spoken word, response time, correctness, SUBTLEX frequency, acoustic duration, and within-run trial order.

## Slide 7: Examining repetition in the MALD table

Source note: `regression-models/structured-data.qmd`

The latency analysis retains correct responses, as in Tucker et al.’s source analysis. This restriction leaves 11,987 trials from 94 participants and 4,872 spoken words. It does not make the retained rows independent.

## Slide 8: Examining repetition in the MALD table

Source note: `regression-models/structured-data.qmd`

This figure shows observed linguistic data for Examining repetition in the MALD table.

## Slide 9: Examining repetition in the MALD table

Source note: `regression-models/structured-data.qmd`

The two panels show different replication structures. A participant contributes many lexical decisions, while a word is heard by more than one participant. Thus the trial count, participant count, and item count answer different questions.

## Slide 10: Writing the independence claim

Source note: `regression-models/structured-data.qmd`

A regression model without grouping terms often represents conditional independence as

$$
f(\mathbf y\mid\mathbf X,\boldsymbol\beta)
=\prod_i f(y_i\mid\mathbf x_i,\boldsymbol\beta).
$$

## Slide 11: Writing the independence claim

Source note: `regression-models/structured-data.qmd`

After the predictors are known, the joint density is written as a product over trials. Under this model, learning the residual for one row gives no information about the residual for another.

## Slide 12: Writing the independence claim

Source note: `regression-models/structured-data.qmd`

That claim is implausible here for two distinct reasons. Responses from one participant may resemble each other because that listener has a persistent response-speed baseline. Responses to one word may resemble each other because its acoustic and lexical properties are not completely represented by the measured predictors. Observing one trial can thus change what we expect for another trial that shares its participant or word.

## Slide 13: Distinguishing crossed and nested units

Source note: `regression-models/structured-data.qmd`

Participant and word are **crossed** because participants respond to many words and words receive responses from multiple participants. A nested structure would instead require each lower-level unit to belong to only one higher-level unit. For instance, runs belong to participant sessions in the MALD release; a run identifier does not migrate between participants.

## Slide 14: Distinguishing crossed and nested units

Source note: `regression-models/structured-data.qmd`

The distinction can be checked from the incidence table rather than inferred from column order:

## Slide 15: Matching dependence to the claim

Source note: `regression-models/structured-data.qmd`

A participant-population claim requires replication across participants. An item-population claim requires replication across words. A claim about both requires a design and analysis that preserve both sources. More trials from the same participants or words improve estimates for those units but do not add participant or word replication.

## Slide 16: Matching dependence to the claim

Source note: `regression-models/structured-data.qmd`

Averaging trials within participants would preserve participant replication while discarding word variation and within-participant trial predictors. Averaging within words would do the reverse. Mixed-effects models retain trial-level responses while representing both shared sources.

## Slide 17: Matching dependence to the claim

Source note: `regression-models/structured-data.qmd`

Before fitting one, record four facts: (i) what one response row represents, (ii) which sampled units recur, (iii) whether those units are crossed or nested, and (iv) the populations across which the linguistic association should generalize. The next page translates those design facts into population coefficients and group distributions.

## Slide 18: Population coefficients and group variation

Source note: `regression-models/fixed-and-random-effects.qmd`

Now we turn to Population coefficients and group variation.

## Slide 19: Population coefficients and group variation

Source note: `regression-models/fixed-and-random-effects.qmd`

The preceding page identified participant and spoken word as crossed repeated units in the MALD trial table. We now separate the population associations represented by coefficients from variation across those sampled units.

## Slide 20: Beginning with the scientific target

Source note: `regression-models/fixed-and-random-effects.qmd`

The focal course model relates log response time to standardized log SUBTLEX frequency, standardized log acoustic duration, and standardized trial order. These predictors enter the population relation:

$$
\mathbb{E}[Y_i\mid\mathbf x_i,\mathbf b]
=\mathbf x_i^{\mathsf T}\boldsymbol\beta
+\mathbf z_i^{\mathsf T}\mathbf b.
$$

## Slide 21: Beginning with the scientific target

Source note: `regression-models/fixed-and-random-effects.qmd`

Here $\boldsymbol\beta$ contains the population intercept and the three population associations. In particular, $\beta_{\text{frequency}}$ is the expected change in log response time for a one-standard-deviation increase in log frequency, holding duration and trial order fixed.

## Slide 22: Beginning with the scientific target

Source note: `regression-models/fixed-and-random-effects.qmd`

The word *fixed* does not mean known, measured without uncertainty, or constant across every conceivable population. It means that the coefficient is not itself indexed by a grouping level in this model.

## Slide 23: Representing sampled variation

Source note: `regression-models/fixed-and-random-effects.qmd`

Participant $p$ receives an intercept deviation and a frequency-slope deviation:

$$
\mathbf b_p=
\begin{pmatrix}b_{0p}\\b_{1p}\end{pmatrix}
\sim
\mathcal N(\mathbf 0,\boldsymbol\Sigma_p).
$$

## Slide 24: Representing sampled variation

Source note: `regression-models/fixed-and-random-effects.qmd`

Word $w$ receives an intercept deviation,

$$
c_w\sim\mathcal N(0,\tau_w^2),
$$

and the trial residual is

$$
\varepsilon_{pwi}\sim\mathcal N(0,\sigma^2).
$$

## Slide 25: Representing sampled variation

Source note: `regression-models/fixed-and-random-effects.qmd`

Combining the pieces gives

$$
Y_{pwi}
=\beta_0+\beta_f x_{wi}^{(f)}+\beta_d x_{wi}^{(d)}
+\beta_t x_{pwi}^{(t)}
+b_{0p}+b_{1p}x_{wi}^{(f)}+c_w+\varepsilon_{pwi}.
$$

## Slide 26: Representing sampled variation

Source note: `regression-models/fixed-and-random-effects.qmd`

The frequency column and participant identifier both enter the construction of the linear predictor, but they have different roles. Frequency is a measured predictor with a population coefficient. Participant identity indexes deviations drawn from a population distribution.

## Slide 27: Fitting the MALD model

Source note: `regression-models/fixed-and-random-effects.qmd`

The fitted frequency coefficient is -0.031 log-response-time units per standard deviation. This is a population association conditional on duration and trial order. It is not a participant-specific slope or a causal effect of lexical frequency.

## Slide 28: Showing raw data and the fitted population relation

Source note: `regression-models/fixed-and-random-effects.qmd`

Plotting all trials would obscure the relation. We thus summarize the raw responses in empirical frequency bins and draw the fitted population line at mean duration and mean trial order.

## Slide 29: Showing raw data and the fitted population relation

Source note: `regression-models/fixed-and-random-effects.qmd`

This figure shows observed linguistic data for Showing raw data and the fitted population relation.

## Slide 30: Showing raw data and the fitted population relation

Source note: `regression-models/fixed-and-random-effects.qmd`

The points are raw bin means; the line sets participant and item deviations to zero. Thus it describes the fitted population relation on the same response scale, not the trajectory of an observed participant or word.

## Slide 31: Storage type does not determine modeling role

Source note: `regression-models/fixed-and-random-effects.qmd`

Frequency, participant, item, and part of speech can all be stored as columns. Their storage types do not decide whether they receive population coefficients or group distributions. The decision follows the estimand and sampling design. A measured property that encodes a theoretical contrast belongs in the population relation. A sampled identifier that records repeated observations can index remaining variation around that relation.

## Slide 32: Storage type does not determine modeling role

Source note: `regression-models/fixed-and-random-effects.qmd`

The course formula omits controls analyzed by Tucker et al. It isolates the covariance concepts needed here and does not reproduce their predictor comparison. The next page shows how the group distributions produce partial pooling.

## Slide 33: Random effects and partial pooling

Source note: `regression-models/random-effects.qmd`

The next topic is Random effects and partial pooling.

## Slide 34: Random effects and partial pooling

Source note: `regression-models/random-effects.qmd`

The preceding page separated population associations from variation across sampled listeners and words. A random-effects model represents the latter through a shared group distribution and **partial pooling**.

## Slide 35: Model deviations from a shared center

Source note: `regression-models/random-effects.qmd`

Begin with a crossed intercept-only model for the correct MALD latencies:

$$
Y_{pwi}=\beta_0+b_p+c_w+\varepsilon_{pwi},
$$

where

$$
b_p\sim\mathcal N(0,\tau_p^2),\qquad
c_w\sim\mathcal N(0,\tau_w^2),\qquad
\varepsilon_{pwi}\sim\mathcal N(0,\sigma^2).
$$

## Slide 36: Model deviations from a shared center

Source note: `regression-models/random-effects.qmd`

The zero centers define $\beta_0$ as the population center. They do not assert that participants or words are identical. The parameters $\tau_p$ and $\tau_w$ describe the extent of persistent baseline differences.

## Slide 37: Comparing pooling strategies

Source note: `regression-models/random-effects.qmd`

Complete pooling ignores participant identity and assigns every participant the population baseline $\beta_0$. No pooling estimates an unrelated mean for every participant. Partial pooling gives each participant a distinct deviation while estimating those deviations under one population distribution.

## Slide 38: Comparing pooling strategies

Source note: `regression-models/random-effects.qmd`

For a one-group normal random-intercept model with known variance components, the participant deviation has the form

$$
\widehat b_p
=w_p(\overline y_p-\beta_0),
$$

with

$$
w_p
=\frac{n_p\tau_p^2}{\sigma^2+n_p\tau_p^2}.
$$

## Slide 39: Comparing pooling strategies

Source note: `regression-models/random-effects.qmd`

The weight $w_p$ lies between zero and one. More observations or greater between-participant variation move it toward one; more within-participant residual variation moves it toward zero. Shrinkage is thus a consequence of the joint probability model, not a correction applied after fitting unrelated participant means.

## Slide 40: Computing the three MALD summaries

Source note: `regression-models/random-effects.qmd`

This figure shows observed linguistic data for Computing the three MALD summaries.

## Slide 41: Computing the three MALD summaries

Source note: `regression-models/random-effects.qmd`

The diagonal marks equality between raw and partially pooled means. Points move toward the horizontal population center, with the amount of movement determined by the fitted variances and the information available for each listener.

## Slide 42: Keeping two kinds of variation separate

Source note: `regression-models/random-effects.qmd`

The participant standard deviation $\tau_p$ describes stable between-listener variation. The residual standard deviation $\sigma$ describes trial variation around participant and word baselines. One cannot substitute for the other: large residual variation is not persistent listener heterogeneity, and large group variation is not within-listener trial noise.

## Slide 43: Understanding exchangeability

Source note: `regression-models/random-effects.qmd`

The shared normal distribution treats participant labels as exchangeable after conditioning on included predictors. Before observing the responses, swapping two arbitrary participant labels does not change the model. If listeners differ systematically by a measured property, that property should enter the population relation; the random effects then describe remaining variation.

## Slide 44: Understanding exchangeability

Source note: `regression-models/random-effects.qmd`

An estimated deviation near zero can indicate either that a listener lies near the fitted center or that the listener's trials provide weak information and receive strong shrinkage. The estimate, its conditional uncertainty, and the number of trials must be interpreted together. The next page derives the dependence induced by the shared deviations.

## Slide 45: Random-intercept models

Source note: `regression-models/random-intercepts.qmd`

Our next step is Random-intercept models.

## Slide 46: Random-intercept models

Source note: `regression-models/random-intercepts.qmd`

The partial-pooling page gave participants and words deviations from a shared population center. A **random-intercept model** places those deviations inside a regression equation.

## Slide 47: Inserting a participant deviation

Source note: `regression-models/random-intercepts.qmd`

For trial $i$ from participant $p$, a participant-intercept model has

$$
Y_{pi}=\beta_0+b_p+\mathbf x_{pi}^{\mathsf T}\boldsymbol\beta+\varepsilon_{pi},
$$

with

$$
b_p\sim\mathcal N(0,\tau_p^2),
\qquad
\varepsilon_{pi}\sim\mathcal N(0,\sigma^2).
$$

## Slide 48: Inserting a participant deviation

Source note: `regression-models/random-intercepts.qmd`

Participant $p$ has fitted baseline $\beta_0+b_p$. The deviation changes the vertical location of the participant's regression relation; it does not change any predictor association.

## Slide 49: Deriving the induced covariance

Source note: `regression-models/random-intercepts.qmd`

Two trials from the same participant share $b_p$:

$$
Y_{pi}=\beta_0+b_p+\varepsilon_{pi},
\qquad
Y_{pi'}=\beta_0+b_p+\varepsilon_{pi'}.
$$

## Slide 50: Deriving the induced covariance

Source note: `regression-models/random-intercepts.qmd`

Under independent residuals and independence between residuals and the group deviation,

$$
\begin{aligned}
\operatorname{Cov}(Y_{pi},Y_{pi'})
&=\operatorname{Cov}(b_p+\varepsilon_{pi},
                     b_p+\varepsilon_{pi'})\\
&=\operatorname{Var}[b_p]\\
&=\tau_p^2.
\end{aligned}
$$

## Slide 51: Deriving the induced covariance

Source note: `regression-models/random-intercepts.qmd`

Conditional on $b_p$, the residuals may be independent. Marginally, before the deviation is known, the two responses are associated because they contain the same participant baseline.

## Slide 52: Adding the crossed word intercept

Source note: `regression-models/random-intercepts.qmd`

MALD trials also repeat spoken words. Give word $w$ a deviation $c_w$:

$$
Y_{pwi}=\beta_0+b_p+c_w+\varepsilon_{pwi},
$$

where

$$
b_p\sim\mathcal N(0,\tau_p^2),\qquad
c_w\sim\mathcal N(0,\tau_w^2),\qquad
\varepsilon_{pwi}\sim\mathcal N(0,\sigma^2).
$$

## Slide 53: Adding the crossed word intercept

Source note: `regression-models/random-intercepts.qmd`

Two rows that share only a participant have covariance $\tau_p^2$. Two rows that share only a word have covariance $\tau_w^2$. Rows sharing both units have covariance $\tau_p^2+\tau_w^2$ under the model's independence assumptions.

## Slide 54: Fitting the crossed model

Source note: `regression-models/random-intercepts.qmd`

The two grouping terms are crossed because participant and word identifiers recur in many combinations. The formula does not create replication absent from the table; it represents the incidence structure that the table already contains.

## Slide 55: Comparing raw and conditional participant baselines

Source note: `regression-models/random-intercepts.qmd`

This figure shows observed linguistic data for Comparing raw and conditional participant baselines.

## Slide 56: Comparing raw and conditional participant baselines

Source note: `regression-models/random-intercepts.qmd`

The participant intercept represents persistent response-speed differences. It cannot represent participant-specific lexical-frequency associations; that requires a random slope. The next page converts the fitted covariance components into model-implied correlations.

## Slide 57: Intraclass correlation

Source note: `regression-models/intraclass-correlation.qmd`

Now we turn to Intraclass correlation.

## Slide 58: Intraclass correlation

Source note: `regression-models/intraclass-correlation.qmd`

The random-intercept page showed that responses sharing a participant or word also share a modeled deviation. The **intraclass correlation coefficient (ICC)** summarizes the resulting correlation for a Gaussian random-intercept model.

## Slide 59: Deriving the crossed-unit correlations

Source note: `regression-models/intraclass-correlation.qmd`

For the MALD intercept-only model,

$$
Y_{pwi}=\beta_0+b_p+c_w+\varepsilon_{pwi},
$$

with independent components having variances $\tau_p^2$, $\tau_w^2$, and $\sigma^2$.

## Slide 60: Deriving the crossed-unit correlations

Source note: `regression-models/intraclass-correlation.qmd`

The marginal response variance is

$$
\operatorname{Var}[Y_{pwi}]
=\tau_p^2+\tau_w^2+\sigma^2.
$$

## Slide 61: Deriving the crossed-unit correlations

Source note: `regression-models/intraclass-correlation.qmd`

Two distinct trials from the same participant but different words share only $b_p$, so their covariance is $\tau_p^2$. Their correlation is

$$
\rho_p
=\frac{\tau_p^2}
{\tau_p^2+\tau_w^2+\sigma^2}.
$$

## Slide 62: Deriving the crossed-unit correlations

Source note: `regression-models/intraclass-correlation.qmd`

Two trials on the same word from different participants instead have

$$
\rho_w
=\frac{\tau_w^2}
{\tau_p^2+\tau_w^2+\sigma^2}.
$$

## Slide 63: Deriving the crossed-unit correlations

Source note: `regression-models/intraclass-correlation.qmd`

If two rows share both participant and word, the fitted correlation is

$$
\rho_{pw}
=\frac{\tau_p^2+\tau_w^2}
{\tau_p^2+\tau_w^2+\sigma^2}
=\rho_p+\rho_w.
$$

## Slide 64: Substituting the MALD variance estimates

Source note: `regression-models/intraclass-correlation.qmd`

The fitted participant ICC is 0.1834, the item ICC is 0.1522, and sharing both units gives correlation 0.3356. These values are computed from the correct-response MALD subset rather than supplied as schematic quantities.

## Slide 65: Relating the correlations to replication

Source note: `regression-models/intraclass-correlation.qmd`

This figure shows observed linguistic data for Relating the correlations to replication.

## Slide 66: Relating the correlations to replication

Source note: `regression-models/intraclass-correlation.qmd`

Positive ICCs mean that repeated rows from one unit contain less independent information than the same number of rows from distinct units. Additional trials can estimate an observed participant's or word's baseline more precisely. Additional participants or words provide replication across the corresponding population.

## Slide 67: Keeping the interpretation model-specific

Source note: `regression-models/intraclass-correlation.qmd`

Adding predictors can change every variance component. An intercept-only ICC and an ICC conditional on frequency, duration, and trial order need not agree. Random slopes also make the covariance depend on predictor values, so one constant ICC no longer describes every trial pair. Logistic and Poisson mixed models require further scale choices because they do not estimate a Gaussian residual variance on the response scale.

## Slide 68: Keeping the interpretation model-specific

Source note: `regression-models/intraclass-correlation.qmd`

These ICCs are properties of this fitted Gaussian intercept-only model and its correct-response subset. Report the formula and variance components with the ratios. The next page examines the partially pooled group deviations returned by the fitted model.

## Slide 69: Group-specific estimates

Source note: `regression-models/random-effect-estimates.qmd`

Now we turn to Group-specific estimates.

## Slide 70: Group-specific estimates

Source note: `regression-models/random-effect-estimates.qmd`

The partial-pooling page explained why group deviations are estimated jointly with a population distribution. A fitted multilevel model gives each observed group a partially pooled estimate of its deviation from the population relation. In a frequentist `lme4` fit, `ranef()` reports these values as **conditional modes**.

## Slide 71: Group-specific estimates

Source note: `regression-models/random-effect-estimates.qmd`

They are useful summaries of the fitted group structure. They are not raw group means, independently estimated coefficients, or error-free rankings.

## Slide 72: Defining the conditional mode

Source note: `regression-models/random-effect-estimates.qmd`

For participant $p$, collect the intercept and frequency-slope deviations in $\mathbf b_p$. Conditional on fitted population coefficients and variance components, the estimate is

$$
\widehat{\mathbf b}_p
=\operatorname*{arg\,max}_{\mathbf b_p}
\left{
\log f(\mathbf y_p\mid\mathbf b_p,\widehat{\boldsymbol\beta},\widehat\sigma)
+\log g(\mathbf b_p\mid\widehat{\boldsymbol\Sigma}_p)
\right}.
$$

## Slide 73: Defining the conditional mode

Source note: `regression-models/random-effect-estimates.qmd`

The first term rewards values that fit the participant's trials. The second rewards values plausible under the estimated participant distribution. Their combination produces partial pooling.

## Slide 74: Defining the conditional mode

Source note: `regression-models/random-effect-estimates.qmd`

For a simple intercept-only normal model, the same balance appears in

$$
\widehat b_p
=\frac{n_p\tau_p^2}{n_p\tau_p^2+\sigma^2}
(\overline y_p-\beta_0).
$$

## Slide 75: Defining the conditional mode

Source note: `regression-models/random-effect-estimates.qmd`

The MALD focal model uses a two-dimensional participant vector, so software performs the corresponding multivariate calculation.

## Slide 76: Extracting estimates and conditional uncertainty

Source note: `regression-models/random-effect-estimates.qmd`

The participant-level standard deviation in `VarCorr(fit)` describes variation across the modeled participant population. A row's `conditional_se` instead describes local uncertainty for one participant's conditional mode, conditional on the fitted population parameters. The two quantities answer different questions.

## Slide 77: Extracting estimates and conditional uncertainty

Source note: `regression-models/random-effect-estimates.qmd`

This figure shows observed linguistic data for Extracting estimates and conditional uncertainty.

## Slide 78: Extracting estimates and conditional uncertainty

Source note: `regression-models/random-effect-estimates.qmd`

The intervals overlap heavily through much of the ordering. A participant placed above another by point estimate need not have a stably higher baseline. Rank uncertainty is part of the result.

## Slide 79: Distinguishing deviations from group-specific coefficients

Source note: `regression-models/random-effect-estimates.qmd`

For participant $p$, the group-specific intercept is

$$
\widehat\beta_0+\widehat b_{0p},
$$

and the group-specific frequency slope is

$$
\widehat\beta_f+\widehat b_{1p}.
$$

`ranef(fit)` returns the deviations $\widehat b_{0p}$ and $\widehat b_{1p}$; `coef(fit)` adds the population coefficients.

## Slide 80: Distinguishing deviations from group-specific coefficients

Source note: `regression-models/random-effect-estimates.qmd`

Both depend on the predictor reference points. Here the intercept refers to mean log frequency, mean log duration, and mean trial order because the predictors were standardized.

## Slide 81: Distinguishing deviations from group-specific coefficients

Source note: `regression-models/random-effect-estimates.qmd`

Testing every conditional mode against zero would replace a population model with many separate hypotheses and would create a multiple-comparison problem. If a particular listener or dialect is a planned scientific target, that target should enter the population relation explicitly. The modes here describe modeled heterogeneity among sampled MALD listeners; they are not independently observed traits. The next page examines the participant-specific frequency associations.

## Slide 82: Random slopes

Source note: `regression-models/random-slopes.qmd`

Our next step is Random slopes.

## Slide 83: Random slopes

Source note: `regression-models/random-slopes.qmd`

The random-intercept model allows participant baselines to vary while holding the lexical-frequency association constant. A random-slope model also lets that association vary across participants.

## Slide 84: Adding a participant-specific association

Source note: `regression-models/random-slopes.qmd`

For MALD trial $i$, participant $p$, and word $w$, write

$$
Y_{pwi}
=\beta_0+b_{0p}
+(\beta_f+b_{1p})x_{wi}^{(f)}
+\beta_d x_{wi}^{(d)}
+\beta_t x_{pwi}^{(t)}
+c_w+\varepsilon_{pwi}.
$$

## Slide 85: Adding a participant-specific association

Source note: `regression-models/random-slopes.qmd`

The population frequency association is $\beta_f$. Participant $p$ has association

$$
\beta_f+b_{1p}.
$$

## Slide 86: Adding a participant-specific association

Source note: `regression-models/random-slopes.qmd`

The intercept and slope deviations are modeled jointly:

$$
\begin{pmatrix}b_{0p}\\b_{1p}\end{pmatrix}
\sim
\mathcal N
\left(
\begin{pmatrix}0\\0\end{pmatrix},
\boldsymbol\Sigma_p
\right).
$$

## Slide 87: Adding a participant-specific association

Source note: `regression-models/random-slopes.qmd`

The frequency-slope standard deviation describes how much the fitted lexical-frequency association varies across the participant population.

## Slide 88: Checking that the design contains the contrast

Source note: `regression-models/random-slopes.qmd`

A participant-specific frequency association requires frequency variation within participants. A word has one lexical frequency, so repeated responses to that word cannot identify an item-specific frequency slope.

## Slide 89: Checking that the design contains the contrast

Source note: `regression-models/random-slopes.qmd`

Every participant spans a nonzero range of standardized frequency, whereas the maximum within-item range is 0.0. The data thus support participant frequency slopes but not word-specific frequency slopes.

## Slide 90: Comparing raw and fitted participant relations

Source note: `regression-models/random-slopes.qmd`

We display six participants selected across the fitted slope distribution. Points are within-participant raw bin means. Lines include participant intercept and frequency-slope deviations, set duration and trial order to their standardized means, and set the word effect to zero.

## Slide 91: Comparing raw and fitted participant relations

Source note: `regression-models/random-slopes.qmd`

This figure shows observed linguistic data for Comparing raw and fitted participant relations.

## Slide 92: How the dependence changes

Source note: `regression-models/random-slopes.qmd`

Two trials from participant $p$ share $b_{0p}$, and their covariance also contains the slope contribution

$$
x_{pwi}^{(f)}x_{pwi'}^{(f)}\tau_1^2
$$

plus intercept-slope covariance terms when the deviations are correlated.

## Slide 93: How the dependence changes

Source note: `regression-models/random-slopes.qmd`

Trial pairs at different frequency values thus need not have the same covariance. A constant participant ICC no longer summarizes every pair.

## Slide 94: How the dependence changes

Source note: `regression-models/random-slopes.qmd`

The model still imposes one population frequency coefficient. The random slope states that this average is incomplete as a description of individual listeners. Its inclusion is licensed by both the within-participant frequency range and the goal of generalizing the frequency association across listeners. The next page examines the covariance between participant baselines and these frequency slopes.

## Slide 95: Random-effect correlations

Source note: `regression-models/random-effect-correlations.qmd`

The next topic is Random-effect correlations.

## Slide 96: Random-effect correlations

Source note: `regression-models/random-effect-correlations.qmd`

The random-slope page gave each MALD participant a baseline deviation and a lexical-frequency-slope deviation. The two deviations may themselves be related across the participant population.

## Slide 97: Writing one joint distribution

Source note: `regression-models/random-effect-correlations.qmd`

For participant $p$, model

$$
\begin{pmatrix}
b_{0p}\\
b_{1p}
\end{pmatrix}
\sim
\mathcal N
\left(
\begin{pmatrix}0\\0\end{pmatrix},
\begin{pmatrix}
\tau_0^2 & \rho\tau_0\tau_1\\
\rho\tau_0\tau_1 & \tau_1^2
\end{pmatrix}
\right).
$$

## Slide 98: Writing one joint distribution

Source note: `regression-models/random-effect-correlations.qmd`

The parameter $\rho$ is the correlation between participant intercept and frequency-slope deviations. A positive value means that participants above the population baseline tend to have frequency slopes above the population slope. The sign of *above* depends on the response and predictor coding.

## Slide 99: Writing one joint distribution

Source note: `regression-models/random-effect-correlations.qmd`

If $\rho=0$, the model treats the deviations as uncorrelated. It does not set either variance to zero; participants may still vary substantially in both dimensions.

## Slide 100: Fitting the covariance on centered predictors

Source note: `regression-models/random-effect-correlations.qmd`

The fitted correlation is 0.152. Its meaning is tied to the intercept at mean log frequency, mean log duration, and mean trial order. The fitted slope standard deviation is only 0.0121 log-response-time units, so a strong substantive story about the correlation would outrun the estimated slope variation.

## Slide 101: Why centering changes the correlation

Source note: `regression-models/random-effect-correlations.qmd`

Let the centered predictor be

$$
x_i^{c}=x_i-c.
$$

Because $x_i=x_i^c+c$, the group-specific part becomes

$$
b_{0p}+b_{1p}x_i
=(b_{0p}+cb_{1p})+b_{1p}x_i^c.
$$

## Slide 102: Why centering changes the correlation

Source note: `regression-models/random-effect-correlations.qmd`

The new intercept deviation is thus

$$
b'_{0p}=b_{0p}+cb_{1p}.
$$

## Slide 103: Why centering changes the correlation

Source note: `regression-models/random-effect-correlations.qmd`

Its covariance with the unchanged slope is

$$
\operatorname{Cov}(b'_{0p},b_{1p})
=\operatorname{Cov}(b_{0p},b_{1p})
+c\operatorname{Var}[b_{1p}].
$$

## Slide 104: Why centering changes the correlation

Source note: `regression-models/random-effect-correlations.qmd`

Centering changes the point on each fitted line called the intercept. It can thus change the intercept-slope correlation without changing any fitted line or response.

## Slide 105: Why centering changes the correlation

Source note: `regression-models/random-effect-correlations.qmd`

This figure shows observed linguistic data for Why centering changes the correlation.

## Slide 106: Why centering changes the correlation

Source note: `regression-models/random-effect-correlations.qmd`

The points are conditional modes, not independently observed participant traits, and their empirical scatter is not a replacement for $\widehat\rho$ from the covariance model. The display makes the fitted group dimensions visible while the model accounts for shrinkage and conditional uncertainty.

## Slide 107: Why centering changes the correlation

Source note: `regression-models/random-effect-correlations.qmd`

A correlation near an endpoint can reflect a stable population relation or weak information in an over-rich covariance structure. It should be interpreted with the two standard deviations, the number of participant levels, and the singularity diagnostic. The next page develops that diagnostic directly.

## Slide 108: Singular fits

Source note: `regression-models/singular-fits.qmd`

Next, we take up Singular fits.

## Slide 109: Singular fits

Source note: `regression-models/singular-fits.qmd`

The random-effects-correlation page represented intercept and slope deviations with a covariance matrix. A **singular fit** occurs when the estimated covariance matrix has lower rank than the formula allows.

## Slide 110: Rank and covariance dimensions

Source note: `regression-models/singular-fits.qmd`

Suppose a grouping term requests $q$ random-effect dimensions with covariance matrix $\boldsymbol\Sigma$. A nonsingular fit requires

$$
\operatorname{rank}(\boldsymbol\Sigma)=q.
$$

## Slide 111: Rank and covariance dimensions

Source note: `regression-models/singular-fits.qmd`

Writing the eigendecomposition as

$$
\boldsymbol\Sigma
=\mathbf Q\boldsymbol\Lambda\mathbf Q^{\mathsf T},
$$

the rank is the number of positive eigenvalues in $\boldsymbol\Lambda$.

## Slide 112: Rank and covariance dimensions

Source note: `regression-models/singular-fits.qmd`

If one eigenvalue is zero, one linear combination of the requested deviations has no fitted variation and

$$
\operatorname{rank}(\boldsymbol\Sigma)<q.
$$

## Slide 113: Rank and covariance dimensions

Source note: `regression-models/singular-fits.qmd`

In a two-dimensional intercept-slope model, singularity can arise when a variance reaches zero or when the correlation reaches an endpoint. In a larger structure, a collapsed dimension may involve a combination of several terms and may not be obvious from any one printed variance.

## Slide 114: Fitting a predeclared MALD stress test

Source note: `regression-models/singular-fits.qmd`

The stress-test model asks participants to vary in an intercept, frequency slope, duration slope, trial-order slope, and frequency-by-duration interaction slope. It also gives words a trial-order slope. The fixed interaction remains in both models because the diagnostic concerns the group covariance structure.

## Slide 115: Fitting a predeclared MALD stress test

Source note: `regression-models/singular-fits.qmd`

The model requesting participant interaction-slope variation is singular. Removing only that unsupported random slope gives the prespecified nonsingular revision. This comparison does not remove the fixed frequency-by-duration interaction or the item trial-order slope.

## Slide 116: Inspecting the fitted dimensions

Source note: `regression-models/singular-fits.qmd`

`rePCA()` rotates each fitted covariance matrix into orthogonal directions. The returned standard deviations are the square roots of the rotated, residual-scaled eigenvalues.

## Slide 117: Inspecting the fitted dimensions

Source note: `regression-models/singular-fits.qmd`

The final participant direction in the larger model collapses to the boundary. Because the rotated directions are linear combinations, this fact is stronger than merely inspecting whether one named standard deviation looks small.

## Slide 118: Inspecting the fitted dimensions

Source note: `regression-models/singular-fits.qmd`

This figure shows observed linguistic data for Inspecting the fitted dimensions.

## Slide 119: Separating singularity from convergence

Source note: `regression-models/singular-fits.qmd`

An optimizer can reach a boundary optimum successfully, producing a singular fit without a convergence failure. Conversely, a nonsingular covariance estimate can accompany an optimizer warning. `isSingular()` and the optimizer diagnostics answer different questions and both should be checked.

## Slide 120: Separating singularity from convergence

Source note: `regression-models/singular-fits.qmd`

A singular fit should send us back to the design: which predictor contrasts vary within which groups, how many group levels support the covariance, and which population variation the scientific claim requires. Plausible responses include removing an unsupported correlation, removing an unsupported slope, collecting more within-group contrasts, or using a regularized model. These moves encode different population assumptions.

## Slide 121: Separating singularity from convergence

Source note: `regression-models/singular-fits.qmd`

The MALD revision above follows a predeclared design audit: it removes only the collapsed participant interaction slope. It is not a general stepwise-selection recipe, and it should not be used to search for a preferred fixed-effect conclusion. The next page carries the same group-variation logic to a binary linguistic response.

## Slide 122: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The next topic is Generalized linear mixed models.

## Slide 123: SuperTelicity: the empirical object

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The data source is SuperTelicity cloze release. It provides participant-by-item cloze choices for aspectual inference.

## Slide 124: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The Gaussian pages represented repeated observations with group-specific deviations. A **generalized linear mixed model (GLMM)** keeps that group structure while replacing the Gaussian response with a distribution and link appropriate to the outcome.

## Slide 125: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

We use the cloze judgments from White, Cao, Grimm, and Glass's working manuscript *The Preservation of Telicity under Sense Locality* (n.d.) and the immutable CC BY-SA teaching table prepared from its credential-gated source release at commit `e45277ce466719c1a03629f6ccf1e12db9904421`. On each trial, a participant selected *in* or *for*, a numeral, and a time unit for an event description. The preposition is a noisy behavioral measure related to telicity; it is not a direct semantic label because temporal modifiers can receive habitual or other interpretations.

## Slide 126: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

All participant and trial totals below are computed from the pinned CSV. We do not transfer recruitment counts from an unlinked working draft to the released teaching table; all fitted quantities use the release itself.

## Slide 127: Combining a Bernoulli response with group variation

Source note: `regression-models/generalized-linear-mixed-models.qmd`

Let $Y_i=1$ when trial $i$ has an *in* response. Conditional on the random effects,

$$
Y_i\mid u_{p[i]},v_{w[i]},s_{q[i]}
\sim\operatorname{Bernoulli}(\pi_i),
$$

and

$$
\operatorname{logit}(\pi_i)
=\log\frac{\pi_i}{1-\pi_i}
=\mathbf x_i^{\mathsf T}\boldsymbol\beta
+u_{p[i]}+v_{w[i]}+s_{q[i]}.
$$

## Slide 128: Combining a Bernoulli response with group variation

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The vector $\mathbf x_i$ contains verb class, contentfulness, and their interaction. Participant $p$, verb $w$, and sentence $q$ receive independent random intercepts:

$$
u_p\sim\mathcal N(0,\tau_p^2),\qquad
v_w\sim\mathcal N(0,\tau_w^2),\qquad
s_q\sim\mathcal N(0,\tau_q^2).
$$

## Slide 129: Combining a Bernoulli response with group variation

Source note: `regression-models/generalized-linear-mixed-models.qmd`

Conditional on these deviations, the Bernoulli likelihood is

$$
p(\mathbf y\mid\boldsymbol\pi)
=\prod_i \pi_i^{y_i}(1-\pi_i)^{1-y_i}.
$$

## Slide 130: Combining a Bernoulli response with group variation

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The inverse logit keeps every fitted value inside the probability interval. The random intercepts represent which rows share persistent participant, verb, or sentence tendencies.

## Slide 131: Fitting the crossed-intercept teaching model

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The course formula is deliberately smaller than the source analysis, which uses a richer Bayesian random structure involving additional participant, lexical, duration, list, and argument-form terms. This GLMM illustrates the architecture; it does not replace the manuscript's model.

## Slide 132: Raw sentence proportions and fitted probabilities

Source note: `regression-models/generalized-linear-mixed-models.qmd`

One raw point below is the proportion of *in* responses for one sentence. The fitted points set all three random intercepts to zero, so they describe a participant, verb, and sentence at the center of the fitted link-scale distributions.

## Slide 133: Raw sentence proportions and fitted probabilities

Source note: `regression-models/generalized-linear-mixed-models.qmd`

This figure shows observed linguistic data for Raw sentence proportions and fitted probabilities.

## Slide 134: Raw sentence proportions and fitted probabilities

Source note: `regression-models/generalized-linear-mixed-models.qmd`

With sum coding, the result-minus-manner contrast averaged over the contentfulness coding is The interaction terms modify this comparison at particular contentfulness levels. The coefficient remains a conditional log-odds contrast: it compares trials with the same random-effect values.

## Slide 135: Conditional and population-averaged prediction

Source note: `regression-models/generalized-linear-mixed-models.qmd`

A prediction at zero random effects is not generally the probability for a randomly drawn participant, verb, and sentence. Let $B$ be the sum of the three independent intercepts. Its variance is

$$
\tau_B^2=\tau_p^2+\tau_w^2+\tau_q^2.
$$

## Slide 136: Conditional and population-averaged prediction

Source note: `regression-models/generalized-linear-mixed-models.qmd`

For fixed-effect location $\eta$, the random-effect-averaged probability is

$$
\mathbb{P}(Y=1\mid\mathbf x)
=\int_{-\infty}^{\infty}
\operatorname{logit}^{-1}(\eta+b)
\phi(b;0,\tau_B^2)\,db.
$$

Because the inverse logit is nonlinear,

$$
\operatorname{E}_{B}
\left[\operatorname{logit}^{-1}(\eta+B)\right]
\ne
\operatorname{logit}^{-1}(\eta)
$$

in general.

## Slide 137: Conditional and population-averaged prediction

Source note: `regression-models/generalized-linear-mixed-models.qmd`

This figure shows observed linguistic data for Conditional and population-averaged prediction.

## Slide 138: Conditional and population-averaged prediction

Source note: `regression-models/generalized-linear-mixed-models.qmd`

Predictions for returning participants or observed lexical material may condition on their fitted deviations. Predictions for new participants or verbs cannot reuse deviations from observed groups. Every response-scale summary should state which target it uses.

## Slide 139: Conditional and population-averaged prediction

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The release includes missing numerals on many trials, so this teaching analysis uses the complete binary preposition response rather than conditioning on a selected duration. Together with the restricted random structure and the release/manuscript participant mismatch, this scope keeps the page aligned with what the connected data can support. The next page applies the same logic to an ordered response.

## Slide 140: Ordinal mixed models

Source note: `regression-models/ordinal-mixed-models.qmd`

Now we turn to Ordinal mixed models.

## Slide 141: MegaVeridicality: the empirical object

Source note: `regression-models/ordinal-mixed-models.qmd`

The data source is White and Rawlins (2018), MegaVeridicality. It provides ordinal inference judgments crossed with verb and respondent.

## Slide 142: Ordinal mixed models

Source note: `regression-models/ordinal-mixed-models.qmd`

An ordinal mixed model combines the cumulative link introduced for ordinal regression with the group deviations introduced for generalized linear mixed models.

## Slide 143: Ordinal mixed models

Source note: `regression-models/ordinal-mixed-models.qmd`

We use **MegaVeridicality v1**, the *no*, *maybe*, and *yes* veridicality judgments described by White and Rawlins (2018) and distributed through the official MegaVeridicality project. Each row records one response to a low-content sentence containing a clause-embedding verb. The direct task asks whether the embedded event happened after an assertion; the conditional task places that assertion in a conditional antecedent.

## Slide 144: Ordinal mixed models

Source note: `regression-models/ordinal-mixed-models.qmd`

The two tasks recruited separate samples. Numeric participant labels recur across tasks, so the prepared table prefixes them with the task before constructing `respondent_id`. Treating the repeated numbers as the same people would invent a dependence relation not present in the study.

## Slide 145: A fixed teaching subset

Source note: `regression-models/ordinal-mixed-models.qmd`

The full active/native table contains 14951 responses from 375 active-frame verbs. Fitting the correlated-slope ordinal mixed model to that table makes routine course builds unnecessarily slow. We therefore use a fixed teaching subset: all 2990 responses for the 75 verbs assigned to fold 1 by the release’s salted verb-hash partition. The partition was constructed without reference to the response values. It retains all four polarity-by-task conditions for every selected verb and all 319 task-specific respondents.

## Slide 146: A fixed teaching subset

Source note: `regression-models/ordinal-mixed-models.qmd`

This is a computational teaching subset, not a probability sample from the English clause-embedding lexicon. The estimates describe the selected verbs and should not be reported as full-data estimates. The model also analyzes raw ordered responses; it does not reproduce White and Rawlins's participant-threshold normalization, derived veridicality and factivity measures, or responsivity analysis.

## Slide 147: Retaining the ordered response

Source note: `regression-models/ordinal-mixed-models.qmd`

For response $Y_i$ and cutpoint $c$, the cumulative-logit model is

$$
\operatorname{logit}\mathbb{P}(Y_i\le c)
=\kappa_c-\eta_i,
\qquad c\in\{1,2\}.
$$

## Slide 148: Retaining the ordered response

Source note: `regression-models/ordinal-mixed-models.qmd`

The location predictor is

$$
\eta_i
=\mathbf x_i^{\mathsf T}\boldsymbol\beta
+\mathbf z_{v[i]}^{\mathsf T}\mathbf b_{v[i]}
+u_{r[i]}.
$$

## Slide 149: Retaining the ordered response

Source note: `regression-models/ordinal-mixed-models.qmd`

The fixed part contains polarity, task, and their interaction. Verbs receive correlated intercept, polarity-slope, and task-slope deviations; respondents receive intercept deviations. For verb $v$ and respondent $r$,

$$
\mathbf b_v\sim\mathcal N(\mathbf 0,\boldsymbol\Sigma_v),
\qquad
u_r\sim\mathcal N(0,\tau_r^2).
$$

With logistic cumulative distribution $F$, the three category probabilities are

$$
\mathbb{P}(Y_i=\text{no})=F(\kappa_1-\eta_i),
$$

$$
\mathbb{P}(Y_i=\text{maybe})
=F(\kappa_2-\eta_i)-F(\kappa_1-\eta_i),
$$

and

$$
\mathbb{P}(Y_i=\text{yes})=1-F(\kappa_2-\eta_i).
$$

## Slide 150: Retaining the ordered response

Source note: `regression-models/ordinal-mixed-models.qmd`

The ordered thresholds preserve category order without assigning equal numerical spacing to the labels.

## Slide 151: Fitting the verb-and-respondent model

Source note: `regression-models/ordinal-mixed-models.qmd`

The threshold and fixed-effect estimates are computed directly from the raw ordered responses: These values describe one fitted teaching model. They do not define a latent taxonomy of clause-embedding verbs.

## Slide 152: Comparing observed and fitted category probabilities

Source note: `regression-models/ordinal-mixed-models.qmd`

The fitted points below set verb and respondent deviations to zero. The bars are raw teaching-subset response proportions for the same polarity-by-task cells. Thus the figure compares raw and fitted quantities from the same 75 verbs.

## Slide 153: Comparing observed and fitted category probabilities

Source note: `regression-models/ordinal-mixed-models.qmd`

This figure shows observed linguistic data for Comparing observed and fitted category probabilities.

## Slide 154: Stating which groups are represented in a prediction

Source note: `regression-models/ordinal-mixed-models.qmd`

A prediction for an observed respondent and verb can condition on both estimated deviations. A prediction for a new respondent judging an observed verb may condition on the verb deviation but cannot reuse an observed respondent effect. A prediction for a new respondent and new verb must handle both group distributions.

## Slide 155: Stating which groups are represented in a prediction

Source note: `regression-models/ordinal-mixed-models.qmd`

Setting both deviations to zero gives a location at the center of the link-scale distributions, as in the figure. Averaging category probabilities over either distribution generally produces different response-scale probabilities because the inverse cumulative-logit transformation is nonlinear. A reported probability must thus state which groups are represented in the target.

## Slide 156: What the fitted location can and cannot represent

Source note: `regression-models/ordinal-mixed-models.qmd`

A positive location shift moves probability toward higher ordered responses. It changes category probabilities; it does not add a fixed number of slider points.

## Slide 157: What the fitted location can and cannot represent

Source note: `regression-models/ordinal-mixed-models.qmd`

The verb random slopes allow the polarity and task associations to vary across observed verbs. The respondent random intercept allows overall response location to vary across respondents. It cannot represent every response style: respondents might also differ in threshold spacing or in how often they use *maybe*. A location-intercept model leaves those possibilities outside its structure.

## Slide 158: What the fitted location can and cannot represent

Source note: `regression-models/ordinal-mixed-models.qmd`

White and Rawlins normalize responses and study derived veridicality, factivity, responsivity, and clause-selection patterns. The course model instead analyzes raw ordered responses as a function of polarity and task. It is related to the source design, but it is not a reproduction of the paper's normalization or responsivity analysis. The next worked page asks whether the fixed interaction predicts judgments for verbs absent from fitting.

## Slide 159: MegaVeridicality: prediction for unseen verbs

Source note: `regression-models/aspectual-similarity-example.qmd`

Now we turn to MegaVeridicality: prediction for unseen verbs.

## Slide 160: MegaVeridicality: prediction for unseen verbs

Source note: `regression-models/aspectual-similarity-example.qmd`

The preceding ordinal-mixed-model page used MegaVeridicality to describe respondent and verb heterogeneity. This worked analysis asks a different question: does the polarity-by-task interaction improve response probabilities for clause-embedding verbs absent from fitting?

## Slide 161: MegaVeridicality: prediction for unseen verbs

Source note: `regression-models/aspectual-similarity-example.qmd`

The data remain the raw ordered judgments from White and Rawlins (2018) and the official MegaVeridicality project release. One row is one *no*, *maybe*, or *yes* response. The validation folds are frozen by verb before any model is fit.

## Slide 162: From ordered responses to a likelihood

Source note: `regression-models/aspectual-similarity-example.qmd`

For ordered category $k$ and fixed-effect location $\eta_i$, define

$$
\mathbb{P}(Y_i=k\mid\mathbf x_i)
=F(\kappa_k-\eta_i)-F(\kappa_{k-1}-\eta_i),
$$

where $F$ is the logistic cumulative distribution, $\kappa_0=-\infty$, and $\kappa_3=\infty$.

## Slide 163: From ordered responses to a likelihood

Source note: `regression-models/aspectual-similarity-example.qmd`

The likelihood is

$$
L(\boldsymbol\beta,\boldsymbol\kappa)
=\prod_i\mathbb{P}(Y_i=y_i\mid\mathbf x_i),
$$

and its mean log score on held-out judgments is

$$
\frac{1}{n_{\mathrm{test}}}
\sum_{i\in\mathrm{test}}
\log\mathbb{P}(Y_i=y_i\mid\mathbf x_i).
$$

## Slide 164: From ordered responses to a likelihood

Source note: `regression-models/aspectual-similarity-example.qmd`

Larger values indicate that a model assigns more probability to the observed held-out responses.

## Slide 165: Preparing the frozen verb folds

Source note: `regression-models/aspectual-similarity-example.qmd`

Every judgment for a verb belongs to the same fold. When fold $k$ is assessed, the training data contain no row from any fold-$k$ verb. This is a lexical-unit holdout, not a random row split.

## Slide 166: Showing the population model on the response scale

Source note: `regression-models/aspectual-similarity-example.qmd`

The full-data display below is descriptive. It compares raw cell proportions with a population cumulative-logit model containing the interaction.

## Slide 167: Showing the population model on the response scale

Source note: `regression-models/aspectual-similarity-example.qmd`

This figure shows observed linguistic data for Showing the population model on the response scale.

## Slide 168: Showing the population model on the response scale

Source note: `regression-models/aspectual-similarity-example.qmd`

The mixed model on the preceding page adds respondent and verb deviations to this location structure. Those deviations are essential for describing observed heterogeneity. Every assessment verb is new, so we compare population cumulative-link models and ask whether the fixed interaction transfers.

## Slide 169: Comparing additive and interaction models by held-out verb

Source note: `regression-models/aspectual-similarity-example.qmd`

The row-weighted interaction gain is computed from the held-out folds:

## Slide 170: Comparing additive and interaction models by held-out verb

Source note: `regression-models/aspectual-similarity-example.qmd`

This figure shows observed linguistic data for Comparing additive and interaction models by held-out verb.

## Slide 171: Comparing additive and interaction models by held-out verb

Source note: `regression-models/aspectual-similarity-example.qmd`

The interaction improves the mean log score in every frozen fold, but the row-weighted gain is small. Thus the interaction has consistent predictive support while the additive model remains a live comparison. The result does not classify verbs, estimate respondent variation, or reproduce the paper's normalized responsivity analysis. It asks one narrow question about transferring a population interaction to unseen verbs.

## Slide 172: The Laplace approximation

Source note: `regression-models/laplace-approximation.qmd`

The next topic is The Laplace approximation.

## Slide 173: The Laplace approximation

Source note: `regression-models/laplace-approximation.qmd`

A generalized linear mixed model contains random effects that are not observed directly. The response likelihood is conditional on their values, and the model assigns those values a population distribution. A likelihood for the observed responses must thus average over every possible random-effect value.

## Slide 174: The Laplace approximation

Source note: `regression-models/laplace-approximation.qmd`

This integral usually has no elementary form for a logistic mixed model. The **Laplace approximation** replaces the log integrand with a quadratic near its highest point. We expose that computation with one participant intercept from the SuperTelicity release introduced on the GLMM page.

## Slide 175: Why the integral appears

Source note: `regression-models/laplace-approximation.qmd`

For participant $p$, let $\mathbf y_p$ denote the binary preposition choices and $b_p$ the participant intercept. Conditional on $b_p$, the participant likelihood is

$$
p(\mathbf y_p\mid b_p,\boldsymbol\beta).
$$

## Slide 176: Why the integral appears

Source note: `regression-models/laplace-approximation.qmd`

The group model supplies the density $f_B(b_p\mid\tau)$. The observed-data contribution is

$$
p(\mathbf y_p\mid\boldsymbol\beta,\tau)
=\int_{-\infty}^{\infty}
p(\mathbf y_p\mid b_p,\boldsymbol\beta)
f_B(b_p\mid\tau)\,db_p.
$$

## Slide 177: Why the integral appears

Source note: `regression-models/laplace-approximation.qmd`

Integration adds support over every intercept value. Selecting only the best-fitting intercept would omit uncertainty about that latent value.

## Slide 178: Expanding the log integrand

Source note: `regression-models/laplace-approximation.qmd`

Define

$$
h(b)
=\log p(\mathbf y_p\mid b,\boldsymbol\beta)
+\log f_B(b\mid\tau).
$$

## Slide 179: Expanding the log integrand

Source note: `regression-models/laplace-approximation.qmd`

Let $\widehat b$ maximize $h(b)$. At the mode,

$$
h'(\widehat b)=0.
$$

## Slide 180: Expanding the log integrand

Source note: `regression-models/laplace-approximation.qmd`

The second-order Taylor expansion is

$$
h(b)
\approx h(\widehat b)
+h'(\widehat b)(b-\widehat b)
+\frac{1}{2}h''(\widehat b)(b-\widehat b)^2.
$$

## Slide 181: Expanding the log integrand

Source note: `regression-models/laplace-approximation.qmd`

The first-derivative term vanishes at the mode. Writing

$$
H=-h''(\widehat b)>0
$$

gives

$$
h(b)
\approx h(\widehat b)-\frac{H}{2}(b-\widehat b)^2.
$$

## Slide 182: Expanding the log integrand

Source note: `regression-models/laplace-approximation.qmd`

Exponentiating produces a normal-shaped approximation whose integral is

$$
\int \exp\{h(b)\}\,db
\approx
\exp\{h(\widehat b)\}
\sqrt{\frac{2\pi}{H}}.
$$

## Slide 183: Expanding the log integrand

Source note: `regression-models/laplace-approximation.qmd`

Equivalently,

$$
\log L
\approx h(\widehat b)
+\frac{1}{2}\log(2\pi)
-\frac{1}{2}\log H.
$$

## Slide 184: Expanding the log integrand

Source note: `regression-models/laplace-approximation.qmd`

The height records support at the conditional mode. The curvature records how quickly support falls away from it.

## Slide 185: Constructing the SuperTelicity integrand

Source note: `regression-models/laplace-approximation.qmd`

The complete teaching GLMM has participant, verb, and sentence intercepts. To make the integral one-dimensional and visible, this page fits a declared computational restriction with only the participant intercept.

## Slide 186: Constructing the SuperTelicity integrand

Source note: `regression-models/laplace-approximation.qmd`

The selected participant has 42 observed trials. This count and every likelihood quantity below come from the release.

## Slide 187: Comparing the exact integral with its local approximation

Source note: `regression-models/laplace-approximation.qmd`

Numerical integration is stabilized by subtracting the log integrand at the mode before exponentiation.

## Slide 188: Comparing the exact integral with its local approximation

Source note: `regression-models/laplace-approximation.qmd`

The small difference is an empirical computation diagnostic for these observed trials. It is not an invented likelihood example and does not guarantee equal accuracy for every participant or for the higher-dimensional crossed model.

## Slide 189: Comparing the exact integral with its local approximation

Source note: `regression-models/laplace-approximation.qmd`

This figure shows observed linguistic data for Comparing the exact integral with its local approximation.

## Slide 190: Comparing the exact integral with its local approximation

Source note: `regression-models/laplace-approximation.qmd`

The approximation is a computational method, not a new response model. It does not add a predictor, repair a missing random slope, or make an inappropriate link valid. It tends to be most accurate when the integrand is concentrated and roughly symmetric near its mode; sparse groups, rare responses, boundary variances, or strong asymmetry may make the local quadratic less adequate.

## Slide 191: Comparing the exact integral with its local approximation

Source note: `regression-models/laplace-approximation.qmd`

The one-intercept restriction exists only to expose the calculation. The crossed participant, verb, and sentence GLMM remains the scientific teaching model for SuperTelicity.

## Slide 192: Poisson mixed-effects models

Source note: `regression-models/poisson-mixed-models.qmd`

Now we turn to Poisson mixed-effects models.

## Slide 193: UCCA: the empirical object

Source note: `regression-models/poisson-mixed-models.qmd`

The data source is Sulem, Abend, and Rappoport (2015), UCCA French-English 20K. It provides aligned French and English passages with graph-derived Scene counts.

## Slide 194: Poisson mixed-effects models

Source note: `regression-models/poisson-mixed-models.qmd`

We now combine Poisson regression, an exposure offset, and a random intercept in an analysis of aligned linguistic graphs.

## Slide 195: Poisson mixed-effects models

Source note: `regression-models/poisson-mixed-models.qmd`

Sulem, Abend, and Rappoport's French-English UCCA study compares independently annotated passages from *Twenty Thousand Leagues Under the Sea*. The annotation follows Universal Conceptual Cognitive Annotation (UCCA). A UCCA Scene contains a Process or State main relation; it is not simply a finite clause or verb token.

## Slide 196: Poisson mixed-effects models

Source note: `regression-models/poisson-mixed-models.qmd`

The current v2 release differs from the older version summarized in the paper. The analysis below is thus a new paired analysis of the graph-aware v2 table, not a reproduction of the paper's reported passage averages.

## Slide 197: Stating the observation and target

Source note: `regression-models/poisson-mixed-models.qmd`

One row is one complete passage graph in English or French. `pair_id` joins the aligned translations. `word_count` is the number of annotated words, and `scene_count` counts distinct nodes with an outgoing Process or State edge. A remote reference to an existing node does not create another Scene.

## Slide 198: Stating the observation and target

Source note: `regression-models/poisson-mixed-models.qmd`

The target is the French-to-English Scene-rate ratio within this release, conditional on aligned passage-pair heterogeneity. It is a rate per annotated word, not a contrast in raw counts.

## Slide 199: Assembling the conditional model

Source note: `regression-models/poisson-mixed-models.qmd`

For passage pair $p$ and language side $l$,

$$
Y_{pl}\mid b_p
\sim\operatorname{Poisson}(\lambda_{pl}),
$$

with probability mass

$$
\mathbb{P}(Y_{pl}=y\mid b_p)
=\frac{\exp(-\lambda_{pl})\lambda_{pl}^{y}}{y!}.
$$

## Slide 200: Assembling the conditional model

Source note: `regression-models/poisson-mixed-models.qmd`

The log expected count combines word exposure, a language contrast, and the pair intercept:

$$
\log\lambda_{pl}
=\log W_{pl}
+\beta_0
+\beta_1\operatorname{French}_{pl}
+b_p,
$$

where

$$
b_p\sim\mathcal N(0,\tau_p^2).
$$

## Slide 201: Assembling the conditional model

Source note: `regression-models/poisson-mixed-models.qmd`

Exponentiating gives

$$
\lambda_{pl}
=W_{pl}
\exp\left(
\beta_0+\beta_1\operatorname{French}_{pl}+b_p
\right).
$$

## Slide 202: Assembling the conditional model

Source note: `regression-models/poisson-mixed-models.qmd`

Dividing by exposure shows the modeled Scene rate:

$$
\frac{\lambda_{pl}}{W_{pl}}
=\exp\left(
\beta_0+\beta_1\operatorname{French}_{pl}+b_p
\right).
$$

## Slide 203: Assembling the conditional model

Source note: `regression-models/poisson-mixed-models.qmd`

The offset fixes the coefficient of $\log W_{pl}$ at one. Doubling word exposure doubles the expected count while holding the rate constant.

## Slide 204: Fitting the paired UCCA model

Source note: `regression-models/poisson-mixed-models.qmd`

Holding the passage-pair effect fixed, the fitted French Scene rate is 1.131 times the fitted English rate per annotated word. The comparison is multiplicative because the model uses a log link.

## Slide 205: Showing observed counts and fitted rates

Source note: `regression-models/poisson-mixed-models.qmd`

The points below are observed passage counts. The fitted curves set the pair deviation to zero and vary word exposure, so the observations and model remain on the same count scale.

## Slide 206: Showing observed counts and fitted rates

Source note: `regression-models/poisson-mixed-models.qmd`

This figure shows observed linguistic data for Showing observed counts and fitted rates.

## Slide 207: Preserving the conditioning statement

Source note: `regression-models/poisson-mixed-models.qmd`

Conditional on $b_p$, the Poisson model has

$$
\operatorname{Var}[Y_{pl}\mid b_p]
=\mathbb{E}[Y_{pl}\mid b_p]
=\lambda_{pl}.
$$

## Slide 208: Preserving the conditioning statement

Source note: `regression-models/poisson-mixed-models.qmd`

This statement concerns a passage pair with a given deviation. A prediction for a new pair must average over the fitted pair distribution. The next page shows why that averaging produces marginal variance greater than the marginal mean even though the conditional response remains Poisson.

## Slide 209: Preserving the conditioning statement

Source note: `regression-models/poisson-mixed-models.qmd`

Language is a fixed within-pair description of this translation release, not a random sample of languages. The corpus contains consecutive material from one novel, one translation, and one annotation history. The fitted rate ratio may summarize that selected corpus; it cannot be promoted to a population claim about French and English.

## Slide 210: Group heterogeneity and marginal dispersion

Source note: `regression-models/overdispersion-and-random-effects.qmd`

Next, we take up Group heterogeneity and marginal dispersion.

## Slide 211: Group heterogeneity and marginal dispersion

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The Poisson mixed-model page supplied one source of structured count variation: persistent differences across aligned passage pairs. A Poisson regression without that structure can appear overdispersed because it combines low-rate and high-rate pairs under one mean.

## Slide 212: Group heterogeneity and marginal dispersion

Source note: `regression-models/overdispersion-and-random-effects.qmd`

This extra variation arises after averaging over heterogeneous groups. It is not a new conditional response distribution. The distinction follows from the law of total variance.

## Slide 213: Beginning with the conditional Poisson claim

Source note: `regression-models/overdispersion-and-random-effects.qmd`

For language side $l$ of passage pair $p$, write

$$
Y_{pl}\mid b_p
\sim\operatorname{Poisson}(\lambda_{pl}(b_p)),
$$

with

$$
\lambda_{pl}(b_p)
=\lambda_{pl}^{(0)}\exp(b_p),
$$

where

$$
\lambda_{pl}^{(0)}
=W_{pl}\exp\left(
\beta_0+\beta_1\operatorname{French}_{pl}
\right)
$$

is the expected count when the pair deviation is zero, and

$$
b_p\sim\mathcal N(0,\tau_p^2).
$$

## Slide 214: Beginning with the conditional Poisson claim

Source note: `regression-models/overdispersion-and-random-effects.qmd`

Conditional on a particular pair effect,

$$
\operatorname{Var}[Y_{pl}\mid b_p]
=\mathbb{E}[Y_{pl}\mid b_p]
=\lambda_{pl}(b_p).
$$

## Slide 215: Beginning with the conditional Poisson claim

Source note: `regression-models/overdispersion-and-random-effects.qmd`

Thus the model remains conditionally Poisson.

## Slide 216: Averaging over the passage-pair population

Source note: `regression-models/overdispersion-and-random-effects.qmd`

For a new aligned pair, the marginal mean is

$$
m_{pl}
=\operatorname{E}_{b}\left[\lambda_{pl}(b)\right].
$$

Because $b\sim\mathcal N(0,\tau_p^2)$,

$$
\operatorname{E}[\exp(b)]
=\exp\left(\frac{\tau_p^2}{2}\right),
$$

so

$$
m_{pl}
=\lambda_{pl}^{(0)}
\exp\left(\frac{\tau_p^2}{2}\right).
$$

## Slide 217: Averaging over the passage-pair population

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The law of total variance gives

$$
\begin{aligned}
\operatorname{Var}[Y_{pl}]
&=\operatorname{E}_{b}
  [\operatorname{Var}[Y_{pl}\mid b]]
  +\operatorname{Var}_{b}
  [\mathbb{E}[Y_{pl}\mid b]]\\
&=\operatorname{E}_{b}[\lambda_{pl}(b)]
  +\operatorname{Var}_{b}[\lambda_{pl}(b)]\\
&=m_{pl}+\operatorname{Var}_{b}[\lambda_{pl}(b)].
\end{aligned}
$$

## Slide 218: Averaging over the passage-pair population

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The lognormal moment identity yields

$$
\operatorname{Var}_{b}[\lambda_{pl}(b)]
=m_{pl}^2\left[\exp(\tau_p^2)-1\right].
$$

## Slide 219: Averaging over the passage-pair population

Source note: `regression-models/overdispersion-and-random-effects.qmd`

Thus,

$$
\operatorname{Var}[Y_{pl}]
=m_{pl}
+m_{pl}^2\left[\exp(\tau_p^2)-1\right].
$$

## Slide 220: Averaging over the passage-pair population

Source note: `regression-models/overdispersion-and-random-effects.qmd`

If $\tau_p^2>0$, the second term is positive. Marginal variance then exceeds marginal mean even though every conditional count distribution is Poisson.

## Slide 221: Substituting the fitted UCCA pair variance

Source note: `regression-models/overdispersion-and-random-effects.qmd`

At the observed-data fit, the population-center mean for an English passage with 100 annotated words is 16.93 Scenes. Averaging over new passage-pair heterogeneity raises the mean to 17.06 and gives marginal variance 21.40. The resulting marginal variance-to-mean ratio is 1.254.

## Slide 222: Substituting the fitted UCCA pair variance

Source note: `regression-models/overdispersion-and-random-effects.qmd`

These values describe the fitted Poisson-lognormal model at one actual exposure value. They are not a simulated count example.

## Slide 223: Diagnosing conditional fit

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The marginal moment identity does not tell us whether the conditional Poisson variance fits the observed within-model residual pattern. A Pearson diagnostic assesses that different question.

## Slide 224: Diagnosing conditional fit

Source note: `regression-models/overdispersion-and-random-effects.qmd`

This figure shows observed linguistic data for Diagnosing conditional fit.

## Slide 225: Diagnosing conditional fit

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The conditional Pearson ratio is 0.445, which is below one. These data are conditionally underdispersed relative to the fitted Poisson working model even though the pair intercept induces extra-Poisson *marginal* variance. The two claims refer to different conditioning levels and can hold simultaneously.

## Slide 226: Diagnosing conditional fit

Source note: `regression-models/overdispersion-and-random-effects.qmd`

Two sides of the same passage pair share $b_p$. After that effect is averaged out, a high count on one side provides information that the pair has a high baseline, which in turn raises the expectation for the other side. A negative-binomial or observation-level dispersion term can change count variance but does not by itself encode this paired association.

## Slide 227: Diagnosing conditional fit

Source note: `regression-models/overdispersion-and-random-effects.qmd`

Random intercepts thus do not repair every dispersion pattern. They are licensed by a known repeated unit and explain one structured source of variation. Remaining conditional underdispersion, omitted predictors, varying associations, or another response family require separate model criticism.
