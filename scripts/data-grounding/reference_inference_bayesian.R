#!/usr/bin/env Rscript

# Paper-first reference analysis for the Bayesian and posterior-computation
# sequence in statistical-inference/. The script reads only committed teaching
# inputs. It writes small reference tables, restrained scientific figures, and
# a cached Stan draw object; it never edits a note page or problem set.

options(stringsAsFactors = FALSE, scipen = 999)

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(script_arg) == 1L) {
  script_path <- normalizePath(sub("^--file=", "", script_arg), mustWork = TRUE)
  project_root <- dirname(dirname(dirname(script_path)))
} else {
  project_root <- normalizePath(getwd(), mustWork = TRUE)
}

arguments <- commandArgs(trailingOnly = TRUE)
refresh_stan <- "--refresh-stan" %in% arguments
output_dir <- file.path(
  project_root,
  "research", "dataset-audits", "reference-inference-bayesian-output"
)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

assert_true <- function(condition, message) {
  if (!isTRUE(condition)) stop(message, call. = FALSE)
}

write_output <- function(x, filename) {
  utils::write.csv(
    x,
    file.path(output_dir, filename),
    row.names = FALSE,
    na = "",
    quote = TRUE
  )
}

sha256 <- function(path) {
  line <- system2("shasum", c("-a", "256", path), stdout = TRUE)
  sub("[[:space:]].*$", "", line[[1L]])
}

weighted_quantile <- function(x, weights, probabilities) {
  ordering <- order(x)
  x <- x[ordering]
  weights <- weights[ordering] / sum(weights)
  cumulative <- cumsum(weights)
  vapply(
    probabilities,
    function(probability) x[which(cumulative >= probability)[[1L]]],
    numeric(1)
  )
}

log_sum_exp <- function(x) {
  maximum <- max(x)
  maximum + log(sum(exp(x - maximum)))
}

required_packages <- c("ggplot2", "MASS", "cmdstanr", "posterior", "loo")
package_available <- vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
assert_true(all(package_available), paste(
  "Install required packages:",
  paste(required_packages[!package_available], collapse = ", ")
))

package_versions <- data.frame(
  package = c("R", required_packages, "CmdStan"),
  version = c(
    as.character(getRversion()),
    vapply(required_packages, function(package) {
      as.character(utils::packageVersion(package))
    }, character(1)),
    as.character(cmdstanr::cmdstan_version())
  ),
  stringsAsFactors = FALSE
)
write_output(package_versions, "package-versions.csv")

theme_notes <- ggplot2::theme_classic(base_size = 11) +
  ggplot2::theme(
    legend.position = "top",
    legend.title = ggplot2::element_blank(),
    strip.background = ggplot2::element_blank(),
    plot.title.position = "plot"
  )

save_plot <- function(plot, filename, width = 6.5, height = 4.0) {
  ggplot2::ggsave(
    filename = file.path(output_dir, filename),
    plot = plot,
    width = width,
    height = height,
    units = "in",
    dpi = 180,
    bg = "white"
  )
}

unimorph_population_path <- file.path(
  project_root, "data", "unimorph-turkish", "verb-past-population.csv"
)
unimorph_sample_path <- file.path(
  project_root, "data", "unimorph-turkish", "verb-past-sample-120.csv"
)
provo_path <- file.path(project_root, "data", "provo", "passage-summaries.csv")
stan_path <- file.path(
  project_root, "scripts", "data-grounding", "reference_inference_bayesian.stan"
)

inputs <- data.frame(
  dataset = c(
    "Turkish UniMorph population",
    "Turkish UniMorph fixed sample",
    "Provo passage summaries",
    "Provo posterior Stan program"
  ),
  path = c(unimorph_population_path, unimorph_sample_path, provo_path, stan_path),
  expected_sha256 = c(
    "440ba51c27fd9b9db0366478dfbcf40ae50e7538e35ec0f8793d6231b9be76a4",
    "b5d293b2496290b567a86ee7c77ce33cee249c3a9a5c7c38f6a11a2dba28980e",
    "9d210d419966c96e1a99b0be79049e46e7cd3bdf8285f8cbe3f062d9a1695121",
    NA_character_
  ),
  stringsAsFactors = FALSE
)
assert_true(all(file.exists(inputs$path)), "At least one Bayesian reference input is missing")
inputs$observed_sha256 <- vapply(inputs$path, sha256, character(1))
inputs$checksum_matches <- is.na(inputs$expected_sha256) |
  inputs$observed_sha256 == inputs$expected_sha256
assert_true(all(inputs$checksum_matches), "A frozen Bayesian reference input checksum changed")
write_output(inputs, "input-checksums.csv")

unimorph_population <- utils::read.csv(unimorph_population_path, check.names = FALSE)
unimorph_sample <- utils::read.csv(unimorph_sample_path, check.names = FALSE)
provo <- utils::read.csv(provo_path, check.names = FALSE)

assert_true(nrow(unimorph_population) == 588L, "UniMorph population row count changed")
assert_true(nrow(unimorph_sample) == 120L, "UniMorph sample row count changed")
assert_true(!anyDuplicated(unimorph_population$lemma), "UniMorph population lemmas are not unique")
assert_true(!anyDuplicated(unimorph_sample$lemma), "UniMorph sample lemmas are not unique")
assert_true(all(unimorph_sample$lemma %in% unimorph_population$lemma),
            "UniMorph fixed sample is not contained in its population")
assert_true(all(unimorph_population$t_initial %in% 0:1), "UniMorph indicator is not binary")
assert_true(nrow(provo) == 55L, "Provo passage count changed")
assert_true(!anyDuplicated(provo$Text_ID), "Provo passage identifiers are not unique")
assert_true(all(provo$n_positions >= 1L), "A Provo passage has no retained positions")
assert_true(all(is.finite(provo$noun_minus_verb_log_ffd)),
            "A Provo passage contrast is not finite")

# ----------------------------------------------------------------------------
# Turkish UniMorph: a finite-resource bridge to Bernoulli/Beta--Binomial work
# ----------------------------------------------------------------------------

population_n <- nrow(unimorph_population)
population_k <- sum(unimorph_population$t_initial)
sample_n <- nrow(unimorph_sample)
sample_k <- sum(unimorph_sample$t_initial)
remaining_n <- population_n - sample_n
remaining_k <- population_k - sample_k

assert_true(population_k == 200L, "UniMorph t-initial population count changed")
assert_true(sample_k == 42L, "UniMorph t-initial sample count changed")
assert_true(remaining_k == 158L, "UniMorph remaining t-initial count changed")

# Beta(1, 1) is a weak support-calibrated bridge prior on a probability in
# [0, 1]. Its two prior observations are negligible relative to n = 120. It
# belongs to a hypothetical independent lexeme-draw model, not to the actual
# without-replacement sampling design.
prior_alpha <- 1
prior_beta <- 1
posterior_alpha <- prior_alpha + sample_k
posterior_beta <- prior_beta + sample_n - sample_k
population_share <- population_k / population_n
posterior_mean <- posterior_alpha / (posterior_alpha + posterior_beta)
posterior_variance <- posterior_alpha * posterior_beta /
  ((posterior_alpha + posterior_beta)^2 *
     (posterior_alpha + posterior_beta + 1))
posterior_interval <- stats::qbeta(
  c(0.025, 0.5, 0.975), posterior_alpha, posterior_beta
)

unimorph_update <- data.frame(
  quantity = c(
    "population_size", "population_t_initial", "fixed_sample_size",
    "fixed_sample_t_initial", "remaining_population_size",
    "remaining_t_initial", "population_share", "sample_share",
    "prior_alpha", "prior_beta", "posterior_alpha", "posterior_beta",
    "posterior_mean", "posterior_variance", "posterior_q025",
    "posterior_median", "posterior_q975",
    "posterior_probability_above_population_share",
    "next_independent_draw_probability",
    "next_without_replacement_probability"
  ),
  value = c(
    population_n, population_k, sample_n, sample_k, remaining_n, remaining_k,
    population_share, sample_k / sample_n, prior_alpha, prior_beta,
    posterior_alpha, posterior_beta, posterior_mean, posterior_variance,
    posterior_interval,
    1 - stats::pbeta(population_share, posterior_alpha, posterior_beta),
    posterior_mean,
    remaining_k / remaining_n
  ),
  design = c(
    rep("known finite resource", 8L),
    rep("hypothetical exchangeable Bernoulli bridge", 10L),
    "hypothetical next independent lexeme draw",
    "actual remaining resource without replacement"
  ),
  stringsAsFactors = FALSE
)
write_output(unimorph_update, "unimorph-beta-update.csv")

