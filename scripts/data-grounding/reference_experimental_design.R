#!/usr/bin/env Rscript

# Paper-first reference analysis for the seven non-index pages in
# experimental-design/.
#
# This script reads the pinned ManyBabies 1 teaching object, checks its frozen
# identity and design structure, computes the empirical objects needed by the
# notes, fits one compact teaching model, and runs a calibrated hierarchical
# design simulation. It does not edit notes, source data, or problem sets.

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
  "research", "dataset-audits", "reference-experimental-design-output"
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

mode_value <- function(x) {
  tab <- sort(table(x, useNA = "no"), decreasing = TRUE)
  names(tab)[[1L]]
}

ggplot_available <- requireNamespace("ggplot2", quietly = TRUE)
lme4_available <- requireNamespace("lme4", quietly = TRUE)
jsonlite_available <- requireNamespace("jsonlite", quietly = TRUE)
assert_true(ggplot_available, "ggplot2 is required to write the reference figures")
assert_true(lme4_available, "lme4 is required for the empirical model and simulation")
assert_true(jsonlite_available, "jsonlite is required to write the machine-readable registry")

accent <- "#2C6E9B"
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

# -----------------------------------------------------------------------------
# Frozen input, source pins, and schema
# -----------------------------------------------------------------------------

input_path <- file.path(project_root, "data", "manybabies", "manybabies1-trials.rds")
provenance_path <- file.path(project_root, "data", "manybabies", "provenance.json")
readme_path <- file.path(project_root, "data", "manybabies", "README.md")
license_path <- file.path(project_root, "data", "manybabies", "LICENSE-MIT.txt")

input_specs <- data.frame(
  object = c("teaching trial table", "provenance", "course README", "repository license"),
  path = c(input_path, provenance_path, readme_path, license_path),
  expected_sha256 = c(
    "a259076cb7948c8f07d5e7923c6fef263d0c50e20c8c6c1804162683fdbb75e1",
    "2a7d5c7dc3b42673dd07d81b2fcc5829874b1d7922649f0fe666605448bc84f2",
    "6dcf4042b900d42f5ffff825ee72854157c00f64c6b196c8a9d9cc79f040506c",
    "aedf2ccfe00a21fbf2ad74dcb1df9777f30fba395e7108a738754d2bcabcfe2b"
  ),
  stringsAsFactors = FALSE
)
assert_true(all(file.exists(input_specs$path)), "A pinned ManyBabies input is missing")
input_specs$observed_sha256 <- vapply(input_specs$path, sha256, character(1))
input_specs$checksum_matches <- is.na(input_specs$expected_sha256) |
  input_specs$expected_sha256 == input_specs$observed_sha256
assert_true(all(input_specs$checksum_matches), "The frozen ManyBabies trial table changed")
write_output(input_specs, "input-checksums.csv")

provenance <- jsonlite::read_json(provenance_path, simplifyVector = TRUE)
assert_true(
  identical(provenance$source_commit, "dc3eb5b3578057096d337203635c0759d2fc04b6"),
  "The ManyBabies source commit changed"
)
write_output(provenance$source_files, "upstream-source-checksums.csv")

d <- readRDS(input_path)
required_columns <- c(
  "lab_id", "infant_id", "counterbalance_order", "trial_number", "register",
  "stimulus_id", "method", "age_days", "age_months", "age_group",
  "north_american_english", "gender", "second_session",
  "looking_time_seconds", "trial_missing", "trial_metadata_observed"
)
assert_true(identical(names(d), required_columns), "The ManyBabies teaching schema changed")
assert_true(nrow(d) == 37264L, "The ManyBabies row count changed")
assert_true(length(unique(d$infant_id)) == 2329L, "The infant count changed")
assert_true(length(unique(d$lab_id)) == 67L, "The lab count changed")
assert_true(all(table(d$infant_id) == 16L), "The completed 16-row infant design changed")
assert_true(setequal(stats::na.omit(unique(d$register)), c("ADS", "IDS")),
            "The register levels changed")
assert_true(setequal(unique(d$method), c("eyetracking", "hpp", "singlescreen")),
            "The method levels changed")
assert_true(sum(d$trial_missing) == 10369L, "The missing-outcome count changed")
assert_true(sum(!d$trial_metadata_observed) == 4383L,
            "The completed-row metadata count changed")
assert_true(all(is.na(d$looking_time_seconds) == d$trial_missing),
            "Missingness and looking time no longer agree")

package_status <- data.frame(
  package = c("R", "stats", "utils", "ggplot2", "lme4", "jsonlite"),
  version = c(
    as.character(getRversion()),
    as.character(utils::packageVersion("stats")),
    as.character(utils::packageVersion("utils")),
    as.character(utils::packageVersion("ggplot2")),
    as.character(utils::packageVersion("lme4")),
    as.character(utils::packageVersion("jsonlite"))
  ),
  stringsAsFactors = FALSE
)
write_output(package_status, "package-versions.csv")

