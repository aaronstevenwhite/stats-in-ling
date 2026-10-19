# Mixed-effects models

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Mixed-effects models

Source note: `regression-models/structured-data.qmd`

Welcome to Mixed-effects models. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Repeated units in linguistic data

Source note: `regression-models/structured-data.qmd`

We now turn to Repeated units in linguistic data. The chapter on independent sampling separated the number of recorded observations from the assumptions that make those observations independent. Linguistic experiments commonly contain repeated participants and items, so rows inherit dependence from the design.

## Slide 3: MALD: the empirical object

Source note: `regression-models/structured-data.qmd`

This is the first use of MALD in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 4: Repeated units in linguistic data

Source note: `regression-models/structured-data.qmd`

The chapter on independent sampling separated the number of recorded observations from the assumptions that make those observations independent. Linguistic experiments commonly contain repeated participants and items, so rows inherit dependence from the design. We examine that structure in the **MALD connected-trial extract**. MALD is an auditory lexical-decision database described by Tucker et al. (2019); the later MALD 1.1 release expanded the participant inventory. The paper reports 231 listeners, whereas release 1.1 contains 440. These totals describe different versions and should not be combined. Notice what is observed and what is supplied by the model.

## Slide 5: Examining repetition in the MALD table

Source note: `regression-models/structured-data.qmd`

The prepared extract is response-blind: participants and words were selected without using correctness or response time. It is not the full release. One row records one real-word trial from one participant, including the spoken word, response time, correctness, SUBTLEX frequency, acoustic duration, and within-run trial order. The latency analysis retains correct responses, as in Tucker et al.'s source analysis. This restriction leaves observed trials from observed participants and observed spoken words. It does not make the retained rows independent. That distinction will matter again on the next slide.

## Slide 6: Writing the independence claim

Source note: `regression-models/structured-data.qmd`

A regression model without grouping terms often represents conditional independence as After the predictors are known, the joint density is written as a product over trials. Under this model, learning the residual for one row gives no information about the residual for another. Use the graph or equation to say the result in ordinary language.

## Slide 7: Writing the independence claim

Source note: `regression-models/structured-data.qmd`

The displayed expression formalizes writing the independence claim. A regression model without grouping terms often represents conditional independence as Keep track of what each term refers to in the linguistic dataset.

## Slide 8: Distinguishing crossed and nested units

Source note: `regression-models/structured-data.qmd`

Participant and word are **crossed** because participants respond to many words and words receive responses from multiple participants. A nested structure would instead require each lower-level unit to belong to only one higher-level unit. The distinction can be checked from the incidence table rather than inferred from column order: That distinction will matter again on the next slide.

## Slide 9: Matching dependence to the claim

Source note: `regression-models/structured-data.qmd`

A participant-population claim requires replication across participants. An item-population claim requires replication across words. A claim about both requires a design and analysis that preserve both sources. Averaging trials within participants would preserve participant replication while discarding word variation and within-participant trial predictors. Averaging within words would do the reverse. Mixed-effects models retain trial-level responses while representing both shared sources. Use the graph or equation to say the result in ordinary language.

## Slide 10: Repeated units in linguistic data

Source note: `regression-models/structured-data.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Repeated units in linguistic data. Read the pattern before attaching a model interpretation to it.

## Slide 11: Interpretation

Source note: `regression-models/structured-data.qmd`

Averaging trials within participants would preserve participant replication while discarding word variation and within-participant trial predictors. Averaging within words would do the reverse. Mixed-effects models retain trial-level responses while representing both shared sources. Now connect the notation back to the linguistic comparison.

## Slide 12: Population coefficients and group variation

Source note: `regression-models/fixed-and-random-effects.qmd`

We now turn to Population coefficients and group variation. The preceding page identified participant and spoken word as crossed repeated units in the MALD trial table. We now separate the population associations represented by coefficients from variation across those sampled units.

## Slide 13: Population coefficients and group variation

Source note: `regression-models/fixed-and-random-effects.qmd`

The preceding page identified participant and spoken word as crossed repeated units in the MALD trial table. We now separate the population associations represented by coefficients from variation across those sampled units. Use the graph or equation to say the result in ordinary language.

## Slide 14: Beginning with the scientific target

Source note: `regression-models/fixed-and-random-effects.qmd`

The focal course model relates log response time to standardized log SUBTLEX frequency, standardized log acoustic duration, and standardized trial order. These predictors enter the population relation: Here $\boldsymbol\beta$ contains the population intercept and the three population associations. In particular, $\beta_{\text{frequency}}$ is the expected change in log response time for a one-standard-deviation increase in log frequency, holding duration and trial order fixed. Notice what is observed and what is supplied by the model.

## Slide 15: Beginning with the scientific target

Source note: `regression-models/fixed-and-random-effects.qmd`

The displayed expression formalizes beginning with the scientific target. The focal course model relates log response time to standardized log SUBTLEX frequency, standardized log acoustic duration, and standardized trial order. These predictors enter the population relation: Keep track of what each term refers to in the linguistic dataset.

## Slide 16: Representing sampled variation

Source note: `regression-models/fixed-and-random-effects.qmd`

Participant $p$ receives an intercept deviation and a frequency-slope deviation: Word $w$ receives an intercept deviation, Notice what is observed and what is supplied by the model.

## Slide 17: Representing sampled variation: equation 1

Source note: `regression-models/fixed-and-random-effects.qmd`

The displayed expression formalizes representing sampled variation: equation 1. Participant $p$ receives an intercept deviation and a frequency-slope deviation: Keep track of what each term refers to in the linguistic dataset.

## Slide 18: Representing sampled variation: equation 2

Source note: `regression-models/fixed-and-random-effects.qmd`

The displayed expression formalizes representing sampled variation: equation 2. Word $w$ receives an intercept deviation, Keep track of what each term refers to in the linguistic dataset.

## Slide 19: Representing sampled variation: equation 3

Source note: `regression-models/fixed-and-random-effects.qmd`

The displayed expression formalizes representing sampled variation: equation 3. and the trial residual is Keep track of what each term refers to in the linguistic dataset.

## Slide 20: Representing sampled variation: equation 4

Source note: `regression-models/fixed-and-random-effects.qmd`

The displayed expression formalizes representing sampled variation: equation 4. Combining the pieces gives Keep track of what each term refers to in the linguistic dataset.

## Slide 21: Fitting the MALD model

Source note: `regression-models/fixed-and-random-effects.qmd`

The fitted frequency coefficient is observed log-response-time units per standard deviation. This is a population association conditional on duration and trial order. It is not a participant-specific slope or a causal effect of lexical frequency. The preceding page identified participant and spoken word as crossed repeated units in the MALD trial table. We now separate the population associations represented by coefficients from variation across those sampled units. Now connect the notation back to the linguistic comparison.

## Slide 22: Showing raw data and the fitted population relation

Source note: `regression-models/fixed-and-random-effects.qmd`

Plotting all trials would obscure the relation. We thus summarize the raw responses in empirical frequency bins and draw the fitted population line at mean duration and mean trial order. The points are raw bin means; the line sets participant and item deviations to zero. Thus it describes the fitted population relation on the same response scale, not the trajectory of an observed participant or word. Use the graph or equation to say the result in ordinary language.

## Slide 23: Storage type does not determine modeling role

Source note: `regression-models/fixed-and-random-effects.qmd`

Frequency, participant, item, and part of speech can all be stored as columns. Their storage types do not decide whether they receive population coefficients or group distributions. The decision follows the estimand and sampling design. A measured property that encodes a theoretical contrast belongs in the population relation. The course formula omits run length, phonological neighborhood density, uniqueness point, and other controls considered by Tucker et al. It isolates the covariance concepts needed here and should not be read as a reproduction of their predictor comparison. The next page shows how the group distributions produce partial pooling. Now connect the notation back to the linguistic comparison.

## Slide 24: Population coefficients and group variation

Source note: `regression-models/fixed-and-random-effects.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Population coefficients and group variation. Read the pattern before attaching a model interpretation to it.

## Slide 25: Random effects and partial pooling

Source note: `regression-models/random-effects.qmd`

We now turn to Random effects and partial pooling. The preceding page separated population associations from variation across sampled listeners and words. A random-effects model represents the latter through a shared group distribution and **partial pooling**.