theta_grid <- seq(0, 1, length.out = 1001L)
unimorph_beta_density <- rbind(
  data.frame(
    distribution = "prior Beta(1, 1)",
    theta = theta_grid,
    density = stats::dbeta(theta_grid, prior_alpha, prior_beta)
  ),
  data.frame(
    distribution = sprintf(
      "posterior Beta(%d, %d)", posterior_alpha, posterior_beta
    ),
    theta = theta_grid,
    density = stats::dbeta(theta_grid, posterior_alpha, posterior_beta)
  )
)
write_output(unimorph_beta_density, "unimorph-beta-density.csv")

p_unimorph_beta <- ggplot2::ggplot(
  unimorph_beta_density,
  ggplot2::aes(theta, density, linetype = distribution)
) +
  ggplot2::geom_line(color = "#8B1A1A", linewidth = 0.85) +
  ggplot2::geom_vline(
    xintercept = population_share,
    color = "grey35",
    linewidth = 0.6
  ) +
  ggplot2::labs(
    x = "Modeled share of lexeme cells with a t-initial ending",
    y = "Density"
  ) +
  theme_notes
save_plot(p_unimorph_beta, "unimorph-beta-posterior.png")

future_block_n <- sample_n
count_support <- 0:future_block_n
prior_predictive <- exp(
  lchoose(future_block_n, count_support) +
    lbeta(count_support + prior_alpha,
          future_block_n - count_support + prior_beta) -
    lbeta(prior_alpha, prior_beta)
)
posterior_predictive <- exp(
  lchoose(future_block_n, count_support) +
    lbeta(count_support + posterior_alpha,
          future_block_n - count_support + posterior_beta) -
    lbeta(posterior_alpha, posterior_beta)
)
finite_predictive <- stats::dhyper(
  count_support,
  m = remaining_k,
  n = remaining_n - remaining_k,
  k = future_block_n
)
unimorph_predictive <- rbind(
  data.frame(
    design = "prior Beta-Binomial independent draws",
    count = count_support,
    probability = prior_predictive
  ),
  data.frame(
    design = "posterior Beta-Binomial independent draws",
    count = count_support,
    probability = posterior_predictive
  ),
  data.frame(
    design = "known remaining resource without replacement",
    count = count_support,
    probability = finite_predictive
  )
)
write_output(unimorph_predictive, "unimorph-predictive-pmfs.csv")
assert_true(all(abs(tapply(
  unimorph_predictive$probability,
  unimorph_predictive$design,
  sum
) - 1) < 1e-10), "A UniMorph predictive mass function does not sum to one")

unimorph_predictive_summary <- data.frame(
  design = c(
    "prior Beta-Binomial independent draws",
    "posterior Beta-Binomial independent draws",
    "known remaining resource without replacement"
  ),
  expected_count = c(
    future_block_n * prior_alpha / (prior_alpha + prior_beta),
    future_block_n * posterior_mean,
    future_block_n * remaining_k / remaining_n
  ),
  variance = c(
    future_block_n * prior_alpha * prior_beta *
      (prior_alpha + prior_beta + future_block_n) /
      ((prior_alpha + prior_beta)^2 * (prior_alpha + prior_beta + 1)),
    future_block_n * posterior_alpha * posterior_beta *
      (posterior_alpha + posterior_beta + future_block_n) /
      ((posterior_alpha + posterior_beta)^2 *
         (posterior_alpha + posterior_beta + 1)),
    future_block_n * remaining_k / remaining_n *
      (1 - remaining_k / remaining_n) *
      (remaining_n - future_block_n) / (remaining_n - 1)
  ),
  stringsAsFactors = FALSE
)
write_output(unimorph_predictive_summary, "unimorph-predictive-summary.csv")

p_unimorph_predictive <- ggplot2::ggplot(
  subset(unimorph_predictive, probability > 1e-5),
  ggplot2::aes(count, probability, linetype = design)
) +
  ggplot2::geom_line(color = "#8B1A1A", linewidth = 0.75) +
  ggplot2::scale_linetype_discrete(labels = c(
    "Known resource, no replacement",
    "Posterior independent draws",
    "Prior independent draws"
  )) +
  ggplot2::labs(
    x = sprintf("t-initial forms in a block of %d lexeme cells", future_block_n),
    y = "Probability"
  ) +
  theme_notes +
  ggplot2::theme(legend.position = "bottom")
save_plot(p_unimorph_predictive, "unimorph-predictive-designs.png", height = 4.3)

# ----------------------------------------------------------------------------
# Provo: one passage-level robust posterior for all computation pages
# ----------------------------------------------------------------------------

y <- provo$noun_minus_verb_log_ffd
N <- length(y)
nu <- 4
response_scale <- stats::sd(y)
prior_mu_sd <- 2 * response_scale
prior_sigma_sd <- 2 * response_scale

assert_true(response_scale > 0, "Provo contrast scale is zero")
assert_true(all(provo$n_nouns >= 4L & provo$n_verbs >= 4L),
            "A Provo passage no longer meets the noun/verb count rule")

provo_raw <- provo[, c(
  "Text_ID", "n_positions", "n_nouns", "n_verbs",
  "noun_mean_log_ffd", "verb_mean_log_ffd", "noun_minus_verb_log_ffd"
)]
write_output(provo_raw, "provo-passage-contrasts.csv")

provo_target_summary <- data.frame(
  quantity = c(
    "passages", "retained_position_summaries", "mean_log_contrast",
    "sd_log_contrast", "median_log_contrast", "minimum_log_contrast",
    "maximum_log_contrast", "proportion_positive", "nu",
    "prior_mu_mean", "prior_mu_sd", "prior_sigma_scale"
  ),
  value = c(
    N, sum(provo$n_positions), mean(y), response_scale, stats::median(y),
    min(y), max(y), mean(y > 0), nu, 0, prior_mu_sd, prior_sigma_sd
  ),
  source = c(
    rep("observed Provo passage summary table", 8L),
    "fixed robust-likelihood setting",
    "no noun-verb contrast reference",
    "twice the observed passage-contrast SD",
    "twice the observed passage-contrast SD"
  ),
  stringsAsFactors = FALSE
)
write_output(provo_target_summary, "provo-target-and-prior.csv")

# The target is a Student-t location-scale model. The prior scales are an
# empirical calibration for this computation lesson. They make the target
# unsuitable as a confirmatory Bayesian analysis, a limitation recorded in the
# evidence card.
log_posterior_eta <- function(eta) {
  mu <- eta[[1L]]
  sigma <- exp(eta[[2L]])
  sum(stats::dt((y - mu) / sigma, df = nu, log = TRUE) - log(sigma)) +
    stats::dnorm(mu, 0, prior_mu_sd, log = TRUE) +
    log(2) + stats::dnorm(sigma, 0, prior_sigma_sd, log = TRUE) +
    eta[[2L]]
}

gradient_log_posterior_eta <- function(eta) {
  mu <- eta[[1L]]
  log_sigma <- eta[[2L]]
  sigma <- exp(log_sigma)
  residual <- y - mu
  scaled_squared <- residual^2 / sigma^2
  gradient_mu <- sum(
    (nu + 1) * residual / (nu * sigma^2 + residual^2)
  ) - mu / prior_mu_sd^2
  gradient_log_sigma <- sum(
    -1 + (nu + 1) * scaled_squared / (nu + scaled_squared)
  ) - sigma^2 / prior_sigma_sd^2 + 1
  c(gradient_mu, gradient_log_sigma)
}

