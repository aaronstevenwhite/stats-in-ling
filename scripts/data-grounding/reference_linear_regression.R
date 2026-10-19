#!/usr/bin/env Rscript

# Paper-first reference analysis for the linear-regression notes.
#
# This script does not edit the notes. It verifies the prepared Provo and MALD
# inputs, fits the models that later pages may use, records their exact formulas,
# and writes restrained reference figures plus the data behind those figures.

source("scripts/data-grounding/common.R")

required_packages <- c("digest", "ggplot2", "glmnet", "sandwich", "lmtest")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Missing packages: ", paste(missing_packages, collapse = ", "))
}

seed <- 20261018L
set.seed(seed)

output_dir <- file.path(
  "research", "dataset-audits", "reference-linear-regression-output"
)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

write_csv <- function(x, filename) {
  utils::write.csv(
    x,
    file.path(output_dir, filename),
    row.names = FALSE,
    na = ""
  )
}

assertions <- list()
record_assertion <- function(name, condition, observed, requirement, note = "") {
  assertions[[length(assertions) + 1L]] <<- data.frame(
    assertion = name,
    passed = isTRUE(condition),
    observed = as.character(observed),
    requirement = as.character(requirement),
    note = note,
    stringsAsFactors = FALSE
  )
  if (!isTRUE(condition)) {
    stop("Assertion failed: ", name, "; observed ", observed,
         "; required ", requirement)
  }
  invisible(condition)
}

bind_rows_base <- function(rows) {
  rows <- rows[lengths(rows) > 0L]
  if (!length(rows)) return(data.frame())
  result <- do.call(rbind, rows)
  row.names(result) <- NULL
  result
}

coefficient_tables <- list()
add_lm_coefficients <- function(model_id, fit, source = "lm") {
  table <- summary(fit)$coefficients
  intervals <- stats::confint(fit)
  coefficient_tables[[length(coefficient_tables) + 1L]] <<- data.frame(
    model_id = model_id,
    source = source,
    term = rownames(table),
    estimate = table[, "Estimate"],
    standard_error = table[, "Std. Error"],
    statistic = table[, "t value"],
    p_value = table[, "Pr(>|t|)"],
    conf_low = intervals[, 1],
    conf_high = intervals[, 2],
    stringsAsFactors = FALSE,
    row.names = NULL
  )
}

model_summaries <- list()
add_lm_summary <- function(model_id, fit, formula_text, dataset, unit) {
  model_summaries[[length(model_summaries) + 1L]] <<- data.frame(
    model_id = model_id,
    dataset = dataset,
    observational_unit = unit,
    formula = formula_text,
    n = stats::nobs(fit),
    residual_sd = summary(fit)$sigma,
    r_squared = summary(fit)$r.squared,
    adjusted_r_squared = summary(fit)$adj.r.squared,
    log_likelihood = as.numeric(stats::logLik(fit)),
    aic = stats::AIC(fit),
    stringsAsFactors = FALSE
  )
}

theme_reference <- function() {
  ggplot2::theme_classic(base_size = 11) +
    ggplot2::theme(
      legend.position = "top",
      plot.title.position = "plot",
      strip.background = ggplot2::element_blank()
    )
}

save_plot <- function(plot, filename, width = 6.4, height = 4.2) {
  ggplot2::ggsave(
    file.path(output_dir, filename),
    plot = plot,
    width = width,
    height = height,
    dpi = 160,
    bg = "white"
  )
}

# -----------------------------------------------------------------------------
# Source integrity and prepared-table structure
# -----------------------------------------------------------------------------

provo_path <- file.path("data", "provo", "content-word-positions.csv")
mald_items_path <- file.path("data", "mald", "mald-items.csv")
mald_trials_path <- file.path("data", "mald", "mald-connected-trials.csv")

expected_checksums <- data.frame(
  dataset = c(
    "Provo content-word positions",
    "MALD item summaries",
    "MALD connected trials"
  ),
  path = c(provo_path, mald_items_path, mald_trials_path),
  expected_sha256 = c(
    "458a5233347c5e5e1b80e9d73a14b448d90bbd7031bd80b295b096d74f50e914",
    "96ce8002488a7e520851e15641edf70539a469e35e1511a32563a925b7e03a01",
    "552720af4714734590e5b6c8005caf951aa4e7a43956ea23e10db26235bd24aa"
  ),
  stringsAsFactors = FALSE
)
expected_checksums$observed_sha256 <- vapply(
  expected_checksums$path,
  digest::digest,
  character(1),
  file = TRUE,
  algo = "sha256",
  serialize = FALSE
)
expected_checksums$matches <- with(
  expected_checksums,
  expected_sha256 == observed_sha256
)
record_assertion(
  "prepared input checksums",
  all(expected_checksums$matches),
  paste(expected_checksums$matches, collapse = ","),
  "all TRUE"
)
write_csv(expected_checksums, "data-checksums.csv")

provo <- utils::read.csv(provo_path, stringsAsFactors = FALSE)
mald <- utils::read.csv(mald_items_path, stringsAsFactors = FALSE)
mald_trials <- utils::read.csv(mald_trials_path, stringsAsFactors = FALSE)

record_assertion("Provo row count", nrow(provo) == 1593L, nrow(provo), 1593L)
record_assertion(
  "Provo passage count",
  length(unique(provo$Text_ID)) == 55L,
  length(unique(provo$Text_ID)),
  55L
)
record_assertion(
  "Provo position identifiers unique",
  !anyDuplicated(provo$position_id),
  anyDuplicated(provo$position_id),
  0L
)
record_assertion("MALD item row count", nrow(mald) == 23756L,
                 nrow(mald), 23756L)
record_assertion(
  "MALD item identifiers unique",
  !anyDuplicated(mald$item),
  anyDuplicated(mald$item),
  0L
)
record_assertion("MALD connected-trial row count", nrow(mald_trials) == 13339L,
                 nrow(mald_trials), 13339L)
record_assertion(
  "MALD connected participant count",
  length(unique(mald_trials$participant_id)) == 94L,
  length(unique(mald_trials$participant_id)),
  94L
)
record_assertion(
  "MALD connected item count",
  length(unique(mald_trials$item)) == 5000L,
  length(unique(mald_trials$item)),
  5000L
)

# -----------------------------------------------------------------------------
# Provo: one coherent simple-regression run
# -----------------------------------------------------------------------------

# OrthoMatchModel is a fitted cloze probability supplied by the Provo release,
# not a language-model probability. Its negative base-2 logarithm is called
# cloze surprisal here to keep that distinction visible.
provo$cloze_probability <- provo$OrthoMatchModel
provo$cloze_surprisal_bits <- -log2(provo$cloze_probability)
provo_surprisal_center <- mean(provo$cloze_surprisal_bits)
provo$cloze_surprisal_c <-
  provo$cloze_surprisal_bits - provo_surprisal_center
provo$ffd_geometric_mean_ms <- exp(provo$mean_log_ffd)

record_assertion(
  "Provo cloze probabilities inside unit interval",
  all(provo$cloze_probability > 0 & provo$cloze_probability < 1),
  paste(range(provo$cloze_probability), collapse = " to "),
  "strictly between 0 and 1"
)
record_assertion(
  "Provo log response reverses exactly",
  max(abs(log(provo$ffd_geometric_mean_ms) - provo$mean_log_ffd)) < 1e-12,
  max(abs(log(provo$ffd_geometric_mean_ms) - provo$mean_log_ffd)),
  "< 1e-12"
)

provo_fit_uncentered <- stats::lm(
  mean_log_ffd ~ cloze_surprisal_bits,
  data = provo
)
provo_fit <- stats::lm(
  mean_log_ffd ~ cloze_surprisal_c,
  data = provo
)

record_assertion(
  "centering preserves Provo fitted values",
  max(abs(fitted(provo_fit) - fitted(provo_fit_uncentered))) < 1e-12,
  max(abs(fitted(provo_fit) - fitted(provo_fit_uncentered))),
  "< 1e-12"
)
record_assertion(
  "centering preserves Provo slope",
  abs(coef(provo_fit)[[2]] - coef(provo_fit_uncentered)[[2]]) < 1e-12,
  abs(coef(provo_fit)[[2]] - coef(provo_fit_uncentered)[[2]]),
  "< 1e-12"
)

provo_manual_slope <- with(
  provo,
  sum((cloze_surprisal_c - mean(cloze_surprisal_c)) *
        (mean_log_ffd - mean(mean_log_ffd))) /
    sum((cloze_surprisal_c - mean(cloze_surprisal_c))^2)
)
record_assertion(
  "closed-form and lm Provo slopes agree",
  abs(provo_manual_slope - coef(provo_fit)[[2]]) < 1e-12,
  abs(provo_manual_slope - coef(provo_fit)[[2]]),
  "< 1e-12"
)

provo_sst <- sum((provo$mean_log_ffd - mean(provo$mean_log_ffd))^2)
provo_sse <- sum(residuals(provo_fit)^2)
provo_r_squared <- 1 - provo_sse / provo_sst
record_assertion(
  "manual and lm Provo R squared agree",
  abs(provo_r_squared - summary(provo_fit)$r.squared) < 1e-12,
  abs(provo_r_squared - summary(provo_fit)$r.squared),
  "< 1e-12"
)
record_assertion(
  "Provo OLS residuals sum to numerical zero",
  abs(sum(residuals(provo_fit))) < 1e-10,
  sum(residuals(provo_fit)),
  "absolute value < 1e-10"
)

