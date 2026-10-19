#!/usr/bin/env python3
"""Rebuild every course deck and transcript from the revised note sequence.

The script is intentionally destructive only with respect to generated deck sources:
all twelve ``decks/*/index.qmd`` files and all generated transcript files are
replaced from the manifest below.  No pre-existing slide body is read.  This is
the mechanism that prevents stale slide content from surviving the revamp.

The notes remain the content authority.  Each generated slide records its note
page, the SHA-256 of that page, and a stable slide identifier.  Empirical figures
come from the audited reference analyses or from figures rendered by the note
itself.  The companion validator checks these contracts.
"""

from __future__ import annotations

import csv
import argparse
import difflib
import hashlib
import html
import json
import re
from dataclasses import dataclass, field
from html.parser import HTMLParser
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parents[1]
DECK_ROOT = ROOT / "decks"
RENDER_RECEIPTS = DECK_ROOT / "note-render-receipts.json"


DECKS: dict[str, dict] = {
    "data-and-probability": {
        "title": "Describing what happens",
        "date": "2026-08-31",
        "date_format": "[August 31, September 2 and 9,] YYYY",
        "pages": [
            "foundations/index.qmd",
            "foundations/linguistic-data.qmd",
            "foundations/making-sense-of-data.qmd",
            "foundations/zipfs-law.qmd",
            "foundations/possibilities-and-events.qmd",
            "foundations/events.qmd",
            "foundations/event-spaces.qmd",
            "foundations/generating-event-spaces.qmd",
            "foundations/probability-measures.qmd",
            "foundations/probability-concepts.qmd",
            "foundations/joint-probability-of-events.qmd",
            "foundations/conditional-probability.qmd",
            "foundations/probability-factorization.qmd",
            "foundations/bayes-rule.qmd",
            "foundations/independence.qmd",
        ],
    },
    "random-variables-and-distributions": {
        "title": "Random variables and probability distributions",
        "date": "2026-09-14",
        "date_format": "[September 14, 16, 21 and 23,] YYYY",
        "pages": [
            "random-variables-and-distributions/index.qmd",
            "random-variables-and-distributions/why-random-variables.qmd",
            "random-variables-and-distributions/defining-random-variables.qmd",
            "random-variables-and-distributions/discrete-random-variables.qmd",
            "random-variables-and-distributions/probability-mass-functions.qmd",
            "random-variables-and-distributions/continuous-random-variables.qmd",
            "random-variables-and-distributions/probability-density-functions.qmd",
            "random-variables-and-distributions/cumulative-distribution-functions.qmd",
            "random-variables-and-distributions/expected-values.qmd",
            "random-variables-and-distributions/expectation-of-functions.qmd",
            "random-variables-and-distributions/linearity-of-expectation.qmd",
            "random-variables-and-distributions/when-expectations-fail.qmd",
            "random-variables-and-distributions/variance-and-covariance.qmd",
            "random-variables-and-distributions/standard-deviation.qmd",
            "random-variables-and-distributions/central-moments.qmd",
            "random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd",
            "random-variables-and-distributions/bernoulli-distribution.qmd",
            "random-variables-and-distributions/binomial-distribution.qmd",
            "random-variables-and-distributions/hypergeometric-distribution.qmd",
            "random-variables-and-distributions/geometric-distribution.qmd",
            "random-variables-and-distributions/negative-binomial-distribution.qmd",
            "random-variables-and-distributions/poisson-distribution.qmd",
            "random-variables-and-distributions/uniform-distribution.qmd",
            "random-variables-and-distributions/beta-distribution.qmd",
            "random-variables-and-distributions/normal-distribution.qmd",
            "random-variables-and-distributions/chi-squared-distribution.qmd",
            "random-variables-and-distributions/student-t-distribution.qmd",
            "random-variables-and-distributions/inverse-transform-sampling.qmd",
            "random-variables-and-distributions/random-seeds.qmd",
            "random-variables-and-distributions/joint-probability.qmd",
            "random-variables-and-distributions/marginal-distributions.qmd",
            "random-variables-and-distributions/conditional-independence.qmd",
            "random-variables-and-distributions/conditional-expectation.qmd",
            "random-variables-and-distributions/covariance.qmd",
            "random-variables-and-distributions/correlation.qmd",
        ],
    },
    "statistical-inference": {
        "title": "Learning beyond the observed sample",
        "date": "2026-09-28",
        "date_format": "[September 28 and 30, October 5,] YYYY",
        "pages": [
            "statistical-inference/index.qmd",
            "statistical-inference/populations-and-samples.qmd",
            "statistical-inference/independent-sampling.qmd",
            "statistical-inference/pronoun-case-example.qmd",
            "statistical-inference/maximum-likelihood.qmd",
            "statistical-inference/poisson-maximum-likelihood.qmd",
            "statistical-inference/properties-of-estimators.qmd",
            "statistical-inference/standard-errors.qmd",
            "statistical-inference/estimator-bias.qmd",
            "statistical-inference/mean-squared-error.qmd",
            "statistical-inference/confidence-intervals.qmd",
            "statistical-inference/exact-binomial-intervals.qmd",
            "statistical-inference/bootstrap-confidence-intervals.qmd",
            "statistical-inference/null-hypotheses-and-test-statistics.qmd",
            "statistical-inference/one-sample-t-inference.qmd",
            "statistical-inference/paired-observations.qmd",
            "statistical-inference/paired-mean-inference.qmd",
            "statistical-inference/independent-means.qmd",
            "statistical-inference/fishers-exact-test.qmd",
            "statistical-inference/chi-squared-test.qmd",
            "statistical-inference/posterior-distributions.qmd",
            "statistical-inference/posterior-summaries.qmd",
            "statistical-inference/conjugate-priors.qmd",
            "statistical-inference/prior-predictive-distributions.qmd",
            "statistical-inference/predictive-distributions.qmd",
            "statistical-inference/beyond-conjugacy.qmd",
            "statistical-inference/monte-carlo-integration.qmd",
            "statistical-inference/importance-sampling.qmd",
            "statistical-inference/markov-chains.qmd",
            "statistical-inference/markov-chain-monte-carlo.qmd",
            "statistical-inference/metropolis-hastings.qmd",
            "statistical-inference/hamiltonian-monte-carlo.qmd",
            "statistical-inference/mass-matrix-geometry.qmd",
            "statistical-inference/no-u-turn-sampler.qmd",
            "statistical-inference/stan.qmd",
            "statistical-inference/checking-markov-chains.qmd",
            "statistical-inference/rhat.qmd",
            "statistical-inference/autocorrelation.qmd",
            "statistical-inference/effective-sample-size.qmd",
            "statistical-inference/divergent-transitions.qmd",
            "statistical-inference/parameter-pair-plots.qmd",
            "statistical-inference/generated-quantities.qmd",
            "statistical-inference/posterior-predictive-checks.qmd",
        ],
    },
    "linear-regression": {
        "title": "Ordinary linear regression",
        "date": "2026-10-07",
        "date_format": "[October 7 and 14,] YYYY",
        "pages": [
            "regression-models/index.qmd",
            "regression-models/regression-models.qmd",
            "regression-models/simple-linear-regression.qmd",
            "regression-models/centering-predictors.qmd",
            "regression-models/response-transformations.qmd",
            "regression-models/frequentist-linear-regression.qmd",
            "regression-models/linear-regression-uncertainty.qmd",
            "regression-models/coefficient-of-determination.qmd",
            "regression-models/residuals.qmd",
            "regression-models/checking-linear-regression.qmd",
            "regression-models/leverage-and-influence.qmd",
            "regression-models/influence.qmd",
            "regression-models/bayesian-linear-regression.qmd",
            "regression-models/multiple-regression.qmd",
            "regression-models/design-matrices.qmd",
            "regression-models/coding-categorical-predictors.qmd",
            "regression-models/sum-coding.qmd",
            "regression-models/helmert-coding.qmd",
            "regression-models/inverse-helmert-coding.qmd",
            "regression-models/interactions.qmd",
            "regression-models/correlated-predictors.qmd",
            "regression-models/variance-inflation-factors.qmd",
            "regression-models/ridge-regression.qmd",
            "regression-models/residualizing-a-predictor.qmd",
            "regression-models/heteroscedasticity.qmd",
            "regression-models/distributional-regression.qmd",
        ],
    },
    "model-criticism-and-prediction": {
        "title": "Model criticism and out-of-sample prediction",
        "date": "2026-10-14",
        "date_format": "[October 14, 19 and 21,] YYYY",
        "pages": [
            "model-criticism-and-prediction/index.qmd",
            "model-criticism-and-prediction/prediction-targets.qmd",
            "model-criticism-and-prediction/training-and-test-data.qmd",
            "model-criticism-and-prediction/predictive-loss.qmd",
            "model-criticism-and-prediction/bias-variance-tradeoff.qmd",
            "model-criticism-and-prediction/cross-validation.qmd",
            "model-criticism-and-prediction/grouped-cross-validation.qmd",
            "model-criticism-and-prediction/comparing-predictive-loss.qmd",
            "model-criticism-and-prediction/likelihood-ratio-tests.qmd",
            "model-criticism-and-prediction/information-criteria.qmd",
            "model-criticism-and-prediction/leave-one-out-cross-validation.qmd",
            "model-criticism-and-prediction/psis-loo.qmd",
            "model-criticism-and-prediction/waic.qmd",
        ],
    },
    "generalized-linear-models": {
        "title": "Generalized linear models",
        "date": "2026-11-02",
        "date_format": "[November 2 and 4,] YYYY",
        "pages": [
            "regression-models/why-generalized-linear-models.qmd",
            "regression-models/link-functions.qmd",
            "regression-models/generalized-linear-models.qmd",
            "regression-models/exponential-family.qmd",
            "regression-models/sufficient-statistics.qmd",
            "regression-models/iteratively-reweighted-least-squares.qmd",
            "regression-models/deviance.qmd",
            "regression-models/odds-and-log-odds.qmd",
            "regression-models/logistic-regression.qmd",
            "regression-models/logistic-regression-example.qmd",
            "regression-models/logistic-regression-with-multiple-predictors.qmd",
            "regression-models/deviance-residuals.qmd",
            "regression-models/ordinal-regression.qmd",
            "regression-models/poisson-regression.qmd",
            "regression-models/exposure-offsets.qmd",
            "regression-models/poisson-regression-example.qmd",
            "regression-models/count-overdispersion.qmd",
            "regression-models/quasi-poisson.qmd",
            "regression-models/zero-inflated-counts.qmd",
            "regression-models/negative-binomial-regression.qmd",
            "regression-models/bounded-responses.qmd",
            "regression-models/why-not-beta-sliders.qmd",
            "regression-models/ordered-beta-regression.qmd",
        ],
    },
    "experimental-design": {
        "title": "Experimental design",
        "date": "2026-11-09",
        "date_format": "[November 9 and 11,] YYYY",
        "pages": [
            "experimental-design/index.qmd",
            "experimental-design/units-of-assignment.qmd",
            "experimental-design/random-assignment.qmd",
            "experimental-design/within-participant-designs.qmd",
            "experimental-design/between-participant-designs.qmd",
            "experimental-design/counterbalancing.qmd",
            "experimental-design/exclusion-rules.qmd",
            "experimental-design/power-by-simulation.qmd",
        ],
    },
    "mixed-effects-models": {
        "title": "Mixed-effects models",
        "date": "2026-11-16",
        "date_format": "[November 16 and 18,] YYYY",
        "pages": [
            "regression-models/structured-data.qmd",
            "regression-models/fixed-and-random-effects.qmd",
            "regression-models/random-effects.qmd",
            "regression-models/random-intercepts.qmd",
            "regression-models/intraclass-correlation.qmd",
            "regression-models/random-effect-estimates.qmd",
            "regression-models/random-slopes.qmd",
            "regression-models/random-effect-correlations.qmd",
            "regression-models/singular-fits.qmd",
            "regression-models/generalized-linear-mixed-models.qmd",
            "regression-models/ordinal-mixed-models.qmd",
            "regression-models/aspectual-similarity-example.qmd",
            "regression-models/laplace-approximation.qmd",
            "regression-models/poisson-mixed-models.qmd",
            "regression-models/overdispersion-and-random-effects.qmd",
        ],
    },
    "latent-structure": {
        "title": "Finding unobserved groups in linguistic data",
        "date": "2026-11-23",
        "date_format": "[November 23,] YYYY",
        "pages": [
            "latent-structure/index.qmd",
            "latent-structure/representing-objects.qmd",
            "latent-structure/distance-and-scaling.qmd",
            "latent-structure/k-means.qmd",
            "latent-structure/within-cluster-loss.qmd",
            "latent-structure/silhouette-scores.qmd",
            "latent-structure/unsupervised-validation.qmd",
            "latent-structure/gaussian-mixtures.qmd",
            "latent-structure/posterior-membership.qmd",
            "latent-structure/expectation-maximization.qmd",
            "latent-structure/choosing-a-mixture.qmd",
            "latent-structure/validating-a-mixture.qmd",
        ],
    },
    "factorization": {
        "title": "Factorizing linguistic data",
        "date": "2026-11-30",
        "date_format": "[November 30,] YYYY",
        "pages": [
            "factorization/index.qmd",
            "factorization/data-matrices.qmd",
            "factorization/centering-and-scaling.qmd",
            "factorization/rank-one-structure.qmd",
            "factorization/singular-value-decomposition.qmd",
            "factorization/principal-component-analysis.qmd",
            "factorization/scores-and-loadings.qmd",
            "factorization/reconstruction.qmd",
            "factorization/choosing-components.qmd",
            "factorization/valex-megaacceptability.qmd",
        ],
    },
    "missing-data": {
        "title": "Missing linguistic data",
        "date": "2026-12-02",
        "date_format": "[December 2,] YYYY",
        "pages": [
            "missing-data/index.qmd",
            "missing-data/missingness-patterns.qmd",
            "missing-data/missingness-mechanisms.qmd",
            "missing-data/complete-case-analysis.qmd",
            "missing-data/pca-imputation.qmd",
            "missing-data/validating-imputation.qmd",
        ],
    },
    "custom-model-design": {
        "title": "Custom generative models for annotations",
        "date": "2026-12-02",
        "date_format": "[December 2,] YYYY",
        "pages": [
            "custom-models/index.qmd",
            "custom-models/generative-stories.qmd",
            "custom-models/writing-a-joint-model.qmd",
            "custom-models/parameter-recovery.qmd",
            "custom-models/annotations-as-measurements.qmd",
            "custom-models/annotator-effects.qmd",
            "custom-models/uds-measurement-model.qmd",
            "custom-models/gated-annotations.qmd",
        ],
    },
}