# `counterbalance_order` is absent on rows added by `complete()` in the official
# exclusion script. Fill it only from the unique recorded value within infant.
order_by_infant <- vapply(split(d$counterbalance_order, d$infant_id), function(x) {
  observed <- unique(stats::na.omit(x))
  assert_true(length(observed) == 1L, "An infant has zero or multiple order values")
  as.integer(observed)
}, integer(1))
d$assigned_order <- unname(order_by_infant[d$infant_id])

# -----------------------------------------------------------------------------
# Units of assignment, sampling, measurement, exclusion, and analysis
# -----------------------------------------------------------------------------

usable_by_infant <- aggregate(
  cbind(
    usable_trials = as.integer(!d$trial_missing),
    metadata_rows = as.integer(d$trial_metadata_observed)
  ) ~ infant_id + lab_id + assigned_order + method + age_months +
    north_american_english,
  data = d,
  FUN = sum
)

registers_by_infant <- tapply(
  d$register[!d$trial_missing],
  d$infant_id[!d$trial_missing],
  function(x) length(unique(x))
)
usable_by_infant$registers_with_usable_data <- 0L
usable_by_infant$registers_with_usable_data[
  match(names(registers_by_infant), usable_by_infant$infant_id)
] <- as.integer(registers_by_infant)

unit_counts <- data.frame(
  unit = c(
    "possible trial rows", "rows with recorded trial metadata",
    "rows with included looking time", "included infants",
    "infants with at least one included looking time",
    "infants with included looking time in both registers",
    "laboratories", "paired stimulus IDs", "assigned order sequences"
  ),
  count = c(
    nrow(d), sum(d$trial_metadata_observed), sum(!d$trial_missing),
    length(unique(d$infant_id)), sum(usable_by_infant$usable_trials > 0L),
    sum(usable_by_infant$registers_with_usable_data == 2L),
    length(unique(d$lab_id)), length(unique(stats::na.omit(d$stimulus_id))),
    length(unique(d$assigned_order))
  ),
  role = c(
    "completed measurement opportunities", "recorded measurement opportunities",
    "observed outcomes in teaching table", "sampling and order-assignment units",
    "units entering any looking-time analysis",
    "units entering a within-infant register contrast",
    "sampling and analysis clusters", "crossed repeated materials",
    "between-infant nuisance assignment"
  ),
  stringsAsFactors = FALSE
)
write_output(unit_counts, "unit-counts.csv")
write_output(usable_by_infant, "infant-design-summary.csv")

lab_order_counts <- as.data.frame(table(
  lab_id = usable_by_infant$lab_id,
  assigned_order = usable_by_infant$assigned_order
), responseName = "infants")
lab_order_counts$assigned_order <- as.integer(as.character(lab_order_counts$assigned_order))
write_output(lab_order_counts, "lab-by-order-counts.csv")

p_units <- ggplot2::ggplot(
  usable_by_infant,
  ggplot2::aes(x = stats::reorder(lab_id, usable_trials, FUN = median), y = usable_trials)
) +
  ggplot2::geom_point(alpha = 0.22, size = 0.75, color = "grey25",
                      position = ggplot2::position_jitter(width = 0.18, height = 0)) +
  ggplot2::stat_summary(fun = median, geom = "point", color = accent, size = 1.6) +
  ggplot2::coord_flip() +
  ggplot2::labs(x = "Laboratory", y = "Included looking-time trials per infant") +
  theme_notes +
  ggplot2::theme(axis.text.y = ggplot2::element_blank(), axis.ticks.y = ggplot2::element_blank())
save_plot(p_units, "units-usable-trials-by-lab.png", width = 6.2, height = 6.0)

# -----------------------------------------------------------------------------
# Assignment and between-infant order groups
# -----------------------------------------------------------------------------

order_summary <- aggregate(
  cbind(age_months, usable_trials) ~ assigned_order,
  data = usable_by_infant,
  FUN = function(x) c(n = length(x), mean = mean(x), sd = stats::sd(x))
)
order_summary <- data.frame(
  assigned_order = order_summary$assigned_order,
  infants = as.integer(order_summary$age_months[, "n"]),
  mean_age_months = order_summary$age_months[, "mean"],
  sd_age_months = order_summary$age_months[, "sd"],
  mean_usable_trials = order_summary$usable_trials[, "mean"],
  sd_usable_trials = order_summary$usable_trials[, "sd"]
)

order_summary$north_american_english_proportion <- vapply(
  order_summary$assigned_order,
  function(order) mean(usable_by_infant$north_american_english[
    usable_by_infant$assigned_order == order
  ]),
  numeric(1)
)
write_output(order_summary, "order-allocation-summary.csv")