## Slide 26: Random effects and partial pooling

Source note: `regression-models/random-effects.qmd`

The preceding page separated population associations from variation across sampled listeners and words. A random-effects model represents the latter through a shared group distribution and **partial pooling**. The interpretation is conditional on the sampling and measurement design.

## Slide 27: Model deviations from a shared center

Source note: `regression-models/random-effects.qmd`

Begin with a crossed intercept-only model for the correct MALD latencies: where Notice what is observed and what is supplied by the model.

## Slide 28: Model deviations from a shared center: equation 1

Source note: `regression-models/random-effects.qmd`

The displayed expression formalizes model deviations from a shared center: equation 1. Begin with a crossed intercept-only model for the correct MALD latencies: Keep track of what each term refers to in the linguistic dataset.

## Slide 29: Model deviations from a shared center: equation 2

Source note: `regression-models/random-effects.qmd`

The displayed expression formalizes model deviations from a shared center: equation 2. where Keep track of what each term refers to in the linguistic dataset.

## Slide 30: Comparing pooling strategies

Source note: `regression-models/random-effects.qmd`

Complete pooling ignores participant identity and assigns every participant the population baseline $\beta_0$. No pooling estimates an unrelated mean for every participant. Partial pooling gives each participant a distinct deviation while estimating those deviations under one population distribution. For a one-group normal random-intercept model with known variance components, the participant deviation has the form Use the graph or equation to say the result in ordinary language.

## Slide 31: Comparing pooling strategies: equation 1

Source note: `regression-models/random-effects.qmd`

The displayed expression formalizes comparing pooling strategies: equation 1. Complete pooling ignores participant identity and assigns every participant the population baseline $\beta_0$. No pooling estimates an unrelated mean for every participant. Partial pooling gives each participant a distinct deviation while estimating those deviations under one population distribution. Keep track of what each term refers to in the linguistic dataset.

## Slide 32: Comparing pooling strategies: equation 2

Source note: `regression-models/random-effects.qmd`

The displayed expression formalizes comparing pooling strategies: equation 2. For a one-group normal random-intercept model with known variance components, the participant deviation has the form Keep track of what each term refers to in the linguistic dataset.

## Slide 33: Computing the three MALD summaries

Source note: `regression-models/random-effects.qmd`

The diagonal marks equality between raw and partially pooled means. Points move toward the horizontal population center, with the amount of movement determined by the fitted variances and the information available for each listener. The preceding page separated population associations from variation across sampled listeners and words. A random-effects model represents the latter through a shared group distribution and **partial pooling**. Use the graph or equation to say the result in ordinary language.

## Slide 34: Keeping two kinds of variation separate

Source note: `regression-models/random-effects.qmd`

The participant standard deviation $\tau_p$ describes stable between-listener variation. The residual standard deviation $\sigma$ describes trial variation around participant and word baselines. One cannot substitute for the other: large residual variation is not persistent listener heterogeneity, and large group variation is not within-listener trial noise. The preceding page separated population associations from variation across sampled listeners and words. A random-effects model represents the latter through a shared group distribution and **partial pooling**. That distinction will matter again on the next slide.

## Slide 35: Understanding exchangeability

Source note: `regression-models/random-effects.qmd`

Take a minute before we move on. The shared normal distribution treats participant labels as exchangeable after conditioning on included predictors. Before observing the responses, swapping two arbitrary participant labels does not change the model. If listeners differ systematically by a measured property, that property should enter the population relation; the random effects then describe remaining variation. State the answer in terms of the dataset and the unit of analysis.

## Slide 36: Random effects and partial pooling

Source note: `regression-models/random-effects.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Random effects and partial pooling. Read the pattern before attaching a model interpretation to it.

## Slide 37: Random-intercept models

Source note: `regression-models/random-intercepts.qmd`

We now turn to Random-intercept models. The partial-pooling page gave participants and words deviations from a shared population center. A **random-intercept model** places those deviations inside a regression equation.

## Slide 38: Random-intercept models

Source note: `regression-models/random-intercepts.qmd`

The partial-pooling page gave participants and words deviations from a shared population center. A **random-intercept model** places those deviations inside a regression equation. That distinction will matter again on the next slide.

## Slide 39: Inserting a participant deviation

Source note: `regression-models/random-intercepts.qmd`

For trial $i$ from participant $p$, a participant-intercept model has with The interpretation is conditional on the sampling and measurement design.

## Slide 40: Inserting a participant deviation: equation 1

Source note: `regression-models/random-intercepts.qmd`

The displayed expression formalizes inserting a participant deviation: equation 1. For trial $i$ from participant $p$, a participant-intercept model has Keep track of what each term refers to in the linguistic dataset.

## Slide 41: Inserting a participant deviation: equation 2

Source note: `regression-models/random-intercepts.qmd`

The displayed expression formalizes inserting a participant deviation: equation 2. with Keep track of what each term refers to in the linguistic dataset.

## Slide 42: Deriving the induced covariance

Source note: `regression-models/random-intercepts.qmd`

Two trials from the same participant share $b_p$: Under independent residuals and independence between residuals and the group deviation, The interpretation is conditional on the sampling and measurement design.

## Slide 43: Deriving the induced covariance: equation 1

Source note: `regression-models/random-intercepts.qmd`

The displayed expression formalizes deriving the induced covariance: equation 1. Two trials from the same participant share $b_p$: Keep track of what each term refers to in the linguistic dataset.

## Slide 44: Deriving the induced covariance: equation 2

Source note: `regression-models/random-intercepts.qmd`

The displayed expression formalizes deriving the induced covariance: equation 2. Under independent residuals and independence between residuals and the group deviation, Keep track of what each term refers to in the linguistic dataset.

## Slide 45: Adding the crossed word intercept

Source note: `regression-models/random-intercepts.qmd`

MALD trials also repeat spoken words. Give word $w$ a deviation $c_w$: where Use the graph or equation to say the result in ordinary language.

## Slide 46: Adding the crossed word intercept: equation 1

Source note: `regression-models/random-intercepts.qmd`

The displayed expression formalizes adding the crossed word intercept: equation 1. MALD trials also repeat spoken words. Give word $w$ a deviation $c_w$: Keep track of what each term refers to in the linguistic dataset.

## Slide 47: Adding the crossed word intercept: equation 2

Source note: `regression-models/random-intercepts.qmd`

The displayed expression formalizes adding the crossed word intercept: equation 2. where Keep track of what each term refers to in the linguistic dataset.

## Slide 48: Fitting the crossed model

Source note: `regression-models/random-intercepts.qmd`

The two grouping terms are crossed because participant and word identifiers recur in many combinations. The formula does not create replication absent from the table; it represents the incidence structure that the table already contains. The partial-pooling page gave participants and words deviations from a shared population center. A **random-intercept model** places those deviations inside a regression equation. Use the graph or equation to say the result in ordinary language.

## Slide 49: Comparing raw and conditional participant baselines

Source note: `regression-models/random-intercepts.qmd`

The participant intercept represents persistent response-speed differences. It cannot represent participant-specific lexical-frequency associations; that requires a random slope. The next page converts the fitted covariance components into model-implied correlations. The partial-pooling page gave participants and words deviations from a shared population center. A **random-intercept model** places those deviations inside a regression equation. Now connect the notation back to the linguistic comparison.

## Slide 50: Random-intercept models

Source note: `regression-models/random-intercepts.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Random-intercept models. Read the pattern before attaching a model interpretation to it.

## Slide 51: Intraclass correlation

Source note: `regression-models/intraclass-correlation.qmd`

We now turn to Intraclass correlation. The random-intercept page showed that responses sharing a participant or word also share a modeled deviation. The **intraclass correlation coefficient (ICC)** summarizes the resulting correlation for a Gaussian random-intercept model.

## Slide 52: Intraclass correlation

Source note: `regression-models/intraclass-correlation.qmd`

The random-intercept page showed that responses sharing a participant or word also share a modeled deviation. The **intraclass correlation coefficient (ICC)** summarizes the resulting correlation for a Gaussian random-intercept model. Keep the observational unit fixed while you interpret the result.

## Slide 53: Deriving the crossed-unit correlations

Source note: `regression-models/intraclass-correlation.qmd`