finite_difference_gradient <- function(function_to_check, point, step = 1e-6) {
  vapply(seq_along(point), function(dimension) {
    upper <- lower <- point
    upper[[dimension]] <- upper[[dimension]] + step
    lower[[dimension]] <- lower[[dimension]] - step
    (function_to_check(upper) - function_to_check(lower)) / (2 * step)
  }, numeric(1))
}

start <- c(stats::median(y), log(stats::mad(y)))
mode_fit <- stats::optim(
  start,
  function(eta) -log_posterior_eta(eta),
  gr = function(eta) -gradient_log_posterior_eta(eta),
  method = "BFGS",
  hessian = TRUE,
  control = list(reltol = 1e-12, maxit = 1000L)
)
assert_true(mode_fit$convergence == 0L, "Provo posterior mode optimization failed")
mode_eta <- unname(mode_fit$par)
mode_covariance <- solve(mode_fit$hessian)
assert_true(all(eigen(mode_covariance, symmetric = TRUE)$values > 0),
            "Mode covariance is not positive definite")
gradient_check_points <- rbind(
  posterior_mode = mode_eta,
  observed_center = c(mean(y), log(stats::sd(y))),
  shifted_center = c(mean(y) + 0.5 * stats::sd(y), log(stats::sd(y)) - 0.2)
)
gradient_check <- do.call(rbind, lapply(
  seq_len(nrow(gradient_check_points)),
  function(index) {
    analytic <- gradient_log_posterior_eta(gradient_check_points[index, ])
    numerical <- finite_difference_gradient(
      log_posterior_eta, gradient_check_points[index, ]
    )
    data.frame(
      point = rownames(gradient_check_points)[[index]],
      coordinate = c("mu", "log_sigma"),
      analytic = analytic,
      finite_difference = numerical,
      absolute_error = abs(analytic - numerical)
    )
  }
))
write_output(gradient_check, "provo-gradient-check.csv")
assert_true(max(gradient_check$absolute_error) < 1e-5,
            "Analytic Provo posterior gradient failed its finite-difference check")

# Data-scaled quadrature bounds are seven local posterior standard deviations
# from the mode in each unconstrained coordinate.
grid_sd <- sqrt(diag(mode_covariance))
mu_grid <- seq(
  mode_eta[[1L]] - 7 * grid_sd[[1L]],
  mode_eta[[1L]] + 7 * grid_sd[[1L]],
  length.out = 321L
)
log_sigma_grid <- seq(
  mode_eta[[2L]] - 7 * grid_sd[[2L]],
  mode_eta[[2L]] + 7 * grid_sd[[2L]],
  length.out = 321L
)
posterior_grid <- expand.grid(mu = mu_grid, log_sigma = log_sigma_grid)
posterior_grid$log_kernel <- apply(
  posterior_grid[, c("mu", "log_sigma")],
  1L,
  log_posterior_eta
)
posterior_grid$weight <- exp(
  posterior_grid$log_kernel - log_sum_exp(posterior_grid$log_kernel)
)
posterior_grid$sigma <- exp(posterior_grid$log_sigma)
assert_true(abs(sum(posterior_grid$weight) - 1) < 1e-12,
            "Provo grid posterior weights do not sum to one")

grid_mean_eta <- colSums(
  posterior_grid[, c("mu", "log_sigma")] * posterior_grid$weight
)
grid_centered <- sweep(
  as.matrix(posterior_grid[, c("mu", "log_sigma")]),
  2L,
  grid_mean_eta,
  "-"
)
grid_covariance <- crossprod(grid_centered * sqrt(posterior_grid$weight))
grid_mu_interval <- weighted_quantile(
  posterior_grid$mu, posterior_grid$weight, c(0.025, 0.5, 0.975)
)
grid_sigma_interval <- weighted_quantile(
  posterior_grid$sigma, posterior_grid$weight, c(0.025, 0.5, 0.975)
)
grid_summary <- data.frame(
  parameter = c("mu", "sigma"),
  mode = c(mode_eta[[1L]], exp(mode_eta[[2L]])),
  posterior_mean = c(
    sum(posterior_grid$mu * posterior_grid$weight),
    sum(posterior_grid$sigma * posterior_grid$weight)
  ),
  q025 = c(grid_mu_interval[[1L]], grid_sigma_interval[[1L]]),
  median = c(grid_mu_interval[[2L]], grid_sigma_interval[[2L]]),
  q975 = c(grid_mu_interval[[3L]], grid_sigma_interval[[3L]]),
  stringsAsFactors = FALSE
)
write_output(grid_summary, "provo-grid-posterior-summary.csv")

grid_functionals <- data.frame(
  quantity = c(
    "posterior_probability_mu_positive",
    "posterior_mean_geometric_duration_ratio",
    "posterior_probability_geometric_ratio_above_one",
    "grid_boundary_mass"
  ),
  value = c(
    sum(posterior_grid$weight[posterior_grid$mu > 0]),
    sum(exp(posterior_grid$mu) * posterior_grid$weight),
    sum(posterior_grid$weight[exp(posterior_grid$mu) > 1]),
    sum(posterior_grid$weight[
      posterior_grid$mu %in% range(mu_grid) |
        posterior_grid$log_sigma %in% range(log_sigma_grid)
    ])
  ),
  stringsAsFactors = FALSE
)
write_output(grid_functionals, "provo-grid-functionals.csv")
assert_true(grid_functionals$value[[4L]] < 1e-5,
            "Provo quadrature grid retains too much boundary mass")

# Save a reduced grid sufficient for contours without making the audit output
# needlessly large.
contour_grid <- posterior_grid[
  posterior_grid$mu %in% mu_grid[seq(1L, length(mu_grid), by = 2L)] &
    posterior_grid$log_sigma %in%
      log_sigma_grid[seq(1L, length(log_sigma_grid), by = 2L)],
  c("mu", "log_sigma", "sigma", "log_kernel", "weight")
]
write_output(contour_grid, "provo-posterior-contour-grid.csv")

# Prior predictive calibration. The seeds are computational settings; every
# comparison value comes from the observed 55-passage target.
prior_predictive_seed <- 2026101801L
prior_predictive_replicates <- 4000L
set.seed(prior_predictive_seed)
prior_mu <- stats::rnorm(prior_predictive_replicates, 0, prior_mu_sd)
prior_sigma <- abs(stats::rnorm(prior_predictive_replicates, 0, prior_sigma_sd))
prior_rep <- vapply(
  seq_len(prior_predictive_replicates),
  function(index) {
    prior_mu[[index]] +
      prior_sigma[[index]] * stats::rt(N, df = nu)
  },
  numeric(N)
)
prior_discrepancies <- data.frame(
  replicate = seq_len(prior_predictive_replicates),
  mean = colMeans(prior_rep),
  sd = apply(prior_rep, 2L, stats::sd),
  maximum_absolute = apply(abs(prior_rep), 2L, max),
  proportion_positive = colMeans(prior_rep > 0)
)
write_output(prior_discrepancies, "provo-prior-predictive-discrepancies.csv")

prior_observed <- data.frame(
  discrepancy = c("Mean", "SD", "Maximum absolute contrast", "Proportion positive"),
  observed = c(mean(y), stats::sd(y), max(abs(y)), mean(y > 0))
)
prior_long <- rbind(
  data.frame(discrepancy = "Mean", value = prior_discrepancies$mean),
  data.frame(discrepancy = "SD", value = prior_discrepancies$sd),
  data.frame(
    discrepancy = "Maximum absolute contrast",
    value = prior_discrepancies$maximum_absolute
  ),
  data.frame(
    discrepancy = "Proportion positive",
    value = prior_discrepancies$proportion_positive
  )
)
p_prior <- ggplot2::ggplot(prior_long, ggplot2::aes(value)) +
  ggplot2::geom_histogram(bins = 45, fill = "grey75", color = "white") +
  ggplot2::geom_vline(
    data = prior_observed,
    ggplot2::aes(xintercept = observed),
    color = "#8B1A1A",
    linewidth = 0.75
  ) +
  ggplot2::facet_wrap(~discrepancy, scales = "free", ncol = 2) +
  ggplot2::labs(x = "Prior-predictive discrepancy", y = "Replicates") +
  theme_notes