# The paper documents four pseudorandom trial sequences but does not specify the
# local algorithm that mapped a particular infant to an order. The following is
# thus an allocation diagnostic, not a confirmatory randomization test. It asks
# how large the observed order imbalance in lab-centered age is relative to
# within-lab relabelings that preserve each lab's realized order counts.
allocation_seed <- 20261017L
allocation_permutations <- 5000L
lab_age_mean <- ave(
  usable_by_infant$age_months,
  usable_by_infant$lab_id,
  FUN = mean
)
usable_by_infant$age_residual_within_lab <- usable_by_infant$age_months - lab_age_mean
allocation_statistic <- function(order) {
  order_means <- tapply(usable_by_infant$age_residual_within_lab, order, mean)
  diff(range(order_means))
}
observed_age_range <- allocation_statistic(usable_by_infant$assigned_order)
lab_rows <- split(seq_len(nrow(usable_by_infant)), usable_by_infant$lab_id)
set.seed(allocation_seed)
permuted_age_ranges <- replicate(allocation_permutations, {
  permuted_order <- usable_by_infant$assigned_order
  for (rows in lab_rows) {
    permuted_order[rows] <- sample(permuted_order[rows], replace = FALSE)
  }
  allocation_statistic(permuted_order)
})
allocation_reference_probability <- mean(permuted_age_ranges >= observed_age_range)
allocation_reference <- data.frame(
  seed = allocation_seed,
  permutations = allocation_permutations,
  statistic = "range of order means for lab-centered infant age in months",
  observed = observed_age_range,
  relabeling_mean = mean(permuted_age_ranges),
  relabeling_sd = stats::sd(permuted_age_ranges),
  upper_tail_probability = allocation_reference_probability,
  interpretation = paste(
    "diagnostic only: the public paper does not specify the local",
    "infant-to-order allocation algorithm"
  ),
  stringsAsFactors = FALSE
)
write_output(allocation_reference, "order-age-allocation-reference.csv")
write_output(
  data.frame(permutation = seq_along(permuted_age_ranges),
             age_mean_range_months = permuted_age_ranges),
  "order-age-allocation-permutations.csv"
)

p_allocation_reference <- ggplot2::ggplot(
  data.frame(age_mean_range_months = permuted_age_ranges),
  ggplot2::aes(x = age_mean_range_months)
) +
  ggplot2::geom_histogram(bins = 40, fill = "grey75", color = "white") +
  ggplot2::geom_vline(xintercept = observed_age_range, color = accent, linewidth = 0.8) +
  ggplot2::labs(
    x = "Range of order means for lab-centered age (months)",
    y = "Within-lab relabelings"
  ) +
  theme_notes
save_plot(p_allocation_reference, "random-assignment-age-balance-reference.png",
          width = 5.8, height = 3.7)

order_by_lab <- aggregate(
  infants ~ lab_id,
  data = lab_order_counts,
  FUN = sum
)
names(order_by_lab)[2L] <- "lab_infants"
lab_order_counts <- merge(lab_order_counts, order_by_lab, by = "lab_id")
lab_order_counts$proportion <- lab_order_counts$infants / lab_order_counts$lab_infants

p_assignment <- ggplot2::ggplot(
  lab_order_counts,
  ggplot2::aes(x = factor(assigned_order), y = stats::reorder(lab_id, lab_infants),
               fill = proportion)
) +
  ggplot2::geom_tile(color = "white", linewidth = 0.15) +
  ggplot2::scale_fill_gradient(low = "white", high = accent, limits = c(0, 1)) +
  ggplot2::labs(x = "Assigned order", y = "Laboratory", fill = "Share") +
  theme_notes +
  ggplot2::theme(axis.text.y = ggplot2::element_blank(), axis.ticks.y = ggplot2::element_blank())
save_plot(p_assignment, "random-assignment-order-by-lab.png", width = 5.4, height = 6.0)

infant_mean_log <- aggregate(
  log(looking_time_seconds) ~ infant_id,
  data = d[!d$trial_missing, ],
  FUN = mean
)
names(infant_mean_log)[2L] <- "mean_log_looking_time"
between_data <- merge(usable_by_infant, infant_mean_log, by = "infant_id", all.x = TRUE)
between_summary <- aggregate(
  mean_log_looking_time ~ assigned_order,
  data = between_data,
  FUN = function(x) c(n = length(x), mean = mean(x), sd = stats::sd(x))
)
between_summary <- data.frame(
  assigned_order = between_summary$assigned_order,
  infants_with_outcome = as.integer(between_summary$mean_log_looking_time[, "n"]),
  mean_log_looking_time = between_summary$mean_log_looking_time[, "mean"],
  sd_log_looking_time = between_summary$mean_log_looking_time[, "sd"]
)
write_output(between_summary, "between-order-outcome-summary.csv")

p_between <- ggplot2::ggplot(
  between_data[!is.na(between_data$mean_log_looking_time), ],
  ggplot2::aes(x = factor(assigned_order), y = mean_log_looking_time)
) +
  ggplot2::geom_jitter(width = 0.16, height = 0, alpha = 0.18, size = 0.8,
                       color = "grey25") +
  ggplot2::stat_summary(fun = mean, geom = "point", color = accent, size = 2.2) +
  ggplot2::labs(x = "Assigned order", y = "Infant mean log looking time") +
  theme_notes
save_plot(p_between, "between-participant-order-groups.png", width = 5.8, height = 4.0)

# -----------------------------------------------------------------------------
# Within-infant register contrast and order counterbalancing
# -----------------------------------------------------------------------------

