#!/usr/bin/env Rscript

# Paper-first reference analyses for the non-mixed generalized-model sequence.
# This script writes research artifacts only. It never edits course notes or data.

required_packages <- c(
  "digest", "ggplot2", "jsonlite", "lme4", "MASS", "ordinal"
)
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Missing required packages: ", paste(missing_packages, collapse = ", "))
}

args <- commandArgs(trailingOnly = TRUE)
output_dir <- if (length(args)) args[[1L]] else
  "research/dataset-audits/reference-generalized-models-output"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

options(stringsAsFactors = FALSE)
set.seed(20261018L)

write_csv <- function(x, name) {
  utils::write.csv(x, file.path(output_dir, name), row.names = FALSE,
                   na = "")
}

assert_close <- function(observed, expected, tolerance, label) {
  if (!isTRUE(all.equal(observed, expected, tolerance = tolerance))) {
    stop(label, ": observed ", paste(observed, collapse = ", "),
         "; expected ", paste(expected, collapse = ", "))
  }
}

theme_reference <- function() {
  ggplot2::theme_classic(base_size = 11) +
    ggplot2::theme(
      legend.position = "top",
      legend.title = ggplot2::element_blank(),
      strip.background = ggplot2::element_blank()
    )
}

save_plot <- function(plot, name, width = 6.5, height = 4.2) {
  ggplot2::ggsave(
    file.path(output_dir, name), plot,
    width = width, height = height, device = "pdf"
  )
}

tidy_coef <- function(model, dataset, model_name) {
  table <- stats::coef(summary(model))
  data.frame(
    dataset = dataset,
    model = model_name,
    term = rownames(table),
    estimate = table[, "Estimate"],
    standard_error = table[, "Std. Error"],
    statistic = table[, grep("value$", colnames(table))[[1L]]],
    row.names = NULL,
    check.names = FALSE
  )
}

ordinal_probabilities <- function(fit, newdata, fixed_formula) {
  design <- stats::model.matrix(fixed_formula, newdata)
  beta <- fit$beta
  eta <- drop(design[, names(beta), drop = FALSE] %*% beta)
  cumulative <- stats::plogis(outer(
    eta, fit$alpha,
    function(linear_predictor, threshold) threshold - linear_predictor
  ))
  probabilities <- cbind(
    cumulative[, 1L],
    cumulative[, 2:ncol(cumulative), drop = FALSE] -
      cumulative[, 1:(ncol(cumulative) - 1L), drop = FALSE],
    1 - cumulative[, ncol(cumulative)]
  )
  probabilities <- pmax(probabilities, 1e-12)
  probabilities / rowSums(probabilities)
}

score_ordinal <- function(probabilities, outcome) {
  log(probabilities[cbind(seq_along(outcome), as.integer(outcome))])
}

# Ordered-beta negative log likelihood used by both bounded-response audits.
# Endpoint probabilities come from an ordered logit; conditional interior
# responses follow a beta distribution. The upper cutpoint and precision are
# transformed so every optimizer proposal respects their support.
ordered_beta_nll <- function(parameters, y, design) {
  beta <- parameters[seq_len(ncol(design))]
  lower_cutpoint <- parameters[ncol(design) + 1L]
  upper_cutpoint <- lower_cutpoint +
    exp(parameters[ncol(design) + 2L])
  precision <- exp(parameters[ncol(design) + 3L])
  eta <- drop(design %*% beta)
  probability_zero <- stats::plogis(lower_cutpoint - eta)
  probability_one <- stats::plogis(eta - upper_cutpoint)
  probability_interior <- pmax(
    1 - probability_zero - probability_one, 1e-15
  )
  interior_mean <- stats::plogis(eta)
  log_likelihood <- numeric(length(y))
  is_zero <- y == 0
  is_one <- y == 1
  is_interior <- !is_zero & !is_one
  log_likelihood[is_zero] <- log(pmax(probability_zero[is_zero], 1e-15))
  log_likelihood[is_one] <- log(pmax(probability_one[is_one], 1e-15))
  log_likelihood[is_interior] <-
    log(probability_interior[is_interior]) +
    stats::dbeta(
      y[is_interior],
      interior_mean[is_interior] * precision,
      (1 - interior_mean[is_interior]) * precision,
      log = TRUE
    )
  if (any(!is.finite(log_likelihood))) return(1e100)
  -sum(log_likelihood)
}

# ---------------------------------------------------------------------------
# SuperTelicity: binary support, link, Bernoulli likelihood, IRLS, deviance,
# odds, single- and multiple-predictor logistic models, and residuals.
# ---------------------------------------------------------------------------

st <- utils::read.csv(
  "data/supertelicity/supertelicity-cloze.csv",
  check.names = FALSE
)
stopifnot(
  nrow(st) == 9160L,
  length(unique(st$participant_id)) == 200L,
  length(unique(st$sentence_id)) == 574L,
  length(unique(st$verb)) == 40L,
  all(st$prep_in %in% 0:1),
  sum(is.na(st$log_duration_minutes)) == 3780L
)
st$verb_type <- factor(st$verb_type, levels = c("manner", "result"))
st$contentfulness <- factor(
  st$contentfulness,
  levels = c("contentful", "bleached", "templatic")
)
st$duration_centered <- st$log_duration_minutes -
  mean(st$log_duration_minutes, na.rm = TRUE)

st_binary <- as.data.frame.matrix(table(st$verb_type, st$preposition))
st_binary$verb_type <- rownames(st_binary)
rownames(st_binary) <- NULL
names(st_binary)[1:2] <- c("for_count", "in_count")
st_binary$total <- st_binary$for_count + st_binary$in_count
st_binary$in_probability <- st_binary$in_count / st_binary$total
st_binary$odds_in <- st_binary$in_probability /
  (1 - st_binary$in_probability)
write_csv(st_binary, "supertelicity-binary-summary.csv")

st_lpm <- stats::lm(
  prep_in ~ duration_centered + verb_type,
  data = st,
  na.action = stats::na.exclude
)
st_duration_logit <- stats::glm(
  prep_in ~ duration_centered + verb_type,
  family = stats::binomial(link = "logit"),
  data = st,
  na.action = stats::na.exclude
)
st_simple <- stats::glm(
  prep_in ~ verb_type,
  family = stats::binomial(link = "logit"),
  data = st
)
st_additive <- stats::glm(
  prep_in ~ verb_type + contentfulness,
  family = stats::binomial(link = "logit"),
  data = st
)
st_interaction <- stats::glm(
  prep_in ~ verb_type * contentfulness,
  family = stats::binomial(link = "logit"),
  data = st
)

st_duration_grid <- expand.grid(
  duration_centered = seq(
    min(st$duration_centered, na.rm = TRUE),
    max(st$duration_centered, na.rm = TRUE),
    length.out = 201L
  ),
  verb_type = levels(st$verb_type)
)
st_duration_grid$log_duration_minutes <- st_duration_grid$duration_centered +
  mean(st$log_duration_minutes, na.rm = TRUE)
st_duration_grid$linear_probability <- stats::predict(
  st_lpm, newdata = st_duration_grid
)
st_duration_grid$logistic_probability <- stats::predict(
  st_duration_logit, newdata = st_duration_grid, type = "response"
)
write_csv(st_duration_grid, "supertelicity-duration-predictions.csv")

st_complete <- st[!is.na(st$log_duration_minutes), ]
duration_breaks <- unique(stats::quantile(
  st_complete$log_duration_minutes,
  probs = seq(0, 1, length.out = 13L), na.rm = TRUE
))
st_complete$duration_bin <- cut(
  st_complete$log_duration_minutes,
  breaks = duration_breaks, include.lowest = TRUE
)
st_binned <- stats::aggregate(
  cbind(prep_in, log_duration_minutes) ~ duration_bin + verb_type,
  data = st_complete,
  FUN = mean
)
names(st_binned)[names(st_binned) == "prep_in"] <- "empirical_probability"
write_csv(st_binned, "supertelicity-duration-bins.csv")