add_lm_coefficients("provo_simple_centered", provo_fit)
add_lm_coefficients("provo_simple_uncentered", provo_fit_uncentered)
add_lm_summary(
  "provo_simple_centered",
  provo_fit,
  "mean_log_ffd ~ cloze_surprisal_c",
  "Provo Corpus",
  "content-word position aggregated across readers"
)

# Passage-clustered covariance is a sensitivity analysis. It does not recover
# reader-level variation, which was removed by the prepared position table.
provo_cluster_vcov <- sandwich::vcovCL(
  provo_fit,
  cluster = provo$Text_ID,
  type = "HC1"
)
provo_cluster_test <- lmtest::coeftest(provo_fit, vcov. = provo_cluster_vcov)
coefficient_tables[[length(coefficient_tables) + 1L]] <- data.frame(
  model_id = "provo_simple_passage_cluster_sensitivity",
  source = "sandwich::vcovCL HC1 by Text_ID",
  term = rownames(provo_cluster_test),
  estimate = provo_cluster_test[, "Estimate"],
  standard_error = provo_cluster_test[, "Std. Error"],
  statistic = provo_cluster_test[, "t value"],
  p_value = provo_cluster_test[, "Pr(>|t|)"],
  conf_low = provo_cluster_test[, "Estimate"] -
    stats::qt(0.975, df = length(unique(provo$Text_ID)) - 1L) *
    provo_cluster_test[, "Std. Error"],
  conf_high = provo_cluster_test[, "Estimate"] +
    stats::qt(0.975, df = length(unique(provo$Text_ID)) - 1L) *
    provo_cluster_test[, "Std. Error"],
  stringsAsFactors = FALSE,
  row.names = NULL
)

# Empirical conditional means use equal-count bins only as a display device.
provo_breaks <- unique(stats::quantile(
  provo$cloze_surprisal_bits,
  probs = seq(0, 1, length.out = 11L),
  names = FALSE
))
provo$surprisal_bin <- cut(
  provo$cloze_surprisal_bits,
  breaks = provo_breaks,
  include.lowest = TRUE,
  ordered_result = TRUE
)
provo_bins <- do.call(rbind, lapply(
  split(provo, provo$surprisal_bin),
  function(rows) data.frame(
    surprisal_bin = as.character(rows$surprisal_bin[[1]]),
    n_positions = nrow(rows),
    mean_cloze_surprisal_bits = mean(rows$cloze_surprisal_bits),
    mean_log_ffd = mean(rows$mean_log_ffd),
    sd_log_ffd = stats::sd(rows$mean_log_ffd),
    se_mean_log_ffd = stats::sd(rows$mean_log_ffd) / sqrt(nrow(rows))
  )
))
row.names(provo_bins) <- NULL

provo_grid <- data.frame(
  cloze_surprisal_bits = seq(
    min(provo$cloze_surprisal_bits),
    max(provo$cloze_surprisal_bits),
    length.out = 160L
  )
)
provo_grid$cloze_surprisal_c <-
  provo_grid$cloze_surprisal_bits - provo_surprisal_center
provo_confidence <- stats::predict(
  provo_fit,
  newdata = provo_grid,
  interval = "confidence",
  level = 0.95
)
provo_prediction <- stats::predict(
  provo_fit,
  newdata = provo_grid,
  interval = "prediction",
  level = 0.95
)
provo_grid$fitted_log_ffd <- provo_confidence[, "fit"]
provo_grid$mean_conf_low <- provo_confidence[, "lwr"]
provo_grid$mean_conf_high <- provo_confidence[, "upr"]
provo_grid$response_pred_low <- provo_prediction[, "lwr"]
provo_grid$response_pred_high <- provo_prediction[, "upr"]
provo_grid$fitted_geometric_mean_ms <- exp(provo_grid$fitted_log_ffd)
provo_grid$fitted_lognormal_mean_ms <- exp(
  provo_grid$fitted_log_ffd + summary(provo_fit)$sigma^2 / 2
)

provo$ols_fitted_log_ffd <- fitted(provo_fit)
provo$ols_residual <- residuals(provo_fit)
provo$leverage <- stats::hatvalues(provo_fit)
provo$cooks_distance <- stats::cooks.distance(provo_fit)

# The quadratic term is a diagnostic sensitivity, not the new default model.
provo_quadratic_fit <- stats::lm(
  mean_log_ffd ~ cloze_surprisal_c + I(cloze_surprisal_c^2),
  data = provo
)
add_lm_coefficients("provo_quadratic_diagnostic", provo_quadratic_fit)
add_lm_summary(
  "provo_quadratic_diagnostic",
  provo_quadratic_fit,
  "mean_log_ffd ~ cloze_surprisal_c + I(cloze_surprisal_c^2)",
  "Provo Corpus",
  "content-word position aggregated across readers"
)

provo_passage_residuals <- do.call(rbind, lapply(
  split(provo, provo$Text_ID),
  function(rows) data.frame(
    Text_ID = rows$Text_ID[[1]],
    n_positions = nrow(rows),
    mean_residual = mean(rows$ols_residual),
    sd_residual = stats::sd(rows$ols_residual)
  )
))
row.names(provo_passage_residuals) <- NULL

# Influence is evaluated at both the position and passage units. The latter
# matches the remaining grouping identifier in the prepared table.
provo_full_slope <- unname(coef(provo_fit)["cloze_surprisal_c"])
provo_passage_deletion <- do.call(rbind, lapply(
  sort(unique(provo$Text_ID)),
  function(current_passage) {
    deleted_fit <- stats::lm(
      mean_log_ffd ~ cloze_surprisal_c,
      data = provo[provo$Text_ID != current_passage, ]
    )
    deleted_slope <- unname(coef(deleted_fit)["cloze_surprisal_c"])
    data.frame(
      deleted_Text_ID = current_passage,
      n_deleted_positions = sum(provo$Text_ID == current_passage),
      slope_without_passage = deleted_slope,
      slope_change_from_full = deleted_slope - provo_full_slope,
      absolute_slope_change = abs(deleted_slope - provo_full_slope)
    )
  }
))
most_influential_passage <- provo_passage_deletion$deleted_Text_ID[
  which.max(provo_passage_deletion$absolute_slope_change)
]
provo_fit_without_passage <- stats::lm(
  mean_log_ffd ~ cloze_surprisal_c,
  data = provo[provo$Text_ID != most_influential_passage, ]
)
provo_grid$fitted_without_most_influential_passage <- stats::predict(
  provo_fit_without_passage,
  newdata = provo_grid
)

# Bayesian bridge: a conjugate normal-inverse-gamma model. Its prior location
# and scale are calibrated from the observed response and predictor scales, so
# this is explicitly an empirical-Bayes teaching bridge rather than an
# independent confirmatory analysis.
X_provo <- stats::model.matrix(
  ~ cloze_surprisal_c,
  data = provo
)
y_provo <- provo$mean_log_ffd
p_provo <- ncol(X_provo)
sigma_ols <- summary(provo_fit)$sigma
b0 <- c(mean(y_provo), 0)
V0 <- diag(c(
  (2 * stats::sd(y_provo) / sigma_ols)^2,
  (2 * stats::sd(y_provo) /
     (stats::sd(provo$cloze_surprisal_c) * sigma_ols))^2
))
a0 <- 3
d0 <- (a0 - 1) * sigma_ols^2
Vn <- solve(solve(V0) + crossprod(X_provo))
bn <- drop(Vn %*% (solve(V0) %*% b0 + crossprod(X_provo, y_provo)))
an <- a0 + nrow(provo) / 2
dn <- as.numeric(
  d0 + 0.5 * (
    crossprod(y_provo) +
      t(b0) %*% solve(V0) %*% b0 -
      t(bn) %*% solve(Vn) %*% bn
  )
)

bayes_draw_seed <- seed + 1L
set.seed(bayes_draw_seed)
n_bayes_draws <- 4000L
sigma2_draws <- 1 / stats::rgamma(n_bayes_draws, shape = an, rate = dn)
beta_noise <- matrix(
  stats::rnorm(n_bayes_draws * p_provo),
  nrow = n_bayes_draws,
  ncol = p_provo
) %*% chol(Vn)
beta_draws <- matrix(
  bn,
  nrow = n_bayes_draws,
  ncol = p_provo,
  byrow = TRUE
) + sweep(beta_noise, 1, sqrt(sigma2_draws), `*`)
colnames(beta_draws) <- colnames(X_provo)

posterior_summary <- rbind(
  data.frame(
    term = colnames(beta_draws),
    posterior_mean = colMeans(beta_draws),
    posterior_sd = apply(beta_draws, 2, stats::sd),
    posterior_low = apply(beta_draws, 2, stats::quantile, probs = 0.025),
    posterior_high = apply(beta_draws, 2, stats::quantile, probs = 0.975)
  ),
  data.frame(
    term = "sigma",
    posterior_mean = mean(sqrt(sigma2_draws)),
    posterior_sd = stats::sd(sqrt(sigma2_draws)),
    posterior_low = stats::quantile(sqrt(sigma2_draws), 0.025),
    posterior_high = stats::quantile(sqrt(sigma2_draws), 0.975)
  )
)
row.names(posterior_summary) <- NULL

posterior_mu_draws <- outer(
  beta_draws[, "cloze_surprisal_c"],
  provo_grid$cloze_surprisal_c,
  `*`
)
posterior_mu_draws <- sweep(
  posterior_mu_draws,
  1,
  beta_draws[, "(Intercept)"],
  `+`
)
provo_bayes_grid <- data.frame(
  cloze_surprisal_bits = provo_grid$cloze_surprisal_bits,
  cloze_surprisal_c = provo_grid$cloze_surprisal_c,
  posterior_mean_log_ffd = colMeans(posterior_mu_draws),
  posterior_low_log_ffd = apply(
    posterior_mu_draws, 2, stats::quantile, probs = 0.025
  ),
  posterior_high_log_ffd = apply(
    posterior_mu_draws, 2, stats::quantile, probs = 0.975
  )
)
record_assertion(
  "Provo Bayesian posterior finite",
  all(is.finite(as.matrix(posterior_summary[, -1]))),
  all(is.finite(as.matrix(posterior_summary[, -1]))),
  TRUE
)