observed <- d[!d$trial_missing & !is.na(d$register), ]
infant_register <- aggregate(
  looking_time_seconds ~ infant_id + lab_id + assigned_order + register,
  data = observed,
  FUN = mean
)
within_wide <- reshape(
  infant_register[, c("infant_id", "lab_id", "assigned_order", "register", "looking_time_seconds")],
  idvar = c("infant_id", "lab_id", "assigned_order"),
  timevar = "register",
  direction = "wide"
)
names(within_wide)[names(within_wide) == "looking_time_seconds.ADS"] <- "mean_ads_seconds"
names(within_wide)[names(within_wide) == "looking_time_seconds.IDS"] <- "mean_ids_seconds"
within_wide <- within_wide[stats::complete.cases(within_wide), ]
within_wide$difference_seconds <- within_wide$mean_ids_seconds - within_wide$mean_ads_seconds
within_summary <- data.frame(
  complete_infants = nrow(within_wide),
  mean_ads_seconds = mean(within_wide$mean_ads_seconds),
  mean_ids_seconds = mean(within_wide$mean_ids_seconds),
  mean_within_infant_difference_seconds = mean(within_wide$difference_seconds),
  sd_within_infant_difference_seconds = stats::sd(within_wide$difference_seconds),
  se_within_infant_difference_seconds = stats::sd(within_wide$difference_seconds) / sqrt(nrow(within_wide))
)
write_output(within_wide, "within-infant-register-means.csv")
write_output(within_summary, "within-infant-register-summary.csv")

p_within <- ggplot2::ggplot(
  within_wide,
  ggplot2::aes(x = mean_ads_seconds, y = mean_ids_seconds)
) +
  ggplot2::geom_abline(slope = 1, intercept = 0, color = "grey65", linewidth = 0.5) +
  ggplot2::geom_point(alpha = 0.18, size = 0.8, color = "grey20") +
  ggplot2::coord_equal(xlim = c(2, 18), ylim = c(2, 18)) +
  ggplot2::labs(x = "Mean ADS looking time (s)", y = "Mean IDS looking time (s)") +
  theme_notes
save_plot(p_within, "within-infant-ids-ads-means.png", width = 5.2, height = 5.0)

recorded_design <- d[d$trial_metadata_observed & !is.na(d$counterbalance_order), ]
order_template_register <- aggregate(
  register ~ counterbalance_order + trial_number,
  data = recorded_design,
  FUN = mode_value
)
order_template_stimulus <- aggregate(
  stimulus_id ~ counterbalance_order + trial_number,
  data = recorded_design,
  FUN = function(x) as.integer(mode_value(x))
)
order_template <- merge(
  order_template_register,
  order_template_stimulus,
  by = c("counterbalance_order", "trial_number")
)
order_template <- order_template[order(order_template$counterbalance_order,
                                       order_template$trial_number), ]
names(order_template)[1L] <- "assigned_order"

for (order in 1:4) {
  current <- order_template[order_template$assigned_order == order, ]
  assert_true(nrow(current) == 16L, "An order template is incomplete")
  assert_true(all(table(current$register) == 8L), "An order is not balanced by register")
  assert_true(all(table(current$stimulus_id) == 2L), "An order does not contain each pair twice")
  paired <- table(current$stimulus_id, current$register)
  assert_true(all(paired == 1L), "An order does not pair each stimulus across registers")
}
write_output(order_template, "counterbalance-order-template.csv")

modal_key <- paste(order_template$assigned_order, order_template$trial_number)
template_register_lookup <- setNames(order_template$register, modal_key)
template_stimulus_lookup <- setNames(order_template$stimulus_id, modal_key)
recorded_key <- paste(recorded_design$counterbalance_order, recorded_design$trial_number)
recorded_design$register_matches_template <-
  recorded_design$register == unname(template_register_lookup[recorded_key])
recorded_design$stimulus_matches_template <-
  recorded_design$stimulus_id == unname(template_stimulus_lookup[recorded_key])
template_match <- data.frame(
  recorded_metadata_rows = nrow(recorded_design),
  register_matches = sum(recorded_design$register_matches_template),
  register_match_proportion = mean(recorded_design$register_matches_template),
  stimulus_matches = sum(recorded_design$stimulus_matches_template),
  stimulus_match_proportion = mean(recorded_design$stimulus_matches_template)
)
write_output(template_match, "counterbalance-template-match.csv")

p_counterbalance <- ggplot2::ggplot(
  order_template,
  ggplot2::aes(x = trial_number, y = factor(assigned_order), fill = register)
) +
  ggplot2::geom_tile(color = "white", linewidth = 0.45) +
  ggplot2::scale_fill_manual(values = c(ADS = "grey78", IDS = accent)) +
  ggplot2::scale_x_continuous(breaks = c(1, 4, 8, 12, 16)) +
  ggplot2::labs(x = "Trial number", y = "Assigned order") +
  theme_notes
save_plot(p_counterbalance, "counterbalance-order-map.png", width = 6.4, height = 2.5)

# -----------------------------------------------------------------------------
# Official missing-outcome field and analysis-set sensitivity
# -----------------------------------------------------------------------------