save_plot(p_prior, "provo-prior-predictive-check.png", height = 5.0)

# Direct grid draws support the Monte Carlo-integration page without requiring
# independent exact draws from an unavailable closed form.
grid_draw_seed <- 2026101802L
grid_draw_count <- 20000L
set.seed(grid_draw_seed)
grid_indices <- sample(
  seq_len(nrow(posterior_grid)),
  size = grid_draw_count,
  replace = TRUE,
  prob = posterior_grid$weight
)
grid_draws <- posterior_grid[grid_indices, c("mu", "log_sigma", "sigma")]
monte_carlo_summary <- data.frame(
  functional = c(
    "E[mu|y]", "P(mu>0|y)", "E[exp(mu)|y]"
  ),
  quadrature_reference = c(
    sum(posterior_grid$mu * posterior_grid$weight),
    sum(posterior_grid$weight[posterior_grid$mu > 0]),
    sum(exp(posterior_grid$mu) * posterior_grid$weight)
  ),
  monte_carlo_estimate = c(
    mean(grid_draws$mu),
    mean(grid_draws$mu > 0),
    mean(exp(grid_draws$mu))
  ),
  monte_carlo_se = c(
    stats::sd(grid_draws$mu) / sqrt(grid_draw_count),
    sqrt(mean(grid_draws$mu > 0) * (1 - mean(grid_draws$mu > 0)) /
           grid_draw_count),
    stats::sd(exp(grid_draws$mu)) / sqrt(grid_draw_count)
  ),
  draws = grid_draw_count,
  stringsAsFactors = FALSE
)
write_output(monte_carlo_summary, "provo-monte-carlo-integration.csv")

# Importance sampling uses a bivariate Student-t proposal centered on the
# data-derived mode and scaled from grid posterior covariance.
rmvt <- function(n, location, scale, df) {
  dimension <- length(location)
  normal <- matrix(stats::rnorm(n * dimension), nrow = n, ncol = dimension)
  standard <- sqrt(stats::rchisq(n, df = df) / df)
  sweep(normal %*% chol(scale), 1L, standard, "/") +
    matrix(location, nrow = n, ncol = dimension, byrow = TRUE)
}

dmvt_log <- function(x, location, scale, df) {
  dimension <- length(location)
  centered <- sweep(x, 2L, location, "-")
  inverse <- solve(scale)
  quadratic <- rowSums((centered %*% inverse) * centered)
  determinant <- determinant(scale, logarithm = TRUE)$modulus[[1L]]
  lgamma((df + dimension) / 2) - lgamma(df / 2) -
    0.5 * (dimension * log(df * pi) + determinant) -
    0.5 * (df + dimension) * log1p(quadratic / df)
}

importance_seed <- 2026101803L
importance_draw_count <- 30000L
proposal_df <- 5
proposal_scale <- 1.5 * grid_covariance
set.seed(importance_seed)
importance_eta <- rmvt(
  importance_draw_count,
  location = grid_mean_eta,
  scale = proposal_scale,
  df = proposal_df
)
importance_log_target <- apply(importance_eta, 1L, log_posterior_eta)
importance_log_proposal <- dmvt_log(
  importance_eta,
  location = grid_mean_eta,
  scale = proposal_scale,
  df = proposal_df
)
importance_log_weight <- importance_log_target - importance_log_proposal
importance_weight <- exp(importance_log_weight - log_sum_exp(importance_log_weight))
importance_ess <- 1 / sum(importance_weight^2)
importance_mu <- importance_eta[, 1L]
importance_summary <- data.frame(
  quantity = c(
    "draws", "self_normalized_E_mu", "self_normalized_P_mu_positive",
    "self_normalized_E_exp_mu", "raw_weight_ESS", "largest_weight",
    "top_100_weight_share"
  ),
  value = c(
    importance_draw_count,
    sum(importance_weight * importance_mu),
    sum(importance_weight * (importance_mu > 0)),
    sum(importance_weight * exp(importance_mu)),
    importance_ess,
    max(importance_weight),
    sum(sort(importance_weight, decreasing = TRUE)[seq_len(100L)])
  ),
  stringsAsFactors = FALSE
)
write_output(importance_summary, "provo-importance-sampling-summary.csv")

importance_output <- data.frame(
  draw = seq_len(importance_draw_count),
  mu = importance_eta[, 1L],
  sigma = exp(importance_eta[, 2L]),
  normalized_weight = importance_weight
)
write_output(importance_output, "provo-importance-sampling-draws.csv")
importance_cutoff <- stats::quantile(importance_weight, 0.99)
p_importance <- ggplot2::ggplot(
  importance_output,
  ggplot2::aes(mu, sigma)
) +
  ggplot2::geom_point(color = "grey65", alpha = 0.16, size = 0.55) +
  ggplot2::geom_point(
    data = subset(importance_output, normalized_weight >= importance_cutoff),
    color = "#8B1A1A",
    alpha = 0.65,
    size = 0.8
  ) +
  ggplot2::labs(
    x = "Passage-level noun-minus-verb contrast (mu)",
    y = "Passage contrast scale (sigma)"
  ) +
  theme_notes
save_plot(p_importance, "provo-importance-proposal.png")

# Random-walk Metropolis. Proposal covariance and initial offsets are scaled by
# the actual grid posterior geometry.
mh_seed <- 2026101804L
mh_chains <- 4L
mh_iterations <- 6000L
mh_warmup <- 1000L
mh_dimension <- 2L
mh_proposal_covariance <- (2.38^2 / mh_dimension) * grid_covariance
mh_cholesky <- chol(mh_proposal_covariance)
posterior_cholesky <- t(chol(grid_covariance))
initial_z <- rbind(c(-2, -1), c(-0.6, 1), c(0.6, -1), c(2, 1))
mh_initial <- t(vapply(
  seq_len(mh_chains),
  function(chain) grid_mean_eta + posterior_cholesky %*% initial_z[chain, ],
  numeric(mh_dimension)
))

set.seed(mh_seed)
mh_rows <- vector("list", mh_chains)
for (chain in seq_len(mh_chains)) {
  current <- mh_initial[chain, ]
  current_log_target <- log_posterior_eta(current)
  chain_rows <- vector("list", mh_iterations)
  for (iteration in seq_len(mh_iterations)) {
    proposal <- current + drop(stats::rnorm(mh_dimension) %*% mh_cholesky)
    proposal_log_target <- log_posterior_eta(proposal)
    log_acceptance_ratio <- proposal_log_target - current_log_target
    accepted <- log(stats::runif(1L)) < min(0, log_acceptance_ratio)
    previous <- current
    if (accepted) {
      current <- proposal
      current_log_target <- proposal_log_target
    }
    chain_rows[[iteration]] <- data.frame(
      chain = chain,
      iteration = iteration,
      mu_previous = previous[[1L]],
      sigma_previous = exp(previous[[2L]]),
      mu_proposed = proposal[[1L]],
      sigma_proposed = exp(proposal[[2L]]),
      log_acceptance_ratio = log_acceptance_ratio,
      accepted = accepted,
      mu = current[[1L]],
      log_sigma = current[[2L]],
      sigma = exp(current[[2L]])
    )
  }
  mh_rows[[chain]] <- do.call(rbind, chain_rows)
}
mh <- do.call(rbind, mh_rows)
mh$post_warmup <- mh$iteration > mh_warmup
write_output(mh, "provo-metropolis-hastings-draws.csv")