provo_prior_hyperparameters <- data.frame(
  object = c(
    "beta intercept prior mean",
    "beta slope prior mean",
    "conditional intercept prior variance multiplier V0[1,1]",
    "conditional slope prior variance multiplier V0[2,2]",
    "inverse-gamma shape a0",
    "inverse-gamma rate d0",
    "observed surprisal centering constant",
    "OLS residual scale used for calibration"
  ),
  value = c(b0, diag(V0), a0, d0, provo_surprisal_center, sigma_ols),
  derivation = c(
    "observed mean of mean_log_ffd",
    "zero change at the observed predictor center",
    "(2 * observed response SD / OLS residual SD)^2",
    "(2 * observed response SD / (observed predictor SD * OLS residual SD))^2",
    "declared weak-shape setting",
    "(a0 - 1) * observed OLS residual variance",
    "observed mean of -log2(OrthoMatchModel)",
    "summary(lm)$sigma"
  ),
  stringsAsFactors = FALSE
)

# -----------------------------------------------------------------------------
# MALD: multiple regression, coding, collinearity, and conditional scale
# -----------------------------------------------------------------------------

mald$log_frequency_c <-
  mald$log_frequency_subtlex - mean(mald$log_frequency_subtlex)
mald$log_duration_c <- mald$log_duration - mean(mald$log_duration)
mald$n_phones_c <- mald$n_phones - mean(mald$n_phones)
mald$n_syllables_c <- mald$n_syllables - mean(mald$n_syllables)

mald_multiple <- stats::lm(
  mean_log_rt ~ log_frequency_c + log_duration_c + n_phones_c,
  data = mald
)
add_lm_coefficients("mald_multiple", mald_multiple)
add_lm_summary(
  "mald_multiple",
  mald_multiple,
  "mean_log_rt ~ log_frequency_c + log_duration_c + n_phones_c",
  "MALD 1.1",
  "word item summarized over correct retained trials"
)

mald_frequency_only <- stats::lm(
  mean_log_rt ~ log_frequency_c,
  data = mald
)
add_lm_coefficients("mald_frequency_only", mald_frequency_only)
add_lm_summary(
  "mald_frequency_only",
  mald_frequency_only,
  "mean_log_rt ~ log_frequency_c",
  "MALD 1.1",
  "word item summarized over correct retained trials"
)

# Representative design rows are actual MALD items nearest three empirical
# frequency quantiles. They are not invented predictor combinations.
design_targets <- stats::quantile(
  mald$log_frequency_subtlex,
  probs = c(0.1, 0.5, 0.9),
  names = FALSE
)
design_indices <- vapply(
  design_targets,
  function(target) which.min(abs(mald$log_frequency_subtlex - target)),
  integer(1)
)
record_assertion(
  "MALD representative design rows unique",
  length(unique(design_indices)) == length(design_indices),
  length(unique(design_indices)),
  length(design_indices)
)
design_rows <- mald[design_indices, ]
design_matrix <- stats::model.matrix(mald_multiple, data = design_rows)
design_predictions <- drop(design_matrix %*% coef(mald_multiple))
record_assertion(
  "MALD design matrix reproduces predict.lm",
  max(abs(design_predictions - stats::predict(
    mald_multiple,
    newdata = design_rows
  ))) < 1e-12,
  max(abs(design_predictions - stats::predict(
    mald_multiple,
    newdata = design_rows
  ))),
  "< 1e-12"
)
mald_design_matrix <- cbind(
  design_rows[, c(
    "item", "mean_log_rt", "log_frequency_subtlex", "log_duration",
    "n_phones", "n_syllables", "part_of_speech"
  )],
  as.data.frame(design_matrix),
  matrix_prediction = design_predictions
)

mald_grid <- data.frame(
  log_frequency_subtlex = seq(
    stats::quantile(mald$log_frequency_subtlex, 0.01),
    stats::quantile(mald$log_frequency_subtlex, 0.99),
    length.out = 160L
  )
)
mald_grid$log_frequency_c <-
  mald_grid$log_frequency_subtlex - mean(mald$log_frequency_subtlex)
mald_grid$log_duration_c <- 0
mald_grid$n_phones_c <- 0
mald_multiple_prediction <- stats::predict(
  mald_multiple,
  newdata = mald_grid,
  interval = "confidence",
  level = 0.95
)
mald_grid$fitted_mean_log_rt <- mald_multiple_prediction[, "fit"]
mald_grid$conf_low <- mald_multiple_prediction[, "lwr"]
mald_grid$conf_high <- mald_multiple_prediction[, "upr"]

# Categorical coding uses the three major frequency-dominant POS classes in
# the release. POS is a word-form summary from SUBTLEX, not a token annotation.
major_pos <- mald[
  mald$part_of_speech %in% c("Noun", "Verb", "Adjective"),
]
major_pos$part_of_speech <- factor(
  major_pos$part_of_speech,
  levels = c("Noun", "Verb", "Adjective")
)

pos_treatment <- major_pos
contrasts(pos_treatment$part_of_speech) <- stats::contr.treatment(3)
fit_pos_treatment <- stats::lm(
  mean_log_rt ~ part_of_speech + log_frequency_c +
    log_duration_c + n_phones_c,
  data = pos_treatment
)
add_lm_coefficients("mald_pos_treatment", fit_pos_treatment)

pos_sum <- major_pos
contrasts(pos_sum$part_of_speech) <- stats::contr.sum(3)
fit_pos_sum <- stats::lm(
  mean_log_rt ~ part_of_speech + log_frequency_c +
    log_duration_c + n_phones_c,
  data = pos_sum
)
add_lm_coefficients("mald_pos_sum", fit_pos_sum)

record_assertion(
  "MALD POS treatment and sum coding preserve fitted values",
  max(abs(fitted(fit_pos_treatment) - fitted(fit_pos_sum))) < 1e-10,
  max(abs(fitted(fit_pos_treatment) - fitted(fit_pos_sum))),
  "< 1e-10"
)

pos_prediction_data <- data.frame(
  part_of_speech = factor(
    levels(major_pos$part_of_speech),
    levels = levels(major_pos$part_of_speech)
  ),
  log_frequency_c = 0,
  log_duration_c = 0,
  n_phones_c = 0
)
pos_predictions <- stats::predict(
  fit_pos_treatment,
  newdata = pos_prediction_data,
  interval = "confidence"
)
mald_pos_predictions <- cbind(
  pos_prediction_data,
  fitted_mean_log_rt = pos_predictions[, "fit"],
  conf_low = pos_predictions[, "lwr"],
  conf_high = pos_predictions[, "upr"]
)
mald_pos_counts <- as.data.frame(table(major_pos$part_of_speech))
names(mald_pos_counts) <- c("part_of_speech", "n_items")
mald_pos_predictions <- merge(
  mald_pos_predictions,
  mald_pos_counts,
  by = "part_of_speech",
  sort = FALSE
)

# The ordered syllable bands support the successive comparisons on the Helmert
# pages. The open top band is retained as "4+" and must not be read as one
# exact syllable count.
mald$syllable_band <- factor(
  ifelse(mald$n_syllables >= 4L, "4+", as.character(mald$n_syllables)),
  levels = c("1", "2", "3", "4+")
)

fit_syllable_with_contrast <- function(contrast_matrix) {
  current <- mald
  contrasts(current$syllable_band) <- contrast_matrix
  stats::lm(
    mean_log_rt ~ syllable_band + log_frequency_c + log_duration_c,
    data = current
  )
}

syllable_treatment_matrix <- stats::contr.treatment(4)
rownames(syllable_treatment_matrix) <- levels(mald$syllable_band)
syllable_sum_matrix <- stats::contr.sum(4)
rownames(syllable_sum_matrix) <- levels(mald$syllable_band)
syllable_helmert_matrix <- stats::contr.helmert(4)
rownames(syllable_helmert_matrix) <- levels(mald$syllable_band)
syllable_reverse_matrix <- matrix(
  c(
     3, -1, -1, -1,
     0,  2, -1, -1,
     0,  0,  1, -1
  ),
  nrow = 4,
  ncol = 3
)
rownames(syllable_reverse_matrix) <- levels(mald$syllable_band)
colnames(syllable_reverse_matrix) <- c(
  "one_vs_later", "two_vs_later", "three_vs_four_plus"
)

fit_syllable_treatment <- fit_syllable_with_contrast(
  syllable_treatment_matrix
)
fit_syllable_sum <- fit_syllable_with_contrast(syllable_sum_matrix)
fit_syllable_helmert <- fit_syllable_with_contrast(syllable_helmert_matrix)
fit_syllable_reverse <- fit_syllable_with_contrast(syllable_reverse_matrix)

add_lm_coefficients("mald_syllable_treatment", fit_syllable_treatment)
add_lm_coefficients("mald_syllable_sum", fit_syllable_sum)
add_lm_coefficients("mald_syllable_helmert", fit_syllable_helmert)
add_lm_coefficients("mald_syllable_reverse_helmert", fit_syllable_reverse)