For the MALD intercept-only model, with independent components having variances $\tau_p^2$, $\tau_w^2$, and $\sigma^2$. The marginal response variance is Use the graph or equation to say the result in ordinary language.

## Slide 54: Deriving the crossed-unit correlations: equation 1

Source note: `regression-models/intraclass-correlation.qmd`

The displayed expression formalizes deriving the crossed-unit correlations: equation 1. For the MALD intercept-only model, Keep track of what each term refers to in the linguistic dataset.

## Slide 55: Deriving the crossed-unit correlations: equation 2

Source note: `regression-models/intraclass-correlation.qmd`

The displayed expression formalizes deriving the crossed-unit correlations: equation 2. with independent components having variances $\tau_p^2$, $\tau_w^2$, and $\sigma^2$. The marginal response variance is Keep track of what each term refers to in the linguistic dataset.

## Slide 56: Deriving the crossed-unit correlations: equation 3

Source note: `regression-models/intraclass-correlation.qmd`

The displayed expression formalizes deriving the crossed-unit correlations: equation 3. Two distinct trials from the same participant but different words share only $b_p$, so their covariance is $\tau_p^2$. Their correlation is Keep track of what each term refers to in the linguistic dataset.

## Slide 57: Deriving the crossed-unit correlations: equation 4

Source note: `regression-models/intraclass-correlation.qmd`

The displayed expression formalizes deriving the crossed-unit correlations: equation 4. Two trials on the same word from different participants instead have Keep track of what each term refers to in the linguistic dataset.

## Slide 58: Deriving the crossed-unit correlations: equation 5

Source note: `regression-models/intraclass-correlation.qmd`

The displayed expression formalizes deriving the crossed-unit correlations: equation 5. If two rows share both participant and word, the fitted correlation is Keep track of what each term refers to in the linguistic dataset.

## Slide 59: Substituting the MALD variance estimates

Source note: `regression-models/intraclass-correlation.qmd`

The fitted participant ICC is observed, the item ICC is observed, and sharing both units gives correlation observed. These values are computed from the correct-response MALD subset rather than supplied as schematic quantities. The random-intercept page showed that responses sharing a participant or word also share a modeled deviation. The **intraclass correlation coefficient (ICC)** summarizes the resulting correlation for a Gaussian random-intercept model. Notice what is observed and what is supplied by the model.

## Slide 60: Relating the correlations to replication

Source note: `regression-models/intraclass-correlation.qmd`

Positive ICCs mean that repeated rows from one unit contain less independent information than the same number of rows from distinct units. Additional trials can estimate an observed participant's or word's baseline more precisely. Additional participants or words provide replication across the corresponding population. The random-intercept page showed that responses sharing a participant or word also share a modeled deviation. The **intraclass correlation coefficient (ICC)** summarizes the resulting correlation for a Gaussian random-intercept model. That distinction will matter again on the next slide.

## Slide 61: Keeping the interpretation model-specific

Source note: `regression-models/intraclass-correlation.qmd`

Adding predictors can change every variance component. An intercept-only ICC and an ICC conditional on frequency, duration, and trial order need not agree. Random slopes also make the covariance depend on predictor values, so one constant ICC no longer describes every trial pair. These ICCs are properties of this fitted Gaussian intercept-only model and its correct-response subset. Report the formula and variance components with the ratios. The next page examines the partially pooled group deviations returned by the fitted model. The interpretation is conditional on the sampling and measurement design.

## Slide 62: Intraclass correlation

Source note: `regression-models/intraclass-correlation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Intraclass correlation. Read the pattern before attaching a model interpretation to it.

## Slide 63: Group-specific estimates

Source note: `regression-models/random-effect-estimates.qmd`

We now turn to Group-specific estimates. The partial-pooling page explained why group deviations are estimated jointly with a population distribution. A fitted multilevel model gives each observed group a partially pooled estimate of its deviation from the population relation. In a frequentist `lme4` fit, `ranef()` reports these values as **conditional modes**.

## Slide 64: Group-specific estimates

Source note: `regression-models/random-effect-estimates.qmd`

The partial-pooling page explained why group deviations are estimated jointly with a population distribution. A fitted multilevel model gives each observed group a partially pooled estimate of its deviation from the population relation. In a frequentist `lme4` fit, `ranef()` reports these values as **conditional modes**. They are useful summaries of the fitted group structure. They are not raw group means, independently estimated coefficients, or error-free rankings. Keep the observational unit fixed while you interpret the result.

## Slide 65: Defining the conditional mode

Source note: `regression-models/random-effect-estimates.qmd`

For participant $p$, collect the intercept and frequency-slope deviations in $\mathbf b_p$. Conditional on fitted population coefficients and variance components, the estimate is The first term rewards values that fit the participant's trials. The second rewards values plausible under the estimated participant distribution. Their combination produces partial pooling. Notice what is observed and what is supplied by the model.

## Slide 66: Defining the conditional mode: equation 1

Source note: `regression-models/random-effect-estimates.qmd`

The displayed expression formalizes defining the conditional mode: equation 1. For participant $p$, collect the intercept and frequency-slope deviations in $\mathbf b_p$. Conditional on fitted population coefficients and variance components, the estimate is Keep track of what each term refers to in the linguistic dataset.

## Slide 67: Defining the conditional mode: equation 2

Source note: `regression-models/random-effect-estimates.qmd`

The displayed expression formalizes defining the conditional mode: equation 2. The first term rewards values that fit the participant's trials. The second rewards values plausible under the estimated participant distribution. Their combination produces partial pooling. Keep track of what each term refers to in the linguistic dataset.

## Slide 68: Extracting estimates and conditional uncertainty

Source note: `regression-models/random-effect-estimates.qmd`

The participant-level standard deviation in `VarCorr(fit)` describes variation across the modeled participant population. A row's `conditional_se` instead describes local uncertainty for one participant's conditional mode, conditional on the fitted population parameters. The two quantities answer different questions. The intervals overlap heavily through much of the ordering. A participant placed above another by point estimate need not have a stably higher baseline. Rank uncertainty is part of the result. That distinction will matter again on the next slide.

## Slide 69: Distinguishing deviations from group-specific coefficients

Source note: `regression-models/random-effect-estimates.qmd`

For participant $p$, the group-specific intercept is and the group-specific frequency slope is Keep the observational unit fixed while you interpret the result.

## Slide 70: Distinguishing deviations from group-specific coefficients: equation 1

Source note: `regression-models/random-effect-estimates.qmd`

The displayed expression formalizes distinguishing deviations from group-specific coefficients: equation 1. For participant $p$, the group-specific intercept is Keep track of what each term refers to in the linguistic dataset.

## Slide 71: Distinguishing deviations from group-specific coefficients: equation 2

Source note: `regression-models/random-effect-estimates.qmd`

The displayed expression formalizes distinguishing deviations from group-specific coefficients: equation 2. and the group-specific frequency slope is Keep track of what each term refers to in the linguistic dataset.

## Slide 72: Group-specific estimates

Source note: `regression-models/random-effect-estimates.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Group-specific estimates. Read the pattern before attaching a model interpretation to it.

## Slide 73: Interpretation

Source note: `regression-models/random-effect-estimates.qmd`

`ranef(fit)` returns the deviations $\widehat b_{0p}$ and $\widehat b_{1p}$; `coef(fit)` adds the population coefficients. Both depend on the predictor reference points. Here the intercept refers to mean log frequency, mean log duration, and mean trial order because the predictors were standardized. Now connect the notation back to the linguistic comparison.

## Slide 74: Random slopes

Source note: `regression-models/random-slopes.qmd`

We now turn to Random slopes. The random-intercept model allows participant baselines to vary while holding the lexical-frequency association constant. A random-slope model also lets that association vary across participants.

## Slide 75: Random slopes

Source note: `regression-models/random-slopes.qmd`

The random-intercept model allows participant baselines to vary while holding the lexical-frequency association constant. A random-slope model also lets that association vary across participants. Use the graph or equation to say the result in ordinary language.

## Slide 76: Adding a participant-specific association

Source note: `regression-models/random-slopes.qmd`

For MALD trial $i$, participant $p$, and word $w$, write The population frequency association is $\beta_f$. Participant $p$ has association That distinction will matter again on the next slide.

