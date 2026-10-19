#!/usr/bin/env Rscript

# Paper-first reference analysis for the frequentist half of
# statistical-inference/.
#
# This script reads only the committed, audited teaching extracts. It checks
# their frozen identities and schemas, computes every numerical object needed
# by the 19-page run, and writes restrained scientific figures. It does not
# edit a notes page, a teaching input, or a problem set.

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
  "research", "dataset-audits", "reference-inference-frequentist-output"
)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

assert_true <- function(condition, message) {
  if (!isTRUE(condition)) stop(message, call. = FALSE)
}

assert_close <- function(observed, expected, tolerance, message) {
  if (length(observed) != length(expected) ||
      any(!is.finite(observed)) ||
      any(abs(observed - expected) > tolerance)) {
    stop(message, call. = FALSE)
  }
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

ggplot_available <- requireNamespace("ggplot2", quietly = TRUE)
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
    "UD Turkish BOUN personal pronouns",
    "Hillenbrand et al. (1995)",
    "UCCA French-English 20K v2",
    "Turkish UniMorph population",
    "Turkish UniMorph sample"
  ),
  path = file.path(
    project_root,
    c(
      "data/ud-turkish-boun/personal-pronoun-cases.csv",
      "data/hillenbrand/vowels-complete.csv",
      "data/ucca-french-english/passage-counts.csv",
      "data/unimorph-turkish/verb-past-population.csv",
      "data/unimorph-turkish/verb-past-sample-120.csv"
    )
  ),
  expected_sha256 = c(
    "7ba0b69d2747f01a13960055ca46ff86af48841892b73065c2a3738bcf34eb07",
    "de3450982779fe3ac2e914974eb0ba6a7e0f778d7328f6dbb5d5ab5a58af22c9",
    "6cfcc7e88c874243b7b25f939c11d5787b2a4eef377d2dc8261fc35cea8abb20",
    "440ba51c27fd9b9db0366478dfbcf40ae50e7538e35ec0f8793d6231b9be76a4",
    "b5d293b2496290b567a86ee7c77ce33cee249c3a9a5c7c38f6a11a2dba28980e"
  ),
  stringsAsFactors = FALSE
)

assert_true(all(file.exists(input_specs$path)), "At least one frozen teaching input is missing")
input_specs$observed_sha256 <- vapply(input_specs$path, sha256, character(1))
input_specs$checksum_matches <- input_specs$observed_sha256 == input_specs$expected_sha256
assert_true(all(input_specs$checksum_matches), "At least one frozen teaching input checksum changed")
write_output(input_specs, "input-checksums.csv")

read_input <- function(label) {
  path <- input_specs$path[input_specs$dataset == label]
  utils::read.csv(path, check.names = FALSE)
}

ud <- read_input("UD Turkish BOUN personal pronouns")
hillenbrand <- read_input("Hillenbrand et al. (1995)")
ucca <- read_input("UCCA French-English 20K v2")
unimorph_population <- read_input("Turkish UniMorph population")
unimorph_sample <- read_input("Turkish UniMorph sample")

required_columns <- list(
  ud = c(
    "split", "register", "sentence_id", "token_id", "form", "lemma",
    "case", "person", "dependency_relation", "reflexive", "accusative"
  ),
  hillenbrand = c(
    "speaker_id", "speaker_type", "vowel", "duration_ms", "f0_hz",
    "f1_hz", "f2_hz", "f3_hz"
  ),
  ucca = c(
    "pair_id", "chapter", "pair_position_in_chapter", "language",
    "release_passage_id", "terminal_count", "word_count", "scene_count",
    "remote_edge_count", "implicit_node_count", "discontiguous_node_count"
  ),
  unimorph_population = c(
    "lemma", "form", "feature_bundle", "stem_final_voiceless",
    "vowel_class", "past_suffix", "past_initial", "t_initial"
  ),
  unimorph_sample = c(
    "lemma", "form", "feature_bundle", "stem_final_voiceless",
    "vowel_class", "past_suffix", "past_initial", "t_initial"
  )
)

data_objects <- list(
  ud = ud,
  hillenbrand = hillenbrand,
  ucca = ucca,
  unimorph_population = unimorph_population,
  unimorph_sample = unimorph_sample
)

for (name in names(required_columns)) {
  missing_columns <- setdiff(required_columns[[name]], names(data_objects[[name]]))
  assert_true(length(missing_columns) == 0L, paste(name, "is missing required columns"))
}

assert_true(nrow(ud) == 2128L, "UD personal-pronoun row count changed")
assert_true(length(unique(ud$sentence_id)) == 1727L, "UD sentence count changed")
assert_true(sum(ud$accusative) == 430L, "UD accusative count changed")
assert_true(setequal(unique(ud$case), c("Abl", "Acc", "Dat", "Equ", "Gen", "Ins", "Loc", "Nom")),
            "UD case inventory changed")

assert_true(nrow(hillenbrand) == 1668L, "Hillenbrand row count changed")
assert_true(length(unique(hillenbrand$speaker_id)) == 139L, "Hillenbrand speaker count changed")
assert_true(all(table(hillenbrand$speaker_id) == 12L), "Hillenbrand speaker-by-vowel design changed")
assert_true(setequal(unique(hillenbrand$speaker_type), c("boy", "girl", "man", "woman")),
            "Hillenbrand speaker types changed")

assert_true(nrow(ucca) == 308L, "UCCA row count changed")
assert_true(length(unique(ucca$pair_id)) == 154L, "UCCA pair count changed")
assert_true(setequal(unique(ucca$language), c("en", "fr")), "UCCA language set changed")
assert_true(all(table(ucca$pair_id) == 2L), "UCCA pairs are incomplete")
assert_true(sum(ucca$scene_count[ucca$language == "en"]) == 1839L,
            "UCCA English Scene count changed")
assert_true(sum(ucca$scene_count[ucca$language == "fr"]) == 2121L,
            "UCCA French Scene count changed")

assert_true(nrow(unimorph_population) == 588L, "UniMorph population row count changed")
assert_true(nrow(unimorph_sample) == 120L, "UniMorph sample row count changed")
assert_true(!anyDuplicated(unimorph_population$lemma), "UniMorph population lemmas are not unique")
assert_true(all(unimorph_sample$lemma %in% unimorph_population$lemma),
            "UniMorph sample is not a population subset")
assert_true(sum(unimorph_population$t_initial) == 200L, "UniMorph population t-initial count changed")
assert_true(sum(unimorph_sample$t_initial) == 42L, "UniMorph sample t-initial count changed")

package_status <- data.frame(
  package = c("base", "stats", "utils", "grDevices", "ggplot2"),
  available = c(TRUE, TRUE, TRUE, TRUE, ggplot_available),
  version = c(
    as.character(getRversion()),
    as.character(utils::packageVersion("stats")),
    as.character(utils::packageVersion("utils")),
    as.character(utils::packageVersion("grDevices")),
    as.character(utils::packageVersion("ggplot2"))
  )
)
write_output(package_status, "package-versions.csv")