DATASET_SOURCES = {
    "Hillenbrand et al. (1995)": (
        "American English /hVd/ vowel tokens with acoustic measurements",
        "Hillenbrand et al. (1995)",
        "https://doi.org/10.1121/1.411872",
    ),
    "UD Turkish BOUN": (
        "manually reviewed Turkish Universal Dependencies tokens",
        "Türk et al. (2022), UD Turkish BOUN 2.18",
        "https://doi.org/10.1007/s10579-021-09558-0",
    ),
    "CMUdict": (
        "pronunciation entries with phone and vowel counts",
        "CMUdict 0.7b",
        "https://github.com/cmusphinx/cmudict",
    ),
    "Turkish UniMorph": (
        "Turkish inflectional paradigms from the pinned UniMorph release",
        "Pimentel et al. (2021) and Batsuren et al. (2022), Turkish UniMorph",
        "https://github.com/unimorph/tur/tree/6c179ace7d2f3d7f3484020e5304c1544d07bb6b",
    ),
    "English dative": (
        "attested English dative construction tokens",
        "Bresnan et al. (2007), English dative alternation",
        "https://web.stanford.edu/~bresnan/qs-submit.pdf",
    ),
    "Provo": (
        "content-word positions aggregated across Provo readers",
        "Luke and Christianson (2018), Provo Corpus",
        "https://doi.org/10.3758/s13428-017-0908-4",
    ),
    "MALD": (
        "participant-by-word auditory lexical-decision trials",
        "Tucker et al. (2019), MALD",
        "https://doi.org/10.3758/s13428-018-1056-1",
    ),
    "Natural Stories": (
        "reader-by-word self-paced reading responses",
        "Futrell et al., Natural Stories",
        "https://github.com/languageMIT/naturalstories",
    ),
    "MegaOrientation": (
        "ordinal attitude reports grouped by embedded verb",
        "Moon and White (2020), MegaOrientation v1.1",
        "https://megaattitude.io/projects/mega-orientation/",
    ),
    "SuperTelicity": (
        "participant-by-item cloze choices for aspectual inference",
        "SuperTelicity cloze release",
        "https://creativecommons.org/licenses/by-sa/4.0/",
    ),
    "MegaVeridicality": (
        "ordinal inference judgments crossed with verb and respondent",
        "White and Rawlins (2018), MegaVeridicality",
        "https://ling.auf.net/lingbuzz/004012/current.pdf",
    ),
    "UCCA": (
        "aligned French and English passages with graph-derived Scene counts",
        "Sulem, Abend, and Rappoport (2015), UCCA French-English 20K",
        "https://aclanthology.org/W15-3502/",
    ),
    "ManyBabies": (
        "trial-level infant-directed and adult-directed speech responses",
        "ManyBabies 1 Consortium (2020)",
        "https://doi.org/10.1177/2515245919900809",
    ),
    "Peterson-Barney": (
        "1,520 F1-F2 vowel-token vectors from 76 speakers",
        "Peterson and Barney (1952)",
        "https://doi.org/10.1121/1.1906875",
    ),
    "PHOIBLE": (
        "one selected phoneme inventory per Glottocode",
        "PHOIBLE 2.0",
        "https://phoible.org/",
    ),
    "VALEX": (
        "verb-frame counts paired with MegaAcceptability ratings",
        "VALEX and MegaAcceptability 1.2",
        "https://github.com/aaronstevenwhite/mega-acceptability",
    ),
    "Jacy": (
        "Japanese analyses from the Jacy grammar over Tanaka examples",
        "Bond et al. (2008), Jacy",
        "https://www.anlp.jp/proceedings/annual_meeting/2008/pdf_dir/PC1-7.pdf",
    ),
    "UDS": (
        "predicate-node and annotator responses from Universal Decompositional Semantics",
        "White et al. (2020), UDS",
        "https://aclanthology.org/2020.lrec-1.699/",
    ),
    "Turkish PropBank": (
        "individual role judgments aligned with adjudicated Turkish roles",
        "Kara et al. (2020), Turkish PropBank",
        "https://doi.org/10.1007/s10579-017-9390-y",
    ),
    "Nettle": (
        "language-level population and climate counts",
        "Nettle (1999) teaching extract",
        "https://github.com/bodowinter/applied_statistics_book_data/blob/master/nettle_1999_climate.csv",
    ),
    "Storme": (
        "French liaison counts with repeated lexical contexts",
        "Storme (2024)",
        "https://doi.org/10.1007/s11525-024-09429-8",
    ),
    "MegaNegRaising": (
        "bounded acceptability responses for neg-raising configurations",
        "An and White (2020), MegaNegRaising",
        "https://aclanthology.org/2020.scil-1.45/",
    ),
}


MANUAL_FIGURES: dict[str, list[str]] = {
    "foundations/linguistic-data.qmd": [
        "foundations/linguistic-data_files/figure-html/plot-hillenbrand-units-1.png"
    ],
    "foundations/making-sense-of-data.qmd": [
        "foundations/making-sense-of-data_files/figure-html/plot-paired-vowels-1.png"
    ],
    "random-variables-and-distributions/why-random-variables.qmd": [
        "research/dataset-audits/reference-random-variables-output/cmudict-phone-vowel-pmfs.png"
    ],
    "random-variables-and-distributions/probability-mass-functions.qmd": [
        "research/dataset-audits/reference-random-variables-output/cmudict-phone-vowel-pmfs.png"
    ],
    "random-variables-and-distributions/probability-density-functions.qmd": [
        "research/dataset-audits/reference-random-variables-output/hillenbrand-duration-density.png"
    ],
    "random-variables-and-distributions/cumulative-distribution-functions.qmd": [
        "research/dataset-audits/reference-random-variables-output/hillenbrand-duration-f1-ecdf.png"
    ],
    "random-variables-and-distributions/when-expectations-fail.qmd": [
        "research/dataset-audits/reference-random-variables-output/cmudict-cauchy-mean-paths.png"
    ],
    "random-variables-and-distributions/bernoulli-and-categorical-distributions.qmd": [
        "research/dataset-audits/reference-random-variables-output/ud-turkish-question-pmfs.png"
    ],
    "random-variables-and-distributions/binomial-distribution.qmd": [
        "research/dataset-audits/reference-random-variables-output/ud-turkish-question-binomial-reference.png"
    ],
    "random-variables-and-distributions/hypergeometric-distribution.qmd": [
        "research/dataset-audits/reference-random-variables-output/unimorph-turkish-hypergeometric.png"
    ],
    "random-variables-and-distributions/negative-binomial-distribution.qmd": [
        "research/dataset-audits/reference-random-variables-output/cmudict-waiting-count-fits.png"
    ],
    "random-variables-and-distributions/poisson-distribution.qmd": [
        "research/dataset-audits/reference-random-variables-output/dative-poisson-fit.png"
    ],
    "random-variables-and-distributions/uniform-distribution.qmd": [
        "research/dataset-audits/reference-random-variables-output/provo-uniform-beta.png"
    ],
    "random-variables-and-distributions/beta-distribution.qmd": [
        "research/dataset-audits/reference-random-variables-output/provo-uniform-beta.png"
    ],
    "random-variables-and-distributions/normal-distribution.qmd": [
        "research/dataset-audits/reference-random-variables-output/hillenbrand-normal-fit.png"
    ],
    "random-variables-and-distributions/chi-squared-distribution.qmd": [
        "research/dataset-audits/reference-random-variables-output/hillenbrand-chi-square-reference.png"
    ],
    "random-variables-and-distributions/student-t-distribution.qmd": [
        "research/dataset-audits/reference-random-variables-output/hillenbrand-student-t-reference.png"
    ],
    "random-variables-and-distributions/inverse-transform-sampling.qmd": [
        "research/dataset-audits/reference-random-variables-output/ud-turkish-question-pmfs.png"
    ],
    "random-variables-and-distributions/joint-probability.qmd": [
        "research/dataset-audits/reference-random-variables-output/dative-joint-lengths.png"
    ],
    "random-variables-and-distributions/conditional-expectation.qmd": [
        "research/dataset-audits/reference-random-variables-output/dative-conditional-realization.png"
    ],
    "random-variables-and-distributions/covariance.qmd": [
        "research/dataset-audits/reference-random-variables-output/hillenbrand-paired-f1.png"
    ],
    "random-variables-and-distributions/correlation.qmd": [
        "research/dataset-audits/reference-random-variables-output/hillenbrand-paired-f1.png"
    ],
    "regression-models/why-generalized-linear-models.qmd": [
        "decks/shared/generated-figures/generalized/supertelicity-support-and-link.png"
    ],
    "regression-models/link-functions.qmd": [
        "decks/shared/generated-figures/generalized/supertelicity-support-and-link.png"
    ],
    "regression-models/generalized-linear-models.qmd": [
        "decks/shared/generated-figures/generalized/supertelicity-raw-and-fitted.png"
    ],
    "regression-models/iteratively-reweighted-least-squares.qmd": [
        "_freeze/regression-models/iteratively-reweighted-least-squares/figure-html/plot-irls-path-1.png"
    ],
    "regression-models/deviance.qmd": [
        "decks/shared/generated-figures/generalized/supertelicity-verb-calibration.png"
    ],
    "regression-models/logistic-regression.qmd": [
        "decks/shared/generated-figures/generalized/supertelicity-raw-and-fitted.png"
    ],
    "regression-models/logistic-regression-example.qmd": [
        "_freeze/regression-models/logistic-regression-example/figure-html/logistic-application-plot-1.png"
    ],
    "regression-models/logistic-regression-with-multiple-predictors.qmd": [
        "_freeze/regression-models/logistic-regression-with-multiple-predictors/figure-html/plot-multiple-logistic-1.png"
    ],
    "regression-models/deviance-residuals.qmd": [
        "decks/shared/generated-figures/generalized/supertelicity-verb-calibration.png"
    ],
    "regression-models/ordinal-regression.qmd": [
        "decks/shared/generated-figures/generalized/megaveridicality-raw-and-fitted.png"
    ],
    "regression-models/poisson-regression.qmd": [
        "decks/shared/generated-figures/generalized/nettle-poisson-rate.png"
    ],
    "regression-models/exposure-offsets.qmd": [
        "decks/shared/generated-figures/generalized/nettle-poisson-rate.png"
    ],
    "regression-models/poisson-regression-example.qmd": [
        "_freeze/regression-models/poisson-regression-example/figure-html/nettle-application-plot-1.png"
    ],
    "regression-models/count-overdispersion.qmd": [
        "decks/shared/generated-figures/generalized/nettle-poisson-dispersion.png"
    ],
    "regression-models/quasi-poisson.qmd": [
        "decks/shared/generated-figures/generalized/nettle-poisson-dispersion.png"
    ],
    "regression-models/zero-inflated-counts.qmd": [
        "decks/shared/generated-figures/generalized/storme-zero-check.png"
    ],
    "regression-models/negative-binomial-regression.qmd": [
        "decks/shared/generated-figures/generalized/storme-raw-and-negative-binomial.png"
    ],
    "regression-models/bounded-responses.qmd": [
        "decks/shared/generated-figures/generalized/meganegraising-ordered-beta-raw-and-fitted.png"
    ],
    "regression-models/why-not-beta-sliders.qmd": [
        "decks/shared/generated-figures/generalized/aspectual-ordered-beta-raw-and-fitted.png"
    ],
    "regression-models/ordered-beta-regression.qmd": [
        "decks/shared/generated-figures/generalized/aspectual-ordered-beta-raw-and-fitted.png",
        "decks/shared/generated-figures/generalized/meganegraising-ordered-beta-raw-and-fitted.png",
    ],
}