st_support_plot <- ggplot2::ggplot() +
  ggplot2::geom_hline(
    yintercept = c(0, 1), color = "grey75", linewidth = 0.35
  ) +
  ggplot2::geom_point(
    data = st_binned,
    ggplot2::aes(
      x = log_duration_minutes, y = empirical_probability,
      shape = verb_type
    ),
    size = 1.7
  ) +
  ggplot2::geom_line(
    data = st_duration_grid,
    ggplot2::aes(
      x = log_duration_minutes, y = linear_probability,
      linetype = verb_type
    ),
    color = "grey55", linewidth = 0.6
  ) +
  ggplot2::geom_line(
    data = st_duration_grid,
    ggplot2::aes(
      x = log_duration_minutes, y = logistic_probability,
      linetype = verb_type
    ),
    color = "#1F5A85", linewidth = 0.8
  ) +
  ggplot2::labs(
    x = "Selected duration (log minutes)",
    y = "Probability of an in-completion",
    shape = NULL, linetype = NULL
  ) +
  ggplot2::coord_cartesian(ylim = c(-0.4, 1.1)) +
  theme_reference()
save_plot(st_support_plot, "supertelicity-support-and-link.pdf")

st_cell_raw <- stats::aggregate(
  prep_in ~ verb_type + contentfulness,
  data = st, FUN = mean
)
st_cell_raw$n <- as.integer(table(st$verb_type, st$contentfulness))
st_cell_raw$fit_additive <- stats::predict(
  st_additive, newdata = st_cell_raw, type = "response"
)
st_cell_raw$fit_interaction <- stats::predict(
  st_interaction, newdata = st_cell_raw, type = "response"
)
write_csv(st_cell_raw, "supertelicity-cell-probabilities.csv")