syllable_fit_matrix <- cbind(
  treatment = fitted(fit_syllable_treatment),
  sum = fitted(fit_syllable_sum),
  helmert = fitted(fit_syllable_helmert),
  reverse = fitted(fit_syllable_reverse)
)
record_assertion(
  "MALD syllable codings preserve fitted values",
  max(abs(sweep(
    syllable_fit_matrix[, -1, drop = FALSE],
    1,
    syllable_fit_matrix[, 1],
    `-`
  ))) < 1e-9,
  max(abs(sweep(
    syllable_fit_matrix[, -1, drop = FALSE],
    1,
    syllable_fit_matrix[, 1],
    `-`
  ))),
  "< 1e-9"
)

syllable_prediction_data <- data.frame(
  syllable_band = factor(
    levels(mald$syllable_band),
    levels = levels(mald$syllable_band)
  ),
  log_frequency_c = 0,
  log_duration_c = 0
)
syllable_predictions <- stats::predict(
  fit_syllable_treatment,
  newdata = syllable_prediction_data,
  interval = "confidence"
)
mald_syllable_predictions <- cbind(
  syllable_prediction_data,
  fitted_mean_log_rt = syllable_predictions[, "fit"],
  conf_low = syllable_predictions[, "lwr"],
  conf_high = syllable_predictions[, "upr"]
)
mald_syllable_counts <- as.data.frame(table(mald$syllable_band))
names(mald_syllable_counts) <- c("syllable_band", "n_items")
mald_syllable_predictions <- merge(
  mald_syllable_predictions,
  mald_syllable_counts,
  by = "syllable_band",
  sort = FALSE
)

matrix_to_long <- function(matrix_object, coding) {
  result <- as.data.frame(as.table(matrix_object), stringsAsFactors = FALSE)
  names(result) <- c("level", "column", "value")
  result$coding <- coding
  result[, c("coding", "level", "column", "value")]
}
mald_contrast_matrices <- rbind(
  matrix_to_long(syllable_treatment_matrix, "treatment"),
  matrix_to_long(syllable_sum_matrix, "sum"),
  matrix_to_long(syllable_helmert_matrix, "helmert"),
  matrix_to_long(syllable_reverse_matrix, "reverse_helmert")
)

# This interaction is an exploratory teaching extension. Tucker et al. did not
# test a POS-by-frequency interaction in the resource paper.
mald_interaction <- stats::lm(
  mean_log_rt ~ log_frequency_c * part_of_speech +
    log_duration_c + n_phones_c,
  data = major_pos
)
add_lm_coefficients("mald_frequency_by_pos", mald_interaction)
add_lm_summary(
  "mald_frequency_by_pos",
  mald_interaction,
  paste(
    "mean_log_rt ~ log_frequency_c * part_of_speech +",
    "log_duration_c + n_phones_c"
  ),
  "MALD 1.1",
  "noun, verb, or adjective item summarized over correct retained trials"
)

pos_ranges <- do.call(rbind, lapply(
  split(major_pos$log_frequency_subtlex, major_pos$part_of_speech),
  function(values) c(
    low = unname(stats::quantile(values, 0.02)),
    high = unname(stats::quantile(values, 0.98))
  )
))
interaction_low <- max(pos_ranges[, "low"])
interaction_high <- min(pos_ranges[, "high"])
mald_interaction_grid <- expand.grid(
  log_frequency_subtlex = seq(
    interaction_low,
    interaction_high,
    length.out = 120L
  ),
  part_of_speech = levels(major_pos$part_of_speech),
  KEEP.OUT.ATTRS = FALSE,
  stringsAsFactors = FALSE
)
mald_interaction_grid$part_of_speech <- factor(
  mald_interaction_grid$part_of_speech,
  levels = levels(major_pos$part_of_speech)
)
mald_interaction_grid$log_frequency_c <-
  mald_interaction_grid$log_frequency_subtlex -
  mean(mald$log_frequency_subtlex)
mald_interaction_grid$log_duration_c <- 0
mald_interaction_grid$n_phones_c <- 0
interaction_predictions <- stats::predict(
  mald_interaction,
  newdata = mald_interaction_grid,
  interval = "confidence"
)
mald_interaction_grid$fitted_mean_log_rt <- interaction_predictions[, "fit"]
mald_interaction_grid$conf_low <- interaction_predictions[, "lwr"]
mald_interaction_grid$conf_high <- interaction_predictions[, "upr"]

# Collinearity is described from the actual item-property matrix.
collinearity_variables <- c(
  "log_frequency_subtlex", "log_duration", "n_phones", "n_syllables"
)
mald_correlation_matrix <- stats::cor(mald[, collinearity_variables])
mald_correlations <- as.data.frame(
  as.table(mald_correlation_matrix),
  stringsAsFactors = FALSE
)
names(mald_correlations) <- c("variable_1", "variable_2", "correlation")

mald_vif <- do.call(rbind, lapply(
  collinearity_variables,
  function(response) {
    predictors <- setdiff(collinearity_variables, response)
    auxiliary <- stats::lm(
      stats::reformulate(predictors, response = response),
      data = mald
    )
    auxiliary_r_squared <- summary(auxiliary)$r.squared
    data.frame(
      predictor = response,
      auxiliary_formula = paste(
        response,
        "~",
        paste(predictors, collapse = " + ")
      ),
      auxiliary_r_squared = auxiliary_r_squared,
      vif = 1 / (1 - auxiliary_r_squared),
      standard_error_multiplier = sqrt(1 / (1 - auxiliary_r_squared))
    )
  }
))
row.names(mald_vif) <- NULL

# Ridge prediction targets a new MALD item. Since the table contains one row
# per item, fold assignment by item is equivalent to row assignment here; the
# item-level target and unique-key assertion are nevertheless recorded.
ridge_predictors <- c(
  "log_frequency_subtlex", "log_duration", "n_phones", "n_syllables"
)
X_ridge <- stats::model.matrix(
  ~ log_frequency_subtlex + log_duration + n_phones + n_syllables,
  data = mald
)[, -1, drop = FALSE]
y_ridge <- mald$mean_log_rt
n_folds <- 10L
ridge_seed <- seed + 2L
set.seed(ridge_seed)
ridge_fold <- sample(rep(seq_len(n_folds), length.out = nrow(mald)))
record_assertion(
  "ridge new-item folds contain each item once",
  nrow(mald) == length(unique(mald$item)),
  length(unique(mald$item)),
  nrow(mald)
)

lambda_grid <- 10^seq(-5, 1, length.out = 80L)
ridge_mse <- matrix(
  NA_real_,
  nrow = n_folds,
  ncol = length(lambda_grid)
)
ridge_prediction_matrix <- matrix(
  NA_real_,
  nrow = nrow(mald),
  ncol = length(lambda_grid)
)
ols_fold_prediction <- rep(NA_real_, nrow(mald))

for (fold in seq_len(n_folds)) {
  training <- ridge_fold != fold
  testing <- !training
  ridge_fit <- glmnet::glmnet(
    x = X_ridge[training, , drop = FALSE],
    y = y_ridge[training],
    alpha = 0,
    lambda = lambda_grid,
    standardize = TRUE,
    intercept = TRUE
  )
  current_prediction <- stats::predict(
    ridge_fit,
    newx = X_ridge[testing, , drop = FALSE],
    s = lambda_grid
  )
  ridge_prediction_matrix[testing, ] <- current_prediction
  ridge_mse[fold, ] <- colMeans(
    (y_ridge[testing] - current_prediction)^2
  )
  ols_fold_fit <- stats::lm(
    mean_log_rt ~ log_frequency_subtlex + log_duration +
      n_phones + n_syllables,
    data = mald[training, ]
  )
  ols_fold_prediction[testing] <- stats::predict(
    ols_fold_fit,
    newdata = mald[testing, ]
  )
}

ridge_mean_mse <- colMeans(ridge_mse)
ridge_se_mse <- apply(ridge_mse, 2, stats::sd) / sqrt(n_folds)
ridge_min_index <- which.min(ridge_mean_mse)
ridge_one_se_candidates <- which(
  ridge_mean_mse <=
    ridge_mean_mse[ridge_min_index] + ridge_se_mse[ridge_min_index]
)
ridge_one_se_index <- max(ridge_one_se_candidates)
ridge_lambda_min <- lambda_grid[ridge_min_index]
ridge_lambda_one_se <- lambda_grid[ridge_one_se_index]
ridge_selected_prediction <- ridge_prediction_matrix[, ridge_one_se_index]

record_assertion(
  "ridge cross-validated predictions complete",
  all(is.finite(ridge_selected_prediction)),
  sum(is.finite(ridge_selected_prediction)),
  nrow(mald)
)
record_assertion(
  "ridge one-SE lambda no smaller than minimum-error lambda",
  ridge_lambda_one_se >= ridge_lambda_min,
  ridge_lambda_one_se,
  paste(">=", ridge_lambda_min)
)

ridge_full_fit <- glmnet::glmnet(
  x = X_ridge,
  y = y_ridge,
  alpha = 0,
  lambda = lambda_grid,
  standardize = TRUE,
  intercept = TRUE
)
ridge_coefficients_min <- as.matrix(stats::coef(
  ridge_full_fit,
  s = ridge_lambda_min
))[, 1]
ridge_coefficients_one_se <- as.matrix(stats::coef(
  ridge_full_fit,
  s = ridge_lambda_one_se
))[, 1]
mald_ridge_coefficients <- rbind(
  data.frame(
    selection = "minimum_cv_error",
    lambda = ridge_lambda_min,
    term = names(ridge_coefficients_min),
    estimate = unname(ridge_coefficients_min)
  ),
  data.frame(
    selection = "one_standard_error",
    lambda = ridge_lambda_one_se,
    term = names(ridge_coefficients_one_se),
    estimate = unname(ridge_coefficients_one_se)
  )
)
mald_ridge_cv <- data.frame(
  lambda = lambda_grid,
  mean_mse = ridge_mean_mse,
  se_mse = ridge_se_mse,
  mean_rmse = sqrt(ridge_mean_mse),
  selected_min = seq_along(lambda_grid) == ridge_min_index,
  selected_one_se = seq_along(lambda_grid) == ridge_one_se_index
)
mald_ridge_predictions <- data.frame(
  item = mald$item,
  fold = ridge_fold,
  observed_mean_log_rt = y_ridge,
  ridge_one_se_prediction = ridge_selected_prediction,
  ols_prediction = ols_fold_prediction,
  ridge_squared_error = (y_ridge - ridge_selected_prediction)^2,
  ols_squared_error = (y_ridge - ols_fold_prediction)^2
)