mh_diagnostics <- do.call(rbind, lapply(split(mh, mh$chain), function(chain_data) {
  post <- subset(chain_data, post_warmup)
  data.frame(
    chain = chain_data$chain[[1L]],
    initial_mu = chain_data$mu_previous[[1L]],
    initial_sigma = chain_data$sigma_previous[[1L]],
    acceptance_rate_all = mean(chain_data$accepted),
    acceptance_rate_post_warmup = mean(post$accepted),
    post_warmup_mu_mean = mean(post$mu),
    post_warmup_sigma_mean = mean(post$sigma)
  )
}))
write_output(mh_diagnostics, "provo-metropolis-hastings-diagnostics.csv")
write_output(
  subset(mh, iteration <= 25L),
  "provo-metropolis-first-transitions.csv"
)

p_mh_trace <- ggplot2::ggplot(
  subset(mh, iteration > mh_warmup),
  ggplot2::aes(iteration, mu, group = factor(chain), color = factor(chain))
) +
  ggplot2::geom_line(alpha = 0.65, linewidth = 0.3) +
  ggplot2::scale_color_grey(start = 0.15, end = 0.7) +
  ggplot2::labs(
    x = "Post-warmup Metropolis iteration",
    y = "Passage-level contrast (mu)"
  ) +
  theme_notes
save_plot(p_mh_trace, "provo-metropolis-trace.png", height = 4.4)

# One static HMC trajectory in whitened coordinates. Whitening uses the grid
# posterior covariance, while every potential-energy evaluation is still the
# Provo posterior kernel above.
hmc_seed <- 2026101805L
hmc_step_size <- 0.20
hmc_leapfrog_steps <- 12L
hmc_transform <- posterior_cholesky
hmc_inverse_transform <- solve(hmc_transform)
log_posterior_z <- function(z) {
  eta <- grid_mean_eta + drop(hmc_transform %*% z)
  log_posterior_eta(eta)
}
gradient_log_posterior_z <- function(z) {
  eta <- grid_mean_eta + drop(hmc_transform %*% z)
  drop(t(hmc_transform) %*% gradient_log_posterior_eta(eta))
}

set.seed(hmc_seed)
hmc_q <- drop(hmc_inverse_transform %*% (mode_eta - grid_mean_eta))
hmc_p <- stats::rnorm(mh_dimension)
hmc_initial_q <- hmc_q
hmc_initial_p <- hmc_p
hmc_rows <- vector("list", hmc_leapfrog_steps + 1L)
record_hmc <- function(step, q, p) {
  eta <- grid_mean_eta + drop(hmc_transform %*% q)
  potential <- -log_posterior_z(q)
  kinetic <- sum(p^2) / 2
  data.frame(
    step = step,
    mu = eta[[1L]],
    log_sigma = eta[[2L]],
    sigma = exp(eta[[2L]]),
    momentum_1 = p[[1L]],
    momentum_2 = p[[2L]],
    potential_energy = potential,
    kinetic_energy = kinetic,
    hamiltonian = potential + kinetic
  )
}
hmc_rows[[1L]] <- record_hmc(0L, hmc_q, hmc_p)
hmc_p <- hmc_p + 0.5 * hmc_step_size * gradient_log_posterior_z(hmc_q)
for (step in seq_len(hmc_leapfrog_steps)) {
  hmc_q <- hmc_q + hmc_step_size * hmc_p
  if (step < hmc_leapfrog_steps) {
    hmc_p <- hmc_p + hmc_step_size * gradient_log_posterior_z(hmc_q)
  } else {
    hmc_p <- hmc_p + 0.5 * hmc_step_size * gradient_log_posterior_z(hmc_q)
  }
  hmc_rows[[step + 1L]] <- record_hmc(step, hmc_q, hmc_p)
}
hmc_path <- do.call(rbind, hmc_rows)
hmc_energy_error <- tail(hmc_path$hamiltonian, 1L) - hmc_path$hamiltonian[[1L]]
hmc_acceptance_probability <- min(1, exp(-hmc_energy_error))
write_output(hmc_path, "provo-hmc-trajectory.csv")
write_output(data.frame(
  step_size = hmc_step_size,
  leapfrog_steps = hmc_leapfrog_steps,
  initial_hamiltonian = hmc_path$hamiltonian[[1L]],
  final_hamiltonian = tail(hmc_path$hamiltonian, 1L),
  energy_error = hmc_energy_error,
  acceptance_probability = hmc_acceptance_probability
), "provo-hmc-trajectory-summary.csv")

posterior_grid$density_relative <- exp(
  posterior_grid$log_kernel - max(posterior_grid$log_kernel)
)
p_hmc <- ggplot2::ggplot(
  posterior_grid,
  ggplot2::aes(mu, sigma, z = density_relative)
) +
  ggplot2::geom_contour(color = "grey65", bins = 7, linewidth = 0.45) +
  ggplot2::geom_path(
    data = hmc_path,
    ggplot2::aes(mu, sigma),
    color = "#8B1A1A",
    linewidth = 0.75,
    inherit.aes = FALSE
  ) +
  ggplot2::geom_point(
    data = hmc_path[c(1L, nrow(hmc_path)), ],
    ggplot2::aes(mu, sigma),
    color = "#8B1A1A",
    size = 1.7,
    inherit.aes = FALSE
  ) +
  ggplot2::labs(
    x = "Passage-level contrast (mu)",
    y = "Passage contrast scale (sigma)"
  ) +
  theme_notes
save_plot(p_hmc, "provo-hmc-trajectory.png")

whitened_grid <- t(hmc_inverse_transform %*% t(grid_centered))
whitened_covariance <- crossprod(
  whitened_grid * sqrt(posterior_grid$weight)
)
geometry_summary <- rbind(
  data.frame(
    coordinate_system = "mu, log_sigma",
    parameter_1_variance = grid_covariance[1L, 1L],
    parameter_2_variance = grid_covariance[2L, 2L],
    correlation = stats::cov2cor(grid_covariance)[1L, 2L]
  ),
  data.frame(
    coordinate_system = "posterior-whitened",
    parameter_1_variance = whitened_covariance[1L, 1L],
    parameter_2_variance = whitened_covariance[2L, 2L],
    correlation = stats::cov2cor(whitened_covariance)[1L, 2L]
  )
)
write_output(geometry_summary, "provo-mass-matrix-geometry.csv")

# Stan/NUTS production and stress fits. The production fit supplies inference.
# The stress fit keeps the same data and posterior but disables adaptation and
# uses an intentionally coarse step size solely to teach divergences.
stan_cache_path <- file.path(output_dir, "provo-stan-draw-cache.rds")
stan_algorithm_spec <- paste(
  "production=4x750+1000,adapt_delta=.90,max_treedepth=10",
  "stress=2x0+500,unit_e,no_adapt,step=.03,max_treedepth=7",
  "initialization=grid_mode_plus_posterior_scale_offsets",
  sep = ";"
)
cache_key <- paste(
  inputs$observed_sha256[inputs$dataset == "Provo passage summaries"],
  inputs$observed_sha256[inputs$dataset == "Provo posterior Stan program"],
  as.character(cmdstanr::cmdstan_version()),
  stan_algorithm_spec,
  sep = "::"
)

run_stan_fits <- function() {
  temporary_directory <- tempfile("reference-inference-bayesian-")
  dir.create(temporary_directory)
  temporary_stan <- file.path(temporary_directory, "provo_reference.stan")
  file.copy(stan_path, temporary_stan)
  model <- cmdstanr::cmdstan_model(temporary_stan, quiet = TRUE)
  stan_data <- list(
    N = N,
    y = y,
    prior_mu_sd = prior_mu_sd,
    prior_sigma_sd = prior_sigma_sd,
    nu = nu
  )
  initial_values <- function(offsets) {
    lapply(offsets, function(offset) list(
      mu = mode_eta[[1L]] + offset * sqrt(grid_covariance[1L, 1L]),
      sigma = exp(
        mode_eta[[2L]] + offset * sqrt(grid_covariance[2L, 2L])
      )
    ))
  }
  production <- model$sample(
    data = stan_data,
    seed = 2026101806,
    chains = 4,
    parallel_chains = 4,
    iter_warmup = 750,
    iter_sampling = 1000,
    adapt_delta = 0.90,
    max_treedepth = 10,
    init = initial_values(c(-0.75, -0.25, 0.25, 0.75)),
    refresh = 0,
    output_dir = temporary_directory,
    output_basename = "production"
  )
  stress <- model$sample(
    data = stan_data,
    seed = 2026101807,
    chains = 2,
    parallel_chains = 2,
    iter_warmup = 0,
    iter_sampling = 500,
    adapt_engaged = FALSE,
    step_size = 0.03,
    metric = "unit_e",
    max_treedepth = 7,
    init = initial_values(c(-0.25, 0.25)),
    refresh = 0,
    output_dir = temporary_directory,
    output_basename = "stress"
  )
  list(
    cache_key = cache_key,
    production_draws = production$draws(format = "draws_array"),
    production_diagnostics = production$sampler_diagnostics(format = "draws_array"),
    production_metadata = production$metadata(),
    stress_draws = stress$draws(format = "draws_array"),
    stress_diagnostics = stress$sampler_diagnostics(format = "draws_array"),
    stress_metadata = stress$metadata()
  )
}

