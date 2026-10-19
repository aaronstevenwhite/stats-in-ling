# Learning beyond the observed sample

This transcript is generated from the speaker notes in the slide source. Slide identifiers, titles, note-page provenance, and order are identical.

## Slide 1: Learning beyond the observed sample

Source note: `statistical-inference/index.qmd`

Welcome to Learning beyond the observed sample. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.

## Slide 2: Learning from a sample

Source note: `statistical-inference/index.qmd`

Now we turn to Learning from a sample.

## Slide 3: Learning from a sample

Source note: `statistical-inference/index.qmd`

An empirical proportion depends on which units receive equal weight. A token proportion weights every retained token equally. An average of speaker proportions first weights tokens within speaker and then weights speakers equally. These are different weighting schemes, and they may target different quantities because their denominators represent different units.

## Slide 4: Learning from a sample

Source note: `statistical-inference/index.qmd`

Neither summary is automatically a population quantity. If the research question concerns speakers in a region, the population includes speakers who did not contribute to the corpus. The question for this module is thus not merely how to calculate a sample summary. It is: what can the observed speakers and clauses tell us about a specified quantity in a specified population?

## Slide 5: Populations, samples, and estimators

Source note: `statistical-inference/index.qmd`

We begin by distinguishing populations from samples. The population must identify the units to which the claim applies, while the sample contains the units that were observed. An independent sampling model then states how repeated observations are related to a population parameter.

## Slide 6: Populations, samples, and estimators

Source note: `statistical-inference/index.qmd`

The pronoun case example uses a binomial model for one corpus proportion. Maximum likelihood selects the parameter value that assigns the greatest probability to the observed sample. An estimator is the rule that maps each possible sample to an estimate, while the estimate is the value obtained from the realized sample.

## Slide 7: Populations, samples, and estimators

Source note: `statistical-inference/index.qmd`

The sampling distribution of an estimator allows us to define its standard error, bias, and mean squared error. Confidence intervals and exact binomial intervals are procedures whose coverage is defined across repeated samples. Null hypotheses and test statistics compare an observed statistic with a reference distribution under a stated null hypothesis.

## Slide 8: Populations, samples, and estimators

Source note: `statistical-inference/index.qmd`

Later pages apply these definitions in increasing order of design complexity: first to one mean, then to paired acoustic measurements, then to two independent means, and finally to contingency tables. In each case, we will name the independent unit before calculating an interval or test.

## Slide 9: Updating uncertainty with Bayes' rule

Source note: `statistical-inference/index.qmd`

Bayesian inference begins with a probability model for the observations and adds a probability distribution over unknown parameters. The posterior distribution page uses Bayes' rule to combine a prior distribution and likelihood. The posterior summaries page then asks which features of that distribution address a particular linguistic claim.

## Slide 10: Updating uncertainty with Bayes' rule

Source note: `statistical-inference/index.qmd`

Some posterior distributions can be calculated algebraically. Conjugate priors make one class of such calculations possible by keeping the posterior in a known family.

## Slide 11: Updating uncertainty with Bayes' rule

Source note: `statistical-inference/index.qmd`

The next distinction concerns prediction. A prior predictive distribution states what the model predicts before the present observations update it, while a posterior predictive distribution states what it predicts after that update. Both distributions put the prediction on an observable response scale. Other models leave a posterior that is mathematically defined but not available as a familiar normalized formula. We thus begin with a finite update, summarize it, derive a conjugate update, predict before and after conditioning, and only then turn to numerical approximation. This order keeps the inferential target separate from the algorithm used to approximate it.

## Slide 12: Posterior computation and checking

Source note: `statistical-inference/index.qmd`

The computational sequence also has an order. Monte Carlo integration first explains why averages of target draws approximate expectations. Importance sampling changes the distribution used to produce those draws. Markov chains and Markov chain Monte Carlo then permit dependent draws when direct independent sampling is unavailable.

## Slide 13: Posterior computation and checking

Source note: `statistical-inference/index.qmd`

The remaining pages move from Metropolis-Hastings transitions to Hamiltonian Monte Carlo and Stan's implementation. Only after the sampler has been defined do we read trace plots, $\widehat R$, autocorrelation, effective sample size, divergences, and parameter pairs. Generated quantities and posterior predictive checks then return us to the response scale. This final return matters: a sampler may accurately approximate a posterior for a model that predicts the linguistic data poorly.

## Slide 14: Posterior computation and checking

Source note: `statistical-inference/index.qmd`

For each inferential result, identify the population quantity, the sampling or observation model, and the procedure that maps the realized sample to the reported value. A token proportion, an average speaker proportion, and a regional population proportion remain three different quantities even when they are calculated from the same file.

## Slide 15: Posterior computation and checking

Source note: `statistical-inference/index.qmd`

The chapter dependency graph shows the probability concepts used in this module. We assume the earlier definitions of conditional probability, independence, expectation, and variance. Begin with populations and samples.

## Slide 16: Populations and samples

Source note: `statistical-inference/populations-and-samples.qmd`

Now we turn to Populations and samples.

## Slide 17: UD Turkish BOUN: the empirical object

Source note: `statistical-inference/populations-and-samples.qmd`

The data source is Türk et al. (2022), UD Turkish BOUN 2.18. It provides manually reviewed Turkish Universal Dependencies tokens.

## Slide 18: Populations and samples

Source note: `statistical-inference/populations-and-samples.qmd`

Statistical inference begins by specifying the target population. That population is not defined until its units and their route into the data have been stated.

## Slide 19: A finite linguistic population

Source note: `statistical-inference/populations-and-samples.qmd`

We begin with UD Turkish BOUN, release 2.18, a Universal Dependencies treebank for Turkish, a Turkic language. Türk et al. (2022) describe the source and annotation process, while Marşan et al. (2022) document the agglutination-sensitive revisions. The release contains written sentences sampled within five selected Turkish National Corpus registers. Native-speaker linguists manually annotated and cross-checked automatically preprocessed material.

## Slide 20: A finite linguistic population

Source note: `statistical-inference/populations-and-samples.qmd`

The teaching extract contains each token tagged `UPOS=PRON` and `PronType=Prs` with an attested UD `Case` value. One row is one annotated token nested in a sampled sentence. The release is CC BY-SA 4.0, subject to the upstream permission conditions described in the Turkish National Corpus paper.

## Slide 21: A finite linguistic population

Source note: `statistical-inference/populations-and-samples.qmd`

This table is a census of the qualifying rows in one pinned release. It is not a probability sample of all Turkish personal-pronoun uses.

## Slide 22: Defining the objects

Source note: `statistical-inference/populations-and-samples.qmd`

A parameter describes the modeled population; an estimator is a sample rule; an estimate is that rule's realized value.

## Slide 23: Defining the objects

Source note: `statistical-inference/populations-and-samples.qmd`

For a binary indicator $X_i$ that equals one when token $i$ bears `Case=Acc`, the finite-release proportion is

$$
p_{\mathcal R}
=\frac{1}{N_{\mathcal R}}\sum_{i=1}^{N_{\mathcal R}}X_i,
$$

where $\mathcal R$ denotes this release and $N_{\mathcal R}$ is its number of qualifying token rows.

## Slide 24: Defining the objects

Source note: `statistical-inference/populations-and-samples.qmd`

the calculation computes that finite-population parameter directly.

## Slide 25: Defining the objects

Source note: `statistical-inference/populations-and-samples.qmd`

Thus $p_{\mathcal R}=$ 0.2021 for the pinned release. There is no sampling uncertainty about this arithmetic once the release and filtering rule are fixed.

## Slide 26: Defining the objects

Source note: `statistical-inference/populations-and-samples.qmd`

This figure shows case counts among personal-pronoun tokens in UD Turkish BOUN 2.18.

## Slide 27: The route into the release

Source note: `statistical-inference/populations-and-samples.qmd`

The source design matters. Approximately two thousand sentences were sampled within each of five selected written registers, and tokens are nested within those sentences. Thus a token-level analysis has more rows than sampled sentences, while neither count makes the registers a random sample of Turkish registers.

## Slide 28: The route into the release (1 of 2)

Source note: `statistical-inference/populations-and-samples.qmd`

Two different claims consequently require different targets: The finite-release claim concerns the qualifying annotated tokens in BOUN 2.18, whose exact parameter is computed from the release.

## Slide 29: The route into the release (2 of 2)

Source note: `statistical-inference/populations-and-samples.qmd`

Two different claims consequently require different targets: A usage claim concerns tokens that could arise from a specified Turkish production process. Connecting the release to that process requires a sampling model and assumptions about registers, sentences, and annotation.

## Slide 30: The route into the release

Source note: `statistical-inference/populations-and-samples.qmd`

This distinction is not repaired by a large row count. More token rows may yield a more precise description of the release while leaving its connection to Turkish usage unchanged.

## Slide 31: Populations and samples: question 1

Source note: `statistical-inference/populations-and-samples.qmd`

What is the observational unit in `pronouns`, and what was the source selection unit?

## Slide 32: Populations and samples: answer 1

Source note: `statistical-inference/populations-and-samples.qmd`

One row is an annotated personal-pronoun token; the source design selected sentences within five written registers.

## Slide 33: Populations and samples: question 2

Source note: `statistical-inference/populations-and-samples.qmd`

Why is the computed proportion a parameter of the pinned release but only an estimate for a broader usage process?

## Slide 34: Populations and samples: answer 2

Source note: `statistical-inference/populations-and-samples.qmd`

The release and filter fix all qualifying rows, so the proportion is a known release parameter. A broader usage claim requires a sampling model, making the same quantity an estimate.

## Slide 35: Populations and samples: question 3

Source note: `statistical-inference/populations-and-samples.qmd`

Which identifiers reveal dependence among token rows?

## Slide 36: Populations and samples: answer 3

Source note: `statistical-inference/populations-and-samples.qmd`

Repeated `sentence_id` values show that token rows are nested within sentences; `register` also marks a shared source context.

## Slide 37: Populations and samples: question 4

Source note: `statistical-inference/populations-and-samples.qmd`

What additional design information would be needed to generalize to spoken Turkish?

## Slide 38: Populations and samples: answer 4

Source note: `statistical-inference/populations-and-samples.qmd`

We would need a spoken-language sampling frame, selection probabilities for speakers and speech settings, and identifiers for speaker, conversation, and recording dependence. The next page states a working sampling model while keeping this unit hierarchy visible.

## Slide 39: Independent sampling

Source note: `statistical-inference/independent-sampling.qmd`

Our next step is Independent sampling.

## Slide 40: Independent sampling

Source note: `statistical-inference/independent-sampling.qmd`

The preceding page distinguished the finite BOUN release from a broader Turkish usage process. We now introduce an **IID working model** for the accusative indicators and then inspect where that model strains against the corpus design.

## Slide 41: Identical distributions and independence

Source note: `statistical-inference/independent-sampling.qmd`

Let