# Residualization exposes the same partial phone-count coefficient as the
# original multiple regression. It does not create a purified phonological
# construct.
phone_residualizer <- stats::lm(
  n_phones ~ n_syllables + log_duration + log_frequency_subtlex,
  data = mald
)
mald$residual_n_phones <- residuals(phone_residualizer)
fit_phone_original <- stats::lm(
  mean_log_rt ~ n_phones + n_syllables + log_duration +
    log_frequency_subtlex,
  data = mald
)
fit_phone_residualized <- stats::lm(
  mean_log_rt ~ residual_n_phones + n_syllables + log_duration +
    log_frequency_subtlex,
  data = mald
)
record_assertion(
  "residualized and original phone-count partial slopes agree",
  abs(
    coef(fit_phone_original)["n_phones"] -
      coef(fit_phone_residualized)["residual_n_phones"]
  ) < 1e-10,
  abs(
    coef(fit_phone_original)["n_phones"] -
      coef(fit_phone_residualized)["residual_n_phones"]
  ),
  "< 1e-10"
)
add_lm_coefficients("mald_phone_original", fit_phone_original)
add_lm_coefficients("mald_phone_residualized", fit_phone_residualized)

response_residualizer <- stats::lm(
  mean_log_rt ~ n_syllables + log_duration + log_frequency_subtlex,
  data = mald
)
mald$residual_mean_log_rt <- residuals(response_residualizer)
fit_partial_residuals <- stats::lm(
  residual_mean_log_rt ~ residual_n_phones,
  data = mald
)
record_assertion(
  "Frisch-Waugh-Lovell phone-count slope agrees",
  abs(
    coef(fit_phone_original)["n_phones"] -
      coef(fit_partial_residuals)["residual_n_phones"]
  ) < 1e-10,
  abs(
    coef(fit_phone_original)["n_phones"] -
      coef(fit_partial_residuals)["residual_n_phones"]
  ),
  "< 1e-10"
)

# Verify the same equivalence inside the new-item folds. The residualizer is fit
# only on training items, then applied to held-out items.
residualization_cv <- list()
for (fold in seq_len(n_folds)) {
  training <- ridge_fold != fold
  testing <- !training
  fold_residualizer <- stats::lm(
    n_phones ~ n_syllables + log_duration + log_frequency_subtlex,
    data = mald[training, ]
  )
  training_data <- mald[training, ]
  testing_data <- mald[testing, ]
  training_data$fold_residual_n_phones <- residuals(fold_residualizer)
  testing_data$fold_residual_n_phones <- testing_data$n_phones -
    stats::predict(fold_residualizer, newdata = testing_data)

  fold_original <- stats::lm(
    mean_log_rt ~ n_phones + n_syllables + log_duration +
      log_frequency_subtlex,
    data = training_data
  )
  fold_residualized <- stats::lm(
    mean_log_rt ~ fold_residual_n_phones + n_syllables +
      log_duration + log_frequency_subtlex,
    data = training_data
  )
  original_prediction <- stats::predict(
    fold_original,
    newdata = testing_data
  )
  residualized_prediction <- stats::predict(
    fold_residualized,
    newdata = testing_data
  )
  residualization_cv[[fold]] <- data.frame(
    fold = fold,
    n_training_items = sum(training),
    n_testing_items = sum(testing),
    original_phone_slope = coef(fold_original)["n_phones"],
    residual_phone_slope = coef(fold_residualized)[
      "fold_residual_n_phones"
    ],
    max_prediction_difference = max(abs(
      original_prediction - residualized_prediction
    ))
  )
}
mald_residualization_cv <- bind_rows_base(residualization_cv)
record_assertion(
  "foldwise residualization predictions preserve fitted subspace",
  max(mald_residualization_cv$max_prediction_difference) < 1e-10,
  max(mald_residualization_cv$max_prediction_difference),
  "< 1e-10"
)

# Heteroscedasticity checks use the same item-level mean model and retain each
# item's empirical within-item SD as a separate observed spread measurement.
mald$multiple_fitted <- fitted(mald_multiple)
mald$multiple_residual <- residuals(mald_multiple)
frequency_breaks <- unique(stats::quantile(
  mald$log_frequency_subtlex,
  probs = seq(0, 1, length.out = 11L),
  names = FALSE
))
mald$frequency_bin <- cut(
  mald$log_frequency_subtlex,
  breaks = frequency_breaks,
  include.lowest = TRUE,
  ordered_result = TRUE
)
mald_heteroscedastic_bins <- do.call(rbind, lapply(
  split(mald, mald$frequency_bin),
  function(rows) data.frame(
    frequency_bin = as.character(rows$frequency_bin[[1]]),
    n_items = nrow(rows),
    mean_log_frequency = mean(rows$log_frequency_subtlex),
    mean_residual = mean(rows$multiple_residual),
    mean_absolute_residual = mean(abs(rows$multiple_residual)),
    root_mean_squared_residual = sqrt(mean(rows$multiple_residual^2)),
    mean_within_item_sd_log_rt = mean(rows$sd_log_rt),
    median_within_item_sd_log_rt = stats::median(rows$sd_log_rt)
  )
))
row.names(mald_heteroscedastic_bins) <- NULL

mald_hc3_vcov <- sandwich::vcovHC(mald_multiple, type = "HC3")
mald_hc3_test <- lmtest::coeftest(mald_multiple, vcov. = mald_hc3_vcov)
mald_uncertainty_comparison <- data.frame(
  term = names(coef(mald_multiple)),
  estimate = coef(mald_multiple),
  conventional_standard_error = summary(mald_multiple)$coefficients[, 2],
  hc3_standard_error = mald_hc3_test[, "Std. Error"],
  hc3_to_conventional_ratio =
    mald_hc3_test[, "Std. Error"] /
    summary(mald_multiple)$coefficients[, 2],
  row.names = NULL
)

# Distributional regression uses the sufficient-statistic identity for each
# item's correct log-RT observations:
# sum_j (y_ij - mu_i)^2 = (n_i - 1) s_i^2 + n_i (ybar_i - mu_i)^2.
# This is the Gaussian likelihood of the retained correct trials under an
# independence approximation. Participant dependence is not recoverable from
# the item table and remains a limitation.
X_mu <- stats::model.matrix(
  ~ log_frequency_c + log_duration_c + n_phones_c,
  data = mald
)
Z_constant <- matrix(1, nrow = nrow(mald), ncol = 1)
colnames(Z_constant) <- "(Intercept)"
Z_frequency <- stats::model.matrix(~ log_frequency_c, data = mald)

distributional_nll <- function(parameters, X, Z, data) {
  n_beta <- ncol(X)
  beta <- parameters[seq_len(n_beta)]
  gamma <- parameters[n_beta + seq_len(ncol(Z))]
  mu <- drop(X %*% beta)
  log_sigma <- drop(Z %*% gamma)
  sigma_squared <- exp(2 * log_sigma)
  squared_error <-
    (data$n_observations - 1) * data$variance_log_rt +
    data$n_observations * (data$mean_log_rt - mu)^2
  0.5 * sum(
    data$n_observations * log(2 * pi) +
      2 * data$n_observations * log_sigma +
      squared_error / sigma_squared
  )
}

weighted_mean_fit <- stats::lm(
  mean_log_rt ~ log_frequency_c + log_duration_c + n_phones_c,
  data = mald,
  weights = n_observations
)
initial_beta <- coef(weighted_mean_fit)
initial_sigma <- sqrt(sum(
  (mald$n_observations - 1) * mald$variance_log_rt +
    mald$n_observations * residuals(weighted_mean_fit)^2
) / sum(mald$n_observations))

distributional_constant <- stats::optim(
  c(initial_beta, log(initial_sigma)),
  distributional_nll,
  X = X_mu,
  Z = Z_constant,
  data = mald,
  method = "BFGS",
  hessian = TRUE,
  control = list(maxit = 2000L, reltol = 1e-11)
)
distributional_frequency <- stats::optim(
  c(initial_beta, log(initial_sigma), 0),
  distributional_nll,
  X = X_mu,
  Z = Z_frequency,
  data = mald,
  method = "BFGS",
  hessian = TRUE,
  control = list(maxit = 4000L, reltol = 1e-11)
)

record_assertion(
  "constant-scale distributional optimizer converged",
  distributional_constant$convergence == 0L,
  distributional_constant$convergence,
  0L
)
record_assertion(
  "frequency-scale distributional optimizer converged",
  distributional_frequency$convergence == 0L,
  distributional_frequency$convergence,
  0L
)

n_beta <- ncol(X_mu)
distributional_covariance <- solve(distributional_frequency$hessian)
distributional_parameters <- c(
  paste0("mu_", colnames(X_mu)),
  paste0("sigma_", colnames(Z_frequency))
)
mald_distributional_coefficients <- data.frame(
  term = distributional_parameters,
  estimate = distributional_frequency$par,
  standard_error = sqrt(diag(distributional_covariance)),
  conf_low = distributional_frequency$par -
    stats::qnorm(0.975) * sqrt(diag(distributional_covariance)),
  conf_high = distributional_frequency$par +
    stats::qnorm(0.975) * sqrt(diag(distributional_covariance))
)