stan_cache <- NULL
if (!refresh_stan && file.exists(stan_cache_path)) {
  candidate <- readRDS(stan_cache_path)
  if (identical(candidate$cache_key, cache_key)) stan_cache <- candidate
}
if (is.null(stan_cache)) {
  stan_cache <- run_stan_fits()
  saveRDS(stan_cache, stan_cache_path, version = 3)
}

production_draws <- stan_cache$production_draws
production_diagnostics <- stan_cache$production_diagnostics
stress_draws <- stan_cache$stress_draws
stress_diagnostics <- stan_cache$stress_diagnostics

key_draws <- posterior::subset_draws(
  production_draws,
  variable = c("mu", "sigma", "geometric_duration_ratio")
)
stan_summary <- posterior::summarise_draws(
  key_draws,
  "mean", "median", "sd", "rhat", "ess_bulk", "ess_tail",
  ~posterior::quantile2(.x, probs = c(0.025, 0.975))
)
stan_summary <- as.data.frame(stan_summary)
write_output(stan_summary, "provo-stan-posterior-summary.csv")
assert_true(max(stan_summary$rhat) < 1.01, "Production Stan R-hat is not below 1.01")

production_diag_df <- as.data.frame(posterior::as_draws_df(production_diagnostics))
stress_diag_df <- as.data.frame(posterior::as_draws_df(stress_diagnostics))
production_parameter_df <- as.data.frame(posterior::as_draws_df(key_draws))
stress_parameter_df <- as.data.frame(posterior::as_draws_df(posterior::subset_draws(
  stress_draws, variable = c("mu", "sigma")
)))

production_divergences <- sum(production_diag_df$divergent__)
stress_divergences <- sum(stress_diag_df$divergent__)
assert_true(production_divergences == 0L,
            "Production Stan fit contains divergent transitions")
assert_true(stress_divergences > 0L,
            "Stress fit did not produce a divergence; revise the computational stress setting")

nuts_summary <- do.call(rbind, lapply(
  split(production_diag_df, production_diag_df$.chain),
  function(chain_data) data.frame(
    chain = chain_data$.chain[[1L]],
    draws = nrow(chain_data),
    median_tree_depth = stats::median(chain_data$treedepth__),
    maximum_tree_depth = max(chain_data$treedepth__),
    median_leapfrog_steps = stats::median(chain_data$n_leapfrog__),
    maximum_leapfrog_steps = max(chain_data$n_leapfrog__),
    mean_acceptance_statistic = mean(chain_data$accept_stat__),
    divergences = sum(chain_data$divergent__)
  )
))
write_output(nuts_summary, "provo-nuts-sampler-summary.csv")

energy_summary <- do.call(rbind, lapply(
  split(production_diag_df, production_diag_df$.chain),
  function(chain_data) data.frame(
    chain = chain_data$.chain[[1L]],
    energy_bfmi = mean(diff(chain_data$energy__)^2) /
      stats::var(chain_data$energy__),
    energy_mean = mean(chain_data$energy__),
    energy_sd = stats::sd(chain_data$energy__)
  )
))
write_output(energy_summary, "provo-energy-diagnostics.csv")

divergence_summary <- rbind(
  data.frame(
    fit = "production adapted NUTS",
    chains = length(unique(production_diag_df$.chain)),
    draws = nrow(production_diag_df),
    step_size_setting = NA_real_,
    adaptation = TRUE,
    divergences = production_divergences,
    divergence_rate = mean(production_diag_df$divergent__)
  ),
  data.frame(
    fit = "computational stress: unit metric, no adaptation",
    chains = length(unique(stress_diag_df$.chain)),
    draws = nrow(stress_diag_df),
    step_size_setting = 0.03,
    adaptation = FALSE,
    divergences = stress_divergences,
    divergence_rate = mean(stress_diag_df$divergent__)
  )
)
write_output(divergence_summary, "provo-divergence-summary.csv")

stress_pairs <- merge(
  stress_parameter_df,
  stress_diag_df[, c(".chain", ".iteration", "divergent__")],
  by = c(".chain", ".iteration")
)
write_output(stress_pairs, "provo-divergence-draws.csv")
p_divergence <- ggplot2::ggplot(stress_pairs, ggplot2::aes(mu, sigma)) +
  ggplot2::geom_point(color = "grey65", alpha = 0.35, size = 0.75) +
  ggplot2::geom_point(
    data = subset(stress_pairs, divergent__ == 1),
    color = "#8B1A1A",
    alpha = 0.75,
    size = 1.1
  ) +
  ggplot2::coord_cartesian(
    xlim = weighted_quantile(
      posterior_grid$mu, posterior_grid$weight, c(0.001, 0.999)
    ),
    ylim = exp(weighted_quantile(
      posterior_grid$log_sigma, posterior_grid$weight, c(0.001, 0.999)
    ))
  ) +
  ggplot2::labs(
    x = "Passage-level contrast (mu)",
    y = "Passage contrast scale (sigma)"
  ) +
  theme_notes
save_plot(p_divergence, "provo-divergence-pairs.png")

# Trace and rank displays use only the production fit.
trace_long <- rbind(
  data.frame(
    chain = production_parameter_df$.chain,
    iteration = production_parameter_df$.iteration,
    parameter = "mu",
    value = production_parameter_df$mu
  ),
  data.frame(
    chain = production_parameter_df$.chain,
    iteration = production_parameter_df$.iteration,
    parameter = "sigma",
    value = production_parameter_df$sigma
  )
)
write_output(trace_long, "provo-nuts-trace-draws.csv")
p_trace <- ggplot2::ggplot(
  trace_long,
  ggplot2::aes(iteration, value, group = factor(chain), color = factor(chain))
) +
  ggplot2::geom_line(alpha = 0.65, linewidth = 0.3) +
  ggplot2::facet_wrap(~parameter, scales = "free_y", ncol = 1) +
  ggplot2::scale_color_grey(start = 0.15, end = 0.7) +
  ggplot2::labs(x = "Post-warmup NUTS iteration", y = "Draw") +
  theme_notes
save_plot(p_trace, "provo-nuts-trace.png", height = 5.4)

rank_rows <- do.call(rbind, lapply(c("mu", "sigma"), function(parameter) {
  values <- production_parameter_df[[parameter]]
  ranks <- rank(values, ties.method = "average")
  bins <- cut(
    ranks,
    breaks = seq(0, length(values), length.out = 21L),
    include.lowest = TRUE,
    labels = FALSE
  )
  counts <- as.data.frame(table(
    chain = production_parameter_df$.chain,
    bin = bins
  ))
  names(counts)[[3L]] <- "count"
  counts$parameter <- parameter
  counts
}))
write_output(rank_rows, "provo-nuts-rank-counts.csv")
p_rank <- ggplot2::ggplot(
  rank_rows,
  ggplot2::aes(as.numeric(as.character(bin)), count, fill = factor(chain))
) +
  ggplot2::geom_col(position = "dodge", width = 0.85) +
  ggplot2::facet_wrap(~parameter, ncol = 1) +
  ggplot2::scale_fill_grey(start = 0.2, end = 0.8) +
  ggplot2::labs(x = "Pooled-rank bin", y = "Draws") +
  theme_notes
