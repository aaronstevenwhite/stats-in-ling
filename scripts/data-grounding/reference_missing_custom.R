#!/usr/bin/env Rscript

# Paper-first reference analysis for the missing-data and custom-model notes.
#
# Run from the repository root:
#   Rscript scripts/data-grounding/reference_missing_custom.R
#
# The script writes only to
# research/dataset-audits/reference-missing-custom-output/. It does not refit
# the audited UDS Stan model. Instead, it validates and compacts the tracked
# fit and recovery artifacts produced by research/dataset-audits/uds/.

options(stringsAsFactors = FALSE)

required_packages <- c(
  "ggplot2", "jsonlite", "ragg", "lme4", "posterior", "scales"
)
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Missing required packages: ", paste(missing_packages, collapse = ", "))
}

project_root <- normalizePath(".", mustWork = TRUE)
stopifnot(
  file.exists(file.path(project_root, "_quarto.yml")),
  file.exists(file.path(project_root, "data/jacy-mrs/tanaka-selection.csv")),
  file.exists(file.path(
    project_root,
    "research/dataset-audits/uds/uds_natural_parts.stan"
  ))
)

output_dir <- file.path(
  project_root,
  "research/dataset-audits/reference-missing-custom-output"
)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

sha256_file <- function(path) {
  if (nzchar(Sys.which("shasum"))) {
    output <- system2("shasum", c("-a", "256", path), stdout = TRUE)
  } else if (nzchar(Sys.which("sha256sum"))) {
    output <- system2("sha256sum", path, stdout = TRUE)
  } else {
    stop("Neither shasum nor sha256sum is available.")
  }
  strsplit(output[[1]], "[[:space:]]+")[[1]][[1]]
}

write_csv <- function(x, name) {
  utils::write.csv(
    x,
    file.path(output_dir, name),
    row.names = FALSE,
    na = ""
  )
}

theme_course <- function() {
  ggplot2::theme_classic(base_size = 11) +
    ggplot2::theme(
      legend.position = "right",
      strip.background = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(face = "bold"),
      plot.title.position = "plot"
    )
}

save_plot <- function(plot, name, width, height) {
  ggplot2::ggsave(
    filename = file.path(output_dir, name),
    plot = plot,
    width = width,
    height = height,
    units = "in",
    dpi = 180,
    device = ragg::agg_png
  )
}

safe_logit <- function(probability) {
  stats::qlogis(pmin(pmax(probability, 1e-6), 1 - 1e-6))
}

assert_close <- function(observed, expected, tolerance, label) {
  if (any(abs(observed - expected) > tolerance)) {
    stop(label, " did not match its audited reference value.")
  }
}

input_relative_paths <- c(
  jacy = "data/jacy-mrs/tanaka-selection.csv",
  hillenbrand_raw = "data/hillenbrand-raw/hillenbrand-raw-formants.csv",
  hillenbrand_complete = "data/hillenbrand/vowels-complete.csv",
  turkish_propbank = "data/turkish-propbank/role-agreement-judgments.csv",
  uds = "data/uds/uds-natural-parts.csv",
  uds_stan = "research/dataset-audits/uds/uds_natural_parts.stan",
  uds_recovery = "research/dataset-audits/uds/results/recovery-results.csv",
  uds_parameter_summary =
    "research/dataset-audits/uds/results/real-parameter-summary.csv",
  uds_item_summary =
    "research/dataset-audits/uds/results/real-item-summary.csv",
  uds_annotator_summary =
    "research/dataset-audits/uds/results/real-annotator-summary.csv",
  uds_fit = "research/dataset-audits/uds/results/fit-objects/released-fit.rds"
)
input_paths <- setNames(
  file.path(project_root, unname(input_relative_paths)),
  names(input_relative_paths)
)

expected_input_sha256 <- c(
  jacy = "426316729b46eda77d321b5062497e7996859f433c34613e14d1056239add22c",
  hillenbrand_raw =
    "8538ef208b5caee7d9eed45e38bcf9c0aacf9f45224753aa1574433dcaf6a069",
  hillenbrand_complete =
    "de3450982779fe3ac2e914974eb0ba6a7e0f778d7328f6dbb5d5ab5a58af22c9",
  turkish_propbank =
    "fda552ea364a77fc8dee930112223638601b2d4e90135005693b996dd1e40f70",
  uds = "a9d49305fe6b4780a0f3da845bd3d6bc8ed8908c3664c6931180d4346a46e2f8",
  uds_stan =
    "5d85750a5090c6b1cd709844336372e945ec85e68f8391f0c72d7a8141329fc0",
  uds_recovery =
    "3d9c77565e4260a4aa2eb1dd7ed77a5a957116c6791ad4f232871e1392776370",
  uds_parameter_summary =
    "80551b21ff4e329396c3df3ab08b42b770fd8eb1898557cdcdf90cd6fc66a41a",
  uds_item_summary =
    "20f4b78cf4521131a8fa9cf78a27547dd3d0911309ec2fc0a15da37b04dc72fc",
  uds_annotator_summary =
    "85dddc8f6e512fc8c2318351bc559122db9a5d2e75967838686099be516d701b",
  uds_fit =
    "f48a5b9d37fc91728804366515b8c34864fa69f9ece7755f33a6007a4641005c"
)
observed_input_sha256 <- vapply(input_paths, sha256_file, character(1))
stopifnot(
  identical(names(observed_input_sha256), names(expected_input_sha256)),
  all(observed_input_sha256 == expected_input_sha256)
)
write_csv(
  data.frame(
    object = names(input_paths),
    path = sub(paste0("^", project_root, "/"), "", input_paths),
    sha256 = observed_input_sha256
  ),
  "input-checksums.csv"
)

# -----------------------------------------------------------------------------
# Jacy/Tanaka: selected grammar analyses, not usage observations
# -----------------------------------------------------------------------------

jacy <- utils::read.csv(input_paths[["jacy"]], check.names = FALSE)
stopifnot(
  nrow(jacy) == 15000L,
  ncol(jacy) == 11L,
  !anyDuplicated(paste(jacy$profile, jacy$item_id, sep = "::")),
  setequal(
    unique(jacy$coverage_state),
    c("selected_analysis", "parsed_unselected", "no_positive_reading")
  ),
  sum(jacy$selected_analysis) == 8670L,
  sum(jacy$preferred_analysis_count) == 9128L,
  sum(jacy$preferred_analysis_count > 1L) == 333L,
  sum(jacy$parse_readings == -1L) == 318L,
  sum(jacy$parser_message) == 513L,
  identical(
    jacy$selected_analysis,
    jacy$preferred_analysis_count > 0L
  ),
  all(jacy$coverage_state[jacy$selected_analysis] == "selected_analysis"),
  all(jacy$coverage_state[
    !jacy$selected_analysis & jacy$parse_readings > 0L
  ] == "parsed_unselected"),
  all(jacy$coverage_state[jacy$parse_readings <= 0L] == "no_positive_reading")
)

jacy$coverage_state <- factor(
  jacy$coverage_state,
  levels = c("selected_analysis", "parsed_unselected", "no_positive_reading"),
  labels = c("Selected analysis", "Parsed, unselected", "No positive reading")
)
jacy$selected <- as.integer(jacy$selected_analysis)
jacy$length_z <- as.numeric(scale(jacy$item_length))