## Slide 77: Adding a participant-specific association: equation 1

Source note: `regression-models/random-slopes.qmd`

The displayed expression formalizes adding a participant-specific association: equation 1. For MALD trial $i$, participant $p$, and word $w$, write Keep track of what each term refers to in the linguistic dataset.

## Slide 78: Adding a participant-specific association: equation 2

Source note: `regression-models/random-slopes.qmd`

The displayed expression formalizes adding a participant-specific association: equation 2. The population frequency association is $\beta_f$. Participant $p$ has association Keep track of what each term refers to in the linguistic dataset.

## Slide 79: Adding a participant-specific association: equation 3

Source note: `regression-models/random-slopes.qmd`

The displayed expression formalizes adding a participant-specific association: equation 3. The intercept and slope deviations are modeled jointly: Keep track of what each term refers to in the linguistic dataset.

## Slide 80: Checking that the design contains the contrast

Source note: `regression-models/random-slopes.qmd`

A participant-specific frequency association requires frequency variation within participants. It does not require frequency variation within a word: a word has one lexical frequency, so an item-specific frequency slope is not identified by repeated responses to that word. Every participant spans a nonzero range of standardized frequency, whereas the maximum within-item range is observed. The data thus support participant frequency slopes but not word-specific frequency slopes. Keep the observational unit fixed while you interpret the result.

## Slide 81: Comparing raw and fitted participant relations

Source note: `regression-models/random-slopes.qmd`

We display six participants selected across the fitted slope distribution. Points are within-participant raw bin means. Lines include participant intercept and frequency-slope deviations, set duration and trial order to their standardized means, and set the word effect to zero. The random-intercept model allows participant baselines to vary while holding the lexical-frequency association constant. A random-slope model also lets that association vary across participants. Keep the observational unit fixed while you interpret the result.

## Slide 82: How the dependence changes

Source note: `regression-models/random-slopes.qmd`

Two trials from participant $p$ share $b_{0p}$, and their covariance also contains the slope contribution plus intercept-slope covariance terms when the deviations are correlated. Trial pairs at different frequency values thus need not have the same covariance. A constant participant ICC no longer summarizes every pair. Use the graph or equation to say the result in ordinary language.

## Slide 83: How the dependence changes

Source note: `regression-models/random-slopes.qmd`

The displayed expression formalizes how the dependence changes. Two trials from participant $p$ share $b_{0p}$, and their covariance also contains the slope contribution Keep track of what each term refers to in the linguistic dataset.

## Slide 84: Random slopes

Source note: `regression-models/random-slopes.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Random slopes. Read the pattern before attaching a model interpretation to it.

## Slide 85: Interpretation

Source note: `regression-models/random-slopes.qmd`

plus intercept-slope covariance terms when the deviations are correlated. Trial pairs at different frequency values thus need not have the same covariance. A constant participant ICC no longer summarizes every pair. Notice what is observed and what is supplied by the model.

## Slide 86: Random-effect correlations

Source note: `regression-models/random-effect-correlations.qmd`

We now turn to Random-effect correlations. The random-slope page gave each MALD participant a baseline deviation and a lexical-frequency-slope deviation. The two deviations may themselves be related across the participant population.

## Slide 87: Random-effect correlations

Source note: `regression-models/random-effect-correlations.qmd`

The random-slope page gave each MALD participant a baseline deviation and a lexical-frequency-slope deviation. The two deviations may themselves be related across the participant population. The interpretation is conditional on the sampling and measurement design.

## Slide 88: Writing one joint distribution

Source note: `regression-models/random-effect-correlations.qmd`

For participant $p$, model The parameter $\rho$ is the correlation between participant intercept and frequency-slope deviations. A positive value means that participants above the population baseline tend to have frequency slopes above the population slope. The sign of *above* depends on the response and predictor coding. Keep the observational unit fixed while you interpret the result.

## Slide 89: Writing one joint distribution

Source note: `regression-models/random-effect-correlations.qmd`

The displayed expression formalizes writing one joint distribution. For participant $p$, model Keep track of what each term refers to in the linguistic dataset.

## Slide 90: Fitting the covariance on centered predictors

Source note: `regression-models/random-effect-correlations.qmd`

The fitted correlation is observed. Its meaning is tied to the intercept at mean log frequency, mean log duration, and mean trial order. The fitted slope standard deviation is only observed log-response-time units, so a strong substantive story about the correlation would outrun the estimated slope variation. The random-slope page gave each MALD participant a baseline deviation and a lexical-frequency-slope deviation. The two deviations may themselves be related across the participant population. Notice what is observed and what is supplied by the model.

## Slide 91: Why centering changes the correlation

Source note: `regression-models/random-effect-correlations.qmd`

Let the centered predictor be Because $x_i=x_i^c+c$, the group-specific part becomes Now connect the notation back to the linguistic comparison.

## Slide 92: Why centering changes the correlation: equation 1

Source note: `regression-models/random-effect-correlations.qmd`

The displayed expression formalizes why centering changes the correlation: equation 1. Let the centered predictor be Keep track of what each term refers to in the linguistic dataset.

## Slide 93: Why centering changes the correlation: equation 2

Source note: `regression-models/random-effect-correlations.qmd`

The displayed expression formalizes why centering changes the correlation: equation 2. Because $x_i=x_i^c+c$, the group-specific part becomes Keep track of what each term refers to in the linguistic dataset.

## Slide 94: Why centering changes the correlation: equation 3

Source note: `regression-models/random-effect-correlations.qmd`

The displayed expression formalizes why centering changes the correlation: equation 3. The new intercept deviation is thus Keep track of what each term refers to in the linguistic dataset.

## Slide 95: Why centering changes the correlation: equation 4

Source note: `regression-models/random-effect-correlations.qmd`

The displayed expression formalizes why centering changes the correlation: equation 4. Its covariance with the unchanged slope is Keep track of what each term refers to in the linguistic dataset.

## Slide 96: Random-effect correlations

Source note: `regression-models/random-effect-correlations.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Random-effect correlations. Read the pattern before attaching a model interpretation to it.

## Slide 97: Interpretation

Source note: `regression-models/random-effect-correlations.qmd`

The points are conditional modes, not independently observed participant traits, and their empirical scatter is not a replacement for $\widehat\rho$ from the covariance model. The display makes the fitted group dimensions visible while the model accounts for shrinkage and conditional uncertainty. That distinction will matter again on the next slide.

## Slide 98: Singular fits

Source note: `regression-models/singular-fits.qmd`

We now turn to Singular fits. The random-effects-correlation page represented intercept and slope deviations with a covariance matrix. A **singular fit** occurs when the estimated covariance matrix has lower rank than the formula allows.

## Slide 99: Singular fits

Source note: `regression-models/singular-fits.qmd`

The random-effects-correlation page represented intercept and slope deviations with a covariance matrix. A **singular fit** occurs when the estimated covariance matrix has lower rank than the formula allows. Keep the observational unit fixed while you interpret the result.

## Slide 100: Rank and covariance dimensions

Source note: `regression-models/singular-fits.qmd`

Suppose a grouping term requests $q$ random-effect dimensions with covariance matrix $\boldsymbol\Sigma$. A nonsingular fit requires Writing the eigendecomposition as The interpretation is conditional on the sampling and measurement design.

## Slide 101: Rank and covariance dimensions: equation 1

Source note: `regression-models/singular-fits.qmd`

The displayed expression formalizes rank and covariance dimensions: equation 1. Suppose a grouping term requests $q$ random-effect dimensions with covariance matrix $\boldsymbol\Sigma$. A nonsingular fit requires Keep track of what each term refers to in the linguistic dataset.

## Slide 102: Rank and covariance dimensions: equation 2

Source note: `regression-models/singular-fits.qmd`

The displayed expression formalizes rank and covariance dimensions: equation 2. Writing the eigendecomposition as Keep track of what each term refers to in the linguistic dataset.

## Slide 103: Rank and covariance dimensions: equation 3

Source note: `regression-models/singular-fits.qmd`

The displayed expression formalizes rank and covariance dimensions: equation 3. the rank is the number of positive eigenvalues in $\boldsymbol\Lambda$. If one eigenvalue is zero, one linear combination of the requested deviations has no fitted variation and Keep track of what each term refers to in the linguistic dataset.