st_cell_plot <- ggplot2::ggplot(
  st_cell_raw,
  ggplot2::aes(x = contentfulness, group = verb_type, shape = verb_type)
) +
  ggplot2::geom_point(
    ggplot2::aes(y = prep_in), size = 2.2, position =
      ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::geom_line(
    ggplot2::aes(y = fit_interaction, linetype = verb_type),
    color = "#1F5A85", linewidth = 0.75,
    position = ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::labs(
    x = NULL, y = "Probability of an in-completion",
    shape = NULL, linetype = NULL
  ) +
  ggplot2::scale_y_continuous(limits = c(0, 1)) +
  theme_reference()
save_plot(st_cell_plot, "supertelicity-raw-and-fitted.pdf")

# IRLS for the actual one-predictor logistic model. The rows and responses are
# observed; only the provisional optimization path is algorithmic.
X_st <- stats::model.matrix(~ verb_type, data = st)
y_st <- st$prep_in
beta_st <- rep(0, ncol(X_st))
irls_rows <- list()
for (iteration in seq_len(25L)) {
  eta <- drop(X_st %*% beta_st)
  probability <- stats::plogis(eta)
  weight <- pmax(probability * (1 - probability), 1e-12)
  working_response <- eta + (y_st - probability) / weight
  XWX <- crossprod(X_st, X_st * weight)
  XWz <- crossprod(X_st, weight * working_response)
  beta_new <- drop(solve(XWX, XWz))
  fitted_new <- stats::plogis(drop(X_st %*% beta_new))
  log_likelihood <- sum(stats::dbinom(
    y_st, size = 1, prob = fitted_new, log = TRUE
  ))
  irls_rows[[iteration]] <- data.frame(
    iteration = iteration,
    intercept = beta_new[[1L]],
    verb_type_result = beta_new[[2L]],
    log_likelihood = log_likelihood,
    maximum_step = max(abs(beta_new - beta_st))
  )
  if (max(abs(beta_new - beta_st)) < 1e-10) break
  beta_st <- beta_new
}
st_irls <- do.call(rbind, irls_rows)
write_csv(st_irls, "supertelicity-irls.csv")
assert_close(
  as.numeric(tail(st_irls[, c("intercept", "verb_type_result")], 1L)),
  unname(stats::coef(st_simple)), 1e-7,
  "IRLS must recover glm coefficients"
)

st_deviance <- data.frame(
  model = c("intercept_only", "verb_type", "additive", "interaction"),
  parameters = c(1L, 2L, 4L, 6L),
  residual_deviance = c(
    st_simple$null.deviance,
    st_simple$deviance,
    st_additive$deviance,
    st_interaction$deviance
  ),
  residual_df = c(
    st_simple$df.null,
    st_simple$df.residual,
    st_additive$df.residual,
    st_interaction$df.residual
  ),
  AIC = c(
    stats::AIC(stats::glm(prep_in ~ 1, family = stats::binomial(), data = st)),
    stats::AIC(st_simple), stats::AIC(st_additive),
    stats::AIC(st_interaction)
  )
)
write_csv(st_deviance, "supertelicity-deviance.csv")

st$residual_deviance <- stats::residuals(st_interaction, type = "deviance")
st$residual_pearson <- stats::residuals(st_interaction, type = "pearson")
st$residual_fitted <- stats::fitted(st_interaction)
st_verb_residual <- stats::aggregate(
  cbind(prep_in, residual_deviance, residual_pearson, residual_fitted) ~
    verb + verb_type,
  data = st, FUN = mean
)
names(st_verb_residual)[names(st_verb_residual) == "prep_in"] <-
  "empirical_probability"
write_csv(st_verb_residual, "supertelicity-residuals-by-verb.csv")

st_residual_plot <- ggplot2::ggplot(
  st_verb_residual,
  ggplot2::aes(x = residual_fitted, y = empirical_probability,
               shape = verb_type)
) +
  ggplot2::geom_abline(
    slope = 1, intercept = 0, color = "grey65", linewidth = 0.45
  ) +
  ggplot2::geom_point(alpha = 0.8, size = 1.8) +
  ggplot2::labs(
    x = "Fitted in-probability",
    y = "Empirical in-probability by verb",
    shape = NULL
  ) +
  ggplot2::coord_equal(xlim = c(0, 1), ylim = c(0, 1)) +
  theme_reference()
save_plot(st_residual_plot, "supertelicity-verb-calibration.pdf", 5.2, 4.5)

# ---------------------------------------------------------------------------
# Nettle: log-linked Poisson means, geographic exposure, dispersion, and
# quasi-Poisson uncertainty. This is a course reanalysis, not Nettle's exact
# original log-linear specification (which estimated the area coefficient).
# ---------------------------------------------------------------------------

nettle <- utils::read.csv(
  "data/nettle/nettle-1999-climate.csv",
  check.names = FALSE
)
stopifnot(
  nrow(nettle) == 74L,
  min(nettle$language_count) == 1L,
  max(nettle$language_count) == 862L,
  min(nettle$mean_growing_season_months) == 0,
  max(nettle$mean_growing_season_months) == 12
)

nettle_poisson <- stats::glm(
  language_count ~ mean_growing_season_months + offset(log_area_km2),
  family = stats::poisson(link = "log"), data = nettle
)
nettle_quasi <- stats::glm(
  language_count ~ mean_growing_season_months + offset(log_area_km2),
  family = stats::quasipoisson(link = "log"), data = nettle
)
nettle_mismatched <- stats::glm(
  language_count ~ mean_growing_season_months + offset(log10_area_km2),
  family = stats::poisson(link = "log"), data = nettle
)
nettle_dispersion <- sum(
  stats::residuals(nettle_poisson, type = "pearson")^2
) / stats::df.residual(nettle_poisson)
assert_close(nettle_dispersion, 207.99, 0.02, "Nettle dispersion")

nettle_grid <- data.frame(
  mean_growing_season_months = seq(0, 12, length.out = 121L),
  log_area_km2 = 0
)
nettle_grid$fitted_languages_per_km2 <- stats::predict(
  nettle_poisson, newdata = nettle_grid, type = "response"
)
nettle$observed_languages_per_km2 <-
  nettle$language_count / exp(nettle$log_area_km2)
nettle$fitted_language_count <- stats::fitted(nettle_poisson)
nettle$pearson_residual <- stats::residuals(
  nettle_poisson, type = "pearson"
)
write_csv(nettle_grid, "nettle-rate-predictions.csv")
write_csv(nettle, "nettle-observed-and-fitted.csv")

nettle_rate_plot <- ggplot2::ggplot(
  nettle,
  ggplot2::aes(
    x = mean_growing_season_months,
    y = observed_languages_per_km2
  )
) +
  ggplot2::geom_point(size = 1.7, alpha = 0.75) +
  ggplot2::geom_line(
    data = nettle_grid,
    ggplot2::aes(y = fitted_languages_per_km2),
    color = "#1F5A85", linewidth = 0.8
  ) +
  ggplot2::scale_y_log10() +
  ggplot2::labs(
    x = "Mean growing season (months)",
    y = "Languages per square kilometer (log scale)"
  ) +
  theme_reference()
save_plot(nettle_rate_plot, "nettle-poisson-rate.pdf")

nettle_dispersion_plot <- ggplot2::ggplot(
  nettle,
  ggplot2::aes(x = fitted_language_count, y = pearson_residual)
) +
  ggplot2::geom_hline(
    yintercept = 0, color = "grey65", linewidth = 0.4
  ) +
  ggplot2::geom_point(size = 1.7, alpha = 0.8) +
  ggplot2::scale_x_log10() +
  ggplot2::labs(
    x = "Fitted language count (log scale)",
    y = "Pearson residual"
  ) +
  theme_reference()
save_plot(nettle_dispersion_plot, "nettle-poisson-dispersion.pdf")

# ---------------------------------------------------------------------------
# Storme: reconstructed word counts, zero pattern, and negative-binomial
# repair. Fit both the approved teaching simplification and the paper-aligned
# liaison-by-consonant interaction.
# ---------------------------------------------------------------------------

storme <- utils::read.csv(
  "data/storme-liaison/storme-liaison-counts.csv",
  check.names = FALSE
)
stopifnot(
  nrow(storme) == 11195L,
  sum(storme$liaison == "yes") == 4925L,
  sum(storme$liaison == "no") == 6270L,
  all(storme$reconstructed_count >= 0L)
)
storme$liaison <- factor(storme$liaison, levels = c("no", "yes"))
storme$final_consonant <- factor(storme$final_consonant)

storme_poisson <- stats::glm(
  reconstructed_count ~ liaison + final_consonant,
  family = stats::poisson(link = "log"), data = storme
)
storme_nb <- MASS::glm.nb(
  reconstructed_count ~ liaison + final_consonant,
  data = storme,
  control = stats::glm.control(maxit = 100L)
)
storme_nb_interaction <- MASS::glm.nb(
  reconstructed_count ~ liaison * final_consonant,
  data = storme,
  control = stats::glm.control(maxit = 100L)
)
storme_poisson_dispersion <- sum(
  stats::residuals(storme_poisson, type = "pearson")^2
) / stats::df.residual(storme_poisson)
assert_close(
  storme_poisson_dispersion, 1365928, 1,
  "Storme Poisson dispersion"
)

storme_grid <- expand.grid(
  liaison = levels(storme$liaison),
  final_consonant = levels(storme$final_consonant)
)
storme_grid$poisson_mean <- stats::predict(
  storme_poisson, newdata = storme_grid, type = "response"
)
storme_grid$negative_binomial_mean <- stats::predict(
  storme_nb, newdata = storme_grid, type = "response"
)
storme_grid$interaction_mean <- stats::predict(
  storme_nb_interaction, newdata = storme_grid, type = "response"
)
storme_interaction_wide <- reshape(
  storme_grid[c("liaison", "final_consonant", "interaction_mean")],
  idvar = "final_consonant", timevar = "liaison", direction = "wide"
)
names(storme_interaction_wide) <- sub(
  "interaction_mean\\.", "mean_", names(storme_interaction_wide)
)
storme_interaction_wide$liaison_mean_ratio <- with(
  storme_interaction_wide, mean_yes / mean_no
)
storme_interaction_wide$liaison_log_mean_ratio <- log(
  storme_interaction_wide$liaison_mean_ratio
)
write_csv(
  storme_interaction_wide, "storme-interaction-contrasts.csv"
)
storme_raw_cell <- stats::aggregate(
  reconstructed_count ~ liaison + final_consonant,
  data = storme,
  FUN = function(x) c(
    observations = length(x), mean = mean(x), median = stats::median(x),
    variance = stats::var(x), zero_probability = mean(x == 0)
  )
)
storme_raw_cell <- cbind(
  storme_raw_cell[c("liaison", "final_consonant")],
  as.data.frame(storme_raw_cell$reconstructed_count)
)
storme_cell <- merge(
  storme_raw_cell, storme_grid,
  by = c("liaison", "final_consonant"), sort = FALSE
)

storme$poisson_mean <- stats::fitted(storme_poisson)
storme$nb_mean <- stats::fitted(storme_nb)
storme$nb_zero_probability <- stats::dnbinom(
  0L, size = storme_nb$theta, mu = storme$nb_mean
)
storme$poisson_zero_probability <- stats::dpois(
  0L, lambda = storme$poisson_mean
)
storme_zero <- stats::aggregate(
  cbind(
    observed_zero = as.numeric(storme$reconstructed_count == 0L),
    poisson_zero_probability,
    nb_zero_probability
  ) ~ liaison,
  data = storme, FUN = mean
)
write_csv(storme_cell, "storme-cell-summary-and-fits.csv")
write_csv(storme_zero, "storme-zero-check.csv")

storme_sample <- do.call(rbind, lapply(
  split(storme, interaction(storme$liaison, storme$final_consonant)),
  function(x) {
    if (nrow(x) <= 240L) x else x[seq(1L, nrow(x), length.out = 240L), ]
  }
))
storme_count_plot <- ggplot2::ggplot(
  storme_sample,
  ggplot2::aes(x = liaison, y = reconstructed_count)
) +
  ggplot2::geom_point(
    position = ggplot2::position_jitter(width = 0.12, height = 0),
    alpha = 0.12, size = 0.65
  ) +
  ggplot2::geom_point(
    data = storme_cell,
    ggplot2::aes(y = interaction_mean),
    color = "#1F5A85", size = 2
  ) +
  ggplot2::scale_y_continuous(
    transform = "log1p",
    breaks = c(0, 10, 1000, 100000, 1000000),
    labels = c("0", "10", "1k", "100k", "1m")
  ) +
  ggplot2::facet_wrap(~ final_consonant, scales = "free_x") +
  ggplot2::labs(
    x = "Liaison status",
    y = "Reconstructed token count (log1p scale)"
  ) +
  theme_reference()
save_plot(storme_count_plot, "storme-raw-and-negative-binomial.pdf", 7.2, 4.1)

storme_zero_long <- rbind(
  data.frame(
    liaison = storme_zero$liaison, model = "Observed",
    zero_probability = storme_zero$observed_zero
  ),
  data.frame(
    liaison = storme_zero$liaison, model = "Poisson",
    zero_probability = storme_zero$poisson_zero_probability
  ),
  data.frame(
    liaison = storme_zero$liaison, model = "Negative binomial",
    zero_probability = storme_zero$nb_zero_probability
  )
)
storme_zero_long$model <- factor(
  storme_zero_long$model,
  levels = c("Observed", "Poisson", "Negative binomial")
)
storme_zero_plot <- ggplot2::ggplot(
  storme_zero_long,
  ggplot2::aes(x = model, y = zero_probability, shape = liaison)
) +
  ggplot2::geom_point(
    position = ggplot2::position_dodge(width = 0.35), size = 2
  ) +
  ggplot2::labs(
    x = NULL, y = "Probability of a zero", shape = NULL
  ) +
  ggplot2::scale_y_continuous(limits = c(0, 0.35)) +
  theme_reference()
save_plot(storme_zero_plot, "storme-zero-check.pdf", 5.8, 3.8)

# ---------------------------------------------------------------------------
# MegaVeridicality: empirical category probabilities and population
# cumulative-logit regression. Participant and verb dependence remain for the
# later ordinal-mixed page; this model is a teaching bridge, not a confirmatory
# replication of the paper's responsivity analysis.
# ---------------------------------------------------------------------------

mv <- utils::read.csv(
  "data/megaveridicality/megaveridicality-v1-active-native.csv",
  check.names = FALSE
)
stopifnot(
  nrow(mv) == 14951L,
  length(unique(mv$verb)) == 375L,
  length(unique(mv$respondent_id)) == 319L,
  length(unique(interaction(mv$verb, mv$polarity, mv$task))) == 1500L
)
mv$outcome <- ordered(mv$response, levels = c("no", "maybe", "yes"))
mv$polarity <- factor(mv$polarity, levels = c("positive", "negative"))
mv$task <- factor(mv$task, levels = c("direct", "conditional"))

mv_clm <- ordinal::clm(
  outcome ~ polarity * task, data = mv, link = "logit",
  Hess = TRUE
)
mv_grid <- expand.grid(
  polarity = levels(mv$polarity),
  task = levels(mv$task)
)
mv_probability <- ordinal_probabilities(
  mv_clm, mv_grid, ~ polarity * task
)
colnames(mv_probability) <- levels(mv$outcome)
mv_fitted <- cbind(mv_grid, as.data.frame(mv_probability))
mv_fitted_long <- reshape(
  mv_fitted,
  varying = levels(mv$outcome), v.names = "fitted_probability",
  timevar = "response", times = levels(mv$outcome),
  direction = "long"
)
rownames(mv_fitted_long) <- NULL

mv_raw <- as.data.frame(table(
  mv$polarity, mv$task, mv$outcome,
  dnn = c("polarity", "task", "response")
))
names(mv_raw)[[4L]] <- "responses"
mv_raw$empirical_probability <- ave(
  mv_raw$responses, mv_raw$polarity, mv_raw$task,
  FUN = function(x) x / sum(x)
)
mv_raw_fitted <- merge(
  mv_raw, mv_fitted_long,
  by = c("polarity", "task", "response"), sort = FALSE
)
mv_raw_fitted$response <- factor(
  mv_raw_fitted$response, levels = c("no", "maybe", "yes")
)
write_csv(mv_raw_fitted, "megaveridicality-raw-and-fitted.csv")

mv_above_no <- stats::glm(
  I(as.integer(outcome) > 1L) ~ polarity * task,
  family = stats::binomial(link = "logit"), data = mv
)
mv_yes <- stats::glm(
  I(as.integer(outcome) > 2L) ~ polarity * task,
  family = stats::binomial(link = "logit"), data = mv
)
mv_thresholds <- rbind(
  transform(
    tidy_coef(mv_above_no, "MegaVeridicality", "above-no logit"),
    boundary = "maybe-or-yes versus no"
  ),
  transform(
    tidy_coef(mv_yes, "MegaVeridicality", "yes logit"),
    boundary = "yes versus no-or-maybe"
  )
)
write_csv(mv_thresholds, "megaveridicality-threshold-specific-logits.csv")

mv_plot <- ggplot2::ggplot(
  mv_raw_fitted,
  ggplot2::aes(x = response, group = polarity)
) +
  ggplot2::geom_point(
    ggplot2::aes(y = empirical_probability, shape = polarity),
    size = 2, position = ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::geom_line(
    ggplot2::aes(
      y = fitted_probability, linetype = polarity,
      group = polarity
    ),
    color = "#1F5A85", linewidth = 0.75,
    position = ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::facet_wrap(~ task) +
  ggplot2::labs(
    x = "Response", y = "Response probability",
    shape = NULL, linetype = NULL
  ) +
  ggplot2::coord_cartesian(ylim = c(0, 0.7)) +
  theme_reference()
save_plot(mv_plot, "megaveridicality-raw-and-fitted.pdf", 6.4, 3.9)

# ---------------------------------------------------------------------------
# MegaOrientation: population orientation-by-frame interaction and grouped
# held-out-verb comparison. This is not Moon and White's latent-type model.
# ---------------------------------------------------------------------------

mo <- utils::read.delim(
  "data/megaorientation/megaorientation-v1.1.tsv",
  check.names = FALSE
)
mo_folds <- utils::read.csv(
  "data/megaorientation/verb-folds-multiframe.csv",
  check.names = FALSE
)
stopifnot(
  nrow(mo) == 44160L,
  length(unique(mo$verb)) == 898L,
  length(unique(mo$participant_id)) == 862L,
  length(unique(mo$verb_frame_id)) == 2208L,
  length(unique(mo$item_id)) == 4416L,
  nrow(mo_folds) == 662L,
  all(sort(unique(mo_folds$fold)) == 1:5)
)
mo <- merge(mo, mo_folds[c("verb", "fold")], by = "verb", sort = FALSE)
stopifnot(nrow(mo) == 39440L, !anyNA(mo$fold))
mo$outcome <- ordered(mo$response, levels = 1:7)
mo$orientation <- factor(mo$orientation, levels = c("past", "future"))
mo$frame_code <- factor(mo$frame_code)

mo_restricted <- ordinal::clm(
  outcome ~ orientation + frame_code,
  data = mo, link = "logit", Hess = TRUE
)
mo_interaction <- ordinal::clm(
  outcome ~ orientation * frame_code,
  data = mo, link = "logit", Hess = TRUE
)

mo_paired <- stats::aggregate(
  response ~ verb + frame_code + orientation,
  data = mo, FUN = mean
)
mo_past <- mo_paired[
  mo_paired$orientation == "past",
  c("verb", "frame_code", "response")
]
mo_future <- mo_paired[
  mo_paired$orientation == "future",
  c("verb", "frame_code", "response")
]
names(mo_past)[[3L]] <- "mean_past"
names(mo_future)[[3L]] <- "mean_future"
mo_paired <- merge(
  mo_past, mo_future,
  by = c("verb", "frame_code"), sort = FALSE
)
stopifnot(nrow(mo_paired) == 1972L)
write_csv(mo_paired, "megaorientation-paired-means.csv")

mo_cv_rows <- vector("list", 5L)
for (fold in 1:5) {
  train <- droplevels(mo[mo$fold != fold, ])
  test <- droplevels(mo[mo$fold == fold, ])
  restricted <- ordinal::clm(
    outcome ~ orientation + frame_code,
    data = train, link = "logit", Hess = FALSE,
    control = ordinal::clm.control(convergence = "silent")
  )
  interaction <- ordinal::clm(
    outcome ~ orientation * frame_code,
    data = train, link = "logit", Hess = FALSE,
    control = ordinal::clm.control(convergence = "silent")
  )
  restricted_probability <- ordinal_probabilities(
    restricted, test, ~ orientation + frame_code
  )
  interaction_probability <- ordinal_probabilities(
    interaction, test, ~ orientation * frame_code
  )
  restricted_score <- score_ordinal(restricted_probability, test$outcome)
  interaction_score <- score_ordinal(interaction_probability, test$outcome)
  mo_cv_rows[[fold]] <- data.frame(
    fold = fold,
    held_out_verbs = length(unique(test$verb)),
    held_out_rows = nrow(test),
    restricted_convergence_code = restricted$convergence$code,
    restricted_max_gradient = as.numeric(restricted$info$max.grad),
    interaction_convergence_code = interaction$convergence$code,
    interaction_max_gradient = as.numeric(interaction$info$max.grad),
    restricted_mean_log_score = mean(restricted_score),
    interaction_mean_log_score = mean(interaction_score),
    interaction_minus_restricted = mean(
      interaction_score - restricted_score
    )
  )
}
mo_cv <- do.call(rbind, mo_cv_rows)
stopifnot(all(mo_cv$interaction_minus_restricted > 0))
stopifnot(
  all(mo_cv$restricted_max_gradient < 1e-3),
  all(mo_cv$interaction_max_gradient < 1e-3)
)
write_csv(mo_cv, "megaorientation-grouped-cv.csv")

mo_grid <- expand.grid(
  orientation = levels(mo$orientation),
  frame_code = levels(mo$frame_code)
)
mo_probability <- ordinal_probabilities(
  mo_interaction, mo_grid, ~ orientation * frame_code
)
colnames(mo_probability) <- levels(mo$outcome)
mo_fitted <- cbind(mo_grid, as.data.frame(mo_probability))
mo_fitted_long <- reshape(
  mo_fitted,
  varying = levels(mo$outcome), v.names = "fitted_probability",
  timevar = "rating", times = levels(mo$outcome), direction = "long"
)
rownames(mo_fitted_long) <- NULL
mo_raw <- as.data.frame(table(
  mo$frame_code, mo$orientation, mo$outcome,
  dnn = c("frame_code", "orientation", "rating")
))
names(mo_raw)[[4L]] <- "responses"
mo_raw$empirical_probability <- ave(
  mo_raw$responses, mo_raw$frame_code, mo_raw$orientation,
  FUN = function(x) x / sum(x)
)
mo_raw_fitted <- merge(
  mo_raw, mo_fitted_long,
  by = c("frame_code", "orientation", "rating"), sort = FALSE
)
mo_raw_fitted$rating <- factor(mo_raw_fitted$rating, levels = 1:7)
write_csv(mo_raw_fitted, "megaorientation-raw-and-fitted.csv")

mo_pair_plot <- ggplot2::ggplot(
  mo_paired,
  ggplot2::aes(x = mean_past, y = mean_future)
) +
  ggplot2::geom_abline(
    slope = 1, intercept = 0, color = "grey65", linewidth = 0.4
  ) +
  ggplot2::geom_point(size = 0.7, alpha = 0.35) +
  ggplot2::coord_equal(xlim = c(1, 7), ylim = c(1, 7)) +
  ggplot2::facet_wrap(~ frame_code) +
  ggplot2::labs(
    x = "Mean rating: forced past orientation",
    y = "Mean rating: forced future orientation"
  ) +
  theme_reference()
save_plot(mo_pair_plot, "megaorientation-paired-means.pdf", 7.4, 4.5)

mo_probability_plot <- ggplot2::ggplot(
  mo_raw_fitted,
  ggplot2::aes(x = rating, group = orientation)
) +
  ggplot2::geom_point(
    ggplot2::aes(y = empirical_probability, shape = orientation),
    size = 1.5, position = ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::geom_line(
    ggplot2::aes(
      y = fitted_probability, linetype = orientation,
      group = orientation
    ),
    color = "#1F5A85", linewidth = 0.65,
    position = ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::facet_wrap(~ frame_code) +
  ggplot2::labs(
    x = "Acceptability rating", y = "Response probability",
    shape = NULL, linetype = NULL
  ) +
  theme_reference()
save_plot(mo_probability_plot, "megaorientation-raw-and-fitted.pdf", 7.4, 4.5)

# ---------------------------------------------------------------------------
# Aspectual similarity: endpoint anatomy, illegal Gaussian mass, inward-nudge
# sensitivity, and a transparent fixed-effect ordered-beta reference fit. The
# later application page must restore participant and pair dependence.
# ---------------------------------------------------------------------------

aspect <- utils::read.csv(
  "data/aspectual-similarity/within-verb-similarity.csv",
  check.names = FALSE
)
stopifnot(
  nrow(aspect) == 4405L,
  length(unique(aspect$participant_id)) == 202L,
  length(unique(aspect$verb)) == 14L,
  length(unique(aspect$sentence_pair_id)) == 218L,
  all(aspect$dissimilarity %in% 0:100),
  all(c(0L, 100L) %in% aspect$dissimilarity)
)
aspect$same_sense <- as.integer(aspect$same_sense)
aspect$y <- aspect$dissimilarity / 100

aspect_summary <- do.call(rbind, lapply(split(aspect, aspect$same_sense), function(x) {
  data.frame(
    same_sense = unique(x$same_sense),
    observations = nrow(x),
    mean_dissimilarity = mean(x$dissimilarity),
    zero_probability = mean(x$dissimilarity == 0L),
    hundred_probability = mean(x$dissimilarity == 100L),
    endpoint_probability = mean(x$dissimilarity %in% c(0L, 100L))
  )
}))
rownames(aspect_summary) <- NULL
write_csv(aspect_summary, "aspectual-response-summary.csv")

aspect_gaussian <- lme4::lmer(
  dissimilarity ~ same_sense +
    (1 | participant_id) + (1 | sentence_pair_id),
  data = aspect, REML = FALSE,
  control = lme4::lmerControl(
    optimizer = "bobyqa", optCtrl = list(maxfun = 200000L)
  )
)
aspect_gaussian_coefficients <- data.frame(
  term = names(lme4::fixef(aspect_gaussian)),
  estimate = unname(lme4::fixef(aspect_gaussian)),
  standard_error = sqrt(diag(as.matrix(stats::vcov(aspect_gaussian)))),
  row.names = NULL
)
write_csv(
  aspect_gaussian_coefficients,
  "aspectual-gaussian-mixed-coefficients.csv"
)
aspect$gaussian_mean <- stats::predict(aspect_gaussian, re.form = NA)
aspect_sigma <- stats::sigma(aspect_gaussian)
aspect$gaussian_illegal_probability <-
  stats::pnorm(0, aspect$gaussian_mean, aspect_sigma) +
  stats::pnorm(100, aspect$gaussian_mean, aspect_sigma, lower.tail = FALSE)

# Standard sample-size inward transformation applied to this actual extract.
aspect_n <- nrow(aspect)
aspect$nudged_y <- (aspect$y * (aspect_n - 1) + 0.5) / aspect_n
aspect_nudge <- data.frame(
  recorded_response = c(0, 1),
  transformed_response = c(
    (0 * (aspect_n - 1) + 0.5) / aspect_n,
    (1 * (aspect_n - 1) + 0.5) / aspect_n
  ),
  sample_size = aspect_n
)
write_csv(aspect_nudge, "aspectual-endpoint-nudge.csv")

# Fixed-effect ordered-beta maximum likelihood fit. This implements the
# Kubinec likelihood directly so the reference script remains fast and exposes
# each endpoint contribution. It is descriptive because it omits repeated-unit
# effects; the course application must keep that limitation visible.
X_aspect <- stats::model.matrix(~ same_sense, data = aspect)
aspect_start <- c(
  stats::qlogis(mean(aspect$y)),
  0,
  stats::qlogis(mean(aspect$y == 0) + 0.01),
  log(3),
  log(5)
)
aspect_ordered_beta <- stats::optim(
  aspect_start, ordered_beta_nll,
  y = aspect$y, design = X_aspect,
  method = "BFGS", hessian = TRUE,
  control = list(maxit = 2000L, reltol = 1e-10)
)
stopifnot(aspect_ordered_beta$convergence == 0L)
aspect_parameters <- aspect_ordered_beta$par
aspect_beta <- aspect_parameters[1:2]
aspect_lower <- aspect_parameters[[3L]]
aspect_upper <- aspect_lower + exp(aspect_parameters[[4L]])
aspect_precision <- exp(aspect_parameters[[5L]])
aspect_vcov <- solve(aspect_ordered_beta$hessian)
aspect_upper_gradient <- c(1, exp(aspect_parameters[[4L]]))
aspect_upper_se <- sqrt(drop(
  t(aspect_upper_gradient) %*%
    aspect_vcov[3:4, 3:4, drop = FALSE] %*%
    aspect_upper_gradient
))
aspect_precision_se <- aspect_precision * sqrt(aspect_vcov[5L, 5L])
aspect_parameter_table <- data.frame(
  term = c(
    "intercept", "same_sense", "lower_cutpoint",
    "upper_cutpoint", "precision"
  ),
  estimate = c(
    aspect_beta, aspect_lower, aspect_upper, aspect_precision
  ),
  standard_error = c(
    sqrt(diag(aspect_vcov))[1:3],
    aspect_upper_se, aspect_precision_se
  )
)
write_csv(aspect_parameter_table, "aspectual-ordered-beta-coefficients.csv")

aspect_predictions <- do.call(rbind, lapply(0:1, function(same_sense) {
  eta <- aspect_beta[[1L]] + aspect_beta[[2L]] * same_sense
  probability_zero <- stats::plogis(aspect_lower - eta)
  probability_one <- stats::plogis(eta - aspect_upper)
  probability_interior <- 1 - probability_zero - probability_one
  interior_mean <- stats::plogis(eta)
  data.frame(
    same_sense = same_sense,
    probability_zero = probability_zero,
    probability_interior = probability_interior,
    probability_one = probability_one,
    interior_mean = interior_mean,
    expected_dissimilarity = 100 * (
      probability_one + probability_interior * interior_mean
    )
  )
}))
write_csv(aspect_predictions, "aspectual-ordered-beta-predictions.csv")

# Put endpoint masses and ten equal-width interior bins on one probability
# scale. For the interior, integrate the fitted beta density within each bin.
aspect$display_bin <- cut(
  aspect$y,
  breaks = c(-Inf, 0, seq(0.1, 0.9, by = 0.1), 1, Inf),
  labels = c("0", paste0(seq(0.05, 0.95, by = 0.1)), "1"),
  include.lowest = TRUE, right = TRUE
)
# cut() above would place one at the last interior boundary; restore endpoints.
aspect$display_bin[aspect$y == 0] <- "0"
aspect$display_bin[aspect$y == 1] <- "1"
aspect$display_bin <- factor(
  aspect$display_bin,
  levels = c("0", paste0(seq(0.05, 0.95, by = 0.1)), "1")
)
aspect_binned_raw <- as.data.frame(table(
  aspect$same_sense, aspect$display_bin,
  dnn = c("same_sense", "bin")
))
names(aspect_binned_raw)[[3L]] <- "responses"
aspect_binned_raw$empirical_probability <- ave(
  aspect_binned_raw$responses, aspect_binned_raw$same_sense,
  FUN = function(x) x / sum(x)
)

aspect_binned_fit <- do.call(rbind, lapply(0:1, function(same_sense) {
  eta <- aspect_beta[[1L]] + aspect_beta[[2L]] * same_sense
  p0 <- stats::plogis(aspect_lower - eta)
  p1 <- stats::plogis(eta - aspect_upper)
  pm <- 1 - p0 - p1
  mu <- stats::plogis(eta)
  lower <- seq(0, 0.9, by = 0.1)
  upper <- seq(0.1, 1, by = 0.1)
  interior_bin <- pm * (
    stats::pbeta(upper, mu * aspect_precision,
                 (1 - mu) * aspect_precision) -
      stats::pbeta(lower, mu * aspect_precision,
                   (1 - mu) * aspect_precision)
  )
  data.frame(
    same_sense = as.character(same_sense),
    bin = c("0", paste0(seq(0.05, 0.95, by = 0.1)), "1"),
    fitted_probability = c(p0, interior_bin, p1)
  )
}))
aspect_binned <- merge(
  aspect_binned_raw, aspect_binned_fit,
  by = c("same_sense", "bin"), sort = FALSE
)
aspect_binned$bin <- factor(
  aspect_binned$bin,
  levels = c("0", paste0(seq(0.05, 0.95, by = 0.1)), "1")
)
aspect_binned$sense_relation <- factor(
  aspect_binned$same_sense,
  levels = c("0", "1"), labels = c("different", "same")
)
write_csv(aspect_binned, "aspectual-binned-raw-and-fitted.csv")

aspect_plot <- ggplot2::ggplot(
  aspect_binned,
  ggplot2::aes(x = bin, group = sense_relation)
) +
  ggplot2::geom_point(
    ggplot2::aes(
      y = empirical_probability, shape = sense_relation
    ),
    size = 1.8, position = ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::geom_line(
    ggplot2::aes(
      y = fitted_probability, linetype = sense_relation,
      group = sense_relation
    ),
    color = "#1F5A85", linewidth = 0.65,
    position = ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::scale_x_discrete(
    breaks = c("0", "0.25", "0.45", "0.65", "0.85", "1")
  ) +
  ggplot2::labs(
    x = "Dissimilarity (0--1; interior shown in bins)",
    y = "Probability",
    shape = "Same PropBank sense", linetype = "Same PropBank sense"
  ) +
  theme_reference()
save_plot(aspect_plot, "aspectual-ordered-beta-raw-and-fitted.pdf", 7, 4.2)

# ---------------------------------------------------------------------------
# MegaNegRaising: deployable public fallback for bounded-response pages. The
# balanced subset and both slider outcomes follow the paper-first evidence card.
# The fixed-effect ordered-beta fits are teaching references, not reproductions
# of An and White's acceptability-weighted latent model.
# ---------------------------------------------------------------------------

mnr_url <- paste0(
  "https://megaattitude.io/projects/mega-negraising/",
  "mega-negraising-v1.zip"
)
mnr_expected_sha256 <-
  "6121ed8da217e1e66c20e115fe90848a2d0c3a61e896ebfaaa388a966106ef23"
mnr_archive <- Sys.getenv("MEGANEGR_ARCHIVE", unset = "")
mnr_data_path <- "data/meganegraising/meganegraising-balanced.csv"
mnr_summary_path <-
  "data/meganegraising/meganegraising-release-summary.csv"
mnr_provenance_path <- "data/meganegraising/provenance.json"

if (nzchar(mnr_archive)) {
  if (!file.exists(mnr_archive)) {
    stop("MegaNegRaising archive not found: ", mnr_archive)
  }
  mnr_observed_sha256 <- digest::digest(
    file = mnr_archive, algo = "sha256", serialize = FALSE
  )
  stopifnot(identical(mnr_observed_sha256, mnr_expected_sha256))

  mnr_raw <- utils::read.delim(
    unz(
      mnr_archive,
      "mega-negraising-v1/mega-negraising-v1.tsv"
    ),
    check.names = FALSE
  )
  stopifnot(
    nrow(mnr_raw) == 79360L,
    length(unique(mnr_raw$verb)) == 925L,
    length(unique(mnr_raw$participant)) == 1108L,
    all(mnr_raw$negraising >= 0 & mnr_raw$negraising <= 1),
    all(mnr_raw$acceptability >= 0 & mnr_raw$acceptability <= 1)
  )

  mnr_native <- subset(mnr_raw, nativeenglish == "True")
  stopifnot(
    nrow(mnr_native) == 78496L,
    length(unique(mnr_native$participant)) == 1098L
  )

  mnr <- subset(
    mnr_native,
    tense == "past" &
      frame %in% c(
        "NP V to VP[+eventive]",
        "NP be V to VP[+eventive]"
      )
  )
  mnr_cells <- unique(mnr[c("verb", "frame", "subject")])
  mnr_complete_verbs <- names(which(table(mnr_cells$verb) == 4L))
  mnr <- mnr[mnr$verb %in% mnr_complete_verbs, ]
  mnr_release_summary <- data.frame(
    sample = c(
      "full release", "native-speaker release",
      "balanced teaching subset"
    ),
    rows = c(nrow(mnr_raw), nrow(mnr_native), nrow(mnr)),
    participants = c(
      length(unique(mnr_raw$participant)),
      length(unique(mnr_native$participant)),
      length(unique(mnr$participant))
    ),
    verbs = c(
      length(unique(mnr_raw$verb)),
      length(unique(mnr_native$verb)),
      length(unique(mnr$verb))
    )
  )
} else {
  stopifnot(
    file.exists(mnr_data_path),
    file.exists(mnr_summary_path),
    file.exists(mnr_provenance_path)
  )
  mnr_provenance <- jsonlite::read_json(
    mnr_provenance_path,
    simplifyVector = TRUE
  )
  stopifnot(
    identical(mnr_provenance$source_sha256, mnr_expected_sha256),
    identical(
      digest::digest(
        file = mnr_data_path, algo = "sha256", serialize = FALSE
      ),
      mnr_provenance$output_sha256
    ),
    identical(
      digest::digest(
        file = mnr_summary_path, algo = "sha256", serialize = FALSE
      ),
      mnr_provenance$release_summary_sha256
    )
  )
  mnr_observed_sha256 <- mnr_provenance$source_sha256
  mnr <- utils::read.csv(mnr_data_path, check.names = FALSE)
  mnr_release_summary <- utils::read.csv(
    mnr_summary_path,
    check.names = FALSE
  )
}

mnr$voice <- factor(
  ifelse(grepl("^NP be", mnr$frame), "passive", "active"),
  levels = c("active", "passive")
)
mnr$subject <- factor(mnr$subject, levels = c("first", "third"))
stopifnot(
  nrow(mnr) == 7651L,
  length(unique(mnr$verb)) == 193L,
  length(unique(mnr$participant)) == 1091L,
  nrow(unique(mnr[c("verb", "voice", "subject")])) == 772L
)
write_csv(mnr_release_summary, "meganegraising-release-summary.csv")

mnr_source_pin <- data.frame(
  archive_url = mnr_url,
  archive_label = "v1 archive; internal README version 1.1",
  release_date = "2020-08-29",
  sha256 = mnr_observed_sha256,
  license = "CC BY-SA 4.0"
)
write_csv(mnr_source_pin, "meganegraising-source-pin.csv")

mnr_summary <- stats::aggregate(
  cbind(negraising, acceptability) ~ voice + subject,
  data = mnr,
  FUN = function(y) c(
    observations = length(y), mean = mean(y),
    zero_probability = mean(y == 0),
    one_probability = mean(y == 1),
    endpoint_probability = mean(y %in% c(0, 1))
  )
)
mnr_summary <- cbind(
  mnr_summary[c("voice", "subject")],
  as.data.frame(mnr_summary$negraising),
  as.data.frame(mnr_summary$acceptability)
)
names(mnr_summary)[3:7] <- paste0(
  "negraising_",
  c(
    "observations", "mean", "zero_probability", "one_probability",
    "endpoint_probability"
  )
)
names(mnr_summary)[8:12] <- paste0(
  "acceptability_",
  c(
    "observations", "mean", "zero_probability", "one_probability",
    "endpoint_probability"
  )
)
write_csv(mnr_summary, "meganegraising-cell-summary.csv")

mnr_gaussian <- lme4::lmer(
  negraising ~ voice * subject +
    (1 | participant) + (1 | verb),
  data = mnr, REML = FALSE,
  control = lme4::lmerControl(
    optimizer = "bobyqa", optCtrl = list(maxfun = 200000L)
  )
)
mnr_gaussian_coefficients <- data.frame(
  term = names(lme4::fixef(mnr_gaussian)),
  estimate = unname(lme4::fixef(mnr_gaussian)),
  standard_error = sqrt(diag(as.matrix(stats::vcov(mnr_gaussian)))),
  row.names = NULL
)
write_csv(
  mnr_gaussian_coefficients,
  "meganegraising-gaussian-mixed-coefficients.csv"
)
mnr$gaussian_mean <- stats::predict(mnr_gaussian, re.form = NA)
mnr_gaussian_sigma <- stats::sigma(mnr_gaussian)
mnr$gaussian_illegal_probability <-
  stats::pnorm(0, mnr$gaussian_mean, mnr_gaussian_sigma) +
  stats::pnorm(
    1, mnr$gaussian_mean, mnr_gaussian_sigma,
    lower.tail = FALSE
  )

mnr_n <- nrow(mnr)
mnr_nudge <- data.frame(
  recorded_response = c(0, 1),
  transformed_response = c(
    (0 * (mnr_n - 1) + 0.5) / mnr_n,
    (1 * (mnr_n - 1) + 0.5) / mnr_n
  ),
  sample_size = mnr_n
)
write_csv(mnr_nudge, "meganegraising-endpoint-nudge.csv")

X_mnr <- stats::model.matrix(~ voice * subject, data = mnr)
fit_mnr_ordered_beta <- function(y) {
  start <- c(
    stats::qlogis(mean(y)),
    rep(0, ncol(X_mnr) - 1L),
    stats::qlogis(mean(y == 0) + 0.01),
    log(3), log(5)
  )
  fit <- stats::optim(
    start, ordered_beta_nll,
    y = y, design = X_mnr,
    method = "BFGS", hessian = TRUE,
    control = list(maxit = 3000L, reltol = 1e-10)
  )
  stopifnot(fit$convergence == 0L)
  fit
}

mnr_neg_fit <- fit_mnr_ordered_beta(mnr$negraising)
mnr_acc_fit <- fit_mnr_ordered_beta(mnr$acceptability)

tidy_mnr_ordered_beta <- function(fit, response) {
  parameter_count <- ncol(X_mnr)
  covariance <- solve(fit$hessian)
  lower <- fit$par[[parameter_count + 1L]]
  gap <- exp(fit$par[[parameter_count + 2L]])
  upper <- lower + gap
  precision <- exp(fit$par[[parameter_count + 3L]])
  upper_gradient <- c(1, gap)
  upper_se <- sqrt(drop(
    t(upper_gradient) %*%
      covariance[
        (parameter_count + 1L):(parameter_count + 2L),
        (parameter_count + 1L):(parameter_count + 2L),
        drop = FALSE
      ] %*%
      upper_gradient
  ))
  data.frame(
    response = response,
    term = c(
      colnames(X_mnr), "lower_cutpoint", "upper_cutpoint", "precision"
    ),
    estimate = c(
      fit$par[seq_len(parameter_count)],
      lower, upper, precision
    ),
    standard_error = c(
      sqrt(diag(covariance))[seq_len(parameter_count + 1L)],
      upper_se,
      precision * sqrt(covariance[
        parameter_count + 3L, parameter_count + 3L
      ])
    ),
    row.names = NULL
  )
}

mnr_coefficients <- rbind(
  tidy_mnr_ordered_beta(mnr_neg_fit, "negraising"),
  tidy_mnr_ordered_beta(mnr_acc_fit, "acceptability")
)
write_csv(
  mnr_coefficients,
  "meganegraising-ordered-beta-coefficients.csv"
)

mnr$display_bin <- cut(
  mnr$negraising,
  breaks = c(-Inf, 0, seq(0.1, 0.9, by = 0.1), 1, Inf),
  labels = c("0", paste0(seq(0.05, 0.95, by = 0.1)), "1"),
  include.lowest = TRUE, right = TRUE
)
mnr$display_bin[mnr$negraising == 0] <- "0"
mnr$display_bin[mnr$negraising == 1] <- "1"
mnr$display_bin <- factor(
  mnr$display_bin,
  levels = c("0", paste0(seq(0.05, 0.95, by = 0.1)), "1")
)
mnr_binned_raw <- as.data.frame(table(
  mnr$voice, mnr$subject, mnr$display_bin,
  dnn = c("voice", "subject", "bin")
))
names(mnr_binned_raw)[[4L]] <- "responses"
mnr_binned_raw$empirical_probability <- ave(
  mnr_binned_raw$responses,
  mnr_binned_raw$voice,
  mnr_binned_raw$subject,
  FUN = function(x) x / sum(x)
)

mnr_grid <- expand.grid(
  voice = levels(mnr$voice),
  subject = levels(mnr$subject)
)
X_mnr_grid <- stats::model.matrix(~ voice * subject, data = mnr_grid)
mnr_parameter_count <- ncol(X_mnr)
mnr_neg_beta <- mnr_neg_fit$par[seq_len(mnr_parameter_count)]
mnr_neg_lower <- mnr_neg_fit$par[[mnr_parameter_count + 1L]]
mnr_neg_upper <- mnr_neg_lower +
  exp(mnr_neg_fit$par[[mnr_parameter_count + 2L]])
mnr_neg_precision <- exp(mnr_neg_fit$par[[mnr_parameter_count + 3L]])
mnr_eta <- drop(X_mnr_grid %*% mnr_neg_beta)
mnr_binned_fit <- do.call(rbind, lapply(seq_len(nrow(mnr_grid)), function(row) {
  eta <- mnr_eta[[row]]
  p0 <- stats::plogis(mnr_neg_lower - eta)
  p1 <- stats::plogis(eta - mnr_neg_upper)
  pm <- 1 - p0 - p1
  mu <- stats::plogis(eta)
  lower <- seq(0, 0.9, by = 0.1)
  upper <- seq(0.1, 1, by = 0.1)
  interior_bin <- pm * (
    stats::pbeta(
      upper, mu * mnr_neg_precision,
      (1 - mu) * mnr_neg_precision
    ) -
      stats::pbeta(
        lower, mu * mnr_neg_precision,
        (1 - mu) * mnr_neg_precision
      )
  )
  data.frame(
    voice = mnr_grid$voice[[row]],
    subject = mnr_grid$subject[[row]],
    bin = c("0", paste0(seq(0.05, 0.95, by = 0.1)), "1"),
    fitted_probability = c(p0, interior_bin, p1)
  )
}))
mnr_binned <- merge(
  mnr_binned_raw, mnr_binned_fit,
  by = c("voice", "subject", "bin"), sort = FALSE
)
mnr_binned$bin <- factor(
  mnr_binned$bin,
  levels = c("0", paste0(seq(0.05, 0.95, by = 0.1)), "1")
)
write_csv(
  mnr_binned,
  "meganegraising-binned-raw-and-fitted.csv"
)

mnr_plot <- ggplot2::ggplot(
  mnr_binned,
  ggplot2::aes(x = bin, group = subject)
) +
  ggplot2::geom_point(
    ggplot2::aes(y = empirical_probability, shape = subject),
    size = 1.7, position = ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::geom_line(
    ggplot2::aes(
      y = fitted_probability, linetype = subject, group = subject
    ),
    color = "#1F5A85", linewidth = 0.65,
    position = ggplot2::position_dodge(width = 0.18)
  ) +
  ggplot2::scale_x_discrete(
    breaks = c("0", "0.25", "0.45", "0.65", "0.85", "1")
  ) +
  ggplot2::facet_wrap(~ voice) +
  ggplot2::labs(
    x = "Neg-raising judgment (0--1; interior shown in bins)",
    y = "Probability", shape = "Matrix subject", linetype = "Matrix subject"
  ) +
  theme_reference()
save_plot(
  mnr_plot,
  "meganegraising-ordered-beta-raw-and-fitted.pdf", 6.8, 4.1
)

# ---------------------------------------------------------------------------
# Consolidated coefficients and quantities for page workers.
# ---------------------------------------------------------------------------

coefficients <- rbind(
  tidy_coef(st_lpm, "SuperTelicity", "linear probability"),
  tidy_coef(st_duration_logit, "SuperTelicity", "duration logistic"),
  tidy_coef(st_simple, "SuperTelicity", "verb-type logistic"),
  tidy_coef(st_additive, "SuperTelicity", "additive logistic"),
  tidy_coef(st_interaction, "SuperTelicity", "interaction logistic"),
  tidy_coef(nettle_poisson, "Nettle", "Poisson with area offset"),
  tidy_coef(nettle_quasi, "Nettle", "quasi-Poisson with area offset"),
  tidy_coef(nettle_mismatched, "Nettle", "Poisson with mismatched offset"),
  tidy_coef(storme_poisson, "Storme", "Poisson additive"),
  tidy_coef(storme_nb, "Storme", "negative binomial additive"),
  tidy_coef(
    storme_nb_interaction, "Storme", "negative binomial interaction"
  ),
  tidy_coef(mv_clm, "MegaVeridicality", "population cumulative logit"),
  tidy_coef(mo_restricted, "MegaOrientation", "population additive cumulative logit"),
  tidy_coef(mo_interaction, "MegaOrientation", "population interaction cumulative logit")
)
write_csv(coefficients, "model-coefficients.csv")

key_quantities <- data.frame(
  dataset = c(
    rep("SuperTelicity", 12), rep("Nettle", 7), rep("Storme", 8),
    rep("MegaVeridicality", 6), rep("MegaOrientation", 4),
    rep("MegaNegRaising", 14),
    rep("Aspectual similarity", 9)
  ),
  quantity = c(
    "rows", "participants", "sentences", "verbs", "in responses",
    "empirical in probability", "manner in probability",
    "result in probability", "empirical odds ratio result/manner",
    "linear probability minimum", "linear probability maximum",
    "interaction residual deviance",
    "countries", "language count minimum", "language count maximum",
    "MGS coefficient", "one-month rate ratio", "Poisson dispersion",
    "quasi dispersion",
    "morpheme rows", "liaison rows", "observed zero probability",
    "mean count", "count variance", "Poisson dispersion", "NB theta",
    "additive liaison mean ratio",
    "rows", "verbs", "task-specific respondents", "cells",
    "positive-direct yes probability", "negative-conditional yes probability",
    "rows in multiframe comparison", "multiframe verbs",
    "predicate-frame pairs", "weighted held-out interaction log-score gain",
    "balanced-subset rows", "participants", "verbs", "cells",
    "neg-raising mean", "neg-raising zero probability",
    "neg-raising one probability", "neg-raising endpoint probability",
    "acceptability mean", "acceptability zero probability",
    "acceptability one probability", "acceptability endpoint probability",
    "Gaussian illegal mass", "ordered-beta passive coefficient",
    "rows", "participants", "verbs", "sentence pairs", "zero probability",
    "one probability", "boundary probability", "Gaussian illegal mass",
    "ordered-beta same-sense coefficient"
  ),
  value = c(
    nrow(st), length(unique(st$participant_id)),
    length(unique(st$sentence_id)), length(unique(st$verb)),
    sum(st$prep_in), mean(st$prep_in),
    st_binary$in_probability[st_binary$verb_type == "manner"],
    st_binary$in_probability[st_binary$verb_type == "result"],
    st_binary$odds_in[st_binary$verb_type == "result"] /
      st_binary$odds_in[st_binary$verb_type == "manner"],
    min(st_duration_grid$linear_probability),
    max(st_duration_grid$linear_probability),
    stats::deviance(st_interaction),
    nrow(nettle), min(nettle$language_count), max(nettle$language_count),
    stats::coef(nettle_poisson)[["mean_growing_season_months"]],
    exp(stats::coef(nettle_poisson)[["mean_growing_season_months"]]),
    nettle_dispersion, summary(nettle_quasi)$dispersion,
    nrow(storme), sum(storme$liaison == "yes"),
    mean(storme$reconstructed_count == 0L),
    mean(storme$reconstructed_count), stats::var(storme$reconstructed_count),
    storme_poisson_dispersion, storme_nb$theta,
    exp(stats::coef(storme_nb)[["liaisonyes"]]),
    nrow(mv), length(unique(mv$verb)),
    length(unique(mv$respondent_id)),
    length(unique(interaction(mv$verb, mv$polarity, mv$task))),
    with(
      subset(mv_raw, polarity == "positive" & task == "direct" &
               response == "yes"), empirical_probability
    ),
    with(
      subset(mv_raw, polarity == "negative" & task == "conditional" &
               response == "yes"), empirical_probability
    ),
    nrow(mo), length(unique(mo$verb)), nrow(mo_paired),
    weighted.mean(
      mo_cv$interaction_minus_restricted, mo_cv$held_out_rows
    ),
    nrow(mnr), length(unique(mnr$participant)),
    length(unique(mnr$verb)),
    nrow(unique(mnr[c("verb", "voice", "subject")])),
    mean(mnr$negraising), mean(mnr$negraising == 0),
    mean(mnr$negraising == 1),
    mean(mnr$negraising %in% c(0, 1)),
    mean(mnr$acceptability), mean(mnr$acceptability == 0),
    mean(mnr$acceptability == 1),
    mean(mnr$acceptability %in% c(0, 1)),
    mean(mnr$gaussian_illegal_probability),
    mnr_neg_fit$par[[which(colnames(X_mnr) == "voicepassive")]],
    nrow(aspect), length(unique(aspect$participant_id)),
    length(unique(aspect$verb)), length(unique(aspect$sentence_pair_id)),
    mean(aspect$y == 0), mean(aspect$y == 1),
    mean(aspect$y %in% c(0, 1)),
    mean(aspect$gaussian_illegal_probability),
    aspect_beta[[2L]]
  )
)
write_csv(key_quantities, "key-quantities.csv")

assert_close(
  stats::coef(nettle_poisson)[["mean_growing_season_months"]],
  0.2498, 5e-4, "Nettle MGS coefficient"
)
assert_close(
  stats::coef(storme_nb)[["liaisonyes"]],
  2.2355, 5e-4, "Storme liaison coefficient"
)
assert_close(
  mean(aspect$y %in% c(0, 1)),
  0.2082, 5e-4, "Aspectual boundary probability"
)
assert_close(
  mean(mnr$negraising %in% c(0, 1)),
  0.1127, 5e-4, "MegaNegRaising boundary probability"
)

writeLines(capture.output(utils::sessionInfo()),
           file.path(output_dir, "session-info.txt"))

writeLines(
  c(
    "All structural assertions passed.",
    "Random seed: 20261018 (reserved; plots use deterministic subsampling and MegaOrientation folds are frozen in data).",
    paste("SuperTelicity IRLS iterations:", nrow(st_irls)),
    paste("Nettle Poisson dispersion:", format(nettle_dispersion, digits = 8)),
    paste("Storme Poisson dispersion:", format(storme_poisson_dispersion, digits = 9)),
    paste("MegaOrientation folds favoring interaction:",
          sum(mo_cv$interaction_minus_restricted > 0), "of 5"),
    paste("MegaNegRaising balanced-subset rows:", nrow(mnr)),
    paste("MegaNegRaising neg-raising ordered-beta convergence:",
          mnr_neg_fit$convergence),
    paste("MegaNegRaising neg-raising ordered-beta negative log likelihood:",
          format(mnr_neg_fit$value, digits = 9)),
    paste("MegaNegRaising acceptability ordered-beta convergence:",
          mnr_acc_fit$convergence),
    paste("MegaNegRaising acceptability ordered-beta negative log likelihood:",
          format(mnr_acc_fit$value, digits = 9)),
    paste("Aspectual ordered-beta optimizer convergence:",
          aspect_ordered_beta$convergence),
    paste("Aspectual ordered-beta negative log likelihood:",
          format(aspect_ordered_beta$value, digits = 9))
  ),
  file.path(output_dir, "assertions.txt")
)

cat("Reference generalized-model analysis completed.\n")
cat("Outputs:", normalizePath(output_dir), "\n")