retention_summary <- data.frame(
  population = c(
    "all completed possible rows", "rows with recorded trial metadata",
    "included infants", "infants with at least 2 usable trials",
    "infants with at least 4 usable trials", "infants with at least 8 usable trials"
  ),
  denominator = c(
    nrow(d), sum(d$trial_metadata_observed), length(unique(d$infant_id)),
    rep(length(unique(d$infant_id)), 3L)
  ),
  retained = c(
    sum(!d$trial_missing),
    sum(!d$trial_missing & d$trial_metadata_observed),
    length(unique(d$infant_id)),
    sum(usable_by_infant$usable_trials >= 2L),
    sum(usable_by_infant$usable_trials >= 4L),
    sum(usable_by_infant$usable_trials >= 8L)
  ),
  stringsAsFactors = FALSE
)
retention_summary$proportion <- retention_summary$retained / retention_summary$denominator
write_output(retention_summary, "analysis-set-retention.csv")

retention_by_method_trial <- aggregate(
  trial_missing ~ method + trial_number,
  data = d,
  FUN = mean
)
names(retention_by_method_trial)[3L] <- "missing_proportion"
write_output(retention_by_method_trial, "missingness-by-method-and-trial.csv")

retention_by_register <- aggregate(
  trial_missing ~ register,
  data = d[d$trial_metadata_observed, ],
  FUN = mean
)
names(retention_by_register)[2L] <- "missing_proportion"
write_output(retention_by_register, "missingness-by-register.csv")

p_exclusion <- ggplot2::ggplot(
  retention_by_method_trial,
  ggplot2::aes(x = trial_number, y = missing_proportion, linetype = method)
) +
  ggplot2::geom_line(color = "grey25", linewidth = 0.7) +
  ggplot2::geom_point(color = "grey25", size = 1.2) +
  ggplot2::scale_y_continuous(labels = function(x) paste0(round(100 * x), "%"),
                              limits = c(0, 0.72)) +
  ggplot2::scale_x_continuous(breaks = c(1, 4, 8, 12, 16)) +
  ggplot2::labs(x = "Trial number", y = "Rows without included looking time") +
  theme_notes
save_plot(p_exclusion, "exclusion-missingness-by-method.png", width = 6.0, height = 4.0)

# -----------------------------------------------------------------------------
# Compact empirical model used only to calibrate the design simulation
# -----------------------------------------------------------------------------

model_data <- observed
model_data$ids <- as.integer(model_data$register == "IDS")
model_data$trial_centered <- model_data$trial_number - mean(model_data$trial_number)
model_data$log_looking_time <- log(model_data$looking_time_seconds)

empirical_model <- lme4::lmer(
  log_looking_time ~ ids + trial_centered +
    (1 | lab_id) + (1 | infant_id) + (1 | stimulus_id),
  data = model_data,
  REML = TRUE,
  control = lme4::lmerControl(optimizer = "bobyqa")
)
assert_true(!lme4::isSingular(empirical_model), "The compact empirical model became singular")

fixed <- summary(empirical_model)$coefficients
fixed_effects <- data.frame(
  term = rownames(fixed),
  estimate = fixed[, "Estimate"],
  standard_error = fixed[, "Std. Error"],
  stringsAsFactors = FALSE
)
row.names(fixed_effects) <- NULL
write_output(fixed_effects, "empirical-model-fixed-effects.csv")

variance_components <- as.data.frame(lme4::VarCorr(empirical_model))
variance_components <- variance_components[, c("grp", "var1", "vcov", "sdcor")]
names(variance_components) <- c("group", "term", "variance", "standard_deviation")
write_output(variance_components, "empirical-model-variance-components.csv")

beta <- lme4::fixef(empirical_model)
beta_ids <- unname(beta[["ids"]])
beta_trial <- unname(beta[["trial_centered"]])
beta_intercept <- unname(beta[["(Intercept)"]])
sd_lookup <- setNames(variance_components$standard_deviation, variance_components$group)
sd_lab <- unname(sd_lookup[["lab_id"]])
sd_infant <- unname(sd_lookup[["infant_id"]])
sd_stimulus <- unname(sd_lookup[["stimulus_id"]])
sd_residual <- unname(sd_lookup[["Residual"]])

assert_close(beta_ids, 0.106804, 0.00001, "The calibrated IDS coefficient changed")
assert_true(all(c(sd_lab, sd_infant, sd_stimulus, sd_residual) > 0),
            "A calibrated variance component is nonpositive")

# Raw trial means plus fitted marginal means across trial number. The fitted
# line is conditional on zero-valued random intercepts and the fitted trial
# slope; it is not the paper's confirmatory model.
raw_register_trial <- aggregate(
  log_looking_time ~ register + trial_number,
  data = model_data,
  FUN = function(x) c(mean = mean(x), se = stats::sd(x) / sqrt(length(x)), n = length(x))
)
raw_register_trial <- data.frame(
  register = raw_register_trial$register,
  trial_number = raw_register_trial$trial_number,
  mean_log_looking_time = raw_register_trial$log_looking_time[, "mean"],
  standard_error = raw_register_trial$log_looking_time[, "se"],
  trials = as.integer(raw_register_trial$log_looking_time[, "n"])
)
raw_register_trial$fitted_log_looking_time <- beta_intercept +
  beta_ids * as.integer(raw_register_trial$register == "IDS") +
  beta_trial * (raw_register_trial$trial_number - mean(model_data$trial_number))