dataset_validation <- data.frame(
  dataset = input_specs$dataset,
  rows = c(nrow(ud), nrow(hillenbrand), nrow(ucca), nrow(unimorph_population), nrow(unimorph_sample)),
  primary_units = c(
    length(unique(ud$sentence_id)),
    length(unique(hillenbrand$speaker_id)),
    length(unique(ucca$pair_id)),
    length(unique(unimorph_population$lemma)),
    length(unique(unimorph_sample$lemma))
  ),
  unit_identifier = c("sentence_id", "speaker_id", "pair_id", "lemma", "lemma"),
  stringsAsFactors = FALSE
)
write_output(dataset_validation, "dataset-validation.csv")

# -----------------------------------------------------------------------------
# UD Turkish BOUN: populations, Bernoulli likelihood, and sentence counts
# -----------------------------------------------------------------------------

ud_total_sentences <- 9761L
ud_sentence_counts_positive <- as.integer(table(ud$sentence_id))
ud_zero_sentence_count <- ud_total_sentences - length(ud_sentence_counts_positive)
assert_true(ud_zero_sentence_count == 8034L, "UD zero-pronoun sentence count changed")
ud_sentence_counts <- c(
  ud_sentence_counts_positive,
  rep.int(0L, ud_zero_sentence_count)
)
assert_true(length(ud_sentence_counts) == ud_total_sentences,
            "UD reconstructed sentence-count vector has the wrong length")
assert_true(sum(ud_sentence_counts) == nrow(ud),
            "UD reconstructed sentence counts do not recover the token total")

ud_case_counts <- as.data.frame(table(case = ud$case), responseName = "tokens")
ud_case_counts$proportion <- ud_case_counts$tokens / sum(ud_case_counts$tokens)
ud_case_counts <- ud_case_counts[order(-ud_case_counts$tokens), ]
write_output(ud_case_counts, "ud-case-counts.csv")

ud_register_counts <- aggregate(
  accusative ~ register,
  data = ud,
  FUN = function(x) c(successes = sum(x), tokens = length(x), proportion = mean(x))
)
ud_register_summary <- data.frame(
  register = ud_register_counts$register,
  accusative_tokens = ud_register_counts$accusative[, "successes"],
  personal_pronoun_tokens = ud_register_counts$accusative[, "tokens"],
  accusative_proportion = ud_register_counts$accusative[, "proportion"]
)
ud_register_summary$sentences_with_personal_pronoun <- as.integer(table(ud$register[!duplicated(ud$sentence_id)])[ud_register_summary$register])
write_output(ud_register_summary, "ud-register-accusative-proportions.csv")

ud_p_hat <- mean(ud$accusative)
ud_population_summary <- data.frame(
  object = c(
    "personal-pronoun token rows", "sentences represented by those tokens",
    "all BOUN sentences", "selected registers", "accusative token rows",
    "finite-release accusative proportion"
  ),
  value = c(
    nrow(ud), length(unique(ud$sentence_id)), ud_total_sentences,
    length(unique(ud$register)), sum(ud$accusative), ud_p_hat
  ),
  stringsAsFactors = FALSE
)
write_output(ud_population_summary, "ud-population-sample-summary.csv")

# Use an actual source-ordered subsequence. Its probability is evaluated under
# the fitted Bernoulli working model; no token probability is invented.
ud_sequence_n <- 12L
ud_sequence <- ud$accusative[seq_len(ud_sequence_n)]
ud_sequence_probability <- prod(
  ud_p_hat^ud_sequence * (1 - ud_p_hat)^(1 - ud_sequence)
)
ud_sequence_summary <- data.frame(
  position = seq_len(ud_sequence_n),
  sentence_id = ud$sentence_id[seq_len(ud_sequence_n)],
  form = ud$form[seq_len(ud_sequence_n)],
  case = ud$case[seq_len(ud_sequence_n)],
  accusative = ud_sequence,
  pooled_fitted_probability = ud_p_hat,
  stringsAsFactors = FALSE
)
write_output(ud_sequence_summary, "ud-observed-bernoulli-sequence.csv")
write_output(data.frame(
  n = ud_sequence_n,
  successes = sum(ud_sequence),
  failures = ud_sequence_n - sum(ud_sequence),
  pooled_fitted_probability = ud_p_hat,
  exact_ordered_sequence_probability = ud_sequence_probability,
  log_exact_ordered_sequence_probability = log(ud_sequence_probability)
), "ud-observed-bernoulli-sequence-summary.csv")

ud_n <- nrow(ud)
ud_k <- sum(ud$accusative)
ud_nll <- function(p) {
  if (!is.finite(p) || p <= 0 || p >= 1) return(.Machine$double.xmax)
  -(ud_k * log(p) + (ud_n - ud_k) * log1p(-p))
}
ud_numerical_mle <- stats::optimize(
  ud_nll,
  interval = c(1e-8, 1 - 1e-8),
  tol = .Machine$double.eps^0.5
)$minimum
assert_close(ud_numerical_mle, ud_p_hat, 1e-7, "UD analytic and numerical Bernoulli MLEs disagree")

ud_likelihood_grid <- data.frame(p = seq(0.12, 0.29, length.out = 500L))
ud_likelihood_grid$log_likelihood <- with(
  ud_likelihood_grid,
  ud_k * log(p) + (ud_n - ud_k) * log1p(-p)
)
ud_likelihood_grid$relative_log_likelihood <-
  ud_likelihood_grid$log_likelihood - max(ud_likelihood_grid$log_likelihood)
write_output(ud_likelihood_grid, "ud-bernoulli-likelihood-grid.csv")
write_output(data.frame(
  n_tokens = ud_n,
  accusative_tokens = ud_k,
  analytic_mle = ud_p_hat,
  numerical_mle = ud_numerical_mle,
  maximized_log_likelihood = -ud_nll(ud_p_hat),
  empirical_bernoulli_variance = ud_p_hat * (1 - ud_p_hat)
), "ud-bernoulli-mle-summary.csv")

p_ud_cases <- ggplot2::ggplot(
  ud_case_counts,
  ggplot2::aes(x = stats::reorder(case, tokens), y = tokens)
) +
  ggplot2::geom_col(fill = "grey45", width = 0.75) +
  ggplot2::coord_flip() +
  ggplot2::labs(x = "UD Case value", y = "Personal-pronoun tokens") +
  theme_notes
save_plot(p_ud_cases, "ud-case-counts.png")