save_plot(p_rank, "provo-nuts-rank-plots.png", height = 5.2)

# Basic R-hat arithmetic and modern rank-normalized summaries use the same
# actual production chains.
mu_matrix <- posterior::as_draws_matrix(
  posterior::subset_draws(production_draws, variable = "mu")
)
# as_draws_matrix stacks chains; reconstruct by chain explicitly for the hand
# calculation so columns are chains and rows are iterations.
mu_by_chain <- sapply(
  sort(unique(production_parameter_df$.chain)),
  function(chain) production_parameter_df$mu[production_parameter_df$.chain == chain]
)
chain_length <- nrow(mu_by_chain)
chain_count <- ncol(mu_by_chain)
within_variance <- mean(apply(mu_by_chain, 2L, stats::var))
between_variance <- chain_length * stats::var(colMeans(mu_by_chain))
variance_plus <- ((chain_length - 1) / chain_length) * within_variance +
  between_variance / chain_length
basic_rhat <- sqrt(variance_plus / within_variance)
rhat_output <- data.frame(
  quantity = c(
    "chains", "draws_per_chain", "within_chain_variance",
    "scaled_between_chain_variance", "variance_plus", "basic_rhat",
    "rank_normalized_split_rhat_mu", "rank_normalized_split_rhat_sigma"
  ),
  value = c(
    chain_count, chain_length, within_variance, between_variance,
    variance_plus, basic_rhat,
    posterior::rhat(posterior::subset_draws(production_draws, variable = "mu")),
    posterior::rhat(posterior::subset_draws(production_draws, variable = "sigma"))
  ),
  stringsAsFactors = FALSE
)
write_output(rhat_output, "provo-rhat-calculation.csv")

acf_rows <- do.call(rbind, lapply(c("mu", "sigma"), function(parameter) {
  do.call(rbind, lapply(split(
    production_parameter_df,
    production_parameter_df$.chain
  ), function(chain_data) {
    acf_value <- stats::acf(
      chain_data[[parameter]], lag.max = 40L, plot = FALSE, demean = TRUE
    )$acf[, 1L, 1L]
    data.frame(
      parameter = parameter,
      chain = chain_data$.chain[[1L]],
      lag = 0:40,
      autocorrelation = acf_value
    )
  }))
}))
write_output(acf_rows, "provo-nuts-autocorrelation.csv")
p_acf <- ggplot2::ggplot(
  acf_rows,
  ggplot2::aes(lag, autocorrelation, group = factor(chain), color = factor(chain))
) +
  ggplot2::geom_hline(yintercept = 0, color = "grey75", linewidth = 0.4) +
  ggplot2::geom_line(linewidth = 0.55) +
  ggplot2::facet_wrap(~parameter, ncol = 1) +
  ggplot2::scale_color_grey(start = 0.15, end = 0.7) +
  ggplot2::labs(x = "Lag", y = "Autocorrelation") +
  theme_notes
save_plot(p_acf, "provo-nuts-autocorrelation.png", height = 5.2)

# A one-chain truncated autocorrelation sum provides the textbook ESS bridge;
# modern bulk/tail values remain the reporting quantities.
mu_chain_one_acf <- subset(acf_rows, parameter == "mu" & chain == 1L)
positive_lags <- mu_chain_one_acf$autocorrelation[-1L]
first_nonpositive <- which(positive_lags <= 0)
if (length(first_nonpositive)) {
  positive_lags <- positive_lags[seq_len(first_nonpositive[[1L]] - 1L)]
}
integrated_time <- 1 + 2 * sum(positive_lags)
ess_output <- data.frame(
  quantity = c(
    "chain_1_draws", "chain_1_positive_sequence_integrated_time",
    "chain_1_textbook_ess_mu", "modern_bulk_ess_mu", "modern_tail_ess_mu",
    "modern_bulk_ess_sigma", "modern_tail_ess_sigma",
    "posterior_sd_mu", "mcse_mean_mu"
  ),
  value = c(
    chain_length, integrated_time, chain_length / integrated_time,
    posterior::ess_bulk(posterior::subset_draws(production_draws, variable = "mu")),
    posterior::ess_tail(posterior::subset_draws(production_draws, variable = "mu")),
    posterior::ess_bulk(posterior::subset_draws(production_draws, variable = "sigma")),
    posterior::ess_tail(posterior::subset_draws(production_draws, variable = "sigma")),
    stats::sd(production_parameter_df$mu),
    posterior::mcse_mean(posterior::subset_draws(production_draws, variable = "mu"))
  ),
  stringsAsFactors = FALSE
)
write_output(ess_output, "provo-effective-sample-size.csv")

p_pairs <- ggplot2::ggplot(
  production_parameter_df,
  ggplot2::aes(mu, sigma)
) +
  ggplot2::geom_point(color = "grey35", alpha = 0.18, size = 0.65) +
  ggplot2::labs(
    x = "Passage-level contrast (mu)",
    y = "Passage contrast scale (sigma)"
  ) +
  theme_notes
save_plot(p_pairs, "provo-production-pairs.png")

# Generated quantities and posterior predictive checks.
all_draws_df <- as.data.frame(posterior::as_draws_df(production_draws))
y_rep_columns <- grep("^y_rep\\[", names(all_draws_df), value = TRUE)
log_lik_columns <- grep("^log_lik\\[", names(all_draws_df), value = TRUE)
y_rep <- as.matrix(all_draws_df[, y_rep_columns, drop = FALSE])
log_lik <- as.matrix(all_draws_df[, log_lik_columns, drop = FALSE])
assert_true(ncol(y_rep) == N, "Stan generated quantities lost a passage replicate")
assert_true(ncol(log_lik) == N, "Stan log likelihood lost a passage")

generated_summary <- data.frame(
  quantity = c(
    "posterior_draws", "replicated_values_per_draw", "log_likelihood_values_per_draw",
    "mean_geometric_duration_ratio", "median_geometric_duration_ratio",
    "mean_total_log_likelihood"
  ),
  value = c(
    nrow(all_draws_df), ncol(y_rep), ncol(log_lik),
    mean(all_draws_df$geometric_duration_ratio),
    stats::median(all_draws_df$geometric_duration_ratio),
    mean(rowSums(log_lik))
  ),
  stringsAsFactors = FALSE
)
write_output(generated_summary, "provo-generated-quantities-summary.csv")

ppc_discrepancies <- data.frame(
  draw = seq_len(nrow(y_rep)),
  mean = rowMeans(y_rep),
  sd = apply(y_rep, 1L, stats::sd),
  maximum_absolute = apply(abs(y_rep), 1L, max),
  proportion_positive = rowMeans(y_rep > 0)
)
write_output(ppc_discrepancies, "provo-posterior-predictive-discrepancies.csv")

ppc_summary <- data.frame(
  discrepancy = c("mean", "sd", "maximum_absolute", "proportion_positive"),
  observed = c(mean(y), stats::sd(y), max(abs(y)), mean(y > 0)),
  posterior_predictive_median = c(
    stats::median(ppc_discrepancies$mean),
    stats::median(ppc_discrepancies$sd),
    stats::median(ppc_discrepancies$maximum_absolute),
    stats::median(ppc_discrepancies$proportion_positive)
  ),
  posterior_predictive_q025 = c(
    stats::quantile(ppc_discrepancies$mean, 0.025),
    stats::quantile(ppc_discrepancies$sd, 0.025),
    stats::quantile(ppc_discrepancies$maximum_absolute, 0.025),
    stats::quantile(ppc_discrepancies$proportion_positive, 0.025)
  ),
  posterior_predictive_q975 = c(
    stats::quantile(ppc_discrepancies$mean, 0.975),
    stats::quantile(ppc_discrepancies$sd, 0.975),
    stats::quantile(ppc_discrepancies$maximum_absolute, 0.975),
    stats::quantile(ppc_discrepancies$proportion_positive, 0.975)
  ),
  stringsAsFactors = FALSE
)
write_output(ppc_summary, "provo-posterior-predictive-summary.csv")