write_output(raw_register_trial, "empirical-model-raw-and-fitted.csv")

p_model <- ggplot2::ggplot(
  raw_register_trial,
  ggplot2::aes(x = trial_number, y = mean_log_looking_time, shape = register)
) +
  ggplot2::geom_point(color = "grey20", size = 1.6) +
  ggplot2::geom_line(ggplot2::aes(y = fitted_log_looking_time, linetype = register),
                     color = accent, linewidth = 0.75) +
  ggplot2::scale_x_continuous(breaks = c(1, 4, 8, 12, 16)) +
  ggplot2::labs(x = "Trial number", y = "Mean log looking time") +
  theme_notes
save_plot(p_model, "empirical-model-raw-and-fitted.png", width = 6.0, height = 4.0)

# -----------------------------------------------------------------------------
# Hierarchical design simulation
# -----------------------------------------------------------------------------

simulation_seed <- 20261018L
simulations_per_scenario <- 200L
set.seed(simulation_seed)

designs <- data.frame(
  scenario = c(
    "fewer labs", "baseline", "more labs",
    "fewer infants per lab", "more infants per lab",
    "fewer usable trials", "more usable trials"
  ),
  varied_dimension = c("labs", "baseline", "labs", "infants per lab",
                       "infants per lab", "usable trials", "usable trials"),
  labs = c(4L, 8L, 16L, 8L, 8L, 8L, 8L),
  infants_per_lab = c(24L, 24L, 24L, 12L, 48L, 24L, 24L),
  usable_trials_per_infant = c(8L, 8L, 8L, 8L, 8L, 4L, 16L),
  stringsAsFactors = FALSE
)

simulate_one <- function(n_labs, infants_per_lab, usable_trials_per_infant) {
  assert_true(usable_trials_per_infant %in% c(4L, 8L, 16L),
              "Usable trials must preserve complete stimulus pairs")

  infant_grid <- expand.grid(
    lab_index = seq_len(n_labs),
    infant_within_lab = seq_len(infants_per_lab)
  )
  infant_grid$lab_id <- paste0("L", infant_grid$lab_index)
  infant_grid$infant_id <- paste0(infant_grid$lab_id, ":I", infant_grid$infant_within_lab)
  infant_grid$assigned_order <- sample(1:4, nrow(infant_grid), replace = TRUE)

  pair_count <- usable_trials_per_infant / 2L
  rows <- lapply(seq_len(nrow(infant_grid)), function(i) {
    current_order <- infant_grid$assigned_order[[i]]
    pairs <- if (pair_count == 8L) 1:8 else sample(1:8, pair_count, replace = FALSE)
    template <- order_template[
      order_template$assigned_order == current_order &
        order_template$stimulus_id %in% pairs,
    ]
    template$lab_id <- infant_grid$lab_id[[i]]
    template$infant_id <- infant_grid$infant_id[[i]]
    template
  })
  sim <- do.call(rbind, rows)
  row.names(sim) <- NULL

  lab_effect <- stats::rnorm(n_labs, 0, sd_lab)
  names(lab_effect) <- paste0("L", seq_len(n_labs))
  infant_effect <- stats::rnorm(nrow(infant_grid), 0, sd_infant)
  names(infant_effect) <- infant_grid$infant_id
  stimulus_effect <- stats::rnorm(8L, 0, sd_stimulus)
  names(stimulus_effect) <- as.character(1:8)

  sim$ids <- as.integer(sim$register == "IDS")
  sim$trial_centered <- sim$trial_number - mean(model_data$trial_number)
  # Fit the null-generated response once. Adding beta_ids * ids later shifts
  # the fitted IDS coefficient by beta_ids without changing its standard error.
  sim$log_looking_time <- beta_intercept +
    beta_trial * sim$trial_centered +
    lab_effect[sim$lab_id] +
    infant_effect[sim$infant_id] +
    stimulus_effect[as.character(sim$stimulus_id)] +
    stats::rnorm(nrow(sim), 0, sd_residual)

  fit <- tryCatch(
    suppressMessages(suppressWarnings(lme4::lmer(
      log_looking_time ~ ids + trial_centered +
        (1 | lab_id) + (1 | infant_id) + (1 | stimulus_id),
      data = sim,
      REML = TRUE,
      control = lme4::lmerControl(optimizer = "bobyqa")
    ))),
    error = function(e) NULL
  )
  if (is.null(fit)) {
    return(data.frame(
      estimate_null = NA_real_, standard_error = NA_real_,
      singular = NA, converged = FALSE
    ))
  }

  coefficient <- summary(fit)$coefficients["ids", ]
  data.frame(
    estimate_null = unname(coefficient[["Estimate"]]),
    standard_error = unname(coefficient[["Std. Error"]]),
    singular = lme4::isSingular(fit, tol = 1e-4),
    converged = TRUE
  )
}