## Slide 104: Fitting a predeclared MALD stress test

Source note: `regression-models/singular-fits.qmd`

Take a minute before we move on. The stress-test model asks participants to vary in an intercept, frequency slope, duration slope, trial-order slope, and frequency-by-duration interaction slope. It also gives words a trial-order slope. The fixed interaction remains in both models because the diagnostic concerns the group covariance structure. State the answer in terms of the dataset and the unit of analysis.

## Slide 105: Inspecting the fitted dimensions

Source note: `regression-models/singular-fits.qmd`

`rePCA()` rotates each fitted covariance matrix into orthogonal directions. The returned standard deviations are the square roots of the rotated, residual-scaled eigenvalues. The final participant direction in the larger model collapses to the boundary. Because the rotated directions are linear combinations, this fact is stronger than merely inspecting whether one named standard deviation looks small. Now connect the notation back to the linguistic comparison.

## Slide 106: Separating singularity from convergence

Source note: `regression-models/singular-fits.qmd`

An optimizer can reach a boundary optimum successfully, producing a singular fit without a convergence failure. Conversely, a nonsingular covariance estimate can accompany an optimizer warning. `isSingular()` and the optimizer diagnostics answer different questions and both should be checked. A singular fit should send us back to the design: which predictor contrasts vary within which groups, how many group levels support the covariance, and which population variation the scientific claim requires. Plausible responses include removing an unsupported correlation, removing an unsupported slope, collecting more within-group contrasts, or using a regularized model. These moves encode different population assumptions. Keep the observational unit fixed while you interpret the result.

## Slide 107: Singular fits

Source note: `regression-models/singular-fits.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Singular fits. Read the pattern before attaching a model interpretation to it.

## Slide 108: Interpretation

Source note: `regression-models/singular-fits.qmd`

A singular fit should send us back to the design: which predictor contrasts vary within which groups, how many group levels support the covariance, and which population variation the scientific claim requires. Now connect the notation back to the linguistic comparison.

## Slide 109: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

We now turn to Generalized linear mixed models. The Gaussian pages represented repeated observations with group-specific deviations. A **generalized linear mixed model (GLMM)** keeps that group structure while replacing the Gaussian response with a distribution and link appropriate to the outcome.

## Slide 110: SuperTelicity: the empirical object

Source note: `regression-models/generalized-linear-mixed-models.qmd`

This is the first use of SuperTelicity in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 111: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The Gaussian pages represented repeated observations with group-specific deviations. A **generalized linear mixed model (GLMM)** keeps that group structure while replacing the Gaussian response with a distribution and link appropriate to the outcome. We use the cloze judgments from White, Cao, Grimm, and Glass's working manuscript *The Preservation of Telicity under Sense Locality* (n.d.) and the immutable CC BY-SA teaching table prepared from its credential-gated source release at commit `e45277ce466719c1a03629f6ccf1e12db9904421`. On each trial, a participant selected *in* or *for*, a numeral, and a time unit for an event description. That distinction will matter again on the next slide.

## Slide 112: Combining a Bernoulli response with group variation

Source note: `regression-models/generalized-linear-mixed-models.qmd`

Let $Y_i=1$ when trial $i$ has an *in* response. Conditional on the random effects, The interpretation is conditional on the sampling and measurement design.

## Slide 113: Combining a Bernoulli response with group variation: equation 1

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The displayed expression formalizes combining a bernoulli response with group variation: equation 1. Let $Y_i=1$ when trial $i$ has an *in* response. Conditional on the random effects, Keep track of what each term refers to in the linguistic dataset.

## Slide 114: Combining a Bernoulli response with group variation: equation 2

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The displayed expression formalizes combining a bernoulli response with group variation: equation 2. and Keep track of what each term refers to in the linguistic dataset.

## Slide 115: Combining a Bernoulli response with group variation: equation 3

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The displayed expression formalizes combining a bernoulli response with group variation: equation 3. The vector $\mathbf x_i$ contains verb class, contentfulness, and their interaction. Participant $p$, verb $w$, and sentence $q$ receive independent random intercepts: Keep track of what each term refers to in the linguistic dataset.

## Slide 116: Combining a Bernoulli response with group variation: equation 4

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The displayed expression formalizes combining a bernoulli response with group variation: equation 4. Conditional on these deviations, the Bernoulli likelihood is Keep track of what each term refers to in the linguistic dataset.

## Slide 117: Fitting the crossed-intercept teaching model

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The course formula is deliberately smaller than the source analysis, which uses a richer Bayesian random structure involving additional participant, lexical, duration, list, and argument-form terms. This GLMM illustrates the architecture; it does not replace the manuscript's model. The Gaussian pages represented repeated observations with group-specific deviations. A **generalized linear mixed model (GLMM)** keeps that group structure while replacing the Gaussian response with a distribution and link appropriate to the outcome. That distinction will matter again on the next slide.

## Slide 118: Raw sentence proportions and fitted probabilities

Source note: `regression-models/generalized-linear-mixed-models.qmd`

One raw point below is the proportion of *in* responses for one sentence. The fitted points set all three random intercepts to zero, so they describe a participant, verb, and sentence at the center of the fitted link-scale distributions. With sum coding, the result-minus-manner contrast averaged over the contentfulness coding is Use the graph or equation to say the result in ordinary language.

## Slide 119: Conditional and population-averaged prediction

Source note: `regression-models/generalized-linear-mixed-models.qmd`

A prediction at zero random effects is not generally the probability for a randomly drawn participant, verb, and sentence. Let $B$ be the sum of the three independent intercepts. Its variance is For fixed-effect location $\eta$, the random-effect-averaged probability is Keep the observational unit fixed while you interpret the result.

## Slide 120: Conditional and population-averaged prediction: equation 1

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The displayed expression formalizes conditional and population-averaged prediction: equation 1. A prediction at zero random effects is not generally the probability for a randomly drawn participant, verb, and sentence. Let $B$ be the sum of the three independent intercepts. Its variance is Keep track of what each term refers to in the linguistic dataset.

## Slide 121: Conditional and population-averaged prediction: equation 2

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The displayed expression formalizes conditional and population-averaged prediction: equation 2. For fixed-effect location $\eta$, the random-effect-averaged probability is Keep track of what each term refers to in the linguistic dataset.

## Slide 122: Conditional and population-averaged prediction: equation 3

Source note: `regression-models/generalized-linear-mixed-models.qmd`

The displayed expression formalizes conditional and population-averaged prediction: equation 3. Because the inverse logit is nonlinear, Keep track of what each term refers to in the linguistic dataset.

## Slide 123: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Generalized linear mixed models. Read the pattern before attaching a model interpretation to it.

## Slide 124: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Generalized linear mixed models. Read the pattern before attaching a model interpretation to it.

## Slide 125: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Generalized linear mixed models. Read the pattern before attaching a model interpretation to it.

## Slide 126: Generalized linear mixed models

Source note: `regression-models/generalized-linear-mixed-models.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Generalized linear mixed models. Read the pattern before attaching a model interpretation to it.

## Slide 127: Interpretation

Source note: `regression-models/generalized-linear-mixed-models.qmd`

Predictions for returning participants or observed lexical material may condition on their fitted deviations. Predictions for new participants or verbs cannot reuse deviations from observed groups. Every response-scale summary should state which target it uses. Use the graph or equation to say the result in ordinary language.

## Slide 128: Ordinal mixed models

Source note: `regression-models/ordinal-mixed-models.qmd`

We now turn to Ordinal mixed models. An ordinal mixed model combines the cumulative link introduced for ordinal regression with the group deviations introduced for generalized linear mixed models.

## Slide 129: MegaVeridicality: the empirical object

Source note: `regression-models/ordinal-mixed-models.qmd`

This is the first use of MegaVeridicality in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 130: Ordinal mixed models

Source note: `regression-models/ordinal-mixed-models.qmd`

An ordinal mixed model combines the cumulative link introduced for ordinal regression with the group deviations introduced for generalized linear mixed models. We use **MegaVeridicality v1**, the *no*, *maybe*, and *yes* veridicality judgments described by White and Rawlins (2018) and distributed through the official MegaVeridicality project. Each row records one response to a low-content sentence containing a clause-embedding verb. The direct task asks whether the embedded event happened after an assertion; the conditional task places that assertion in a conditional antecedent. Use the graph or equation to say the result in ordinary language.