jacy_pattern <- as.data.frame(table(jacy$profile, jacy$coverage_state))
names(jacy_pattern) <- c("profile", "coverage_state", "items")
jacy_pattern$proportion <- with(
  jacy_pattern,
  items / ave(items, profile, FUN = sum)
)
write_csv(jacy_pattern, "jacy-coverage-by-profile.csv")

jacy_length_summary <- stats::aggregate(
  selected ~ item_length,
  jacy,
  function(values) c(items = length(values), selected = sum(values), rate = mean(values))
)
jacy_length_summary <- data.frame(
  item_length = jacy_length_summary$item_length,
  items = jacy_length_summary$selected[, "items"],
  selected = jacy_length_summary$selected[, "selected"],
  raw_probability = jacy_length_summary$selected[, "rate"]
)

jacy_profile_only <- stats::glm(
  selected ~ profile,
  family = stats::binomial(),
  data = jacy
)
jacy_length_model <- stats::glm(
  selected ~ length_z + I(length_z^2) + profile,
  family = stats::binomial(),
  data = jacy
)
jacy$selected_fitted <- stats::predict(jacy_length_model, type = "response")
jacy_fitted_by_length <- stats::aggregate(
  selected_fitted ~ item_length,
  jacy,
  mean
)
jacy_length_summary <- merge(
  jacy_length_summary,
  jacy_fitted_by_length,
  by = "item_length",
  all.x = TRUE,
  sort = TRUE
)
jacy_lrt <- stats::anova(jacy_profile_only, jacy_length_model, test = "LRT")
jacy_coefficients <- data.frame(
  term = rownames(coef(summary(jacy_length_model))),
  coef(summary(jacy_length_model)),
  row.names = NULL,
  check.names = FALSE
)
jacy_model_summary <- data.frame(
  quantity = c(
    "items", "selected_items", "preference_records",
    "multiple_selected_results_items", "parsed_unselected_items",
    "no_positive_reading_items", "parse_minus_one_sentinels",
    "length_plus_quadratic_lrt", "length_plus_quadratic_df"
  ),
  value = c(
    nrow(jacy),
    sum(jacy$selected),
    sum(jacy$preferred_analysis_count),
    sum(jacy$preferred_analysis_count > 1L),
    sum(jacy$coverage_state == "Parsed, unselected"),
    sum(jacy$coverage_state == "No positive reading"),
    sum(jacy$parse_readings == -1L),
    jacy_lrt$Deviance[[2]],
    jacy_lrt$Df[[2]]
  )
)
write_csv(jacy_length_summary, "jacy-selection-by-length.csv")
write_csv(jacy_coefficients, "jacy-selection-model-coefficients.csv")
write_csv(jacy_model_summary, "jacy-model-summary.csv")

jacy_coverage_plot <- ggplot2::ggplot(
  jacy_pattern,
  ggplot2::aes(profile, proportion, fill = coverage_state)
) +
  ggplot2::geom_col(width = 0.78) +
  ggplot2::scale_fill_manual(
    values = c("#2B6F8A", "#9E9E9E", "#D1D1D1")
  ) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  ggplot2::labs(
    x = "Jacy profile",
    y = "Proportion of profile items",
    fill = NULL
  ) +
  theme_course() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
save_plot(jacy_coverage_plot, "jacy-coverage-by-profile.png", 7.2, 4.2)

jacy_length_plot_data <- subset(jacy_length_summary, items >= 20L)
jacy_length_plot <- ggplot2::ggplot(
  jacy_length_plot_data,
  ggplot2::aes(item_length, raw_probability)
) +
  ggplot2::geom_point(
    ggplot2::aes(size = items),
    color = "grey35",
    alpha = 0.8
  ) +
  ggplot2::geom_line(
    ggplot2::aes(y = selected_fitted),
    color = "#2B6F8A",
    linewidth = 0.9
  ) +
  ggplot2::scale_y_continuous(
    limits = c(0, 1),
    labels = scales::label_percent(accuracy = 1)
  ) +
  ggplot2::scale_size_continuous(range = c(1.5, 5), guide = "none") +
  ggplot2::labs(
    x = "Sentence length in the profile (tokens)",
    y = "Probability of a selected analysis"
  ) +
  theme_course()
save_plot(jacy_length_plot, "jacy-selection-by-length.png", 6.4, 4.0)

# -----------------------------------------------------------------------------
# Hillenbrand et al.: raw formant missingness and artificial-mask validation
# -----------------------------------------------------------------------------

hill <- utils::read.csv(input_paths[["hillenbrand_raw"]], check.names = FALSE)
hill_complete_release <- utils::read.csv(
  input_paths[["hillenbrand_complete"]],
  check.names = FALSE
)
stopifnot(
  nrow(hill) == 1668L,
  length(unique(hill$speaker_id)) == 139L,
  length(unique(hill$vowel)) == 12L,
  !anyDuplicated(hill$token_id),
  !anyDuplicated(paste(hill$speaker_id, hill$vowel, sep = "::")),
  all(table(hill$speaker_id) == 12L),
  nrow(hill_complete_release) == nrow(hill),
  !anyNA(hill_complete_release),
  length(unique(hill_complete_release$speaker_id)) == 139L,
  all(table(hill_complete_release$speaker_id) == 12L),
  sum(is.na(hill$f2_steady_hz)) == 10L,
  sum(is.na(hill$f3_steady_hz)) == 41L,
  sum(is.na(hill$f2_steady_hz) & is.na(hill$f3_steady_hz)) == 0L,
  sum(is.na(hill$f1_steady_hz)) == 0L
)

numeric_columns <- names(hill)[vapply(hill, is.numeric, logical(1))]
acoustic_columns <- c(
  "duration_ms", "f0_hz",
  grep("^f[123]_(steady|time[1-8])_hz$", names(hill), value = TRUE)
)
fallible_columns <- acoustic_columns[colSums(is.na(hill[acoustic_columns])) > 0L]
stopifnot(
  length(acoustic_columns) == 29L,
  length(fallible_columns) == 14L,
  !any(is.na(hill[c("duration_ms", "f0_hz")]))
)

missing_counts <- data.frame(
  measurement = acoustic_columns,
  missing = colSums(is.na(hill[acoustic_columns])),
  observed = colSums(!is.na(hill[acoustic_columns])),
  stringsAsFactors = FALSE
)
missing_counts <- missing_counts[missing_counts$missing > 0L, ]
missing_counts$formant <- sub("_.*$", "", missing_counts$measurement)
missing_counts$sample <- sub("^f[123]_", "", missing_counts$measurement)
missing_counts$sample <- sub("_hz$", "", missing_counts$sample)
sample_levels <- c("steady", paste0("time", 1:8))
missing_counts$sample <- factor(missing_counts$sample, levels = sample_levels)
write_csv(missing_counts, "hillenbrand-natural-missingness.csv")

steady_columns <- c(
  "duration_ms", "f0_hz", "f1_steady_hz", "f2_steady_hz", "f3_steady_hz"
)
hill$complete_steady <- stats::complete.cases(hill[steady_columns])
stopifnot(sum(hill$complete_steady) == 1617L)