simulation_rows <- vector("list", nrow(designs) * simulations_per_scenario)
row_index <- 1L
for (i in seq_len(nrow(designs))) {
  for (simulation in seq_len(simulations_per_scenario)) {
    current <- simulate_one(
      designs$labs[[i]],
      designs$infants_per_lab[[i]],
      designs$usable_trials_per_infant[[i]]
    )
    current$scenario <- designs$scenario[[i]]
    current$simulation <- simulation
    simulation_rows[[row_index]] <- current
    row_index <- row_index + 1L
  }
}
simulation_results <- do.call(rbind, simulation_rows)
row.names(simulation_results) <- NULL
simulation_results$estimate_empirical <- simulation_results$estimate_null + beta_ids
simulation_results$reject_null_under_null <- with(
  simulation_results,
  abs(estimate_null / standard_error) > stats::qnorm(0.975)
)
simulation_results$detect_empirical_effect <- with(
  simulation_results,
  abs(estimate_empirical / standard_error) > stats::qnorm(0.975)
)
simulation_results$covers_empirical_effect <- with(
  simulation_results,
  estimate_empirical - stats::qnorm(0.975) * standard_error <= beta_ids &
    estimate_empirical + stats::qnorm(0.975) * standard_error >= beta_ids
)
write_output(simulation_results, "power-simulation-replicates.csv")

summaries <- lapply(split(simulation_results, simulation_results$scenario), function(x) {
  ok <- x$converged & is.finite(x$standard_error)
  n_ok <- sum(ok)
  data.frame(
    completed_simulations = n_ok,
    failed_simulations = sum(!ok),
    singular_proportion = mean(x$singular[ok]),
    power_at_empirical_effect = mean(x$detect_empirical_effect[ok]),
    power_mcse = sqrt(mean(x$detect_empirical_effect[ok]) *
                        (1 - mean(x$detect_empirical_effect[ok])) / n_ok),
    type_i_error_at_zero = mean(x$reject_null_under_null[ok]),
    type_i_mcse = sqrt(mean(x$reject_null_under_null[ok]) *
                         (1 - mean(x$reject_null_under_null[ok])) / n_ok),
    coverage_at_empirical_effect = mean(x$covers_empirical_effect[ok]),
    coverage_mcse = sqrt(mean(x$covers_empirical_effect[ok]) *
                           (1 - mean(x$covers_empirical_effect[ok])) / n_ok)
  )
})
simulation_summary <- do.call(rbind, summaries)
simulation_summary$scenario <- rownames(simulation_summary)
row.names(simulation_summary) <- NULL
simulation_summary <- merge(designs, simulation_summary, by = "scenario", sort = FALSE)
simulation_summary <- simulation_summary[match(designs$scenario, simulation_summary$scenario), ]
write_output(simulation_summary, "power-design-summary.csv")

assert_true(all(simulation_summary$completed_simulations >= 0.98 * simulations_per_scenario),
            "Too many simulation fits failed")
assert_true(all(simulation_summary$type_i_error_at_zero < 0.15),
            "The simulation has grossly inflated Type I error")

plot_power <- simulation_summary[simulation_summary$varied_dimension != "baseline", ]
baseline_power <- simulation_summary[simulation_summary$varied_dimension == "baseline", ]
baseline_copies <- do.call(rbind, lapply(
  c("labs", "infants per lab", "usable trials"),
  function(dimension) {
    current <- baseline_power
    current$varied_dimension <- dimension
    current
  }
))
plot_power <- rbind(plot_power, baseline_copies)
plot_power$axis_value <- ifelse(
  plot_power$varied_dimension == "labs", plot_power$labs,
  ifelse(plot_power$varied_dimension == "infants per lab", plot_power$infants_per_lab,
         plot_power$usable_trials_per_infant)
)

p_power <- ggplot2::ggplot(
  plot_power,
  ggplot2::aes(x = axis_value, y = power_at_empirical_effect)
) +
  ggplot2::geom_line(color = accent, linewidth = 0.75) +
  ggplot2::geom_point(color = accent, size = 1.8) +
  ggplot2::geom_errorbar(
    ggplot2::aes(
      ymin = pmax(0, power_at_empirical_effect - 1.96 * power_mcse),
      ymax = pmin(1, power_at_empirical_effect + 1.96 * power_mcse)
    ),
    width = 0,
    color = "grey30"
  ) +
  ggplot2::facet_wrap(~ varied_dimension, scales = "free_x", nrow = 1) +
  ggplot2::scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
  ggplot2::labs(x = "Design value", y = "Detection probability") +
  theme_notes +
  ggplot2::theme(legend.position = "none")
save_plot(p_power, "power-by-design-dimension.png", width = 7.2, height = 3.2)