p_ud_register <- ggplot2::ggplot(
  ud_register_summary,
  ggplot2::aes(register, accusative_proportion)
) +
  ggplot2::geom_hline(yintercept = ud_p_hat, color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::geom_point(ggplot2::aes(size = personal_pronoun_tokens), color = "grey25") +
  ggplot2::scale_size_area(max_size = 5) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  ggplot2::labs(
    x = "BOUN register",
    y = "Accusative proportion",
    size = "Tokens"
  ) +
  theme_notes +
  ggplot2::theme(legend.title = ggplot2::element_text())
save_plot(p_ud_register, "ud-accusative-by-register.png")

p_ud_likelihood <- ggplot2::ggplot(
  ud_likelihood_grid,
  ggplot2::aes(p, relative_log_likelihood)
) +
  ggplot2::geom_line(color = "grey25", linewidth = 0.85) +
  ggplot2::geom_vline(xintercept = ud_p_hat, color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::labs(
    x = "Shared accusative probability",
    y = "Log likelihood relative to its maximum"
  ) +
  theme_notes
save_plot(p_ud_likelihood, "ud-bernoulli-likelihood.png")

ud_lambda_hat <- mean(ud_sentence_counts)
ud_count_variance <- population_variance(ud_sentence_counts)
ud_count_max <- max(ud_sentence_counts)
ud_count_frequency <- data.frame(count = 0:ud_count_max)
ud_count_tab <- table(factor(ud_sentence_counts, levels = 0:ud_count_max))
ud_count_frequency$observed_sentences <- as.integer(ud_count_tab)
ud_count_frequency$observed_probability <- ud_count_frequency$observed_sentences / ud_total_sentences
ud_count_frequency$fitted_probability <- stats::dpois(ud_count_frequency$count, ud_lambda_hat)
ud_count_frequency$fitted_sentences <- ud_total_sentences * ud_count_frequency$fitted_probability
write_output(ud_count_frequency, "ud-sentence-pronoun-poisson-fit.csv")

ud_poisson_summary <- data.frame(
  sentences = ud_total_sentences,
  sentences_with_at_least_one_personal_pronoun = length(ud_sentence_counts_positive),
  sentences_with_zero_personal_pronouns = ud_zero_sentence_count,
  pronoun_tokens = sum(ud_sentence_counts),
  lambda_mle = ud_lambda_hat,
  empirical_population_variance = ud_count_variance,
  variance_to_mean_ratio = ud_count_variance / ud_lambda_hat,
  observed_zero_proportion = mean(ud_sentence_counts == 0),
  fitted_zero_probability = stats::dpois(0, ud_lambda_hat),
  observed_at_least_two_proportion = mean(ud_sentence_counts >= 2),
  fitted_at_least_two_probability = stats::ppois(1, ud_lambda_hat, lower.tail = FALSE)
)
write_output(ud_poisson_summary, "ud-sentence-pronoun-poisson-summary.csv")
assert_close(ud_lambda_hat, nrow(ud) / ud_total_sentences, 1e-15,
             "UD Poisson MLE does not equal the token total divided by sentences")

ud_poisson_long <- rbind(
  data.frame(
    count = ud_count_frequency$count,
    probability = ud_count_frequency$observed_probability,
    series = "Observed"
  ),
  data.frame(
    count = ud_count_frequency$count,
    probability = ud_count_frequency$fitted_probability,
    series = "Fitted Poisson"
  )
)
p_ud_poisson <- ggplot2::ggplot(
  ud_poisson_long,
  ggplot2::aes(count, probability, color = series, group = series)
) +
  ggplot2::geom_point(
    data = ud_poisson_long[ud_poisson_long$series == "Observed", ],
    size = 2.1
  ) +
  ggplot2::geom_line(
    data = ud_poisson_long[ud_poisson_long$series == "Fitted Poisson", ],
    linewidth = 0.8
  ) +
  ggplot2::scale_x_continuous(breaks = 0:ud_count_max) +
  ggplot2::scale_color_manual(values = c("Observed" = "grey25", "Fitted Poisson" = "#8B1A1A")) +
  ggplot2::labs(
    x = "Annotated personal pronouns per sentence",
    y = "Proportion of BOUN sentences"
  ) +
  theme_notes
save_plot(p_ud_poisson, "ud-sentence-pronoun-poisson-fit.png")

# -----------------------------------------------------------------------------
# Hillenbrand: empirical sampling references and elementary mean inference
# -----------------------------------------------------------------------------

speaker_type_counts <- unique(hillenbrand[c("speaker_id", "speaker_type")])
speaker_group_sizes <- as.data.frame(table(speaker_type = speaker_type_counts$speaker_type),
                                    responseName = "speakers")
write_output(speaker_group_sizes, "hillenbrand-speaker-group-sizes.csv")

women_hid <- hillenbrand[
  hillenbrand$speaker_type == "woman" & hillenbrand$vowel == "I",
  c("speaker_id", "speaker_type", "vowel", "duration_ms")
]
assert_true(nrow(women_hid) == 48L, "Hillenbrand adult-women /I/ subset changed")
assert_true(!anyDuplicated(women_hid$speaker_id), "Adult-women /I/ subset repeats a speaker")

duration_population <- women_hid$duration_ms
duration_target_mean <- mean(duration_population)
duration_target_median <- stats::median(duration_population)
duration_population_variance <- population_variance(duration_population)
duration_population_sd <- sqrt(duration_population_variance)

write_output(data.frame(
  subset = "adult women producing /I/ in hid",
  speakers = length(duration_population),
  empirical_mean_ms = duration_target_mean,
  empirical_median_ms = duration_target_median,
  empirical_population_variance_ms2 = duration_population_variance,
  empirical_population_sd_ms = duration_population_sd,
  minimum_ms = min(duration_population),
  maximum_ms = max(duration_population)
), "hillenbrand-women-hid-duration-summary.csv")

sampling_seed <- 20261018L
sampling_replicates <- 20000L
sampling_sizes <- sort(unique(speaker_group_sizes$speakers))
assert_true(identical(sampling_sizes, c(19L, 27L, 45L, 48L)),
            "Hillenbrand data-derived sample-size sequence changed")

set.seed(sampling_seed)
sampling_draws <- do.call(rbind, lapply(sampling_sizes, function(n) {
  estimates <- replicate(
    sampling_replicates,
    mean(sample(duration_population, size = n, replace = TRUE))
  )
  data.frame(sample_size = n, replicate = seq_len(sampling_replicates), estimate_ms = estimates)
}))

sampling_summary <- do.call(rbind, lapply(split(sampling_draws, sampling_draws$sample_size), function(x) {
  n <- x$sample_size[[1L]]
  data.frame(
    sample_size = n,
    replicates = nrow(x),
    target_mean_ms = duration_target_mean,
    simulated_mean_of_estimates_ms = mean(x$estimate_ms),
    simulated_standard_error_ms = stats::sd(x$estimate_ms),
    analytic_standard_error_ms = duration_population_sd / sqrt(n),
    simulated_bias_ms = mean(x$estimate_ms) - duration_target_mean
  )
}))
write_output(sampling_summary, "hillenbrand-sampling-standard-error-summary.csv")
assert_true(max(abs(sampling_summary$simulated_mean_of_estimates_ms - duration_target_mean)) < 0.25,
            "Hillenbrand sampling-distribution centers are unexpectedly far from the target")
assert_true(max(abs(
  sampling_summary$simulated_standard_error_ms - sampling_summary$analytic_standard_error_ms
)) < 0.15, "Hillenbrand simulated and analytic standard errors disagree")

sampling_display <- sampling_draws[sampling_draws$sample_size == max(sampling_sizes), ]
p_sampling <- ggplot2::ggplot(sampling_display, ggplot2::aes(estimate_ms)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    bins = 42,
    fill = "grey75",
    color = "white"
  ) +
  ggplot2::geom_vline(xintercept = duration_target_mean, color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::labs(
    x = "Mean /I/ duration in a 48-speaker resample (ms)",
    y = "Simulation density"
  ) +
  theme_notes
save_plot(p_sampling, "hillenbrand-sampling-distribution.png")

p_se <- ggplot2::ggplot(
  sampling_summary,
  ggplot2::aes(sample_size, analytic_standard_error_ms)
) +
  ggplot2::geom_line(color = "#8B1A1A", linewidth = 0.8) +
  ggplot2::geom_point(
    ggplot2::aes(y = simulated_standard_error_ms),
    color = "grey25",
    size = 2.2
  ) +
  ggplot2::scale_x_continuous(breaks = sampling_sizes) +
  ggplot2::labs(x = "Resampled speakers", y = "Standard error of mean duration (ms)") +
  theme_notes
save_plot(p_se, "hillenbrand-standard-errors.png")

bias_seed <- 20261019L
bias_replicates <- 20000L
bias_sample_size <- nrow(women_hid)
set.seed(bias_seed)
bias_samples <- replicate(
  bias_replicates,
  sample(duration_population, size = bias_sample_size, replace = TRUE),
  simplify = FALSE
)
bias_estimates <- data.frame(
  replicate = seq_len(bias_replicates),
  sample_mean = vapply(bias_samples, mean, numeric(1)),
  sample_median = vapply(bias_samples, stats::median, numeric(1))
)

estimator_summary <- do.call(rbind, lapply(c("sample_mean", "sample_median"), function(estimator) {
  estimates <- bias_estimates[[estimator]]
  estimator_bias <- mean(estimates) - duration_target_mean
  estimator_variance <- population_variance(estimates)
  estimator_mse <- mean((estimates - duration_target_mean)^2)
  data.frame(
    estimator = estimator,
    target = "empirical mean of adult-women /I/ duration",
    target_value_ms = duration_target_mean,
    sample_size = bias_sample_size,
    replicates = bias_replicates,
    expected_estimate_ms = mean(estimates),
    bias_ms = estimator_bias,
    sampling_variance_ms2 = estimator_variance,
    squared_bias_ms2 = estimator_bias^2,
    mse_ms2 = estimator_mse,
    decomposition_error_ms2 = estimator_mse - estimator_variance - estimator_bias^2
  )
}))
write_output(estimator_summary, "hillenbrand-bias-mse-summary.csv")
assert_true(max(abs(estimator_summary$decomposition_error_ms2)) < 1e-8,
            "Hillenbrand MSE decomposition failed")

bias_long <- rbind(
  data.frame(estimator = "Sample mean", estimate_ms = bias_estimates$sample_mean),
  data.frame(estimator = "Sample median", estimate_ms = bias_estimates$sample_median)
)
p_bias <- ggplot2::ggplot(bias_long, ggplot2::aes(estimate_ms)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    bins = 38,
    fill = "grey75",
    color = "white"
  ) +
  ggplot2::geom_vline(xintercept = duration_target_mean, color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::facet_wrap(~estimator, ncol = 1) +
  ggplot2::labs(x = "Estimate of mean /I/ duration (ms)", y = "Simulation density") +
  theme_notes
save_plot(p_bias, "hillenbrand-estimator-bias.png", height = 5.2)

mse_components <- rbind(
  data.frame(
    estimator = estimator_summary$estimator,
    component = "Sampling variance",
    value_ms2 = estimator_summary$sampling_variance_ms2
  ),
  data.frame(
    estimator = estimator_summary$estimator,
    component = "Squared bias",
    value_ms2 = estimator_summary$squared_bias_ms2
  )
)
p_mse <- ggplot2::ggplot(
  mse_components,
  ggplot2::aes(estimator, value_ms2, fill = component)
) +
  ggplot2::geom_col(width = 0.65, color = "white", linewidth = 0.2) +
  ggplot2::scale_fill_manual(values = c("Sampling variance" = "grey55", "Squared bias" = "#8B1A1A")) +
  ggplot2::labs(x = NULL, y = expression("Mean squared error (ms"^2*")")) +
  theme_notes
save_plot(p_mse, "hillenbrand-mse-decomposition.png")

ci_seed <- 20261020L
ci_replicates <- 20000L
ci_sample_size <- nrow(women_hid)
set.seed(ci_seed)
ci_simulation <- do.call(rbind, lapply(seq_len(ci_replicates), function(draw) {
  x <- sample(duration_population, size = ci_sample_size, replace = TRUE)
  estimate <- mean(x)
  estimated_se <- stats::sd(x) / sqrt(ci_sample_size)
  known_se <- duration_population_sd / sqrt(ci_sample_size)
  data.frame(
    draw = draw,
    estimate_ms = estimate,
    estimated_se_ms = estimated_se,
    t_lower_ms = estimate - stats::qt(0.975, df = ci_sample_size - 1L) * estimated_se,
    t_upper_ms = estimate + stats::qt(0.975, df = ci_sample_size - 1L) * estimated_se,
    z_lower_ms = estimate - stats::qnorm(0.975) * known_se,
    z_upper_ms = estimate + stats::qnorm(0.975) * known_se
  )
}))
ci_simulation$t_covers <- with(
  ci_simulation,
  t_lower_ms <= duration_target_mean & duration_target_mean <= t_upper_ms
)
ci_simulation$z_covers <- with(
  ci_simulation,
  z_lower_ms <= duration_target_mean & duration_target_mean <= z_upper_ms
)
ci_summary <- data.frame(
  empirical_target_mean_ms = duration_target_mean,
  sample_size = ci_sample_size,
  replicates = ci_replicates,
  t_interval_coverage = mean(ci_simulation$t_covers),
  known_sigma_z_interval_coverage = mean(ci_simulation$z_covers),
  average_t_interval_width_ms = mean(ci_simulation$t_upper_ms - ci_simulation$t_lower_ms),
  average_z_interval_width_ms = mean(ci_simulation$z_upper_ms - ci_simulation$z_lower_ms)
)
write_output(ci_summary, "hillenbrand-confidence-interval-coverage.csv")
assert_true(abs(ci_summary$t_interval_coverage - 0.95) < 0.01,
            "Hillenbrand t-interval coverage is unexpectedly far from 0.95")
assert_true(abs(ci_summary$known_sigma_z_interval_coverage - 0.95) < 0.01,
            "Hillenbrand z-interval coverage is unexpectedly far from 0.95")

ci_display_count <- 60L
ci_display <- ci_simulation[seq_len(ci_display_count), ]
ci_display$coverage <- ifelse(ci_display$t_covers, "Covers target", "Misses target")
p_ci <- ggplot2::ggplot(
  ci_display,
  ggplot2::aes(x = draw, y = estimate_ms, ymin = t_lower_ms, ymax = t_upper_ms, color = coverage)
) +
  ggplot2::geom_hline(yintercept = duration_target_mean, color = "grey35", linewidth = 0.6) +
  ggplot2::geom_linerange(linewidth = 0.45) +
  ggplot2::geom_point(size = 0.9) +
  ggplot2::scale_color_manual(values = c("Covers target" = "grey60", "Misses target" = "#8B1A1A")) +
  ggplot2::labs(x = "Repeated sample", y = "Mean /I/ duration interval (ms)") +
  theme_notes
save_plot(p_ci, "hillenbrand-confidence-interval-coverage.png", height = 4.6)

# One within-speaker contrast, used three ways: an exact interval for a sign
# probability, a one-sample t analysis of magnitude, and raw-data diagnostics.
women_two_vowels <- hillenbrand[
  hillenbrand$speaker_type == "woman" & hillenbrand$vowel %in% c("I", "i"),
  c("speaker_id", "vowel", "duration_ms")
]
women_wide <- stats::reshape(
  women_two_vowels,
  idvar = "speaker_id",
  timevar = "vowel",
  direction = "wide"
)
names(women_wide)[names(women_wide) == "duration_ms.I"] <- "hid_duration_ms"
names(women_wide)[names(women_wide) == "duration_ms.i"] <- "heed_duration_ms"
women_wide$duration_difference_ms <- women_wide$hid_duration_ms - women_wide$heed_duration_ms
women_wide$hid_longer <- as.integer(women_wide$duration_difference_ms > 0)
women_wide <- women_wide[order(women_wide$speaker_id), ]
assert_true(nrow(women_wide) == 48L && !anyNA(women_wide$duration_difference_ms),
            "Hillenbrand adult-women duration pairs are incomplete")
write_output(women_wide, "hillenbrand-women-hid-heed-pairs.csv")

sign_successes <- sum(women_wide$hid_longer)
sign_trials <- nrow(women_wide)
sign_estimate <- sign_successes / sign_trials
sign_exact <- stats::binom.test(sign_successes, sign_trials, conf.level = 0.95)
sign_wald_se <- sqrt(sign_estimate * (1 - sign_estimate) / sign_trials)
sign_wald_interval <- sign_estimate + c(-1, 1) * stats::qnorm(0.975) * sign_wald_se
sign_summary <- data.frame(
  response = "/I/ in hid longer than /i/ in heed",
  speakers = sign_trials,
  successes = sign_successes,
  sample_proportion = sign_estimate,
  clopper_pearson_lower = sign_exact$conf.int[[1L]],
  clopper_pearson_upper = sign_exact$conf.int[[2L]],
  wald_lower = sign_wald_interval[[1L]],
  wald_upper = sign_wald_interval[[2L]]
)
write_output(sign_summary, "hillenbrand-exact-binomial-summary.csv")
assert_true(sign_successes == 3L, "Hillenbrand duration-sign count changed")
assert_true(sign_wald_interval[[1L]] < 0, "Hillenbrand Wald interval no longer crosses below zero")

p_sign <- ggplot2::ggplot(sign_summary, ggplot2::aes(x = 1, y = sample_proportion)) +
  ggplot2::geom_linerange(
    ggplot2::aes(ymin = clopper_pearson_lower, ymax = clopper_pearson_upper),
    color = "grey30",
    linewidth = 0.7
  ) +
  ggplot2::geom_point(color = "#8B1A1A", size = 2.4) +
  ggplot2::scale_x_continuous(breaks = NULL) +
  ggplot2::scale_y_continuous(limits = c(0, 0.22), labels = scales::label_percent(accuracy = 1)) +
  ggplot2::labs(x = NULL, y = "Proportion with /I/ longer than /i/") +
  theme_notes
save_plot(p_sign, "hillenbrand-exact-binomial-interval.png", width = 4.2)

bootstrap_seed <- 20261021L
bootstrap_replicates <- 10000L
set.seed(bootstrap_seed)
bootstrap_medians <- replicate(
  bootstrap_replicates,
  stats::median(sample(duration_population, size = length(duration_population), replace = TRUE))
)
bootstrap_interval <- unname(stats::quantile(bootstrap_medians, c(0.025, 0.975), type = 7))
bootstrap_summary <- data.frame(
  response = "adult-women /I/ duration in hid",
  speakers = length(duration_population),
  observed_median_ms = duration_target_median,
  replicates = bootstrap_replicates,
  seed = bootstrap_seed,
  bootstrap_mean_ms = mean(bootstrap_medians),
  bootstrap_standard_error_ms = stats::sd(bootstrap_medians),
  percentile_lower_ms = bootstrap_interval[[1L]],
  percentile_upper_ms = bootstrap_interval[[2L]]
)
write_output(bootstrap_summary, "hillenbrand-bootstrap-median-summary.csv")

p_bootstrap <- ggplot2::ggplot(data.frame(median_ms = bootstrap_medians), ggplot2::aes(median_ms)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    binwidth = 1,
    fill = "grey75",
    color = "white"
  ) +
  ggplot2::geom_vline(xintercept = duration_target_median, color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::labs(x = "Bootstrap median /I/ duration (ms)", y = "Bootstrap density") +
  theme_notes
save_plot(p_bootstrap, "hillenbrand-bootstrap-median.png")

difference <- women_wide$duration_difference_ms
difference_n <- length(difference)
difference_mean <- mean(difference)
difference_sd <- stats::sd(difference)
difference_se <- difference_sd / sqrt(difference_n)
difference_t <- difference_mean / difference_se
difference_df <- difference_n - 1L
difference_p <- 2 * stats::pt(-abs(difference_t), df = difference_df)
difference_critical <- stats::qt(0.975, df = difference_df)
difference_ci <- difference_mean + c(-1, 1) * difference_critical * difference_se
difference_t_test <- stats::t.test(difference, mu = 0)
assert_close(unname(difference_t_test$statistic), difference_t, 1e-12,
             "Manual and t.test one-sample statistics disagree")
assert_close(unname(difference_t_test$conf.int), difference_ci, 1e-10,
             "Manual and t.test one-sample intervals disagree")

difference_summary <- data.frame(
  contrast = "/I/ in hid minus /i/ in heed, adult women",
  speakers = difference_n,
  mean_difference_ms = difference_mean,
  sd_difference_ms = difference_sd,
  se_mean_difference_ms = difference_se,
  null_value_ms = 0,
  t_statistic = difference_t,
  degrees_of_freedom = difference_df,
  two_sided_p_value = difference_p,
  confidence_lower_ms = difference_ci[[1L]],
  confidence_upper_ms = difference_ci[[2L]]
)
write_output(difference_summary, "hillenbrand-one-sample-t-summary.csv")

p_difference <- ggplot2::ggplot(
  women_wide,
  ggplot2::aes(x = 1, y = duration_difference_ms)
) +
  ggplot2::geom_hline(yintercept = 0, color = "grey65", linewidth = 0.5) +
  ggplot2::geom_jitter(
    color = "grey35",
    alpha = 0.75,
    position = ggplot2::position_jitter(width = 0.08, height = 0, seed = 20261018)
  ) +
  ggplot2::geom_point(
    data = data.frame(x = 1, y = difference_mean),
    ggplot2::aes(x, y),
    inherit.aes = FALSE,
    color = "#8B1A1A",
    size = 2.5
  ) +
  ggplot2::scale_x_continuous(breaks = NULL) +
  ggplot2::labs(x = NULL, y = "Within-speaker /I/ - /i/ duration (ms)") +
  theme_notes
save_plot(p_difference, "hillenbrand-women-duration-differences.png", width = 4.5)

t_reference_grid <- data.frame(t = seq(-12, 12, length.out = 1000L))
t_reference_grid$density <- stats::dt(t_reference_grid$t, df = difference_df)
p_t_reference <- ggplot2::ggplot(t_reference_grid, ggplot2::aes(t, density)) +
  ggplot2::geom_line(color = "grey25", linewidth = 0.8) +
  ggplot2::geom_vline(
    xintercept = c(-abs(difference_t), abs(difference_t)),
    color = "#8B1A1A",
    linewidth = 0.7
  ) +
  ggplot2::labs(x = paste0("t statistic (", difference_df, " df)"), y = "Null reference density") +
  theme_notes
save_plot(p_t_reference, "hillenbrand-one-sample-t-reference.png")

men_hid <- hillenbrand[
  hillenbrand$speaker_type == "man" & hillenbrand$vowel == "I",
  c("speaker_id", "speaker_type", "duration_ms")
]
women_hid_group <- hillenbrand[
  hillenbrand$speaker_type == "woman" & hillenbrand$vowel == "I",
  c("speaker_id", "speaker_type", "duration_ms")
]
welch <- stats::t.test(
  men_hid$duration_ms,
  women_hid_group$duration_ms,
  var.equal = FALSE,
  conf.level = 0.95
)
welch_variance_man <- stats::var(men_hid$duration_ms) / nrow(men_hid)
welch_variance_woman <- stats::var(women_hid_group$duration_ms) / nrow(women_hid_group)
welch_se <- sqrt(welch_variance_man + welch_variance_woman)
welch_df <- (welch_variance_man + welch_variance_woman)^2 / (
  welch_variance_man^2 / (nrow(men_hid) - 1L) +
    welch_variance_woman^2 / (nrow(women_hid_group) - 1L)
)
assert_close(unname(welch$statistic),
             (mean(men_hid$duration_ms) - mean(women_hid_group$duration_ms)) / welch_se,
             1e-12, "Manual and t.test Welch statistics disagree")
assert_close(unname(welch$parameter), welch_df, 1e-10,
             "Manual and t.test Welch degrees of freedom disagree")

welch_summary <- data.frame(
  response = "/I/ duration in hid",
  first_group = "man",
  second_group = "woman",
  first_group_speakers = nrow(men_hid),
  second_group_speakers = nrow(women_hid_group),
  first_group_mean_ms = mean(men_hid$duration_ms),
  second_group_mean_ms = mean(women_hid_group$duration_ms),
  first_group_sd_ms = stats::sd(men_hid$duration_ms),
  second_group_sd_ms = stats::sd(women_hid_group$duration_ms),
  difference_man_minus_woman_ms = unname(welch$estimate[[1L]] - welch$estimate[[2L]]),
  standard_error_ms = welch_se,
  degrees_of_freedom = welch_df,
  t_statistic = unname(welch$statistic),
  two_sided_p_value = welch$p.value,
  confidence_lower_ms = welch$conf.int[[1L]],
  confidence_upper_ms = welch$conf.int[[2L]]
)
write_output(welch_summary, "hillenbrand-independent-means-summary.csv")

independent_data <- rbind(men_hid, women_hid_group)
independent_means <- aggregate(duration_ms ~ speaker_type, independent_data, mean)
p_independent <- ggplot2::ggplot(
  independent_data,
  ggplot2::aes(speaker_type, duration_ms)
) +
  ggplot2::geom_jitter(
    color = "grey45",
    alpha = 0.7,
    position = ggplot2::position_jitter(width = 0.08, height = 0, seed = 20261018)
  ) +
  ggplot2::geom_point(
    data = independent_means,
    ggplot2::aes(speaker_type, duration_ms),
    color = "#8B1A1A",
    size = 2.5,
    inherit.aes = FALSE
  ) +
  ggplot2::labs(x = "Speaker group", y = "/I/ duration in hid (ms)") +
  theme_notes
save_plot(p_independent, "hillenbrand-independent-means.png")

# -----------------------------------------------------------------------------
# UCCA: source-order aligned passages and descriptive random re-pairing
# -----------------------------------------------------------------------------

ucca_en <- ucca[ucca$language == "en", ]
ucca_fr <- ucca[ucca$language == "fr", ]
ucca_en <- ucca_en[order(ucca_en$pair_id), ]
ucca_fr <- ucca_fr[order(ucca_fr$pair_id), ]
assert_true(identical(ucca_en$pair_id, ucca_fr$pair_id), "UCCA source-order pair IDs do not align")

ucca_pairs <- data.frame(
  pair_id = ucca_en$pair_id,
  chapter = ucca_en$chapter,
  pair_position_in_chapter = ucca_en$pair_position_in_chapter,
  english_release_passage_id = ucca_en$release_passage_id,
  french_release_passage_id = ucca_fr$release_passage_id,
  english_terminals = ucca_en$terminal_count,
  french_terminals = ucca_fr$terminal_count,
  english_scenes = ucca_en$scene_count,
  french_scenes = ucca_fr$scene_count,
  stringsAsFactors = FALSE
)
ucca_pairs$signed_difference_fr_minus_en <- ucca_pairs$french_scenes - ucca_pairs$english_scenes
ucca_pairs$absolute_difference <- abs(ucca_pairs$signed_difference_fr_minus_en)
ucca_pairs$english_scenes_per_100_terminals <- 100 * ucca_pairs$english_scenes / ucca_pairs$english_terminals
ucca_pairs$french_scenes_per_100_terminals <- 100 * ucca_pairs$french_scenes / ucca_pairs$french_terminals
ucca_pairs$absolute_rate_difference <- abs(
  ucca_pairs$french_scenes_per_100_terminals - ucca_pairs$english_scenes_per_100_terminals
)
write_output(ucca_pairs, "ucca-scene-pairs.csv")

ucca_delta_aligned <- mean(ucca_pairs$absolute_difference)
ucca_signed_mean <- mean(ucca_pairs$signed_difference_fr_minus_en)
ucca_covariance <- stats::cov(ucca_pairs$english_scenes, ucca_pairs$french_scenes)
ucca_correlation <- stats::cor(ucca_pairs$english_scenes, ucca_pairs$french_scenes)
ucca_rate_delta_aligned <- mean(ucca_pairs$absolute_rate_difference)

ucca_seed <- 20261018L
ucca_repairings <- 9999L
set.seed(ucca_seed)
ucca_repaired <- do.call(rbind, lapply(seq_len(ucca_repairings), function(draw) {
  shuffled <- sample(seq_len(nrow(ucca_pairs)))
  data.frame(
    draw = draw,
    mean_absolute_scene_difference = mean(abs(
      ucca_pairs$french_scenes[shuffled] - ucca_pairs$english_scenes
    )),
    mean_absolute_rate_difference = mean(abs(
      ucca_pairs$french_scenes_per_100_terminals[shuffled] -
        ucca_pairs$english_scenes_per_100_terminals
    ))
  )
}))
write_output(ucca_repaired, "ucca-scene-random-repairings.csv")

ucca_lower_tail_fraction <- (
  1 + sum(ucca_repaired$mean_absolute_scene_difference <= ucca_delta_aligned)
) / (ucca_repairings + 1)
ucca_rate_lower_tail_fraction <- (
  1 + sum(ucca_repaired$mean_absolute_rate_difference <= ucca_rate_delta_aligned)
) / (ucca_repairings + 1)

ucca_summary <- data.frame(
  pairs = nrow(ucca_pairs),
  english_scenes = sum(ucca_pairs$english_scenes),
  french_scenes = sum(ucca_pairs$french_scenes),
  mean_english_scenes = mean(ucca_pairs$english_scenes),
  mean_french_scenes = mean(ucca_pairs$french_scenes),
  mean_signed_difference_fr_minus_en = ucca_signed_mean,
  mean_absolute_aligned_difference = ucca_delta_aligned,
  covariance_aligned_counts = ucca_covariance,
  correlation_aligned_counts = ucca_correlation,
  re_pairing_seed = ucca_seed,
  re_pairings = ucca_repairings,
  mean_repaired_absolute_difference = mean(ucca_repaired$mean_absolute_scene_difference),
  minimum_repaired_absolute_difference = min(ucca_repaired$mean_absolute_scene_difference),
  maximum_repaired_absolute_difference = max(ucca_repaired$mean_absolute_scene_difference),
  descriptive_lower_tail_fraction = ucca_lower_tail_fraction,
  mean_absolute_aligned_rate_difference = ucca_rate_delta_aligned,
  mean_repaired_absolute_rate_difference = mean(ucca_repaired$mean_absolute_rate_difference),
  descriptive_rate_lower_tail_fraction = ucca_rate_lower_tail_fraction
)
write_output(ucca_summary, "ucca-scene-pairing-summary.csv")
assert_close(ucca_delta_aligned, 320 / 154, 1e-12,
             "UCCA aligned mean absolute difference changed")
assert_close(ucca_lower_tail_fraction, 0.0001, 1e-12,
             "UCCA descriptive lower-tail fraction changed")

ucca_limits <- range(c(ucca_pairs$english_scenes, ucca_pairs$french_scenes))
p_ucca_pairs <- ggplot2::ggplot(
  ucca_pairs,
  ggplot2::aes(english_scenes, french_scenes)
) +
  ggplot2::geom_abline(slope = 1, intercept = 0, color = "grey55", linewidth = 0.5) +
  ggplot2::geom_point(color = "grey25", size = 1.6, alpha = 0.65) +
  ggplot2::coord_equal(xlim = ucca_limits, ylim = ucca_limits) +
  ggplot2::labs(x = "Scenes in English passage", y = "Scenes in French passage") +
  theme_notes
save_plot(p_ucca_pairs, "ucca-paired-scenes.png", width = 5.4, height = 5.0)

p_ucca_repaired <- ggplot2::ggplot(
  ucca_repaired,
  ggplot2::aes(mean_absolute_scene_difference)
) +
  ggplot2::geom_histogram(bins = 35, fill = "grey75", color = "white", linewidth = 0.2) +
  ggplot2::geom_vline(xintercept = ucca_delta_aligned, color = "#8B1A1A", linewidth = 0.7) +
  ggplot2::labs(
    x = "Mean absolute Scene-count difference after re-pairing",
    y = "Re-pairings"
  ) +
  theme_notes
save_plot(p_ucca_repaired, "ucca-random-repairing-reference.png")

# -----------------------------------------------------------------------------
# Turkish UniMorph: conditional exact and large-sample table references
# -----------------------------------------------------------------------------

unimorph_sample$front_vowel <- grepl("^front", unimorph_sample$vowel_class)
fisher_table <- table(
  front_vowel = unimorph_sample$front_vowel,
  t_initial = unimorph_sample$t_initial
)
assert_true(identical(dim(fisher_table), c(2L, 2L)), "UniMorph Fisher table is not 2 by 2")
fisher_result <- stats::fisher.test(fisher_table, alternative = "two.sided")
fisher_cells <- as.data.frame(fisher_table, responseName = "lexemes")
fisher_cells$front_vowel <- ifelse(fisher_cells$front_vowel == "TRUE", "Front", "Back")
fisher_cells$past_initial <- ifelse(fisher_cells$t_initial == "1", "t", "d")
fisher_cells$t_initial <- NULL
write_output(fisher_cells, "unimorph-fisher-cells.csv")
write_output(data.frame(
  source = "fixed 120-lemma simple random sample without replacement",
  sample_seed = 414L,
  sample_size = nrow(unimorph_sample),
  population_size = nrow(unimorph_population),
  observed_table_probability = stats::dhyper(
    fisher_table["TRUE", "1"],
    m = sum(fisher_table[, "1"]),
    n = sum(fisher_table[, "0"]),
    k = sum(fisher_table["TRUE", ])
  ),
  conditional_odds_ratio = unname(fisher_result$estimate),
  confidence_lower = fisher_result$conf.int[[1L]],
  confidence_upper = fisher_result$conf.int[[2L]],
  two_sided_p_value = fisher_result$p.value
), "unimorph-fisher-summary.csv")

fisher_cells$front_vowel <- factor(fisher_cells$front_vowel, levels = c("Back", "Front"))
fisher_cells$past_initial <- factor(fisher_cells$past_initial, levels = c("d", "t"))
p_fisher <- ggplot2::ggplot(
  fisher_cells,
  ggplot2::aes(past_initial, front_vowel, fill = lexemes)
) +
  ggplot2::geom_tile(color = "white", linewidth = 0.8) +
  ggplot2::geom_text(ggplot2::aes(label = lexemes), size = 4) +
  ggplot2::scale_fill_gradient(low = "grey90", high = "grey45", guide = "none") +
  ggplot2::labs(x = "Past suffix initial", y = "Last stem-vowel class") +
  theme_notes
save_plot(p_fisher, "unimorph-fisher-table.png", width = 4.8, height = 3.7)

chi_table <- table(
  vowel_class = unimorph_population$vowel_class,
  t_initial = unimorph_population$t_initial
)
chi_result <- suppressWarnings(stats::chisq.test(chi_table, correct = FALSE))
assert_true(all(chi_result$expected >= 5), "UniMorph chi-squared expected counts are sparse")
chi_cells <- as.data.frame(chi_table, responseName = "observed")
chi_cells$expected <- as.numeric(chi_result$expected)
chi_cells$pearson_residual <- as.numeric(chi_result$residuals)
chi_cells$past_initial <- ifelse(chi_cells$t_initial == "1", "t", "d")
write_output(chi_cells, "unimorph-chi-square-cells.csv")
chi_cramers_v <- sqrt(
  unname(chi_result$statistic) /
    (sum(chi_table) * min(nrow(chi_table) - 1L, ncol(chi_table) - 1L))
)
write_output(data.frame(
  source = "census of the pinned 588-lemma resource-defined population",
  rows = nrow(chi_table),
  columns = ncol(chi_table),
  lexemes = sum(chi_table),
  chi_squared = unname(chi_result$statistic),
  degrees_of_freedom = unname(chi_result$parameter),
  reference_p_value = chi_result$p.value,
  minimum_expected_count = min(chi_result$expected),
  cramers_v = chi_cramers_v
), "unimorph-chi-square-summary.csv")

chi_cells$vowel_class <- factor(
  chi_cells$vowel_class,
  levels = c("back_unrounded", "back_rounded", "front_unrounded", "front_rounded")
)
p_chi <- ggplot2::ggplot(
  chi_cells,
  ggplot2::aes(y = vowel_class)
) +
  ggplot2::geom_segment(
    ggplot2::aes(x = expected, xend = observed, yend = vowel_class),
    color = "grey65",
    linewidth = 0.6
  ) +
  ggplot2::geom_point(ggplot2::aes(x = expected), shape = 1, color = "#8B1A1A", size = 2.3) +
  ggplot2::geom_point(ggplot2::aes(x = observed), color = "grey25", size = 2.1) +
  ggplot2::facet_wrap(~past_initial, ncol = 2, scales = "free_x") +
  ggplot2::labs(x = "Lexeme count", y = "Last stem-vowel class") +
  theme_notes
save_plot(p_chi, "unimorph-chi-square-observed-expected.png", width = 7.2, height = 4.0)

# -----------------------------------------------------------------------------
# Page-level handoff and run metadata
# -----------------------------------------------------------------------------

page_registry <- data.frame(
  page = c(
    "populations-and-samples.qmd",
    "independent-sampling.qmd",
    "pronoun-case-example.qmd",
    "maximum-likelihood.qmd",
    "poisson-maximum-likelihood.qmd",
    "properties-of-estimators.qmd",
    "standard-errors.qmd",
    "estimator-bias.qmd",
    "mean-squared-error.qmd",
    "confidence-intervals.qmd",
    "exact-binomial-intervals.qmd",
    "bootstrap-confidence-intervals.qmd",
    "null-hypotheses-and-test-statistics.qmd",
    "one-sample-t-inference.qmd",
    "paired-observations.qmd",
    "paired-mean-inference.qmd",
    "independent-means.qmd",
    "fishers-exact-test.qmd",
    "chi-squared-test.qmd"
  ),
  dataset = c(
    rep("UD Turkish BOUN 2.18 personal pronouns", 5),
    rep("Hillenbrand et al. (1995) vowels", 9),
    rep("UCCA French-English 20K v2", 2),
    "Hillenbrand et al. (1995) vowels",
    rep("Turkish UniMorph", 2)
  ),
  response = c(
    "annotated Case on personal-pronoun tokens",
    "Case=Acc indicator on personal-pronoun tokens",
    "Case=Acc indicator on personal-pronoun tokens",
    "Case=Acc indicator on personal-pronoun tokens",
    "personal-pronoun tokens per BOUN sentence, including zero sentences",
    "mean /I/ duration for adult women under the empirical resampling distribution",
    "mean /I/ duration for adult women under the empirical resampling distribution",
    "sample mean and sample median as estimators of empirical mean /I/ duration",
    "squared error of the two empirical estimators",
    "mean /I/ duration interval under empirical resampling",
    "whether /I/ duration exceeds /i/ duration within an adult woman",
    "median adult-women /I/ duration",
    "adult-women within-speaker /I/ minus /i/ duration",
    "adult-women within-speaker /I/ minus /i/ duration",
    "English and French graph-derived Scene counts in source-order passage pairs",
    "mean absolute Scene-count difference and random re-pairing reference",
    "/I/ duration for distinct adult men and women",
    "last stem-vowel backness by past-suffix d/t initial in fixed 120-lemma sample",
    "four last stem-vowel classes by past-suffix d/t initial in 588-lemma census"
  ),
  independent_or_resampling_unit = c(
    "sentence sampled within register; tokens are nested",
    "working token-level IID model, with sentence/register limitation",
    "working token-level IID model, with sentence/register limitation",
    "working token-level IID model, with sentence/register limitation",
    "sentence, with unavailable document identifiers",
    rep("speaker drawn with replacement from the 48-row empirical distribution", 5),
    "speaker",
    "speaker resampled as a block",
    "speaker",
    "speaker",
    "aligned passage pair",
    "aligned passage pair; re-pairing changes only cross-language alignment",
    "speaker",
    "verb lemma sampled without replacement",
    "verb lemma in a finite resource census"
  ),
  primary_output = c(
    "ud-population-sample-summary.csv",
    "ud-observed-bernoulli-sequence-summary.csv",
    "ud-bernoulli-mle-summary.csv",
    "ud-bernoulli-mle-summary.csv",
    "ud-sentence-pronoun-poisson-summary.csv",
    "hillenbrand-sampling-standard-error-summary.csv",
    "hillenbrand-sampling-standard-error-summary.csv",
    "hillenbrand-bias-mse-summary.csv",
    "hillenbrand-bias-mse-summary.csv",
    "hillenbrand-confidence-interval-coverage.csv",
    "hillenbrand-exact-binomial-summary.csv",
    "hillenbrand-bootstrap-median-summary.csv",
    "hillenbrand-one-sample-t-summary.csv",
    "hillenbrand-one-sample-t-summary.csv",
    "ucca-scene-pairing-summary.csv",
    "ucca-scene-pairing-summary.csv",
    "hillenbrand-independent-means-summary.csv",
    "unimorph-fisher-summary.csv",
    "unimorph-chi-square-summary.csv"
  ),
  primary_figure = c(
    "ud-case-counts.png",
    "ud-accusative-by-register.png",
    "ud-accusative-by-register.png",
    "ud-bernoulli-likelihood.png",
    "ud-sentence-pronoun-poisson-fit.png",
    "hillenbrand-sampling-distribution.png",
    "hillenbrand-standard-errors.png",
    "hillenbrand-estimator-bias.png",
    "hillenbrand-mse-decomposition.png",
    "hillenbrand-confidence-interval-coverage.png",
    "hillenbrand-exact-binomial-interval.png",
    "hillenbrand-bootstrap-median.png",
    "hillenbrand-women-duration-differences.png",
    "hillenbrand-one-sample-t-reference.png",
    "ucca-paired-scenes.png",
    "ucca-random-repairing-reference.png",
    "hillenbrand-independent-means.png",
    "unimorph-fisher-table.png",
    "unimorph-chi-square-observed-expected.png"
  ),
  mapping_status = c(
    rep("approved", 4),
    "corrected: use sentence pronoun counts, not a binary WH table",
    rep("approved", 9),
    "approved",
    "corrected: descriptive re-pairing, not a paired t-test",
    "approved",
    "approved with finite-resource limitation",
    "approved as descriptive census/reference comparison"
  ),
  stringsAsFactors = FALSE
)
write_output(page_registry, "page-object-registry.csv")
assert_true(nrow(page_registry) == 19L, "Frequentist page registry does not contain 19 pages")

seed_registry <- data.frame(
  purpose = c(
    "Hillenbrand sampling distributions and standard errors",
    "Hillenbrand bias and MSE simulation",
    "Hillenbrand confidence-interval coverage",
    "Hillenbrand bootstrap median",
    "UCCA random re-pairing",
    "Turkish UniMorph prepared finite sample"
  ),
  seed = c(sampling_seed, bias_seed, ci_seed, bootstrap_seed, ucca_seed, 414L),
  repetitions_or_sample_size = c(
    sampling_replicates, bias_replicates, ci_replicates,
    bootstrap_replicates, ucca_repairings, nrow(unimorph_sample)
  ),
  stringsAsFactors = FALSE
)
write_output(seed_registry, "seed-registry.csv")

run_metadata <- data.frame(
  field = c(
    "analysis_date", "r_version", "platform", "script",
    "output_directory", "problem_sets_edited"
  ),
  value = c(
    as.character(Sys.Date()),
    R.version.string,
    R.version$platform,
    "scripts/data-grounding/reference_inference_frequentist.R",
    "research/dataset-audits/reference-inference-frequentist-output",
    "none"
  ),
  stringsAsFactors = FALSE
)
write_output(run_metadata, "run-metadata.csv")

message("Frequentist reference analysis complete: ", nrow(page_registry), " page mappings written.")