## Slide 131: Retaining the ordered response

Source note: `regression-models/ordinal-mixed-models.qmd`

For response $Y_i$ and cutpoint $c$, the cumulative-logit model is The location predictor is Now connect the notation back to the linguistic comparison.

## Slide 132: Retaining the ordered response: equation 1

Source note: `regression-models/ordinal-mixed-models.qmd`

The displayed expression formalizes retaining the ordered response: equation 1. For response $Y_i$ and cutpoint $c$, the cumulative-logit model is Keep track of what each term refers to in the linguistic dataset.

## Slide 133: Retaining the ordered response: equation 2

Source note: `regression-models/ordinal-mixed-models.qmd`

The displayed expression formalizes retaining the ordered response: equation 2. The location predictor is Keep track of what each term refers to in the linguistic dataset.

## Slide 134: Retaining the ordered response: equation 3

Source note: `regression-models/ordinal-mixed-models.qmd`

The displayed expression formalizes retaining the ordered response: equation 3. The fixed part contains polarity, task, and their interaction. Verbs receive correlated intercept, polarity-slope, and task-slope deviations; respondents receive intercept deviations. For verb $v$ and respondent $r$, Keep track of what each term refers to in the linguistic dataset.

## Slide 135: Retaining the ordered response: equation 4

Source note: `regression-models/ordinal-mixed-models.qmd`

The displayed expression formalizes retaining the ordered response: equation 4. With logistic cumulative distribution $F$, the three category probabilities are Keep track of what each term refers to in the linguistic dataset.

## Slide 136: Retaining the ordered response: equation 5

Source note: `regression-models/ordinal-mixed-models.qmd`

The displayed expression formalizes retaining the ordered response: equation 5. and Keep track of what each term refers to in the linguistic dataset.

## Slide 137: Retaining the ordered response: equation 6

Source note: `regression-models/ordinal-mixed-models.qmd`

The displayed expression formalizes retaining the ordered response: equation 6. The ordered thresholds preserve category order without assigning equal numerical spacing to the labels. Keep track of what each term refers to in the linguistic dataset.

## Slide 138: Fitting the verb-and-respondent model

Source note: `regression-models/ordinal-mixed-models.qmd`

The threshold and fixed-effect estimates are computed directly from the raw ordered responses: These values describe one fitted teaching model. They do not define a latent taxonomy of clause-embedding verbs. Use the graph or equation to say the result in ordinary language.

## Slide 139: Comparing observed and fitted category probabilities

Source note: `regression-models/ordinal-mixed-models.qmd`

The fitted points below set verb and respondent deviations to zero. The bars are raw response proportions for the same polarity-by-task cells. An ordinal mixed model combines the cumulative link introduced for ordinal regression with the group deviations introduced for generalized linear mixed models. That distinction will matter again on the next slide.

## Slide 140: Stating which groups are represented in a prediction

Source note: `regression-models/ordinal-mixed-models.qmd`

A prediction for an observed respondent and verb can condition on both estimated deviations. A prediction for a new respondent judging an observed verb may condition on the verb deviation but cannot reuse an observed respondent effect. A prediction for a new respondent and new verb must handle both group distributions. Setting both deviations to zero gives a location at the center of the link-scale distributions, as in the figure. Averaging category probabilities over either distribution generally produces different response-scale probabilities because the inverse cumulative-logit transformation is nonlinear. A reported probability must thus state which groups are represented in the target. That distinction will matter again on the next slide.

## Slide 141: What the fitted location can and cannot represent

Source note: `regression-models/ordinal-mixed-models.qmd`

A positive location shift moves probability toward higher ordered responses. It does not add a fixed number of slider points, because the response is categorical and the change depends on both thresholds and the starting location. The verb random slopes allow the polarity and task associations to vary across observed verbs. The respondent random intercept allows overall response location to vary across respondents. It cannot represent every response style: respondents might also differ in threshold spacing or in how often they use *maybe*. A location-intercept model leaves those possibilities outside its structure. The interpretation is conditional on the sampling and measurement design.

## Slide 142: Ordinal mixed models

Source note: `regression-models/ordinal-mixed-models.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Ordinal mixed models. Read the pattern before attaching a model interpretation to it.

## Slide 143: Interpretation

Source note: `regression-models/ordinal-mixed-models.qmd`

White and Rawlins normalize responses and study derived veridicality, factivity, responsivity, and clause-selection patterns. The course model instead analyzes raw ordered responses as a function of polarity and task. The interpretation is conditional on the sampling and measurement design.

## Slide 144: MegaVeridicality: prediction for unseen verbs

Source note: `regression-models/aspectual-similarity-example.qmd`

We now turn to MegaVeridicality: prediction for unseen verbs. The preceding ordinal-mixed-model page used MegaVeridicality to describe respondent and verb heterogeneity. This worked analysis asks a different question: does the polarity-by-task interaction improve response probabilities for clause-embedding verbs absent from fitting?

## Slide 145: MegaVeridicality: prediction for unseen verbs

Source note: `regression-models/aspectual-similarity-example.qmd`

The preceding ordinal-mixed-model page used MegaVeridicality to describe respondent and verb heterogeneity. This worked analysis asks a different question: does the polarity-by-task interaction improve response probabilities for clause-embedding verbs absent from fitting? The data remain the raw ordered judgments from White and Rawlins (2018) and the official MegaVeridicality project release. One row is one *no*, *maybe*, or *yes* response. The validation folds are frozen by verb before any model is fit. The interpretation is conditional on the sampling and measurement design.

## Slide 146: From ordered responses to a likelihood

Source note: `regression-models/aspectual-similarity-example.qmd`

For ordered category $k$ and fixed-effect location $\eta_i$, define where $F$ is the logistic cumulative distribution, $\kappa_0=-\infty$, and $\kappa_3=\infty$. The likelihood is Keep the observational unit fixed while you interpret the result.

## Slide 147: From ordered responses to a likelihood: equation 1

Source note: `regression-models/aspectual-similarity-example.qmd`

The displayed expression formalizes from ordered responses to a likelihood: equation 1. For ordered category $k$ and fixed-effect location $\eta_i$, define Keep track of what each term refers to in the linguistic dataset.

## Slide 148: From ordered responses to a likelihood: equation 2

Source note: `regression-models/aspectual-similarity-example.qmd`

The displayed expression formalizes from ordered responses to a likelihood: equation 2. where $F$ is the logistic cumulative distribution, $\kappa_0=-\infty$, and $\kappa_3=\infty$. The likelihood is Keep track of what each term refers to in the linguistic dataset.

## Slide 149: From ordered responses to a likelihood: equation 3

Source note: `regression-models/aspectual-similarity-example.qmd`

The displayed expression formalizes from ordered responses to a likelihood: equation 3. and its mean log score on held-out judgments is Keep track of what each term refers to in the linguistic dataset.

## Slide 150: Preparing the frozen verb folds

Source note: `regression-models/aspectual-similarity-example.qmd`

Every judgment for a verb belongs to the same fold. When fold $k$ is assessed, the training data contain no row from any fold-$k$ verb. This is a lexical-unit holdout, not a random row split. The preceding ordinal-mixed-model page used MegaVeridicality to describe respondent and verb heterogeneity. This worked analysis asks a different question: does the polarity-by-task interaction improve response probabilities for clause-embedding verbs absent from fitting? That distinction will matter again on the next slide.

## Slide 151: Showing the population model on the response scale

Source note: `regression-models/aspectual-similarity-example.qmd`

The full-data display below is descriptive. It compares raw cell proportions with a population cumulative-logit model containing the interaction. The mixed model on the preceding page adds respondent and verb deviations to this location structure. Those deviations are essential for describing observed heterogeneity. For the validation comparison, however, every assessment verb is new, so we compare two population `clm` specifications and ask only whether the fixed interaction transfers. Notice what is observed and what is supplied by the model.

## Slide 152: Comparing additive and interaction models by held-out verb

Source note: `regression-models/aspectual-similarity-example.qmd`

The row-weighted interaction gain is computed from the held-out folds: The interaction improves the mean log score in every frozen fold, but the row-weighted gain is small. Thus the interaction has consistent predictive support while the additive model remains a live comparison. The result does not classify verbs, estimate respondent variation, or reproduce the paper's normalized responsivity analysis. It asks one narrow question about transferring a population interaction to unseen verbs. Use the graph or equation to say the result in ordinary language.

## Slide 153: MegaVeridicality: prediction for unseen verbs

Source note: `regression-models/aspectual-similarity-example.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for MegaVeridicality: prediction for unseen verbs. Read the pattern before attaching a model interpretation to it.