simulation_settings <- data.frame(
  setting = c(
    "seed", "simulations per scenario", "target coefficient",
    "decision rule", "outcome scale", "stimulus pairs",
    "trial retention rule"
  ),
  value = c(
    simulation_seed,
    simulations_per_scenario,
    sprintf("IDS coefficient %.9f", beta_ids),
    "two-sided Wald interval excludes zero at alpha = .05",
    "log looking time",
    "eight paired stimulus IDs",
    "sample complete IDS-ADS pairs to obtain 4, 8, or 16 usable trials"
  ),
  stringsAsFactors = FALSE
)
write_output(simulation_settings, "power-simulation-settings.csv")

# -----------------------------------------------------------------------------
# Page registry and auditable assertions
# -----------------------------------------------------------------------------

page_registry <- data.frame(
  page = c(
    "units-of-assignment.qmd", "random-assignment.qmd",
    "between-participant-designs.qmd", "within-participant-designs.qmd",
    "counterbalancing.qmd", "exclusion-rules.qmd", "power-by-simulation.qmd"
  ),
  empirical_object = c(
    "16 possible trial rows nested in 2,329 infants and 67 labs",
    "realized infant allocation to four assigned trial orders by lab",
    "infant-level mean log looking time across assigned order groups",
    "paired infant means for IDS and ADS among infants observed in both registers",
    "modal released 4-by-16 order map with eight IDS-ADS stimulus pairs",
    "official missing-outcome field plus 2/4/8 usable-trial analysis sets",
    "compact log-looking-time mixed model and calibrated hierarchical simulation"
  ),
  estimand_or_target = c(
    "counts of assignment, measurement, sampling, exclusion, and analysis units",
    "realized order-allocation proportions; no causal order effect",
    "descriptive order-group means; order is a nuisance assignment",
    "mean within-infant IDS-minus-ADS difference in seconds",
    "balance of register and paired stimulus identity across sequences",
    "retention conditional on the official pipeline and stricter usable-trial thresholds",
    "probability that a two-sided Wald interval excludes zero for the fitted IDS coefficient"
  ),
  grouping_units = c(
    "trial, infant, laboratory, stimulus pair", "infant within laboratory",
    "infant within laboratory", "trial within infant within laboratory",
    "trial within assigned order; stimulus pair crossed with infant",
    "trial within infant within laboratory", "laboratory, infant, stimulus pair"
  ),
  figure = c(
    "units-usable-trials-by-lab.png", "random-assignment-age-balance-reference.png",
    "between-participant-order-groups.png", "within-infant-ids-ads-means.png",
    "counterbalance-order-map.png", "exclusion-missingness-by-method.png",
    "power-by-design-dimension.png"
  ),
  primary_output = c(
    "unit-counts.csv", "order-allocation-summary.csv",
    "between-order-outcome-summary.csv", "within-infant-register-summary.csv",
    "counterbalance-order-template.csv", "analysis-set-retention.csv",
    "power-design-summary.csv"
  ),
  paper_alignment = c(
    "uses the released post-exclusion main table and keeps all five unit roles distinct",
    "uses the paper's four pseudorandom sequences but does not infer the local allocation mechanism",
    "uses order rather than observational method as the between-infant factor",
    "uses the paper's experimental register contrast but a simple paired summary",
    "checks the release against the paper's eight-pair, four-order design",
    "uses the release's `missing` field and the paper's 2/4/8 sensitivity thresholds",
    "calibrates from a compact model; does not reproduce the paper's meta-analysis or richer confirmatory model"
  ),
  stringsAsFactors = FALSE
)
write_output(page_registry, "page-registry.csv")
jsonlite::write_json(
  page_registry,
  file.path(output_dir, "page-registry.json"),
  dataframe = "rows",
  pretty = TRUE,
  auto_unbox = TRUE,
  na = "null"
)

assertions <- data.frame(
  check = c(
    "frozen trial checksum", "trial rows", "infants", "laboratories",
    "sixteen possible rows per infant", "official missing rows",
    "completed rows without trial metadata", "infants with any included looking time",
    "infants with both registers", "four complete order templates",
    "positive fitted IDS coefficient", "power fits completed", "page registry complete"
  ),
  status = "pass",
  observed = c(
    input_specs$observed_sha256[[1L]], nrow(d), length(unique(d$infant_id)),
    length(unique(d$lab_id)), paste(range(table(d$infant_id)), collapse = "-"),
    sum(d$trial_missing), sum(!d$trial_metadata_observed),
    sum(usable_by_infant$usable_trials > 0L),
    sum(usable_by_infant$registers_with_usable_data == 2L),
    nrow(order_template) / 16L, beta_ids,
    sum(simulation_summary$completed_simulations), nrow(page_registry)
  ),
  stringsAsFactors = FALSE
)
write_output(assertions, "assertions.csv")

writeLines(capture.output(sessionInfo()), file.path(output_dir, "session-info.txt"))

cat(
  "Experimental-design reference analysis complete:\n",
  "  rows:", nrow(d), "\n",
  "  infants:", length(unique(d$infant_id)), "\n",
  "  labs:", length(unique(d$lab_id)), "\n",
  "  fitted IDS coefficient:", sprintf("%.6f", beta_ids), "\n",
  "  simulation fits:", sum(simulation_summary$completed_simulations), "\n",
  "  output:", output_dir, "\n"
)