complete_summary <- do.call(
  rbind,
  lapply(c("speaker_type", "vowel"), function(group) {
    counts <- as.data.frame(table(hill[[group]], hill$complete_steady))
    names(counts) <- c("level", "complete", "tokens")
    counts$variable <- group
    counts$complete <- counts$complete == "TRUE"
    counts$proportion <- with(counts, tokens / ave(tokens, level, FUN = sum))
    counts
  })
)
write_csv(complete_summary, "hillenbrand-complete-case-composition.csv")

complete_observed_summary <- do.call(
  rbind,
  lapply(c("duration_ms", "f0_hz", "f1_steady_hz"), function(measurement) {
    do.call(
      rbind,
      lapply(c(FALSE, TRUE), function(status) {
        values <- hill[[measurement]][hill$complete_steady == status]
        data.frame(
          measurement = measurement,
          complete = status,
          tokens = length(values),
          mean = mean(values),
          sd = stats::sd(values),
          median = stats::median(values),
          q25 = stats::quantile(values, 0.25),
          q75 = stats::quantile(values, 0.75)
        )
      })
    )
  })
)
write_csv(
  complete_observed_summary,
  "hillenbrand-complete-case-observed-summary.csv"
)

hill_missing_plot <- ggplot2::ggplot(
  missing_counts,
  ggplot2::aes(sample, missing, group = formant, color = formant)
) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::geom_point(size = 2) +
  ggplot2::scale_color_manual(values = c(f2 = "#2B6F8A", f3 = "grey35")) +
  ggplot2::labs(
    x = "Formant sample",
    y = "Naturally missing token measurements",
    color = NULL
  ) +
  theme_course() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
save_plot(
  hill_missing_plot,
  "hillenbrand-natural-missingness.png",
  6.4,
  3.8
)

vowel_complete <- subset(
  complete_summary,
  variable == "vowel" & complete
)
vowel_complete$incomplete_probability <- 1 - vowel_complete$proportion
vowel_complete$level <- stats::reorder(
  vowel_complete$level,
  vowel_complete$incomplete_probability
)
hill_complete_plot <- ggplot2::ggplot(
  vowel_complete,
  ggplot2::aes(incomplete_probability, level)
) +
  ggplot2::geom_col(fill = "#2B6F8A", width = 0.7) +
  ggplot2::scale_x_continuous(labels = scales::label_percent(accuracy = 1)) +
  ggplot2::labs(
    x = "Incomplete on the five steady measurements",
    y = "Vowel label"
  ) +
  theme_course()
save_plot(
  hill_complete_plot,
  "hillenbrand-complete-case-by-vowel.png",
  6.0,
  4.4
)

pca_impute <- function(
  x,
  rank,
  tolerance = 1e-6,
  max_iterations = 1000L
) {
  x <- as.matrix(x)
  storage.mode(x) <- "double"
  missing <- is.na(x)
  center <- colMeans(x, na.rm = TRUE)
  scale <- vapply(
    seq_len(ncol(x)),
    function(column) stats::sd(x[, column], na.rm = TRUE),
    numeric(1)
  )
  stopifnot(all(is.finite(center)), all(is.finite(scale)), all(scale > 0))
  standardized <- sweep(sweep(x, 2, center, "-"), 2, scale, "/")
  filled <- standardized
  filled[missing] <- 0

  if (rank == 0L) {
    reconstructed <- filled
    iterations <- 0L
    final_change <- 0
  } else {
    final_change <- Inf
    for (iteration in seq_len(max_iterations)) {
      decomposition <- base::svd(filled, nu = rank, nv = rank)
      reconstructed <- decomposition$u %*%
        diag(decomposition$d[seq_len(rank)], nrow = rank) %*%
        t(decomposition$v)
      updated <- filled
      updated[missing] <- reconstructed[missing]
      final_change <-
        sum((updated[missing] - filled[missing])^2) /
        max(sum(filled[missing]^2), .Machine$double.eps)
      filled <- updated
      if (final_change < tolerance) {
        break
      }
    }
    iterations <- iteration
    reconstructed <- filled
  }

  completed <- sweep(sweep(reconstructed, 2, scale, "*"), 2, center, "+")
  completed[!missing] <- x[!missing]
  list(
    completed = completed,
    center = center,
    scale = scale,
    iterations = iterations,
    final_change = final_change,
    converged = final_change < tolerance || rank == 0L
  )
}

make_mask <- function(
  data_matrix,
  eligible_columns,
  fraction,
  seed,
  excluded = matrix(FALSE, nrow(data_matrix), ncol(data_matrix))
) {
  set.seed(seed)
  mask <- matrix(FALSE, nrow(data_matrix), ncol(data_matrix))
  colnames(mask) <- colnames(data_matrix)
  for (column_name in eligible_columns) {
    column <- match(column_name, colnames(data_matrix))
    observed_rows <- which(!is.na(data_matrix[, column]))
    available_rows <- observed_rows[!excluded[observed_rows, column]]
    n_mask <- max(1L, floor(fraction * length(observed_rows)))
    stopifnot(length(available_rows) >= n_mask)
    selected <- sample(available_rows, n_mask, replace = FALSE)
    mask[selected, column] <- TRUE
  }
  mask
}

acoustic_matrix <- as.matrix(hill[acoustic_columns])
validation_repeats <- 8L
test_repeats <- 4L
mask_seeds <- 20261018L + seq_len(validation_repeats + test_repeats) - 1L
masks <- vector("list", length(mask_seeds))
used_mask_cells <- matrix(
  FALSE,
  nrow(acoustic_matrix),
  ncol(acoustic_matrix),
  dimnames = dimnames(acoustic_matrix)
)
for (replicate in seq_along(masks)) {
  fraction <- if (replicate <= validation_repeats) 0.05 else 0.0125
  masks[[replicate]] <- make_mask(
    acoustic_matrix,
    fallible_columns,
    fraction,
    mask_seeds[[replicate]],
    excluded = used_mask_cells
  )
  used_mask_cells <- used_mask_cells | masks[[replicate]]
}
test_holdout_union <- Reduce(
  `|`,
  masks[validation_repeats + seq_len(test_repeats)]
)

mask_registry <- do.call(
  rbind,
  lapply(seq_along(masks), function(replicate) {
    location <- which(masks[[replicate]], arr.ind = TRUE)
    data.frame(
      replicate = replicate,
      split = if (replicate <= validation_repeats) "validation" else "test",
      seed = mask_seeds[[replicate]],
      token_id = hill$token_id[location[, "row"]],
      speaker_id = hill$speaker_id[location[, "row"]],
      speaker_type = hill$speaker_type[location[, "row"]],
      vowel = hill$vowel[location[, "row"]],
      measurement = colnames(acoustic_matrix)[location[, "col"]],
      truth_hz = acoustic_matrix[location]
    )
  })
)
stopifnot(
  all(stats::complete.cases(mask_registry$truth_hz)),
  !any(duplicated(paste(
    mask_registry$token_id,
    mask_registry$measurement,
    sep = "::"
  ))),
  !anyDuplicated(paste(
    mask_registry$replicate,
    mask_registry$token_id,
    mask_registry$measurement,
    sep = "::"
  ))
)
write_csv(mask_registry, "hillenbrand-artificial-mask-cells.csv")