## Slide 154: Interpretation

Source note: `regression-models/aspectual-similarity-example.qmd`

The interaction improves the mean log score in every frozen fold, but the row-weighted gain is small. Thus the interaction has consistent predictive support while the additive model remains a live comparison. Notice what is observed and what is supplied by the model.

## Slide 155: The Laplace approximation

Source note: `regression-models/laplace-approximation.qmd`

We now turn to The Laplace approximation. A generalized linear mixed model contains random effects that are not observed directly. The response likelihood is conditional on their values, and the model assigns those values a population distribution. A likelihood for the observed responses must thus average over every possible random-effect value.

## Slide 156: The Laplace approximation

Source note: `regression-models/laplace-approximation.qmd`

A generalized linear mixed model contains random effects that are not observed directly. The response likelihood is conditional on their values, and the model assigns those values a population distribution. A likelihood for the observed responses must thus average over every possible random-effect value. This integral usually has no elementary form for a logistic mixed model. The **Laplace approximation** replaces the log integrand with a quadratic near its highest point. We expose that computation with one participant intercept from the SuperTelicity release introduced on the GLMM page. Keep the observational unit fixed while you interpret the result.

## Slide 157: Why the integral appears

Source note: `regression-models/laplace-approximation.qmd`

For participant $p$, let $\mathbf y_p$ denote the binary preposition choices and $b_p$ the participant intercept. Conditional on $b_p$, the participant likelihood is The group model supplies $p(b_p\mid\tau)$. The observed-data contribution is Keep the observational unit fixed while you interpret the result.

## Slide 158: Why the integral appears: equation 1

Source note: `regression-models/laplace-approximation.qmd`

The displayed expression formalizes why the integral appears: equation 1. For participant $p$, let $\mathbf y_p$ denote the binary preposition choices and $b_p$ the participant intercept. Conditional on $b_p$, the participant likelihood is Keep track of what each term refers to in the linguistic dataset.

## Slide 159: Why the integral appears: equation 2

Source note: `regression-models/laplace-approximation.qmd`

The displayed expression formalizes why the integral appears: equation 2. The group model supplies $p(b_p\mid\tau)$. The observed-data contribution is Keep track of what each term refers to in the linguistic dataset.

## Slide 160: Expanding the log integrand

Source note: `regression-models/laplace-approximation.qmd`

Define Let $\widehat b$ maximize $h(b)$. At the mode, Use the graph or equation to say the result in ordinary language.

## Slide 161: Expanding the log integrand: equation 1

Source note: `regression-models/laplace-approximation.qmd`

The displayed expression formalizes expanding the log integrand: equation 1. Define Keep track of what each term refers to in the linguistic dataset.

## Slide 162: Expanding the log integrand: equation 2

Source note: `regression-models/laplace-approximation.qmd`

The displayed expression formalizes expanding the log integrand: equation 2. Let $\widehat b$ maximize $h(b)$. At the mode, Keep track of what each term refers to in the linguistic dataset.

## Slide 163: Expanding the log integrand: equation 3

Source note: `regression-models/laplace-approximation.qmd`

The displayed expression formalizes expanding the log integrand: equation 3. The second-order Taylor expansion is Keep track of what each term refers to in the linguistic dataset.

## Slide 164: Expanding the log integrand: equation 4

Source note: `regression-models/laplace-approximation.qmd`

The displayed expression formalizes expanding the log integrand: equation 4. The first-derivative term vanishes at the mode. Writing Keep track of what each term refers to in the linguistic dataset.

## Slide 165: Expanding the log integrand: equation 5

Source note: `regression-models/laplace-approximation.qmd`

The displayed expression formalizes expanding the log integrand: equation 5. gives Keep track of what each term refers to in the linguistic dataset.

## Slide 166: Expanding the log integrand: equation 6

Source note: `regression-models/laplace-approximation.qmd`

The displayed expression formalizes expanding the log integrand: equation 6. Exponentiating produces a normal-shaped approximation whose integral is Keep track of what each term refers to in the linguistic dataset.

## Slide 167: Expanding the log integrand: equation 7

Source note: `regression-models/laplace-approximation.qmd`

The displayed expression formalizes expanding the log integrand: equation 7. Equivalently, Keep track of what each term refers to in the linguistic dataset.

## Slide 168: Constructing the SuperTelicity integrand

Source note: `regression-models/laplace-approximation.qmd`

The complete teaching GLMM has participant, verb, and sentence intercepts. To make the integral one-dimensional and visible, this page fits a declared computational restriction with only the participant intercept. The selected participant has observed observed trials. This count and every likelihood quantity below come from the release. Now connect the notation back to the linguistic comparison.

## Slide 169: Comparing the exact integral with its local approximation

Source note: `regression-models/laplace-approximation.qmd`

Numerical integration is stabilized by subtracting the log integrand at the mode before exponentiation. The small difference is an empirical computation diagnostic for these observed trials. It is not an invented likelihood example and does not guarantee equal accuracy for every participant or for the higher-dimensional crossed model. Keep the observational unit fixed while you interpret the result.

## Slide 170: The Laplace approximation