predictive_x <- seq(min(y) - 0.04, max(y) + 0.04, length.out = 300L)
predictive_draw_indices <- round(seq(1L, nrow(all_draws_df), length.out = 800L))
predictive_density_matrix <- vapply(
  predictive_draw_indices,
  function(index) {
    stats::dt(
      (predictive_x - all_draws_df$mu[[index]]) /
        all_draws_df$sigma[[index]],
      df = nu
    ) / all_draws_df$sigma[[index]]
  },
  numeric(length(predictive_x))
)
predictive_density <- data.frame(
  contrast = predictive_x,
  q05 = apply(predictive_density_matrix, 1L, stats::quantile, 0.05),
  median = apply(predictive_density_matrix, 1L, stats::median),
  q95 = apply(predictive_density_matrix, 1L, stats::quantile, 0.95)
)
write_output(predictive_density, "provo-posterior-predictive-density.csv")

p_fitted <- ggplot2::ggplot(data.frame(contrast = y), ggplot2::aes(contrast)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    bins = 14,
    fill = "grey78",
    color = "white"
  ) +
  ggplot2::geom_ribbon(
    data = predictive_density,
    ggplot2::aes(contrast, ymin = q05, ymax = q95),
    fill = "#8B1A1A",
    alpha = 0.14,
    inherit.aes = FALSE
  ) +
  ggplot2::geom_line(
    data = predictive_density,
    ggplot2::aes(contrast, median),
    color = "#8B1A1A",
    linewidth = 0.85,
    inherit.aes = FALSE
  ) +
  ggplot2::geom_rug(color = "grey30", sides = "b") +
  ggplot2::labs(
    x = "Passage noun-minus-verb mean log first-fixation duration",
    y = "Density"
  ) +
  theme_notes
save_plot(p_fitted, "provo-raw-and-posterior-predictive.png")

ppc_observed <- data.frame(
  discrepancy = c("Mean", "SD", "Maximum absolute contrast", "Proportion positive"),
  observed = c(mean(y), stats::sd(y), max(abs(y)), mean(y > 0))
)
ppc_long <- rbind(
  data.frame(discrepancy = "Mean", value = ppc_discrepancies$mean),
  data.frame(discrepancy = "SD", value = ppc_discrepancies$sd),
  data.frame(
    discrepancy = "Maximum absolute contrast",
    value = ppc_discrepancies$maximum_absolute
  ),
  data.frame(
    discrepancy = "Proportion positive",
    value = ppc_discrepancies$proportion_positive
  )
)
p_ppc <- ggplot2::ggplot(ppc_long, ggplot2::aes(value)) +
  ggplot2::geom_histogram(bins = 40, fill = "grey75", color = "white") +
  ggplot2::geom_vline(
    data = ppc_observed,
    ggplot2::aes(xintercept = observed),
    color = "#8B1A1A",
    linewidth = 0.75
  ) +
  ggplot2::facet_wrap(~discrepancy, scales = "free", ncol = 2) +
  ggplot2::labs(x = "Posterior-predictive discrepancy", y = "Replicates") +
  theme_notes
save_plot(p_ppc, "provo-posterior-predictive-checks.png", height = 5.0)

# One row per page fixes the handoff and prevents later page implementations
# from silently changing empirical targets.
page_registry <- data.frame(
  page = paste0(c(
    "posterior-distributions", "conjugate-priors",
    "prior-predictive-distributions", "predictive-distributions",
    "posterior-summaries", "beyond-conjugacy", "monte-carlo-integration",
    "importance-sampling", "markov-chains", "markov-chain-monte-carlo",
    "metropolis-hastings", "hamiltonian-monte-carlo",
    "mass-matrix-geometry", "no-u-turn-sampler", "stan",
    "checking-markov-chains", "rhat", "autocorrelation",
    "effective-sample-size", "divergent-transitions",
    "parameter-pair-plots", "generated-quantities",
    "posterior-predictive-checks"
  ), ".qmd"),
  dataset = c(
    rep("Turkish UniMorph", 5L),
    rep("Provo passage summaries", 18L)
  ),
  empirical_object = c(
    "Beta posterior for t-initial ending share under an exchangeable bridge",
    "Beta--Bernoulli algebra for 42 of 120 sampled lexeme cells",
    "Beta--Binomial count distribution before the 120-row sample",
    "Beta--Binomial independent block versus known-resource hypergeometric block",
    "Posterior center, interval, direction, and transformed share",
    "Nonconjugate Student-t location--scale posterior for 55 passage contrasts",
    "Grid-posterior expectations and Monte Carlo standard errors",
    "Student-t proposal draws and self-normalized importance weights",
    "Provo-posterior random-walk transition and the Markov property",
    "Dependent draws targeting the Provo posterior",
    "Four random-walk Metropolis chains",
    "Whitened leapfrog trajectory through the Provo posterior",
    "Observed posterior covariance and whitening transformation",
    "Actual Stan NUTS tree-depth and leapfrog-count distribution",
    "Exact Provo Student-t Stan program and data list",
    "Four production NUTS traces and rank histograms",
    "Basic and rank-normalized split R-hat from production chains",
    "Within-chain autocorrelation for mu and sigma",
    "Textbook chain-one ESS and modern bulk/tail ESS",
    "Same Provo posterior under an intentionally coarse, unadapted HMC setting",
    "Production and stress-fit mu-by-sigma pairs",
    "exp(mu), replicated passage contrasts, and observation log likelihood",
    "Raw 55-passage contrasts, fitted predictive density, and four discrepancies"
  ),
  principal_output = c(
    "unimorph-beta-update.csv", "unimorph-beta-density.csv",
    "unimorph-predictive-summary.csv", "unimorph-predictive-designs.png",
    "unimorph-beta-posterior.png", "provo-grid-posterior-summary.csv",
    "provo-monte-carlo-integration.csv",
    "provo-importance-sampling-summary.csv",
    "provo-metropolis-first-transitions.csv",
    "provo-metropolis-hastings-diagnostics.csv",
    "provo-metropolis-trace.png", "provo-hmc-trajectory.png",
    "provo-mass-matrix-geometry.csv", "provo-nuts-sampler-summary.csv",
    "provo-stan-posterior-summary.csv", "provo-nuts-trace.png",
    "provo-rhat-calculation.csv", "provo-nuts-autocorrelation.png",
    "provo-effective-sample-size.csv", "provo-divergence-pairs.png",
    "provo-production-pairs.png", "provo-generated-quantities-summary.csv",
    "provo-posterior-predictive-checks.png"
  ),
  stringsAsFactors = FALSE
)
assert_true(nrow(page_registry) == 23L, "Bayesian page registry is not 23 rows")
write_output(page_registry, "page-object-registry.csv")

run_metadata <- data.frame(
  field = c(
    "run_timestamp_utc", "script", "refresh_stan", "unimorph_sample_seed",
    "prior_predictive_seed", "grid_draw_seed", "importance_seed", "mh_seed",
    "hmc_seed", "production_stan_seed", "stress_stan_seed",
    "provo_observation_unit", "provo_target", "stan_algorithm_spec",
    "stan_cache_key"
  ),
  value = c(
    format(Sys.time(), tz = "UTC", usetz = TRUE),
    "scripts/data-grounding/reference_inference_bayesian.R",
    refresh_stan,
    414,
    prior_predictive_seed,
    grid_draw_seed,
    importance_seed,
    mh_seed,
    hmc_seed,
    2026101806,
    2026101807,
    "one passage summary assembled from aggregated content-word positions",
    "unweighted location and scale of noun-minus-verb mean log FFD across 55 passages",
    stan_algorithm_spec,
    cache_key
  ),
  stringsAsFactors = FALSE
)
write_output(run_metadata, "run-metadata.csv")

capture.output(sessionInfo(), file = file.path(output_dir, "session-info.txt"))

message("Bayesian reference analysis complete: ", output_dir)