score_imputation <- function(rank, replicate) {
  training <- acoustic_matrix
  artificial_mask <- masks[[replicate]]
  training[artificial_mask] <- NA_real_
  if (replicate <= validation_repeats) {
    training[test_holdout_union] <- NA_real_
  }
  fit <- pca_impute(training, rank = rank)
  location <- which(artificial_mask, arr.ind = TRUE)
  truth <- acoustic_matrix[location]
  prediction <- fit$completed[location]
  training_scale <- fit$scale[location[, "col"]]
  data.frame(
    replicate = replicate,
    split = if (replicate <= validation_repeats) "validation" else "test",
    rank = rank,
    token_id = hill$token_id[location[, "row"]],
    speaker_id = hill$speaker_id[location[, "row"]],
    speaker_type = hill$speaker_type[location[, "row"]],
    vowel = hill$vowel[location[, "row"]],
    measurement = colnames(acoustic_matrix)[location[, "col"]],
    formant = sub("_.*$", "", colnames(acoustic_matrix)[location[, "col"]]),
    truth_hz = truth,
    prediction_hz = prediction,
    error_hz = prediction - truth,
    squared_standardized_error = ((prediction - truth) / training_scale)^2,
    iterations = fit$iterations,
    final_change = fit$final_change,
    converged = fit$converged
  )
}

candidate_ranks <- c(0L, 1L, 2L, 3L, 4L, 5L, 8L, 10L, 12L, 15L, 20L)
validation_predictions <- do.call(
  rbind,
  lapply(candidate_ranks, function(rank) {
    do.call(
      rbind,
      lapply(seq_len(validation_repeats), function(replicate) {
        score_imputation(rank, replicate)
      })
    )
  })
)
if (!all(validation_predictions$converged)) {
  print(unique(validation_predictions[
    !validation_predictions$converged,
    c("rank", "replicate", "iterations", "final_change")
  ]))
  stop("At least one validation imputation did not converge.")
}
validation_predictions$squared_error_hz <- validation_predictions$error_hz^2
validation_rank_curve <- stats::aggregate(
  cbind(squared_standardized_error, squared_error_hz) ~ rank,
  validation_predictions,
  mean
)
validation_rank_curve$standardized_rmse <- sqrt(
  validation_rank_curve$squared_standardized_error
)
validation_rank_curve$rmse_hz <- sqrt(validation_rank_curve$squared_error_hz)
validation_rank_curve$selected <-
  validation_rank_curve$standardized_rmse ==
  min(validation_rank_curve$standardized_rmse)
selected_rank <- validation_rank_curve$rank[validation_rank_curve$selected][[1]]
stopifnot(selected_rank > 0L)

test_predictions <- do.call(
  rbind,
  lapply(c(0L, selected_rank), function(rank) {
    do.call(
      rbind,
      lapply(
        validation_repeats + seq_len(test_repeats),
        function(replicate) score_imputation(rank, replicate)
      )
    )
  })
)
stopifnot(all(test_predictions$converged))
test_summary <- do.call(
  rbind,
  lapply(split(test_predictions, test_predictions$rank), function(data) {
    do.call(
      rbind,
      lapply(split(data, data$formant), function(formant_data) {
        data.frame(
          rank = unique(formant_data$rank),
          formant = unique(formant_data$formant),
          heldout_cells = nrow(formant_data),
          standardized_rmse = sqrt(mean(
            formant_data$squared_standardized_error
          )),
          rmse_hz = sqrt(mean(formant_data$error_hz^2)),
          mean_error_hz = mean(formant_data$error_hz)
        )
      })
    )
  })
)
rownames(test_summary) <- NULL

final_imputation <- pca_impute(acoustic_matrix, rank = selected_rank)
stopifnot(
  final_imputation$converged,
  all(final_imputation$completed[!is.na(acoustic_matrix)] ==
    acoustic_matrix[!is.na(acoustic_matrix)])
)
natural_location <- which(is.na(acoustic_matrix), arr.ind = TRUE)
natural_imputations <- data.frame(
  token_id = hill$token_id[natural_location[, "row"]],
  speaker_id = hill$speaker_id[natural_location[, "row"]],
  speaker_type = hill$speaker_type[natural_location[, "row"]],
  vowel = hill$vowel[natural_location[, "row"]],
  measurement = colnames(acoustic_matrix)[natural_location[, "col"]],
  imputed_value = final_imputation$completed[natural_location],
  selected_rank = selected_rank,
  iterations = final_imputation$iterations,
  convergence_change = final_imputation$final_change
)

write_csv(validation_rank_curve, "hillenbrand-pca-rank-curve.csv")
write_csv(
  subset(
    validation_predictions,
    rank %in% c(0L, selected_rank)
  ),
  "hillenbrand-validation-predictions.csv"
)
write_csv(test_predictions, "hillenbrand-test-predictions.csv")
write_csv(test_summary, "hillenbrand-test-summary.csv")
write_csv(natural_imputations, "hillenbrand-natural-imputations.csv")

rank_plot <- ggplot2::ggplot(
  validation_rank_curve,
  ggplot2::aes(rank, standardized_rmse)
) +
  ggplot2::geom_line(color = "grey35", linewidth = 0.8) +
  ggplot2::geom_point(color = "grey35", size = 2) +
  ggplot2::geom_point(
    data = subset(validation_rank_curve, selected),
    color = "#2B6F8A",
    size = 3
  ) +
  ggplot2::scale_x_continuous(breaks = candidate_ranks) +
  ggplot2::labs(
    x = "PCA rank",
    y = "Validation RMSE (training-standardized units)"
  ) +
  theme_course()
save_plot(rank_plot, "hillenbrand-pca-rank-selection.png", 6.2, 3.8)

selected_test_predictions <- subset(test_predictions, rank == selected_rank)
prediction_plot <- ggplot2::ggplot(
  selected_test_predictions,
  ggplot2::aes(truth_hz, prediction_hz)
) +
  ggplot2::geom_abline(slope = 1, intercept = 0, color = "grey65") +
  ggplot2::geom_point(color = "#2B6F8A", alpha = 0.35, size = 1) +
  ggplot2::facet_wrap(~ formant, scales = "free") +
  ggplot2::labs(
    x = "Held-out observed value (Hz)",
    y = "PCA reconstruction (Hz)"
  ) +
  theme_course()
save_plot(
  prediction_plot,
  "hillenbrand-heldout-reconstruction.png",
  7.0,
  3.6
)

# -----------------------------------------------------------------------------
# ITU/IMST Turkish PropBank: individual agreement with adjudication
# -----------------------------------------------------------------------------