Source note: `regression-models/laplace-approximation.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for The Laplace approximation. Read the pattern before attaching a model interpretation to it.

## Slide 171: Interpretation

Source note: `regression-models/laplace-approximation.qmd`

The one-intercept restriction exists only to expose the calculation. The crossed participant, verb, and sentence GLMM remains the scientific teaching model for SuperTelicity. That distinction will matter again on the next slide.

## Slide 172: Poisson mixed-effects models

Source note: `regression-models/poisson-mixed-models.qmd`

We now turn to Poisson mixed-effects models. We now combine Poisson regression, an exposure offset, and a random intercept in an analysis of aligned linguistic graphs.

## Slide 173: UCCA: the empirical object

Source note: `regression-models/poisson-mixed-models.qmd`

This is the first use of UCCA in this module. The slide names the observation represented in the teaching table and links the original source. We will keep that unit fixed when we compute and interpret quantities from these data.

## Slide 174: Poisson mixed-effects models

Source note: `regression-models/poisson-mixed-models.qmd`

We now combine Poisson regression, an exposure offset, and a random intercept in an analysis of aligned linguistic graphs. Sulem, Abend, and Rappoport's French-English UCCA study compares independently annotated passages from *Twenty Thousand Leagues Under the Sea*. The annotation follows Universal Conceptual Cognitive Annotation (UCCA). A UCCA Scene contains a Process or State main relation; it is not simply a finite clause or verb token. The interpretation is conditional on the sampling and measurement design.

## Slide 175: Stating the observation and target

Source note: `regression-models/poisson-mixed-models.qmd`

One row is one complete passage graph in English or French. `pair_id` joins the aligned translations. `word_count` is the number of annotated words, and `scene_count` counts distinct nodes with an outgoing Process or State edge. A remote reference to an existing node does not create another Scene. The target is the French-to-English Scene-rate ratio within this release, conditional on aligned passage-pair heterogeneity. It is a rate per annotated word, not a contrast in raw counts. The interpretation is conditional on the sampling and measurement design.

## Slide 176: Assembling the conditional model

Source note: `regression-models/poisson-mixed-models.qmd`

For passage pair $p$ and language side $l$, with probability mass That distinction will matter again on the next slide.

## Slide 177: Assembling the conditional model: equation 1

Source note: `regression-models/poisson-mixed-models.qmd`

The displayed expression formalizes assembling the conditional model: equation 1. For passage pair $p$ and language side $l$, Keep track of what each term refers to in the linguistic dataset.

## Slide 178: Assembling the conditional model: equation 2

Source note: `regression-models/poisson-mixed-models.qmd`

The displayed expression formalizes assembling the conditional model: equation 2. with probability mass Keep track of what each term refers to in the linguistic dataset.

## Slide 179: Assembling the conditional model: equation 3

Source note: `regression-models/poisson-mixed-models.qmd`

The displayed expression formalizes assembling the conditional model: equation 3. The log expected count combines word exposure, a language contrast, and the pair intercept: Keep track of what each term refers to in the linguistic dataset.

## Slide 180: Assembling the conditional model: equation 4

Source note: `regression-models/poisson-mixed-models.qmd`

The displayed expression formalizes assembling the conditional model: equation 4. where Keep track of what each term refers to in the linguistic dataset.

## Slide 181: Assembling the conditional model: equation 5

Source note: `regression-models/poisson-mixed-models.qmd`

The displayed expression formalizes assembling the conditional model: equation 5. Exponentiating gives Keep track of what each term refers to in the linguistic dataset.

## Slide 182: Assembling the conditional model: equation 6

Source note: `regression-models/poisson-mixed-models.qmd`

The displayed expression formalizes assembling the conditional model: equation 6. Dividing by exposure shows the modeled Scene rate: Keep track of what each term refers to in the linguistic dataset.

## Slide 183: Fitting the paired UCCA model

Source note: `regression-models/poisson-mixed-models.qmd`

Holding the passage-pair effect fixed, the fitted French Scene rate is observed times the fitted English rate per annotated word. The comparison is multiplicative because the model uses a log link. We now combine Poisson regression, an exposure offset, and a random intercept in an analysis of aligned linguistic graphs. Notice what is observed and what is supplied by the model.

## Slide 184: Showing observed counts and fitted rates

Source note: `regression-models/poisson-mixed-models.qmd`

The points below are observed passage counts. The fitted curves set the pair deviation to zero and vary word exposure, so the observations and model remain on the same count scale. We now combine Poisson regression, an exposure offset, and a random intercept in an analysis of aligned linguistic graphs. Keep the observational unit fixed while you interpret the result.

## Slide 185: Preserving the conditioning statement

Source note: `regression-models/poisson-mixed-models.qmd`

Conditional on $b_p$, the Poisson model has This statement concerns a passage pair with a given deviation. A prediction for a new pair must average over the fitted pair distribution. The next page shows why that averaging produces marginal variance greater than the marginal mean even though the conditional response remains Poisson. Keep the observational unit fixed while you interpret the result.

## Slide 186: Preserving the conditioning statement

Source note: `regression-models/poisson-mixed-models.qmd`

The displayed expression formalizes preserving the conditioning statement. Conditional on $b_p$, the Poisson model has Keep track of what each term refers to in the linguistic dataset.

## Slide 187: Poisson mixed-effects models

Source note: `regression-models/poisson-mixed-models.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Poisson mixed-effects models. Read the pattern before attaching a model interpretation to it.

## Slide 188: Interpretation

Source note: `regression-models/poisson-mixed-models.qmd`

Language is a fixed within-pair description of this translation release, not a random sample of languages. The corpus contains consecutive material from one novel, one translation, and one annotation history. The interpretation is conditional on the sampling and measurement design.

## Slide 189: Group heterogeneity and marginal dispersion

Source note: `regression-models/overdispersion-and-random-effects.qmd`

We now turn to Group heterogeneity and marginal dispersion. The Poisson mixed-model page supplied one source of structured count variation: persistent differences across aligned passage pairs. A Poisson regression without that structure can appear overdispersed because it combines low-rate and high-rate pairs under one mean.

## Slide 190: Group heterogeneity and marginal dispersion

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The Poisson mixed-model page supplied one source of structured count variation: persistent differences across aligned passage pairs. A Poisson regression without that structure can appear overdispersed because it combines low-rate and high-rate pairs under one mean. This extra variation arises after averaging over heterogeneous groups. It is not a new conditional response distribution. The distinction follows from the law of total variance. Use the graph or equation to say the result in ordinary language.

## Slide 191: Beginning with the conditional Poisson claim

Source note: `regression-models/overdispersion-and-random-effects.qmd`

For language side $l$ of passage pair $p$, write with The interpretation is conditional on the sampling and measurement design.

## Slide 192: Beginning with the conditional Poisson claim: equation 1

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes beginning with the conditional poisson claim: equation 1. For language side $l$ of passage pair $p$, write Keep track of what each term refers to in the linguistic dataset.

## Slide 193: Beginning with the conditional Poisson claim: equation 2

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes beginning with the conditional poisson claim: equation 2. with Keep track of what each term refers to in the linguistic dataset.

## Slide 194: Beginning with the conditional Poisson claim: equation 3

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes beginning with the conditional poisson claim: equation 3. where Keep track of what each term refers to in the linguistic dataset.

## Slide 195: Beginning with the conditional Poisson claim: equation 4

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes beginning with the conditional poisson claim: equation 4. is the expected count when the pair deviation is zero, and Keep track of what each term refers to in the linguistic dataset.

## Slide 196: Beginning with the conditional Poisson claim: equation 5

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes beginning with the conditional poisson claim: equation 5. Conditional on a particular pair effect, Keep track of what each term refers to in the linguistic dataset.

## Slide 197: Averaging over the passage-pair population

Source note: `regression-models/overdispersion-and-random-effects.qmd`

For a new aligned pair, the marginal mean is Because $b\sim\mathcal N(0,\tau_p^2)$, Keep the observational unit fixed while you interpret the result.

## Slide 198: Averaging over the passage-pair population: equation 1

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes averaging over the passage-pair population: equation 1. For a new aligned pair, the marginal mean is Keep track of what each term refers to in the linguistic dataset.

## Slide 199: Averaging over the passage-pair population: equation 2

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes averaging over the passage-pair population: equation 2. Because $b\sim\mathcal N(0,\tau_p^2)$, Keep track of what each term refers to in the linguistic dataset.

## Slide 200: Averaging over the passage-pair population: equation 3

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes averaging over the passage-pair population: equation 3. so Keep track of what each term refers to in the linguistic dataset.

## Slide 201: Averaging over the passage-pair population: equation 4

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes averaging over the passage-pair population: equation 4. The law of total variance gives Keep track of what each term refers to in the linguistic dataset.

## Slide 202: Averaging over the passage-pair population: equation 5

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes averaging over the passage-pair population: equation 5. The lognormal moment identity yields Keep track of what each term refers to in the linguistic dataset.

## Slide 203: Averaging over the passage-pair population: equation 6

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The displayed expression formalizes averaging over the passage-pair population: equation 6. Thus, Keep track of what each term refers to in the linguistic dataset.

## Slide 204: Substituting the fitted UCCA pair variance

Source note: `regression-models/overdispersion-and-random-effects.qmd`

At the observed-data fit, the population-center mean for an English passage with 100 annotated words is observed Scenes. Averaging over new passage-pair heterogeneity raises the mean to observed and gives marginal variance observed. The resulting marginal variance-to-mean ratio is observed. These values describe the fitted Poisson-lognormal model at one actual exposure value. They are not a simulated count example. The interpretation is conditional on the sampling and measurement design.

## Slide 205: Diagnosing conditional fit

Source note: `regression-models/overdispersion-and-random-effects.qmd`

The marginal moment identity does not tell us whether the conditional Poisson variance fits the observed within-model residual pattern. A Pearson diagnostic assesses that different question. The conditional Pearson ratio is observed, which is below one. These data are conditionally underdispersed relative to the fitted Poisson working model even though the pair intercept induces extra-Poisson *marginal* variance. The two claims refer to different conditioning levels and can hold simultaneously. Now connect the notation back to the linguistic comparison.

## Slide 206: Group heterogeneity and marginal dispersion

Source note: `regression-models/overdispersion-and-random-effects.qmd`

Start with the axes and the observed values. Observed data and fitted quantities for Group heterogeneity and marginal dispersion. Read the pattern before attaching a model interpretation to it.

## Slide 207: Interpretation

Source note: `regression-models/overdispersion-and-random-effects.qmd`

Random intercepts thus do not repair every dispersion pattern. They are licensed by a known repeated unit and explain one structured source of variation. Remaining conditional underdispersion, omitted predictors, varying associations, or another response family require separate model criticism. That distinction will matter again on the next slide.
