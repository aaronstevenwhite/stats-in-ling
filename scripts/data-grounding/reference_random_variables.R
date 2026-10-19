#!/usr/bin/env Rscript

# Paper-first reference analysis for random-variables-and-distributions/.
#
# This script reads only the committed teaching inputs. It validates their
# schemas and frozen checksums, computes the empirical objects used in the
# notes, and writes small reference tables and restrained scientific figures.
# It does not modify a teaching input or a problem set.

options(stringsAsFactors = FALSE, scipen = 999)

script_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
if (length(script_arg) == 1L) {
  script_path <- normalizePath(sub("^--file=", "", script_arg), mustWork = TRUE)
  project_root <- dirname(dirname(dirname(script_path)))
} else {
  project_root <- normalizePath(getwd(), mustWork = TRUE)
}

output_dir <- file.path(
  project_root,
  "research", "dataset-audits", "reference-random-variables-output"
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

population_variance <- function(x) mean((x - mean(x))^2)
population_covariance <- function(x, y) mean((x - mean(x)) * (y - mean(y)))

empirical_pmf <- function(x, variable) {
  counts <- table(x, useNA = "no")
  data.frame(
    variable = variable,
    value = as.numeric(names(counts)),
    count = as.integer(counts),
    probability = as.numeric(counts) / sum(counts),
    stringsAsFactors = FALSE
  )
}

empirical_cdf <- function(x, dataset, variable) {
  pmf <- empirical_pmf(x, variable)
  data.frame(
    dataset = dataset,
    variable = variable,
    value = pmf$value,
    count = pmf$count,
    cumulative_probability = cumsum(pmf$probability),
    stringsAsFactors = FALSE
  )
}

ggplot_available <- requireNamespace("ggplot2", quietly = TRUE)
mass_available <- requireNamespace("MASS", quietly = TRUE)

package_status <- data.frame(
  package = c("base", "stats", "utils", "grDevices", "ggplot2", "MASS"),
  available = c(TRUE, TRUE, TRUE, TRUE, ggplot_available, mass_available),
  version = c(
    as.character(getRversion()),
    as.character(utils::packageVersion("stats")),
    as.character(utils::packageVersion("utils")),
    as.character(utils::packageVersion("grDevices")),
    if (ggplot_available) as.character(utils::packageVersion("ggplot2")) else NA_character_,
    if (mass_available) as.character(utils::packageVersion("MASS")) else NA_character_
  )
)
write_output(package_status, "package-versions.csv")
assert_true(ggplot_available, "ggplot2 is required to write the reference figures")

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

input_specs <- data.frame(
  dataset = c(
    "CMUdict 0.7b",
    "Hillenbrand et al. (1995)",
    "UD Turkish BOUN 2.18 questions",
    "Turkish UniMorph population",
    "Turkish UniMorph sample",
    "English dative alternation",
    "Provo content-word positions"
  ),
  path = file.path(
    project_root,
    c(
      "data/cmudict/cmudict-pronunciations.csv",
      "data/hillenbrand/vowels-complete.csv",
      "data/ud-turkish-boun/question-core-arguments.csv",
      "data/unimorph-turkish/verb-past-population.csv",
      "data/unimorph-turkish/verb-past-sample-120.csv",
      "data/english-dative/dative-alternation.csv",
      "data/provo/content-word-positions.csv"
    )
  ),
  expected_sha256 = c(
    "bbf40ef2e185b32d515f5ba6dea91c640977007b61967dce2e489ccfb99385fd",
    "de3450982779fe3ac2e914974eb0ba6a7e0f778d7328f6dbb5d5ab5a58af22c9",
    "420a4f358b77af61decf75e4536f46c88c26a5ae84c1dd75de6269bc85cc49d9",
    "440ba51c27fd9b9db0366478dfbcf40ae50e7538e35ec0f8793d6231b9be76a4",
    "b5d293b2496290b567a86ee7c77ce33cee249c3a9a5c7c38f6a11a2dba28980e",
    "02a49e0ef2da7df73a7ef622ddf31a55ba13c52a9b66bcfdf2fef3def7932bea",
    "458a5233347c5e5e1b80e9d73a14b448d90bbd7031bd80b295b096d74f50e914"
  ),
  stringsAsFactors = FALSE
)
assert_true(all(file.exists(input_specs$path)), "At least one frozen teaching input is missing")
input_specs$observed_sha256 <- vapply(input_specs$path, sha256, character(1))
input_specs$checksum_matches <- input_specs$observed_sha256 == input_specs$expected_sha256
assert_true(all(input_specs$checksum_matches), "At least one frozen teaching input checksum changed")
write_output(input_specs, "input-checksums.csv")

cmu <- utils::read.csv(input_specs$path[input_specs$dataset == "CMUdict 0.7b"], check.names = FALSE)
hillenbrand <- utils::read.csv(
  input_specs$path[input_specs$dataset == "Hillenbrand et al. (1995)"],
  check.names = FALSE
)
ud_question <- utils::read.csv(
  input_specs$path[input_specs$dataset == "UD Turkish BOUN 2.18 questions"],
  check.names = FALSE
)
unimorph_population <- utils::read.csv(
  input_specs$path[input_specs$dataset == "Turkish UniMorph population"],
  check.names = FALSE
)
unimorph_sample <- utils::read.csv(
  input_specs$path[input_specs$dataset == "Turkish UniMorph sample"],
  check.names = FALSE
)
dative <- utils::read.csv(
  input_specs$path[input_specs$dataset == "English dative alternation"],
  check.names = FALSE,
  na.strings = c("", "NA")
)
provo <- utils::read.csv(
  input_specs$path[input_specs$dataset == "Provo content-word positions"],
  check.names = FALSE
)

required_columns <- list(
  cmu = c(
    "entry", "word", "phones", "phone_count", "vowel_phone_count",
    "consonants_before_first_vowel", "consonants_before_third_vowel"
  ),
  hillenbrand = c("speaker_id", "speaker_type", "vowel", "duration_ms", "f1_hz"),
  ud_question = c("sentence_id", "lemma", "dependency_relation", "object"),
  unimorph_population = c("lemma", "form", "feature_bundle", "past_suffix", "t_initial"),
  unimorph_sample = c("lemma", "form", "feature_bundle", "past_suffix", "t_initial"),
  dative = c(
    "modality", "verb", "recipient_length_words", "theme_length_words",
    "recipient_pronominality", "recipient_realization"
  ),
  provo = c("position_id", "Text_ID", "Word_POS", "OrthoMatchModel")
)
data_objects <- list(
  cmu = cmu,
  hillenbrand = hillenbrand,
  ud_question = ud_question,
  unimorph_population = unimorph_population,
  unimorph_sample = unimorph_sample,
  dative = dative,
  provo = provo
)
for (name in names(required_columns)) {
  missing_columns <- setdiff(required_columns[[name]], names(data_objects[[name]]))
  assert_true(length(missing_columns) == 0L, paste(name, "is missing required columns"))
}

assert_true(nrow(cmu) == 133854L, "CMUdict row count changed")
assert_true(!anyDuplicated(cmu$entry), "CMUdict entry IDs are not unique")
assert_true(all(cmu$phone_count >= cmu$vowel_phone_count), "CMUdict phone counts are inconsistent")
assert_true(nrow(hillenbrand) == 1668L, "Hillenbrand row count changed")
assert_true(length(unique(hillenbrand$speaker_id)) == 139L, "Hillenbrand speaker count changed")
assert_true(all(table(hillenbrand$speaker_id) == 12L), "Hillenbrand speaker-by-vowel design changed")
assert_true(nrow(ud_question) == 167L, "UD Turkish BOUN question row count changed")
assert_true(identical(sort(unique(ud_question$lemma)), c("hangi", "kim", "ne")), "UD lemma support changed")
assert_true(nrow(unimorph_population) == 588L, "UniMorph population row count changed")
assert_true(nrow(unimorph_sample) == 120L, "UniMorph sample row count changed")
assert_true(all(unimorph_sample$lemma %in% unimorph_population$lemma), "UniMorph sample is not a population subset")
assert_true(nrow(dative) == 3263L, "Dative row count changed")
assert_true(nrow(provo) == 1593L, "Provo position row count changed")
assert_true(all(provo$OrthoMatchModel > 0 & provo$OrthoMatchModel < 1), "Provo modeled cloze values left (0,1)")

validation <- data.frame(
  dataset = input_specs$dataset,
  rows = c(
    nrow(cmu), nrow(hillenbrand), nrow(ud_question), nrow(unimorph_population),
    nrow(unimorph_sample), nrow(dative), nrow(provo)
  ),
  primary_cluster_count = c(
    length(unique(cmu$word)),
    length(unique(hillenbrand$speaker_id)),
    length(unique(ud_question$sentence_id)),
    length(unique(unimorph_population$lemma)),
    length(unique(unimorph_sample$lemma)),
    length(unique(dative$verb)),
    length(unique(provo$Text_ID))
  ),
  cluster_identifier = c("word", "speaker_id", "sentence_id", "lemma", "lemma", "verb", "Text_ID")
)
write_output(validation, "dataset-validation.csv")

# -----------------------------------------------------------------------------
# CMUdict: discrete random variables, moments, fitted Cauchy, and waiting counts
# -----------------------------------------------------------------------------

cmu_pmf <- rbind(
  empirical_pmf(cmu$phone_count, "phone_count"),
  empirical_pmf(cmu$vowel_phone_count, "vowel_phone_count")
)
write_output(cmu_pmf, "cmudict-pmfs.csv")
assert_true(abs(sum(cmu_pmf$probability[cmu_pmf$variable == "phone_count"]) - 1) < 1e-12,
            "CMUdict phone PMF does not sum to one")

cmu_phone_threshold <- unname(stats::quantile(cmu$phone_count, 0.75, type = 1))
cmu_vowel_value <- unname(stats::median(cmu$vowel_phone_count))
cmu_pmf_events <- data.frame(
  event = c(
    paste0("phone_count <= ", cmu_phone_threshold),
    paste0("vowel_phone_count = ", cmu_vowel_value),
    paste0("phone_count > ", cmu_phone_threshold)
  ),
  empirical_probability = c(
    mean(cmu$phone_count <= cmu_phone_threshold),
    mean(cmu$vowel_phone_count == cmu_vowel_value),
    mean(cmu$phone_count > cmu_phone_threshold)
  ),
  threshold_source = c(
    "empirical type-1 third quartile",
    "empirical median",
    "empirical type-1 third quartile"
  )
)
write_output(cmu_pmf_events, "cmudict-pmf-events.csv")

cmu_moment_row <- function(x, variable) {
  centered <- x - mean(x)
  variance <- mean(centered^2)
  data.frame(
    variable = variable,
    n = length(x),
    expectation = mean(x),
    variance_population = variance,
    standard_deviation_population = sqrt(variance),
    central_moment_1 = mean(centered),
    central_moment_2 = mean(centered^2),
    central_moment_3 = mean(centered^3),
    central_moment_4 = mean(centered^4),
    skewness = mean(centered^3) / variance^(3 / 2),
    kurtosis = mean(centered^4) / variance^2
  )
}
cmu_moments <- rbind(
  cmu_moment_row(cmu$phone_count, "phone_count"),
  cmu_moment_row(cmu$vowel_phone_count, "vowel_phone_count")
)
write_output(cmu_moments, "cmudict-moments.csv")
assert_true(abs(cmu_moments$central_moment_1[1L]) < 1e-12, "First central moment is not zero")

cmu_expectation_functions <- data.frame(
  random_variable = c("phone_count", "phone_count", "vowel_phone_count"),
  function_name = c("square", "log1p", "square"),
  expectation_of_function = c(
    mean(cmu$phone_count^2),
    mean(log1p(cmu$phone_count)),
    mean(cmu$vowel_phone_count^2)
  ),
  function_of_expectation = c(
    mean(cmu$phone_count)^2,
    log1p(mean(cmu$phone_count)),
    mean(cmu$vowel_phone_count)^2
  )
)
write_output(cmu_expectation_functions, "cmudict-expectation-of-functions.csv")

cmu$consonant_phone_count <- cmu$phone_count - cmu$vowel_phone_count
cmu_linearity <- data.frame(
  quantity = c(
    "E[phone_count]", "E[vowel_phone_count]", "E[consonant_phone_count]",
    "E[vowel_phone_count] + E[consonant_phone_count]", "identity_error"
  ),
  value = c(
    mean(cmu$phone_count),
    mean(cmu$vowel_phone_count),
    mean(cmu$consonant_phone_count),
    mean(cmu$vowel_phone_count) + mean(cmu$consonant_phone_count),
    mean(cmu$phone_count) - mean(cmu$vowel_phone_count) - mean(cmu$consonant_phone_count)
  )
)
write_output(cmu_linearity, "cmudict-linearity.csv")
assert_true(abs(tail(cmu_linearity$value, 1L)) < 1e-12, "CMUdict expectation identity failed")

cmu_variance_decomposition <- data.frame(
  quantity = c(
    "Var(phone_count)", "Var(vowel_phone_count)", "Var(consonant_phone_count)",
    "Cov(vowel_phone_count, consonant_phone_count)",
    "Var(vowels) + Var(consonants) + 2 Cov", "identity_error"
  ),
  value = c(
    population_variance(cmu$phone_count),
    population_variance(cmu$vowel_phone_count),
    population_variance(cmu$consonant_phone_count),
    population_covariance(cmu$vowel_phone_count, cmu$consonant_phone_count),
    population_variance(cmu$vowel_phone_count) +
      population_variance(cmu$consonant_phone_count) +
      2 * population_covariance(cmu$vowel_phone_count, cmu$consonant_phone_count),
    population_variance(cmu$phone_count) -
      population_variance(cmu$vowel_phone_count) -
      population_variance(cmu$consonant_phone_count) -
      2 * population_covariance(cmu$vowel_phone_count, cmu$consonant_phone_count)
  )
)
write_output(cmu_variance_decomposition, "cmudict-variance-decomposition.csv")
assert_true(abs(tail(cmu_variance_decomposition$value, 1L)) < 1e-10,
            "CMUdict variance decomposition failed")

cmu_joint <- as.data.frame(table(
  phone_count = cmu$phone_count,
  vowel_phone_count = cmu$vowel_phone_count
), responseName = "count")
cmu_joint$phone_count <- as.numeric(as.character(cmu_joint$phone_count))
cmu_joint$vowel_phone_count <- as.numeric(as.character(cmu_joint$vowel_phone_count))
cmu_joint$probability <- cmu_joint$count / nrow(cmu)
cmu_joint <- cmu_joint[cmu_joint$count > 0, ]
write_output(cmu_joint, "cmudict-phone-vowel-joint-pmf.csv")

p_cmu_pmf <- ggplot2::ggplot(cmu_pmf, ggplot2::aes(value, probability)) +
  ggplot2::geom_col(fill = "grey45", width = 0.8) +
  ggplot2::facet_wrap(~variable, scales = "free_x", ncol = 1) +
  ggplot2::labs(x = "Count per pronunciation entry", y = "Empirical probability") +
  theme_notes
save_plot(p_cmu_pmf, "cmudict-phone-vowel-pmfs.png", height = 5.4)

# Fit a continuous Cauchy reference to the discrete phone counts. This is an
# intentionally misspecified descriptive model used only to anchor the Cauchy
# nonexistence demonstration to observed linguistic measurements.
cauchy_nll <- function(theta, x) {
  location <- theta[[1L]]
  scale <- exp(theta[[2L]])
  if (!is.finite(location) || !is.finite(scale) || scale <= 0) return(.Machine$double.xmax)
  -sum(stats::dcauchy(x, location = location, scale = scale, log = TRUE))
}
cauchy_start <- c(stats::median(cmu$phone_count), log(stats::IQR(cmu$phone_count) / 2))
cauchy_fit <- stats::optim(
  cauchy_start,
  cauchy_nll,
  x = cmu$phone_count,
  method = "L-BFGS-B",
  lower = c(min(cmu$phone_count) - 10, log(1e-6)),
  upper = c(max(cmu$phone_count) + 10, log(1e3)),
  hessian = TRUE
)
cauchy_location <- unname(cauchy_fit$par[[1L]])
cauchy_scale <- exp(unname(cauchy_fit$par[[2L]]))
assert_true(cauchy_fit$convergence == 0L, "Cauchy optimizer did not converge")
assert_true(is.finite(cauchy_location) && is.finite(cauchy_scale) && cauchy_scale > 0,
            "Cauchy fit returned invalid parameters")

phone_support <- sort(unique(cmu$phone_count))
phone_ecdf <- stats::ecdf(cmu$phone_count)
cauchy_ks_distance <- max(abs(
  phone_ecdf(phone_support) -
    stats::pcauchy(phone_support, cauchy_location, cauchy_scale)
))
cauchy_summary <- data.frame(
  model = "Cauchy fitted to CMUdict phone_count",
  n = nrow(cmu),
  location_mle = cauchy_location,
  scale_mle = cauchy_scale,
  log_likelihood = -cauchy_fit$value,
  optimizer_convergence = cauchy_fit$convergence,
  empirical_cdf_sup_distance = cauchy_ks_distance,
  model_expectation_exists = FALSE,
  model_variance_exists = FALSE
)
write_output(cauchy_summary, "cmudict-cauchy-fit-summary.csv")

cauchy_grid <- data.frame(x = seq(min(cmu$phone_count), max(cmu$phone_count), length.out = 500L))
cauchy_grid$density <- stats::dcauchy(cauchy_grid$x, cauchy_location, cauchy_scale)
write_output(cauchy_grid, "cmudict-cauchy-fit-grid.csv")

p_cauchy_fit <- ggplot2::ggplot(data.frame(phone_count = cmu$phone_count),
                                ggplot2::aes(phone_count)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    binwidth = 1,
    boundary = 0.5,
    fill = "grey75",
    color = "white"
  ) +
  ggplot2::geom_line(
    data = cauchy_grid,
    ggplot2::aes(x, density),
    color = "#8B1A1A",
    linewidth = 0.9,
    inherit.aes = FALSE
  ) +
  ggplot2::labs(x = "Phones per pronunciation entry", y = "Density") +
  theme_notes
save_plot(p_cauchy_fit, "cmudict-cauchy-fit.png")

set.seed(20261018)
cauchy_path_sizes <- c(10L, 30L, 100L, 300L, 1000L, 3000L, 10000L)
cauchy_path_replicates <- 24L
cauchy_paths <- do.call(rbind, lapply(seq_len(cauchy_path_replicates), function(replicate_id) {
  n_max <- max(cauchy_path_sizes)
  cauchy_draws <- stats::rcauchy(n_max, cauchy_location, cauchy_scale)
  empirical_draws <- sample(cmu$phone_count, n_max, replace = TRUE)
  rbind(
    data.frame(
      distribution = "fitted Cauchy",
      replicate = replicate_id,
      sample_size = cauchy_path_sizes,
      sample_mean = vapply(cauchy_path_sizes, function(n) mean(cauchy_draws[seq_len(n)]), numeric(1))
    ),
    data.frame(
      distribution = "empirical CMUdict PMF",
      replicate = replicate_id,
      sample_size = cauchy_path_sizes,
      sample_mean = vapply(cauchy_path_sizes, function(n) mean(empirical_draws[seq_len(n)]), numeric(1))
    )
  )
}))
write_output(cauchy_paths, "cmudict-cauchy-mean-paths.csv")

reference_means <- data.frame(
  distribution = c("fitted Cauchy", "empirical CMUdict PMF"),
  reference = c(cauchy_location, mean(cmu$phone_count)),
  reference_type = c("fitted location (not an expectation)", "empirical expectation")
)
p_cauchy_paths <- ggplot2::ggplot(
  cauchy_paths,
  ggplot2::aes(sample_size, sample_mean, group = interaction(distribution, replicate))
) +
  ggplot2::geom_line(color = "grey65", linewidth = 0.35, alpha = 0.7) +
  ggplot2::geom_hline(
    data = reference_means,
    ggplot2::aes(yintercept = reference),
    color = "#8B1A1A",
    linewidth = 0.75
  ) +
  ggplot2::facet_wrap(~distribution, scales = "free_y", ncol = 1) +
  ggplot2::scale_x_log10() +
  ggplot2::labs(x = "Sample size (log scale)", y = "Running sample mean") +
  theme_notes
save_plot(p_cauchy_paths, "cmudict-cauchy-mean-paths.png", height = 5.5)

first_wait <- cmu$consonants_before_first_vowel
third_wait <- cmu$consonants_before_third_vowel[!is.na(cmu$consonants_before_third_vowel)]
geometric_p <- 1 / (mean(first_wait) + 1)
negative_binomial_size <- 3L
negative_binomial_p <- negative_binomial_size / (negative_binomial_size + mean(third_wait))

geometric_grid <- data.frame(value = 0:max(first_wait))
geometric_counts <- table(first_wait)
geometric_grid$observed_count <- as.integer(geometric_counts[as.character(geometric_grid$value)])
geometric_grid$observed_probability <- geometric_grid$observed_count / length(first_wait)
geometric_grid$fitted_probability <- stats::dgeom(geometric_grid$value, prob = geometric_p)
geometric_grid$family <- "Geometric: consonants before first vowel"

negative_binomial_grid <- data.frame(value = 0:max(third_wait))
negative_binomial_counts <- table(third_wait)
negative_binomial_grid$observed_count <- as.integer(negative_binomial_counts[as.character(negative_binomial_grid$value)])
negative_binomial_grid$observed_probability <- negative_binomial_grid$observed_count / length(third_wait)
negative_binomial_grid$fitted_probability <- stats::dnbinom(
  negative_binomial_grid$value,
  size = negative_binomial_size,
  prob = negative_binomial_p
)
negative_binomial_grid$family <- "Negative binomial: consonants before third vowel"

waiting_fit <- rbind(geometric_grid, negative_binomial_grid)
write_output(waiting_fit, "cmudict-waiting-count-fits.csv")
waiting_summary <- data.frame(
  family = c("geometric", "negative_binomial"),
  observation = c("consonants before first vowel", "consonants before third vowel"),
  n = c(length(first_wait), length(third_wait)),
  target_success_number = c(1L, negative_binomial_size),
  fitted_success_probability = c(geometric_p, negative_binomial_p),
  empirical_mean = c(mean(first_wait), mean(third_wait)),
  fitted_mean = c((1 - geometric_p) / geometric_p,
                  negative_binomial_size * (1 - negative_binomial_p) / negative_binomial_p),
  empirical_variance_population = c(population_variance(first_wait), population_variance(third_wait)),
  fitted_variance = c((1 - geometric_p) / geometric_p^2,
                      negative_binomial_size * (1 - negative_binomial_p) / negative_binomial_p^2),
  observed_maximum = c(max(first_wait), max(third_wait)),
  fitted_probability_above_observed_maximum = c(
    stats::pgeom(max(first_wait), geometric_p, lower.tail = FALSE),
    stats::pnbinom(max(third_wait), negative_binomial_size, negative_binomial_p, lower.tail = FALSE)
  ),
  demonstration_count = c(stats::median(first_wait), stats::median(third_wait)),
  fitted_probability_at_demonstration_count = c(
    stats::dgeom(stats::median(first_wait), geometric_p),
    stats::dnbinom(stats::median(third_wait), negative_binomial_size, negative_binomial_p)
  ),
  empirical_probability_at_demonstration_count = c(
    mean(first_wait == stats::median(first_wait)),
    mean(third_wait == stats::median(third_wait))
  )
)
write_output(waiting_summary, "cmudict-waiting-count-summary.csv")

p_waiting <- ggplot2::ggplot(waiting_fit, ggplot2::aes(value)) +
  ggplot2::geom_col(ggplot2::aes(y = observed_probability), fill = "grey72", width = 0.8) +
  ggplot2::geom_point(ggplot2::aes(y = fitted_probability), color = "#8B1A1A", size = 1.8) +
  ggplot2::geom_line(ggplot2::aes(y = fitted_probability), color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::facet_wrap(~family, scales = "free_x", ncol = 1) +
  ggplot2::labs(x = "Consonant count", y = "Probability") +
  theme_notes
save_plot(p_waiting, "cmudict-waiting-count-fits.png", height = 5.5)

# -----------------------------------------------------------------------------
# Hillenbrand: continuous measurements and normal/chi-square/t references
# -----------------------------------------------------------------------------

hillenbrand_summary <- do.call(rbind, lapply(
  split(hillenbrand, list(hillenbrand$speaker_type, hillenbrand$vowel), drop = TRUE),
  function(x) data.frame(
    speaker_type = x$speaker_type[[1L]],
    vowel = x$vowel[[1L]],
    n = nrow(x),
    duration_mean_ms = mean(x$duration_ms),
    duration_sd_ms = stats::sd(x$duration_ms),
    f1_mean_hz = mean(x$f1_hz),
    f1_sd_hz = stats::sd(x$f1_hz)
  )
))
row.names(hillenbrand_summary) <- NULL
write_output(hillenbrand_summary, "hillenbrand-by-vowel-speaker-summary.csv")

hillenbrand_man_i <- subset(hillenbrand, speaker_type == "man" & vowel == "i")
assert_true(nrow(hillenbrand_man_i) == 45L, "Adult-men /i/ subset changed")
write_output(
  hillenbrand_man_i[, c("speaker_id", "duration_ms", "f1_hz")],
  "hillenbrand-man-i-raw.csv"
)

duration_density <- stats::density(hillenbrand_man_i$duration_ms, from = 0)
duration_density_grid <- data.frame(
  duration_ms = duration_density$x,
  estimated_density = duration_density$y
)
write_output(duration_density_grid, "hillenbrand-man-i-duration-density.csv")

duration_midpoint <- unname(stats::median(hillenbrand_man_i$duration_ms))
duration_interval <- duration_midpoint + c(-0.5, 0.5)
duration_dx <- duration_density_grid$duration_ms[[2L]] - duration_density_grid$duration_ms[[1L]]
duration_area <- sum(duration_density_grid$estimated_density) * duration_dx
duration_interval_probability <- sum(
  duration_density_grid$estimated_density[
    duration_density_grid$duration_ms >= duration_interval[[1L]] &
      duration_density_grid$duration_ms <= duration_interval[[2L]]
  ]
) * duration_dx
duration_density_summary <- data.frame(
  subset = "adult men producing /i/",
  n_speakers = nrow(hillenbrand_man_i),
  recorded_duration_median_ms = duration_midpoint,
  empirical_mass_at_recorded_median = mean(hillenbrand_man_i$duration_ms == duration_midpoint),
  continuous_model_point_probability = 0,
  one_ms_interval_lower = duration_interval[[1L]],
  one_ms_interval_upper = duration_interval[[2L]],
  kde_probability_over_one_ms_interval = duration_interval_probability,
  kde_numeric_integral_over_grid = duration_area,
  kde_bandwidth_ms = duration_density$bw
)
write_output(duration_density_summary, "hillenbrand-man-i-duration-density-summary.csv")

p_duration <- ggplot2::ggplot(hillenbrand_man_i, ggplot2::aes(duration_ms)) +
  ggplot2::geom_rug(color = "grey45", sides = "b", alpha = 0.75) +
  ggplot2::geom_line(
    data = duration_density_grid,
    ggplot2::aes(duration_ms, estimated_density),
    color = "#8B1A1A",
    linewidth = 0.9,
    inherit.aes = FALSE
  ) +
  ggplot2::labs(x = "Adult men's /i/ duration (ms)", y = "Estimated density") +
  theme_notes
save_plot(p_duration, "hillenbrand-duration-density.png")

hillenbrand_cdf <- rbind(
  empirical_cdf(hillenbrand_man_i$duration_ms, "Hillenbrand adult men /i/", "duration_ms"),
  empirical_cdf(hillenbrand_man_i$f1_hz, "Hillenbrand adult men /i/", "f1_hz")
)
write_output(hillenbrand_cdf, "hillenbrand-duration-f1-ecdf.csv")

p_hillenbrand_cdf <- ggplot2::ggplot(
  hillenbrand_cdf,
  ggplot2::aes(value, cumulative_probability)
) +
  ggplot2::geom_step(color = "grey25", linewidth = 0.75) +
  ggplot2::facet_wrap(~variable, scales = "free_x", ncol = 1) +
  ggplot2::labs(x = "Recorded measurement", y = "Empirical cumulative probability") +
  theme_notes
save_plot(p_hillenbrand_cdf, "hillenbrand-duration-f1-ecdf.png", height = 5.4)

normal_mean <- mean(hillenbrand_man_i$f1_hz)
normal_sd_mle <- sqrt(mean((hillenbrand_man_i$f1_hz - normal_mean)^2))
normal_grid <- data.frame(
  f1_hz = seq(min(hillenbrand_man_i$f1_hz) - 20, max(hillenbrand_man_i$f1_hz) + 20, length.out = 500L)
)
normal_grid$density <- stats::dnorm(normal_grid$f1_hz, normal_mean, normal_sd_mle)
write_output(normal_grid, "hillenbrand-normal-fit-grid.csv")
normal_ecdf <- stats::ecdf(hillenbrand_man_i$f1_hz)
normal_fit_summary <- data.frame(
  subset = "adult men producing /i/",
  n_speakers = nrow(hillenbrand_man_i),
  f1_mean_hz_mle = normal_mean,
  f1_sd_hz_mle = normal_sd_mle,
  f1_sd_hz_unbiased_sample = stats::sd(hillenbrand_man_i$f1_hz),
  empirical_cdf_sup_distance = max(abs(
    normal_ecdf(sort(unique(hillenbrand_man_i$f1_hz))) -
      stats::pnorm(sort(unique(hillenbrand_man_i$f1_hz)), normal_mean, normal_sd_mle)
  ))
)
write_output(normal_fit_summary, "hillenbrand-normal-fit-summary.csv")

normal_fit_by_group <- do.call(rbind, lapply(
  split(subset(hillenbrand, vowel == "i"), subset(hillenbrand, vowel == "i")$speaker_type),
  function(x) {
    mu <- mean(x$f1_hz)
    sigma <- sqrt(mean((x$f1_hz - mu)^2))
    data.frame(
      speaker_type = x$speaker_type[[1L]],
      n_speakers = nrow(x),
      f1_mean_hz_mle = mu,
      f1_sd_hz_mle = sigma,
      degrees_of_freedom_for_variance_reference = nrow(x) - 1L
    )
  }
))
row.names(normal_fit_by_group) <- NULL
write_output(normal_fit_by_group, "hillenbrand-normal-fits-by-speaker-type.csv")

normal_group_grid <- do.call(rbind, lapply(split(subset(hillenbrand, vowel == "i"),
                                                   subset(hillenbrand, vowel == "i")$speaker_type), function(x) {
  mu <- mean(x$f1_hz)
  sigma <- sqrt(mean((x$f1_hz - mu)^2))
  grid <- seq(min(x$f1_hz) - 20, max(x$f1_hz) + 20, length.out = 300L)
  data.frame(
    speaker_type = x$speaker_type[[1L]],
    f1_hz = grid,
    density = stats::dnorm(grid, mu, sigma)
  )
}))
write_output(normal_group_grid, "hillenbrand-normal-fits-by-speaker-type-grid.csv")

p_normal_groups <- ggplot2::ggplot(
  subset(hillenbrand, vowel == "i"),
  ggplot2::aes(f1_hz)
) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    bins = 9,
    fill = "grey78",
    color = "white"
  ) +
  ggplot2::geom_line(
    data = normal_group_grid,
    ggplot2::aes(f1_hz, density),
    color = "#8B1A1A",
    linewidth = 0.8,
    inherit.aes = FALSE
  ) +
  ggplot2::facet_wrap(~speaker_type, scales = "free", ncol = 2) +
  ggplot2::labs(x = "/i/ F1 (Hz)", y = "Density") +
  theme_notes
save_plot(p_normal_groups, "hillenbrand-normal-fits-by-speaker-type.png", height = 5.2)

p_normal <- ggplot2::ggplot(hillenbrand_man_i, ggplot2::aes(f1_hz)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    bins = 10,
    fill = "grey75",
    color = "white"
  ) +
  ggplot2::geom_line(
    data = normal_grid,
    ggplot2::aes(f1_hz, density),
    color = "#8B1A1A",
    linewidth = 0.9,
    inherit.aes = FALSE
  ) +
  ggplot2::labs(x = "Adult men's /i/ F1 (Hz)", y = "Density") +
  theme_notes
save_plot(p_normal, "hillenbrand-normal-fit.png")

chisq_df <- nrow(hillenbrand_man_i) - 1L
chisq_grid <- data.frame(
  statistic = seq(0, stats::qchisq(0.999, df = chisq_df), length.out = 500L)
)
chisq_grid$density <- stats::dchisq(chisq_grid$statistic, df = chisq_df)
write_output(chisq_grid, "hillenbrand-chi-square-reference-grid.csv")
chisq_summary <- data.frame(
  source_subset = "adult men producing /i/",
  n_speakers = nrow(hillenbrand_man_i),
  degrees_of_freedom = chisq_df,
  reference_mean = chisq_df,
  reference_variance = 2 * chisq_df,
  lower_0.025 = stats::qchisq(0.025, df = chisq_df),
  upper_0.975 = stats::qchisq(0.975, df = chisq_df),
  interpretation = "reference for (n-1) S^2 / sigma^2 only under independent normal sampling"
)
write_output(chisq_summary, "hillenbrand-chi-square-reference-summary.csv")

p_chisq <- ggplot2::ggplot(chisq_grid, ggplot2::aes(statistic, density)) +
  ggplot2::geom_line(color = "grey25", linewidth = 0.9) +
  ggplot2::geom_vline(xintercept = chisq_df, color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::labs(x = expression(chi^2), y = "Reference density") +
  theme_notes
save_plot(p_chisq, "hillenbrand-chi-square-reference.png")

chisq_group_grid <- do.call(rbind, lapply(seq_len(nrow(normal_fit_by_group)), function(i) {
  df <- normal_fit_by_group$degrees_of_freedom_for_variance_reference[[i]]
  x <- seq(0, stats::qchisq(0.999, df = df), length.out = 400L)
  data.frame(
    speaker_type = normal_fit_by_group$speaker_type[[i]],
    degrees_of_freedom = df,
    statistic = x,
    density = stats::dchisq(x, df = df)
  )
}))
write_output(chisq_group_grid, "hillenbrand-chi-square-reference-by-speaker-type.csv")

p_chisq_groups <- ggplot2::ggplot(
  chisq_group_grid,
  ggplot2::aes(statistic, density, color = speaker_type)
) +
  ggplot2::geom_line(linewidth = 0.75) +
  ggplot2::scale_color_grey(start = 0.2, end = 0.7) +
  ggplot2::labs(x = expression(chi^2), y = "Reference density") +
  theme_notes
save_plot(p_chisq_groups, "hillenbrand-chi-square-reference-by-speaker-type.png")

hillenbrand_f1_wide <- reshape(
  hillenbrand[, c("speaker_id", "speaker_type", "vowel", "f1_hz")],
  idvar = c("speaker_id", "speaker_type"),
  timevar = "vowel",
  direction = "wide"
)
hillenbrand_f1_wide$f1_difference_ae_minus_i_hz <-
  hillenbrand_f1_wide[["f1_hz.{"]] - hillenbrand_f1_wide[["f1_hz.i"]]
paired_difference <- hillenbrand_f1_wide$f1_difference_ae_minus_i_hz
paired_n <- length(paired_difference)
paired_mean <- mean(paired_difference)
paired_sd <- stats::sd(paired_difference)
paired_se <- paired_sd / sqrt(paired_n)
paired_t <- paired_mean / paired_se
paired_df <- paired_n - 1L
paired_p <- 2 * stats::pt(abs(paired_t), df = paired_df, lower.tail = FALSE)
paired_summary <- data.frame(
  contrast = "F1(/ae/ in had) - F1(/i/ in heed)",
  paired_unit = "speaker",
  n_speakers = paired_n,
  mean_difference_hz = paired_mean,
  standard_deviation_hz = paired_sd,
  standard_error_hz = paired_se,
  t_statistic_against_zero = paired_t,
  degrees_of_freedom = paired_df,
  two_sided_p_value = paired_p
)
write_output(paired_summary, "hillenbrand-paired-f1-summary.csv")
write_output(
  hillenbrand_f1_wide[, c("speaker_id", "speaker_type", "f1_hz.{", "f1_hz.i", "f1_difference_ae_minus_i_hz")],
  "hillenbrand-paired-f1-raw.csv"
)

t_grid <- data.frame(t = seq(-max(5, abs(paired_t) * 1.05), max(5, abs(paired_t) * 1.05), length.out = 1000L))
t_grid$density <- stats::dt(t_grid$t, df = paired_df)
write_output(t_grid, "hillenbrand-student-t-reference-grid.csv")

p_paired <- ggplot2::ggplot(
  hillenbrand_f1_wide,
  ggplot2::aes(f1_difference_ae_minus_i_hz)
) +
  ggplot2::geom_histogram(bins = 18, fill = "grey75", color = "white") +
  ggplot2::geom_vline(xintercept = 0, color = "grey25", linetype = 2) +
  ggplot2::geom_vline(xintercept = paired_mean, color = "#8B1A1A", linewidth = 0.8) +
  ggplot2::labs(x = "Within-speaker F1 difference: /ae/ minus /i/ (Hz)", y = "Speakers") +
  theme_notes
save_plot(p_paired, "hillenbrand-paired-f1.png")

p_t <- ggplot2::ggplot(t_grid, ggplot2::aes(t, density)) +
  ggplot2::geom_line(color = "grey25", linewidth = 0.9) +
  ggplot2::geom_vline(xintercept = c(-paired_t, paired_t), color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::labs(x = paste0("t statistic (df = ", paired_df, ")"), y = "Reference density") +
  theme_notes
save_plot(p_t, "hillenbrand-student-t-reference.png")

t_group_grid <- do.call(rbind, lapply(seq_len(nrow(normal_fit_by_group)), function(i) {
  df <- normal_fit_by_group$degrees_of_freedom_for_variance_reference[[i]]
  x <- seq(-4, 4, length.out = 500L)
  data.frame(
    speaker_type = normal_fit_by_group$speaker_type[[i]],
    degrees_of_freedom = df,
    t = x,
    density = stats::dt(x, df = df)
  )
}))
t_group_grid <- rbind(
  t_group_grid,
  data.frame(
    speaker_type = "all paired speakers",
    degrees_of_freedom = paired_df,
    t = seq(-4, 4, length.out = 500L),
    density = stats::dt(seq(-4, 4, length.out = 500L), df = paired_df)
  )
)
write_output(t_group_grid, "hillenbrand-student-t-reference-by-sample-size.csv")

p_t_groups <- ggplot2::ggplot(
  t_group_grid,
  ggplot2::aes(t, density, color = factor(degrees_of_freedom))
) +
  ggplot2::geom_line(linewidth = 0.75) +
  ggplot2::scale_color_grey(start = 0.15, end = 0.75) +
  ggplot2::labs(x = "t", y = "Reference density", color = "Degrees of freedom") +
  theme_notes
save_plot(p_t_groups, "hillenbrand-student-t-reference-by-sample-size.png")

# -----------------------------------------------------------------------------
# UD Turkish BOUN: categorical/Bernoulli/binomial objects and inverse sampling
# -----------------------------------------------------------------------------

ud_lemma_counts <- as.data.frame(table(ud_question$lemma), responseName = "count")
names(ud_lemma_counts)[[1L]] <- "category"
ud_lemma_counts$variable <- "interrogative lemma"
ud_lemma_counts$probability <- ud_lemma_counts$count / sum(ud_lemma_counts$count)

ud_relation_counts <- as.data.frame(table(ud_question$dependency_relation), responseName = "count")
names(ud_relation_counts)[[1L]] <- "category"
ud_relation_counts$variable <- "dependency relation"
ud_relation_counts$probability <- ud_relation_counts$count / sum(ud_relation_counts$count)

ud_question_pmfs <- rbind(ud_lemma_counts, ud_relation_counts)
ud_question_pmfs <- ud_question_pmfs[, c("variable", "category", "count", "probability")]
write_output(ud_question_pmfs, "ud-turkish-question-pmfs.csv")

ud_joint <- as.data.frame(table(
  lemma = ud_question$lemma,
  dependency_relation = ud_question$dependency_relation
), responseName = "count")
ud_joint$probability <- ud_joint$count / nrow(ud_question)
write_output(ud_joint, "ud-turkish-question-joint-pmf.csv")
assert_true(identical(as.integer(ud_joint$count), c(2L, 14L, 35L, 1L, 3L, 112L)),
            "UD Turkish question table changed")

object_probability <- mean(ud_question$object)
ud_bernoulli <- data.frame(
  response = "object dependency relation",
  n_tokens = nrow(ud_question),
  successes = sum(ud_question$object),
  fitted_probability = object_probability,
  expectation = object_probability,
  variance = object_probability * (1 - object_probability),
  population_variance_of_indicator = population_variance(ud_question$object)
)
write_output(ud_bernoulli, "ud-turkish-question-bernoulli-summary.csv")

ud_binomial <- data.frame(object_count = 0:nrow(ud_question))
ud_binomial$fitted_probability <- stats::dbinom(
  ud_binomial$object_count,
  size = nrow(ud_question),
  prob = object_probability
)
write_output(ud_binomial, "ud-turkish-question-binomial-reference.csv")
ud_binomial_summary <- data.frame(
  reference_model = "independent Bernoulli trials with plug-in corpus probability",
  n_opportunities = nrow(ud_question),
  fitted_probability = object_probability,
  observed_object_count = sum(ud_question$object),
  fitted_expectation = nrow(ud_question) * object_probability,
  fitted_variance = nrow(ud_question) * object_probability * (1 - object_probability),
  dependence_warning = "tokens are nested in sentences; the binomial is a reference model, not the treebank sampling design"
)
write_output(ud_binomial_summary, "ud-turkish-question-binomial-summary.csv")

p_ud <- ggplot2::ggplot(ud_question_pmfs, ggplot2::aes(category, probability)) +
  ggplot2::geom_col(fill = "grey45", width = 0.72) +
  ggplot2::facet_wrap(~variable, scales = "free_x", ncol = 1) +
  ggplot2::labs(x = NULL, y = "Empirical probability") +
  theme_notes
save_plot(p_ud, "ud-turkish-question-pmfs.png", height = 5.2)

p_binomial <- ggplot2::ggplot(ud_binomial, ggplot2::aes(object_count, fitted_probability)) +
  ggplot2::geom_col(fill = "grey70", width = 0.9) +
  ggplot2::geom_vline(xintercept = sum(ud_question$object), color = "#8B1A1A", linewidth = 0.8) +
  ggplot2::labs(x = "Object-relation tokens in 167 opportunities", y = "Binomial reference probability") +
  theme_notes
save_plot(p_binomial, "ud-turkish-question-binomial-reference.png")

inverse_categories <- ud_lemma_counts$category
inverse_probabilities <- ud_lemma_counts$probability
inverse_cumulative <- cumsum(inverse_probabilities)
inverse_cutpoints <- data.frame(
  category = inverse_categories,
  lower = c(0, head(inverse_cumulative, -1L)),
  upper = inverse_cumulative,
  empirical_probability = inverse_probabilities
)
write_output(inverse_cutpoints, "ud-turkish-inverse-transform-cutpoints.csv")

inverse_sample <- function(n, seed) {
  set.seed(seed)
  uniforms <- stats::runif(n)
  sampled_index <- findInterval(uniforms, vec = c(0, inverse_cumulative), rightmost.closed = TRUE)
  sampled_index[sampled_index > length(inverse_categories)] <- length(inverse_categories)
  data.frame(draw = seq_len(n), uniform = uniforms, category = inverse_categories[sampled_index])
}

inverse_n <- 10000L
inverse_seed <- 20261018L
inverse_draws <- inverse_sample(inverse_n, inverse_seed)
inverse_summary <- merge(
  ud_lemma_counts[, c("category", "probability")],
  as.data.frame(table(inverse_draws$category), responseName = "sampled_count"),
  by.x = "category",
  by.y = "Var1",
  all = TRUE
)
names(inverse_summary)[names(inverse_summary) == "probability"] <- "target_probability"
inverse_summary$sampled_proportion <- inverse_summary$sampled_count / inverse_n
inverse_summary$absolute_error <- abs(inverse_summary$sampled_proportion - inverse_summary$target_probability)
inverse_summary$seed <- inverse_seed
inverse_summary$n_draws <- inverse_n
write_output(inverse_summary, "ud-turkish-inverse-transform-summary.csv")
write_output(utils::head(inverse_draws, 20L), "ud-turkish-inverse-transform-first-20.csv")

repeat_a <- inverse_sample(250L, inverse_seed)$category
repeat_b <- inverse_sample(250L, inverse_seed)$category
different_seed <- inverse_sample(250L, inverse_seed + 1L)$category
seed_check <- data.frame(
  comparison = c("same seed, same procedure", "different seed, same procedure"),
  n_draws = 250L,
  identical_sequence = c(identical(repeat_a, repeat_b), identical(repeat_a, different_seed)),
  seed_a = inverse_seed,
  seed_b = c(inverse_seed, inverse_seed + 1L)
)
write_output(seed_check, "ud-turkish-seed-check.csv")
assert_true(seed_check$identical_sequence[[1L]], "Repeated seed did not reproduce the sequence")
assert_true(!seed_check$identical_sequence[[2L]], "Different seeds unexpectedly reproduced the sequence")

# -----------------------------------------------------------------------------
# Turkish UniMorph: finite-population hypergeometric reference
# -----------------------------------------------------------------------------

N_unimorph <- nrow(unimorph_population)
K_unimorph <- sum(unimorph_population$t_initial)
n_unimorph <- nrow(unimorph_sample)
x_unimorph <- sum(unimorph_sample$t_initial)
assert_true(K_unimorph == 200L && x_unimorph == 42L, "UniMorph t-initial counts changed")

hyper_lower <- max(0L, n_unimorph - (N_unimorph - K_unimorph))
hyper_upper <- min(n_unimorph, K_unimorph)
hyper_grid <- data.frame(t_initial_count = hyper_lower:hyper_upper)
hyper_grid$hypergeometric_probability <- stats::dhyper(
  hyper_grid$t_initial_count,
  m = K_unimorph,
  n = N_unimorph - K_unimorph,
  k = n_unimorph
)
hyper_grid$binomial_probability <- stats::dbinom(
  hyper_grid$t_initial_count,
  size = n_unimorph,
  prob = K_unimorph / N_unimorph
)
write_output(hyper_grid, "unimorph-turkish-hypergeometric-reference.csv")

hyper_mean <- n_unimorph * K_unimorph / N_unimorph
hyper_variance <- n_unimorph * (K_unimorph / N_unimorph) * (1 - K_unimorph / N_unimorph) *
  (N_unimorph - n_unimorph) / (N_unimorph - 1)
binomial_variance <- n_unimorph * (K_unimorph / N_unimorph) * (1 - K_unimorph / N_unimorph)
hyper_summary <- data.frame(
  population_size = N_unimorph,
  t_initial_population_count = K_unimorph,
  sample_size = n_unimorph,
  observed_t_initial_sample_count = x_unimorph,
  population_proportion = K_unimorph / N_unimorph,
  hypergeometric_expectation = hyper_mean,
  hypergeometric_variance = hyper_variance,
  binomial_reference_variance = binomial_variance,
  finite_population_correction = (N_unimorph - n_unimorph) / (N_unimorph - 1),
  hypergeometric_probability_of_observed_count = stats::dhyper(
    x_unimorph, K_unimorph, N_unimorph - K_unimorph, n_unimorph
  ),
  binomial_probability_of_observed_count = stats::dbinom(
    x_unimorph, n_unimorph, K_unimorph / N_unimorph
  )
)
write_output(hyper_summary, "unimorph-turkish-hypergeometric-summary.csv")

hyper_long <- rbind(
  data.frame(
    t_initial_count = hyper_grid$t_initial_count,
    probability = hyper_grid$hypergeometric_probability,
    model = "without replacement"
  ),
  data.frame(
    t_initial_count = hyper_grid$t_initial_count,
    probability = hyper_grid$binomial_probability,
    model = "independent-draw reference"
  )
)
p_hyper <- ggplot2::ggplot(
  hyper_long,
  ggplot2::aes(t_initial_count, probability, color = model, linetype = model)
) +
  ggplot2::geom_line(linewidth = 0.85) +
  ggplot2::geom_vline(xintercept = x_unimorph, color = "grey25", linewidth = 0.6) +
  ggplot2::scale_color_manual(values = c("without replacement" = "#8B1A1A", "independent-draw reference" = "grey45")) +
  ggplot2::labs(x = "t-initial past-tense forms in the sample", y = "Probability") +
  theme_notes
save_plot(p_hyper, "unimorph-turkish-hypergeometric.png")

# -----------------------------------------------------------------------------
# English datives: Poisson, joint/conditional probability, covariance/correlation
# -----------------------------------------------------------------------------

dative$recipient_words_beyond_first <- dative$recipient_length_words - 1L
assert_true(all(dative$recipient_words_beyond_first >= 0L), "Dative count transformation became negative")
poisson_lambda <- mean(dative$recipient_words_beyond_first)
dative_count_pmf <- empirical_pmf(dative$recipient_words_beyond_first, "recipient_words_beyond_first")
dative_poisson <- data.frame(value = 0:max(dative$recipient_words_beyond_first))
dative_poisson <- merge(dative_poisson, dative_count_pmf[, c("value", "count", "probability")], by = "value", all.x = TRUE)
dative_poisson$count[is.na(dative_poisson$count)] <- 0L
dative_poisson$probability[is.na(dative_poisson$probability)] <- 0
dative_poisson$fitted_probability <- stats::dpois(dative_poisson$value, lambda = poisson_lambda)
write_output(dative_poisson, "dative-poisson-fit.csv")
dative_poisson_summary <- data.frame(
  response = "recipient length in words minus one",
  n_tokens = nrow(dative),
  fitted_lambda = poisson_lambda,
  empirical_mean = mean(dative$recipient_words_beyond_first),
  empirical_variance_population = population_variance(dative$recipient_words_beyond_first),
  empirical_variance_sample = stats::var(dative$recipient_words_beyond_first),
  variance_to_mean_ratio_population = population_variance(dative$recipient_words_beyond_first) / poisson_lambda,
  observed_zero_proportion = mean(dative$recipient_words_beyond_first == 0L),
  fitted_zero_probability = stats::dpois(0, poisson_lambda),
  fitted_probability_above_observed_maximum = stats::ppois(
    max(dative$recipient_words_beyond_first), poisson_lambda, lower.tail = FALSE
  ),
  empirical_third_quartile = unname(stats::quantile(dative$recipient_words_beyond_first, 0.75, type = 1)),
  fitted_point_probability_at_empirical_third_quartile = stats::dpois(
    unname(stats::quantile(dative$recipient_words_beyond_first, 0.75, type = 1)), poisson_lambda
  ),
  fitted_cdf_at_empirical_third_quartile = stats::ppois(
    unname(stats::quantile(dative$recipient_words_beyond_first, 0.75, type = 1)), poisson_lambda
  ),
  fitted_ninetieth_percentile = stats::qpois(0.9, poisson_lambda)
)
write_output(dative_poisson_summary, "dative-poisson-summary.csv")

p_poisson <- ggplot2::ggplot(dative_poisson, ggplot2::aes(value)) +
  ggplot2::geom_col(ggplot2::aes(y = probability), fill = "grey72", width = 0.8) +
  ggplot2::geom_point(ggplot2::aes(y = fitted_probability), color = "#8B1A1A", size = 1.8) +
  ggplot2::geom_line(ggplot2::aes(y = fitted_probability), color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::labs(x = "Recipient words beyond the first", y = "Probability") +
  theme_notes
save_plot(p_poisson, "dative-poisson-fit.png")

dative_joint <- as.data.frame(table(
  recipient_length_words = dative$recipient_length_words,
  theme_length_words = dative$theme_length_words
), responseName = "count")
dative_joint$recipient_length_words <- as.numeric(as.character(dative_joint$recipient_length_words))
dative_joint$theme_length_words <- as.numeric(as.character(dative_joint$theme_length_words))
dative_joint$probability <- dative_joint$count / nrow(dative)
dative_joint <- dative_joint[dative_joint$count > 0L, ]
write_output(dative_joint, "dative-joint-length-pmf.csv")
assert_true(abs(sum(dative_joint$probability) - 1) < 1e-12, "Dative joint PMF does not sum to one")

dative_recipient_margin <- aggregate(
  cbind(count, probability) ~ recipient_length_words,
  data = dative_joint,
  FUN = sum
)
dative_recipient_margin$margin <- "recipient length"
names(dative_recipient_margin)[names(dative_recipient_margin) == "recipient_length_words"] <- "value"
dative_theme_margin <- aggregate(
  cbind(count, probability) ~ theme_length_words,
  data = dative_joint,
  FUN = sum
)
dative_theme_margin$margin <- "theme length"
names(dative_theme_margin)[names(dative_theme_margin) == "theme_length_words"] <- "value"
dative_margins <- rbind(dative_recipient_margin, dative_theme_margin)
dative_margins <- dative_margins[, c("margin", "value", "count", "probability")]
write_output(dative_margins, "dative-length-marginal-pmfs.csv")

dative_conditional_expectation <- aggregate(
  recipient_length_words ~ recipient_realization,
  data = dative,
  FUN = function(x) c(n = length(x), expectation = mean(x))
)
dative_conditional_expectation <- data.frame(
  recipient_realization = dative_conditional_expectation$recipient_realization,
  n = dative_conditional_expectation$recipient_length_words[, "n"],
  conditional_expectation_words = dative_conditional_expectation$recipient_length_words[, "expectation"]
)
dative_conditional_expectation$realization_probability <-
  dative_conditional_expectation$n / sum(dative_conditional_expectation$n)
dative_conditional_expectation$mixture_contribution <-
  dative_conditional_expectation$realization_probability *
  dative_conditional_expectation$conditional_expectation_words
write_output(dative_conditional_expectation, "dative-conditional-expectation.csv")
assert_true(abs(sum(dative_conditional_expectation$mixture_contribution) - mean(dative$recipient_length_words)) < 1e-12,
            "Dative law of total expectation failed")

conditional_independence_rows <- do.call(rbind, lapply(split(dative, dative$modality), function(z) {
  observed <- table(z$recipient_pronominality, z$recipient_realization)
  expected <- outer(rowSums(observed), colSums(observed)) / sum(observed)
  out <- expand.grid(
    recipient_pronominality = rownames(observed),
    recipient_realization = colnames(observed),
    stringsAsFactors = FALSE
  )
  out$observed_count <- as.numeric(observed)
  out$expected_count_under_conditional_independence <- as.numeric(expected)
  out$modality <- z$modality[[1L]]
  out$pearson_contribution <-
    (out$observed_count - out$expected_count_under_conditional_independence)^2 /
    out$expected_count_under_conditional_independence
  out
}))
row.names(conditional_independence_rows) <- NULL
write_output(conditional_independence_rows, "dative-conditional-independence-cells.csv")

conditional_independence_summary <- aggregate(
  pearson_contribution ~ modality,
  data = conditional_independence_rows,
  FUN = sum
)
names(conditional_independence_summary)[[2L]] <- "pearson_chisq"
conditional_independence_summary$degrees_of_freedom <- 1L
conditional_independence_summary$p_value <- stats::pchisq(
  conditional_independence_summary$pearson_chisq,
  df = conditional_independence_summary$degrees_of_freedom,
  lower.tail = FALSE
)
conditional_independence_summary$claim <-
  "recipient realization and recipient pronominality are not conditionally independent within modality"
write_output(conditional_independence_summary, "dative-conditional-independence-summary.csv")

dative_covariance <- population_covariance(dative$recipient_length_words, dative$theme_length_words)
dative_correlation <- dative_covariance /
  sqrt(population_variance(dative$recipient_length_words) * population_variance(dative$theme_length_words))
dative_association_summary <- data.frame(
  x = "recipient_length_words",
  y = "theme_length_words",
  n_tokens = nrow(dative),
  expectation_x = mean(dative$recipient_length_words),
  expectation_y = mean(dative$theme_length_words),
  variance_x_population = population_variance(dative$recipient_length_words),
  variance_y_population = population_variance(dative$theme_length_words),
  covariance_population = dative_covariance,
  standard_deviation_x_population = sqrt(population_variance(dative$recipient_length_words)),
  standard_deviation_y_population = sqrt(population_variance(dative$theme_length_words)),
  correlation = dative_correlation,
  covariance_sample = stats::cov(dative$recipient_length_words, dative$theme_length_words),
  correlation_from_R = stats::cor(dative$recipient_length_words, dative$theme_length_words)
)
write_output(dative_association_summary, "dative-length-covariance-correlation.csv")
assert_true(abs(dative_correlation - stats::cor(dative$recipient_length_words, dative$theme_length_words)) < 1e-12,
            "Population-standardized correlation does not match R cor")

p_joint <- ggplot2::ggplot(
  dative_joint,
  ggplot2::aes(theme_length_words, recipient_length_words, size = count)
) +
  ggplot2::geom_point(color = "grey30", alpha = 0.65) +
  ggplot2::scale_size_area(max_size = 7) +
  ggplot2::labs(x = "Theme length (words)", y = "Recipient length (words)", size = "Token count") +
  theme_notes +
  ggplot2::theme(legend.position = "right")
save_plot(p_joint, "dative-joint-lengths.png")

conditional_plot <- aggregate(
  recipient_realization == "NP" ~ modality + recipient_pronominality,
  data = dative,
  FUN = mean
)
names(conditional_plot)[[3L]] <- "np_proportion"
p_conditional <- ggplot2::ggplot(
  conditional_plot,
  ggplot2::aes(recipient_pronominality, np_proportion, group = modality, color = modality)
) +
  ggplot2::geom_point(size = 2) +
  ggplot2::geom_line(linewidth = 0.7) +
  ggplot2::scale_color_manual(values = c("spoken" = "grey25", "written" = "#8B1A1A")) +
  ggplot2::labs(x = "Recipient pronominality", y = "Observed NP-recipient proportion") +
  theme_notes
save_plot(p_conditional, "dative-conditional-realization.png")

# -----------------------------------------------------------------------------
# Provo: bounded uniform and beta references for model-derived cloze estimates
# -----------------------------------------------------------------------------

provo_probability <- provo$OrthoMatchModel
provo_mean <- mean(provo_probability)
provo_variance <- stats::var(provo_probability)
beta_concentration_start <- provo_mean * (1 - provo_mean) / provo_variance - 1
beta_start <- c(
  log(provo_mean * beta_concentration_start),
  log((1 - provo_mean) * beta_concentration_start)
)
beta_nll <- function(theta, x) {
  alpha <- exp(theta[[1L]])
  beta <- exp(theta[[2L]])
  -sum(stats::dbeta(x, shape1 = alpha, shape2 = beta, log = TRUE))
}
beta_fit <- stats::optim(beta_start, beta_nll, x = provo_probability, method = "BFGS", hessian = TRUE)
beta_alpha <- exp(beta_fit$par[[1L]])
beta_beta <- exp(beta_fit$par[[2L]])
assert_true(beta_fit$convergence == 0L, "Beta optimizer did not converge")
assert_true(beta_alpha > 0 && beta_beta > 0, "Beta fit returned invalid shape parameters")

provo_quartiles <- unname(stats::quantile(provo_probability, c(0.25, 0.75)))
provo_distribution_summary <- data.frame(
  variable = "OrthoMatchModel",
  source_definition = "fitted cloze values from a word-random-intercept logit mixed model in the Provo release",
  n_word_positions = length(provo_probability),
  n_passages = length(unique(provo$Text_ID)),
  observed_minimum = min(provo_probability),
  observed_maximum = max(provo_probability),
  empirical_mean = provo_mean,
  empirical_variance_sample = provo_variance,
  unit_interval_uniform_mean = 0.5,
  unit_interval_uniform_variance = 1 / 12,
  empirical_first_quartile = provo_quartiles[[1L]],
  empirical_third_quartile = provo_quartiles[[2L]],
  unit_interval_uniform_probability_between_empirical_quartiles = diff(provo_quartiles),
  beta_alpha_mle = beta_alpha,
  beta_beta_mle = beta_beta,
  beta_mean = beta_alpha / (beta_alpha + beta_beta),
  beta_variance = beta_alpha * beta_beta /
    ((beta_alpha + beta_beta)^2 * (beta_alpha + beta_beta + 1)),
  beta_log_likelihood = -beta_fit$value,
  uniform_0_1_log_likelihood = 0,
  beta_optimizer_convergence = beta_fit$convergence
)
write_output(provo_distribution_summary, "provo-uniform-beta-summary.csv")

fit_beta_group <- function(x, label) {
  group_mean <- mean(x)
  group_variance <- stats::var(x)
  concentration <- group_mean * (1 - group_mean) / group_variance - 1
  start <- c(log(group_mean * concentration), log((1 - group_mean) * concentration))
  fit <- stats::optim(start, beta_nll, x = x, method = "BFGS", hessian = TRUE)
  alpha <- exp(fit$par[[1L]])
  beta <- exp(fit$par[[2L]])
  data.frame(
    word_pos = label,
    n_word_positions = length(x),
    alpha_mle = alpha,
    beta_mle = beta,
    fitted_mean = alpha / (alpha + beta),
    fitted_concentration = alpha + beta,
    fitted_variance = alpha * beta / ((alpha + beta)^2 * (alpha + beta + 1)),
    optimizer_convergence = fit$convergence
  )
}
provo_beta_by_pos <- do.call(rbind, Map(
  fit_beta_group,
  split(provo_probability, provo$Word_POS),
  names(split(provo_probability, provo$Word_POS))
))
row.names(provo_beta_by_pos) <- NULL
assert_true(all(provo_beta_by_pos$optimizer_convergence == 0L), "A POS-specific beta fit failed")
write_output(provo_beta_by_pos, "provo-beta-fits-by-pos.csv")

provo_grid <- data.frame(probability = seq(0, 1, length.out = 500L))
provo_grid$uniform_density <- stats::dunif(provo_grid$probability, min = 0, max = 1)
provo_grid$beta_density <- stats::dbeta(provo_grid$probability, beta_alpha, beta_beta)
write_output(provo_grid, "provo-uniform-beta-grid.csv")

provo_fit_long <- rbind(
  data.frame(probability = provo_grid$probability, density = provo_grid$uniform_density, model = "Uniform(0, 1) reference"),
  data.frame(probability = provo_grid$probability, density = provo_grid$beta_density, model = "fitted beta")
)
p_provo <- ggplot2::ggplot(data.frame(probability = provo_probability), ggplot2::aes(probability)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    bins = 24,
    fill = "grey75",
    color = "white"
  ) +
  ggplot2::geom_line(
    data = provo_fit_long,
    ggplot2::aes(probability, density, color = model, linetype = model),
    linewidth = 0.85,
    inherit.aes = FALSE
  ) +
  ggplot2::scale_color_manual(values = c("Uniform(0, 1) reference" = "grey35", "fitted beta" = "#8B1A1A")) +
  ggplot2::labs(x = "Provo modeled orthographic predictability", y = "Density") +
  theme_notes
save_plot(p_provo, "provo-uniform-beta.png")

# -----------------------------------------------------------------------------
# Page-to-object registry and deterministic run metadata
# -----------------------------------------------------------------------------

page_registry <- data.frame(
  page = c(
    "why-random-variables.qmd", "defining-random-variables.qmd", "discrete-random-variables.qmd",
    "probability-mass-functions.qmd", "continuous-random-variables.qmd",
    "probability-density-functions.qmd", "cumulative-distribution-functions.qmd",
    "expected-values.qmd", "expectation-of-functions.qmd", "linearity-of-expectation.qmd",
    "variance-and-covariance.qmd", "standard-deviation.qmd", "central-moments.qmd",
    "when-expectations-fail.qmd", "bernoulli-and-categorical-distributions.qmd",
    "bernoulli-distribution.qmd", "binomial-distribution.qmd", "hypergeometric-distribution.qmd",
    "geometric-distribution.qmd", "negative-binomial-distribution.qmd", "poisson-distribution.qmd",
    "uniform-distribution.qmd", "beta-distribution.qmd", "normal-distribution.qmd",
    "chi-squared-distribution.qmd", "student-t-distribution.qmd",
    "inverse-transform-sampling.qmd", "random-seeds.qmd", "joint-probability.qmd",
    "marginal-distributions.qmd", "conditional-expectation.qmd", "conditional-independence.qmd",
    "covariance.qmd", "correlation.qmd"
  ),
  dataset = c(
    rep("CMUdict 0.7b", 4),
    rep("Hillenbrand et al. (1995)", 3),
    rep("CMUdict 0.7b", 7),
    rep("UD Turkish BOUN 2.18", 3),
    "Turkish UniMorph",
    rep("CMUdict 0.7b", 2),
    "English dative alternation",
    rep("Provo Corpus", 2),
    rep("Hillenbrand et al. (1995)", 3),
    rep("UD Turkish BOUN 2.18", 2),
    rep("English dative alternation", 6)
  ),
  primary_object = c(
    "pronunciation entry mapped to phone and vowel counts",
    "preimages of phone-count and vowel-count values",
    "finite observed support and resource-defined countable codomain",
    "empirical phone-count and vowel-count PMFs",
    "recorded duration versus a continuous duration model",
    "adult-men /i/ duration KDE with raw rug",
    "adult-men /i/ duration and F1 empirical CDFs",
    "empirical expectations of phone and vowel counts",
    "E[X^2] and E[log(1+X)] versus transformed E[X]",
    "E[phones] = E[vowels] + E[consonants]",
    "population variance decomposition for dependent component counts",
    "population SDs for phone and vowel counts",
    "first four central moments of phone and vowel counts",
    "Cauchy fit to phone count and simulated running means",
    "empirical categorical lemma PMF and binary object mapping",
    "object-relation indicator with corpus-fitted Bernoulli probability",
    "plug-in binomial reference for the observed opportunity count",
    "fixed seeded sample without replacement from the 588-lemma population",
    "consonants before the first vowel and a fitted geometric reference",
    "consonants before the third vowel and a size-three negative-binomial reference",
    "recipient words beyond the first and a fitted Poisson reference",
    "unit-interval reference for Provo model-derived cloze estimates",
    "beta MLE for Provo model-derived cloze estimates",
    "normal MLE for adult men's /i/ F1",
    "chi-square reference with df from the adult-men /i/ speaker count",
    "paired /ae/ minus /i/ F1 t reference over speakers",
    "inverse-CDF draws from the empirical Turkish interrogative-lemma PMF",
    "same-seed replication and different-seed variation for that PMF",
    "joint PMF of recipient and theme word lengths",
    "recipient- and theme-length marginal PMFs",
    "E[recipient length | realization] and the law of total expectation",
    "realization-pronominality tables within spoken and written modality",
    "population covariance of recipient and theme lengths",
    "standardized covariance of recipient and theme lengths"
  ),
  stringsAsFactors = FALSE
)
assert_true(nrow(page_registry) == 34L, "Page registry does not cover all 34 non-index pages")
write_output(page_registry, "page-object-registry.csv")

run_metadata <- data.frame(
  item = c(
    "analysis_date", "R_version", "inverse_transform_seed", "inverse_transform_draws",
    "cauchy_path_seed", "cauchy_path_replicates", "cauchy_path_sample_sizes",
    "plot_style", "problem_sets_modified"
  ),
  value = c(
    "2026-10-18",
    R.version.string,
    inverse_seed,
    inverse_n,
    20261018L,
    cauchy_path_replicates,
    paste(cauchy_path_sizes, collapse = ";"),
    "theme_classic; gray observations; one dark-red model accent; no internal prose annotations",
    "none"
  )
)
write_output(run_metadata, "run-metadata.csv")

message("Reference analysis completed: ", output_dir)