turkish <- utils::read.csv(
  input_paths[["turkish_propbank"]],
  check.names = FALSE
)
stopifnot(
  nrow(turkish) == 55207L,
  length(unique(turkish$item_id)) == 18306L,
  length(unique(turkish$worker_id)) == 144L,
  setequal(unique(turkish$correct), 0:1),
  sum(turkish$correct) == 46078L,
  !anyDuplicated(paste(
    turkish$item_id,
    turkish$judgment_index,
    sep = "::"
  ))
)
turkish_analysis <- subset(turkish, role_group %in% c("core", "adjunct"))
turkish_analysis$role_group <- stats::relevel(
  factor(turkish_analysis$role_group),
  ref = "core"
)
stopifnot(
  nrow(turkish_analysis) == 52784L,
  length(unique(turkish_analysis$item_id)) == 17502L,
  length(unique(turkish_analysis$worker_id)) == 144L,
  sum(turkish_analysis$role_group == "core") == 36672L,
  sum(turkish_analysis$role_group == "adjunct") == 16112L,
  sum(turkish_analysis$correct[turkish_analysis$role_group == "core"]) == 33008L,
  sum(turkish_analysis$correct[turkish_analysis$role_group == "adjunct"]) == 11660L
)

turkish_raw <- do.call(
  rbind,
  lapply(split(turkish_analysis, turkish_analysis$role_group), function(data) {
    successes <- sum(data$correct)
    trials <- nrow(data)
    interval <- stats::binom.test(successes, trials)$conf.int
    data.frame(
      role_group = as.character(unique(data$role_group)),
      judgments = trials,
      agreements = successes,
      raw_probability = successes / trials,
      raw_lower = interval[[1]],
      raw_upper = interval[[2]]
    )
  })
)
rownames(turkish_raw) <- NULL

turkish_control <- lme4::glmerControl(
  optimizer = "bobyqa",
  optCtrl = list(maxfun = 200000)
)
turkish_baseline <- lme4::glmer(
  correct ~ 1 + (1 | item_id) + (1 | worker_id),
  data = turkish_analysis,
  family = stats::binomial(),
  control = turkish_control
)
turkish_role_model <- lme4::glmer(
  correct ~ role_group + (1 | item_id) + (1 | worker_id),
  data = turkish_analysis,
  family = stats::binomial(),
  control = turkish_control
)
turkish_comparison <- stats::anova(
  turkish_baseline,
  turkish_role_model,
  test = "Chisq"
)
turkish_fixed <- lme4::fixef(turkish_role_model)
turkish_coefficient <- unname(turkish_fixed[["role_groupadjunct"]])
assert_close(
  turkish_coefficient,
  -1.329326,
  1e-5,
  "Turkish PropBank role coefficient"
)
stopifnot(
  is.null(turkish_role_model@optinfo$conv$lme4$messages),
  !lme4::isSingular(turkish_role_model, tol = 1e-4),
  turkish_comparison$Chisq[[2]] > 2000
)

turkish_design <- stats::model.matrix(
  ~ role_group,
  data.frame(
    role_group = factor(c("core", "adjunct"), levels = c("core", "adjunct"))
  )
)
turkish_vcov <- as.matrix(stats::vcov(turkish_role_model))
turkish_eta <- as.vector(turkish_design %*% turkish_fixed)
turkish_eta_se <- sqrt(diag(turkish_design %*% turkish_vcov %*% t(turkish_design)))
turkish_fitted <- data.frame(
  role_group = c("core", "adjunct"),
  fitted_probability = stats::plogis(turkish_eta),
  fitted_lower = stats::plogis(turkish_eta - 1.96 * turkish_eta_se),
  fitted_upper = stats::plogis(turkish_eta + 1.96 * turkish_eta_se)
)
turkish_summary <- merge(
  turkish_raw,
  turkish_fitted,
  by = "role_group",
  sort = FALSE
)
turkish_model_summary <- data.frame(
  quantity = c(
    "individual_judgments", "ordinary_items", "workers",
    "role_coefficient_adjunct_vs_core", "likelihood_ratio_chisq",
    "likelihood_ratio_df"
  ),
  value = c(
    nrow(turkish),
    length(unique(turkish$item_id)),
    length(unique(turkish$worker_id)),
    turkish_coefficient,
    turkish_comparison$Chisq[[2]],
    turkish_comparison$Df[[2]]
  )
)
write_csv(turkish_summary, "turkish-propbank-raw-and-fitted.csv")
write_csv(turkish_model_summary, "turkish-propbank-model-summary.csv")

turkish_plot_data <- rbind(
  data.frame(
    role_group = turkish_summary$role_group,
    estimate = turkish_summary$raw_probability,
    lower = turkish_summary$raw_lower,
    upper = turkish_summary$raw_upper,
    estimate_type = "Raw"
  ),
  data.frame(
    role_group = turkish_summary$role_group,
    estimate = turkish_summary$fitted_probability,
    lower = turkish_summary$fitted_lower,
    upper = turkish_summary$fitted_upper,
    estimate_type = "Crossed model"
  )
)
turkish_plot_data$role_group <- factor(
  turkish_plot_data$role_group,
  levels = c("core", "adjunct")
)
turkish_plot <- ggplot2::ggplot(
  turkish_plot_data,
  ggplot2::aes(role_group, estimate, color = estimate_type)
) +
  ggplot2::geom_errorbar(
    ggplot2::aes(ymin = lower, ymax = upper),
    width = 0.08,
    position = ggplot2::position_dodge(width = 0.25)
  ) +
  ggplot2::geom_point(
    size = 2.4,
    position = ggplot2::position_dodge(width = 0.25)
  ) +
  ggplot2::scale_color_manual(values = c("Raw" = "grey35", "Crossed model" = "#2B6F8A")) +
  ggplot2::scale_y_continuous(
    limits = c(0.6, 1),
    labels = scales::label_percent(accuracy = 1)
  ) +
  ggplot2::labs(
    x = "Adjudicated role class",
    y = "Agreement with adjudicated description",
    color = NULL
  ) +
  theme_course()
save_plot(
  turkish_plot,
  "turkish-propbank-raw-and-fitted.png",
  6.1,
  3.8
)

# -----------------------------------------------------------------------------
# UDS natural parts: validated binary measurement model and compact draw cache
# -----------------------------------------------------------------------------

uds <- utils::read.csv(input_paths[["uds"]], check.names = FALSE)
stopifnot(
  nrow(uds) == 2955L,
  length(unique(uds$item_id)) == 1000L,
  length(unique(uds$annotator_id)) == 12L,
  setequal(unique(uds$natural_parts), 0:1),
  sum(uds$natural_parts) == 659L,
  all(table(uds$item_id) >= 2L),
  all(table(uds$item_id) <= 3L),
  !anyDuplicated(paste(uds$item_id, uds$annotator_id, sep = "::")),
  all(uds$item_id == paste(uds$graph_id, uds$node_id, sep = "%%"))
)

is_connected_bipartite <- function(item, annotator) {
  item_nodes <- paste0("item::", item)
  annotator_nodes <- paste0("annotator::", annotator)
  adjacency <- split(
    c(annotator_nodes, item_nodes),
    c(item_nodes, annotator_nodes)
  )
  all_nodes <- unique(c(item_nodes, annotator_nodes))
  seen <- setNames(rep(FALSE, length(all_nodes)), all_nodes)
  queue <- all_nodes[[1]]
  seen[[queue]] <- TRUE
  while (length(queue)) {
    node <- queue[[1]]
    queue <- queue[-1]
    neighbors <- unique(adjacency[[node]])
    new_nodes <- neighbors[!seen[neighbors]]
    if (length(new_nodes)) {
      seen[new_nodes] <- TRUE
      queue <- c(queue, new_nodes)
    }
  }
  all(seen)
}
stopifnot(is_connected_bipartite(uds$item_id, uds$annotator_id))