REGISTRIES = [
    "research/dataset-audits/reference-experimental-design-output/page-registry.csv",
    "research/dataset-audits/reference-factorization-output/page-registry.csv",
    "research/dataset-audits/reference-inference-bayesian-output/page-object-registry.csv",
    "research/dataset-audits/reference-inference-frequentist-output/page-object-registry.csv",
    "research/dataset-audits/reference-latent-structure-output/page-registry.csv",
    "research/dataset-audits/reference-linear-regression-output/page-map.csv",
    "research/dataset-audits/reference-missing-custom-output/page-registry.csv",
    "research/dataset-audits/reference-mixed-effects-output/page-map.csv",
    "research/dataset-audits/reference-model-evaluation-output/page-object-registry.csv",
]


# Two note equations place evaluated R values directly inside display math.
# Deck execution is intentionally disabled, so the audited reference outputs
# supply those values explicitly.  Keeping this list narrow makes any new
# inline-R equation fail validation until it receives the same treatment.
INLINE_R_MATH = {
    "model-criticism-and-prediction/likelihood-ratio-tests.qmd": {
        '`r sprintf("%.3f", quadratic_log_likelihood)`': "1493.619",
        '`r sprintf("%.3f", linear_log_likelihood)`': "1490.543",
        '`r sprintf("%.3f", lr_statistic)`': "6.152",
    },
    "latent-structure/silhouette-scores.qmd": {
        "`r round(a_i, 3)`": "0.590",
        "`r round(b_i, 3)`": "0.573",
        "`r round(s_i, 3)`": "-0.028",
    },
}


REGISTRY_PREFIX = {
    "reference-experimental-design-output": "experimental-design",
    "reference-factorization-output": "factorization",
    "reference-inference-bayesian-output": "statistical-inference",
    "reference-inference-frequentist-output": "statistical-inference",
    "reference-latent-structure-output": "latent-structure",
    "reference-linear-regression-output": "regression-models",
    "reference-missing-custom-output": "",
    "reference-mixed-effects-output": "regression-models",
    "reference-model-evaluation-output": "model-criticism-and-prediction",
}


@dataclass
class ContentBlock:
    kind: str
    value: str
    number: int | None = None


@dataclass
class Section:
    title: str
    raw: str
    prose: list[str] = field(default_factory=list)
    math: list[str] = field(default_factory=list)
    tables: list[str] = field(default_factory=list)
    code: list[str] = field(default_factory=list)
    fig_captions: list[str] = field(default_factory=list)
    blocks: list[ContentBlock] = field(default_factory=list)


@dataclass
class Slide:
    slide_id: str
    title: str
    visible: str
    transcript: str
    note_page: str
    note_hash: str
    role: str
    sources: list[str]
    classes: str = ""


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def split_frontmatter(text: str) -> tuple[str, str]:
    if not text.startswith("---\n"):
        return "", text
    end = text.find("\n---\n", 4)
    if end < 0:
        return "", text
    return text[4:end], text[end + 5 :]


def yaml_title(frontmatter: str, fallback: str) -> str:
    match = re.search(r'(?m)^title:\s*["\']?(.*?)["\']?\s*$', frontmatter)
    return match.group(1).strip().strip('"\'') if match else fallback


def normalize_prose(text: str) -> str:
    text = re.sub(r"<!--.*?-->", " ", text, flags=re.S)
    # Inline R must come from the rendered note, where it has already been
    # evaluated.  This marker makes a missing/stale rendered note fail the
    # alignment check rather than silently turning a computed value into vague
    # prose.
    text = re.sub(r"`r\s+[^`]+`", "[[INLINE-R-NOT-EVALUATED]]", text)
    text = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r"\1", text)
    text = re.sub(r"<[^>]+>", " ", text)
    text = text.replace("—", ",").replace("–", "-")
    text = re.sub(r"\s+", " ", text).strip()
    # Code remains explicit in the notes, but generated slides intentionally omit
    # code fences.  Refer to the empirical operation rather than an invisible block.
    text = re.sub(r"\b[Tt]he visible code\b", "the empirical calculation", text)
    text = re.sub(r"\b[Tt]he code\b", "the calculation", text)
    text = re.sub(r"\bvisible code\b", "empirical calculation", text)
    text = re.sub(r"\bdisplayed assertion\b", "stated assertion", text)
    text = re.sub(r"\bshown above\b", "in the stated identity", text)
    text = re.sub(r"\bcalculation below\b", "calculation", text)
    return text


def visible_words(text: str) -> int:
    clean = re.sub(r"\$\$.*?\$\$", " equation ", text, flags=re.S)
    clean = re.sub(r"\$[^$]+\$", " variable ", clean)
    clean = re.sub(r"[`*_>#|{}\[\]()]", " ", clean)
    return len(re.findall(r"\b[\w'/-]+\b", clean))


def split_sentences(text: str) -> list[str]:
    """Split prose without treating common scholarly abbreviations as stops."""

    protected = text
    replacements = {
        "et al.": "et al<prd>",
        "e.g.": "e<prd>g<prd>",
        "i.e.": "i<prd>e<prd>",
        "Fig.": "Fig<prd>",
        "Eq.": "Eq<prd>",
        "Dr.": "Dr<prd>",
    }
    for source, target in replacements.items():
        protected = protected.replace(source, target)
    parts = re.split(r"(?<=[.!?])\s+", protected)
    return [part.replace("<prd>", ".") for part in parts]


def sentence_trim(text: str, limit: int = 48) -> str:
    text = normalize_prose(text)
    if visible_words(text) <= limit:
        return text
    sentences = split_sentences(text)
    kept: list[str] = []
    for sentence in sentences:
        candidate = " ".join(kept + [sentence])
        if kept and visible_words(candidate) > limit:
            break
        kept.append(sentence)
        if visible_words(candidate) >= limit:
            break
    if kept and visible_words(" ".join(kept)) <= limit + 8:
        return " ".join(kept)
    words = text.split()
    return " ".join(words[:limit]).rstrip(" ,;:") + "."


NAVIGATION_SENTENCE_RE = re.compile(
    r"\b(?:next|preceding|following) (?:page|section|module)\b|\bwe (?:now |can now )?turn to\b",
    re.I,
)