distributional_comparison <- data.frame(
  model = c("constant scale", "frequency-dependent scale"),
  mean_formula = rep(
    "mu = beta0 + beta_frequency*log_frequency_c + beta_duration*log_duration_c + beta_phones*n_phones_c",
    2L
  ),
  scale_formula = c(
    "log(sigma) = gamma0",
    "log(sigma) = gamma0 + gamma_frequency*log_frequency_c"
  ),
  n_parameters = c(
    length(distributional_constant$par),
    length(distributional_frequency$par)
  ),
  negative_log_likelihood = c(
    distributional_constant$value,
    distributional_frequency$value
  )
)
distributional_comparison$aic <- with(
  distributional_comparison,
  2 * negative_log_likelihood + 2 * n_parameters
)

distributional_grid <- data.frame(
  log_frequency_subtlex = seq(
    stats::quantile(mald$log_frequency_subtlex, 0.01),
    stats::quantile(mald$log_frequency_subtlex, 0.99),
    length.out = 160L
  )
)
distributional_grid$log_frequency_c <-
  distributional_grid$log_frequency_subtlex -
  mean(mald$log_frequency_subtlex)
distributional_grid$log_duration_c <- 0
distributional_grid$n_phones_c <- 0
X_distributional_grid <- stats::model.matrix(
  ~ log_frequency_c + log_duration_c + n_phones_c,
  data = distributional_grid
)
Z_distributional_grid <- stats::model.matrix(
  ~ log_frequency_c,
  data = distributional_grid
)
distributional_grid$fitted_mean_log_rt <- drop(
  X_distributional_grid %*%
    distributional_frequency$par[seq_len(n_beta)]
)
distributional_grid$fitted_sd_log_rt <- exp(drop(
  Z_distributional_grid %*%
    distributional_frequency$par[n_beta + seq_len(ncol(Z_frequency))]
))
distributional_grid$predictive_10 <-
  distributional_grid$fitted_mean_log_rt +
  stats::qnorm(0.10) * distributional_grid$fitted_sd_log_rt
distributional_grid$predictive_90 <-
  distributional_grid$fitted_mean_log_rt +
  stats::qnorm(0.90) * distributional_grid$fitted_sd_log_rt
record_assertion(
  "distributional fitted scales positive",
  all(distributional_grid$fitted_sd_log_rt > 0),
  min(distributional_grid$fitted_sd_log_rt),
  "> 0"
)

# -----------------------------------------------------------------------------
# Sparse scientific figures and plot data
# -----------------------------------------------------------------------------

provo_conditional_plot <- ggplot2::ggplot(
  provo,
  ggplot2::aes(cloze_surprisal_bits, mean_log_ffd)
) +
  ggplot2::geom_point(color = "grey65", alpha = 0.22, size = 0.9) +
  ggplot2::geom_point(
    data = provo_bins,
    ggplot2::aes(mean_cloze_surprisal_bits, mean_log_ffd),
    inherit.aes = FALSE,
    color = "black",
    size = 2
  ) +
  ggplot2::labs(
    x = "Modeled cloze surprisal (bits)",
    y = "Mean log first-fixation duration"
  ) +
  theme_reference()
save_plot(provo_conditional_plot, "figure-provo-conditional-means.png")

provo_fit_plot <- ggplot2::ggplot(
  provo,
  ggplot2::aes(cloze_surprisal_bits, mean_log_ffd)
) +
  ggplot2::geom_point(color = "grey65", alpha = 0.22, size = 0.9) +
  ggplot2::geom_ribbon(
    data = provo_grid,
    ggplot2::aes(
      x = cloze_surprisal_bits,
      ymin = mean_conf_low,
      ymax = mean_conf_high
    ),
    inherit.aes = FALSE,
    fill = "#2C6E9B",
    alpha = 0.18
  ) +
  ggplot2::geom_line(
    data = provo_grid,
    ggplot2::aes(cloze_surprisal_bits, fitted_log_ffd),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    linewidth = 0.8
  ) +
  ggplot2::labs(
    x = "Modeled cloze surprisal (bits)",
    y = "Mean log first-fixation duration"
  ) +
  theme_reference()
save_plot(provo_fit_plot, "figure-provo-linear-fit.png")

provo_response_long <- rbind(
  data.frame(
    scale = "Position geometric mean (ms)",
    value = provo$ffd_geometric_mean_ms
  ),
  data.frame(
    scale = "Mean log first-fixation duration",
    value = provo$mean_log_ffd
  )
)
provo_response_plot <- ggplot2::ggplot(
  provo_response_long,
  ggplot2::aes(value)
) +
  ggplot2::geom_histogram(bins = 30, color = "white", fill = "grey45") +
  ggplot2::facet_wrap(~ scale, scales = "free_x", ncol = 2) +
  ggplot2::labs(x = NULL, y = "Word positions") +
  theme_reference()
save_plot(
  provo_response_plot,
  "figure-provo-response-scales.png",
  width = 7.2,
  height = 3.5
)

provo_residual_plot <- ggplot2::ggplot(
  provo,
  ggplot2::aes(ols_fitted_log_ffd, ols_residual)
) +
  ggplot2::geom_hline(yintercept = 0, color = "grey55", linewidth = 0.35) +
  ggplot2::geom_point(color = "grey60", alpha = 0.25, size = 0.9) +
  ggplot2::geom_smooth(
    method = "loess",
    formula = y ~ x,
    se = FALSE,
    color = "#2C6E9B",
    linewidth = 0.8
  ) +
  ggplot2::labs(x = "Fitted mean log FFD", y = "Residual") +
  theme_reference()
save_plot(provo_residual_plot, "figure-provo-residual-check.png")

provo_qq <- data.frame(
  theoretical_quantile = stats::qnorm(
    (seq_len(nrow(provo)) - 0.5) / nrow(provo)
  ),
  ordered_residual = sort(provo$ols_residual)
)
qq_sample_quartiles <- stats::quantile(provo$ols_residual, c(0.25, 0.75))
qq_normal_quartiles <- stats::qnorm(c(0.25, 0.75))
qq_reference <- list(
  slope = diff(qq_sample_quartiles) / diff(qq_normal_quartiles),
  intercept = qq_sample_quartiles[[1]] -
    (diff(qq_sample_quartiles) / diff(qq_normal_quartiles)) *
    qq_normal_quartiles[[1]]
)
provo_qq_plot <- ggplot2::ggplot(
  provo_qq,
  ggplot2::aes(theoretical_quantile, ordered_residual)
) +
  ggplot2::geom_point(color = "grey50", alpha = 0.45, size = 0.9) +
  ggplot2::geom_abline(
    slope = qq_reference$slope,
    intercept = qq_reference$intercept,
    color = "#2C6E9B",
    linewidth = 0.7
  ) +
  ggplot2::labs(x = "Normal quantile", y = "Ordered residual") +
  theme_reference()
save_plot(provo_qq_plot, "figure-provo-normal-quantile.png")

provo_influence_plot <- ggplot2::ggplot(
  provo,
  ggplot2::aes(cloze_surprisal_bits, mean_log_ffd)
) +
  ggplot2::geom_point(color = "grey70", alpha = 0.18, size = 0.8) +
  ggplot2::geom_line(
    data = provo_grid,
    ggplot2::aes(cloze_surprisal_bits, fitted_log_ffd),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    linewidth = 0.9
  ) +
  ggplot2::geom_line(
    data = provo_grid,
    ggplot2::aes(
      cloze_surprisal_bits,
      fitted_without_most_influential_passage
    ),
    inherit.aes = FALSE,
    color = "black",
    linetype = 2,
    linewidth = 0.7
  ) +
  ggplot2::labs(
    x = "Modeled cloze surprisal (bits)",
    y = "Mean log first-fixation duration"
  ) +
  theme_reference()
save_plot(provo_influence_plot, "figure-provo-passage-influence.png")

provo_bayes_plot <- ggplot2::ggplot(
  provo,
  ggplot2::aes(cloze_surprisal_bits, mean_log_ffd)
) +
  ggplot2::geom_point(color = "grey65", alpha = 0.2, size = 0.8) +
  ggplot2::geom_ribbon(
    data = provo_bayes_grid,
    ggplot2::aes(
      x = cloze_surprisal_bits,
      ymin = posterior_low_log_ffd,
      ymax = posterior_high_log_ffd
    ),
    inherit.aes = FALSE,
    fill = "#2C6E9B",
    alpha = 0.18
  ) +
  ggplot2::geom_line(
    data = provo_bayes_grid,
    ggplot2::aes(cloze_surprisal_bits, posterior_mean_log_ffd),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    linewidth = 0.8
  ) +
  ggplot2::labs(
    x = "Modeled cloze surprisal (bits)",
    y = "Mean log first-fixation duration"
  ) +
  theme_reference()
save_plot(provo_bayes_plot, "figure-provo-bayesian-fit.png")

mald_multiple_plot <- ggplot2::ggplot(
  mald,
  ggplot2::aes(log_frequency_subtlex, mean_log_rt)
) +
  ggplot2::geom_point(color = "grey65", alpha = 0.08, size = 0.65) +
  ggplot2::geom_ribbon(
    data = mald_grid,
    ggplot2::aes(
      x = log_frequency_subtlex,
      ymin = conf_low,
      ymax = conf_high
    ),
    inherit.aes = FALSE,
    fill = "#2C6E9B",
    alpha = 0.18
  ) +
  ggplot2::geom_line(
    data = mald_grid,
    ggplot2::aes(log_frequency_subtlex, fitted_mean_log_rt),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    linewidth = 0.8
  ) +
  ggplot2::labs(
    x = "Log SUBTLEX frequency",
    y = "Mean log lexical-decision time"
  ) +
  theme_reference()
