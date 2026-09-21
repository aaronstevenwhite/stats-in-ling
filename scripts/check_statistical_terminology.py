#!/usr/bin/env python3
"""Check statistical terminology and first-definition authority links.

The substantive chapter order comes from the Quarto sidebar. Every bold term in
that sequence must either have an explicit authority in this file or be listed as
ordinary emphasis. The first occurrence of every term with an authority must be
an external link to that authority. Run with ``--fix`` to add missing links.
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import defaultdict
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]

NICENBOIM_1 = "https://bruno.nicenboim.me/bayescogsci/ch-intro.html"
NICENBOIM_2 = "https://bruno.nicenboim.me/bayescogsci/ch-introBDA.html"
NICENBOIM_4 = "https://bruno.nicenboim.me/bayescogsci/ch-reg.html"
NICENBOIM_5 = "https://bruno.nicenboim.me/bayescogsci/ch-hierarchical.html"
NICENBOIM_8 = "https://bruno.nicenboim.me/bayescogsci/ch-introstan.html"
NICENBOIM_9 = "https://bruno.nicenboim.me/bayescogsci/ch-complexstan.html"
NICENBOIM_10 = "https://bruno.nicenboim.me/bayescogsci/ch-custom.html"
NICENBOIM_12 = "https://bruno.nicenboim.me/bayescogsci/ch-comparison.html"
NICENBOIM_14 = "https://bruno.nicenboim.me/bayescogsci/ch-cv.html"
NICENBOIM_WORKFLOW = "https://bruno.nicenboim.me/bayescogsci/ch-workflow.html"
PSU_CONDITIONAL_PROBABILITY = "https://online.stat.psu.edu/stat414/Lesson04"
PSU_INDEPENDENCE = "https://online.stat.psu.edu/stat414/Lesson05"
PSU_STUDENT_T = "https://online.stat.psu.edu/stat414/Lesson26"
CONDITIONAL_INDEPENDENCE_TEXT = (
    "https://www.probabilitycourse.com/chapter1/"
    "1_4_4_conditional_independence.php"
)

WINTER = "https://appliedstatisticsforlinguists.org/bwinter_stats_proofs.pdf"
WINTER_DESCRIPTIVE = f"{WINTER}#page=69"
WINTER_LINEAR = f"{WINTER}#page=85"
WINTER_CENTERING = f"{WINTER}#page=102"
WINTER_MULTIPLE = f"{WINTER}#page=119"
WINTER_CATEGORICAL = f"{WINTER}#page=133"
WINTER_INTERACTIONS = f"{WINTER}#page=149"
WINTER_INFERENCE = f"{WINTER}#page=173"
WINTER_POWER = f"{WINTER}#page=187"
WINTER_GLM = f"{WINTER}#page=214"
WINTER_POISSON = f"{WINTER}#page=234"
WINTER_MIXED = f"{WINTER}#page=248"
WINTER_MIXED_EXAMPLE = f"{WINTER}#page=261"
WINTER_T_TESTS = f"{WINTER}#page=308"

OPENSTAX_TERMS = (
    "https://openstax.org/books/introductory-statistics-2e/pages/"
    "1-1-definitions-of-statistics-probability-and-key-terms"
)
OPENSTAX_DESIGN = (
    "https://openstax.org/books/introductory-statistics-2e/pages/"
    "1-4-experimental-design-and-ethics"
)
OPENSTAX_HYPERGEOMETRIC = (
    "https://openstax.org/books/introductory-statistics-2e/pages/"
    "4-5-hypergeometric-distribution"
)
OPENSTAX_FPC = (
    "https://openstax.org/books/introductory-business-statistics-2e/pages/"
    "7-4-finite-population-correction-factor"
)
OPENSTAX_GEOMETRIC = (
    "https://openstax.org/books/introductory-statistics-2e/pages/"
    "4-4-geometric-distribution"
)
OPENSTAX_CHISQUARE = (
    "https://openstax.org/books/introductory-statistics-2e/pages/"
    "11-1-facts-about-the-chi-square-distribution"
)
OPENSTAX_INDEPENDENCE = (
    "https://openstax.org/books/introductory-business-statistics-2e/pages/"
    "11-4-test-of-independence"
)
OPENSTAX_ZSCORE = (
    "https://openstax.org/books/introductory-statistics-2e/pages/"
    "6-1-the-standard-normal-distribution"
)
OPENSTAX_BOOTSTRAP = "https://openintro-ims.netlify.app/foundations-bootstrapping.html"

PROBABILITY_TEXT = "https://www.probabilitycourse.com/chapter1/1_3_1_random_variables.php"
MEASURABLE_SPACES = (
    "https://stats.libretexts.org/Bookshelves/Probability_Theory/"
    "Probability_Mathematical_Statistics_and_Stochastic_Processes_%28Siegrist%29/"
    "01%3A_Foundations/1.11%3A_Measurable_Spaces"
)
PROBABILITY_SPACES_REVISITED = (
    "https://stats.libretexts.org/Bookshelves/Probability_Theory/"
    "Probability_Mathematical_Statistics_and_Stochastic_Processes_%28Siegrist%29/"
    "02%3A_Probability_Spaces/2.09%3A_Probability_Spaces_Revisited"
)
ABSOLUTELY_CONTINUOUS_TEXT = (
    "https://stats.libretexts.org/Bookshelves/Probability_Theory/"
    "Applied_Probability_%28Pfeiffer%29/07%3A_Distribution_and_Density_Functions/"
    "7.01%3A_Distribution_and_Density_Functions"
)
MOMENTS_TEXT = (
    "https://stats.libretexts.org/Bookshelves/Probability_Theory/"
    "Probability_Mathematical_Statistics_and_Stochastic_Processes_%28Siegrist%29/"
    "04%3A_Expected_Value/4.01%3A_Definitions_and_Basic_Properties"
)
CONDITIONAL_EXPECTATION_TEXT = (
    "https://stats.libretexts.org/Bookshelves/Probability_Theory/"
    "Probability_Mathematical_Statistics_and_Stochastic_Processes_%28Siegrist%29/"
    "04%3A_Expected_Value/4.07%3A_Conditional_Expected_Value"
)
ESTIMATORS_TEXT = (
    "https://stats.libretexts.org/Bookshelves/Probability_Theory/"
    "Probability_Mathematical_Statistics_and_Stochastic_Processes_%28Siegrist%29/"
    "07%3A_Point_Estimation/7.01%3A_Estimators"
)
NEGATIVE_BINOMIAL_TEXT = "https://online.stat.psu.edu/stat414/lesson/11/11.4"
INVERSE_TRANSFORM_TEXT = (
    "https://bookdown.org/richard_g_everitt/notes/chapsimulation.html"
)
MARKOV_TEXT = "https://bookdown.org/rdpeng/advstatcomp/markov-chain-monte-carlo.html"
IMPORTANCE_TEXT = (
    "https://www.cambridge.org/core/books/inverse-problems-and-data-assimilation/"
    "monte-carlo-sampling-and-importance-sampling/"
    "AEE4AC4E63548DC6A732013B571841D8"
)
PSEUDOCOUNT_TEXT = "https://web.stanford.edu/group/sisl/public/dmu.pdf"
R_RANDOM = "https://stat.ethz.ch/R-manual/R-devel/library/base/html/Random.html"
R_FISHER = "https://stat.ethz.ch/R-manual/R-devel/library/stats/html/fisher.test.html"
R_T_TEST = "https://stat.ethz.ch/R-manual/R-devel/library/stats/html/t.test.html"
R_BINOM_TEST = "https://stat.ethz.ch/R-manual/R-devel/library/stats/html/binom.test.html"
SILHOUETTE_SOURCE = "https://doi.org/10.1016/0377-0427(87)90125-7"

STAN_MCMC = "https://mc-stan.org/docs/reference-manual/mcmc.html"
STAN_RHAT = "https://mc-stan.org/rstan/reference/Rhat.html"
STAN_PAIRS = "https://mc-stan.org/bayesplot/articles/plotting-mcmc-draws.html"
STAN_ESS = "https://mc-stan.org/docs/2_31/reference-manual/effective-sample-size.html"
STAN_DIAGNOSTICS = "https://mc-stan.org/learn-stan/diagnostics-warnings.html"
STAN_BLOCKS = "https://mc-stan.org/docs/reference-manual/blocks.html"
STAN_MIXTURES = "https://mc-stan.org/docs/stan-users-guide/finite-mixtures.html"
STAN_PPC = "https://mc-stan.org/docs/stan-users-guide/posterior-predictive-checks.html"
STAN_CATEGORICAL = "https://mc-stan.org/docs/functions-reference/categorical-distribution.html"
STAN_PARAMETER_RECOVERY = "https://mc-stan.org/learn-stan/case-studies/rasch_and_2pl.html"

VASHISHTH_CONTRASTS = "https://vasishth.github.io/Freq_CogSci/ch-contr.html"
R_CONTRASTS = (
    "https://stat.ethz.ch/R-manual/R-devel/library/stats/html/contrast.html"
)
ISLP_RIDGE = (
    "https://islp.readthedocs.io/en/latest/labs/Ch06-varselect-lab.html"
    "#ridge-regression-and-the-lasso"
)
BRMS_DISTREG = "https://paulbuerkner.com/brms/articles/brms_distreg.html"
BRMS_FAMILIES = "https://paulbuerkner.com/brms/articles/brms_families.html"
SKLEARN_LEAKAGE = "https://scikit-learn.org/stable/common_pitfalls.html#data-leakage"
SKLEARN_GROUP_CV = (
    "https://scikit-learn.org/stable/modules/cross_validation.html"
    "#cross-validation-iterators-for-grouped-data"
)
OTEXTS_TRAIN_TEST = "https://otexts.com/fpp3/training-test.html"
OTEXTS_ACCURACY = "https://otexts.com/fpp3/accuracy.html"
PSU_ORDINAL = "https://online.stat.psu.edu/stat504/lesson/8/8.1"
PSU_ICC = "https://online.stat.psu.edu/stat502/Lesson06"
PSU_SUFFICIENCY = "https://online.stat.psu.edu/stat415/book/export/html/844"
PSU_WALD = "https://online.stat.psu.edu/stat504/Lesson02"
PSU_COVERAGE = "https://online.stat.psu.edu/stat100/Lesson09"
LME4_SINGULAR = "https://lme4.github.io/lme4/reference/isSingular.html"
LME4_RANEF = "https://lme4.github.io/lme4/reference/ranef.html"
LME4_GLMER = "https://lme4.github.io/lme4/reference/glmer.html"

DESIGN_TEXT = "https://opentextbc.ca/researchmethods/chapter/experimental-design/"
PSU_DESIGN = "https://online.stat.psu.edu/stat503/Lesson01"
UNIT_TEXT = "https://bookdown.org/pkaldunn/Book/UnitsObsAnalysis.html"
TOKEN_TEXT = "https://web.stanford.edu/~jurafsky/slp3/old_aug25/ed3book.pdf"
DATA_KEYS = "https://datacarpentry.github.io/spreadsheet-ecology-lesson/01-format-data.html"
ICH_ESTIMAND = (
    "https://database.ich.org/sites/default/files/"
    "E9-R1_Step4_Guideline_2019_1203.pdf"
)
ZIPF_SOURCE = "https://doi.org/10.3758/s13423-014-0585-6"
MEGA_SOURCE = "https://doi.org/10.5334/gjgl.1001"

PSU_CLUSTERING = "https://online.stat.psu.edu/stat505/Lesson14"
SKLEARN_SILHOUETTE = (
    "https://scikit-learn.org/stable/auto_examples/cluster/"
    "plot_kmeans_silhouette_analysis.html"
)
SKLEARN_MIXTURES = "https://scikit-learn.org/stable/modules/mixture.html"
PSU_PCA = "https://online.stat.psu.edu/stat508/Lesson07.html"
CS357_SVD = "https://cs357.cs.illinois.edu/textbook/notes/svd.html"
PCA_SIGN = (
    "https://imae.udg.edu/~jpalarea/StatsDS/principal-components-analysis.html"
)
LOO_PSIS = "https://mc-stan.org/loo/articles/online-only/faq.html"
LOO_WAIC = "https://mc-stan.org/loo/reference/waic.html"
LOO_GLOSSARY = "https://mc-stan.org/loo/reference/loo-glossary.html"
LOO_PARETO_K = "https://mc-stan.org/loo/reference/pareto-k-diagnostic.html"
ISLR = "https://www.statlearning.com/s/ISLRSeventhPrinting.pdf"
RISK_TEXT = (
    "https://wanghemath.github.io/Book-ProbabilityStatisticalTheory/"
    "chapters/chapter-13-point-estimation2.html"
)
VAN_BUUREN = "https://stefvanbuuren.name/fimd/sec-MCAR.html"
RUBIN_MISSINGNESS = (
    "https://academic.oup.com/biomet/article-abstract/63/3/581/270932"
)
MISSMDA = "https://search.r-project.org/CRAN/refmans/missMDA/html/imputePCA.html"
PHOIBLE_FAQ = "https://phoible.org/faq"
TALKER_ADAPTATION_SOURCE = "https://pmc.ncbi.nlm.nih.gov/articles/PMC2213510/"
ORDERED_BETA_SOURCE = "https://doi.org/10.1007/s11050-025-09244-9"
WURM_RESIDUALIZATION = "https://doi.org/10.1016/j.jml.2013.12.003"
HARMONIC_ALIGNMENT_SOURCE = "https://web.stanford.edu/~bresnan/qs-submit.pdf"
PROJECTION_SOURCE = "https://doi.org/10.18148/sub/2019.v23i2.601"
CORRELATION_RATIO_SOURCE = (
    "https://courses.washington.edu/psy524a/_book/anova-is-just-regression.html"
)


TERM_AUTHORITIES: dict[str, str] = {}


def add(authority: str, *terms: str) -> None:
    for term in terms:
        if term in TERM_AUTHORITIES:
            raise ValueError(f"duplicate authority for {term!r}")
        TERM_AUTHORITIES[term] = authority


add(
    UNIT_TEXT,
    "unit of analysis",
    "unit of observation",
)
add(OPENSTAX_TERMS, "record", "response", "predictor", "target population", "sample", "parameter", "estimate", "data", "model")
add(DATA_KEYS, "observation key")
add(TOKEN_TEXT, "tokens", "types")
add(ICH_ESTIMAND, "estimand")
add(ZIPF_SOURCE, "Zipf's law")

add(
    NICENBOIM_1,
    "sample space",
    "outcome",
    "event",
    "probability space",
    "mutually exclusive",
    "joint probability",
    "marginal probabilities",
    "conditional probability",
    "Bayes' rule",
    "random variable",
    "discrete random variable",
    "support",
    "probability mass function",
    "PMF",
    "probability density function",
    "PDF",
    "cumulative distribution function",
    "CDF",
    "expected value",
    "variance",
    "standard deviation",
    "Bernoulli distribution",
    "binomial distribution",
    "continuous uniform distribution",
    "normal distribution",
    "joint distribution",
    "marginal distribution",
    "covariance",
    "Correlation",
    "independent and identically distributed (IID)",
    "likelihood function",
    "maximum-likelihood estimate",
)
add(PSU_CONDITIONAL_PROBABILITY, "multiplication rule", "factorization")
add(PSU_INDEPENDENCE, "independent")
add(CONDITIONAL_INDEPENDENCE_TEXT, "Conditional independence")
add(PROBABILITY_SPACES_REVISITED, "probability measure")
add(MEASURABLE_SPACES, "sigma-algebra", "generating set", "atoms")
add(PROBABILITY_SPACES_REVISITED, "preimage", "measurability")
add(ABSOLUTELY_CONTINUOUS_TEXT, "absolutely continuous")
add(MOMENTS_TEXT, "linearity of expectation", "$k$th central moment")
add(CONDITIONAL_EXPECTATION_TEXT, "conditional expectations")
add(STAN_CATEGORICAL, "categorical distribution")
add(OPENSTAX_HYPERGEOMETRIC, "without replacement", "hypergeometric distribution")
add(OPENSTAX_FPC, "finite population correction")
add(OPENSTAX_GEOMETRIC, "geometric distribution")
add(NEGATIVE_BINOMIAL_TEXT, "negative binomial distribution")
add(WINTER_POISSON, "Poisson distribution", "overdispersion")
add(NICENBOIM_2, "beta distribution")
add(PSU_STUDENT_T, "Student's t distribution")
add(OPENSTAX_CHISQUARE, "chi-squared distribution")
add(OPENSTAX_ZSCORE, "z-score")
add(INVERSE_TRANSFORM_TEXT, "inverse transform sampling")
add(NICENBOIM_1, "marginalization")
add(R_RANDOM, "random seed")

add(
    WINTER_INFERENCE,
    "sampling distribution",
    "standard error",
    "confidence interval",
    "null hypothesis",
    "alternative hypothesis",
    "null distribution",
    "paired design",
)
add(ESTIMATORS_TEXT, "bias", "mean squared error")
add(PSU_COVERAGE, "coverage probability")
add(PSU_WALD, "Wald interval")
add(WINTER_T_TESTS, "one-sample t-test", "paired t-test")
add(R_T_TEST, "Welch's two-sample t-test")
add(OPENSTAX_INDEPENDENCE, "chi-squared test of independence")
add(R_BINOM_TEST, "Clopper-Pearson confidence interval")
add(OPENSTAX_BOOTSTRAP, "nonparametric bootstrap", "empirical distribution", "percentile bootstrap confidence interval")
add(R_FISHER, "Fisher's exact test", "sample odds ratio")
add(
    NICENBOIM_2,
    "prior distribution",
    "posterior distribution",
    "posterior summary",
    "conjugate prior",
    "prior predictive distribution",
    "posterior predictive distribution",
    "normalizing constant",
)
add(PSEUDOCOUNT_TEXT, "pseudocount")
add(NICENBOIM_8, "Monte Carlo integration", "Monte Carlo error")
add(IMPORTANCE_TEXT, "importance weight")
add(MARKOV_TEXT, "Markov chain", "stationary", "irreducible", "aperiodic", "Markov chain Monte Carlo (MCMC)", "Metropolis-Hastings algorithm")
add(
    NICENBOIM_8,
    "Hamiltonian Monte Carlo (HMC)",
    "potential energy",
    "kinetic energy",
    "Hamiltonian",
    "leapfrog integrator",
    "No-U-Turn Sampler (NUTS)",
    "Stan",
)
add(STAN_MCMC, "mass matrix", "unit mass matrix", "diagonal mass matrix", "dense mass matrix", "nonstationarity", "divergent transition")
add(STAN_PAIRS, "trace plot", "pairs plot")
add(STAN_ESS, "autocorrelation", "autocorrelation function", "integrated autocorrelation time", "effective sample size")
add(STAN_DIAGNOSTICS, "Bulk ESS", "Tail ESS")
add(STAN_RHAT, "$\\widehat{R}$ statistic", "rank-normalized split $\\widehat{R}$")
add(STAN_BLOCKS, "generated quantities block")
add(STAN_PPC, "posterior predictive check", "discrepancy function")

add(NICENBOIM_4, "conditional mean", "regression model", "Bayesian linear regression")
add(WINTER_LINEAR, "simple linear regression", "least squares", "coefficient of determination", "residual", "Residual diagnostics", "Leverage", "Influence")
add(WINTER_LINEAR, "total sum of squares (SST)", "sum of squared errors (SSE)")
add(ISLR, "residual sum of squares (RSS)")
add(WINTER_CENTERING, "centering", "Standardization")
add(WINTER_MULTIPLE, "partial regression coefficients", "collinearity", "variance inflation factor (VIF)")
add(WINTER_CATEGORICAL, "design matrix", "contrast coding", "Sum coding", "Helmert coding")
add(WINTER_INTERACTIONS, "interaction term")
add(R_CONTRASTS, "reverse Helmert contrasts")
add(ISLP_RIDGE, "Ridge regression", "regularization parameter")
add(WINTER_LINEAR, "heteroscedasticity")
add(WURM_RESIDUALIZATION, "residualization")
add(BRMS_DISTREG, "distributional regression")

add(RISK_TEXT, "loss function", "predictive risk")
add(RISK_TEXT, "squared-error loss", "absolute-error loss")
add(OTEXTS_ACCURACY, "root mean squared error (RMSE)", "mean absolute error (MAE)")
add(ISLR, "bias-variance decomposition", "irreducible error")
add(NICENBOIM_14, "Out-of-sample prediction", "$K$-fold cross-validation (CV)", "Leave-one-out cross-validation (LOO-CV)")
add(SKLEARN_GROUP_CV, "Grouped K-fold cross-validation", "leave-one-group-out cross-validation")
add(LOO_PSIS, "Pareto-smoothed importance sampling leave-one-out cross-validation (PSIS-LOO)")
add(LOO_GLOSSARY, "expected log pointwise predictive density (ELPD)")
add(LOO_PARETO_K, "Pareto $k$ diagnostic")
add(LOO_WAIC, "widely applicable information criterion (WAIC)")
add(LOO_WAIC, "log pointwise predictive density (lppd)")
add(OTEXTS_TRAIN_TEST, "training set", "test set")
add(SKLEARN_LEAKAGE, "Data leakage")
add(WINTER_MIXED_EXAMPLE, "nested", "likelihood-ratio test (LRT)")
add(ISLR, "optimism of training error")
add(ISLR, "information criterion")
add(ISLR, "Akaike information criterion (AIC)", "Bayesian information criterion (BIC)")

add(WINTER_GLM, "link function", "exponential family", "generalized linear model", "GLM", "linear predictor", "variance function", "canonical link", "iteratively reweighted least squares", "deviance", "odds", "log odds", "logit", "Logistic regression", "Deviance residuals")
add(PSU_SUFFICIENCY, "sufficient statistic")
add(PSU_ORDINAL, "Ordinal regression", "proportional odds assumption")
add(WINTER_POISSON, "Poisson regression", "exposure offset", "Pearson residual", "Pearson estimate of dispersion", "quasi-Poisson model", "zero-inflated model", "negative binomial regression")
add(ORDERED_BETA_SOURCE, "bounded response", "beta regression", "Ordered-beta regression")

add(NICENBOIM_5, "crossed", "fixed effects", "random effects", "partial pooling", "Complete pooling", "No pooling", "Partial pooling", "shrinkage", "random-intercept model", "random-slope model", "random-effects correlation", "generalized linear mixed model", "GLMM")
add(PSU_ICC, "intraclass correlation coefficient (ICC)")
add(BRMS_FAMILIES, "ordinal mixed model")
add(LME4_GLMER, "Poisson mixed-effects model")
add(LME4_RANEF, "conditional modes", "group-specific estimates")
add(LME4_SINGULAR, "singular fit")
add(NICENBOIM_9, "Laplace approximation")

add(OPENSTAX_DESIGN, "unit of assignment", "assignment mechanism")
add(DESIGN_TEXT, "within-participant design", "carryover effect", "between-participant design", "Counterbalancing")
add(WINTER_POWER, "power curve")

add(PSU_CLUSTERING, "K-means clustering", "local minimum", "elbow plot", "elbow method", "Euclidean distance")
add(STAN_MIXTURES, "finite mixture model")
add(SILHOUETTE_SOURCE, "silhouette width")
add(PSU_CLUSTERING, "responsibilities")
add(SKLEARN_MIXTURES, "Gaussian mixture model (GMM)", "posterior probability of component membership", "expectation-maximization (EM) algorithm")
add(STAN_MIXTURES, "label switching")

add(PSU_PCA, "rank one", "Principal component analysis (PCA)", "principal component directions", "score matrix", "Scores", "loadings", "rank-$K$ approximation", "proportion of variance explained")
add(CS357_SVD, "singular value decomposition (SVD)", "left singular vectors", "right singular vectors")
add(PCA_SIGN, "sign indeterminacy")
add(MEGA_SOURCE, "selectional profile", "communicativity")
add(PHOIBLE_FAQ, "doculect")

add(RUBIN_MISSINGNESS, "missingness mechanism")
add(VAN_BUUREN, "missingness indicator", "missingness pattern", "missing completely at random (MCAR)", "missing at random (MAR)", "missing not at random (MNAR)", "Complete-case analysis")
add(MISSMDA, "Iterative PCA imputation")
add(NICENBOIM_WORKFLOW, "data-generating process")
add(NICENBOIM_10, "joint probability model")
add(STAN_PARAMETER_RECOVERY, "parameter recovery")
add(HARMONIC_ALIGNMENT_SOURCE, "harmonic alignment")
add(PROJECTION_SOURCE, "project")
add(CORRELATION_RATIO_SOURCE, "correlation ratio")


EMPHASIS_NOT_TERMS = {
    "what does one observation represent?",
    "Why this reading?",
    "where was the response measured?",
    "what does one response in the analysis represent?",
    "what should the claim generalize to?",
    "given",
    "new",
    "Aggregate direction and magnitude:",
    "Improvement rate:",
    "Variation:",
    "Control:",
    "Lexical:",
    "Graded:",
    "Piloted checkpoint:",
    "What the paper records.",
    "What counts as a new observation?",
    "What breaks the simpler model?",
    "representation problem",
    "unit choice",
    "comparison-alignment problem",
    "description-explanation gap",
    "outcome-representation problem",
    "closure problem",
    "generation problem",
    "coherence problem",
    "double-counting problem",
    "conditional-direction problem",
    "invariance test",
    "outcome-to-value mapping",
    "heuristic accusative label",
    "prediction-unit problem (PUP)",
    "prediction unit",
    "prediction information set",
    "error-consequence problem",
    "row-level LOO",
    "leave-one-group-out",
    "talker-independent perceptual adaptation",
    "design-to-estimand map",
    "sampling unit",
    "assignment-identification link",
    "intention-to-treat contrast",
    "item-rotation principle",
    "component--category distinction",
    "within-cluster sum of squares (WCSS)",
    "representation constraint (RC)",
    "distributional components (DCs)",
    "missing-data specification",
    "An absent record:",
    "Planned missingness:",
    "An undefined measure:",
    "Measurement, annotation, or tracking failure:",
    "Dropout:",
    "complete-case selection problem",
    "Holdout validation by artificial masking",
    "measurement chain",
    "annotator location effect",
    "by-design absence",
}


BANNED_TERMINOLOGY = {
    "Gaussian regression": "ordinary linear regression",
    "normal-error model": "ordinary linear regression with normally distributed errors",
    "null reference distribution": "null distribution",
    "paired t procedure": "paired t-test",
    "Welch's t procedure": "Welch's two-sample t-test",
    "posterior pair plot": "pairs plot of posterior draws",
    "random effect correlation": "random-effects correlation",
    "within participant design": "within-participant design",
    "between participant design": "between-participant design",
    "silhouette score": "silhouette width",
    "training and test split": "training and test sets",
    "percentile bootstrap interval": "percentile bootstrap confidence interval",
    "intraclass correlation (ICC)": "intraclass correlation coefficient (ICC)",
    "prediction target": "a direct statement of what is held out and what information is available at prediction time",
    "transfer unit": "held-out group",
    "transfer target": "new-group prediction",
    "interpolation target": "prediction for another response from represented groups",
}


BOLD_RE = re.compile(r"\*\*(.+?)\*\*")


def sidebar_order() -> list[Path]:
    config = yaml.safe_load((ROOT / "_quarto.yml").read_text())
    ordered: list[Path] = []

    def walk(node: object) -> None:
        if isinstance(node, str) and node.endswith(".qmd"):
            ordered.append(ROOT / node)
        elif isinstance(node, list):
            for child in node:
                walk(child)
        elif isinstance(node, dict):
            walk(node.get("contents", []))

    walk(config["website"]["sidebar"]["contents"])
    assessments = [
        ROOT / "problem-sets/ps1/ps1.qmd",
        ROOT / "problem-sets/ps2/ps2.qmd",
        ROOT / "problem-sets/ps3/ps3-dative-alternation.qmd",
        ROOT / "problem-sets/ps4/ps4.qmd",
        ROOT / "problem-sets/ps5/ps5.qmd",
    ]
    return [path for path in ordered + assessments if path.exists()]


def prose_lines(path: Path):
    in_yaml = False
    in_code = False
    for index, line in enumerate(path.read_text().splitlines(), start=1):
        if index == 1 and line.strip() == "---":
            in_yaml = True
            continue
        if in_yaml:
            if line.strip() == "---":
                in_yaml = False
            continue
        if line.lstrip().startswith("```"):
            in_code = not in_code
            continue
        if not in_code:
            yield index, line


def first_occurrences(paths: list[Path]):
    first = {}
    for path in paths:
        for line_number, line in prose_lines(path):
            for match in BOLD_RE.finditer(line):
                term = match.group(1).strip()
                first.setdefault(term, (path, line_number, line))
    return first


def linked_to(line: str, term: str, authority: str) -> bool:
    expected = f"[**{term}**]({authority})"
    return expected in line


def fix_links(first: dict[str, tuple[Path, int, str]]) -> int:
    changes: dict[Path, dict[int, list[tuple[str, str]]]] = defaultdict(lambda: defaultdict(list))
    for term, authority in TERM_AUTHORITIES.items():
        if term not in first:
            continue
        path, line_number, line = first[term]
        if not linked_to(line, term, authority):
            changes[path][line_number].append((term, authority))

    changed_files = 0
    for path, by_line in changes.items():
        lines = path.read_text().splitlines(keepends=True)
        for line_number, replacements in by_line.items():
            line = lines[line_number - 1]
            for term, authority in replacements:
                new = f"[**{term}**]({authority})"
                linked = re.compile(
                    r"\[\*\*" + re.escape(term) + r"\*\*\]\(https?://[^)]+\)"
                )
                line, count = linked.subn(lambda _match: new, line, count=1)
                if count:
                    continue

                old = f"**{term}**"
                if old in line:
                    line = line.replace(old, new, 1)
                else:
                    raise RuntimeError(
                        f"cannot locate bold term {term!r} in {path}:{line_number}"
                    )
            lines[line_number - 1] = line
        path.write_text("".join(lines))
        changed_files += 1
    return changed_files


def check(paths: list[Path]) -> list[str]:
    first = first_occurrences(paths)
    problems: list[str] = []

    for term, (path, line_number, line) in first.items():
        rel = path.relative_to(ROOT)
        if term in EMPHASIS_NOT_TERMS:
            continue
        authority = TERM_AUTHORITIES.get(term)
        if authority is None:
            problems.append(f"{rel}:{line_number}: bold expression has no terminology decision: {term!r}")
        elif not linked_to(line, term, authority):
            problems.append(f"{rel}:{line_number}: first introduction is not linked to {authority}: {term!r}")

    for term in sorted(TERM_AUTHORITIES):
        if term not in first:
            problems.append(f"authority table contains a term not found in the chapter sequence: {term!r}")

    for path in paths:
        text = path.read_text()
        normalized_text = re.sub(r"\s+", " ", text)
        if "[[**" in text or re.search(r"\]\]\(https?://", text):
            problems.append(
                f"{path.relative_to(ROOT)}: malformed nested authority link"
            )
        for banned, replacement in BANNED_TERMINOLOGY.items():
            if banned.casefold() in normalized_text.casefold():
                problems.append(
                    f"{path.relative_to(ROOT)}: nonstandard term {banned!r}; use {replacement!r}"
                )

    return problems


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--fix", action="store_true", help="add missing first-introduction links")
    args = parser.parse_args()

    paths = sidebar_order()
    first = first_occurrences(paths)
    if args.fix:
        changed = fix_links(first)
        print(f"Added or corrected authority links in {changed} files.")

    problems = check(paths)
    if problems:
        print("Statistical terminology check failed:")
        for problem in problems:
            print(f"  {problem}")
        return 1

    technical = len(TERM_AUTHORITIES)
    print(
        f"Statistical terminology check passed for {technical} terms "
        f"across {len(paths)} course pages."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