SLIDE_POINT_TEXT_OVERRIDES = {
    "Then ask (i) which columns identify that observation": (
        "State what one observation represents before checking identifiers, repeated units, "
        "preprocessing, and replication."
    ),
    "Phone count has the largest VIF, 5.22": (
        "Phone count has the largest VIF, 5.22, inflating its conventional standard error "
        "by a factor of 2.28."
    ),
    "We first decide what the observations are": (
        "We identify the observations and comparisons before assigning probability to "
        "outcomes and events."
    ),
    "A unique row and an independent row are different notions": (
        "Row uniqueness distinguishes tokens; repeated speaker IDs reveal tokens that share "
        "a talker."
    ),
    "The table contains 324 tokens from 27 boys": (
        "Token totals are 324, 228, 540, and 576 for boys, girls, men, and women; the "
        "corresponding speaker totals are 27, 19, 45, and 48."
    ),
    "Hillenbrand et al. (1995) used the measurements": (
        "Hillenbrand et al. (1995) compared vowel acoustics and identification; here we "
        "isolate one paired acoustic contrast."
    ),
    "A response specification should name what was measured": (
        "The response is steady-state first-formant frequency (Hz) for one /hVd/ vowel token."
    ),
    "Mean F1 differences are 74.741 Hz": (
        "Mean F1 differences are 74.741, 41.526, 86.667, and 47.063 Hz for boys, girls, "
        "men, and women, respectively."
    ),
    "The ten most frequent forms are": (
        "Most frequent: *bir* (2,746), *ve* (2,045), *bu* (1,258), *de* (836), *ki* "
        "(787), *da* (786), *için* (591), *çok* (485), *o* (450), *gibi* (411)."
    ),
    "The largest absolute log residual belongs to *olanak*": (
        "Largest absolute log residual: *olanak*, split rank 32,474, residual 3.119. The "
        "fitted curve underpredicts its count."
    ),
    "For finite course examples we will often use the power set": (
        "For finite examples, we often use the power set $2^\\Omega$ as a modeling choice."
    ),
    "Uniform sampling of its rows does not imply": (
        "Uniform row sampling neither makes the source sentences an independent uniform "
        "sample nor eliminates annotation error."
    ),
    "The event $V=1$ contains the 16,935": (
        "The event $V=1$ contains 16,935 pronunciation rows with one vowel phone; the rows "
        "are outcomes, while 1 is their mapped value."
    ),
    "It does not turn the Cauchy family into an adequate model": (
        "The Cauchy family exposes expectation failure here; its support for negative "
        "durations makes it inadequate for vowel duration."
    ),
    "Until a particular family has been justified": (
        "Standard deviation is a root mean squared distance; guaranteed coverage requires "
        "a justified distribution family."
    ),
    "The teaching extract retains tokens whose lemma is": (
        "The extract retains *hangi*, *kim*, and *ne* tokens annotated as `nsubj` or `obj`; "
        "it does not infer missing dependencies."
    ),
    "The curves show how the reference changes with an empirically determined sample size": (
        "The curves use the vowel sample size to show how the reference changes with "
        "degrees of freedom."
    ),
    "With seed 20261018, increasing `diagnostic_n`": (
        "Increasing `diagnostic_n` from 10,000 to 100,000 reduces absolute errors to "
        "0.000146 (*hangi*), 0.000786 (*kim*), and 0.000640 (*ne*)."
    ),
    "Conditioning on modality does not remove the association": (
        "Within speech and writing, observed NP proportions remain higher for nonpronominal "
        "than pronominal subjects: 0.884 versus 0.404 and 0.987 versus 0.541."
    ),
    "A fixed numerical feature of a modeled population is a": (
        "A parameter describes the modeled population; an estimator is a sample rule; an "
        "estimate is that rule's realized value."
    ),
    "For this empirical sampling reference, the natural target": (
        "The empirical target is the median duration for adult-women /I/ tokens in the "
        "Hillenbrand cohort; a broader model targets the corresponding population median."
    ),
    "A 95% credible interval contains 95% posterior mass": (
        "A 95% credible interval contains 95% posterior mass; a 95% confidence procedure "
        "has 95% repeated-sampling coverage under its reference model."
    ),
    "the calculation runs the frozen random-walk computation": (
        "Four chains use 6,000 iterations, discard 1,000 as warmup, and share proposal "
        "covariance $(2.38^2/2)\\widehat\\Sigma$ estimated from the normalized PCT grid."
    ),
    "An elicited binary choice is not a grammaticality label": (
        "Binary choices, ordinal labels, counts, and rates require distinct response models; "
        "a count becomes a rate only after representing exposure."
    ),
    "Back-transforming a fitted log mean without the variance term": (
        "Without the variance term, back-transforming a fitted log mean targets the "
        "conditional median, not the arithmetic mean."
    ),
    "The centered cross-products measure whether deviations": (
        "Centered cross-products measure co-movement; dividing by centered $x$ variation "
        "yields change in $y$ per unit $x$."
    ),
    "For the PRS, we check three restrictions": (
        "For the PRS, we check a linear conditional mean, stable residual location across "
        "passages, and approximately normal residual shape."
    ),
    "The exact PCT program contains": (
        "The exact PCT program returns a transformed ratio, replicated responses, and "
        "pointwise log likelihoods."
    ),
    "the calculation below reconstructs the PCT": (
        "The PCT calculation normalizes a $321\\times321$ posterior grid and samples "
        "20,000 cells with posterior weights."
    ),
    "The complete code below uses the frozen seed": (
        "The PCT fit uses the frozen seed and the data-scaled proposal from the reference "
        "analysis."
    ),
    "the calculation below reconstructs those values": (
        "The observed Provo contrasts determine the four data-scaled initial values used "
        "in the reference fit."
    ),
    "We select the actual MALD items nearest three observed frequency quantiles": (
        "Three observed MALD items near the 10th, 50th, and 90th frequency quantiles "
        "anchor the matrix calculation in attested predictor combinations."
    ),
    "The complete matrix contains": (
        "The complete MALD design matrix has one intercept column and three columns of "
        "observed centered item properties."
    ),
    "where $q_{.75}$ is computed in the displayed code": (
        "where $q_{.75}=8$ phones is the observed third quartile in CMUdict."
    ),
    "where the displayed code sets $d$ to the observed median": (
        "where $d$ is the empirical median of the adult-women /I/ durations."
    ),
    "which the displayed code evaluates as 40.712 phones squared": (
        "which equals 40.712 phones squared for the empirical CMUdict PMF."
    ),
    "This is the population variance of the finite empirical distribution": (
        "The denominator is the number of CMUdict entries because this variance describes "
        "the complete finite release, rather than an external population sample."
    ),
    "The finite-release claim concerns the qualifying annotated tokens in BOUN 2.18": (
        "The finite-release claim concerns the qualifying annotated tokens in BOUN 2.18, "
        "whose exact parameter is computed from the release."
    ),
    "Using the empirical first and third quartiles as the thresholds, the displayed code returns": (
        "Under the empirical quartile thresholds, "
        "$\\mathbb{P}(q_{.25}<D\\leq q_{.75})=0.511$; ties at the lower threshold matter "
        "because the event is open on the left."
    ),
    "The following code reconstructs the PCT grid": (
        "The normalized PCT grid supplies the proposal covariance for the first 25 "
        "recorded transitions; the full sampler is developed with Metropolis--Hastings."
    ),
    "The following code reads the actual production draws": (
        "The diagnostic draws come from the production PCT fit, retain chain identity, "
        "and exclude warmup."
    ),
    "With row and column margins fixed, one cell determines the remaining cells": (
        "With margins fixed, let $A$ be the front-vowel/*t*-initial count. Under conditional "
        "independence,"
    ),
    "The course table does not retain the individual correct trials used in this sequence": (
        "For item $i$, the table retains only $n_i$, $\\overline y_i$, and $s_i^2$. The identity"
    ),
}

QUESTION_TEXT_OVERRIDES = {
    "Use the displayed code to verify how many rows belong to each speaker. Why does that "
    "make `speaker_id` an incomplete observation key?": (
        "How many rows belong to each speaker, and why does that make `speaker_id` an "
        "incomplete observation key?"
    ),
    "Use the empirical calculation to identify the ten most frequent word forms and report their observed counts.": (
        "Which ten word forms are most frequent in the observed Turkish BOUN release, and "
        "what are their counts?"
    ),
    "Use the empirical calculation to compute $\\widehat{\\mathbb{P}}(L=\\textit{kim})$.": (
        "Compute $\\widehat{\\mathbb{P}}(L=\\textit{kim})$ from the observed *kim* count "
        "and the 167 retained tokens."
    ),
    "Are the three lemma events exhaustive in the extract? Use code rather than the README count.": (
        "Do the six observed lemma-relation cell counts show that the three lemma events "
        "are exhaustive?"
    ),
}

FIGURE_TRANSCRIPT_OVERRIDES = {
    "statistical-inference/independent-sampling.qmd": (
        "The register-specific accusative proportions vary around the pooled estimate. "
        "That variation is what the shared-$p$ model suppresses."
    ),
    "statistical-inference/pronoun-case-example.qmd": (
        "The red line is the pooled accusative proportion. The register-specific points "
        "show why one shared probability may be too restrictive."
    ),
}


def full_transcript_prose(text: str) -> str:
    """Preserve a note paragraph as complete classroom prose."""

    value = TRANSCRIPT_UI_RE.sub(" ", text or "")
    value = normalize_prose(value).strip()
    if not value:
        return ""
    sentences: list[str] = []
    for sentence in split_sentences(value):
        sentence = sentence.strip()
        if not sentence:
            continue
        if sentence.endswith(";"):
            sentences.append(sentence[:-1].rstrip() + ".")
        elif re.search(r"[.!?](?:[\"'”’)]*)$", sentence):
            sentences.append(sentence)
        elif not TRANSCRIPT_FRAGMENT_END_RE.search(sentence) and not sentence.endswith(":"):
            sentences.append(sentence + ".")
        else:
            sentences.append(sentence)
    return " ".join(sentences)


def capitalize_slide_sentence(text: str) -> str:
    """Capitalize prose excerpted from the middle of a note sentence."""

    text = text.strip()
    if not text or text.startswith(("$", "`", "\\")):
        return text
    first_letter = re.search(r"[A-Za-z]", text)
    if first_letter and first_letter.group(0).islower():
        offset = first_letter.start()
        return text[:offset] + first_letter.group(0).upper() + text[offset + 1 :]
    return text


def compact_clause(sentence: str, limit: int = 32) -> str:
    """Extract a grammatical, visibly compact clause from one note sentence."""

    sentence = sentence.strip()
    sentence = re.sub(r"^(?:And|But|Thus|Note that)\s+", "", sentence, flags=re.I)
    sentence = capitalize_slide_sentence(sentence)
    if visible_words(sentence) <= limit:
        return sentence

    # Semicolon- and dash-delimited clauses are usually independently readable.
    clauses = [part.strip(" ,;:") for part in re.split(r"\s*[;—]\s*", sentence)]
    viable = [
        part for part in clauses
        if 6 <= visible_words(part) <= limit
        and not TRANSCRIPT_FRAGMENT_END_RE.search(part)
    ]
    if viable:
        chosen = capitalize_slide_sentence(viable[-1])
        return chosen if re.search(r"[.!?]$", chosen) else chosen + "."

    # A colon often separates a compact claim from details that belong in the transcript.
    if ":" in sentence:
        before, after = (part.strip() for part in sentence.split(":", 1))
        for candidate in (before, after):
            if 6 <= visible_words(candidate) <= limit and not TRANSCRIPT_FRAGMENT_END_RE.search(candidate):
                candidate = capitalize_slide_sentence(candidate)
                return candidate if re.search(r"[.!?]$", candidate) else candidate + "."

    # Keep the slide visibly light without pretending the excerpt is a full sentence.
    words = sentence.split()
    return " ".join(words[:limit]).rstrip(" ,;:.") + " …"


def slide_point_override(text: str) -> str:
    """Return a reviewed compact claim for prose that should not be excerpted mechanically."""

    value = normalize_prose(text)
    for excerpt, override in SLIDE_POINT_TEXT_OVERRIDES.items():
        if excerpt in value:
            return override
    return ""


def transcript_for_prose(text: str) -> str:
    """Use reviewed replacements in speech when the original refers to omitted slide code."""

    return full_transcript_prose(slide_point_override(text) or text)


def figure_transcript(text: str) -> str:
    """Turn a terse figure caption into one speakable classroom sentence."""

    value = full_transcript_prose(text).strip()
    if not value:
        return "This figure shows the observed linguistic data."
    if re.search(
        r"\b(?:is|are|was|were|shows?|plots?|compares?|marks?|indicates?|varies?|"
        r"increases?|decreases?|contains?|exceeds?|remains?)\b",
        value,
        re.I,
    ):
        return value
    value = value.rstrip(".")
    first = re.search(r"[A-Za-z]", value)
    if first:
        offset = first.start()
        value = value[:offset] + first.group(0).lower() + value[offset + 1 :]
    return f"This figure shows {value}."