$$
X_i=
\begin{cases}
1 & \text{if personal-pronoun token }i\text{ bears `Case=Acc'},\\
0 & \text{otherwise}.
\end{cases}
$$

## Slide 42: Identical distributions and independence

Source note: `statistical-inference/independent-sampling.qmd`

The identically distributed claim is

$$
X_i\sim\operatorname{Bernoulli}(p)
$$

for every $i$.

## Slide 43: Identical distributions and independence

Source note: `statistical-inference/independent-sampling.qmd`

It says that each modeled token has the same probability $p$, not that the observed case values are identical.

## Slide 44: Identical distributions and independence

Source note: `statistical-inference/independent-sampling.qmd`

Conditional mutual independence adds

$$
p(x_1,\ldots,x_n\mid p)
=\prod_{i=1}^n p(x_i\mid p).
$$

## Slide 45: Identical distributions and independence

Source note: `statistical-inference/independent-sampling.qmd`

Together, the claims are written

$$
X_1,\ldots,X_n\mathrel{\overset{\mathrm{IID}}{\sim}}
\operatorname{Bernoulli}(p).
$$

## Slide 46: An observed sequence

Source note: `statistical-inference/independent-sampling.qmd`

the calculation loads the audited BOUN extract, estimates the shared probability from all qualifying release rows, and selects the first source-ordered token sequence. Thus neither the outcomes nor the probability are schematic.

## Slide 47: An observed sequence

Source note: `statistical-inference/independent-sampling.qmd`

The probability of this exact ordered sequence under the pooled working model is 1.082e-03. If the observed sequence contains $k$ accusative tokens, its product has the form

$$
\begin{aligned}
p(\mathbf x\mid p)
&=\prod_{i=1}^{n}p^{x_i}(1-p)^{1-x_i}\\
&=p^k(1-p)^{n-k}.
\end{aligned}
$$

## Slide 48: An observed sequence

Source note: `statistical-inference/independent-sampling.qmd`

The second line follows because multiplication ignores order after the exact sequence has been observed. A binomial probability for the unordered count would additionally multiply by ${n\choose k}$.

## Slide 49: Inspecting the shared-probability claim

Source note: `statistical-inference/independent-sampling.qmd`

The release preserves five register labels. Their observed accusative proportions expose variation that the pooled model suppresses.

## Slide 50: Inspecting the shared-probability claim

Source note: `statistical-inference/independent-sampling.qmd`

The register-specific accusative proportions vary around the pooled estimate. That variation is what the shared-$p$ model suppresses.

## Slide 51: Inspecting the shared-probability claim

Source note: `statistical-inference/independent-sampling.qmd`

Tokens also repeat sentences, and nearby sentences may share documents even though document identifiers are unavailable. The product likelihood is thus a transparent working approximation, not a consequence of the file having distinct rows.

## Slide 52: Independent sampling: question 1

Source note: `statistical-inference/independent-sampling.qmd`

Which assumption permits the joint probability to factor into token-level probabilities?

## Slide 53: Independent sampling: answer 1

Source note: `statistical-inference/independent-sampling.qmd`

Conditional mutual independence permits the joint probability to factor into token-level probabilities.

## Slide 54: Independent sampling: question 2

Source note: `statistical-inference/independent-sampling.qmd`

Why does the ordered-sequence probability omit ${n\choose k}$?

## Slide 55: Independent sampling: answer 2

Source note: `statistical-inference/independent-sampling.qmd`

The calculation concerns one exact ordered sequence. The factor ${n\choose k}$ is needed only when summing over every ordering with the same count.

## Slide 56: Independent sampling: question 3

Source note: `statistical-inference/independent-sampling.qmd`

Which feature of the plot challenges the identical-distribution assumption?

## Slide 57: Independent sampling: answer 3

Source note: `statistical-inference/independent-sampling.qmd`

The observed accusative proportions differ across BOUN registers, challenging one common token probability.

## Slide 58: Independent sampling: question 4

Source note: `statistical-inference/independent-sampling.qmd`

Why can unique token identifiers coexist with dependence?

## Slide 59: Independent sampling: answer 4

Source note: `statistical-inference/independent-sampling.qmd`

Distinct identifiers label rows; they do not prevent rows from sharing a sentence, document, register, or other source of dependence. The corpus-proportion page turns this indicator into an empirical mean and variance.

## Slide 60: A corpus proportion

Source note: `statistical-inference/pronoun-case-example.qmd`

Next, we take up A corpus proportion.

## Slide 61: A corpus proportion

Source note: `statistical-inference/pronoun-case-example.qmd`

The IID model on the preceding page used the actual accusative labels in UD Turkish BOUN. We now connect that coding to the mean and variance of a Bernoulli variable.

## Slide 62: From annotation to random variable

Source note: `statistical-inference/pronoun-case-example.qmd`

One row remains one personal-pronoun token nested in a sampled sentence. The binary response is a deterministic recoding of the source UD `Case` value:

$$
X_i=\mathbb I\{\text{case}_i=\text{Acc}\}.
$$

## Slide 63: From annotation to random variable

Source note: `statistical-inference/pronoun-case-example.qmd`

For $X\sim\operatorname{Bernoulli}(p)$, the two possible values give

$$
\mathbb{E}[X]
=0(1-p)+1(p)=p
$$

and, because $X^2=X$,

$$
\begin{aligned}
\operatorname{Var}[X]
&=\mathbb{E}[X^2]-\mathbb{E}[X]^2\\
&=p-p^2\\
&=p(1-p).
\end{aligned}
$$

## Slide 64: From annotation to random variable

Source note: `statistical-inference/pronoun-case-example.qmd`

The sample analogue of the mean is

$$
\widehat p=\overline X
=\frac{1}{n}\sum_{i=1}^n X_i
=\frac{k}{n}.
$$

## Slide 65: From annotation to random variable

Source note: `statistical-inference/pronoun-case-example.qmd`

For this release, the empirical calculation yields $\widehat p=$ 0.2021 and the fitted Bernoulli variance 0.1612.

## Slide 66: Variation hidden by the pooled proportion

Source note: `statistical-inference/pronoun-case-example.qmd`

The red line is the pooled accusative proportion. The register-specific points show why one shared probability may be too restrictive.

## Slide 67: Variation hidden by the pooled proportion

Source note: `statistical-inference/pronoun-case-example.qmd`

The pooled proportion describes the release under this coding. It does not explain case choice, and the register differences suggest that one shared probability may be too restrictive. Case depends on grammatical function and construction, while token rows also inherit sentence-level dependence.

## Slide 68: A corpus proportion: question 1

Source note: `statistical-inference/pronoun-case-example.qmd`

Why does the mean of the indicator equal a proportion?

## Slide 69: A corpus proportion: answer 1

Source note: `statistical-inference/pronoun-case-example.qmd`

The indicator is one for an accusative token and zero otherwise, so its sample mean is the number of accusative tokens divided by the number of tokens.

## Slide 70: A corpus proportion: question 2

Source note: `statistical-inference/pronoun-case-example.qmd`

Derive the Bernoulli variance using $\mathbb{E}[X^2]$.

## Slide 71: A corpus proportion: answer 2

Source note: `statistical-inference/pronoun-case-example.qmd`

$\mathbb{E}[X^2]=\mathbb{E}[X]=p$ because $X^2=X$. Thus $\operatorname{Var}[X]=p-p^2=p(1-p)$.

## Slide 72: A corpus proportion: question 3

Source note: `statistical-inference/pronoun-case-example.qmd`

What does the red line represent in the figure?

## Slide 73: A corpus proportion: answer 3

Source note: `statistical-inference/pronoun-case-example.qmd`

The red line is the pooled accusative proportion across all qualifying BOUN release rows.

## Slide 74: A corpus proportion: question 4

Source note: `statistical-inference/pronoun-case-example.qmd`

Name a syntactic predictor that a substantive model of Turkish case might include.

## Slide 75: A corpus proportion: answer 4

Source note: `statistical-inference/pronoun-case-example.qmd`

A substantive model might include grammatical function, such as whether the pronoun is a direct object. The next page asks which shared probability makes the observed release labels most probable under the working model.

## Slide 76: Maximum likelihood

Source note: `statistical-inference/maximum-likelihood.qmd`

Now we turn to Maximum likelihood.

## Slide 77: Maximum likelihood

Source note: `statistical-inference/maximum-likelihood.qmd`

Under the provisional Bernoulli model for BOUN accusative labels, which value of the shared probability $p$ makes the observed token sequence most probable? **Maximum likelihood estimation** answers this question by holding the data fixed and varying $p$.

## Slide 78: Probability and likelihood

Source note: `statistical-inference/maximum-likelihood.qmd`

For one observation,

$$
p(x_i\mid p)=p^{x_i}(1-p)^{1-x_i}.
$$

## Slide 79: Probability and likelihood

Source note: `statistical-inference/maximum-likelihood.qmd`

Conditional independence gives the probability of an ordered sample:

$$
\begin{aligned}
p(\mathbf x\mid p)
&=\prod_{i=1}^n p^{x_i}(1-p)^{1-x_i}\\
&=p^k(1-p)^{n-k},
\end{aligned}
$$

where $k=\sum_i x_i$.

## Slide 80: Probability and likelihood

Source note: `statistical-inference/maximum-likelihood.qmd`

As a probability distribution, this expression varies over possible data at fixed $p$. As a likelihood,

$$
L(p;\mathbf x)=p^k(1-p)^{n-k},
$$

it compares parameter values for the data that were actually observed.

## Slide 81: Deriving the estimator

Source note: `statistical-inference/maximum-likelihood.qmd`

The log likelihood is

$$
\ell(p)=k\log p+(n-k)\log(1-p).
$$

## Slide 82: Deriving the estimator

Source note: `statistical-inference/maximum-likelihood.qmd`

Differentiate and set the score to zero:

$$
\begin{aligned}
\frac{\partial\ell}{\partial p}
&=\frac{k}{p}-\frac{n-k}{1-p}=0,\\
k(1-p)&=(n-k)p,\\
\widehat p_{\mathrm{MLE}}&=\frac{k}{n}.
\end{aligned}
$$

## Slide 83: Deriving the estimator

Source note: `statistical-inference/maximum-likelihood.qmd`

The second derivative,

$$
\frac{\partial^2\ell}{\partial p^2}
=-\frac{k}{p^2}-\frac{n-k}{(1-p)^2},
$$

is negative in the interior whenever both outcomes occur.

## Slide 84: Deriving the estimator

Source note: `statistical-inference/maximum-likelihood.qmd`

The stationary point is thus the unique maximum.

## Slide 85: Fitting the BOUN labels

Source note: `statistical-inference/maximum-likelihood.qmd`

The analytic and numerical estimates agree at $\widehat p=$ 0.202068.

## Slide 86: Fitting the BOUN labels

Source note: `statistical-inference/maximum-likelihood.qmd`

Relative Bernoulli log likelihood for the BOUN accusative labels. The vertical line marks the maximum.

## Slide 87: Fitting the BOUN labels

Source note: `statistical-inference/maximum-likelihood.qmd`

This estimate maximizes the likelihood within a model that treats token indicators as IID. It does not establish that the model is adequate, remove register variation, or generalize the finite treebank to all Turkish usage.

## Slide 88: Maximum likelihood: question 1

Source note: `statistical-inference/maximum-likelihood.qmd`

Why can a likelihood fail to sum or integrate to one over parameter values?

## Slide 89: Maximum likelihood: answer 1

Source note: `statistical-inference/maximum-likelihood.qmd`

A likelihood is a function of the parameter for fixed observed data; it is not required to normalize over parameter values.

## Slide 90: Maximum likelihood: question 2

Source note: `statistical-inference/maximum-likelihood.qmd`

Which statistic of the binary data appears in the likelihood after terms are collected?

## Slide 91: Maximum likelihood: answer 2

Source note: `statistical-inference/maximum-likelihood.qmd`

Only the number of successes, $k=\sum_i x_i$, appears after the Bernoulli terms are collected.

## Slide 92: Maximum likelihood: question 3

Source note: `statistical-inference/maximum-likelihood.qmd`

How does the second derivative establish that the stationary point is a maximum?

## Slide 93: Maximum likelihood: answer 3

Source note: `statistical-inference/maximum-likelihood.qmd`

The second derivative is negative for every interior $p$ when both outcomes occur, so the stationary point is the unique maximum.

## Slide 94: Maximum likelihood: question 4

Source note: `statistical-inference/maximum-likelihood.qmd`

Which part of the treebank structure is absent from this likelihood?

## Slide 95: Maximum likelihood: answer 4

Source note: `statistical-inference/maximum-likelihood.qmd`

The likelihood omits the nesting of tokens within sentences and registers, as well as any document structure. The Poisson maximum-likelihood page applies the same logic to sentence-level counts.

## Slide 96: Poisson maximum likelihood

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

Now we turn to Poisson maximum likelihood.

## Slide 97: Poisson maximum likelihood

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

The Bernoulli likelihood represented one case label per token. A different question asks how many annotated personal pronouns occur in one BOUN sentence. The response is now a nonnegative count, including sentences with no qualifying pronoun.

## Slide 98: Constructing the sentence counts

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

The full UD Turkish BOUN 2.18 release defines the sentence total used below. The pronoun extract identifies every sentence with at least one selected token; subtracting those distinct identifiers from the release total reconstructs the zero count exactly. The zero rows lack recoverable document or register identifiers, so the analysis cannot model those sources of structure.

## Slide 99: Deriving the Poisson estimator

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

Suppose, as a working model, that

$$
Y_i\mathrel{\overset{\mathrm{IID}}{\sim}}\operatorname{Poisson}(\lambda).
$$

## Slide 100: Deriving the Poisson estimator

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

For one sentence,

$$
p(y_i\mid\lambda)=\frac{\lambda^{y_i}e^{-\lambda}}{y_i!}.
$$

## Slide 101: Deriving the Poisson estimator

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

The likelihood and log likelihood are

$$
L(\lambda;\mathbf y)
=\prod_{i=1}^n\frac{\lambda^{y_i}e^{-\lambda}}{y_i!}
$$

and

$$
\ell(\lambda)
=\left(\sum_{i=1}^n y_i\right)\log\lambda
-n\lambda
-\sum_{i=1}^n\log(y_i!).
$$

## Slide 102: Deriving the Poisson estimator

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

Thus

$$
\frac{\partial\ell}{\partial\lambda}
=\frac{\sum_i y_i}{\lambda}-n,
$$

and setting the score to zero gives

$$
\widehat\lambda_{\mathrm{MLE}}
=\frac{1}{n}\sum_{i=1}^n y_i
=\overline y.
$$

## Slide 103: Fit and model check

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

The fitted mean is 0.2180 pronouns per sentence. But the empirical variance is 0.2822, producing a variance-to-mean ratio of 1.294 rather than the Poisson value of one.

## Slide 104: Fit and model check

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

This figure shows observed sentence-count probabilities and probabilities under the fitted Poisson model.

## Slide 105: Fit and model check

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

The observed zero proportion is 0.8231, compared with 0.8041 under the fitted model. The mismatch shows that maximizing a likelihood does not guarantee adequate fit. It does not, by itself, identify register, document, or syntactic structure as the source of extra variation.

## Slide 106: Poisson maximum likelihood: question 1

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

Why must zero-pronoun sentences enter the likelihood?

## Slide 107: Poisson maximum likelihood: answer 1

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

Zero-count sentences are part of the sentence population and contribute the factor $e^{-\lambda}$; excluding them would condition on observing at least one pronoun and inflate the fitted mean.

## Slide 108: Poisson maximum likelihood: question 2

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

Show how the Poisson score equation yields the sample mean.

## Slide 109: Poisson maximum likelihood: answer 2

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

Setting $\partial\ell/\partial\lambda=(\sum_i y_i)/\lambda-n$ to zero gives $\widehat\lambda=(\sum_i y_i)/n=\overline y$.

## Slide 110: Poisson maximum likelihood: question 3

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

Which visible feature of the fitted distribution misses the data?

## Slide 111: Poisson maximum likelihood: answer 3

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

The fitted Poisson probabilities miss the observed count shape, including the observed mass at zero and the heavier occurrence of multiple-pronoun sentences.

## Slide 112: Poisson maximum likelihood: question 4

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

Why can we not diagnose document clustering from this prepared count vector?

## Slide 113: Poisson maximum likelihood: answer 4

Source note: `statistical-inference/poisson-maximum-likelihood.qmd`

The reconstructed zero rows have no document identifiers, so the prepared vector cannot show which sentences share documents. The next page treats an estimator as a random variable across repeated samples.

## Slide 114: Properties of estimators

Source note: `statistical-inference/properties-of-estimators.qmd`

Now we turn to Properties of estimators.

## Slide 115: Hillenbrand et al. (1995): the empirical object

Source note: `statistical-inference/properties-of-estimators.qmd`

The data source is Hillenbrand et al. (1995). It provides American English /hVd/ vowel tokens with acoustic measurements.

## Slide 116: Properties of estimators

Source note: `statistical-inference/properties-of-estimators.qmd`

An estimate is one realized number. An **estimator** is the rule that would produce an estimate from every possible sample, and its **sampling distribution** describes the estimates that rule would produce across repeated samples.

## Slide 117: A nonparametric bootstrap from the observed cohort

Source note: `statistical-inference/properties-of-estimators.qmd`

We use the vowel measurements of Hillenbrand et al. (1995), distributed here through `phonTools::h95` under the package's BSD 2-Clause terms. The study recorded 45 adult men, 48 adult women, 27 boys, and 19 girls producing the same 12 /hVd/ vowels. One row is one vowel token nested within a speaker.

## Slide 118: A nonparametric bootstrap from the observed cohort

Source note: `statistical-inference/properties-of-estimators.qmd`

The teaching table contains complete duration measurements. Its F2 and F3 columns include package-supplied imputations, but those columns play no role here. We focus on the 48 adult women producing /I/ in *hid*. A nonparametric bootstrap samples these observed speaker rows with replacement. It is useful for studying estimator behavior conditional on the cohort, but it does not reconstruct recruitment from all American English speakers.

## Slide 119: Estimators are random variables

Source note: `statistical-inference/properties-of-estimators.qmd`

For a sample $X_1,\ldots,X_n$, the sample-mean estimator is

$$
T(\mathbf X)=\overline X=\frac{1}{n}\sum_{i=1}^nX_i.
$$

## Slide 120: Estimators are random variables

Source note: `statistical-inference/properties-of-estimators.qmd`

Before sampling, $T(\mathbf X)$ is a random variable. After observing one sample $\mathbf x$, $T(\mathbf x)$ is an estimate. A useful sampling distribution is described by its expectation and variance:

$$
\mathbb{E}[T(\mathbf X)]
\qquad\text{and}\qquad
\operatorname{Var}[T(\mathbf X)].
$$

## Slide 121: Estimators are random variables

Source note: `statistical-inference/properties-of-estimators.qmd`

The following simulation uses the observed adult-women group size and a fixed seed. The resampling unit is a speaker row.

## Slide 122: Estimators are random variables

Source note: `statistical-inference/properties-of-estimators.qmd`

Empirical sampling distribution of the mean /I/ duration from speaker-row resamples. The line marks the empirical cohort mean.

## Slide 123: Estimators are random variables

Source note: `statistical-inference/properties-of-estimators.qmd`

The estimates vary even though the empirical target remains fixed at 241.396 ms. This distinction between response variation and estimator variation is the foundation for standard errors, bias, and confidence intervals.

## Slide 124: Properties of estimators: question 1

Source note: `statistical-inference/properties-of-estimators.qmd`

Which object changes across the bootstrap samples, and which target remains fixed?

## Slide 125: Properties of estimators: answer 1

Source note: `statistical-inference/properties-of-estimators.qmd`

The resampled speaker rows, and thus the estimated means, change across draws; the empirical cohort mean remains fixed.

## Slide 126: Properties of estimators: question 2

Source note: `statistical-inference/properties-of-estimators.qmd`

What is the resampling unit?

## Slide 127: Properties of estimators: answer 2

Source note: `statistical-inference/properties-of-estimators.qmd`

The resampling unit is one adult-woman speaker row for /I/ in *hid*.

## Slide 128: Properties of estimators: question 3

Source note: `statistical-inference/properties-of-estimators.qmd`

Why would resampling all twelve vowel rows independently break the speaker structure?

## Slide 129: Properties of estimators: answer 3

Source note: `statistical-inference/properties-of-estimators.qmd`

The twelve vowel measurements from one speaker are dependent. Row-wise resampling would separate measurements that belong to the same speaker.

## Slide 130: Properties of estimators: question 4

Source note: `statistical-inference/properties-of-estimators.qmd`

What population claim does this nonparametric bootstrap not license?

## Slide 131: Properties of estimators: answer 4

Source note: `statistical-inference/properties-of-estimators.qmd`

This nonparametric bootstrap does not license a claim about all American English speakers or reproduce the study's recruitment process. The next page relates the spread of this sampling distribution to sample size.

## Slide 132: Standard errors

Source note: `statistical-inference/standard-errors.qmd`

Our next step is Standard errors.

## Slide 133: Standard errors

Source note: `statistical-inference/standard-errors.qmd`

The **standard error** of an estimator is the standard deviation of its sampling distribution. We continue with the nonparametric bootstrap of the Hillenbrand cohort introduced on the preceding page.

## Slide 134: Deriving the standard error of a mean

Source note: `statistical-inference/standard-errors.qmd`

If $X_1,\ldots,X_n$ are independent with common variance $\sigma^2$, then

$$
\begin{aligned}
\operatorname{Var}[\overline X]
&=\operatorname{Var}[\frac{1}{n}\sum_{i=1}^nX_i]\\
&=\frac{1}{n^2}\sum_{i=1}^n\operatorname{Var}[X_i]\\
&=\frac{\sigma^2}{n}.
\end{aligned}
$$

## Slide 135: Deriving the standard error of a mean

Source note: `statistical-inference/standard-errors.qmd`

Thus

$$
\operatorname{SE}(\overline X)=\frac{\sigma}{\sqrt n}.
$$

## Slide 136: Deriving the standard error of a mean

Source note: `statistical-inference/standard-errors.qmd`

The second equality uses independence. With covariance among observations, the omitted covariance terms may change the result.

## Slide 137: Checking the relation in vowel durations

Source note: `statistical-inference/standard-errors.qmd`

The four sample sizes below are not arbitrary: they are the observed counts of girls, boys, men, and women in Hillenbrand et al.'s speaker cohort. The duration distribution remains the adult-women /I/ distribution so that only $n$ changes.

## Slide 138: Checking the relation in vowel durations

Source note: `statistical-inference/standard-errors.qmd`

This figure shows bootstrap standard errors (points) and analytic values under the empirical distribution (line).

## Slide 139: Checking the relation in vowel durations

Source note: `statistical-inference/standard-errors.qmd`

At the observed adult-women sample size, the simulation gives 7.615 ms, compared with the analytic value 7.580 ms.

## Slide 140: Checking the relation in vowel durations

Source note: `statistical-inference/standard-errors.qmd`

When $\sigma$ is unknown, ordinary data analysis substitutes the sample standard deviation $s$:

$$
\widehat{\operatorname{SE}}(\overline X)=\frac{s}{\sqrt n}.
$$

## Slide 141: Checking the relation in vowel durations

Source note: `statistical-inference/standard-errors.qmd`

The square-root relation means that precision improves more slowly than the row count. But adding dependent rows need not follow this relation at all.

## Slide 142: Standard errors: question 1

Source note: `statistical-inference/standard-errors.qmd`

Which line in the derivation requires independence?

## Slide 143: Standard errors: answer 1

Source note: `statistical-inference/standard-errors.qmd`

The step from the variance of a sum to the sum of variances omits covariance terms and thus requires independence.

## Slide 144: Standard errors: question 2

Source note: `statistical-inference/standard-errors.qmd`

Why are the plotted sample sizes data-derived?

## Slide 145: Standard errors: answer 2

Source note: `statistical-inference/standard-errors.qmd`

The plotted sample sizes are the observed Hillenbrand cohort sizes: 19 girls, 27 boys, 45 men, and 48 women.

## Slide 146: Standard errors: question 3

Source note: `statistical-inference/standard-errors.qmd`

How would positive within-speaker covariance affect a naive row-level standard error?

## Slide 147: Standard errors: answer 3

Source note: `statistical-inference/standard-errors.qmd`

Positive covariance would add positive terms to the variance of the mean, so a row-independent standard error would tend to be too small.

## Slide 148: Standard errors: question 4

Source note: `statistical-inference/standard-errors.qmd`

Distinguish the response standard deviation from the standard error of the mean.

## Slide 149: Standard errors: answer 4

Source note: `statistical-inference/standard-errors.qmd`

The response standard deviation describes variation among individual durations; the standard error describes variation of the sample mean across samples. The bias page turns from spread to the location of a sampling distribution.

## Slide 150: Estimator bias

Source note: `statistical-inference/estimator-bias.qmd`

Our next step is Estimator bias.

## Slide 151: Estimator bias

Source note: `statistical-inference/estimator-bias.qmd`

Sampling variability describes how estimates change. **Estimator bias** asks whether their sampling-distribution center coincides with a named target:

$$
\operatorname{Bias}(T;\theta)=\mathbb{E}[T(\mathbf X)]-\theta.
$$

## Slide 152: Estimator bias

Source note: `statistical-inference/estimator-bias.qmd`

An estimator is unbiased for $\theta$ when this difference is zero.

## Slide 153: A target-specific comparison

Source note: `statistical-inference/estimator-bias.qmd`

We use the empirical mean adult-women /I/ duration in the Hillenbrand cohort as $\theta$. We compare the sample mean and sample median, both calculated from speaker-row resamples of the observed adult-women size. The median is not being judged as an estimator of the population median; it is deliberately being evaluated against the mean target.

## Slide 154: A target-specific comparison

Source note: `statistical-inference/estimator-bias.qmd`

For the mean estimator, linearity of expectation gives

$$
\begin{aligned}
\mathbb{E}[\overline X]
&=\mathbb{E}\left[\frac{1}{n}\sum_{i=1}^nX_i\right]\\
&=\frac{1}{n}\sum_{i=1}^n\mathbb{E}[X_i]\\
&=\theta.
\end{aligned}
$$

## Slide 155: A target-specific comparison

Source note: `statistical-inference/estimator-bias.qmd`

The simulation estimates its bias at -0.079 ms. The sample median’s estimated bias for this *mean* target is -10.708 ms.

## Slide 156: A target-specific comparison

Source note: `statistical-inference/estimator-bias.qmd`

Sampling distributions of two estimators for the empirical mean. The vertical line is the named mean target.

## Slide 157: A target-specific comparison

Source note: `statistical-inference/estimator-bias.qmd`

A realized estimate can lie far from $\theta$ even when its estimator is unbiased. Conversely, an estimator may have nonzero bias but small spread. Bias is thus one property of an estimator, not a complete ranking.

## Slide 158: Estimator bias: question 1

Source note: `statistical-inference/estimator-bias.qmd`

Why is the sample median biased in this analysis without being generally defective?

## Slide 159: Estimator bias: answer 1

Source note: `statistical-inference/estimator-bias.qmd`

The median is evaluated against the empirical mean, not against the median. Its bias is target-specific and does not make it a defective estimator in general.

## Slide 160: Estimator bias: question 2

Source note: `statistical-inference/estimator-bias.qmd`

What expectation appears in the definition of bias?

## Slide 161: Estimator bias: answer 2

Source note: `statistical-inference/estimator-bias.qmd`

Bias uses the sampling expectation $\mathbb{E}[T(\mathbf X)]$ and subtracts the named target $\theta$.

## Slide 162: Estimator bias: question 3

Source note: `statistical-inference/estimator-bias.qmd`

Distinguish realized estimation error from estimator bias.

## Slide 163: Estimator bias: answer 3

Source note: `statistical-inference/estimator-bias.qmd`

Realized error is $T(\mathbf x)-\theta$ for one sample; bias is $\mathbb{E}[T(\mathbf X)]-\theta$ across the sampling distribution.

## Slide 164: Estimator bias: question 4

Source note: `statistical-inference/estimator-bias.qmd`

Which target would make the sample median a more natural estimator?

## Slide 165: Estimator bias: answer 4

Source note: `statistical-inference/estimator-bias.qmd`

For this bootstrap, the target is the empirical median of /I/ durations for the observed women; a broader sampling model would target a population median. The mean-squared-error page combines spread and bias in one target-specific criterion.

## Slide 166: Mean squared error

Source note: `statistical-inference/mean-squared-error.qmd`

Now we turn to Mean squared error.

## Slide 167: Mean squared error

Source note: `statistical-inference/mean-squared-error.qmd`

Bias records systematic displacement from a target, while variance records sampling spread. **Mean squared error** (MSE) combines them:

$$
\operatorname{MSE}(T;\theta)=\mathbb{E}[(T-\theta)^2].
$$

## Slide 168: The decomposition

Source note: `statistical-inference/mean-squared-error.qmd`

Add and subtract $\mathbb{E}[T]$ inside the square:

$$
T-\theta=(T-\mathbb{E}[T])+(\mathbb{E}[T]-\theta).
$$

## Slide 169: The decomposition

Source note: `statistical-inference/mean-squared-error.qmd`

Expanding and taking expectations gives

$$
\begin{aligned}
\operatorname{MSE}(T;\theta)
&=\mathbb{E}[(T-\mathbb{E}[T])^2]
+2\mathbb{E}[T-\mathbb{E}[T]](\mathbb{E}[T]-\theta)
+(\mathbb{E}[T]-\theta)^2\\
&=\operatorname{Var}[T]+\operatorname{Bias}(T;\theta)^2.
\end{aligned}
$$

## Slide 170: The decomposition

Source note: `statistical-inference/mean-squared-error.qmd`

The cross-term vanishes because $\mathbb{E}[T-\mathbb{E}[T]]=0$.

## Slide 171: Comparing two estimators by nonparametric bootstrap

Source note: `statistical-inference/mean-squared-error.qmd`

The target remains the empirical mean /I/ duration among the observed adult women. The resampling unit is a speaker row, and both estimators use the observed group size.

## Slide 172: Comparing two estimators by nonparametric bootstrap

Source note: `statistical-inference/mean-squared-error.qmd`

The sample mean has MSE 57.872 ms(^2), whereas the sample median has MSE 226.443 ms(^2) for this mean target.

## Slide 173: Comparing two estimators by nonparametric bootstrap

Source note: `statistical-inference/mean-squared-error.qmd`

This figure shows variance and squared-bias components of MSE for estimating the empirical mean.

## Slide 174: Comparing two estimators by nonparametric bootstrap

Source note: `statistical-inference/mean-squared-error.qmd`

This comparison is conditional on the empirical target and the observed Hillenbrand cohort. It does not imply that mean duration is always the scientifically appropriate target, nor that the sample median is generally inferior.

## Slide 175: Mean squared error: question 1

Source note: `statistical-inference/mean-squared-error.qmd`

Why does the cross-term disappear in the MSE derivation?

## Slide 176: Mean squared error: answer 1

Source note: `statistical-inference/mean-squared-error.qmd`

The cross-term contains $\mathbb{E}[T-\mathbb{E}[T]]$, which equals zero.

## Slide 177: Mean squared error: question 2

Source note: `statistical-inference/mean-squared-error.qmd`

Which component accounts for most of the sample median's MSE here?

## Slide 178: Mean squared error: answer 2

Source note: `statistical-inference/mean-squared-error.qmd`

Squared bias accounts for slightly more of the sample median's MSE here than sampling variance does.

## Slide 179: Mean squared error: question 3

Source note: `statistical-inference/mean-squared-error.qmd`

Could a biased estimator have lower MSE than an unbiased estimator?

## Slide 180: Mean squared error: answer 3

Source note: `statistical-inference/mean-squared-error.qmd`

Yes. A biased estimator can have lower MSE than an unbiased estimator when its variance reduction exceeds its squared bias.

## Slide 181: Mean squared error: question 4

Source note: `statistical-inference/mean-squared-error.qmd`

Why must an MSE comparison name its target?

## Slide 182: Mean squared error: answer 4

Source note: `statistical-inference/mean-squared-error.qmd`

Both bias and squared error are defined relative to a target; changing the target can change the estimator ranking. The confidence-interval page evaluates procedures that attach a range to each estimate.

## Slide 183: Confidence intervals

Source note: `statistical-inference/confidence-intervals.qmd`

The next topic is Confidence intervals.

## Slide 184: Confidence intervals

Source note: `statistical-inference/confidence-intervals.qmd`

A **confidence-interval procedure** maps each possible sample to a lower and upper endpoint. Its coverage is a property of that repeated-sampling procedure, not a posterior probability assigned to one realized interval.

## Slide 185: Normal and t procedures

Source note: `statistical-inference/confidence-intervals.qmd`

If $\overline X$ has standard error $\sigma/\sqrt n$, a normal-reference interval is

$$
\overline X\pm z_{1-\alpha/2}\frac{\sigma}{\sqrt n}.
$$

When $\sigma$ is estimated by $s$, the one-sample t interval is

$$
\overline X\pm t_{1-\alpha/2,n-1}\frac{s}{\sqrt n}.
$$

## Slide 186: Normal and t procedures

Source note: `statistical-inference/confidence-intervals.qmd`

The confidence coefficient is defined through repeated sampling:

$$
\mathbb{P}_\theta\{L(\mathbf X)\leq\theta\leq U(\mathbf X)\}=1-\alpha.
$$

## Slide 187: Bootstrap coverage in the Hillenbrand cohort

Source note: `statistical-inference/confidence-intervals.qmd`

We repeatedly draw adult-women /I/ speaker rows with replacement from the observed cohort. The empirical cohort mean is the fixed target. The simulation evaluates both the t procedure and a normal procedure that treats the empirical standard deviation as known.

## Slide 188: Bootstrap coverage in the Hillenbrand cohort

Source note: `statistical-inference/confidence-intervals.qmd`

The t procedure covers the empirical target in 94.53% of bootstrap samples and has average width 30.331 ms.

## Slide 189: Bootstrap coverage in the Hillenbrand cohort

Source note: `statistical-inference/confidence-intervals.qmd`

This figure shows the first sixty t intervals from empirical speaker resamples. Red intervals miss the empirical target line.

## Slide 190: Bootstrap coverage in the Hillenbrand cohort

Source note: `statistical-inference/confidence-intervals.qmd`

After an interval is observed, it either covers this fixed target or does not. The confidence coefficient describes the procedure across samples. And this bootstrap coverage remains conditional on the observed cohort rather than representing the original recruitment process.

## Slide 191: Confidence intervals: question 1

Source note: `statistical-inference/confidence-intervals.qmd`

What varies in the coverage probability?

## Slide 192: Confidence intervals: answer 1

Source note: `statistical-inference/confidence-intervals.qmd`

The sample, estimate, and interval endpoints vary across repetitions; the empirical target and confidence procedure remain fixed.

## Slide 193: Confidence intervals: question 2

Source note: `statistical-inference/confidence-intervals.qmd`

Why is the t interval slightly wider on average here?

## Slide 194: Confidence intervals: answer 2

Source note: `statistical-inference/confidence-intervals.qmd`

The $t$ interval estimates the response scale and uses a critical value slightly larger than the corresponding normal critical value, making its average width slightly greater.

## Slide 195: Confidence intervals: question 3

Source note: `statistical-inference/confidence-intervals.qmd`

What does a red interval mean in the figure?

## Slide 196: Confidence intervals: answer 3

Source note: `statistical-inference/confidence-intervals.qmd`

A red interval from that repeated sample does not contain the fixed empirical cohort mean.

## Slide 197: Confidence intervals: question 4

Source note: `statistical-inference/confidence-intervals.qmd`

Why does bootstrap coverage conditional on this cohort not guarantee coverage for all American English speakers?

## Slide 198: Confidence intervals: answer 4

Source note: `statistical-inference/confidence-intervals.qmd`

The simulation resamples the observed cohort and does not reproduce probability sampling from all American English speakers. The next page studies an interval for a probability near a boundary.

## Slide 199: Exact binomial intervals

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Now we turn to Exact binomial intervals.

## Slide 200: Exact binomial intervals

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Normal intervals for a proportion can cross the boundaries of the parameter space, especially when successes are rare. The Hillenbrand paired vowel measurements produce such a case without invented counts.

## Slide 201: A within-speaker binary response

Source note: `statistical-inference/exact-binomial-intervals.qmd`

For each adult woman, define a success when /I/ in *hid* lasts longer than /i/ in *heed*. The speaker, not the vowel row, is the observational unit.

## Slide 202: A within-speaker binary response

Source note: `statistical-inference/exact-binomial-intervals.qmd`

The ordinary Wald interval is

$$
\widehat p\pm z_{1-\alpha/2}
\sqrt{\frac{\widehat p(1-\widehat p)}{n}}.
$$

## Slide 203: A within-speaker binary response

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Here its lower endpoint falls below zero, which is impossible for a probability.

## Slide 204: Inverting binomial tail tests

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Under $X\sim\operatorname{Binomial}(n,p)$, the Clopper--Pearson interval finds parameter values whose binomial tails are not too small. For an interior count $x$, the endpoints satisfy

$$
\mathbb{P}_{p_L}(X\geq x)=\frac{\alpha}{2}
$$

and

$$
\mathbb{P}_{p_U}(X\leq x)=\frac{\alpha}{2}.
$$

## Slide 205: Inverting binomial tail tests

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Equivalently, the endpoints are beta quantiles. R performs this inversion with `binom.test()`.

## Slide 206: Inverting binomial tail tests

Source note: `statistical-inference/exact-binomial-intervals.qmd`

The exact conditional interval is [0.0131, 0.1720], while the Wald interval is [-0.0060, 0.1310].

## Slide 207: Inverting binomial tail tests

Source note: `statistical-inference/exact-binomial-intervals.qmd`

This figure shows intervals for the probability that /I/ lasts longer than /i/ within an adult woman.

## Slide 208: Inverting binomial tail tests

Source note: `statistical-inference/exact-binomial-intervals.qmd`

“Exact” means that the calculation uses the finite binomial distribution rather than a large-sample normal approximation. It does not make the common-probability assumption, speaker independence, or connection from this screened cohort to a broader population exact.

## Slide 209: Exact binomial intervals: question 1

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Why is the speaker the independent unit?

## Slide 210: Exact binomial intervals: answer 1

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Each success compares two vowels from the same woman, so the binary outcome belongs to the speaker rather than to either vowel row separately.

## Slide 211: Exact binomial intervals: question 2

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Which defect of the Wald interval is visible here?

## Slide 212: Exact binomial intervals: answer 2

Source note: `statistical-inference/exact-binomial-intervals.qmd`

The Wald interval's lower endpoint falls below zero, outside the parameter space for a probability.

## Slide 213: Exact binomial intervals: question 3

Source note: `statistical-inference/exact-binomial-intervals.qmd`

What distribution is inverted by the Clopper--Pearson procedure?

## Slide 214: Exact binomial intervals: answer 3

Source note: `statistical-inference/exact-binomial-intervals.qmd`

The procedure inverts finite binomial tail probabilities, equivalently using beta quantiles for its endpoints.

## Slide 215: Exact binomial intervals: question 4

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Which assumptions remain even after using an exact calculation?

## Slide 216: Exact binomial intervals: answer 4

Source note: `statistical-inference/exact-binomial-intervals.qmd`

Even the exact Clopper--Pearson interval assumes independent speakers and a common success probability; generalization still depends on the screened cohort's recruitment. The bootstrap page constructs an interval for a statistic without a simple standard-error formula.

## Slide 217: Bootstrap confidence intervals

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

Our next step is Bootstrap confidence intervals.

## Slide 218: Bootstrap confidence intervals

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

The sampling distribution of a median is less convenient than that of a mean. The **nonparametric bootstrap** approximates it by repeatedly sampling observed units with replacement and recalculating the statistic.

## Slide 219: The algorithm

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

For observed speaker values $x_1,\ldots,x_n$: Draw $n$ speaker rows with replacement from the empirical distribution. Calculate the bootstrap statistic $T_b^*$. Repeat for $b=1,\ldots,B$. Use the empirical quantiles $Q^*_{\alpha/2}$ and $Q^*_{1-\alpha/2}$ as percentile endpoints.

## Slide 220: The algorithm

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

Thus the percentile interval is

$$
[Q^*_{\alpha/2},Q^*_{1-\alpha/2}].
$$

## Slide 221: Bootstrapping the adult-women median

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

The target statistic is the median duration of /I/ in *hid* among the observed Hillenbrand adult women. Since this subset has one row per speaker, resampling its rows is speaker-block resampling.

## Slide 222: Bootstrapping the adult-women median

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

The bootstrap standard error is 10.650 ms, and the percentile interval is [215.475, 249.000] ms.

## Slide 223: Bootstrapping the adult-women median

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

Bootstrap distribution of the adult-women /I/ median. The line marks the observed median.

## Slide 224: Bootstrapping the adult-women median

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

If all twelve vowel rows had been retained, the bootstrap would need to resample speakers as blocks so that their vowel measurements remained together. Row-wise resampling would invent independent vowel tokens. The interval is also conditional on treating the observed cohort as an empirical approximation to the target distribution.

## Slide 225: Bootstrap confidence intervals: question 1

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

Why does the bootstrap sample with replacement?

## Slide 226: Bootstrap confidence intervals: answer 1

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

Sampling with replacement draws from the empirical distribution and allows observed speakers to appear zero, one, or several times across bootstrap samples.

## Slide 227: Bootstrap confidence intervals: question 2

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

What makes the resampling unit a speaker here?

## Slide 228: Bootstrap confidence intervals: answer 2

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

The analyzed subset contains one /I/ duration per adult-woman speaker, so one row is one speaker.

## Slide 229: Bootstrap confidence intervals: question 3

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

What does `bootstrap_se` estimate?

## Slide 230: Bootstrap confidence intervals: answer 3

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

`bootstrap_se` estimates the standard deviation of the bootstrap sampling distribution of the sample median.

## Slide 231: Bootstrap confidence intervals: question 4

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

Which population limitation does the bootstrap leave unchanged?

## Slide 232: Bootstrap confidence intervals: answer 4

Source note: `statistical-inference/bootstrap-confidence-intervals.qmd`

The bootstrap interval remains conditional on the observed Hillenbrand cohort and does not supply population-representative recruitment. The next page returns to the paired vowel difference and formalizes a null comparison.

## Slide 233: Null hypotheses and test statistics

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

Next, we take up Null hypotheses and test statistics.

## Slide 234: Null hypotheses and test statistics

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

A hypothesis test begins with a parameter claim and a statistic that standardizes the discrepancy between that claim and the data. The null value, estimator, and standard error must refer to the same unit and estimand.

## Slide 235: A within-speaker target

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

For each Hillenbrand adult woman, let

$$
D_s=Y_{s,/I/}-Y_{s,/i/}
$$

be the duration of /I/ in *hid* minus /i/ in *heed*.

## Slide 236: A within-speaker target

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

Pairing first makes the speaker the observation and removes stable speaker-level duration differences from the contrast.

## Slide 237: The null and statistic

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

The target is the mean within-speaker difference $\mu_D$. The point null is

$$
H_0:\mu_D=0,
$$

and the two-sided alternative is

$$
H_1:\mu_D\neq0.
$$

## Slide 238: The null and statistic

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

The standardized statistic is

$$
t
=\frac{\overline D-0}{s_D/\sqrt n}.
$$

## Slide 239: The null and statistic

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

The observed mean difference is -65.438 ms and the standardized discrepancy is $t=$ -10.590.

## Slide 240: The null and statistic

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

Within-speaker duration differences. The line is the null value and the red point is the observed mean.

## Slide 241: The null and statistic

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

A small tail probability measures incompatibility with this null model. It is not the probability that $H_0$ is true, and it does not replace the effect estimate or its units.

## Slide 242: Null hypotheses and test statistics: question 1

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

Why is the null value expressed in milliseconds?

## Slide 243: Null hypotheses and test statistics: answer 1

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

The parameter is a mean within-speaker duration difference, so zero and any alternative value have millisecond units.

## Slide 244: Null hypotheses and test statistics: question 2

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

Which quantity standardizes the observed discrepancy?

## Slide 245: Null hypotheses and test statistics: answer 2

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

The standard error $s_D/\sqrt n$ standardizes the observed mean difference from the null value.

## Slide 246: Null hypotheses and test statistics: question 3

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

Why must the vowel rows be paired before calculating the statistic?

## Slide 247: Null hypotheses and test statistics: answer 3

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

Pairing forms one within-speaker contrast and removes stable between-speaker duration differences from the statistic.

## Slide 248: Null hypotheses and test statistics: question 4

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

What does the tail probability condition on?

## Slide 249: Null hypotheses and test statistics: answer 4

Source note: `statistical-inference/null-hypotheses-and-test-statistics.qmd`

The $t$-test tail probability conditions on the point null and its reference model, including independent speaker differences and the $t$ reference assumptions. The one-sample t page derives the reference distribution and confidence interval for this same contrast.

## Slide 250: One-sample t inference

Source note: `statistical-inference/one-sample-t-inference.qmd`

Next, we take up One-sample t inference.

## Slide 251: One-sample t inference

Source note: `statistical-inference/one-sample-t-inference.qmd`

The paired Hillenbrand contrast yields one duration difference per adult woman. One-sample t inference represents uncertainty in the mean of those speaker-level differences while estimating their scale from the same observations.

## Slide 252: From a standardized mean to a t reference

Source note: `statistical-inference/one-sample-t-inference.qmd`

For independent differences $D_1,\ldots,D_n$ from a normal population,

$$
\frac{\overline D-\mu_D}{\sigma_D/\sqrt n}\sim\mathcal N(0,1)
$$

and

$$
\frac{(n-1)S_D^2}{\sigma_D^2}\sim\chi^2_{n-1}.
$$

## Slide 253: From a standardized mean to a t reference

Source note: `statistical-inference/one-sample-t-inference.qmd`

Replacing $\sigma_D$ by $S_D$ gives

$$
T=\frac{\overline D-\mu_D}{S_D/\sqrt n}\sim t_{n-1}.
$$

## Slide 254: From a standardized mean to a t reference

Source note: `statistical-inference/one-sample-t-inference.qmd`

The corresponding interval is

$$
\overline D\pm t_{1-\alpha/2,n-1}\frac{S_D}{\sqrt n}.
$$

## Slide 255: Computing the paired contrast

Source note: `statistical-inference/one-sample-t-inference.qmd`

The interval is [-77.868, -53.007] ms. The two-sided tail area is 4.875e-14.

## Slide 256: Computing the paired contrast

Source note: `statistical-inference/one-sample-t-inference.qmd`

t reference density for the within-speaker duration statistic. The vertical lines mark the observed two-sided cutoffs.

## Slide 257: Computing the paired contrast

Source note: `statistical-inference/one-sample-t-inference.qmd`

The normality assumption concerns the speaker differences, not the two vowel distributions separately. And the screened cohort does not make the speakers a probability sample of all American English speakers. The procedure quantifies uncertainty under the stated model; recruitment determines the scope of the conclusion.

## Slide 258: One-sample t inference: question 1

Source note: `statistical-inference/one-sample-t-inference.qmd`

Why does estimating $\sigma_D$ change the reference family?

## Slide 259: One-sample t inference: answer 1

Source note: `statistical-inference/one-sample-t-inference.qmd`

Replacing the unknown $\sigma_D$ with the random estimate $S_D$ adds scale uncertainty, yielding a $t$ rather than a normal reference distribution.

## Slide 260: One-sample t inference: question 2

Source note: `statistical-inference/one-sample-t-inference.qmd`

Which values determine the degrees of freedom?

## Slide 261: One-sample t inference: answer 2

Source note: `statistical-inference/one-sample-t-inference.qmd`

The number of independent speaker differences and the number of estimated mean parameters determine $n-1=47$ degrees of freedom.

## Slide 262: One-sample t inference: question 3

Source note: `statistical-inference/one-sample-t-inference.qmd`

Why should diagnostics focus on $D_s$?

## Slide 263: One-sample t inference: answer 3

Source note: `statistical-inference/one-sample-t-inference.qmd`

The one-sample model is applied to the within-speaker differences, so its distributional assumptions concern $D_s$, not the two vowel margins separately.

## Slide 264: One-sample t inference: question 4

Source note: `statistical-inference/one-sample-t-inference.qmd`

What does the interval say about the direction and magnitude of the cohort contrast?

## Slide 265: One-sample t inference: answer 4

Source note: `statistical-inference/one-sample-t-inference.qmd`

The 95% interval is $[-77.868,-53.007]$ ms: in this cohort, /I/ in *hid* is shorter than /i/ in *heed* by about 53 to 78 ms on average. The paired-observation page turns to aligned semantic graphs, where pairing is determined by translation structure.

## Slide 266: Paired observations

Source note: `statistical-inference/paired-observations.qmd`

Next, we take up Paired observations.

## Slide 267: UCCA: the empirical object

Source note: `statistical-inference/paired-observations.qmd`

The data source is Sulem, Abend, and Rappoport (2015), UCCA French-English 20K. It provides aligned French and English passages with graph-derived Scene counts.

## Slide 268: Paired observations

Source note: `statistical-inference/paired-observations.qmd`

Two measurements are paired when the design supplies a defensible match between them. In translation research, an aligned passage pair may serve as the paired observational unit and must remain intact whenever the two language measurements are compared.

## Slide 269: UCCA graphs across translation

Source note: `statistical-inference/paired-observations.qmd`

We use the public CC BY-SA 3.0 English and French UCCA 20K v2 corpora. Sulem, Abend, and Rappoport (2015) ask whether UCCA structure is preserved across translations; the same bilingual annotator annotated the two languages separately. Current UCCA guidelines are described by Abend et al. (2020).

## Slide 270: UCCA graphs across translation

Source note: `statistical-inference/paired-observations.qmd`

UCCA is a graph representation. A distinct **Scene** is a foundational node with an outgoing Process (`P`) or State (`S`) edge. A remote edge points to an already represented unit and does not create another Scene. One row in the extract is one language side of a passage graph; the analysis unit is one of the 154 source-order English--French passage pairs.

## Slide 271: UCCA graphs across translation

Source note: `statistical-inference/paired-observations.qmd`

The current v2 release is not the numerical release reported in the 2015 paper. The paper reports 583 sentences per language and mean Scene counts of 9.49 in English and 9.25 in French. The pinned v2 graphs form the aligned passage pairs loaded below and produce different graph-derived counts. We apply the paper's paired estimand to v2; we do not claim to reproduce the paper's numbers.

## Slide 272: Pairing changes the variance

Source note: `statistical-inference/paired-observations.qmd`

For pair $i$, define $D_i=Y_{i,\mathrm{fr}}-Y_{i,\mathrm{en}}$. Then

$$
\overline D=\overline Y_{\mathrm{fr}}-\overline Y_{\mathrm{en}}
$$

and

$$
\operatorname{Var}[D]
=\operatorname{Var}[Y_{\mathrm{fr}}]
+\operatorname{Var}[Y_{\mathrm{en}}]
-2\operatorname{Cov}(Y_{\mathrm{fr}},Y_{\mathrm{en}}).
$$

## Slide 273: Pairing changes the variance

Source note: `statistical-inference/paired-observations.qmd`

Positive covariance can make paired differences substantially less variable than a comparison that discards alignment.

## Slide 274: Pairing changes the variance

Source note: `statistical-inference/paired-observations.qmd`

Graph-derived Scene counts in aligned v2 passages. The identity line marks exact count agreement.

## Slide 275: Pairing changes the variance

Source note: `statistical-inference/paired-observations.qmd`

The count correlation is 0.968, but correlation does not establish agreement. Points can follow a line closely while remaining systematically above the identity line. The next page thus uses an absolute count-agreement target.

## Slide 276: Pairing changes the variance

Source note: `statistical-inference/paired-observations.qmd`

The paired observational unit must be preserved: v2 filenames are internal annotation identifiers, not bilingual order. The prepared table reconstructs source order from passage ranges and repository history. Sorting filenames would invent pairs.

## Slide 277: Paired observations: question 1

Source note: `statistical-inference/paired-observations.qmd`

What is the observational unit for the paired analysis?

## Slide 278: Paired observations: answer 1

Source note: `statistical-inference/paired-observations.qmd`

One aligned English--French passage pair is the observational unit.

## Slide 279: Paired observations: question 2

Source note: `statistical-inference/paired-observations.qmd`

Why does a remote edge not create another Scene?

## Slide 280: Paired observations: answer 2

Source note: `statistical-inference/paired-observations.qmd`

A remote edge points to a unit already represented in the graph; it does not introduce a new Process or State unit and thus does not create a new Scene.

## Slide 281: Paired observations: question 3

Source note: `statistical-inference/paired-observations.qmd`

How does covariance enter the variance of a difference?

## Slide 282: Paired observations: answer 3

Source note: `statistical-inference/paired-observations.qmd`

$\operatorname{Var}[D]=\operatorname{Var}[Y_{\mathrm{fr}}]+\operatorname{Var}[Y_{\mathrm{en}}]-2\operatorname{Cov}(Y_{\mathrm{fr}},Y_{\mathrm{en}})$, so positive covariance reduces difference variance.

## Slide 283: Paired observations: question 4

Source note: `statistical-inference/paired-observations.qmd`

Why is a high correlation insufficient evidence of count agreement?

## Slide 284: Paired observations: answer 4

Source note: `statistical-inference/paired-observations.qmd`

Correlation measures co-movement, not equality; points can track a line closely while lying systematically above the identity line. The next page compares aligned absolute differences with a descriptive re-pairing reference.

## Slide 285: Paired means and alignment

Source note: `statistical-inference/paired-mean-inference.qmd`

The next topic is Paired means and alignment.

## Slide 286: Paired means and alignment

Source note: `statistical-inference/paired-mean-inference.qmd`

For ordinary paired-mean inference, one first forms within-pair differences and then performs one-sample inference on those values. The UCCA question is different: it concerns absolute agreement of graph-derived Scene counts, so the focal statistic is a mean absolute difference.

## Slide 287: The general paired-mean result

Source note: `statistical-inference/paired-mean-inference.qmd`

For signed differences $D_i=Y_{i,A}-Y_{i,B}$, the target and estimator are

$$
\mu_D=\mathbb{E}[D]
\qquad\text{and}\qquad
\overline D=\frac{1}{n}\sum_{i=1}^nD_i.
$$

## Slide 288: The general paired-mean result

Source note: `statistical-inference/paired-mean-inference.qmd`

Under independent pairs with an appropriate t reference,

$$
\frac{\overline D-\mu_D}{S_D/\sqrt n}\sim t_{n-1},
$$

which yields

$$
\overline D\pm t_{1-\alpha/2,n-1}\frac{S_D}{\sqrt n}.
$$

## Slide 289: The general paired-mean result

Source note: `statistical-inference/paired-mean-inference.qmd`

This derivation remains useful, but it is not the analysis we impose on the UCCA alignment. The source passages are consecutive literary material rather than randomly sampled translation units, and the paper's agreement question is not a zero signed-mean test.

## Slide 290: The aligned agreement statistic

Source note: `statistical-inference/paired-mean-inference.qmd`

For source-order pair $i$, let $S_{i,\mathrm{en}}$ and $S_{i,\mathrm{fr}}$ denote Scene counts. Define

$$
\Delta_{\mathrm{aligned}}
=\frac{1}{n}\sum_{i=1}^n
\left|S_{i,\mathrm{fr}}-S_{i,\mathrm{en}}\right|.
$$

## Slide 291: The aligned agreement statistic

Source note: `statistical-inference/paired-mean-inference.qmd`

The aligned passages differ by 2.078 Scenes on average.

## Slide 292: A descriptive re-pairing reference

Source note: `statistical-inference/paired-mean-inference.qmd`

To show what the alignment contributes, we hold the English counts fixed and randomly permute the French passage order. Each draw measures how far arbitrary cross-language pairings lie apart.

## Slide 293: A descriptive re-pairing reference

Source note: `statistical-inference/paired-mean-inference.qmd`

Mean absolute Scene-count differences after arbitrary re-pairing. The line is the source-order aligned value.

## Slide 294: A descriptive re-pairing reference

Source note: `statistical-inference/paired-mean-inference.qmd`

The re-paired mean is 8.503 Scenes, and the plus-one lower-tail fraction is 0.0001. This fraction is descriptive. It is not a randomization-test p value because translation alignment was not randomly assigned. The analysis supports an agreement claim for the pinned v2 passage graphs, not a general claim about languages, genres, or translators.

## Slide 295: Paired means and alignment: question 1

Source note: `statistical-inference/paired-mean-inference.qmd`

Why does the focal statistic use absolute rather than signed differences?

## Slide 296: Paired means and alignment: answer 1

Source note: `statistical-inference/paired-mean-inference.qmd`

Absolute differences measure passage-level count disagreement without allowing positive and negative signed differences to cancel.

## Slide 297: Paired means and alignment: question 2

Source note: `statistical-inference/paired-mean-inference.qmd`

What feature changes across re-pairings?

## Slide 298: Paired means and alignment: answer 2

Source note: `statistical-inference/paired-mean-inference.qmd`

The French Scene counts are assigned to different English passages while each language's marginal counts remain fixed.

## Slide 299: Paired means and alignment: question 3

Source note: `statistical-inference/paired-mean-inference.qmd`

Why is the lower-tail fraction not a randomization-test p value?

## Slide 300: Paired means and alignment: answer 3

Source note: `statistical-inference/paired-mean-inference.qmd`

Translation alignment was not randomly assigned, so permutation does not represent a randomized treatment assignment under a sharp null.

## Slide 301: Paired means and alignment: question 4

Source note: `statistical-inference/paired-mean-inference.qmd`

What does the per-terminal sensitivity calculation control?

## Slide 302: Paired means and alignment: answer 4

Source note: `statistical-inference/paired-mean-inference.qmd`

Dividing by passage terminal counts controls descriptively for cross-passage and cross-language differences in passage length. The independent-means page returns to Hillenbrand durations and combines uncertainty from two disjoint speaker groups.

## Slide 303: Comparing two independent means

Source note: `statistical-inference/independent-means.qmd`

The next topic is Comparing two independent means.

## Slide 304: Comparing two independent means

Source note: `statistical-inference/independent-means.qmd`

When groups contain different sampled speakers, there is no within-speaker covariance to exploit. We compare /I/ duration in *hid* between the adult men and adult women in the Hillenbrand cohort. The estimand is the difference in group means,

$$
\Delta=\mu_{\mathrm{man}}-\mu_{\mathrm{woman}},
$$

estimated by

$$
\widehat\Delta=\overline Y_{\mathrm{man}}-\overline Y_{\mathrm{woman}}.
$$

## Slide 305: Welch's standard error

Source note: `statistical-inference/independent-means.qmd`

For independent groups,

$$
\operatorname{Var}[\widehat\Delta]
=\operatorname{Var}[\overline Y_{\mathrm{man}}]
+\operatorname{Var}[\overline Y_{\mathrm{woman}}],
$$

so the estimated standard error is

$$
\widehat{\operatorname{SE}}(\widehat\Delta)
=\sqrt{\frac{s_m^2}{n_m}+\frac{s_w^2}{n_w}}.
$$

## Slide 306: Welch's standard error

Source note: `statistical-inference/independent-means.qmd`

Welch's approximation uses

$$
\nu=
\frac{(s_m^2/n_m+s_w^2/n_w)^2}
{(s_m^2/n_m)^2/(n_m-1)+(s_w^2/n_w)^2/(n_w-1)}
$$

degrees of freedom.

## Slide 307: Welch's standard error

Source note: `statistical-inference/independent-means.qmd`

It does not require equal group variances.

## Slide 308: Welch's standard error

Source note: `statistical-inference/independent-means.qmd`

The estimated man-minus-woman difference is -48.507 ms, with interval [-67.257, -29.757] ms.

## Slide 309: Welch's standard error

Source note: `statistical-inference/independent-means.qmd`

Raw /I/ durations for distinct adult speakers. Red points mark the group means.

## Slide 310: Welch's standard error

Source note: `statistical-inference/independent-means.qmd`

The comparison is descriptive for these screened cohorts. It does not isolate a causal effect of gender, and the recruitment design does not make either group a probability sample of a wider speaker population.

## Slide 311: Comparing two independent means: question 1

Source note: `statistical-inference/independent-means.qmd`

Why are the variance contributions added?

## Slide 312: Comparing two independent means: answer 1

Source note: `statistical-inference/independent-means.qmd`

For independent groups the covariance is zero, so the variance of the difference is the sum of the two mean variances.

## Slide 313: Comparing two independent means: question 2

Source note: `statistical-inference/independent-means.qmd`

Which assumption makes the between-group covariance zero?

## Slide 314: Comparing two independent means: answer 2

Source note: `statistical-inference/independent-means.qmd`

The assumption that the adult-men and adult-women speaker samples are independent makes the between-group covariance zero.

## Slide 315: Comparing two independent means: question 3

Source note: `statistical-inference/independent-means.qmd`

What additional assumption would the pooled-variance t procedure make?

## Slide 316: Comparing two independent means: answer 3

Source note: `statistical-inference/independent-means.qmd`

A pooled-variance procedure would additionally assume equal population variances in the two groups.

## Slide 317: Comparing two independent means: question 4

Source note: `statistical-inference/independent-means.qmd`

Why would matching speakers by row number invent pairing?

## Slide 318: Comparing two independent means: answer 4

Source note: `statistical-inference/independent-means.qmd`

Row number has no design-based link across the disjoint speaker groups, so matching on it would fabricate within-pair covariance. The next page moves from continuous speaker measurements to a finite morphological resource sampled without replacement.

## Slide 319: Fisher's exact test

Source note: `statistical-inference/fishers-exact-test.qmd`

Now we turn to Fisher's exact test.

## Slide 320: Turkish UniMorph: the empirical object

Source note: `statistical-inference/fishers-exact-test.qmd`

The data source is Pimentel et al. (2021) and Batsuren et al. (2022), Turkish UniMorph. It provides Turkish inflectional paradigms from the pinned UniMorph release.

## Slide 321: Fisher's exact test

Source note: `statistical-inference/fishers-exact-test.qmd`

Fisher's exact test assigns probabilities to contingency tables conditional on their margins. Its reference distribution is hypergeometric, so it is especially natural for a fixed sample drawn without replacement from a finite resource.

## Slide 322: A Turkish morphology sample

Source note: `statistical-inference/fishers-exact-test.qmd`

We use the Turkish UniMorph release pinned at commit `6c179ace7d2f3d7f3484020e5304c1544d07bb6b` and licensed CC BY-SA 3.0. Pimentel et al. (2021) use the resource for morphological reinflection: predicting an inflected form from a lemma and feature bundle. The release describes its Turkish verb paradigms as semi-automatically generated and partially checked by a native speaker; unverified noun and adjective material is excluded from the teaching data.

## Slide 323: A Turkish morphology sample

Source note: `statistical-inference/fishers-exact-test.qmd`

One row is one of 588 distinct verb lemmas paired with `V;IND;PST;3;SG;POS;DECL`. It is a lexeme--paradigm-cell row, not a corpus token. The table retains the whole UniMorph form and derives the last stem-vowel class and final two orthographic characters. Those characters are teaching measurements, not source-supplied morpheme boundaries; the release's pinned README documents the source data and verification status.

## Slide 324: A Turkish morphology sample

Source note: `statistical-inference/fishers-exact-test.qmd`

The Fisher analysis uses the fixed 120-lemma simple random sample drawn without replacement with seed 414. It crosses last stem-vowel backness with whether the final orthographic sequence begins in *d* or *t*.

## Slide 325: The conditional probability

Source note: `statistical-inference/fishers-exact-test.qmd`

With margins fixed, let $A$ be the front-vowel/*t*-initial count. Under conditional independence,.

$$
\mathbb{P}(A=a)
=\frac{{K\choose a}{N-K\choose n-a}}{{N\choose n}},
$$

where $K$ is the *t*-initial column total, $N-K$ is the *d*-initial total, and $n$ is the front-vowel row total.

## Slide 326: The conditional probability

Source note: `statistical-inference/fishers-exact-test.qmd`

The observed table has conditional probability 0.12016. R’s two-sided p value sums all fixed-margin tables whose null probability is no greater than the observed table’s probability; it is 0.5636.

## Slide 327: The conditional probability

Source note: `statistical-inference/fishers-exact-test.qmd`

This figure shows observed lexeme counts in the fixed UniMorph sample.

## Slide 328: The conditional probability

Source note: `statistical-inference/fishers-exact-test.qmd`

The calculation conditions on the sample and margins. Its finite sampling fraction is 0.204, so treating these without-replacement rows as independent Bernoulli draws would discard part of the design. The result concerns the resource-defined lexeme population, not Turkish token use.

## Slide 329: Fisher's exact test: question 1

Source note: `statistical-inference/fishers-exact-test.qmd`

Which margins remain fixed in the Fisher reference distribution?

## Slide 330: Fisher's exact test: answer 1

Source note: `statistical-inference/fishers-exact-test.qmd`

The front/back row totals, the *t*/*d* column totals, and therefore the grand total remain fixed.

## Slide 331: Fisher's exact test: question 2

Source note: `statistical-inference/fishers-exact-test.qmd`

Why is the observed-table probability not the two-sided p value?

## Slide 332: Fisher's exact test: answer 2

Source note: `statistical-inference/fishers-exact-test.qmd`

The two-sided p value sums the probabilities of all fixed-margin tables no more probable under the null than the observed table.

## Slide 333: Fisher's exact test: question 3

Source note: `statistical-inference/fishers-exact-test.qmd`

What does one UniMorph row represent?

## Slide 334: Fisher's exact test: answer 3

Source note: `statistical-inference/fishers-exact-test.qmd`

One row is one distinct verb lemma paired with the `V;IND;PST;3;SG;POS;DECL` paradigm cell.

## Slide 335: Fisher's exact test: question 4

Source note: `statistical-inference/fishers-exact-test.qmd`

Why can this table not estimate suffix frequency in running Turkish text?

## Slide 336: Fisher's exact test: answer 4

Source note: `statistical-inference/fishers-exact-test.qmd`

UniMorph rows are lexeme--paradigm types without corpus token frequencies, so the table cannot estimate how often suffixes occur in running text. The chi-squared page uses the complete 588-lemma resource to construct the corresponding large-sample reference calculation.

## Slide 337: The chi-squared test of independence

Source note: `statistical-inference/chi-squared-test.qmd`

The next topic is The chi-squared test of independence.

## Slide 338: The chi-squared test of independence

Source note: `statistical-inference/chi-squared-test.qmd`

The chi-squared test compares observed contingency-table counts with counts implied by independence. We continue with the complete Turkish UniMorph verb population introduced on the preceding page, now retaining four last stem-vowel classes.

## Slide 339: Expected counts under independence

Source note: `statistical-inference/chi-squared-test.qmd`

For row $i$, column $j$, and grand total $N$, the fitted independence probability is

$$
\widehat p_{ij}
=\widehat p_{i+}\widehat p_{+j},
$$

so the expected count is

$$
E_{ij}
=N\widehat p_{ij}
=\frac{O_{i+}O_{+j}}{N}.
$$

## Slide 340: Expected counts under independence

Source note: `statistical-inference/chi-squared-test.qmd`

Pearson's statistic aggregates standardized cell discrepancies:

$$
X^2
=\sum_i\sum_j\frac{(O_{ij}-E_{ij})^2}{E_{ij}}.
$$

## Slide 341: Expected counts under independence

Source note: `statistical-inference/chi-squared-test.qmd`

For $r$ rows and $c$ columns, the reference distribution has

$$
\nu=(r-1)(c-1)
$$

degrees of freedom.

## Slide 342: Expected counts under independence

Source note: `statistical-inference/chi-squared-test.qmd`

The signed Pearson residual

$$
r_{ij}=\frac{O_{ij}-E_{ij}}{\sqrt{E_{ij}}}
$$

retains the direction that disappears after squaring.

## Slide 343: The resource census

Source note: `statistical-inference/chi-squared-test.qmd`

the calculation yields $X^2=$ 4.3309 with 3 degrees of freedom. The minimum expected count is 23.469, so sparse expected cells are not the main approximation concern.

## Slide 344: The resource census

Source note: `statistical-inference/chi-squared-test.qmd`

This figure shows observed lexeme counts (filled points) and independence-expected counts (open points).

## Slide 345: The resource census

Source note: `statistical-inference/chi-squared-test.qmd`

The reference p value is 0.2279 and Cramer’s $V$ is 0.0858. But the 588 rows are a census of the pinned resource-defined population. A reference p value is pedagogically useful for showing the chi-squared calculation; it is not needed to learn whether these rows differ from themselves and does not create an inference to Turkish token use.

## Slide 346: The chi-squared test of independence: question 1

Source note: `statistical-inference/chi-squared-test.qmd`

Derive one expected count from its row and column margins using `tab`.

## Slide 347: The chi-squared test of independence: answer 1

Source note: `statistical-inference/chi-squared-test.qmd`

For the back-rounded/*d*-initial cell, $E=(78\times388)/588=51.469$ lexemes; the same row-total times column-total over grand-total rule gives every other expected count.

## Slide 348: The chi-squared test of independence: question 2

Source note: `statistical-inference/chi-squared-test.qmd`

Why are residuals signed while cell contributions to $X^2$ are not?

## Slide 349: The chi-squared test of independence: answer 2

Source note: `statistical-inference/chi-squared-test.qmd`

A Pearson residual retains the sign of $O_{ij}-E_{ij}$, whereas each $X^2$ contribution squares that discrepancy and is nonnegative.

## Slide 350: The chi-squared test of independence: question 3

Source note: `statistical-inference/chi-squared-test.qmd`

How are the degrees of freedom determined?

## Slide 351: The chi-squared test of independence: answer 3

Source note: `statistical-inference/chi-squared-test.qmd`

With four vowel-class rows and two ending-initial columns, $\nu=(4-1)(2-1)=3$.

## Slide 352: The chi-squared test of independence: question 4

Source note: `statistical-inference/chi-squared-test.qmd`

Why is Cramer's $V$ more interpretable here than the reference p value alone?

## Slide 353: The chi-squared test of independence: answer 4

Source note: `statistical-inference/chi-squared-test.qmd`

Cramer's $V$ describes association magnitude in the complete pinned resource, whereas the reference p value mainly reflects a model-based repeated-sampling calculation that the census does not need. The next section begins with posterior distributions, which represent parameter uncertainty under a different inferential framework.

## Slide 354: Posterior distributions

Source note: `statistical-inference/posterior-distributions.qmd`

The next topic is Posterior distributions.

## Slide 355: Posterior distributions

Source note: `statistical-inference/posterior-distributions.qmd`

The foundations chapter derived Bayes' rule, and the frequentist sequence distinguished a likelihood from a probability distribution over observations. We now combine the two to construct a posterior distribution from an observed linguistic resource.

## Slide 356: An exchangeable Bernoulli superpopulation model

Source note: `statistical-inference/posterior-distributions.qmd`

We use the Turkish table from the UniMorph release pinned at commit `6c179ac`. Pimentel et al. (2021) describe its use in a morphological-reinflection task, and Batsuren et al. (2022) describe UniMorph as a type-level resource of lemma--form--feature triples. The data are CC BY-SA 3.0.

## Slide 357: An exchangeable Bernoulli superpopulation model

Source note: `statistical-inference/posterior-distributions.qmd`

The course table retains 588 distinct verb lexemes with one form in the feature cell `V;IND;PST;3;SG;POS;DECL`. A row is a lexeme--paradigm cell, not a usage token. The binary variable $Z_i$ marks whether the course-derived two-character ending begins with *t*. This ending is an orthographic measurement, not a UniMorph morpheme boundary.

## Slide 358: An exchangeable Bernoulli superpopulation model

Source note: `statistical-inference/posterior-distributions.qmd`

The value $K/N=$ 0.340136 is known because the complete pinned resource is available. There is no posterior uncertainty about that finite-population proportion.

## Slide 359: An exchangeable Bernoulli superpopulation model

Source note: `statistical-inference/posterior-distributions.qmd`

To introduce Bayesian updating, we posit an exchangeable superpopulation from which lexeme cells are independently drawn,

$$
Z_i\mid\Theta=\theta
\overset{\mathrm{iid}}{\sim}
\operatorname{Bernoulli}(\theta),
\qquad
\Theta\sim\operatorname{Beta}(1,1).
$$

## Slide 360: An exchangeable Bernoulli superpopulation model

Source note: `statistical-inference/posterior-distributions.qmd`

This exchangeable Bernoulli superpopulation model is counterfactual, not a description of the actual sampling design. The committed 120-row sample was drawn without replacement from the known 588-row resource, so independent Bernoulli sampling does not describe that procedure.

## Slide 361: Updating a continuous parameter

Source note: `statistical-inference/posterior-distributions.qmd`

Bayes' rule for a continuous parameter is

$$
f_{\Theta\mid\mathbf Z}(\theta\mid\mathbf z)
=
\frac{
p_{\mathbf Z\mid\Theta}(\mathbf z\mid\theta)f_\Theta(\theta)
}{
p_{\mathbf Z}(\mathbf z)
}.
$$

## Slide 362: Updating a continuous parameter

Source note: `statistical-inference/posterior-distributions.qmd`

The denominator

$$
p_{\mathbf Z}(\mathbf z)
=
\int_0^1
p_{\mathbf Z\mid\Theta}(\mathbf z\mid\theta)
f_\Theta(\theta)\,\mathrm d\theta
$$

normalizes the numerator.

## Slide 363: Updating a continuous parameter

Source note: `statistical-inference/posterior-distributions.qmd`

For $k$ focal cells among $n$ exchangeable Bernoulli observations, the likelihood kernel is

$$
p_{\mathbf Z\mid\Theta}(\mathbf z\mid\theta)
\propto
\theta^k(1-\theta)^{n-k}.
$$

## Slide 364: Updating a continuous parameter

Source note: `statistical-inference/posterior-distributions.qmd`

Multiplying by the $\operatorname{Beta}(1,1)$ prior gives

$$
f_{\Theta\mid\mathbf Z}(\theta\mid\mathbf z)
\propto
\theta^{1+k-1}(1-\theta)^{1+n-k-1},
$$

so the exchangeable Bernoulli superpopulation model posterior is

$$
\Theta\mid\mathbf z
\sim
\operatorname{Beta}(1+k,1+n-k).
$$

## Slide 365: Updating a continuous parameter

Source note: `statistical-inference/posterior-distributions.qmd`

The 42 observed *t*-initial cells and 78 other cells update the prior to a beta distribution with shape parameters 43 and 79.

## Slide 366: Updating a continuous parameter

Source note: `statistical-inference/posterior-distributions.qmd`

Prior and exchangeable Bernoulli superpopulation model posterior densities. The vertical line is the known proportion in the pinned resource, not an uncertain parameter estimate.

## Slide 367: Updating a continuous parameter

Source note: `statistical-inference/posterior-distributions.qmd`

For a continuous parameter, the density at one point is not a point probability. Posterior probabilities are integrals over intervals:

$$
\mathbb{P}(a<\Theta<b\mid\mathbf z)
=
\int_a^b
f_{\Theta\mid\mathbf Z}(\theta\mid\mathbf z)\,\mathrm d\theta.
$$

## Slide 368: Updating a continuous parameter

Source note: `statistical-inference/posterior-distributions.qmd`

The shorter statement $f(\theta\mid\mathbf z)\propto p(\mathbf z\mid\theta)f(\theta)$ identifies posterior shape, but a normalized density is required before we assign such probabilities.

## Slide 369: What the posterior does not say

Source note: `statistical-inference/posterior-distributions.qmd`

The likelihood evaluates the fixed sample as a function of $\theta$; the posterior distributes model-based uncertainty over $\theta$ after conditioning on that sample. Neither quantity changes the known resource proportion. UniMorph supplies types, not token frequencies, so this posterior does not estimate the frequency of *t*-initial past endings in Turkish use.

## Slide 370: Posterior distributions: question 1

Source note: `statistical-inference/posterior-distributions.qmd`

Which quantity is fixed when the likelihood is evaluated?

## Slide 371: Posterior distributions: answer 1

Source note: `statistical-inference/posterior-distributions.qmd`

The observed sample $\mathbf z$, including $n=120$ and $k=42$, is fixed while the likelihood varies over $\theta$.

## Slide 372: Posterior distributions: question 2

Source note: `statistical-inference/posterior-distributions.qmd`

Why is $200/588$ not uncertain in this analysis?

## Slide 373: Posterior distributions: answer 2

Source note: `statistical-inference/posterior-distributions.qmd`

The complete pinned resource is observed, so its 200 focal rows and 588 total rows are fixed counts rather than uncertain parameters.

## Slide 374: Posterior distributions: question 3

Source note: `statistical-inference/posterior-distributions.qmd`

Which assumption makes the exchangeable Bernoulli superpopulation model a counterfactual superpopulation model rather than a description of the committed sample?

## Slide 375: Posterior distributions: answer 3

Source note: `statistical-inference/posterior-distributions.qmd`

The exchangeable Bernoulli superpopulation model assumes independent, exchangeable Bernoulli draws from a superpopulation, while the committed sample was drawn without replacement from the known finite resource.

## Slide 376: Posterior distributions: question 4

Source note: `statistical-inference/posterior-distributions.qmd`

Why is a posterior density at one value not a point probability?

## Slide 377: Posterior distributions: answer 4

Source note: `statistical-inference/posterior-distributions.qmd`

For a continuous parameter, probability is an integral over an interval; a density value at one point is not probability mass at that point. The posterior-summaries page extracts several distinct claims from this posterior.

## Slide 378: Summarizing a posterior distribution

Source note: `statistical-inference/posterior-summaries.qmd`

Now we turn to Summarizing a posterior distribution.

## Slide 379: Summarizing a posterior distribution

Source note: `statistical-inference/posterior-summaries.qmd`

The posterior-distribution page defined the exchangeable Bernoulli superpopulation model. We now summarize its $\operatorname{Beta}(43,79)$ posterior without changing the estimand or the sampling caveat.

## Slide 380: Center and spread

Source note: `statistical-inference/posterior-summaries.qmd`

For $\Theta\mid\mathbf z\sim\operatorname{Beta}(\alpha',\beta')$,

$$
\mathbb{E}[\Theta\mid\mathbf z]
=\frac{\alpha'}{\alpha'+\beta'},
$$

and

$$
\operatorname{Var}[\Theta\mid\mathbf z]
=
\frac{\alpha'\beta'}
{(\alpha'+\beta')^2(\alpha'+\beta'+1)}.
$$

## Slide 381: Center and spread

Source note: `statistical-inference/posterior-summaries.qmd`

The exchangeable Bernoulli superpopulation model posterior mean is 0.352459, and its variance is 0.001856. The posterior median is 0.351650. The mean minimizes posterior expected squared-error loss; a median minimizes posterior expected absolute-error loss. Thus neither center is automatically the preferred estimate without a loss function.

## Slide 382: Credible intervals and directional probabilities

Source note: `statistical-inference/posterior-summaries.qmd`

An equal-tailed 95% credible interval uses the posterior quantiles

$$
\left[
F^{-1}_{\Theta\mid\mathbf z}(.025),
F^{-1}_{\Theta\mid\mathbf z}(.975)
\right].
$$

## Slide 383: Credible intervals and directional probabilities

Source note: `statistical-inference/posterior-summaries.qmd`

For the exchangeable Bernoulli superpopulation model it is [0.270494, 0.439007]. Conditional on the exchangeable model, prior, and observed sample, 95% of the posterior mass lies in this interval. This is not the repeated-sampling interpretation of a confidence interval.

## Slide 384: Credible intervals and directional probabilities

Source note: `statistical-inference/posterior-summaries.qmd`

The probability that the counterfactual exchangeable share exceeds the known resource share is

$$
\mathbb{P}\!\left(\Theta>\frac{K}{N}\mid\mathbf z\right)
=
\int_{K/N}^1
f_{\Theta\mid\mathbf Z}(\theta\mid\mathbf z)\,\mathrm d\theta.
$$

## Slide 385: Credible intervals and directional probabilities

Source note: `statistical-inference/posterior-summaries.qmd`

Its value is 0.605346. This comparison does not make $K/N$ uncertain and should not be read as evidence that the file’s known proportion has changed.

## Slide 386: Credible intervals and directional probabilities

Source note: `statistical-inference/posterior-summaries.qmd`

exchangeable Bernoulli superpopulation model posterior density. The shaded region is the central 95% interval; the vertical line is the known pinned-resource share.

## Slide 387: Transform before summarizing

Source note: `statistical-inference/posterior-summaries.qmd`

Suppose the linguistic report uses odds rather than a probability. Define

$$
G(\Theta)=\frac{\Theta}{1-\Theta}.
$$

## Slide 388: Transform before summarizing

Source note: `statistical-inference/posterior-summaries.qmd`

The mean of the transformed quantity generally differs from the transformation of the mean:

$$
\mathbb{E}[G(\Theta)\mid\mathbf z]
\ne
G\!\left(\mathbb{E}[\Theta\mid\mathbf z]\right).
$$

## Slide 389: Transform before summarizing

Source note: `statistical-inference/posterior-summaries.qmd`

For a beta posterior, the first expectation exists when $\beta'>1$ and equals $\alpha'/(\beta'-1)$.

## Slide 390: Transform before summarizing

Source note: `statistical-inference/posterior-summaries.qmd`

Compute the estimand within each posterior value or draw, then summarize that distribution. The same rule preserves joint uncertainty when a contrast depends on several parameters.

## Slide 391: Matching the summary to the claim

Source note: `statistical-inference/posterior-summaries.qmd`

A center answers a location question, an interval describes posterior concentration, and a directional probability answers a threshold question. None of these summaries turns the exchangeable Bernoulli superpopulation model into a model of Turkish token frequency. The row remains a lexeme--paradigm cell, and the independent-draw assumption remains a modeling assumption imposed for instruction.

## Slide 392: Summarizing a posterior distribution: question 1

Source note: `statistical-inference/posterior-summaries.qmd`

Which loss functions select the posterior mean and median?

## Slide 393: Summarizing a posterior distribution: answer 1

Source note: `statistical-inference/posterior-summaries.qmd`

Squared-error loss selects the posterior mean; absolute-error loss selects a posterior median.

## Slide 394: Summarizing a posterior distribution: question 2

Source note: `statistical-inference/posterior-summaries.qmd`

How does a 95% credible interval differ from a 95% confidence interval?

## Slide 395: Summarizing a posterior distribution: answer 2

Source note: `statistical-inference/posterior-summaries.qmd`

A 95% credible interval contains 95% posterior mass conditional on the model, prior, and data; a 95% confidence procedure covers the fixed parameter in 95% of repeated samples under its reference model.

## Slide 396: Summarizing a posterior distribution: question 3

Source note: `statistical-inference/posterior-summaries.qmd`

Why does $\mathbb{P}(\Theta>K/N\mid\mathbf z)$ not update $K/N$?

## Slide 397: Summarizing a posterior distribution: answer 3

Source note: `statistical-inference/posterior-summaries.qmd`

$K/N$ is computed from the complete pinned resource and remains fixed; the posterior probability concerns the counterfactual superpopulation parameter $\Theta$.

## Slide 398: Summarizing a posterior distribution: question 4

Source note: `statistical-inference/posterior-summaries.qmd`

Why should a nonlinear estimand be transformed before it is summarized?

## Slide 399: Summarizing a posterior distribution: answer 4

Source note: `statistical-inference/posterior-summaries.qmd`

For nonlinear $G$, $\mathbb{E}[G(\Theta)\mid\mathbf z]$ generally differs from $G(\mathbb{E}[\Theta\mid\mathbf z])$, so the transformation must be applied to each posterior value first. The next page derives the algebra that produced this posterior family.

## Slide 400: Conjugate priors

Source note: `statistical-inference/conjugate-priors.qmd`

The next topic is Conjugate priors.

## Slide 401: Conjugate priors

Source note: `statistical-inference/conjugate-priors.qmd`

The posterior-distribution page normalized a continuous update by recognizing a beta density. A prior is **conjugate** to a likelihood when the resulting posterior belongs to the same distribution family as the prior.

## Slide 402: The exchangeable Bernoulli superpopulation model likelihood and prior

Source note: `statistical-inference/conjugate-priors.qmd`

The exchangeable Bernoulli superpopulation model treats the Turkish UniMorph indicators as draws from a counterfactual exchangeable superpopulation:

$$
Z_i\mid\Theta=\theta
\overset{\mathrm{iid}}{\sim}
\operatorname{Bernoulli}(\theta).
$$

## Slide 403: The exchangeable Bernoulli superpopulation model likelihood and prior

Source note: `statistical-inference/conjugate-priors.qmd`

The committed sample contains 42 *t*-initial endings among 120 lexeme--paradigm cells. These are type-level rows, not corpus tokens, and the actual sample was drawn without replacement.

## Slide 404: The exchangeable Bernoulli superpopulation model likelihood and prior

Source note: `statistical-inference/conjugate-priors.qmd`

For a $\operatorname{Beta}(\alpha,\beta)$ prior,

$$
f_\Theta(\theta)
=
\frac{1}{B(\alpha,\beta)}
\theta^{\alpha-1}(1-\theta)^{\beta-1},
\qquad 0<\theta<1.
$$

## Slide 405: The exchangeable Bernoulli superpopulation model likelihood and prior

Source note: `statistical-inference/conjugate-priors.qmd`

Conditional independence gives the likelihood

$$
\begin{aligned}
p_{\mathbf Z\mid\Theta}(\mathbf z\mid\theta)
&=
\prod_{i=1}^n
\theta^{z_i}(1-\theta)^{1-z_i}\\
&=
\theta^k(1-\theta)^{n-k}.
\end{aligned}
$$

## Slide 406: Collecting powers

Source note: `statistical-inference/conjugate-priors.qmd`

Bayes' rule gives

$$
\begin{aligned}
f_{\Theta\mid\mathbf Z}(\theta\mid\mathbf z)
&\propto
p_{\mathbf Z\mid\Theta}(\mathbf z\mid\theta)f_\Theta(\theta)\\
&\propto
\theta^k(1-\theta)^{n-k}
\theta^{\alpha-1}(1-\theta)^{\beta-1}\\
&=
\theta^{\alpha+k-1}
(1-\theta)^{\beta+n-k-1}.
\end{aligned}
$$

## Slide 407: Collecting powers

Source note: `statistical-inference/conjugate-priors.qmd`

This is the kernel of another beta density:

$$
\Theta\mid\mathbf z
\sim
\operatorname{Beta}(\alpha+k,\beta+n-k).
$$

## Slide 408: Collecting powers

Source note: `statistical-inference/conjugate-priors.qmd`

Thus the two posterior shape parameters are obtained by adding the focal and nonfocal counts to the corresponding prior shapes. With the support-calibrated $\operatorname{Beta}(1,1)$ prior, the result is a beta distribution with shape parameters 43 and 79.

## Slide 409: Collecting powers

Source note: `statistical-inference/conjugate-priors.qmd`

This figure shows beta prior and posterior for the exchangeable Bernoulli superpopulation model, calculated from the observed 42 of 120 lexeme cells.

## Slide 410: The normalizing constant

Source note: `statistical-inference/conjugate-priors.qmd`

Recognizing the kernel supplies the constant that makes the density integrate to one:

$$
f_{\Theta\mid\mathbf Z}(\theta\mid\mathbf z)
=
\frac{1}{B(\alpha+k,\beta+n-k)}
\theta^{\alpha+k-1}(1-\theta)^{\beta+n-k-1}.
$$

## Slide 411: The normalizing constant

Source note: `statistical-inference/conjugate-priors.qmd`

The beta function is

$$
B(a,b)
=
\int_0^1t^{a-1}(1-t)^{b-1}\,\mathrm dt.
$$

## Slide 412: The normalizing constant

Source note: `statistical-inference/conjugate-priors.qmd`

Conjugacy makes this calculation algebraic. It does not establish that the exchangeable Bernoulli likelihood matches the data-collection design.

## Slide 413: What conjugacy buys, and what it does not

Source note: `statistical-inference/conjugate-priors.qmd`

The update is computationally convenient: it provides a normalized posterior, closed-form moments, and beta-binomial predictive masses. But convenience is separate from measurement and sampling. The known UniMorph resource contains 200 focal cells among 588, so the actual finite-population design is hypergeometric. The exchangeable Bernoulli model is a working superpopulation model rather than an analysis of uncertainty about the file.

## Slide 414: Conjugate priors: question 1

Source note: `statistical-inference/conjugate-priors.qmd`

Which exponents are added in the beta--Bernoulli update?

## Slide 415: Conjugate priors: answer 1

Source note: `statistical-inference/conjugate-priors.qmd`

The prior exponents $\alpha-1$ and $\beta-1$ receive the focal count $k$ and nonfocal count $n-k$, yielding shapes $\alpha+k$ and $\beta+n-k$.

## Slide 416: Conjugate priors: question 2

Source note: `statistical-inference/conjugate-priors.qmd`

Why can order be omitted from this likelihood?

## Slide 417: Conjugate priors: answer 2

Source note: `statistical-inference/conjugate-priors.qmd`

Conditional exchangeability makes every ordered binary sequence with the same $k$ contribute the same likelihood kernel $\theta^k(1-\theta)^{n-k}$.

## Slide 418: Conjugate priors: question 3

Source note: `statistical-inference/conjugate-priors.qmd`

What does recognizing the beta kernel provide?

## Slide 419: Conjugate priors: answer 3

Source note: `statistical-inference/conjugate-priors.qmd`

Recognizing the beta kernel provides the normalized beta posterior, including its beta-function constant, moments, and predictive distribution.

## Slide 420: Conjugate priors: question 4

Source note: `statistical-inference/conjugate-priors.qmd`

Why does conjugacy not justify the independent-draw assumption?

## Slide 421: Conjugate priors: answer 4

Source note: `statistical-inference/conjugate-priors.qmd`

Conjugacy is an algebraic relation between a prior and likelihood; it supplies no evidence that independent draws match the actual without-replacement design. The prior-predictive page asks what this model predicts before the sample updates it.

## Slide 422: Prior predictive distributions

Source note: `statistical-inference/prior-predictive-distributions.qmd`

Now we turn to Prior predictive distributions.

## Slide 423: Prior predictive distributions

Source note: `statistical-inference/prior-predictive-distributions.qmd`

The conjugate-prior page updated a beta prior after observing the Turkish UniMorph sample. We now ask what the exchangeable Bernoulli superpopulation model predicted before those rows were observed.

## Slide 424: From a parameter prior to possible counts

Source note: `statistical-inference/prior-predictive-distributions.qmd`

Under the counterfactual exchangeable-superpopulation design,

$$
\Theta\sim\operatorname{Beta}(\alpha,\beta),
$$

and, conditional on $\Theta=\theta$, a block count satisfies

$$
\widetilde K\mid\Theta=\theta
\sim\operatorname{Binomial}(m,\theta).
$$

## Slide 425: From a parameter prior to possible counts

Source note: `statistical-inference/prior-predictive-distributions.qmd`

The **prior predictive distribution** averages the binomial mass over the prior density:

$$
\begin{aligned}
\mathbb{P}(\widetilde K=r)
&=
\int_0^1
\mathbb{P}(\widetilde K=r\mid\Theta=\theta)
f_\Theta(\theta)\,\mathrm d\theta\\
&=
\binom mr
\frac{B(r+\alpha,m-r+\beta)}{B(\alpha,\beta)}.
\end{aligned}
$$

## Slide 426: From a parameter prior to possible counts

Source note: `statistical-inference/prior-predictive-distributions.qmd`

This is the beta-binomial mass function. It makes parameter uncertainty visible in the units that the design records: the number of *t*-initial cells in a block of lexeme--paradigm rows.

## Slide 427: From a parameter prior to possible counts

Source note: `statistical-inference/prior-predictive-distributions.qmd`

With the $\operatorname{Beta}(1,1)$ prior and observed block size 120, the prior-predictive expectation and variance are

$$
\mathbb{E}[\widetilde K]
=m\frac{\alpha}{\alpha+\beta}
$$

and

$$
\operatorname{Var}[\widetilde K]
=
m\frac{\alpha\beta}{(\alpha+\beta)^2}
\frac{\alpha+\beta+m}{\alpha+\beta+1}.
$$

## Slide 428: From a parameter prior to possible counts

Source note: `statistical-inference/prior-predictive-distributions.qmd`

They evaluate to 60.000 and 1220.000. The variance is large because one $\theta$ is drawn for the complete block, then all cells in that block share it.

## Slide 429: From a parameter prior to possible counts

Source note: `statistical-inference/prior-predictive-distributions.qmd`

exchangeable Bernoulli superpopulation model prior-predictive mass for a 120-cell independent block. The line marks the count in the committed sample; it is shown only as an observed reference.

## Slide 430: Generating the same distribution

Source note: `statistical-inference/prior-predictive-distributions.qmd`

The integral can also be simulated in the order specified by the model: draw one $\theta^{(s)}$ for a block, then draw its count.

## Slide 431: Generating the same distribution

Source note: `statistical-inference/prior-predictive-distributions.qmd`

Drawing a fresh $\theta$ before every cell would define a different model. It would average the Bernoulli probability cell by cell and lose the block-level variation represented by the beta-binomial distribution.

## Slide 432: The finite-population restriction

Source note: `statistical-inference/prior-predictive-distributions.qmd`

The prior-predictive distribution belongs to the counterfactual independent-draw exchangeable Bernoulli superpopulation model. It is not the randomization distribution of the actual sample file, whose rows were drawn without replacement from a known population. Nor does it describe Turkish usage, since UniMorph rows have no token-frequency interpretation.

## Slide 433: The finite-population restriction

Source note: `statistical-inference/prior-predictive-distributions.qmd`

Prior prediction remains useful here because it makes that model's commitment explicit. The posterior-predictive page will put the independent-draw prediction beside the corresponding finite-population prediction.

## Slide 434: Prior predictive distributions: question 1

Source note: `statistical-inference/prior-predictive-distributions.qmd`

Why is the predictive outcome a count rather than a value of $\Theta$?

## Slide 435: Prior predictive distributions: answer 1

Source note: `statistical-inference/prior-predictive-distributions.qmd`

The prediction concerns what the design records in a future block: the number of *t*-initial lexeme cells, after averaging over uncertainty in $\Theta$.

## Slide 436: Prior predictive distributions: question 2

Source note: `statistical-inference/prior-predictive-distributions.qmd`

Why must one simulated block use one shared draw of $\theta$?

## Slide 437: Prior predictive distributions: answer 2

Source note: `statistical-inference/prior-predictive-distributions.qmd`

Draw one $\theta$ for the block, then draw all cells conditionally independently given that $\theta$. Averaging over the shared $\theta$ induces the positive dependence and extra beta-binomial variation.

## Slide 438: Prior predictive distributions: question 3

Source note: `statistical-inference/prior-predictive-distributions.qmd`

Which part of the variance reflects uncertainty about $\Theta$?

## Slide 439: Prior predictive distributions: answer 3

Source note: `statistical-inference/prior-predictive-distributions.qmd`

The beta-binomial overdispersion factor, equivalently the variation in the conditional mean $m\Theta$, reflects uncertainty about $\Theta$.

## Slide 440: Prior predictive distributions: question 4

Source note: `statistical-inference/prior-predictive-distributions.qmd`

Why is this beta-binomial mass not the sample's actual randomization distribution?

## Slide 441: Prior predictive distributions: answer 4

Source note: `statistical-inference/prior-predictive-distributions.qmd`

The actual 120 rows were sampled without replacement from a known 588-row resource, so their randomization distribution is hypergeometric rather than beta-binomial.

## Slide 442: Posterior predictive distributions

Source note: `statistical-inference/predictive-distributions.qmd`

Our next step is Posterior predictive distributions.

## Slide 443: Posterior predictive distributions

Source note: `statistical-inference/predictive-distributions.qmd`

The prior-predictive page averaged the observation model over the prior. A **posterior predictive distribution** averages over the posterior. The Turkish UniMorph example also lets us compare that counterfactual independent-draw prediction with the actual without-replacement design.

## Slide 444: Prediction under the exchangeable Bernoulli model

Source note: `statistical-inference/predictive-distributions.qmd`

For one future binary value,

$$
\mathbb{P}(\widetilde Z=1\mid\mathbf z)
=
\int_0^1\theta
f_{\Theta\mid\mathbf Z}(\theta\mid\mathbf z)\,\mathrm d\theta
=
\mathbb{E}[\Theta\mid\mathbf z].
$$

## Slide 445: Prediction under the exchangeable Bernoulli model

Source note: `statistical-inference/predictive-distributions.qmd`

For a future independent block of $m$ cells,

$$
\widetilde K\mid\Theta=\theta
\sim\operatorname{Binomial}(m,\theta),
$$

and a $\operatorname{Beta}(\alpha',\beta')$ posterior gives

$$
\mathbb{P}(\widetilde K=r\mid\mathbf z)
=
\binom mr
\frac{B(r+\alpha',m-r+\beta')}{B(\alpha',\beta')}.
$$

## Slide 446: Prediction under the exchangeable Bernoulli model

Source note: `statistical-inference/predictive-distributions.qmd`

Its expectation and variance are

$$
\mathbb{E}[\widetilde K\mid\mathbf z]
=m\frac{\alpha'}{\alpha'+\beta'},
$$

$$
\operatorname{Var}[\widetilde K\mid\mathbf z]
=
m\frac{\alpha'\beta'}{(\alpha'+\beta')^2}
\frac{\alpha'+\beta'+m}{\alpha'+\beta'+1}.
$$

## Slide 447: Predicting from the known remaining resource

Source note: `statistical-inference/predictive-distributions.qmd`

The actual committed sample removed its rows from the pinned resource. If another block is drawn without replacement from the remaining $N_r$ cells, of which $K_r$ are focal, then

$$
\mathbb{P}(\widetilde K=r\mid N_r,K_r,m)
=
\frac{\binom{K_r}{r}\binom{N_r-K_r}{m-r}}{\binom{N_r}{m}}.
$$

## Slide 448: Predicting from the known remaining resource

Source note: `statistical-inference/predictive-distributions.qmd`

This hypergeometric distribution is not a posterior. It is the sampling distribution induced by the known finite resource.

## Slide 449: Predicting from the known remaining resource

Source note: `statistical-inference/predictive-distributions.qmd`

The exchangeable Bernoulli superpopulation model predicts a mean of 42.295 *t*-initial rows and variance 53.885. The actual remaining-resource design has mean 40.513 and variance 19.997. The difference is a design difference, not a small correction to one model.

## Slide 450: Predicting from the known remaining resource

Source note: `statistical-inference/predictive-distributions.qmd`

This figure shows predictive masses for a second 120-cell block. The posterior beta-binomial uses an independent-draw model; the narrower hypergeometric mass uses the known remaining finite population.

## Slide 451: Two sources of posterior-predictive variation

Source note: `statistical-inference/predictive-distributions.qmd`

The law of total variance gives

$$
\operatorname{Var}[\widetilde K\mid\mathbf z]
=
\mathbb{E}[\operatorname{Var}[\widetilde K\mid\Theta,\mathbf z]\mid\mathbf z]
+
\operatorname{Var}[\mathbb{E}[\widetilde K\mid\Theta,\mathbf z]\mid\mathbf z].
$$

## Slide 452: Two sources of posterior-predictive variation

Source note: `statistical-inference/predictive-distributions.qmd`

The first term averages binomial variation, while the second represents variation in the conditional mean $m\Theta$ across the posterior.

## Slide 453: Two sources of posterior-predictive variation

Source note: `statistical-inference/predictive-distributions.qmd`

More simulation draws can estimate either predictive distribution more precisely, but they do not reduce future variation. And neither distribution supports a token-frequency claim about Turkish.

## Slide 454: Posterior predictive distributions: question 1

Source note: `statistical-inference/predictive-distributions.qmd`

Why does the one-cell exchangeable Bernoulli superpopulation model prediction equal the posterior mean?

## Slide 455: Posterior predictive distributions: answer 1

Source note: `statistical-inference/predictive-distributions.qmd`

Conditional on $\Theta$, the success probability is $\Theta$; averaging it over the posterior gives $\mathbb{P}(\widetilde Z=1\mid\mathbf z)=\mathbb{E}[\Theta\mid\mathbf z]$.

## Slide 456: Posterior predictive distributions: question 2

Source note: `statistical-inference/predictive-distributions.qmd`

Which term in total variance disappears under a plug-in prediction?

## Slide 457: Posterior predictive distributions: answer 2

Source note: `statistical-inference/predictive-distributions.qmd`

The plug-in fixes $\Theta$, so $\operatorname{Var}[\mathbb{E}[\widetilde K\mid\Theta,\mathbf z]\mid\mathbf z]$, the parameter-uncertainty term, disappears.

## Slide 458: Posterior predictive distributions: question 3

Source note: `statistical-inference/predictive-distributions.qmd`

Why is the hypergeometric prediction narrower?

## Slide 459: Posterior predictive distributions: answer 3

Source note: `statistical-inference/predictive-distributions.qmd`

Sampling without replacement uses up focal and nonfocal cells and adds a finite-population correction, reducing variance.

## Slide 460: Posterior predictive distributions: question 4

Source note: `statistical-inference/predictive-distributions.qmd`

Which prediction matches another sample from the committed resource?

## Slide 461: Posterior predictive distributions: answer 4

Source note: `statistical-inference/predictive-distributions.qmd`

The hypergeometric prediction matches another without-replacement sample from the remaining committed resource. The next page turns to a posterior whose normalizing constant is unavailable in closed form.

## Slide 462: When the posterior will not normalize by hand

Source note: `statistical-inference/beyond-conjugacy.qmd`

Next, we take up When the posterior will not normalize by hand.

## Slide 463: Provo: the empirical object

Source note: `statistical-inference/beyond-conjugacy.qmd`

The data source is Luke and Christianson (2018), Provo Corpus. It provides content-word positions aggregated across Provo readers.

## Slide 464: When the posterior will not normalize by hand

Source note: `statistical-inference/beyond-conjugacy.qmd`

Conjugacy identifies a normalized posterior by matching a familiar density. Many useful likelihood--prior combinations do not provide that match. We now fix one empirical posterior that every remaining computation page will target.

## Slide 465: A passage-level Student-t model

Source note: `statistical-inference/beyond-conjugacy.qmd`

The Provo Corpus contains eye-tracking measurements and predictability norms for 55 English passages. Luke and Christianson (2018) describe the resource and its original measurements. The release is CC BY 4.0.

## Slide 466: A passage-level Student-t model

Source note: `statistical-inference/beyond-conjugacy.qmd`

The course table contains one summary per passage, derived from 1,593 retained content-word positions. Each position was already aggregated across readers, so these rows are not participant trials. For passage $j$, let $\mathcal N_j$ and $\mathcal V_j$ be its retained noun and verb positions and let $d_{ji}$ be the position-level mean log first-fixation duration. We define

$$
y_j=
\frac{1}{|\mathcal N_j|}\sum_{i\in\mathcal N_j}d_{ji}
-
\frac{1}{|\mathcal V_j|}\sum_{i\in\mathcal V_j}d_{ji}.
$$

## Slide 467: A passage-level Student-t model

Source note: `statistical-inference/beyond-conjugacy.qmd`

The resulting 55-observation analysis describes the unweighted distribution of passage summaries. It is not participant-level inference or a probability sample of English texts.

## Slide 468: A robust location--scale model

Source note: `statistical-inference/beyond-conjugacy.qmd`

The passage-level model uses

$$
Y_j\mid\mu,\sigma
\sim t_4(\mu,\sigma),
$$

with

$$
\mu\sim\mathcal N(0,(2s_y)^2),
\qquad
\sigma\sim\operatorname{HalfNormal}(0,2s_y),
$$

where $s_y$ is the observed standard deviation of the 55 contrasts.

## Slide 469: A robust location--scale model

Source note: `statistical-inference/beyond-conjugacy.qmd`

Thus both prior scales are computed as 0.103355. This is an empirically calibrated teaching prior, not a confirmatory analysis. The fixed four degrees of freedom make the observation model less sensitive to an extreme passage than a normal likelihood would be.

## Slide 470: A robust location--scale model

Source note: `statistical-inference/beyond-conjugacy.qmd`

Let $\eta=(\mu,\log\sigma)$. The unnormalized log posterior on this unconstrained scale is

$$
\begin{aligned}
\log\widetilde f(\eta\mid\mathbf y)
={}&\sum_{j=1}^{N}
\left[
\log t_4\!\left(\frac{y_j-\mu}{\sigma}\right)
-\log\sigma
\right]\\
&+\log\phi(\mu;0,2s_y)
+\log 2+\log\phi(\sigma;0,2s_y)
+\log\sigma.
\end{aligned}
$$

## Slide 471: A robust location--scale model

Source note: `statistical-inference/beyond-conjugacy.qmd`

The final term is the Jacobian for $\sigma=\exp(\eta_2)$. The Stan program later samples $\sigma$ directly and lets Stan handle its internal transform, so it does not add this term manually.

## Slide 472: A robust location--scale model

Source note: `statistical-inference/beyond-conjugacy.qmd`

The grid gives $\mathbb{P}(\mu>0\mid\mathbf y)=$ 0.911, though the 95% interval for $\mu$, [-0.0046, 0.0236], includes zero. This measured result concerns the passage-level Student-t model only.

## Slide 473: A robust location--scale model

Source note: `statistical-inference/beyond-conjugacy.qmd`

This figure shows observed passage contrasts with the fitted Student-t density at the grid-posterior means.

## Slide 474: The missing normalizer

Source note: `statistical-inference/beyond-conjugacy.qmd`

The normalized posterior is

$$
f(\eta\mid\mathbf y)
=
\frac{\widetilde f(\eta\mid\mathbf y)}{Z},
\qquad
Z=\int_{\mathbb R^2}\widetilde f(\eta'\mid\mathbf y)\,\mathrm d\eta'.
$$

## Slide 475: The missing normalizer

Source note: `statistical-inference/beyond-conjugacy.qmd`

The grid approximates $Z$ numerically, but later algorithms need only relative density or its gradient. For two parameter values,

$$
\frac{f(\eta_b\mid\mathbf y)}{f(\eta_a\mid\mathbf y)}
=
\frac{\widetilde f(\eta_b\mid\mathbf y)}{\widetilde f(\eta_a\mid\mathbf y)},
$$

because $Z$ cancels.

## Slide 476: The missing normalizer

Source note: `statistical-inference/beyond-conjugacy.qmd`

A missing closed-form normalizer is thus a computational problem, not an undefined posterior, provided $0<Z<\infty$.

## Slide 477: When the posterior will not normalize by hand: question 1

Source note: `statistical-inference/beyond-conjugacy.qmd`

What does one $y_j$ summarize?

## Slide 478: When the posterior will not normalize by hand: answer 1

Source note: `statistical-inference/beyond-conjugacy.qmd`

One $y_j$ is a passage's mean noun log-FFD minus its mean verb log-FFD, computed from the retained position summaries in that passage.

## Slide 479: When the posterior will not normalize by hand: question 2

Source note: `statistical-inference/beyond-conjugacy.qmd`

Why does the passage-level Student-t model not support participant-level inference?

## Slide 480: When the posterior will not normalize by hand: answer 2

Source note: `statistical-inference/beyond-conjugacy.qmd`

Reader trials were already aggregated into position and passage summaries, so participant identities and participant-level variation cannot be recovered.

## Slide 481: When the posterior will not normalize by hand: question 3

Source note: `statistical-inference/beyond-conjugacy.qmd`

Which term is the Jacobian in the log target?

## Slide 482: When the posterior will not normalize by hand: answer 3

Source note: `statistical-inference/beyond-conjugacy.qmd`

The final $+\log\sigma$ term is the Jacobian for the transformation $\sigma=\exp(\eta_2)$.

## Slide 483: When the posterior will not normalize by hand: question 4

Source note: `statistical-inference/beyond-conjugacy.qmd`

Why can later algorithms use the unnormalized target?

## Slide 484: When the posterior will not normalize by hand: answer 4

Source note: `statistical-inference/beyond-conjugacy.qmd`

Density ratios and gradients do not require the common normalizing constant $Z$; it cancels or differentiates away. The Monte Carlo page first approximates expectations under the passage-level Student-t posterior using independent draws from this normalized grid.

## Slide 485: Monte Carlo integration

Source note: `statistical-inference/monte-carlo-integration.qmd`

Next, we take up Monte Carlo integration.

## Slide 486: Monte Carlo integration

Source note: `statistical-inference/monte-carlo-integration.qmd`

The passage-level Student-$t$ model has no convenient closed-form posterior. Monte Carlo integration replaces an expectation under that posterior with an average over draws while keeping posterior uncertainty distinct from numerical error.

## Slide 487: Expectations as integrals

Source note: `statistical-inference/monte-carlo-integration.qmd`

For a target density $f(\eta\mid\mathbf y)$ and an integrable function $g$,

$$
I
=
\mathbb{E}[g(\eta)\mid\mathbf y]
=
\int g(\eta)f(\eta\mid\mathbf y)\,\mathrm d\eta.
$$

## Slide 488: Expectations as integrals

Source note: `statistical-inference/monte-carlo-integration.qmd`

Independent target draws give the estimator

$$
\widehat I_S
=
\frac{1}{S}\sum_{s=1}^Sg(\eta^{(s)}).
$$

## Slide 489: Expectations as integrals

Source note: `statistical-inference/monte-carlo-integration.qmd`

Setting $g(\eta)=\mu$ estimates the posterior mean of the passage location. Setting $g(\eta)=\mathbf 1\{\mu>0\}$ estimates its directional probability, while $g(\eta)=\exp(\mu)$ gives a central geometric-scale noun-to-verb ratio.

## Slide 490: Drawing from the posterior grid

Source note: `statistical-inference/monte-carlo-integration.qmd`

the calculation reconstructs the passage-level Student-t model from the 55 passage summaries, normalizes its $321\times321$ reference grid, and samples 20,000 grid cells with their posterior weights.

## Slide 491: Drawing from the posterior grid

Source note: `statistical-inference/monte-carlo-integration.qmd`

The grid benchmark and Monte Carlo estimates agree to the scale of their Monte Carlo standard errors (MCSEs). For independent draws,

$$
\widehat{\operatorname{MCSE}}(\widehat I_S)
=
\sqrt{\frac{\widehat{\operatorname{Var}}(g(\eta))}{S}}.
$$

## Slide 492: Drawing from the posterior grid

Source note: `statistical-inference/monte-carlo-integration.qmd`

For an indicator this becomes

$$
\widehat{\operatorname{MCSE}}
=
\sqrt{\frac{\widehat I_S(1-\widehat I_S)}{S}}.
$$

## Slide 493: Drawing from the posterior grid

Source note: `statistical-inference/monte-carlo-integration.qmd`

Multiplying $S$ by four tends to halve MCSE. This square-root rate concerns the approximation, not the posterior spread.

## Slide 494: Drawing from the posterior grid

Source note: `statistical-inference/monte-carlo-integration.qmd`

Running Monte Carlo estimate of the passage-level Student-t model directional probability. The horizontal line is the quadrature reference.

## Slide 495: Drawing from the posterior grid

Source note: `statistical-inference/monte-carlo-integration.qmd`

The law of large numbers justifies convergence of the average when the expectation exists. A central limit theorem motivates MCSE when $g(\eta)$ has finite variance. Neither result says that the passage-level Student-t model's passage aggregation, likelihood, or empirically calibrated priors are adequate.

## Slide 496: Two uncertainties

Source note: `statistical-inference/monte-carlo-integration.qmd`

Posterior spread describes model-based uncertainty about the passage-level Student-t model. Monte Carlo error describes finite numerical approximation. Increasing $S$ reduces the latter but adds no passages, positions, or readers. More draws are not more linguistic evidence.

## Slide 497: Monte Carlo integration: question 1

Source note: `statistical-inference/monte-carlo-integration.qmd`

Which function $g$ estimates $\mathbb{P}(\mu>0\mid\mathbf y)$?

## Slide 498: Monte Carlo integration: answer 1

Source note: `statistical-inference/monte-carlo-integration.qmd`

Use the indicator $g(\eta)=\mathbf 1\{\mu>0\}$.

## Slide 499: Monte Carlo integration: question 2

Source note: `statistical-inference/monte-carlo-integration.qmd`

Why is the estimate an integral approximation?

## Slide 500: Monte Carlo integration: answer 2

Source note: `statistical-inference/monte-carlo-integration.qmd`

The sample average replaces the posterior integral of $g(\eta)$ with an empirical average over draws from that posterior.

## Slide 501: Monte Carlo integration: question 3

Source note: `statistical-inference/monte-carlo-integration.qmd`

What happens to MCSE when $S$ is quadrupled?

## Slide 502: Monte Carlo integration: answer 3

Source note: `statistical-inference/monte-carlo-integration.qmd`

Quadrupling $S$ tends to halve MCSE because MCSE decreases at the $1/\sqrt S$ rate.

## Slide 503: Monte Carlo integration: question 4

Source note: `statistical-inference/monte-carlo-integration.qmd`

Which uncertainty requires additional linguistic observations to change?

## Slide 504: Monte Carlo integration: answer 4

Source note: `statistical-inference/monte-carlo-integration.qmd`

Posterior uncertainty about the linguistic target changes with additional linguistic observations; more simulation draws change only computational uncertainty.

## Slide 505: Importance sampling

Source note: `statistical-inference/importance-sampling.qmd`

Our next step is Importance sampling.

## Slide 506: Importance sampling

Source note: `statistical-inference/importance-sampling.qmd`

Monte Carlo integration used draws from the normalized posterior grid. **Importance sampling** instead draws from a proposal distribution and corrects its mismatch with the unnormalized passage-level Student-t posterior through weights.

## Slide 507: Reweighting a proposal

Source note: `statistical-inference/importance-sampling.qmd`

For target density $f$, proposal density $g$, and integrand $h$,

$$
\begin{aligned}
\mathbb{E}_f[h(\eta)]
&=
\int h(\eta)\frac{f(\eta)}{g(\eta)}g(\eta)\,\mathrm d\eta\\
&=
\mathbb{E}_g[h(\eta)w(\eta)],
\end{aligned}
$$

where $w(\eta)=f(\eta)/g(\eta)$.

## Slide 508: Reweighting a proposal

Source note: `statistical-inference/importance-sampling.qmd`

If the target is known only as $\widetilde f(\eta)=Zf(\eta)$, normalized weights

$$
\widetilde w^{(s)}
=
\frac{\widetilde f(\eta^{(s)})/g(\eta^{(s)})}
{\sum_{r=1}^S\widetilde f(\eta^{(r)})/g(\eta^{(r)})}
$$

remove the shared unknown constant.

## Slide 509: Reweighting a proposal

Source note: `statistical-inference/importance-sampling.qmd`

The self-normalized estimator is

$$
\widehat I_S
=
\sum_{s=1}^S\widetilde w^{(s)}h(\eta^{(s)}).
$$

## Slide 510: Reweighting a proposal

Source note: `statistical-inference/importance-sampling.qmd`

It is generally biased at finite $S$, but consistent under the required support and integrability conditions.

## Slide 511: Assessing importance weights

Source note: `statistical-inference/importance-sampling.qmd`

the calculation reconstructs the same posterior grid used on the preceding page. It then draws 30,000 values from a bivariate $t_5$ proposal centered at the grid mean with scale $1.5\widehat\Sigma$. The proposal is calibrated to this computation target, not interpreted as a linguistic distribution.

## Slide 512: Assessing importance weights

Source note: `statistical-inference/importance-sampling.qmd`

The raw-weight effective sample size,

$$
\operatorname{ESS}_w
=
\frac{1}{\sum_{s=1}^S(\widetilde w^{(s)})^2},
$$

is 23,991 from 30,000 proposal draws.

## Slide 513: Assessing importance weights

Source note: `statistical-inference/importance-sampling.qmd`

It summarizes weight concentration, not Markov-chain dependence and not the number of Provo passages.

## Slide 514: Assessing importance weights

Source note: `statistical-inference/importance-sampling.qmd`

Proposal draws for the passage-level Student-t model. The accent marks the one percent with the largest normalized weights.

## Slide 515: Assessing importance weights

Source note: `statistical-inference/importance-sampling.qmd`

The proposal must cover every target region of positive probability. Shared support is not sufficient for efficiency: if $q$ places little mass in an important target region, a few weights dominate. The largest weight and the mass in the largest 100 weights diagnose that realized concentration but cannot prove that an unseen tail was covered.

## Slide 516: Assessing importance weights

Source note: `statistical-inference/importance-sampling.qmd`

The proposal distribution is a computational device. Its unweighted draw frequency is neither a prior nor a statement about passage contrasts. Only the weighted empirical distribution approximates the passage-level Student-t model.

## Slide 517: Importance sampling: question 1

Source note: `statistical-inference/importance-sampling.qmd`

Why does self-normalization remove the target normalizer?

## Slide 518: Importance sampling: answer 1

Source note: `statistical-inference/importance-sampling.qmd`

Every raw weight contains the same unknown multiplicative target constant, which cancels when weights are divided by their sum.

## Slide 519: Importance sampling: question 2

Source note: `statistical-inference/importance-sampling.qmd`

What fails when $g(\eta)=0$ in a target region?

## Slide 520: Importance sampling: answer 2

Source note: `statistical-inference/importance-sampling.qmd`

The weight ratio is undefined there, and proposal draws can never represent that positive-probability part of the target.

## Slide 521: Importance sampling: question 3

Source note: `statistical-inference/importance-sampling.qmd`

Why can full support still yield poor efficiency?

## Slide 522: Importance sampling: answer 3

Source note: `statistical-inference/importance-sampling.qmd`

A proposal may have full support but place very little mass in an important target region, causing a few extreme weights to dominate.

## Slide 523: Importance sampling: question 4

Source note: `statistical-inference/importance-sampling.qmd`

What does $\operatorname{ESS}_w$ count in this calculation?

## Slide 524: Importance sampling: answer 4

Source note: `statistical-inference/importance-sampling.qmd`

$\operatorname{ESS}_w$ is the number of equally weighted proposal draws with roughly comparable weight information; it is not a passage count or a Markov-chain ESS.

## Slide 525: Markov chains

Source note: `statistical-inference/markov-chains.qmd`

The next topic is Markov chains.

## Slide 526: Markov chains

Source note: `statistical-inference/markov-chains.qmd`

The passage-level Student-t model cannot be sampled directly in closed form. We now construct a sequence of parameter states in which the next state depends on the current state. This dependence defines a **Markov chain**.

## Slide 527: The Markov property

Source note: `statistical-inference/markov-chains.qmd`

Let $\eta_s=(\mu_s,\log\sigma_s)$ denote the state at iteration $s$. For every measurable set $A$, the Markov property is

$$
\mathbb{P}(\eta_{s+1}\in A\mid
\eta_s=\eta_s,\ldots,\eta_1=\eta_1)
=
\mathbb{P}(\eta_{s+1}\in A\mid\eta_s=\eta_s).
$$

## Slide 528: The Markov property

Source note: `statistical-inference/markov-chains.qmd`

Once the current passage-level Student-t model state is known, earlier states do not alter the next transition distribution. This does not make adjacent states independent: the proposal is centered on the current state, and rejection repeats it.

## Slide 529: An actual passage-level Student-t model transition sequence

Source note: `statistical-inference/markov-chains.qmd`

The normalized posterior grid supplies the proposal covariance for the first 25 recorded transitions; the full sampler is developed with Metropolis--Hastings.

## Slide 530: An actual passage-level Student-t model transition sequence

Source note: `statistical-inference/markov-chains.qmd`

The first 25 states of one passage-level Student-t model random-walk chain. Horizontal segments arise when a proposal is rejected and the current state is retained.

## Slide 531: Transition and stationary distributions

Source note: `statistical-inference/markov-chains.qmd`

Write the transition kernel as

$$
K(\eta,A)
=
\mathbb{P}(\eta_{s+1}\in A\mid\eta_s=\eta).
$$

## Slide 532: Transition and stationary distributions

Source note: `statistical-inference/markov-chains.qmd`

A density $\pi$ is stationary when

$$
\int K(\eta,A)\pi(\eta)\,\mathrm d\eta
=
\int_A\pi(\eta')\,\mathrm d\eta'.
$$

That is, if the current state has distribution $\pi$, one transition leaves its distribution unchanged.

## Slide 533: Transition and stationary distributions

Source note: `statistical-inference/markov-chains.qmd`

The transition rule is not itself the posterior; it must be designed to preserve the posterior.

## Slide 534: Transition and stationary distributions

Source note: `statistical-inference/markov-chains.qmd`

For convergence from a starting state, a chain must be able to reach the relevant target regions and must not be trapped in a fixed cycle. In finite chains these properties are called irreducibility and aperiodicity. Continuous-state conditions are more technical, and a finite run still requires diagnostics.

## Slide 535: Transition and stationary distributions

Source note: `statistical-inference/markov-chains.qmd`

The Markov property is thus a conditional-independence statement about computation. It is not a substantive claim that Provo passages form a temporal sequence or that nearby passages depend on one another.

## Slide 536: Markov chains: question 1

Source note: `statistical-inference/markov-chains.qmd`

Which earlier states enter the transition after $\eta_s$ is known?

## Slide 537: Markov chains: answer 1

Source note: `statistical-inference/markov-chains.qmd`

None. Conditional on the current state $\eta_s$, the transition distribution does not depend on earlier states.

## Slide 538: Markov chains: question 2

Source note: `statistical-inference/markov-chains.qmd`

Why are adjacent states nevertheless dependent?

## Slide 539: Markov chains: answer 2

Source note: `statistical-inference/markov-chains.qmd`

The proposal is centered on the current state, and rejection repeats that state, so successive states remain statistically dependent.

## Slide 540: Markov chains: question 3

Source note: `statistical-inference/markov-chains.qmd`

Why must rejected states remain in the chain?

## Slide 541: Markov chains: answer 3

Source note: `statistical-inference/markov-chains.qmd`

Repetition records the time the chain spends in that posterior region; deleting rejections would change the chain's stationary distribution.

## Slide 542: Markov chains: question 4

Source note: `statistical-inference/markov-chains.qmd`

Which distribution is stationary for a correctly constructed chain for the passage-level Student-t model?

## Slide 543: Markov chains: answer 4

Source note: `statistical-inference/markov-chains.qmd`

The passage-level Student-t posterior is stationary for a correctly constructed chain targeting it. The next page connects averages of these dependent states to posterior expectations.

## Slide 544: Markov chain Monte Carlo

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

The next topic is Markov chain Monte Carlo.

## Slide 545: Markov chain Monte Carlo

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Monte Carlo integration used independent draws from the passage-level Student-t posterior. Direct posterior draws are often unavailable. **Markov chain Monte Carlo (MCMC)** uses dependent states from a chain whose stationary distribution is the posterior target.

## Slide 546: Chain averages

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

For the passage-level Student-t model and a function $g$, the target is

$$
I
=
\mathbb{E}[g(\eta)\mid\mathbf y]
=
\int g(\eta)f(\eta\mid\mathbf y)\,\mathrm d\eta.
$$

## Slide 547: Chain averages

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Under conditions that make the chain ergodic,

$$
\widehat I_S
=
\frac{1}{S}\sum_{s=1}^Sg(\eta^{(s)})
$$

converges to $I$.

## Slide 548: Chain averages

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Here *ergodic* means, roughly, that the chain can reach the target regions relevant to $g$ and eventually loses the influence of its starting state.

## Slide 549: Four dependent chains for the passage-level Student-t model

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Four chains use 6,000 iterations, discard 1,000 as warmup, and share proposal covariance $(2.38^2/2)\widehat\Sigma$ estimated from the normalized posterior grid.

## Slide 550: Four dependent chains for the passage-level Student-t model

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

This figure shows successive post-warmup values of mu in chain one. Their local continuity makes the dependence visible.

## Slide 551: Four dependent chains for the passage-level Student-t model

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

The four acceptance rates and posterior means are computed from the actual chains for the passage-level Student-t model. Adjacent values are dependent, so 20,000 retained states do not generally contain the information of 20,000 independent draws. Later pages quantify that loss.

## Slide 552: Three distributions

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

The posterior target is defined by the likelihood and prior. The transition distribution moves from one state to the next while preserving that target. The empirical distribution of a finite run approximates the target and contains Monte Carlo error. Conflating these three objects makes it impossible to say whether a problem belongs to the model or the computation.

## Slide 553: Three distributions

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Omitting the first 1,000 states here follows the declared reference computation. In adaptive samplers, *warmup* also tunes the transition rule. No finite iteration marks a magical point of exact stationarity, and discarding states cannot repair a transition that misses part of the target.

## Slide 554: Markov chain Monte Carlo: question 1

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Why may a dependent chain average still estimate a posterior expectation?

## Slide 555: Markov chain Monte Carlo: answer 1

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

An ergodic theorem makes averages of dependent states converge to expectations under the chain's stationary posterior distribution.

## Slide 556: Markov chain Monte Carlo: question 2

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

What does warmup change in an adaptive sampler?

## Slide 557: Markov chain Monte Carlo: answer 2

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Warmup adapts computational settings such as step size and mass matrix; it also lets the run move away from its initial state before retention.

## Slide 558: Markov chain Monte Carlo: question 3

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Why do more iterations reduce computational error but not posterior spread?

## Slide 559: Markov chain Monte Carlo: answer 3

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Iterations refine the numerical approximation to a fixed posterior; they add no linguistic observations and thus do not narrow that posterior target.

## Slide 560: Markov chain Monte Carlo: question 4

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

Which of the three distributions encodes the linguistic model?

## Slide 561: Markov chain Monte Carlo: answer 4

Source note: `statistical-inference/markov-chain-monte-carlo.qmd`

The posterior target, defined by the likelihood and prior, encodes the linguistic model. The Metropolis--Hastings page derives the transition used here.

## Slide 562: Metropolis--Hastings sampling

Source note: `statistical-inference/metropolis-hastings.qmd`

Our next step is Metropolis--Hastings sampling.

## Slide 563: Metropolis--Hastings sampling

Source note: `statistical-inference/metropolis-hastings.qmd`

The MCMC page used a random-walk transition without yet deriving its correction. The **Metropolis--Hastings (MH) algorithm** accepts or rejects proposals so that the passage-level Student-t posterior remains stationary.

## Slide 564: Proposal and acceptance

Source note: `statistical-inference/metropolis-hastings.qmd`

At current state $\eta^{(s)}$, draw a proposal

$$
\eta'\sim q(\eta'\mid\eta^{(s)}).
$$

## Slide 565: Proposal and acceptance

Source note: `statistical-inference/metropolis-hastings.qmd`

For posterior density kernel $\widetilde f$, form

$$
r
=
\frac{
\widetilde f(\eta'\mid\mathbf y)
q(\eta^{(s)}\mid\eta')
}{
\widetilde f(\eta^{(s)}\mid\mathbf y)
q(\eta'\mid\eta^{(s)})
}.
$$

## Slide 566: Proposal and acceptance

Source note: `statistical-inference/metropolis-hastings.qmd`

Accept when $U<\min(1,r)$ for $U\sim\operatorname{Uniform}(0,1)$; otherwise retain $\eta^{(s)}$. For the symmetric normal random walk, the two $q$ terms cancel. The unknown posterior normalizer also cancels, so the log acceptance ratio is

$$
\log r
=
\log\widetilde f(\eta'\mid\mathbf y)
-
\log\widetilde f(\eta^{(s)}\mid\mathbf y).
$$

## Slide 567: Proposal and acceptance

Source note: `statistical-inference/metropolis-hastings.qmd`

Rejected current states must remain in the chain. Removing them would change the proportion of time spent in each posterior region.

## Slide 568: Fitting the passage-level Student-t model

Source note: `statistical-inference/metropolis-hastings.qmd`

The passage-level Student-$t$ fit uses the frozen seed and data-scaled proposal from the reference analysis.

## Slide 569: Fitting the passage-level Student-t model

Source note: `statistical-inference/metropolis-hastings.qmd`

This figure shows four post-warmup random-walk MH chains targeting the passage-level Student-t model.

## Slide 570: Fitting the passage-level Student-t model

Source note: `statistical-inference/metropolis-hastings.qmd`

The post-warmup acceptance rates lie between 0.340 and 0.349. Proposal scale changes efficiency: very small moves are accepted often but explore slowly, while very large moves are often rejected. A correctly formed MH ratio preserves the same target across these choices.

## Slide 571: Fitting the passage-level Student-t model

Source note: `statistical-inference/metropolis-hastings.qmd`

Acceptance is a randomized computational decision, not a significance test. It says nothing by itself about whether noun and verb reading times differ or whether the passage-level Student-t model represents participant-level variation.

## Slide 572: Metropolis--Hastings sampling: question 1

Source note: `statistical-inference/metropolis-hastings.qmd`

Why do the proposal terms cancel here?

## Slide 573: Metropolis--Hastings sampling: answer 1

Source note: `statistical-inference/metropolis-hastings.qmd`

The normal random-walk proposal is symmetric, so $q(\eta'\mid\eta)=q(\eta\mid\eta')$.

## Slide 574: Metropolis--Hastings sampling: question 2

Source note: `statistical-inference/metropolis-hastings.qmd`

Why does the posterior normalizer cancel?

## Slide 575: Metropolis--Hastings sampling: answer 2

Source note: `statistical-inference/metropolis-hastings.qmd`

The same multiplicative normalizer appears in the target density at the proposed and current states, so it cancels in their ratio.

## Slide 576: Metropolis--Hastings sampling: question 3

Source note: `statistical-inference/metropolis-hastings.qmd`

What state is saved after a rejection?

## Slide 577: Metropolis--Hastings sampling: answer 3

Source note: `statistical-inference/metropolis-hastings.qmd`

The current state is saved again after a rejection.

## Slide 578: Metropolis--Hastings sampling: question 4

Source note: `statistical-inference/metropolis-hastings.qmd`

Why can a high acceptance rate accompany inefficient exploration?

## Slide 579: Metropolis--Hastings sampling: answer 4

Source note: `statistical-inference/metropolis-hastings.qmd`

Very small proposals are often accepted but move only short distances, producing high autocorrelation and slow exploration. The HMC page replaces random-walk proposals with gradient-directed trajectories through this same target.

## Slide 580: Hamiltonian Monte Carlo

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

Our next step is Hamiltonian Monte Carlo.

## Slide 581: Hamiltonian Monte Carlo

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

Random-walk MH proposes without consulting the target's local geometry. **Hamiltonian Monte Carlo (HMC)** instead uses the gradient of the passage-level Student-t model log posterior to build a coordinated proposal in $(\mu,\log\sigma)$.

## Slide 582: Potential, kinetic, and total energy

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

Let $q$ denote unconstrained parameters and let $\rho$ be an auxiliary momentum. The potential energy is

$$
U(q)=-\log\widetilde f(q\mid\mathbf y).
$$

## Slide 583: Potential, kinetic, and total energy

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

For unit mass, draw $\rho\sim\mathcal N(0,I)$ and define

$$
K(\rho)=\frac12\rho^\mathsf T\rho,
\qquad
H(q,\rho)=U(q)+K(\rho).
$$

## Slide 584: Potential, kinetic, and total energy

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

Adding the momentum does not change the marginal posterior for $q$. It supplies a direction in which to construct a proposal.

## Slide 585: Potential, kinetic, and total energy

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

Hamilton's equations are

$$
\frac{\mathrm dq}{\mathrm dt}=\rho,
\qquad
\frac{\mathrm d\rho}{\mathrm dt}=-\nabla U(q).
$$

## Slide 586: Potential, kinetic, and total energy

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

The first changes position using momentum; the second changes momentum using the local posterior gradient.

## Slide 587: Leapfrog integration

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

For step size $\epsilon$, one leapfrog step is

$$
\rho_{t+\frac12}
=
\rho_t-\frac{\epsilon}{2}\nabla U(q_t),
$$

$$
q_{t+1}=q_t+\epsilon\rho_{t+\frac12},
$$

$$
\rho_{t+1}
=
\rho_{t+\frac12}-\frac{\epsilon}{2}\nabla U(q_{t+1}).
$$

## Slide 588: Leapfrog integration

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

The half steps make the integrator reversible and volume preserving. Numerical integration changes the Hamiltonian slightly, so HMC accepts the endpoint with

$$
\alpha
=
\min\left\{1,
\exp[H(q,\rho)-H(q^*,\rho^*)]
\right\}.
$$

## Slide 589: One trajectory through the passage-level Student-t model

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

The reference trajectory first whitens the grid posterior, then applies 12 leapfrog steps of size 0.20. Every potential and gradient evaluation still uses the observed 55-passage passage-level Student-t model.

## Slide 590: One trajectory through the passage-level Student-t model

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

A 12-step leapfrog path through the passage-level Student-t posterior. Contours come from the normalized grid; the two accent points are the trajectory endpoints.

## Slide 591: One trajectory through the passage-level Student-t model

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

The energy error is 0.000386 and the corresponding acceptance probability is 0.999614. These values assess this numerical trajectory; they are not probabilities that the linguistic model is true.

## Slide 592: Hamiltonian Monte Carlo: question 1

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

Which energy contains the posterior kernel?

## Slide 593: Hamiltonian Monte Carlo: answer 1

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

The potential energy $U(q)=-\log\widetilde f(q\mid\mathbf y)$ contains the posterior kernel.

## Slide 594: Hamiltonian Monte Carlo: question 2

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

Why is momentum temporary?

## Slide 595: Hamiltonian Monte Carlo: answer 2

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

Momentum is an auxiliary variable used to construct a proposal; integrating it out leaves the marginal posterior for $q$ unchanged.

## Slide 596: Hamiltonian Monte Carlo: question 3

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

Which two gradient evaluations enter a leapfrog step?

## Slide 597: Hamiltonian Monte Carlo: answer 3

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

A leapfrog step evaluates $\nabla U(q_t)$ before the position update and $\nabla U(q_{t+1})$ after it.

## Slide 598: Hamiltonian Monte Carlo: question 4

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

What does the final accept--reject step correct?

## Slide 599: Hamiltonian Monte Carlo: answer 4

Source note: `statistical-inference/hamiltonian-monte-carlo.qmd`

The final HMC accept--reject step corrects the small Hamiltonian error introduced by numerical leapfrog integration, preserving the target distribution. The mass-matrix page examines the whitening transformation used above.

## Slide 600: Mass matrices and posterior geometry

Source note: `statistical-inference/mass-matrix-geometry.qmd`

Now we turn to Mass matrices and posterior geometry.

## Slide 601: Mass matrices and posterior geometry

Source note: `statistical-inference/mass-matrix-geometry.qmd`

The HMC trajectory whitened the passage-level Student-t model before applying unit-mass leapfrog steps. A **mass matrix** supplies HMC with a constant scale and orientation for its momentum without changing the posterior target.

## Slide 602: General kinetic energy

Source note: `statistical-inference/mass-matrix-geometry.qmd`

For symmetric positive-definite $M$, draw

$$
\rho\sim\mathcal N(0,M)
$$

and define

$$
K(\rho)=\frac12\rho^\mathsf TM^{-1}\rho.
$$

## Slide 603: General kinetic energy

Source note: `statistical-inference/mass-matrix-geometry.qmd`

The position equation becomes

$$
\frac{\mathrm dq}{\mathrm dt}=M^{-1}\rho,
$$

and the leapfrog position update is

$$
q_{t+1}=q_t+\epsilon M^{-1}\rho_{t+\frac12}.
$$

Because the velocity is $v=M^{-1}\rho$,

$$
\operatorname{Cov}(v)
=M^{-1}MM^{-1}=M^{-1}.
$$

## Slide 604: General kinetic energy

Source note: `statistical-inference/mass-matrix-geometry.qmd`

Thus the inverse mass matrix should roughly match posterior covariance: wider posterior directions receive wider typical velocities.

## Slide 605: Geometry of the passage-level Student-t model

Source note: `statistical-inference/mass-matrix-geometry.qmd`

the calculation reconstructs the exact posterior grid and compares the observed $(\mu,\log\sigma)$ covariance with its whitening transformation.

## Slide 606: Geometry of the passage-level Student-t model

Source note: `statistical-inference/mass-matrix-geometry.qmd`

This figure shows posterior grid cells before and after posterior whitening. Point darkness represents normalized posterior mass.

## Slide 607: Geometry of the passage-level Student-t model

Source note: `statistical-inference/mass-matrix-geometry.qmd`

A unit matrix treats all directions as equally scaled and uncorrelated. A diagonal matrix supplies separate scales but no rotation. A dense matrix can also represent global linear correlation. One constant dense matrix cannot remove curvature that changes across the posterior.

## Slide 608: Geometry of the passage-level Student-t model

Source note: `statistical-inference/mass-matrix-geometry.qmd`

Stan estimates a regularized inverse mass matrix during warmup, then holds it fixed during retained sampling. Adaptation must stop because changing the transition indefinitely could change its stationary distribution. The matrix improves computation; it does not alter the 55 passage summaries or repair the passage-level Student-t model's aggregation limits.

## Slide 609: Mass matrices and posterior geometry: question 1

Source note: `statistical-inference/mass-matrix-geometry.qmd`

Which matrix is the momentum covariance?

## Slide 610: Mass matrices and posterior geometry: answer 1

Source note: `statistical-inference/mass-matrix-geometry.qmd`

The mass matrix $M$ is the covariance of momentum: $\rho\sim\mathcal N(0,M)$.

## Slide 611: Mass matrices and posterior geometry: question 2

Source note: `statistical-inference/mass-matrix-geometry.qmd`

Why does the inverse mass matrix determine velocity covariance?

## Slide 612: Mass matrices and posterior geometry: answer 2

Source note: `statistical-inference/mass-matrix-geometry.qmd`

Because $v=M^{-1}\rho$, $\operatorname{Cov}(v)=M^{-1}MM^{-1}=M^{-1}$.

## Slide 613: Mass matrices and posterior geometry: question 3

Source note: `statistical-inference/mass-matrix-geometry.qmd`

What can a dense matrix represent that a diagonal one cannot?

## Slide 614: Mass matrices and posterior geometry: answer 3

Source note: `statistical-inference/mass-matrix-geometry.qmd`

A dense matrix can represent global linear correlation and rotate the coordinate system; a diagonal matrix can only rescale axes.

## Slide 615: Mass matrices and posterior geometry: question 4

Source note: `statistical-inference/mass-matrix-geometry.qmd`

Why must adaptation end before retained sampling?

## Slide 616: Mass matrices and posterior geometry: answer 4

Source note: `statistical-inference/mass-matrix-geometry.qmd`

The retained transition must remain fixed to preserve a single stationary distribution; indefinite adaptation would keep changing the kernel. The NUTS page turns from trajectory geometry to trajectory length.

## Slide 617: The No-U-Turn Sampler

Source note: `statistical-inference/no-u-turn-sampler.qmd`

Next, we take up The No-U-Turn Sampler.

## Slide 618: The No-U-Turn Sampler

Source note: `statistical-inference/no-u-turn-sampler.qmd`

A static HMC transition requires a fixed number of leapfrog steps. The **No-U-Turn Sampler (NUTS)** chooses trajectory length during each transition. Hoffman and Gelman (2014) introduced the original algorithm; Stan uses a multinomial variant described in its reference manual.

## Slide 619: Growing and stopping a trajectory

Source note: `statistical-inference/no-u-turn-sampler.qmd`

NUTS extends an HMC path forward or backward and organizes candidate states in a balanced binary tree. Increasing tree depth by one doubles the intended path length, though a turning condition or divergence may stop it early. The tree constructs one transition; its internal states are not additional posterior draws.

## Slide 620: Growing and stopping a trajectory

Source note: `statistical-inference/no-u-turn-sampler.qmd`

Let $q^-$ and $q^+$ be the trajectory endpoints and define

$$
\Delta q=q^+-q^-.
$$

## Slide 621: Growing and stopping a trajectory

Source note: `statistical-inference/no-u-turn-sampler.qmd`

An endpoint turning check examines

$$
\Delta q^\mathsf TM^{-1}\rho^-
\qquad\text{and}\qquad
\Delta q^\mathsf TM^{-1}\rho^+.
$$

When one becomes negative, momentum at that endpoint points back across the path.

## Slide 622: Growing and stopping a trajectory

Source note: `statistical-inference/no-u-turn-sampler.qmd`

Stan also checks completed subtrees. It selects one eligible state with weights related to $\exp\{-H(q,\rho)\}$, rather than automatically taking the final endpoint.

## Slide 623: Actual passage-level Student-t model tree lengths

Source note: `statistical-inference/no-u-turn-sampler.qmd`

The production passage-level Student-t fit used four chains, 750 warmup iterations, 1,000 retained iterations, `adapt_delta = 0.90`, and `max_treedepth = 10`. the calculation imports the original 55 passage summaries and the frozen draw object produced by the exact Stan program on the next page.

## Slide 624: Actual passage-level Student-t model tree lengths

Source note: `statistical-inference/no-u-turn-sampler.qmd`

This figure shows leapfrog work in the production passage-level Student-t fit. No transition reached the maximum tree depth.

## Slide 625: Actual passage-level Student-t model tree lengths

Source note: `statistical-inference/no-u-turn-sampler.qmd`

The maximum observed tree depth is 3, and the maximum leapfrog count is 7. These are empirical properties of the production computation, not generic NUTS examples.

## Slide 626: Actual passage-level Student-t model tree lengths

Source note: `statistical-inference/no-u-turn-sampler.qmd`

NUTS chooses trajectory length within a transition. Warmup adaptation separately learns the step size and mass matrix. Increasing `max_treedepth` only permits more work; it does not repair inaccurate integration, poor geometry, or weak identification.

## Slide 627: The No-U-Turn Sampler: question 1

Source note: `statistical-inference/no-u-turn-sampler.qmd`

What doubles when tree depth increases by one?

## Slide 628: The No-U-Turn Sampler: answer 1

Source note: `statistical-inference/no-u-turn-sampler.qmd`

The intended number of leapfrog steps, and thus the path length, doubles.

## Slide 629: The No-U-Turn Sampler: question 2

Source note: `statistical-inference/no-u-turn-sampler.qmd`

What sign indicates that an endpoint has turned back?

## Slide 630: The No-U-Turn Sampler: answer 2

Source note: `statistical-inference/no-u-turn-sampler.qmd`

A negative endpoint dot product, $\Delta q^\mathsf T M^{-1}\rho^-<0$ or $\Delta q^\mathsf T M^{-1}\rho^+<0$, signals a turn back.

## Slide 631: The No-U-Turn Sampler: question 3

Source note: `statistical-inference/no-u-turn-sampler.qmd`

Why is only one state retained from a tree?

## Slide 632: The No-U-Turn Sampler: answer 3

Source note: `statistical-inference/no-u-turn-sampler.qmd`

The whole tree constructs one transition; retaining all internal states as draws would misrepresent their dependent selection mechanism.

## Slide 633: The No-U-Turn Sampler: question 4

Source note: `statistical-inference/no-u-turn-sampler.qmd`

What does repeated maximum-depth saturation diagnose?

## Slide 634: The No-U-Turn Sampler: answer 4

Source note: `statistical-inference/no-u-turn-sampler.qmd`

Repeated saturation indicates that the allowed trajectory length is truncating exploration, though it does not identify whether the cause is geometry, step size, or the depth cap. The Stan page shows the exact passage-level Student-t program and sampling call that generated these diagnostics.

## Slide 635: Implementing the passage-level Student-t model in Stan

Source note: `statistical-inference/stan.qmd`

Next, we take up Implementing the passage-level Student-t model in Stan.

## Slide 636: Implementing the passage-level Student-t model in Stan

Source note: `statistical-inference/stan.qmd`

Stan samples a posterior after the analyst declares data, parameters, and density contributions. The passage-level Student-t program below corresponds exactly to the robust model introduced on the nonconjugate-posterior page.

## Slide 637: The complete program

Source note: `statistical-inference/stan.qmd`

The data block contains the 55 observed passage contrasts and the empirically calibrated prior scales. The parameters block declares the unknown location and positive scale. In the model block, each tilde statement adds a log-density contribution to Stan's `target`; it does not simulate a value.

## Slide 638: The complete program

Source note: `statistical-inference/stan.qmd`

The half-normal prior is represented by the lower bound on `sigma` together with a zero-centered normal density. Stan transforms this constrained parameter internally and applies the required Jacobian on its unconstrained sampling scale.

## Slide 639: Fitting the exact model

Source note: `statistical-inference/stan.qmd`

The reference run uses four data-scaled initial values constructed from the posterior grid covariance shown on the mass-matrix page. the calculation reconstructs those values from the observed Provo contrasts rather than relying on an undeclared helper.

## Slide 640: Fitting the exact model

Source note: `statistical-inference/stan.qmd`

The sampling call is then fully specified by the observed data, the program, and these initial values.

## Slide 641: Fitting the exact model

Source note: `statistical-inference/stan.qmd`

The evaluated page reads the frozen draw object from that exact run. The cache key includes the Provo checksum, Stan-program checksum, CmdStan version, algorithm settings, and initialization specification, so changed inputs cannot silently reuse these draws.

## Slide 642: Fitting the exact model

Source note: `statistical-inference/stan.qmd`

The fitted mean of $\mu$ is 0.009518, and the geometric-scale ratio has mean 1.009588. These are passage-level Student-t model summaries, not participant-level duration effects.

## Slide 643: Factorization and adequacy

Source note: `statistical-inference/stan.qmd`

The vectorized likelihood represents

$$
\sum_{j=1}^{55}\log t_4(y_j\mid\mu,\sigma).
$$

## Slide 644: Factorization and adequacy

Source note: `statistical-inference/stan.qmd`

Concise code does not make passages a probability sample or recover reader-level measurements. Stan can correctly sample the declared posterior even when the declared model is scientifically inadequate. Computation, prior implications, posterior prediction, and the correspondence between rows and modeled units require separate checks.

## Slide 645: Implementing the passage-level Student-t model in Stan: question 1

Source note: `statistical-inference/stan.qmd`

Which objects belong in the data block?

## Slide 646: Implementing the passage-level Student-t model in Stan: answer 1

Source note: `statistical-inference/stan.qmd`

Observed quantities and fixed constants belong in `data`: here $N$, `y`, the two prior scales, and $\nu$.

## Slide 647: Implementing the passage-level Student-t model in Stan: question 2

Source note: `statistical-inference/stan.qmd`

How do the positivity constraint and half-normal prior differ?

## Slide 648: Implementing the passage-level Student-t model in Stan: answer 2

Source note: `statistical-inference/stan.qmd`

The lower bound defines the parameter's support and transformation; the zero-centered normal density supplies the half-normal prior shape on that support.

## Slide 649: Implementing the passage-level Student-t model in Stan: question 3

Source note: `statistical-inference/stan.qmd`

What do tilde statements add to `target`?

## Slide 650: Implementing the passage-level Student-t model in Stan: answer 3

Source note: `statistical-inference/stan.qmd`

Each tilde statement adds the corresponding log-density or log-mass contribution, up to constants, to `target`.

## Slide 651: Implementing the passage-level Student-t model in Stan: question 4

Source note: `statistical-inference/stan.qmd`

Why does successful sampling not validate the aggregation scheme?

## Slide 652: Implementing the passage-level Student-t model in Stan: answer 4

Source note: `statistical-inference/stan.qmd`

Stan can sample the declared passage-level posterior correctly even if aggregation discarded readers or the likelihood poorly represents the scientific design. The trace-plot page begins the diagnostic sequence using these production draws.

## Slide 653: Reading trace and rank plots

Source note: `statistical-inference/checking-markov-chains.qmd`

The next topic is Reading trace and rank plots.

## Slide 654: Reading trace and rank plots

Source note: `statistical-inference/checking-markov-chains.qmd`

The production passage-level Student-t fit retains four independently initialized NUTS chains. A **trace plot** places iteration on the horizontal axis and a sampled quantity on the vertical axis. A **rank plot** divides the pooled ranks into bins and compares how often each chain occupies them.

## Slide 655: Production traces

Source note: `statistical-inference/checking-markov-chains.qmd`

The diagnostic draws come from the production passage-level Student-$t$ fit, retain chain identity, and exclude warmup.

## Slide 656: Production traces

Source note: `statistical-inference/checking-markov-chains.qmd`

This figure shows four post-warmup NUTS traces from the production passage-level Student-t fit.

## Slide 657: Production traces

Source note: `statistical-inference/checking-markov-chains.qmd`

A useful trace fluctuates around a stable location, overlaps across chains, and continues to move. The passage-level Student-t model traces show these properties. They do not prove that the chains found every posterior region or that the model fits the passage summaries.

## Slide 658: Rank histograms

Source note: `statistical-inference/checking-markov-chains.qmd`

Chain identity should not systematically predict pooled rank. the calculation computes 20 bins for each parameter.

## Slide 659: Rank histograms

Source note: `statistical-inference/checking-markov-chains.qmd`

This figure shows pooled-rank histograms for the production chains for the passage-level Student-t model.

## Slide 660: Rank histograms

Source note: `statistical-inference/checking-markov-chains.qmd`

Persistent chain separation would suggest that initialization still predicts the sampled value. Drift would suggest that the finite saved sequence changes with iteration. Long nearly constant stretches would show inefficient movement. These are computational warnings, not model checks.

## Slide 661: Rank histograms

Source note: `statistical-inference/checking-markov-chains.qmd`

Warmup is not an arbitrary deletion of inconvenient draws. Stan uses it to adapt the step size and mass matrix, then samples with a fixed transition. Removing part of a problematic saved trace until it looks stable is not a repair.

## Slide 662: Reading trace and rank plots: question 1

Source note: `statistical-inference/checking-markov-chains.qmd`

What does persistent chain separation show directly?

## Slide 663: Reading trace and rank plots: answer 1

Source note: `statistical-inference/checking-markov-chains.qmd`

Persistent chain separation shows that chain identity or initialization continues to predict sampled values, a direct sign of incomplete cross-chain mixing.

## Slide 664: Reading trace and rank plots: question 2

Source note: `statistical-inference/checking-markov-chains.qmd`

What additional information does a rank plot provide?

## Slide 665: Reading trace and rank plots: answer 2

Source note: `statistical-inference/checking-markov-chains.qmd`

A rank plot shows whether each chain occupies the pooled distribution's ranks similarly, revealing location, scale, or tail differences that traces can obscure.

## Slide 666: Reading trace and rank plots: question 3

Source note: `statistical-inference/checking-markov-chains.qmd`

Why can overlapping traces still miss a posterior region?

## Slide 667: Reading trace and rank plots: answer 3

Source note: `statistical-inference/checking-markov-chains.qmd`

All chains can overlap within the same incomplete region if none reaches another posterior mode or tail.

## Slide 668: Reading trace and rank plots: question 4

Source note: `statistical-inference/checking-markov-chains.qmd`

Which diagnostic asks whether the passage-level Student-t model reproduces passage-level data features?

## Slide 669: Reading trace and rank plots: answer 4

Source note: `statistical-inference/checking-markov-chains.qmd`

A posterior predictive check asks whether the passage-level Student-t model reproduces selected passage-level data features. The $\widehat R$ page summarizes cross-chain agreement numerically.

## Slide 670: Cross-chain agreement

Source note: `statistical-inference/rhat.qmd`

Next, we take up Cross-chain agreement.

## Slide 671: Cross-chain agreement

Source note: `statistical-inference/rhat.qmd`

The trace and rank plots compare chains for the passage-level Student-t model visually. The **$\widehat R$ statistic** compares between-chain variation with within-chain variation: values near one are consistent with chain agreement, while larger values indicate persistent disagreement.

## Slide 672: The basic variance ratio

Source note: `statistical-inference/rhat.qmd`

For $M$ chains with $N$ draws each, let $\overline\mu_m$ and $s_m^2$ be the mean and variance in chain $m$. The average within-chain variance is

$$
W=\frac1M\sum_{m=1}^Ms_m^2.
$$

## Slide 673: The basic variance ratio

Source note: `statistical-inference/rhat.qmd`

The scaled between-chain variance is

$$
B=N\operatorname{Var}[\overline\mu_1,\ldots,\overline\mu_M].
$$

## Slide 674: The basic variance ratio

Source note: `statistical-inference/rhat.qmd`

Combining them gives

$$
\widehat V=\frac{N-1}{N}W+\frac1NB,
\qquad
\widehat R=\sqrt{\frac{\widehat V}{W}}.
$$

## Slide 675: Calculating $\widehat R$ for the passage-level Student-t model

Source note: `statistical-inference/rhat.qmd`

The textbook calculation gives $\widehat R=$ 0.999615 for $\mu$. The modern rank-normalized split values for both parameters of the passage-level Student-t model are at most 1.0001.

## Slide 676: Modern refinements

Source note: `statistical-inference/rhat.qmd`

Splitting each chain into early and late halves makes within-chain drift visible as disagreement among sequences. Rank normalization improves behavior for skewed or heavy-tailed draws. Folding replaces each value with its absolute distance from the pooled median, making the diagnostic sensitive to chains with similar centers but different spreads. Current software reports the larger rank-normalized split and folded values, following Vehtari et al. (2021).

## Slide 677: Modern refinements

Source note: `statistical-inference/rhat.qmd`

A value below 1.01 is an operational threshold, not a convergence theorem. Chains can agree in the same incomplete region, and $\widehat R$ does not measure posterior magnitude or model adequacy. It is also quantity specific: derived quantities and scale parameters require their own checks.

## Slide 678: Cross-chain agreement: question 1

Source note: `statistical-inference/rhat.qmd`

What makes $B$ large?

## Slide 679: Cross-chain agreement: answer 1

Source note: `statistical-inference/rhat.qmd`

Because $B=N\operatorname{Var}[\overline\mu_1,\ldots,\overline\mu_M]$, large dispersion among chain means makes $B$ large, with that dispersion scaled by the common chain length $N$.

## Slide 680: Cross-chain agreement: question 2

Source note: `statistical-inference/rhat.qmd`

Why are chains split before the modern calculation?

## Slide 681: Cross-chain agreement: answer 2

Source note: `statistical-inference/rhat.qmd`

Splitting turns early-versus-late drift within an original chain into disagreement between separate sequences.

## Slide 682: Cross-chain agreement: question 3

Source note: `statistical-inference/rhat.qmd`

What failure can folding detect?

## Slide 683: Cross-chain agreement: answer 3

Source note: `statistical-inference/rhat.qmd`

Folding can detect chains with similar centers but different spreads or tail behavior.

## Slide 684: Cross-chain agreement: question 4

Source note: `statistical-inference/rhat.qmd`

What does $\widehat R$ near one fail to establish?

## Slide 685: Cross-chain agreement: answer 4

Source note: `statistical-inference/rhat.qmd`

$\widehat R$ near one does not establish that every posterior region was explored, that ESS is adequate, or that the linguistic model fits the data. The autocorrelation page turns from cross-chain agreement to within-chain dependence.

## Slide 686: Autocorrelation in a Markov chain

Source note: `statistical-inference/autocorrelation.qmd`

Our next step is Autocorrelation in a Markov chain.

## Slide 687: Autocorrelation in a Markov chain

Source note: `statistical-inference/autocorrelation.qmd`

The chains for the passage-level Student-t model agree across initializations, but adjacent draws remain dependent. **Autocorrelation** measures the association between a saved sequence and a shifted copy of itself.

## Slide 688: Autocorrelation in a Markov chain

Source note: `statistical-inference/autocorrelation.qmd`

For a stationary scalar sequence, the autocorrelation at lag $t$ is

$$
\rho_t
=
\operatorname{Corr}(\Theta_s,\Theta_{s+t}).
$$

## Slide 689: Autocorrelation in a Markov chain

Source note: `statistical-inference/autocorrelation.qmd`

Lag one compares adjacent draws; lag ten compares draws ten transitions apart. A chain of 1,000 draws supplies 999 lag-one pairs and 990 lag-ten pairs.

## Slide 690: The production passage-level Student-t model autocorrelation functions

Source note: `statistical-inference/autocorrelation.qmd`

This figure shows within-chain autocorrelation for the production draws from the passage-level Student-t posterior.

## Slide 691: The production passage-level Student-t model autocorrelation functions

Source note: `statistical-inference/autocorrelation.qmd`

Rapid decay suggests that dependence weakens over a small number of transitions. Slow decay means that information about one state persists across later states. High autocorrelation need not imply the wrong stationary distribution, but it reduces finite-run precision.

## Slide 692: The production passage-level Student-t model autocorrelation functions

Source note: `statistical-inference/autocorrelation.qmd`

Negative autocorrelation can make alternating values offset one another and improve precision for some averages. Thus the complete sequence matters, not only lag one. Thinning may make the retained sequence look less correlated, but it discards information and creates none.

## Slide 693: The production passage-level Student-t model autocorrelation functions

Source note: `statistical-inference/autocorrelation.qmd`

Autocorrelation diagnoses the numerical sequence. It does not describe dependence among readers, word positions, or passages in the underlying Provo study.

## Slide 694: Autocorrelation in a Markov chain: question 1

Source note: `statistical-inference/autocorrelation.qmd`

How many lag-25 pairs occur in one 1,000-draw chain?

## Slide 695: Autocorrelation in a Markov chain: answer 1

Source note: `statistical-inference/autocorrelation.qmd`

There are $1000-25=975$ lag-25 pairs.

## Slide 696: Autocorrelation in a Markov chain: question 2

Source note: `statistical-inference/autocorrelation.qmd`

What does slow ACF decay imply about finite-run information?

## Slide 697: Autocorrelation in a Markov chain: answer 2

Source note: `statistical-inference/autocorrelation.qmd`

Slow decay means that many saved states carry overlapping information, reducing finite-run precision and ESS.

## Slide 698: Autocorrelation in a Markov chain: question 3

Source note: `statistical-inference/autocorrelation.qmd`

Why can a correct chain have positive autocorrelation?

## Slide 699: Autocorrelation in a Markov chain: answer 3

Source note: `statistical-inference/autocorrelation.qmd`

Stationarity determines the marginal target, not independence; a valid transition can preserve the target while moving locally between correlated states.

## Slide 700: Autocorrelation in a Markov chain: question 4

Source note: `statistical-inference/autocorrelation.qmd`

Why does thinning not create information?

## Slide 701: Autocorrelation in a Markov chain: answer 4

Source note: `statistical-inference/autocorrelation.qmd`

Thinning discards saved states. It may lower correlation among retained neighbors, but it cannot add information absent from the original chain. The effective-sample-size page translates this dependence into an information-equivalent draw count.

## Slide 702: Effective sample size

Source note: `statistical-inference/effective-sample-size.qmd`

The next topic is Effective sample size.

## Slide 703: Effective sample size

Source note: `statistical-inference/effective-sample-size.qmd`

Dependent draws contain less information about many posterior summaries than the same number of independent target draws. **Effective sample size** (ESS) approximates the independent-draw count that would give comparable Monte Carlo precision for a particular quantity.

## Slide 704: From autocorrelation to ESS

Source note: `statistical-inference/effective-sample-size.qmd`

For a stationary scalar sequence of $S$ draws,

$$
\operatorname{ESS}
\approx
\frac{S}{1+2\sum_{t=1}^{\infty}\rho_t}.
$$

## Slide 705: From autocorrelation to ESS

Source note: `statistical-inference/effective-sample-size.qmd`

The denominator is the integrated autocorrelation time. Positive dependence increases it and reduces ESS; negative dependence can make ESS exceed the raw draw count for some summaries.

## Slide 706: From autocorrelation to ESS

Source note: `statistical-inference/effective-sample-size.qmd`

For a function $g(\Theta)$ with posterior standard deviation $\sigma_g$,

$$
\operatorname{MCSE}
\approx
\frac{\sigma_g}{\sqrt{\operatorname{ESS}}}.
$$

## Slide 707: From autocorrelation to ESS

Source note: `statistical-inference/effective-sample-size.qmd`

This is uncertainty in a numerical estimate of a posterior mean, not posterior uncertainty about a linguistic quantity.

## Slide 708: passage-level Student-t model effective sample sizes

Source note: `statistical-inference/effective-sample-size.qmd`

the calculation computes a textbook positive-sequence estimate for chain one's $\mu$ draws, then obtains modern four-chain bulk and tail ESS from `posterior`.

## Slide 709: passage-level Student-t model effective sample sizes

Source note: `statistical-inference/effective-sample-size.qmd`

The one-chain textbook value is 665. The modern bulk ESS for $\mu$ is 2867, while its tail ESS is 2355. These are different estimators applied to different collections of draws, so their difference is not a disagreement.

## Slide 710: passage-level Student-t model effective sample sizes

Source note: `statistical-inference/effective-sample-size.qmd`

The posterior standard deviation of $\mu$ is 0.007075, whereas the estimated MCSE of its posterior mean is 0.000132. This separation is the point of ESS.

## Slide 711: passage-level Student-t model effective sample sizes

Source note: `statistical-inference/effective-sample-size.qmd`

Bulk ESS uses rank-normalized draws and is useful for location summaries. Tail ESS targets information relevant to the 5% and 95% quantiles. A chain can move adequately through the center but rarely reach a tail, so the appropriate diagnostic depends on the reported summary.

## Slide 712: passage-level Student-t model effective sample sizes

Source note: `statistical-inference/effective-sample-size.qmd`

ESS counts simulation information, not passages, word positions, or readers. Running longer can increase ESS and reduce MCSE. It cannot add evidence to the passage-level Student-t model or narrow its posterior target.

## Slide 713: Effective sample size: question 1

Source note: `statistical-inference/effective-sample-size.qmd`

Why does positive autocorrelation tend to reduce ESS?

## Slide 714: Effective sample size: answer 1

Source note: `statistical-inference/effective-sample-size.qmd`

Positive autocorrelations increase the integrated autocorrelation time in the denominator of ESS.

## Slide 715: Effective sample size: question 2

Source note: `statistical-inference/effective-sample-size.qmd`

Why can bulk and tail ESS differ?

## Slide 716: Effective sample size: answer 2

Source note: `statistical-inference/effective-sample-size.qmd`

Movement can be efficient near the posterior center but slow in the tails, and the two diagnostics target different summaries of the draws.

## Slide 717: Effective sample size: question 3

Source note: `statistical-inference/effective-sample-size.qmd`

Which quantity changes when the sampler runs longer: posterior spread or MCSE?

## Slide 718: Effective sample size: answer 3

Source note: `statistical-inference/effective-sample-size.qmd`

MCSE can decrease as the run grows; posterior spread remains a property of the fixed posterior target.

## Slide 719: Effective sample size: question 4

Source note: `statistical-inference/effective-sample-size.qmd`

Why is passage-level Student-t model ESS not a linguistic sample size?

## Slide 720: Effective sample size: answer 4

Source note: `statistical-inference/effective-sample-size.qmd`

passage-level Student-t model ESS counts information in simulated posterior draws, not Provo passages, word positions, readers, or any other linguistic unit.

## Slide 721: Divergent Hamiltonian transitions

Source note: `statistical-inference/divergent-transitions.qmd`

Our next step is Divergent Hamiltonian transitions.

## Slide 722: Divergent Hamiltonian transitions

Source note: `statistical-inference/divergent-transitions.qmd`

A **divergent transition** occurs when numerical integration error exceeds Stan's threshold. It indicates that a trajectory may not have followed the target geometry reliably in one region. We demonstrate the warning with a deliberately coarse computation on the same passage-level Student-t model used throughout this sequence.

## Slide 723: Energy error and geometry

Source note: `statistical-inference/divergent-transitions.qmd`

HMC approximately preserves

$$
H(q,\rho)
=
-\log\widetilde f(q\mid\mathbf y)
+\frac12\rho^\mathsf TM^{-1}\rho.
$$

## Slide 724: Energy error and geometry

Source note: `statistical-inference/divergent-transitions.qmd`

Rapidly changing curvature can make one step size inaccurate in a narrow region even if it works elsewhere. In a hierarchical model, for instance,

$$
u_j\sim\mathcal N(0,\tau^2)
$$

can produce a narrow region when $\tau$ is near zero and a wider region when $\tau$ is large.

## Slide 725: Energy error and geometry

Source note: `statistical-inference/divergent-transitions.qmd`

A noncentered representation writes

$$
z_j\sim\mathcal N(0,1),
\qquad
u_j=\tau z_j.
$$

## Slide 726: Energy error and geometry

Source note: `statistical-inference/divergent-transitions.qmd`

The two forms imply the same conditional distribution for $u_j$ at fixed $\tau$, but expose different numerical coordinates.

## Slide 727: Production and stress computations

Source note: `statistical-inference/divergent-transitions.qmd`

The production passage-level Student-t fit uses adapted NUTS. A deliberately coarse run uses the same complete passage set, likelihood, priors, and data-derived initial region, but disables warmup and adaptation, uses a unit metric, fixes step size at 0.03, and caps tree depth at 7. This run demonstrates a numerical warning; it is not a second inferential fit and is not evidence of a defect in the production model.

## Slide 728: Production and stress computations

Source note: `statistical-inference/divergent-transitions.qmd`

The coarse, unadapted stress computation. Accent points mark divergent transitions; this run is not the production fit.

## Slide 729: Production and stress computations

Source note: `statistical-inference/divergent-transitions.qmd`

The production fit has 0 divergences. The intentionally coarse stress computation has 125 among 1000 transitions. The contrast shows what the diagnostic looks like when integration is degraded while the data and posterior remain fixed.

## Slide 730: Responding to a real divergence

Source note: `statistical-inference/divergent-transitions.qmd`

First locate the marked draws in theoretically relevant parameter pairs. Then inspect parameter identification, predictor scales, and parameterization. Increasing `adapt_delta` usually reduces step size and may repair modest integration error; reparameterization may be needed when curvature changes substantially. Refit and recheck all diagnostics.

## Slide 731: Responding to a real divergence

Source note: `statistical-inference/divergent-transitions.qmd`

Filtering divergent iterations is never a repair. And a run with no divergence removes only this warning: chains may still disagree, have low ESS, or target a model that predicts the linguistic data poorly.

## Slide 732: Divergent Hamiltonian transitions: question 1

Source note: `statistical-inference/divergent-transitions.qmd`

Which numerical quantity fails to remain approximately stable during a divergence?

## Slide 733: Divergent Hamiltonian transitions: answer 1

Source note: `statistical-inference/divergent-transitions.qmd`

The Hamiltonian, or total energy $H(q,\rho)$, fails to remain approximately stable.

## Slide 734: Divergent Hamiltonian transitions: question 2

Source note: `statistical-inference/divergent-transitions.qmd`

Why is the stress run not evidence of a defective passage-level Student-t model?

## Slide 735: Divergent Hamiltonian transitions: answer 2

Source note: `statistical-inference/divergent-transitions.qmd`

The run deliberately disables adaptation and uses a coarse unit metric while holding the data and posterior fixed; it demonstrates numerical failure, not a defective model.

## Slide 736: Divergent Hamiltonian transitions: question 3

Source note: `statistical-inference/divergent-transitions.qmd`

Why might localized divergences matter even when their percentage is small?

## Slide 737: Divergent Hamiltonian transitions: answer 3

Source note: `statistical-inference/divergent-transitions.qmd`

A small rate can be concentrated in a narrow, scientifically important posterior region, biasing summaries that depend on that region.

## Slide 738: Divergent Hamiltonian transitions: question 4

Source note: `statistical-inference/divergent-transitions.qmd`

When might reparameterization be more useful than only increasing `adapt_delta`?

## Slide 739: Divergent Hamiltonian transitions: answer 4

Source note: `statistical-inference/divergent-transitions.qmd`

Reparameterization is more useful when posterior curvature changes sharply, as in funnel-like geometry that no single smaller step size handles efficiently. The pairs-plot page separates production geometry from this stress computation.

## Slide 740: Reading pairs plots of posterior draws

Source note: `statistical-inference/parameter-pair-plots.qmd`

Our next step is Reading pairs plots of posterior draws.

## Slide 741: Reading pairs plots of posterior draws

Source note: `statistical-inference/parameter-pair-plots.qmd`

A trace plot shows one parameter across iterations. A **pairs plot** shows joint draws and can reveal dependence or locate a computational warning in parameter space. The plot must distinguish inference from a diagnostic manipulation.

## Slide 742: Production passage-level Student-t model geometry

Source note: `statistical-inference/parameter-pair-plots.qmd`

This figure shows joint mu and sigma draws from the production adapted-NUTS fit.

## Slide 743: Production passage-level Student-t model geometry

Source note: `statistical-inference/parameter-pair-plots.qmd`

A roughly circular cloud suggests weak linear dependence for this parameter pair, while a diagonal ellipse suggests that combinations along one direction remain plausible. Curvature or changing width may be more difficult for a constant mass matrix. Shape alone does not identify its cause.

## Slide 744: Locating the stress warning

Source note: `statistical-inference/parameter-pair-plots.qmd`

Joint draws from the coarse, unadapted stress computation. Divergent transitions are marked in the accent color; this is not the production posterior display.

## Slide 745: Locating the stress warning

Source note: `statistical-inference/parameter-pair-plots.qmd`

Marked transitions locate where the intentionally degraded integrator failed. They do not constitute posterior evidence about $\mu$ or $\sigma$, and they should not be combined with production draws.

## Slide 746: Locating the stress warning

Source note: `statistical-inference/parameter-pair-plots.qmd`

A matrix of every parameter pair quickly becomes unreadable. Select pairs implicated by the model structure or another diagnostic. A compact cloud establishes neither causal relations among parameters nor model fit; both claims require additional assumptions or checks.

## Slide 747: Reading pairs plots of posterior draws: question 1

Source note: `statistical-inference/parameter-pair-plots.qmd`

What does a diagonal posterior cloud show directly?

## Slide 748: Reading pairs plots of posterior draws: answer 1

Source note: `statistical-inference/parameter-pair-plots.qmd`

A diagonal posterior cloud shows linear posterior association: plausible parameter combinations lie along a common direction.

## Slide 749: Reading pairs plots of posterior draws: question 2

Source note: `statistical-inference/parameter-pair-plots.qmd`

What can a divergence overlay locate?

## Slide 750: Reading pairs plots of posterior draws: answer 2

Source note: `statistical-inference/parameter-pair-plots.qmd`

A divergence overlay locates the part of joint parameter space where numerical integration failed.

## Slide 751: Reading pairs plots of posterior draws: question 3

Source note: `statistical-inference/parameter-pair-plots.qmd`

Why are the production and stress displays separated?

## Slide 752: Reading pairs plots of posterior draws: answer 3

Source note: `statistical-inference/parameter-pair-plots.qmd`

The production draws represent inference, while the coarse stress draws are a deliberately degraded diagnostic manipulation and must not be pooled with them.

## Slide 753: Reading pairs plots of posterior draws: question 4

Source note: `statistical-inference/parameter-pair-plots.qmd`

Why does a compact pairs plot not establish model adequacy?

## Slide 754: Reading pairs plots of posterior draws: answer 4

Source note: `statistical-inference/parameter-pair-plots.qmd`

A compact pairs plot shows only selected joint parameter geometry; it does not compare replicated linguistic data with observations. The generated-quantities page turns from sampler diagnostics to derived posterior outputs.

## Slide 755: Generating derived quantities in Stan

Source note: `statistical-inference/generated-quantities.qmd`

Now we turn to Generating derived quantities in Stan.

## Slide 756: Generating derived quantities in Stan

Source note: `statistical-inference/generated-quantities.qmd`

Stan's **generated quantities block** runs after each retained parameter draw. It can transform a joint draw, simulate replicated responses, and evaluate pointwise log likelihoods without changing the posterior target.

## Slide 757: Three passage-level Student-t model outputs

Source note: `statistical-inference/generated-quantities.qmd`

The exact Stan program returns a transformed ratio, replicated responses, and pointwise log likelihoods.

## Slide 758: Three passage-level Student-t model outputs

Source note: `statistical-inference/generated-quantities.qmd`

The transformed quantity is

$$
R=\exp(\mu).
$$

## Slide 759: Three passage-level Student-t model outputs

Source note: `statistical-inference/generated-quantities.qmd`

Within draw $s$, $r^{(s)}=\exp(\mu^{(s)})$. It is a central geometric-scale noun-to-verb ratio for the passage contrast, not a participant-level raw-duration ratio.

## Slide 760: Three passage-level Student-t model outputs

Source note: `statistical-inference/generated-quantities.qmd`

For passage $j$, the replication and log-likelihood contribution are

$$
Y_j^{\mathrm{rep},(s)}
\sim t_4(\mu^{(s)},\sigma^{(s)}),
$$

$$
\ell_j^{(s)}
=
\log t_4(y_j\mid\mu^{(s)},\sigma^{(s)}).
$$

## Slide 761: Three passage-level Student-t model outputs

Source note: `statistical-inference/generated-quantities.qmd`

The `_rng` function simulates; the `_lpdf` function evaluates the observed response.

## Slide 762: Inspecting actual generated quantities

Source note: `statistical-inference/generated-quantities.qmd`

Every retained draw has one replicated value and one log-likelihood contribution for each of the 55 passages. Preserving this index is necessary for passage-level predictive checks and pointwise model-comparison calculations.

## Slide 763: Inspecting actual generated quantities

Source note: `statistical-inference/generated-quantities.qmd`

This figure shows observed passage contrasts and one evenly spaced subset of complete posterior-replicated datasets.

## Slide 764: Inspecting actual generated quantities

Source note: `statistical-inference/generated-quantities.qmd`

Assignments in generated quantities cannot contribute to Stan's `target`. Moving a prior or likelihood there would remove it from inference. And grouping pointwise log likelihoods after fitting does not automatically change a passage-level prediction task into leave-one-reader-out evaluation; the reader rows are unavailable in this teaching table.

## Slide 765: Generating derived quantities in Stan: question 1

Source note: `statistical-inference/generated-quantities.qmd`

Which line simulates a replicated passage contrast?

## Slide 766: Generating derived quantities in Stan: answer 1

Source note: `statistical-inference/generated-quantities.qmd`

`y_rep[n] = student_t_rng(nu, mu, sigma);` simulates a replicated passage contrast.

## Slide 767: Generating derived quantities in Stan: question 2

Source note: `statistical-inference/generated-quantities.qmd`

Which line evaluates an observed contrast?

## Slide 768: Generating derived quantities in Stan: answer 2

Source note: `statistical-inference/generated-quantities.qmd`

`log_lik[n] = student_t_lpdf(y[n] | nu, mu, sigma);` evaluates the observed passage contrast.

## Slide 769: Generating derived quantities in Stan: question 3

Source note: `statistical-inference/generated-quantities.qmd`

Why is $\exp(\mu)$ computed within every joint draw?

## Slide 770: Generating derived quantities in Stan: answer 3

Source note: `statistical-inference/generated-quantities.qmd`

Computing it within each draw preserves its joint uncertainty with all other parameters before the transformed quantity is summarized.

## Slide 771: Generating derived quantities in Stan: question 4

Source note: `statistical-inference/generated-quantities.qmd`

Can generated quantities repair a missing likelihood term?

## Slide 772: Generating derived quantities in Stan: answer 4

Source note: `statistical-inference/generated-quantities.qmd`

No. Generated quantities run after sampling and cannot add a prior or likelihood contribution to `target`. The posterior-predictive-check page compares these replicated passage data with the observations.

## Slide 773: Posterior predictive checks

Source note: `statistical-inference/posterior-predictive-checks.qmd`

Now we turn to Posterior predictive checks.

## Slide 774: Posterior predictive checks

Source note: `statistical-inference/posterior-predictive-checks.qmd`

A **posterior predictive check** compares an observed feature with the same feature in data generated from the fitted model. It criticizes one implication of the passage-level Student-t model rather than assigning a global fit label.

## Slide 775: Replication under the fitted passage-level Student-t model

Source note: `statistical-inference/posterior-predictive-checks.qmd`

For posterior draw $s$,

$$
(\mu^{(s)},\sigma^{(s)})
\sim f(\mu,\sigma\mid\mathbf y),
$$

then

$$
Y_j^{\mathrm{rep},(s)}
\sim t_4(\mu^{(s)},\sigma^{(s)}),
\qquad j=1,\ldots,55.
$$

## Slide 776: Replication under the fitted passage-level Student-t model

Source note: `statistical-inference/posterior-predictive-checks.qmd`

Each replicate preserves the observed number of passage summaries. It does not regenerate reader trials or make the passages a probability sample of English texts.

## Slide 777: Raw data and fitted predictive density

Source note: `statistical-inference/posterior-predictive-checks.qmd`

The next figure keeps the observed histogram and rug visible. The line is the posterior-median predictive density, and the band is its central 90% interval across an evenly spaced subset of posterior draws.

## Slide 778: Raw data and fitted predictive density

Source note: `statistical-inference/posterior-predictive-checks.qmd`

This figure shows observed 55-passage contrasts with the fitted posterior-predictive density and its central 90% pointwise band.

## Slide 779: Four targeted discrepancies

Source note: `statistical-inference/posterior-predictive-checks.qmd`

A discrepancy $T(\mathbf y)$ must be applied identically to observed and replicated data. Here we inspect mean, standard deviation, maximum absolute contrast, and proportion positive. The last two are not direct sufficient statistics for the fitted location and scale, so they can expose tail or sign-pattern failures.

## Slide 780: Four targeted discrepancies

Source note: `statistical-inference/posterior-predictive-checks.qmd`

Posterior-predictive distributions for four passage-level discrepancies. Each accent line is the corresponding observed value.

## Slide 781: Four targeted discrepancies

Source note: `statistical-inference/posterior-predictive-checks.qmd`

All four observed values lie within their central 95% predictive intervals. This result says only that the fitted passage-level Student-t model does not miss these four passage-level features grossly. It does not validate the aggregation scheme, the empirically calibrated priors, participant-level generalization, or unexamined discrepancies.

## Slide 782: Posterior predictive checks: question 1

Source note: `statistical-inference/posterior-predictive-checks.qmd`

Which quantities must use the same discrepancy function $T$?

## Slide 783: Posterior predictive checks: answer 1

Source note: `statistical-inference/posterior-predictive-checks.qmd`

The observed data $T(\mathbf y)$ and every replicated dataset $T(\mathbf y^{\mathrm{rep}})$ must use the same discrepancy function.

## Slide 784: Posterior predictive checks: question 2

Source note: `statistical-inference/posterior-predictive-checks.qmd`

Why are maximum absolute contrast and sign proportion useful here?

## Slide 785: Posterior predictive checks: answer 2

Source note: `statistical-inference/posterior-predictive-checks.qmd`

Maximum absolute contrast and sign proportion probe tail magnitude and sign balance, features not fixed directly by matching the model's location and scale.

## Slide 786: Posterior predictive checks: question 3

Source note: `statistical-inference/posterior-predictive-checks.qmd`

What does a successful check license us to say?

## Slide 787: Posterior predictive checks: answer 3

Source note: `statistical-inference/posterior-predictive-checks.qmd`

A successful posterior predictive check licenses only the claim that the fitted passage-level Student-t model does not grossly miss the checked passage-level features.

## Slide 788: Posterior predictive checks: question 4

Source note: `statistical-inference/posterior-predictive-checks.qmd`

Which limitation cannot be checked from the passage-summary table?

## Slide 789: Posterior predictive checks: answer 4

Source note: `statistical-inference/posterior-predictive-checks.qmd`

The table cannot check participant-level variation, because reader trials and identifiers were removed before the passage summaries were formed.