save_plot(mald_multiple_plot, "figure-mald-multiple-fit.png")

mald_pos_plot <- ggplot2::ggplot(
  major_pos,
  ggplot2::aes(part_of_speech, mean_log_rt)
) +
  ggplot2::geom_jitter(
    color = "grey70",
    alpha = 0.08,
    width = 0.16,
    height = 0,
    size = 0.6
  ) +
  ggplot2::geom_pointrange(
    data = mald_pos_predictions,
    ggplot2::aes(
      part_of_speech,
      fitted_mean_log_rt,
      ymin = conf_low,
      ymax = conf_high
    ),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    linewidth = 0.6
  ) +
  ggplot2::labs(
    x = "Frequency-dominant part of speech",
    y = "Mean log lexical-decision time"
  ) +
  theme_reference()
save_plot(mald_pos_plot, "figure-mald-pos-coding.png")

mald_syllable_plot <- ggplot2::ggplot(
  mald,
  ggplot2::aes(syllable_band, mean_log_rt)
) +
  ggplot2::geom_jitter(
    color = "grey70",
    alpha = 0.06,
    width = 0.16,
    height = 0,
    size = 0.55
  ) +
  ggplot2::geom_pointrange(
    data = mald_syllable_predictions,
    ggplot2::aes(
      syllable_band,
      fitted_mean_log_rt,
      ymin = conf_low,
      ymax = conf_high
    ),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    linewidth = 0.6
  ) +
  ggplot2::labs(
    x = "Syllable-count band",
    y = "Mean log lexical-decision time"
  ) +
  theme_reference()
save_plot(mald_syllable_plot, "figure-mald-syllable-coding.png")

interaction_colors <- c(
  Noun = "#1B1B1B",
  Verb = "#2C6E9B",
  Adjective = "#A45A2A"
)
mald_interaction_plot <- ggplot2::ggplot(
  major_pos,
  ggplot2::aes(
    log_frequency_subtlex,
    mean_log_rt,
    color = part_of_speech
  )
) +
  ggplot2::geom_point(alpha = 0.05, size = 0.55) +
  ggplot2::geom_line(
    data = mald_interaction_grid,
    ggplot2::aes(
      log_frequency_subtlex,
      fitted_mean_log_rt,
      color = part_of_speech
    ),
    inherit.aes = FALSE,
    linewidth = 0.85
  ) +
  ggplot2::scale_color_manual(values = interaction_colors) +
  ggplot2::labs(
    x = "Log SUBTLEX frequency",
    y = "Mean log lexical-decision time",
    color = NULL
  ) +
  theme_reference()
save_plot(mald_interaction_plot, "figure-mald-frequency-pos-interaction.png")

phone_syllable_fit <- stats::lm(n_phones ~ n_syllables, data = mald)
phone_syllable_grid <- data.frame(
  n_syllables = sort(unique(mald$n_syllables))
)
phone_syllable_grid$fitted_n_phones <- stats::predict(
  phone_syllable_fit,
  newdata = phone_syllable_grid
)
mald_correlation_plot <- ggplot2::ggplot(
  mald,
  ggplot2::aes(n_syllables, n_phones)
) +
  ggplot2::geom_jitter(
    color = "grey65",
    alpha = 0.06,
    width = 0.08,
    height = 0.08,
    size = 0.55
  ) +
  ggplot2::geom_line(
    data = phone_syllable_grid,
    ggplot2::aes(n_syllables, fitted_n_phones),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    linewidth = 0.8
  ) +
  ggplot2::labs(x = "Syllables", y = "Phones") +
  theme_reference()
save_plot(mald_correlation_plot, "figure-mald-correlated-predictors.png")

mald_ridge_plot <- ggplot2::ggplot(
  mald_ridge_cv,
  ggplot2::aes(lambda, mean_rmse)
) +
  ggplot2::geom_line(color = "#2C6E9B", linewidth = 0.8) +
  ggplot2::geom_vline(
    xintercept = ridge_lambda_min,
    color = "grey35",
    linetype = 3,
    linewidth = 0.5
  ) +
  ggplot2::geom_vline(
    xintercept = ridge_lambda_one_se,
    color = "black",
    linetype = 2,
    linewidth = 0.5
  ) +
  ggplot2::scale_x_log10() +
  ggplot2::labs(
    x = "Ridge penalty",
    y = "New-item cross-validated RMSE"
  ) +
  theme_reference()
save_plot(mald_ridge_plot, "figure-mald-ridge-validation.png")

mald_residualized_plot <- ggplot2::ggplot(
  mald,
  ggplot2::aes(residual_n_phones, residual_mean_log_rt)
) +
  ggplot2::geom_point(color = "grey65", alpha = 0.07, size = 0.55) +
  ggplot2::geom_smooth(
    method = "lm",
    formula = y ~ x,
    se = FALSE,
    color = "#2C6E9B",
    linewidth = 0.8
  ) +
  ggplot2::labs(
    x = "Phone count residual",
    y = "Mean log-RT residual"
  ) +
  theme_reference()
save_plot(mald_residualized_plot, "figure-mald-residualization.png")

mald_heteroscedastic_plot <- ggplot2::ggplot(
  mald,
  ggplot2::aes(log_frequency_subtlex, abs(multiple_residual))
) +
  ggplot2::geom_point(color = "grey70", alpha = 0.045, size = 0.5) +
  ggplot2::geom_line(
    data = mald_heteroscedastic_bins,
    ggplot2::aes(mean_log_frequency, mean_absolute_residual),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    linewidth = 0.8
  ) +
  ggplot2::geom_point(
    data = mald_heteroscedastic_bins,
    ggplot2::aes(mean_log_frequency, mean_absolute_residual),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    size = 1.6
  ) +
  ggplot2::labs(
    x = "Log SUBTLEX frequency",
    y = "Absolute residual"
  ) +
  theme_reference()
save_plot(mald_heteroscedastic_plot, "figure-mald-heteroscedasticity.png")

mald_distributional_scale_plot <- ggplot2::ggplot(
  mald,
  ggplot2::aes(log_frequency_subtlex, sd_log_rt)
) +
  ggplot2::geom_point(color = "grey70", alpha = 0.045, size = 0.5) +
  ggplot2::geom_line(
    data = distributional_grid,
    ggplot2::aes(log_frequency_subtlex, fitted_sd_log_rt),
    inherit.aes = FALSE,
    color = "#2C6E9B",
    linewidth = 0.85
  ) +
  ggplot2::labs(
    x = "Log SUBTLEX frequency",
    y = "Log-RT standard deviation"
  ) +
  theme_reference()
save_plot(
  mald_distributional_scale_plot,
  "figure-mald-distributional-scale.png"
)

# -----------------------------------------------------------------------------
# Page map, outputs, and reproducibility record
# -----------------------------------------------------------------------------

page_map <- data.frame(
  page = c(
    "regression-models.qmd",
    "simple-linear-regression.qmd",
    "centering-predictors.qmd",
    "response-transformations.qmd",
    "frequentist-linear-regression.qmd",
    "linear-regression-uncertainty.qmd",
    "coefficient-of-determination.qmd",
    "residuals.qmd",
    "checking-linear-regression.qmd",
    "leverage-and-influence.qmd",
    "influence.qmd",
    "bayesian-linear-regression.qmd",
    "multiple-regression.qmd",
    "design-matrices.qmd",
    "coding-categorical-predictors.qmd",
    "sum-coding.qmd",
    "helmert-coding.qmd",
    "inverse-helmert-coding.qmd",
    "interactions.qmd",
    "correlated-predictors.qmd",
    "variance-inflation-factors.qmd",
    "ridge-regression.qmd",
    "residualizing-a-predictor.qmd",
    "heteroscedasticity.qmd",
    "distributional-regression.qmd"
  ),
  dataset = c(rep("Provo Corpus", 12L), rep("MALD 1.1", 13L)),
  observational_unit = c(
    rep("content-word position aggregated across readers", 12L),
    rep("word item summarized over correct retained trials", 13L)
  ),
  exact_formula_or_object = c(
    "empirical E[mean_log_ffd | cloze-surprisal bin]",
    "mean_log_ffd ~ cloze_surprisal_c",
    "mean_log_ffd ~ cloze_surprisal_bits; same fit after mean centering",
    "ffd_geometric_mean_ms = exp(mean_log_ffd); lognormal mean uses exp(mu + sigma^2/2)",
    "mean_log_ffd ~ cloze_surprisal_c by OLS",
    "OLS coefficient covariance; HC1 passage-cluster sensitivity",
    "1 - SSE/SST for mean_log_ffd ~ cloze_surprisal_c",
    "e_i = mean_log_ffd_i - fitted_i",
    "linear fit plus quadratic diagnostic and passage residual summaries",
    "hatvalues(mean_log_ffd ~ cloze_surprisal_c)",
    "Cook distance by position; leave-one-passage-out slope",
    "normal-inverse-gamma bridge for mean_log_ffd ~ cloze_surprisal_c",
    "mean_log_rt ~ log_frequency_c + log_duration_c + n_phones_c",
    "model.matrix(mean_log_rt ~ log_frequency_c + log_duration_c + n_phones_c)",
    "mean_log_rt ~ POS + log_frequency_c + log_duration_c + n_phones_c; noun reference",
    "same POS model with contr.sum(3)",
    "mean_log_rt ~ syllable_band + log_frequency_c + log_duration_c; contr.helmert(4)",
    "same syllable model with explicit earlier-versus-later matrix",
    "mean_log_rt ~ log_frequency_c * POS + log_duration_c + n_phones_c",
    "cor(log_frequency, log_duration, phones, syllables) and auxiliary regressions",
    "VIF_j = 1/(1 - R_j^2) for the four item predictors",
    "ridge mean_log_rt on frequency, duration, phones, syllables; new-item 10-fold CV",
    "phones residualized on syllables, duration, frequency; response model retains controls",
    "absolute residual and within-item log-RT SD by frequency bin; HC3 sensitivity",
    "mu ~ frequency + duration + phones; log(sigma) ~ frequency using grouped Gaussian sufficient statistics"
  ),
  status = c(
    rep("passed", 3L),
    "passed with scope limit",
    rep("passed", 7L),
    "passed as empirical-Bayes bridge",
    rep("passed", 6L),
    "passed as exploratory extension",
    rep("passed", 6L)
  ),
  figure = c(
    "figure-provo-conditional-means.png",
    "figure-provo-linear-fit.png",
    "figure-provo-linear-fit.png",
    "figure-provo-response-scales.png",
    "figure-provo-linear-fit.png",
    "figure-provo-linear-fit.png",
    "figure-provo-linear-fit.png",
    "figure-provo-residual-check.png",
    "figure-provo-residual-check.png; figure-provo-normal-quantile.png",
    "figure-provo-passage-influence.png",
    "figure-provo-passage-influence.png",
    "figure-provo-bayesian-fit.png",
    "figure-mald-multiple-fit.png",
    "figure-mald-multiple-fit.png",
    "figure-mald-pos-coding.png",
    "figure-mald-pos-coding.png",
    "figure-mald-syllable-coding.png",
    "figure-mald-syllable-coding.png",
    "figure-mald-frequency-pos-interaction.png",
    "figure-mald-correlated-predictors.png",
    "figure-mald-correlated-predictors.png",
    "figure-mald-ridge-validation.png",
    "figure-mald-residualization.png",
    "figure-mald-heteroscedasticity.png",
    "figure-mald-distributional-scale.png"
  ),
  stringsAsFactors = FALSE
)