def main_point_for_slide(text: str, limit: int = 32) -> str:
    """Boil one prose paragraph down to its main visible claim."""

    value = normalize_prose(text)
    override = slide_point_override(value)
    if override:
        return override
    sentences = [
        sentence.strip()
        for sentence in split_sentences(value)
        if sentence.strip() and not TRANSCRIPT_UI_RE.search(sentence)
    ]
    if not sentences:
        return ""
    substantive = [s for s in sentences if not NAVIGATION_SENTENCE_RE.search(s)] or sentences
    # ASW paragraphs tend to land the upshot in the final sentence.  A paper-specific
    # attribution remains visible when it is the premise on which the paragraph turns.
    citation_sentences = [
        s for s in substantive
        if re.search(r"\b[A-Z][A-Za-z-]+(?: et al\.)? \(\d{4}[a-z]?\)", s)
        and re.search(r"\b(?:follow|report|describe|define|introduce|show|argue|estimate)\w*\b", s, re.I)
    ]
    chosen = citation_sentences[0] if citation_sentences else substantive[-1]
    compact = compact_clause(chosen, limit)
    if compact.endswith("…"):
        shorter = [
            sentence for sentence in reversed(substantive)
            if 6 <= visible_words(sentence) <= limit
            and not TRANSCRIPT_FRAGMENT_END_RE.search(sentence)
        ]
        if shorter:
            return shorter[0]
    return compact


def extract_urls(text: str) -> list[str]:
    urls = re.findall(r"https?://[^\s)>]+", text)
    cleaned = [url.rstrip(".,;:\"'") for url in urls]
    return list(dict.fromkeys(cleaned))


def parse_section(title: str, raw: str) -> Section:
    fig_captions: list[str] = []
    code = re.findall(r"```\{r[^}]*\}\s*\n(.*?)```", raw, flags=re.S)
    # Code remains explicit in the notes, but a full program is not prose and
    # must not be squeezed onto a concept slide.  Figures generated by R chunks
    # are added separately from the authenticated note render.
    def replace_r_chunk(match: re.Match[str]) -> str:
        chunk = match.group(0)
        caption_match = re.search(
            r'(?m)^#\|\s*fig-cap:\s*["\']?(.*?)["\']?\s*$',
            chunk,
        )
        produces_plot = bool(re.search(r"\b(?:ggplot|plot|hist|qqnorm|pairs)\s*\(", chunk))
        if not caption_match and not produces_plot:
            return "\n"
        caption = (
            normalize_prose(caption_match.group(1))
            if caption_match
            else f"Observed linguistic data for {title}."
        )
        marker = len(fig_captions)
        fig_captions.append(caption)
        return f"\n@@FIGURE_BLOCK_{marker}@@\n"

    working = re.sub(r"```\{r[^}]*\}.*?```", replace_r_chunk, raw, flags=re.S)
    working = re.sub(r"```[^\n]*\n.*?```", "\n", working, flags=re.S)
    lines = working.splitlines()
    blocks: list[ContentBlock] = []
    paragraph_lines: list[str] = []

    def flush_paragraph() -> None:
        nonlocal paragraph_lines
        paragraph = "\n".join(paragraph_lines).strip()
        paragraph_lines = []
        if not paragraph or paragraph.startswith("#"):
            return
        prose = normalize_prose(paragraph)
        if prose:
            blocks.append(ContentBlock("prose", prose))

    index = 0
    in_answer_details = False
    while index < len(lines):
        stripped = lines[index].strip()
        if not stripped:
            flush_paragraph()
            index += 1
            continue
        figure_marker = re.fullmatch(r"@@FIGURE_BLOCK_(\d+)@@", stripped)
        if figure_marker:
            flush_paragraph()
            marker = int(figure_marker.group(1))
            blocks.append(ContentBlock("figure", fig_captions[marker]))
            index += 1
            continue
        if re.match(r"^<details\b[^>]*\bunderstanding-answers\b", stripped, re.I):
            flush_paragraph()
            in_answer_details = True
            index += 1
            continue
        if in_answer_details and re.match(r"^</details>\s*$", stripped, re.I):
            flush_paragraph()
            in_answer_details = False
            index += 1
            continue
        if in_answer_details and re.match(r"^<summary>.*</summary>\s*$", stripped, re.I):
            flush_paragraph()
            index += 1
            continue
        if stripped.startswith(":::") or re.match(r"^#(?!#)\s*\|", stripped):
            flush_paragraph()
            index += 1
            continue
        if stripped == "$$" or stripped.startswith("$$"):
            flush_paragraph()
            math_lines: list[str] = []
            if stripped != "$$":
                remainder = stripped[2:]
                if remainder.endswith("$$"):
                    blocks.append(ContentBlock("math", remainder[:-2].strip()))
                    index += 1
                    continue
                math_lines.append(remainder)
            index += 1
            while index < len(lines):
                current = lines[index]
                if current.strip().endswith("$$"):
                    closing = current.rstrip()
                    if closing.strip() != "$$":
                        math_lines.append(closing[: closing.rfind("$$")])
                    break
                math_lines.append(current)
                index += 1
            blocks.append(ContentBlock("math", "\n".join(math_lines).strip()))
            index += 1
            continue
        if lines[index].lstrip().startswith("|"):
            flush_paragraph()
            table_lines: list[str] = []
            while index < len(lines) and lines[index].lstrip().startswith("|"):
                table_lines.append(lines[index].rstrip())
                index += 1
            if len(table_lines) >= 2:
                blocks.append(ContentBlock("table", "\n".join(table_lines)))
            continue
        question = re.match(r"^\s*(\d+)[.)]\s+(.+)$", lines[index])
        if question:
            flush_paragraph()
            value = question.group(2).strip()
            index += 1
            while index < len(lines):
                continuation = lines[index]
                if not continuation.strip() or re.match(r"^\s*\d+[.)]\s+", continuation):
                    break
                if continuation.startswith(" ") or continuation.startswith("\t"):
                    value += " " + continuation.strip()
                    index += 1
                else:
                    break
            block_kind = (
                "answer"
                if in_answer_details
                else "question"
                if re.fullmatch(r"(?:Check your understanding|Test the distinction)", title, re.I)
                else "list_item"
            )
            blocks.append(ContentBlock(
                block_kind,
                normalize_prose(value),
                int(question.group(1)),
            ))
            continue
        paragraph_lines.append(lines[index])
        index += 1
    flush_paragraph()

    prose_chunks = [
        block.value
        for block in blocks
        if block.kind in {"prose", "question", "answer", "list_item"}
    ]
    math = [block.value for block in blocks if block.kind == "math"]
    tables = [block.value for block in blocks if block.kind == "table"]
    return Section(
        title=title,
        raw=raw,
        prose=prose_chunks,
        math=math,
        tables=tables,
        code=code,
        fig_captions=fig_captions,
        blocks=blocks,
    )