uds_recovery <- utils::read.csv(input_paths[["uds_recovery"]])
uds_parameter_summary <- utils::read.csv(
  input_paths[["uds_parameter_summary"]]
)
uds_item_summary <- utils::read.csv(input_paths[["uds_item_summary"]])
uds_annotator_summary <- utils::read.csv(
  input_paths[["uds_annotator_summary"]]
)
stopifnot(
  nrow(uds_recovery) == 12L,
  all(uds_recovery$divergences == 0L),
  max(uds_recovery$maximum_key_rhat) <= 1.05,
  stats::median(abs(uds_recovery$alpha_error)) <= 0.25,
  stats::median(abs(uds_recovery$sigma_item_relative_error)) <= 0.15,
  stats::median(abs(uds_recovery$sigma_annotator_relative_error)) <= 0.25,
  stats::median(uds_recovery$item_effect_correlation) >= 0.60,
  stats::median(uds_recovery$annotator_effect_correlation) >= 0.90,
  stats::median(uds_recovery$item_probability_correlation) >= 0.65,
  nrow(uds_parameter_summary) == 3L,
  nrow(uds_item_summary) == 1000L,
  nrow(uds_annotator_summary) == 12L,
  setequal(uds_item_summary$item_id, unique(uds$item_id)),
  setequal(uds_annotator_summary$annotator_id, unique(uds$annotator_id))
)

uds_fit <- readRDS(input_paths[["uds_fit"]])
stopifnot(
  identical(uds_fit$metadata$model_name, "uds_natural_parts_model"),
  uds_fit$metadata$iter_warmup == 800L,
  uds_fit$metadata$iter_sampling == 800L,
  length(uds_fit$metadata$id) == 4L,
  identical(
    as.integer(uds_fit$metadata$seed),
    c(880001L, 880002L, 880003L, 880004L)
  )
)
uds_draw_matrix <- posterior::as_draws_matrix(uds_fit$post_warmup_draws)
stopifnot(nrow(uds_draw_matrix) == 3200L)
item_effect_columns <- grep("^item_effect\\[", colnames(uds_draw_matrix), value = TRUE)
annotator_effect_columns <- grep(
  "^annotator_effect\\[",
  colnames(uds_draw_matrix),
  value = TRUE
)
stopifnot(
  length(item_effect_columns) == 1000L,
  length(annotator_effect_columns) == 12L
)

cache_draw_rows <- seq(4L, nrow(uds_draw_matrix), by = 8L)
stopifnot(length(cache_draw_rows) == 400L)
uds_cache <- list(
  provenance = list(
    source_csv = sub(paste0("^", project_root, "/"), "", input_paths[["uds"]]),
    source_csv_sha256 = observed_input_sha256[["uds"]],
    source_fit = sub(paste0("^", project_root, "/"), "", input_paths[["uds_fit"]]),
    source_fit_sha256 = observed_input_sha256[["uds_fit"]],
    stan_file = sub(paste0("^", project_root, "/"), "", input_paths[["uds_stan"]]),
    stan_sha256 = observed_input_sha256[["uds_stan"]],
    fit_seeds = as.integer(uds_fit$metadata$seed),
    warmup_per_chain = uds_fit$metadata$iter_warmup,
    retained_per_chain = uds_fit$metadata$iter_sampling,
    retained_cache_rows = cache_draw_rows
  ),
  item_levels = unique(uds$item_id),
  annotator_levels = unique(uds$annotator_id),
  population_draws = as.matrix(uds_draw_matrix[
    cache_draw_rows,
    c("alpha", "sigma_item", "sigma_annotator"),
    drop = FALSE
  ]),
  item_effect_draws = as.matrix(uds_draw_matrix[
    cache_draw_rows,
    item_effect_columns,
    drop = FALSE
  ]),
  annotator_effect_draws = as.matrix(uds_draw_matrix[
    cache_draw_rows,
    annotator_effect_columns,
    drop = FALSE
  ]),
  recovery = uds_recovery,
  parameter_summary = uds_parameter_summary,
  item_summary = uds_item_summary,
  annotator_summary = uds_annotator_summary
)
cache_path <- file.path(output_dir, "uds-natural-parts-teaching-cache.rds")
saveRDS(uds_cache, cache_path, compress = "xz")

uds$item_index <- match(uds$item_id, uds_cache$item_levels)
uds$annotator_index <- match(uds$annotator_id, uds_cache$annotator_levels)
set.seed(20261103L)
posterior_predictive <- do.call(
  rbind,
  lapply(seq_len(nrow(uds_cache$population_draws)), function(draw) {
    alpha_draw <- as.numeric(uds_cache$population_draws[draw, "alpha"])
    item_draw <- as.numeric(uds_cache$item_effect_draws[draw, ])
    annotator_draw <- as.numeric(uds_cache$annotator_effect_draws[draw, ])
    eta <-
      alpha_draw +
      item_draw[uds$item_index] +
      annotator_draw[uds$annotator_index]
    replicated <- stats::rbinom(nrow(uds), 1L, stats::plogis(eta))
    item_sums <- rowsum(replicated, uds$item_index, reorder = FALSE)
    item_counts <- rowsum(rep(1L, nrow(uds)), uds$item_index, reorder = FALSE)
    mixed <- item_sums > 0 & item_sums < item_counts
    data.frame(
      draw = draw,
      yes_rate = mean(replicated),
      mixed_item_rate = mean(mixed)
    )
  })
)
observed_item_sums <- rowsum(
  uds$natural_parts,
  uds$item_index,
  reorder = FALSE
)
observed_item_counts <- rowsum(
  rep(1L, nrow(uds)),
  uds$item_index,
  reorder = FALSE
)
uds_observed_summary <- data.frame(
  statistic = c("yes_rate", "mixed_item_rate"),
  observed = c(
    mean(uds$natural_parts),
    mean(observed_item_sums > 0 & observed_item_sums < observed_item_counts)
  )
)
uds_ppc_summary <- do.call(
  rbind,
  lapply(uds_observed_summary$statistic, function(statistic) {
    values <- posterior_predictive[[statistic]]
    data.frame(
      statistic = statistic,
      observed = uds_observed_summary$observed[
        uds_observed_summary$statistic == statistic
      ],
      predictive_lower = stats::quantile(values, 0.025),
      predictive_median = stats::median(values),
      predictive_upper = stats::quantile(values, 0.975)
    )
  })
)
rownames(uds_ppc_summary) <- NULL