planned_limits <- data.frame(
  analysis = c(
    "Provo response transformation",
    "Provo OLS uncertainty",
    "Provo Bayesian bridge",
    "MALD item-level regressions",
    "MALD POS interaction",
    "MALD Helmert sequence",
    "MALD ridge",
    "MALD distributional regression",
    "English Lexicon Project"
  ),
  state = c(
    "scope-limited",
    "scope-limited",
    "scope-limited",
    "scope-limited",
    "exploratory",
    "scope-limited",
    "result-dependent",
    "scope-limited",
    "not used"
  ),
  consequence = c(
    "The prepared table already averages log FFD by word position. It can show the exact log/back-transform relation for observed position summaries, but it cannot diagnose reader-level RT skew or compare raw-trial residuals.",
    "Reader observations were aggregated. Naive OLS uncertainty is retained for the derivation and compared with passage-clustered covariance, but neither analysis recovers reader-level variance.",
    "Prior location and scale use observed Provo scales. The fit is an empirical-Bayes teaching bridge, not an independently prior-specified confirmatory model.",
    "The item table contains correct-trial summaries and no participant IDs. Its coefficients describe item-level associations; they are not substitutes for a crossed participant-item model.",
    "The resource paper establishes frequency as a response-time predictor and defines POS, but it did not test their interaction. The interaction is a descriptive teaching extension and must be labeled as such.",
    "The 4+ syllable band is ordered but internally heterogeneous. Helmert coefficients demonstrate declared comparisons and should not be read as equal one-syllable increments.",
    "Minimum-error validation selects almost no shrinkage; the one-standard-error rule selects more shrinkage with similar held-out error. The page must report both and cannot claim a predictive gain that the data do not show.",
    "The grouped Gaussian likelihood treats correct trials as conditionally independent and cannot represent participant effects. It demonstrates separate mean and scale equations only.",
    "ELP terms and redistribution were unresolved in the course audit, so no ELP data enter this run."
  ),
  stringsAsFactors = FALSE
)

seeds <- data.frame(
  purpose = c(
    "script initialization",
    "Provo posterior draws",
    "MALD new-item fold assignment"
  ),
  seed = c(seed, bayes_draw_seed, ridge_seed),
  stringsAsFactors = FALSE
)

package_versions <- data.frame(
  package = c("R", required_packages),
  version = c(
    paste(R.version$major, R.version$minor, sep = "."),
    vapply(
      required_packages,
      function(package) as.character(utils::packageVersion(package)),
      character(1)
    )
  ),
  stringsAsFactors = FALSE
)

provo_output <- provo[, c(
  "position_id", "Text_ID", "Word_Number", "Word_POS", "n_fixations",
  "cloze_probability", "cloze_surprisal_bits", "cloze_surprisal_c",
  "mean_log_ffd", "ffd_geometric_mean_ms", "ols_fitted_log_ffd",
  "ols_residual", "leverage", "cooks_distance", "surprisal_bin"
)]
mald_output <- mald[, c(
  "item", "part_of_speech", "n_observations", "mean_rt_ms", "mean_log_rt",
  "sd_log_rt", "log_frequency_subtlex", "log_frequency_c", "duration_ms",
  "log_duration", "log_duration_c", "n_phones", "n_phones_c",
  "n_syllables", "n_syllables_c", "syllable_band", "multiple_fitted",
  "multiple_residual", "frequency_bin", "residual_n_phones",
  "residual_mean_log_rt"
)]

write_csv(page_map, "page-map.csv")
write_csv(bind_rows_base(coefficient_tables), "model-coefficients.csv")
write_csv(bind_rows_base(model_summaries), "model-fit-summary.csv")
write_csv(provo_output, "provo-analysis-data.csv")
write_csv(provo_bins, "provo-conditional-bins.csv")
write_csv(provo_grid, "provo-prediction-grid.csv")
write_csv(provo_qq, "provo-normal-quantile-data.csv")
write_csv(provo_passage_residuals, "provo-passage-residuals.csv")
write_csv(provo_passage_deletion, "provo-passage-deletion.csv")
write_csv(posterior_summary, "provo-bayesian-summary.csv")
write_csv(provo_bayes_grid, "provo-bayesian-predictions.csv")
write_csv(provo_prior_hyperparameters, "provo-bayesian-prior.csv")
write_csv(mald_output, "mald-analysis-data.csv")
write_csv(mald_grid, "mald-multiple-prediction-grid.csv")
write_csv(mald_design_matrix, "mald-design-matrix.csv")
write_csv(mald_pos_predictions, "mald-pos-predictions.csv")
write_csv(mald_syllable_predictions, "mald-syllable-predictions.csv")
write_csv(mald_contrast_matrices, "mald-syllable-contrast-matrices.csv")
write_csv(mald_interaction_grid, "mald-interaction-prediction-grid.csv")
write_csv(mald_correlations, "mald-correlations.csv")
write_csv(mald_vif, "mald-vif.csv")
write_csv(mald_ridge_cv, "mald-ridge-cv.csv")
write_csv(mald_ridge_coefficients, "mald-ridge-coefficients.csv")
write_csv(mald_ridge_predictions, "mald-ridge-heldout-predictions.csv")
write_csv(mald_residualization_cv, "mald-residualization-folds.csv")
write_csv(mald_heteroscedastic_bins, "mald-heteroscedastic-bins.csv")
write_csv(mald_uncertainty_comparison, "mald-uncertainty-comparison.csv")
write_csv(mald_distributional_coefficients, "mald-distributional-coefficients.csv")
write_csv(distributional_comparison, "mald-distributional-comparison.csv")
write_csv(distributional_grid, "mald-distributional-grid.csv")
write_csv(planned_limits, "failed-or-remapped.csv")
write_csv(seeds, "seeds.csv")
write_csv(package_versions, "package-versions.csv")
write_csv(bind_rows_base(assertions), "assertions.csv")

capture.output(utils::sessionInfo(), file = file.path(output_dir, "session-info.txt"))

run_summary <- c(
  "Reference linear-regression analysis completed.",
  paste("Provo positions:", nrow(provo)),
  paste("Provo passages:", length(unique(provo$Text_ID))),
  paste("Provo centered slope:", signif(coef(provo_fit)[[2]], 8)),
  paste("Provo R squared:", signif(summary(provo_fit)$r.squared, 8)),
  paste("MALD items:", nrow(mald)),
  paste("MALD multiple-regression R squared:",
        signif(summary(mald_multiple)$r.squared, 8)),
  paste("Ridge minimum-error lambda:", signif(ridge_lambda_min, 8)),
  paste("Ridge one-SE lambda:", signif(ridge_lambda_one_se, 8)),
  paste("Ridge one-SE held-out RMSE:",
        signif(sqrt(mean(mald_ridge_predictions$ridge_squared_error)), 8)),
  paste("OLS held-out RMSE:",
        signif(sqrt(mean(mald_ridge_predictions$ols_squared_error)), 8)),
  paste("Distributional constant-scale AIC:",
        signif(distributional_comparison$aic[[1]], 10)),
  paste("Distributional frequency-scale AIC:",
        signif(distributional_comparison$aic[[2]], 10)),
  paste("Assertions passed:", length(assertions)),
  paste("Seed:", seed)
)
writeLines(run_summary, file.path(output_dir, "run-summary.txt"))
cat(paste(run_summary, collapse = "\n"), "\n")