class RenderedProseParser(HTMLParser):
    """Collect evaluated paragraphs and list items from Quarto's main content."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.in_main = False
        self.main_depth = 0
        self.skip_depth = 0
        self.section = "Overview"
        self.sections: list[tuple[str, list[str]]] = [(self.section, [])]
        self.heading: list[str] | None = None
        self.capture: list[str] | None = None
        self.capture_tag: str | None = None
        self.capture_depth = 0
        self.display_math = False
        self.math_stack: list[bool] = []

    VOID_TAGS = {
        "area", "base", "br", "col", "embed", "hr", "img", "input",
        "link", "meta", "param", "source", "track", "wbr",
    }

    # These elements belong to Quarto's reading interface rather than to the
    # course prose.  If they enter the evaluated-prose stream, labels such as
    # "Show All Code" become lecture content and can also create sentence
    # fragments around code blocks.
    UI_TAGS = {"button", "details", "summary"}
    UI_CLASS_PARTS = {
        "code-tools", "code-fold", "code-copy", "code-summary",
        "quarto-title-meta", "anchorjs", "clipboard",
    }

    @staticmethod
    def attrs_dict(attrs: list[tuple[str, str | None]]) -> dict[str, str]:
        return {key: value or "" for key, value in attrs}

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        values = self.attrs_dict(attrs)
        classes = set(values.get("class", "").split())
        if tag == "main" and values.get("id") == "quarto-document-content":
            self.in_main = True
            self.main_depth = 1
            return
        if not self.in_main:
            return
        if tag not in self.VOID_TAGS:
            self.main_depth += 1
        if self.skip_depth:
            if tag not in self.VOID_TAGS:
                self.skip_depth += 1
            return
        ui_class = any(
            part in class_name
            for class_name in classes
            for part in self.UI_CLASS_PARTS
        )
        if tag in {"nav", "script", "style", "pre"} or tag in self.UI_TAGS or (
            tag == "div" and ({"cell", "sourceCode"} & classes)
        ) or ui_class:
            self.skip_depth = 1
            return
        if tag == "h2":
            self.heading = []
            return
        if tag in {"p", "li"}:
            if self.capture is None:
                self.capture = []
                self.capture_tag = tag
                self.capture_depth = 1
                self.display_math = False
            else:
                self.capture_depth += 1
            return
        if tag == "span" and self.capture is not None and "math" in classes:
            is_display = "display" in classes
            self.math_stack.append(is_display)
            self.display_math = self.display_math or is_display
            self.capture.append("$$" if is_display else "$")
        elif tag == "code" and self.capture is not None:
            self.capture.append("`")
        elif tag == "em" and self.capture is not None:
            self.capture.append("*")
        elif tag == "strong" and self.capture is not None:
            self.capture.append("**")

    def handle_endtag(self, tag: str) -> None:
        if not self.in_main:
            return
        if self.skip_depth:
            self.skip_depth -= 1
        elif tag == "h2" and self.heading is not None:
            self.section = normalize_prose("".join(self.heading)) or "Overview"
            self.sections.append((self.section, []))
            self.heading = None
        elif tag == "span" and self.capture is not None and self.math_stack:
            is_display = self.math_stack.pop()
            self.capture.append("$$" if is_display else "$")
        elif tag == "code" and self.capture is not None:
            self.capture.append("`")
        elif tag == "em" and self.capture is not None:
            self.capture.append("*")
        elif tag == "strong" and self.capture is not None:
            self.capture.append("**")
        elif tag in {"p", "li"} and self.capture is not None:
            self.capture_depth -= 1
            if self.capture_depth == 0 and tag == self.capture_tag:
                value = re.sub(r"\s+", " ", "".join(self.capture)).strip()
                if (
                    value
                    and not self.display_math
                    and not re.search(r"\b(?:Show|Hide) All Code\b", value, re.I)
                ):
                    self.sections[-1][1].append(value)
                self.capture = None
                self.capture_tag = None
                self.display_math = False
        if tag == "main":
            self.in_main = False
            self.main_depth = 0
        elif self.main_depth:
            self.main_depth -= 1

    def handle_data(self, data: str) -> None:
        if not self.in_main or self.skip_depth:
            return
        if self.heading is not None:
            self.heading.append(data)
        elif self.capture is not None:
            self.capture.append(data)


def render_receipt(path: Path) -> dict:
    if not RENDER_RECEIPTS.exists():
        raise RuntimeError(
            "Missing decks/note-render-receipts.json. Run "
            "scripts/render_staged_notes.py before rebuilding slides."
        )
    receipts = json.loads(RENDER_RECEIPTS.read_text(encoding="utf-8"))
    page = str(path.relative_to(ROOT))
    receipt = receipts.get("pages", {}).get(page)
    if not receipt:
        raise RuntimeError(f"No authenticated render receipt for {page}")
    if receipt.get("source_sha256") != sha256(path):
        raise RuntimeError(f"Rendered HTML is stale for {page}: source hash changed")
    rendered_path = ROOT / "docs" / path.relative_to(ROOT).with_suffix(".html")
    if not rendered_path.exists():
        raise RuntimeError(f"Authenticated rendered HTML is missing for {page}")
    if receipt.get("html_sha256") != sha256(rendered_path):
        raise RuntimeError(f"Rendered HTML hash no longer matches its receipt for {page}")
    return receipt


def rendered_prose(path: Path) -> list[tuple[str, list[str]]]:
    rendered_path = ROOT / "docs" / path.relative_to(ROOT).with_suffix(".html")
    render_receipt(path)
    parser = RenderedProseParser()
    parser.feed(rendered_path.read_text(encoding="utf-8"))
    return parser.sections


def prose_match_key(text: str) -> str:
    text = text.replace("[[INLINE-R-NOT-EVALUATED]]", " ")
    text = re.sub(r"\$[^$]*\$", " ", text)
    text = re.sub(r"[`*_#>\[\](){}]", " ", text)
    return re.sub(r"\W+", " ", text.casefold()).strip()


def evaluated_paragraph(source: str, candidates: list[str], path: Path, title: str) -> str:
    """Find the rendered counterpart of one source paragraph with inline R."""

    source_key = prose_match_key(source)
    if not candidates:
        raise RuntimeError(
            f"No evaluated prose is available for inline R in "
            f"{path.relative_to(ROOT)} / {title}"
        )
    if not source_key:
        raise RuntimeError(
            f"Inline-R paragraph has no stable prose anchor in "
            f"{path.relative_to(ROOT)} / {title}"
        )
    scored = [
        (difflib.SequenceMatcher(None, source_key, prose_match_key(candidate)).ratio(), candidate)
        for candidate in candidates
    ]
    score, match = max(scored, key=lambda item: item[0])
    if score < 0.28:
        raise RuntimeError(
            f"Could not align evaluated inline-R prose in {path.relative_to(ROOT)} / "
            f"{title} (best similarity {score:.2f})"
        )
    return match


def parse_note(path: Path) -> tuple[str, list[Section], list[str]]:
    raw = path.read_text(encoding="utf-8")
    frontmatter, body = split_frontmatter(raw)
    title = yaml_title(frontmatter, path.stem.replace("-", " ").title())
    matches = list(re.finditer(r"(?m)^##\s+(.+?)\s*$", body))
    sections: list[Section] = []
    if matches:
        sections.append(parse_section("Overview", body[: matches[0].start()]))
        for i, match in enumerate(matches):
            start = match.end()
            end = matches[i + 1].start() if i + 1 < len(matches) else len(body)
            heading = re.sub(r"\s*\{.*\}\s*$", "", match.group(1)).strip()
            sections.append(parse_section(heading, body[start:end]))
    else:
        sections.append(parse_section("Overview", body))
    evaluated = rendered_prose(path)
    if len(evaluated) != len(sections):
        raise RuntimeError(
            f"Rendered/source section mismatch for {path.relative_to(ROOT)}: "
            f"{len(evaluated)} rendered versus {len(sections)} source sections"
        )
    for section, (_, candidates) in zip(sections, evaluated):
        # Source prose is authoritative for mathematical notation.  Rendered
        # HTML is used only for paragraphs that contain inline R, because the
        # HTML supplies the evaluated value.  This prevents the HTML math
        # renderer from erasing or rewriting TeX before it reaches a slide.
        for block in section.blocks:
            if block.kind in {"prose", "question", "answer", "list_item"} and "[[INLINE-R-NOT-EVALUATED]]" in block.value:
                block.value = evaluated_paragraph(block.value, candidates, path, section.title)
        section.prose = [
            block.value
            for block in section.blocks
            if block.kind in {"prose", "question", "answer", "list_item"}
        ]
        section.math = [block.value for block in section.blocks if block.kind == "math"]
        section.tables = [block.value for block in section.blocks if block.kind == "table"]
    sections = [section for section in sections if section.prose or section.math or section.tables or section.code]
    for section in sections:
        if any("[[INLINE-R-NOT-EVALUATED]]" in value for value in section.prose):
            raise RuntimeError(
                f"Inline R remained unevaluated in {path.relative_to(ROOT)} / {section.title}"
            )
    return title, sections, extract_urls(raw)


def registry_maps(decks: dict[str, dict]) -> tuple[dict[str, list[str]], dict[str, str]]:
    figures: dict[str, list[str]] = {}
    datasets: dict[str, str] = {}
    for rel in REGISTRIES:
        registry_path = ROOT / rel
        if not registry_path.exists():
            continue
        output_dir = registry_path.parent
        prefix = REGISTRY_PREFIX[output_dir.name]
        with registry_path.open(newline="", encoding="utf-8") as handle:
            for row in csv.DictReader(handle):
                page = row.get("page", "").strip()
                if not page:
                    continue
                page_key = page if "/" in page or not prefix else f"{prefix}/{page}"
                datasets[page_key] = row.get("dataset", "").strip()
                figure_text = ";".join(
                    value for value in row.values()
                    if value and re.search(r"\.(?:png|pdf)(?:\s*;|$)", value, re.I)
                )
                for filename in re.split(r"\s*;\s*", figure_text):
                    if not filename or filename.casefold() in {"na", "none"}:
                        continue
                    candidate = output_dir / filename
                    if candidate.suffix.casefold() == ".pdf":
                        generated = ROOT / "decks/shared/generated-figures/generalized" / f"{candidate.stem}.png"
                        candidate = generated
                    if candidate.exists():
                        figures.setdefault(page_key, []).append(str(candidate.relative_to(ROOT)))
    for key, paths in MANUAL_FIGURES.items():
        figures.setdefault(key, [])
        for path in paths:
            if (ROOT / path).exists() and path not in figures[key]:
                figures[key].append(path)

    # A note-rendered figure is the strongest possible alignment evidence.  If
    # one exists, prefer the complete ordered set of those figures to the
    # reference-analysis fallback.  The reference outputs remain useful for
    # pages whose notes have not been rendered independently.
    every_page = [page for config in decks.values() for page in config["pages"]]
    for page in every_page:
        receipt = render_receipt(ROOT / page)
        rendered = [
            figure for figure in receipt.get("figures", [])
            if (ROOT / figure).exists()
        ]
        if rendered:
            figures[page] = list(dict.fromkeys(rendered))
    return figures, datasets


def dataset_for_page(page: str, note_text: str, registry_dataset: str) -> tuple[str, tuple[str, str, str]] | None:
    # Prefer what the current note actually analyzes.  The registries include
    # some inherited running-example labels, so concatenating the registry and
    # page text can mislabel a page precisely where the running dataset changes.
    note_haystack = note_text.casefold()
    registry_haystack = registry_dataset.casefold()
    aliases = [
        ("Hillenbrand et al. (1995)", ["hillenbrand"]),
        ("UD Turkish BOUN", ["ud turkish boun", "boun treebank"]),
        ("Turkish UniMorph", ["turkish unimorph", "unimorph"]),
        ("CMUdict", ["cmudict"]),
        ("English dative", ["english dative", "dative alternation"]),
        ("MegaOrientation", ["megaorientation", "mega-orientation"]),
        ("MegaVeridicality", ["megaveridicality"]),
        ("MegaNegRaising", ["meganegraising", "mega-negraising"]),
        ("SuperTelicity", ["supertelicity"]),
        ("Turkish PropBank", ["turkish propbank"]),
        ("UDS", ["universal decompositional semantics", "uds natural"]),
        ("Provo", ["provo"]),
        ("MALD", ["mald"]),
        ("Natural Stories", ["natural stories"]),
        ("UCCA", ["ucca"]),
        ("ManyBabies", ["manybabies"]),
        ("Peterson-Barney", ["peterson", "barney", "pb52"]),
        ("PHOIBLE", ["phoible"]),
        ("VALEX", ["valex", "megaacceptability"]),
        ("Jacy", ["jacy", "tanaka"]),
        ("Nettle", ["nettle"]),
        ("Storme", ["storme", "liaison"]),
    ]
    page_matches: list[tuple[int, int, str]] = []
    for alias_index, (name, needles) in enumerate(aliases):
        positions = [note_haystack.find(needle) for needle in needles]
        positions = [position for position in positions if position >= 0]
        if positions:
            page_matches.append((min(positions), alias_index, name))
    if page_matches:
        _, _, name = min(page_matches)
        return name, DATASET_SOURCES[name]
    for name, needles in aliases:
        if any(needle in registry_haystack for needle in needles):
            return name, DATASET_SOURCES[name]
    return None


def relative_figure(deck: str, repo_relative: str) -> str:
    target = ROOT / repo_relative
    return str(Path("../..") / target.relative_to(ROOT))


def materialize_math(page: str, equation: str) -> str:
    for expression, value in INLINE_R_MATH.get(page, {}).items():
        equation = equation.replace(expression, value)
    return equation


TRANSCRIPT_UI_RE = re.compile(r"\b(?:Show|Hide) All Code\b", re.I)
TRANSCRIPT_FRAGMENT_END_RE = re.compile(
    r"\b(?:and|or|but|as|at|by|for|from|if|in|is|are|was|were|of|than|that|then|to|with|"
    r"call|calls|called|define|defines|denote|denotes|give|gives|let|where|when)\s*[:;,]?$",
    re.I,
)


def transcript_prose(text: str, word_limit: int = 90) -> str:
    """Return complete, classroom-speakable sentences from evaluated prose."""

    if not text:
        return ""
    value = re.sub(r"\$\$.*?\$\$", " ", text, flags=re.S)
    value = TRANSCRIPT_UI_RE.sub(" ", value)
    value = normalize_prose(value).strip()
    if not value:
        return ""

    sentences = split_sentences(value)
    chosen: list[str] = []
    words = 0
    for sentence in sentences:
        sentence = sentence.strip()
        if not sentence or TRANSCRIPT_UI_RE.search(sentence):
            continue
        if TRANSCRIPT_FRAGMENT_END_RE.search(sentence) or sentence.endswith(":"):
            continue
        count = visible_words(sentence)
        if count < 5:
            continue
        if chosen and words + count > word_limit:
            break
        chosen.append(sentence if re.search(r"[.!?]$", sentence) else sentence + ".")
        words += count
        if words >= word_limit:
            break
    return " ".join(chosen)


def transcript_choice(key: str, options: list[str]) -> str:
    index = int(hashlib.sha256(key.encode()).hexdigest()[:8], 16) % len(options)
    return options[index]


def math_lead_in(text: str) -> str:
    """Turn a source lead-in such as 'The OLS objective is' into speech."""

    value = TRANSCRIPT_UI_RE.sub(" ", text or "")
    value = re.sub(r"\$\$.*?\$\$", " ", value, flags=re.S)
    value = normalize_prose(value).strip()
    if not value or value.casefold() in {"and", "or", "then"} or visible_words(value) < 2:
        return ""
    complete = transcript_prose(value, 90)
    if complete:
        return complete
    if re.match(r"^For\b", value) and value.endswith(","):
        return value.rstrip(",") + ", the slide defines:"
    return value.rstrip(" ,;:") + ":"


def equation_comment(equation: str, topic: str) -> str:
    """Give a short equation-specific cue when the note has no usable lead-in."""

    if r"\mathbb{P}" in equation:
        return "The probability measure applies to the event shown inside its parentheses."
    if r"\mathbb{E}" in equation:
        return "The expectation is taken over the empirical random variable defined in this section."
    if r"\operatorname{Var}" in equation:
        return "The variance keeps the squared deviation on the scale defined by the data."
    if r"\operatorname{Cov}" in equation:
        return "The covariance compares paired deviations from the two empirical means."
    if r"\widehat y" in equation or r"\widehat{y}" in equation:
        return "The fitted value is the model prediction for the corresponding observed unit."
    if r"\widehat" in equation:
        return "The hat marks a quantity estimated from the named linguistic observations."
    if r"\int" in equation:
        return "The integral aggregates over the support specified by the empirical variable."
    if r"\sum" in equation:
        return "The sum runs over the observational units defined for this analysis."
    if any(token in equation for token in (r"\le", r"\ge", "<", ">")):
        return "These bounds specify the values that the empirical quantity may take."
    return f"This is the mathematical statement used in {topic.casefold()}."


def teacher_transcript(title: str, visible: str, supporting: str = "", role: str = "concept") -> str:
    main = transcript_prose(visible, 72)
    support = full_transcript_prose(supporting)
    if support and main and support.casefold() in main.casefold():
        support = ""
    topic = re.sub(r"\s*:\s*equation\s+\d+\s*$", "", title, flags=re.I).strip()
    if role == "section":
        clean_title = title.rstrip(".!?")
        return transcript_choice(title, [
            f"Next, we take up {clean_title}.",
            f"Now we turn to {clean_title}.",
            f"The next topic is {clean_title}.",
            f"Our next step is {clean_title}.",
        ])
    if role == "figure":
        return support or main or f"The plot shows the observed comparison for {title.casefold()}."
    if role == "math":
        equation = visible.strip()
        lead = math_lead_in(supporting)
        if lead:
            return f"{lead}\n\n{equation}"
        return f"{equation}\n\n{equation_comment(equation, topic)}"
    if role == "table":
        return support or "Read the row and column labels before comparing the observed entries."
    if role == "check":
        return main or support or "Answer the question using the named dataset."
    if main and support and support.casefold() not in main.casefold():
        return f"{main} {support}"
    if main:
        return main
    if support:
        return support
    return f"This slide introduces {title.casefold()}."


CHECK_SECTION_RE = re.compile(r"^(?:check your understanding|test the distinction)\s*$", re.I)
CONTINUATION_START_RE = re.compile(
    r"^(?:which|where|whereas|when|whose|that|with|so(?: that)?|then|and|or|but|because|"
    r"rather than|for every|in general|estimated by|meaning|means|normalizes?|removes?|"
    r"shows?|turns?|allows?|two summaries|contains?|corresponds?|gives?|yields?|is|are|"
    r"has|have)\b",
    re.I,
)


def continuation_match_text(text: str) -> str:
    """Remove presentation markup before testing a grammatical continuation."""

    return re.sub(r"^[*_>`\s]+", "", normalize_prose(text).strip())


def is_open_lead(text: str) -> bool:
    value = normalize_prose(text).strip()
    return bool(
        value.endswith((":", ",", ";"))
        or TRANSCRIPT_FRAGMENT_END_RE.search(value)
        or re.search(r"\b(?:equals?|becomes?|is given by|can be written as|corresponds to)\s*$", value, re.I)
    )


def is_math_bridge(text: str) -> bool:
    """Return whether a short prose block grammatically introduces math after it."""

    value = continuation_match_text(text)
    if is_open_lead(value):
        return True
    if re.search(r"[.!?]$", value):
        return False
    return bool(
        CONTINUATION_START_RE.search(value)
        or re.match(r"[a-z]", value)
        or (
            visible_words(value) <= 10
            and re.search(
                r"\b(?:and thus|thus|which yields|has (?:probability )?mass|"
                r"mass function|is given by|becomes|equals|takes the form)\s*$",
                value,
                re.I,
            )
        )
    )


def continuation_sentence(text: str) -> str:
    sentences = [sentence.strip() for sentence in split_sentences(normalize_prose(text)) if sentence.strip()]
    if not sentences:
        return ""
    candidate = continuation_match_text(sentences[0])
    if not (CONTINUATION_START_RE.search(candidate) or re.match(r"[a-z]", candidate)):
        return ""
    return sentences[0]


def math_lead_for_slide(text: str, limit: int = 30) -> str:
    """Keep the clause that introduces an equation without copying a full note paragraph."""

    value = normalize_prose(text)
    if visible_words(value) <= limit:
        return value
    sentences = [sentence.strip() for sentence in split_sentences(value) if sentence.strip()]
    if sentences and is_open_lead(sentences[-1]):
        return sentences[-1]
    return main_point_for_slide(value, limit)


def ordered_section_units(section: Section) -> list[tuple[str, list[ContentBlock]]]:
    """Group source-order blocks into coherent teaching units.

    A prose lead-in, its displayed equation, and a grammatically dependent
    continuation form one unit.  This prevents equations from severing the
    sentences that introduce and interpret them.
    """

    units: list[tuple[str, list[ContentBlock]]] = []
    stream = [ContentBlock(block.kind, block.value, block.number) for block in section.blocks]
    index = 0
    while index < len(stream):
        block = stream[index]
        if block.kind == "prose" and index + 1 < len(stream) and stream[index + 1].kind == "list_item":
            group = [block]
            index += 1
            while index < len(stream) and stream[index].kind == "list_item":
                group.append(stream[index])
                index += 1
            units.append(("list", group))
            continue
        if (
            block.kind == "prose"
            and is_open_lead(block.value)
            and index + 1 < len(stream)
            and stream[index + 1].kind == "prose"
        ):
            units.append(("prose_group", [block, stream[index + 1]]))
            index += 2
            continue
        starts_math_chain = block.kind == "math" or (
            block.kind == "prose"
            and index + 1 < len(stream)
            and stream[index + 1].kind == "math"
        )
        if starts_math_chain:
            group: list[ContentBlock] = []
            if block.kind == "prose":
                group.append(block)
                index += 1
            while index < len(stream) and stream[index].kind == "math":
                group.append(stream[index])
                index += 1
                if index >= len(stream) or stream[index].kind != "prose":
                    continue
                follow = stream[index]
                continuation = continuation_sentence(follow.value)
                if not continuation:
                    break
                normalized_follow = normalize_prose(follow.value)
                followed_by_math = index + 1 < len(stream) and stream[index + 1].kind == "math"
                group.append(ContentBlock("prose", continuation))
                remainder = normalized_follow[len(continuation):].strip()
                if remainder:
                    stream[index] = ContentBlock("prose", remainder)
                else:
                    index += 1
                # A short bridge belongs with the equation after it.  A closed
                # continuation completes the current chain and leaves any
                # later sentence to introduce the next unit.
                if followed_by_math and is_math_bridge(continuation) and not remainder:
                    continue
                break
            units.append(("math", group))
            continue
        units.append((block.kind, [block]))
        index += 1
    return units


def chunk_math_blocks(blocks: list[ContentBlock], max_equations: int = 4) -> list[list[ContentBlock]]:
    """Split a long equation chain without orphaning its connective prose."""

    chunks: list[list[ContentBlock]] = []
    current: list[ContentBlock] = []
    equation_count = 0
    for block in blocks:
        if block.kind == "math" and equation_count >= max_equations:
            bridge: list[ContentBlock] = []
            if current and current[-1].kind == "prose" and is_math_bridge(current[-1].value):
                bridge = [current.pop()]
            if current:
                chunks.append(current)
            current = bridge
            equation_count = 0
        current.append(block)
        if block.kind == "math":
            equation_count += 1
    if current:
        chunks.append(current)
    return chunks


def make_note_slides(
    module: str,
    page: str,
    figures: dict[str, list[str]],
    datasets: dict[str, str],
    introduced_datasets: set[str],
) -> list[Slide]:
    note_path = ROOT / page
    title, sections, urls = parse_note(note_path)
    note_hash = sha256(note_path)
    note_text = note_path.read_text(encoding="utf-8")
    dataset = dataset_for_page(page, note_text, datasets.get(page, ""))
    slides: list[Slide] = []
    serial = 1

    def add(title_text: str, visible: str, transcript: str, role: str, classes: str = "") -> None:
        nonlocal serial
        slide_id = f"{module}/{Path(page).stem}/{serial:02d}-{role}"
        slides.append(Slide(slide_id, title_text, visible, transcript, page,
                            note_hash, role, urls, classes))
        serial += 1

    overview = sections[0] if sections else Section("Overview", "")
    overview_support = overview.prose[0] if overview.prose else ""
    divider_visible = ""
    if dataset:
        _, (_, citation, source_url) = dataset
        divider_visible = f'<div class="source"><a href="{source_url}">{citation}</a></div>'
    add(title, divider_visible,
        teacher_transcript(title, title, overview_support, "section"),
        "section", ".section-slide")

    if dataset and dataset[0] not in introduced_datasets:
        dataset_name, (description, citation, source_url) = dataset
        introduced_datasets.add(dataset_name)
        visible = (
            f"The running data are {description}.\n\n"
            f'<div class="source"><a href="{source_url}">{citation}</a></div>'
        )
        transcript = (
            f"The data source is {citation}. It provides {description}."
        )
        add(f"{dataset_name}: the empirical object", visible, transcript, "dataset", ".compact")

    page_figures = list(dict.fromkeys(figures.get(page, [])))
    figure_index = 0
    for section_index, section in enumerate(sections):
        section_title = title if section.title == "Overview" else section.title
        if CHECK_SECTION_RE.match(section.title):
            questions = [block.value for block in section.blocks if block.kind == "question"]
            answers = [block.value for block in section.blocks if block.kind == "answer"]
            transitions = [block.value for block in section.blocks if block.kind == "prose"]
            if len(answers) != len(questions):
                raise RuntimeError(
                    f"Answer count mismatch for {page}: {len(answers)} answers for "
                    f"{len(questions)} questions"
                )
            for question_number, (question, answer) in enumerate(zip(questions, answers), start=1):
                question = normalize_prose(question)
                question = QUESTION_TEXT_OVERRIDES.get(question, question)
                question_title = f"{title}: question {question_number}"
                answer_title = f"{title}: answer {question_number}"
                add(
                    question_title,
                    question,
                    full_transcript_prose(question),
                    "question",
                    ".compact" if visible_words(question) > 34 else "",
                )
                answer_visible = main_point_for_slide(answer, 34)
                answer_transcript = full_transcript_prose(answer)
                if question_number == len(questions) and transitions:
                    answer_transcript = " ".join(
                        [answer_transcript]
                        + [full_transcript_prose(transition) for transition in transitions]
                    )
                add(
                    answer_title,
                    answer_visible,
                    answer_transcript,
                    "answer",
                    ".compact" if visible_words(answer_visible) > 30 else "",
                )
            continue

        table_number = 0
        for unit_kind, blocks in ordered_section_units(section):
            if unit_kind in {"question", "list_item"}:
                # Numbered lists outside an understanding-check section are content,
                # not an assessment sequence.
                paragraph = blocks[0].value
                visible = main_point_for_slide(paragraph, 32)
                if visible:
                    add(section_title, visible, full_transcript_prose(paragraph), "concept")
                continue
            if unit_kind == "list":
                lead = blocks[0].value
                items = blocks[1:]
                lead_visible = (
                    normalize_prose(lead)
                    if visible_words(lead) <= 18
                    else main_point_for_slide(lead, 24)
                )
                chunks: list[list[ContentBlock]] = []
                current: list[ContentBlock] = []
                for item in items:
                    candidate = current + [item]
                    candidate_words = visible_words(lead_visible) + sum(
                        visible_words(value.value) for value in candidate
                    )
                    if current and candidate_words > 48:
                        chunks.append(current)
                        current = [item]
                    else:
                        current = candidate
                if current:
                    chunks.append(current)
                for chunk_number, chunk in enumerate(chunks, start=1):
                    list_title = section_title
                    if len(chunks) > 1:
                        list_title += f" ({chunk_number} of {len(chunks)})"
                    visible_list = lead_visible + "\n\n" + "\n".join(
                        f"{item.number}. {main_point_for_slide(item.value, 34)}" for item in chunk
                    )
                    transcript_list = " ".join(
                        [transcript_for_prose(lead)]
                        + [transcript_for_prose(item.value) for item in chunk]
                    )
                    add(list_title, visible_list, transcript_list, "list", ".compact")
                continue
            if unit_kind == "prose_group":
                lead, completion = (block.value for block in blocks)
                lead_visible = (
                    normalize_prose(lead)
                    if visible_words(lead) <= 18
                    else main_point_for_slide(lead, 24)
                )
                completion_visible = (
                    normalize_prose(completion)
                    if visible_words(completion) <= 22
                    else main_point_for_slide(completion, 28)
                )
                visible_group = lead_visible + "\n\n" + completion_visible
                if visible_words(section_title + " " + visible_group) > 32:
                    visible_group = main_point_for_slide(
                        lead + " " + completion,
                        max(12, 32 - visible_words(section_title)),
                    )
                add(
                    section_title,
                    visible_group,
                    " ".join([transcript_for_prose(lead), transcript_for_prose(completion)]),
                    "concept",
                    ".compact",
                )
                continue
            if unit_kind == "prose":
                paragraph = blocks[0].value
                visible = main_point_for_slide(paragraph, 32)
                if visible and not (section.title == "Overview" and visible == title):
                    add(
                        section_title,
                        visible,
                        transcript_for_prose(paragraph),
                        "concept",
                        ".compact" if visible_words(visible) > 28 else "",
                    )
                continue
            if unit_kind == "math":
                math_chunks = chunk_math_blocks(blocks)
                for chunk_number, math_chunk in enumerate(math_chunks, start=1):
                    visible_parts: list[str] = []
                    transcript_parts: list[str] = []
                    equations: list[str] = []
                    for block_index, block in enumerate(math_chunk):
                        if block.kind == "math":
                            equation = materialize_math(page, block.value).strip()
                            equations.append(equation)
                            display = f"$$\n{equation}\n$$"
                            visible_parts.append(display)
                            transcript_parts.append(display)
                            continue
                        prose = block.value
                        reviewed_prose = slide_point_override(prose)
                        introduces_math = (
                            block_index + 1 < len(math_chunk)
                            and math_chunk[block_index + 1].kind == "math"
                        )
                        completes_math = (
                            block_index > 0
                            and math_chunk[block_index - 1].kind == "math"
                        )
                        if reviewed_prose:
                            visible_prose = reviewed_prose
                            transcript_prose_value = full_transcript_prose(reviewed_prose)
                        elif completes_math:
                            visible_prose = normalize_prose(prose)
                            transcript_prose_value = visible_prose
                        elif introduces_math:
                            visible_prose = math_lead_for_slide(prose)
                            transcript_prose_value = normalize_prose(prose)
                        elif is_math_bridge(prose):
                            visible_prose = normalize_prose(prose)
                            transcript_prose_value = visible_prose
                        else:
                            visible_prose = main_point_for_slide(prose, 28)
                            transcript_prose_value = full_transcript_prose(prose)
                        if visible_prose:
                            visible_parts.append(visible_prose)
                        if transcript_prose_value:
                            transcript_parts.append(transcript_prose_value)
                    if not any(block.kind == "prose" for block in math_chunk):
                        transcript_parts.extend(
                            equation_comment(equation, section_title) for equation in equations
                        )
                    math_title = section_title
                    if len(math_chunks) > 1:
                        math_title += f" ({chunk_number} of {len(math_chunks)})"
                    visible_math = "\n\n".join(visible_parts)
                    classes = ".equation-slide"
                    if len(equations) >= 3:
                        classes += " .small"
                    elif visible_words(visible_math) > 30:
                        classes += " .compact"
                    add(
                        math_title,
                        visible_math,
                        "\n\n".join(transcript_parts),
                        "math",
                        classes,
                    )
                continue
            if unit_kind == "figure":
                if figure_index >= len(page_figures):
                    raise RuntimeError(
                        f"Figure-producing chunk has no authenticated figure in {page} / {section.title}"
                    )
                caption = blocks[0].value or f"Observed data for {title}."
                transcript_caption = FIGURE_TRANSCRIPT_OVERRIDES.get(page, caption)
                figure_path = page_figures[figure_index]
                visible_figure = (
                    f'![]({relative_figure(module, figure_path)})'
                    f'{{.empirical-plot fig-alt="{html.escape(caption, quote=True)}"}}'
                )
                add(
                    section_title,
                    visible_figure,
                    figure_transcript(transcript_caption),
                    "figure",
                    ".plot-slide",
                )
                figure_index += 1
                continue
            if unit_kind == "table":
                table_number += 1
                table = blocks[0].value
                table_lines = table.splitlines()
                chunks = [table_lines[i : i + 9] for i in range(0, len(table_lines), 9)]
                for chunk_number, chunk in enumerate(chunks, start=1):
                    table_title = section_title
                    if len(chunks) > 1:
                        table_title += f" ({chunk_number} of {len(chunks)})"
                    visible_table = "\n".join(chunk)
                    support = section.prose[min(table_number, len(section.prose) - 1)] if section.prose else ""
                    add(
                        table_title,
                        visible_table,
                        teacher_transcript(table_title, visible_table, support, "table"),
                        "table",
                        ".small",
                    )

    while figure_index < len(page_figures):
        figure_path = page_figures[figure_index]
        caption = f"Observed data and fitted quantities for {title}."
        transcript_caption = FIGURE_TRANSCRIPT_OVERRIDES.get(page, caption)
        visible_figure = (
            f'![]({relative_figure(module, figure_path)}){{.empirical-plot fig-alt="{html.escape(caption, quote=True)}"}}'
        )
        add(title, visible_figure,
            figure_transcript(transcript_caption),
            "figure", ".plot-slide")
        figure_index += 1

    return slides


def frontmatter(config: dict) -> str:
    return f'''---
title: "{config["title"]}"
subtitle: "Statistical Methods in Linguistics"
author: "Aaron Steven White"
institute: "University of Rochester"
generator: "scripts/rebuild_slides_and_transcripts.py"
date: "{config["date"]}"
date-format: "{config["date_format"]}"
title-slide-attributes:
  data-background-color: "#113A6A"
format:
  revealjs:
    css: ../shared/theme.css
    width: 1280
    height: 720
    margin: 0
    center: false
    self-contained: true
    embed-resources: true
    transition: none
    slide-number: false
    controls: true
    progress: true
    incremental: false
    html-math-method: katex
execute:
  enabled: false
---
'''


def render_slide(slide: Slide) -> str:
    classes = f" {{{slide.classes}}}" if slide.classes else ""
    source_lines = "\n".join(slide.sources)
    return f'''## {slide.title}{classes}

<!-- generated-slide-id: {slide.slide_id}; notes-page: {slide.note_page}; note-sha256: {slide.note_hash}; role: {slide.role} -->

{slide.visible}

::: {{.notes}}
[Transcript]

{slide.transcript}

[Sources]

{source_lines if source_lines else "Course note: " + slide.note_page}
:::
'''


def build_deck(
    module: str,
    config: dict,
    figures: dict[str, list[str]],
    datasets: dict[str, str],
) -> tuple[str, list[Slide]]:
    slides: list[Slide] = []
    introduced: set[str] = set()
    for page in config["pages"]:
        slides.extend(make_note_slides(module, page, figures, datasets, introduced))
    title_hash = hashlib.sha256(config["title"].encode()).hexdigest()
    title_slide = Slide(
        f"{module}/title/00-title", config["title"], "",
        f"Welcome to {config['title']}. The module follows the revised course notes in their published order, and every numerical result comes from the named linguistic dataset.",
        config["pages"][0], title_hash, "title", [], "",
    )
    all_slides = [title_slide] + slides
    body = "\n".join(render_slide(slide) for slide in slides)
    return frontmatter(config) + "\n" + body, all_slides


def write_transcript(module: str, config: dict, slides: list[Slide]) -> str:
    lines = [
        f"# {config['title']}",
        "",
        "This transcript is generated from the speaker notes in the slide source. "
        "Slide identifiers, titles, note-page provenance, and order are identical.",
        "",
    ]
    for number, slide in enumerate(slides, start=1):
        lines.extend([
            f"## Slide {number}: {slide.title}",
            "",
            f"Source note: `{slide.note_page}`",
            "",
            slide.transcript,
            "",
        ])
    return "\n".join(lines).rstrip() + "\n"


def selected_decks(through: str | None) -> dict[str, dict]:
    """Return the ordered build prefix ending at ``through`` (or all decks)."""

    if through is None:
        return DECKS
    chosen: dict[str, dict] = {}
    for module, config in DECKS.items():
        chosen[module] = config
        if module == through:
            return chosen
    raise ValueError(f"Unknown deck module: {through}")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Rebuild course decks and aligned transcripts from rendered notes."
    )
    parser.add_argument(
        "--through",
        choices=list(DECKS),
        help="Build the ordered prefix ending at this module (useful for staged builds).",
    )
    args = parser.parse_args()
    decks = selected_decks(args.through)
    figures, datasets = registry_maps(decks)
    transcript_root = DECK_ROOT / "transcripts"
    transcript_root.mkdir(parents=True, exist_ok=True)
    manifest: dict[str, dict] = {}
    pending: list[tuple[Path, str]] = []
    for module, config in decks.items():
        for page in config["pages"]:
            if not (ROOT / page).exists():
                raise FileNotFoundError(f"Manifest note is missing: {page}")
        deck_text, slides = build_deck(module, config, figures, datasets)
        deck_path = DECK_ROOT / module / "index.qmd"
        transcript_path = transcript_root / f"{module}.md"
        transcript_text = write_transcript(module, config, slides)
        if "[[INLINE-R-NOT-EVALUATED]]" in deck_text + transcript_text or "`r " in deck_text + transcript_text:
            raise RuntimeError(f"Unevaluated inline R survived generation in {module}")
        pending.extend([(deck_path, deck_text), (transcript_path, transcript_text)])
        manifest[module] = {
            "deck": str(deck_path.relative_to(ROOT)),
            "transcript": str(transcript_path.relative_to(ROOT)),
            "note_pages": config["pages"],
            "note_hashes": {page: sha256(ROOT / page) for page in config["pages"]},
            "note_html_hashes": {
                page: render_receipt(ROOT / page)["html_sha256"] for page in config["pages"]
            },
            "slide_count_including_title": len(slides),
            "slide_ids": [slide.slide_id for slide in slides],
            "figure_slide_count": sum(slide.role == "figure" for slide in slides),
        }
        print(f"rebuilt {module}: {len(slides)} slides")
    pending.append((
        DECK_ROOT / "alignment-manifest.json",
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
    ))
    for target, content in pending:
        target.parent.mkdir(parents=True, exist_ok=True)
        temporary = target.with_name(target.name + ".tmp")
        temporary.write_text(content, encoding="utf-8")
        temporary.replace(target)
    print(
        f"rebuilt {len(decks)} decks from "
        f"{sum(len(c['pages']) for c in decks.values())} note pages"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