uds_recovery_summary <- data.frame(
  quantity = c(
    "replicates", "median_absolute_intercept_error",
    "median_absolute_relative_item_scale_error",
    "median_absolute_relative_annotator_scale_error",
    "median_item_effect_correlation", "median_annotator_effect_correlation",
    "median_item_probability_correlation", "maximum_key_rhat",
    "divergences"
  ),
  value = c(
    nrow(uds_recovery),
    stats::median(abs(uds_recovery$alpha_error)),
    stats::median(abs(uds_recovery$sigma_item_relative_error)),
    stats::median(abs(uds_recovery$sigma_annotator_relative_error)),
    stats::median(uds_recovery$item_effect_correlation),
    stats::median(uds_recovery$annotator_effect_correlation),
    stats::median(uds_recovery$item_probability_correlation),
    max(uds_recovery$maximum_key_rhat),
    sum(uds_recovery$divergences)
  )
)
uds_release_summary <- data.frame(
  quantity = c(
    "responses", "items", "annotators", "yes_responses", "no_responses",
    "observed_yes_rate", "items_with_two_responses",
    "items_with_three_responses", "connected_bipartite_graph",
    "spearman_item_probability_vs_released_value"
  ),
  value = c(
    nrow(uds),
    length(unique(uds$item_id)),
    length(unique(uds$annotator_id)),
    sum(uds$natural_parts == 1L),
    sum(uds$natural_parts == 0L),
    mean(uds$natural_parts),
    sum(table(uds$item_id) == 2L),
    sum(table(uds$item_id) == 3L),
    1,
    stats::cor(
      uds_item_summary$average_annotator_probability_median,
      uds_item_summary$released_normalized_value,
      method = "spearman"
    )
  )
)
write_csv(uds_recovery, "uds-recovery-replicates.csv")
write_csv(uds_recovery_summary, "uds-recovery-summary.csv")
write_csv(uds_parameter_summary, "uds-parameter-summary.csv")
write_csv(uds_item_summary, "uds-item-summary.csv")
write_csv(uds_annotator_summary, "uds-annotator-summary.csv")
write_csv(posterior_predictive, "uds-posterior-predictive-draws.csv")
write_csv(uds_ppc_summary, "uds-posterior-predictive-summary.csv")
write_csv(uds_release_summary, "uds-release-summary.csv")

uds_design <- stats::aggregate(
  natural_parts ~ annotator_id,
  uds,
  function(values) c(responses = length(values), yes_rate = mean(values))
)
uds_design <- data.frame(
  annotator_id = uds_design$annotator_id,
  responses = uds_design$natural_parts[, "responses"],
  yes_rate = uds_design$natural_parts[, "yes_rate"]
)
write_csv(uds_design, "uds-annotator-design.csv")

uds_design$annotator_id <- stats::reorder(
  uds_design$annotator_id,
  uds_design$yes_rate
)
uds_design_plot <- ggplot2::ggplot(
  uds_design,
  ggplot2::aes(yes_rate, annotator_id, size = responses)
) +
  ggplot2::geom_point(color = "#2B6F8A", alpha = 0.85) +
  ggplot2::scale_x_continuous(labels = scales::label_percent(accuracy = 1)) +
  ggplot2::scale_size_continuous(range = c(2, 6), guide = "none") +
  ggplot2::labs(
    x = "Raw natural-parts yes rate",
    y = "Anonymized annotator"
  ) +
  theme_course()
save_plot(uds_design_plot, "uds-annotator-design.png", 6.2, 4.3)

recovery_plot_data <- rbind(
  data.frame(
    replicate = uds_recovery$replicate,
    quantity = "Population location",
    truth = -2.1,
    estimate = uds_recovery$alpha_estimate
  ),
  data.frame(
    replicate = uds_recovery$replicate,
    quantity = "Item scale",
    truth = 1.6,
    estimate = uds_recovery$sigma_item_estimate
  ),
  data.frame(
    replicate = uds_recovery$replicate,
    quantity = "Annotator scale",
    truth = 1.6,
    estimate = uds_recovery$sigma_annotator_estimate
  )
)
recovery_plot <- ggplot2::ggplot(
  recovery_plot_data,
  ggplot2::aes(replicate, estimate)
) +
  ggplot2::geom_hline(
    data = unique(recovery_plot_data[c("quantity", "truth")]),
    ggplot2::aes(yintercept = truth),
    color = "grey65"
  ) +
  ggplot2::geom_point(color = "#2B6F8A", alpha = 0.75, size = 2) +
  ggplot2::facet_wrap(~ quantity, scales = "free_y") +
  ggplot2::scale_x_continuous(breaks = c(1, 4, 8, 12)) +
  ggplot2::labs(
    x = "Recovery replicate",
    y = "Posterior median"
  ) +
  theme_course()
save_plot(recovery_plot, "uds-parameter-recovery.png", 7.4, 3.4)

uds_annotator_summary$annotator_id <- stats::reorder(
  uds_annotator_summary$annotator_id,
  uds_annotator_summary$annotator_effect_median
)
annotator_plot <- ggplot2::ggplot(
  uds_annotator_summary,
  ggplot2::aes(annotator_effect_median, annotator_id)
) +
  ggplot2::geom_vline(xintercept = 0, color = "grey70") +
  ggplot2::geom_errorbarh(
    ggplot2::aes(
      xmin = annotator_effect_lower,
      xmax = annotator_effect_upper
    ),
    height = 0,
    color = "grey35"
  ) +
  ggplot2::geom_point(color = "#2B6F8A", size = 2) +
  ggplot2::labs(
    x = "Annotator location effect (log odds)",
    y = "Anonymized annotator"
  ) +
  theme_course()
save_plot(annotator_plot, "uds-annotator-effects.png", 6.2, 4.4)

item_plot <- ggplot2::ggplot(
  uds_item_summary,
  ggplot2::aes(observed_proportion, average_annotator_probability_median)
) +
  ggplot2::geom_abline(slope = 1, intercept = 0, color = "grey70") +
  ggplot2::geom_point(color = "#2B6F8A", alpha = 0.25, size = 1) +
  ggplot2::scale_x_continuous(
    breaks = c(0, 1 / 3, 1 / 2, 2 / 3, 1),
    labels = c("0", "1/3", "1/2", "2/3", "1")
  ) +
  ggplot2::scale_y_continuous(limits = c(0, 1)) +
  ggplot2::labs(
    x = "Raw item yes proportion",
    y = "Posterior median item probability"
  ) +
  theme_course()
save_plot(item_plot, "uds-item-partial-pooling.png", 5.8, 4.2)

ppc_plot_data <- rbind(
  data.frame(
    statistic = "Overall yes rate",
    value = posterior_predictive$yes_rate
  ),
  data.frame(
    statistic = "Items with both responses",
    value = posterior_predictive$mixed_item_rate
  )
)
ppc_observed <- data.frame(
  statistic = c("Overall yes rate", "Items with both responses"),
  observed = uds_observed_summary$observed
)
ppc_plot <- ggplot2::ggplot(
  ppc_plot_data,
  ggplot2::aes(value)
) +
  ggplot2::geom_histogram(
    bins = 25,
    fill = "grey75",
    color = "white",
    linewidth = 0.2
  ) +
  ggplot2::geom_vline(
    data = ppc_observed,
    ggplot2::aes(xintercept = observed),
    color = "#2B6F8A",
    linewidth = 0.9
  ) +
  ggplot2::facet_wrap(~ statistic, scales = "free") +
  ggplot2::labs(
    x = "Posterior predictive statistic",
    y = "Draws"
  ) +
  theme_course()
save_plot(ppc_plot, "uds-posterior-predictive-check.png", 7.0, 3.5)

# -----------------------------------------------------------------------------
# Page registry, packages, runtime metadata, and output checksums
# -----------------------------------------------------------------------------

page_registry <- data.frame(
  order = seq_len(12L),
  page = c(
    "missing-data/missingness-patterns.qmd",
    "missing-data/missingness-mechanisms.qmd",
    "missing-data/complete-case-analysis.qmd",
    "missing-data/pca-imputation.qmd",
    "missing-data/validating-imputation.qmd",
    "custom-models/generative-stories.qmd",
    "custom-models/writing-a-joint-model.qmd",
    "custom-models/parameter-recovery.qmd",
    "custom-models/annotations-as-measurements.qmd",
    "custom-models/annotator-effects.qmd",
    "custom-models/uds-measurement-model.qmd",
    "custom-models/gated-annotations.qmd"
  ),
  dataset = c(
    "Jacy/Tanaka", "Jacy/Tanaka",
    rep("Hillenbrand et al. 1995", 3),
    rep("UDS natural parts", 3),
    "ITU/IMST Turkish PropBank",
    rep("UDS natural parts", 3)
  ),
  empirical_object = c(
    "three-state selected-analysis coverage pattern",
    "observed length/profile association with selected analysis",
    "steady-measurement complete-case indicator",
    "iterative standardized low-rank reconstruction",
    "validation-rank masks followed by untouched test masks",
    "binary gate responses over predicate-node and annotator pairs",
    "Bernoulli-logit crossed item model",
    "twelve-model recovery study on the released incidence design",
    "individual agreement with an adjudicated Turkish role description",
    "UDS annotator location effects",
    "audited UDS posterior, partial pooling, and predictive checks",
    "observed natural-parts gate only; conditional branches blocked"
  ),
  primary_figure = c(
    "jacy-coverage-by-profile.png",
    "jacy-selection-by-length.png",
    "hillenbrand-complete-case-by-vowel.png",
    "hillenbrand-pca-rank-selection.png",
    "hillenbrand-heldout-reconstruction.png",
    "uds-annotator-design.png",
    "uds-item-partial-pooling.png",
    "uds-parameter-recovery.png",
    "turkish-propbank-raw-and-fitted.png",
    "uds-annotator-effects.png",
    "uds-posterior-predictive-check.png",
    "uds-item-partial-pooling.png"
  ),
  stringsAsFactors = FALSE
)
write_csv(page_registry, "page-registry.csv")

seed_registry <- data.frame(
  purpose = c(
    paste0("Hillenbrand mask replicate ", seq_along(mask_seeds)),
    "UDS compact-cache posterior predictive draws"
  ),
  seed = c(mask_seeds, 20261103L)
)
write_csv(seed_registry, "seed-registry.csv")

package_versions <- data.frame(
  package = c("R", required_packages),
  version = c(
    paste(R.version$major, R.version$minor, sep = "."),
    vapply(
      required_packages,
      function(package) as.character(utils::packageVersion(package)),
      character(1)
    )
  )
)
write_csv(package_versions, "package-versions.csv")

results <- list(
  jacy = list(
    items = nrow(jacy),
    selected_items = sum(jacy$selected),
    preference_records = sum(jacy$preferred_analysis_count),
    selected_probability = mean(jacy$selected),
    length_linear_coefficient = unname(stats::coef(jacy_length_model)[["length_z"]]),
    length_quadratic_coefficient =
      unname(stats::coef(jacy_length_model)[["I(length_z^2)"]]),
    length_profile_lrt = unname(jacy_lrt$Deviance[[2]])
  ),
  hillenbrand = list(
    tokens = nrow(hill),
    complete_steady_tokens = sum(hill$complete_steady),
    natural_missing_cells = nrow(natural_imputations),
    selected_rank = selected_rank,
    validation_standardized_rmse = min(validation_rank_curve$standardized_rmse),
    test = split(test_summary, seq_len(nrow(test_summary)))
  ),
  turkish_propbank = list(
    judgments = nrow(turkish),
    primary_judgments = nrow(turkish_analysis),
    role_coefficient = turkish_coefficient,
    likelihood_ratio_chisq = unname(turkish_comparison$Chisq[[2]]),
    raw = split(turkish_summary, seq_len(nrow(turkish_summary)))
  ),
  uds = list(
    responses = nrow(uds),
    items = length(unique(uds$item_id)),
    annotators = length(unique(uds$annotator_id)),
    yes_rate = mean(uds$natural_parts),
    ppc = split(uds_ppc_summary, seq_len(nrow(uds_ppc_summary))),
    cache_sha256 = sha256_file(cache_path)
  )
)
jsonlite::write_json(
  results,
  file.path(output_dir, "reference-results.json"),
  auto_unbox = TRUE,
  pretty = TRUE,
  digits = 16,
  na = "null"
)

session_lines <- capture.output(utils::sessionInfo())
writeLines(session_lines, file.path(output_dir, "session-info.txt"))

assertion_lines <- c(
  "PASS: every input checksum matches its pinned audit artifact",
  "PASS: Jacy profile-item keys are unique and the three coverage states reconcile",
  "PASS: 9,128 Jacy preference records resolve to 8,670 selected items",
  "PASS: Jacy parse_readings = -1 is retained as a parser sentinel, not a count",
  "PASS: Hillenbrand token and speaker-vowel keys are unique",
  "PASS: Hillenbrand artificial masks contain only naturally observed cells",
  paste0("PASS: Hillenbrand rank ", selected_rank, " was selected on validation masks only"),
  "PASS: Hillenbrand test masks were untouched during rank selection",
  "PASS: PCA preprocessing is estimated after masking and observed cells are unchanged",
  "PASS: Turkish PropBank judgment keys and audited role counts reconcile",
  "PASS: Turkish PropBank model retains crossed item and worker intercepts",
  "PASS: UDS item-annotator observations are unique and the bipartite graph is connected",
  "PASS: the UDS fit and twelve recovery fits satisfy the frozen diagnostic gates",
  "PASS: the compact UDS cache is traceable to the audited Stan file and fit object",
  "PASS: UDS raw confidence and conditional follow-up branches are not analyzed"
)
writeLines(assertion_lines, file.path(output_dir, "assertions.txt"))

output_files <- list.files(output_dir, full.names = TRUE)
output_files <- output_files[basename(output_files) != "output-checksums.csv"]
output_checksums <- data.frame(
  file = basename(output_files),
  bytes = file.info(output_files)$size,
  sha256 = vapply(output_files, sha256_file, character(1))
)
output_checksums <- output_checksums[order(output_checksums$file), ]
write_csv(output_checksums, "output-checksums.csv")

cat(
  paste(
    "Reference missing/custom analysis passed.",
    paste0("Jacy: ", sum(jacy$selected), "/", nrow(jacy), " selected items."),
    paste0(
      "Hillenbrand: ", sum(hill$complete_steady), "/", nrow(hill),
      " steady complete cases; validation selected rank ", selected_rank, "."
    ),
    paste0(
      "Turkish PropBank: adjunct coefficient ",
      format(round(turkish_coefficient, 3), nsmall = 3), "."
    ),
    paste0(
      "UDS: ", sum(uds$natural_parts), "/", nrow(uds),
      " affirmative natural-parts responses."
    ),
    sep = "\n"
  ),
  "\n"
)
