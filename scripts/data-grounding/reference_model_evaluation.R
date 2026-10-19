#!/usr/bin/env Rscript

# Paper-first reference analysis for model criticism and prediction.
#
# This script does not edit the notes or source data. It verifies three prepared
# linguistic datasets, constructs every split and fitted object used by the
# model-evaluation sequence, and writes compact tables plus restrained figures.

source("scripts/data-grounding/common.R")

required_packages <- c("digest", "ggplot2", "ordinal", "loo")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Missing packages: ", paste(missing_packages, collapse = ", "))
}

started_at <- Sys.time()
output_dir <- file.path(
  "research", "dataset-audits", "reference-model-evaluation-output"
)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

seeds <- data.frame(
  object = c(
    "Natural Stories random-row folds",
    "Natural Stories participant folds",
    "Natural Stories display sample",
    "Natural Stories bias-variance calibration",
    "Provo simple posterior draws",
    "Provo quadratic posterior draws",
    "MegaOrientation verb bootstrap"
  ),
  seed = c(20261031L, 20261101L, 20261102L, 20261103L,
           20261104L, 20261105L, 20261106L),
  stringsAsFactors = FALSE
)

write_csv <- function(x, filename) {
  utils::write.csv(
    x,
    file.path(output_dir, filename),
    row.names = FALSE,
    na = ""
  )
}

theme_reference <- function() {
  ggplot2::theme_classic(base_size = 11) +
    ggplot2::theme(
      legend.position = "top",
      strip.background = ggplot2::element_blank(),
      plot.title.position = "plot"
    )
}

save_plot <- function(plot, filename, width = 6.4, height = 4.2) {
  ggplot2::ggsave(
    file.path(output_dir, filename),
    plot = plot,
    width = width,
    height = height,
    dpi = 180,
    bg = "white"
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

# -----------------------------------------------------------------------------
# Frozen inputs
# -----------------------------------------------------------------------------

natural_path <- file.path(
  "data", "natural-stories", "natural-stories-corrected.rds"
)
provo_path <- file.path("data", "provo", "content-word-positions.csv")
orientation_path <- file.path(
  "data", "megaorientation", "megaorientation-v1.1.tsv"
)
orientation_fold_path <- file.path(
  "data", "megaorientation", "verb-folds-multiframe.csv"
)

input_checksums <- data.frame(
  dataset = c(
    "Natural Stories corrected RTs",
    "Provo content-word positions",
    "MegaOrientation v1.1 judgments",
    "MegaOrientation multiframe verb folds"
  ),
  path = c(
    natural_path, provo_path, orientation_path, orientation_fold_path
  ),
  expected_sha256 = c(
    "42dd15e854d7c019f672569bbdf902b246f7745aa35d97a70422717e114cb19c",
    "458a5233347c5e5e1b80e9d73a14b448d90bbd7031bd80b295b096d74f50e914",
    "f16d22239cd419b386252e253e28e5f5db0daa9d7877fba130ae0815408ab205",
    "ba5f8d32f9c0db2170f585d92aa5d36ab63ed4b7d0eb37303487d6231056c7d7"
  ),
  stringsAsFactors = FALSE
)
input_checksums$observed_sha256 <- vapply(
  input_checksums$path,
  sha256_file,
  character(1)
)
input_checksums$matches <- with(
  input_checksums,
  expected_sha256 == observed_sha256
)
record_assertion(
  "all prepared inputs match frozen checksums",
  all(input_checksums$matches),
  paste(input_checksums$matches, collapse = ","),
  "all TRUE"
)
write_csv(input_checksums, "input-checksums.csv")
write_csv(seeds, "seed-registry.csv")

# -----------------------------------------------------------------------------
# Natural Stories: prediction units, loss, and validation
# -----------------------------------------------------------------------------

natural_all <- readRDS(natural_path)
record_assertion(
  "Natural Stories prepared row count",
  nrow(natural_all) == 848875L,
  nrow(natural_all),
  848875L
)
record_assertion(
  "Natural Stories participant count",
  length(unique(natural_all$participant_id)) == 180L,
  length(unique(natural_all$participant_id)),
  180L
)
record_assertion(
  "Natural Stories story count",
  length(unique(natural_all$story_id)) == 10L,
  length(unique(natural_all$story_id)),
  10L
)

natural_all$row_id <- seq_len(nrow(natural_all))
complete_prediction_row <- with(
  natural_all,
  is.finite(log_rt) & is.finite(word_length) &
    is.finite(log_unigram_frequency) & is.finite(gpt3_surprisal)
)
natural <- natural_all[complete_prediction_row, c(
  "row_id", "participant_id", "story_id", "sentence_id", "word_position",
  "word", "word_length", "log_rt", "log_unigram_frequency",
  "gpt3_surprisal"
)]
row.names(natural) <- NULL
rm(natural_all)

record_assertion(
  "Natural Stories prediction rows",
  nrow(natural) == 846537L,
  nrow(natural),
  846537L,
  "Rows with finite frequency and GPT-3 surprisal."
)
natural$position_id <- paste(
  natural$story_id, natural$word_position, sep = ":"
)

prediction_target_inventory <- data.frame(
  object = c(
    "retained response row", "participant", "story", "sentence",
    "story-position", "participant-story pass"
  ),
  count = c(
    nrow(natural),
    length(unique(natural$participant_id)),
    length(unique(natural$story_id)),
    length(unique(natural$sentence_id)),
    length(unique(natural$position_id)),
    length(unique(paste(natural$participant_id, natural$story_id, sep = ":")))
  ),
  interpretation = c(
    "one retained button latency for one reader at one word position",
    "reader grouping unit",
    "deliberately construction-enriched text grouping unit",
    "released sentence unit nested within story",
    "contextual word position repeated across readers",
    "one reader's retained pass through one story"
  ),
  stringsAsFactors = FALSE
)
write_csv(prediction_target_inventory, "natural-stories-target-inventory.csv")

# Group variation is descriptive. It makes the prediction units visible without
# treating row-level responses as independent evidence about texts or readers.
participant_means <- stats::aggregate(
  natural$log_rt,
  list(group_id = natural$participant_id),
  mean
)
names(participant_means)[2L] <- "mean_log_rt"
participant_means$unit <- "Participant"
participant_means$n_rows <- as.integer(table(natural$participant_id)[
  participant_means$group_id
])
story_means <- stats::aggregate(
  natural$log_rt,
  list(group_id = natural$story_id),
  mean
)
names(story_means)[2L] <- "mean_log_rt"
story_means$group_id <- as.character(story_means$group_id)
story_means$unit <- "Story"
story_means$n_rows <- as.integer(table(natural$story_id)[story_means$group_id])
target_variation <- rbind(participant_means, story_means)
target_variation$rank_within_unit <- ave(
  target_variation$mean_log_rt,
  target_variation$unit,
  FUN = function(x) rank(x, ties.method = "first")
)
write_csv(target_variation, "natural-stories-target-variation.csv")

target_plot <- ggplot2::ggplot(
  target_variation,
  ggplot2::aes(rank_within_unit, mean_log_rt)
) +
  ggplot2::geom_point(size = 1.2, alpha = 0.7, color = "grey25") +
  ggplot2::facet_wrap(~ unit, scales = "free_x") +
  ggplot2::labs(
    x = "Group rank by mean response",
    y = "Mean log reading time"
  ) +
  theme_reference()
save_plot(target_plot, "natural-stories-prediction-units.png")

make_balanced_folds <- function(units, folds, seed) {
  units <- sort(unique(as.character(units)))
  set.seed(seed)
  shuffled <- sample(units, length(units), replace = FALSE)
  assigned <- rep(seq_len(folds), length.out = length(shuffled))
  data.frame(
    unit = shuffled,
    fold = assigned,
    stringsAsFactors = FALSE
  )
}

set.seed(seeds$seed[seeds$object == "Natural Stories random-row folds"])
row_order <- sample.int(nrow(natural), nrow(natural), replace = FALSE)
row_fold <- integer(nrow(natural))
row_fold[row_order] <- rep(1:5, length.out = nrow(natural))

participant_fold_map <- make_balanced_folds(
  natural$participant_id,
  5L,
  seeds$seed[seeds$object == "Natural Stories participant folds"]
)
participant_fold_lookup <- stats::setNames(
  participant_fold_map$fold,
  participant_fold_map$unit
)
participant_fold <- unname(participant_fold_lookup[natural$participant_id])
story_fold <- natural$story_id
names(participant_fold_map)[1L] <- "participant_id"
write_csv(participant_fold_map, "natural-stories-participant-folds.csv")

record_assertion(
  "Natural Stories participant groups do not cross folds",
  all(vapply(
    split(participant_fold, natural$participant_id),
    function(x) length(unique(x)) == 1L,
    logical(1)
  )),
  "all participant fold counts equal one",
  TRUE
)
record_assertion(
  "Natural Stories stories do not cross leave-one-story-out folds",
  all(vapply(
    split(story_fold, natural$story_id),
    function(x) length(unique(x)) == 1L,
    logical(1)
  )),
  "all story fold counts equal one",
  TRUE
)

fit_fold_linear <- function(data, train, test, predictors) {
  center <- vapply(data[train, predictors, drop = FALSE], mean, numeric(1))
  scale <- vapply(data[train, predictors, drop = FALSE], stats::sd, numeric(1))
  if (any(!is.finite(scale) | scale <= 0)) {
    stop("A training-fold predictor has zero or invalid scale.")
  }
  train_matrix <- sweep(
    as.matrix(data[train, predictors, drop = FALSE]), 2L, center, "-"
  )
  train_matrix <- sweep(train_matrix, 2L, scale, "/")
  test_matrix <- sweep(
    as.matrix(data[test, predictors, drop = FALSE]), 2L, center, "-"
  )
  test_matrix <- sweep(test_matrix, 2L, scale, "/")
  train_design <- cbind("(Intercept)" = 1, train_matrix)
  test_design <- cbind("(Intercept)" = 1, test_matrix)
  fit <- stats::lm.fit(train_design, data$log_rt[train])
  if (anyNA(fit$coefficients)) stop("Rank-deficient Natural Stories fold fit.")
  list(
    prediction = drop(test_design %*% fit$coefficients),
    center = center,
    scale = scale,
    coefficients = fit$coefficients
  )
}

cross_validated_predictions <- function(data, fold, predictors) {
  prediction <- rep(NA_real_, nrow(data))
  fold_objects <- vector("list", length(unique(fold)))
  fold_values <- sort(unique(fold))
  for (j in seq_along(fold_values)) {
    current <- fold_values[[j]]
    test <- fold == current
    train <- !test
    fit <- fit_fold_linear(data, train, test, predictors)
    prediction[test] <- fit$prediction
    fold_objects[[j]] <- list(
      fold = current,
      n_train = sum(train),
      n_test = sum(test),
      center = fit$center,
      scale = fit$scale,
      coefficients = fit$coefficients
    )
  }
  if (any(!is.finite(prediction))) stop("Incomplete cross-validated prediction.")
  list(prediction = prediction, folds = fold_objects)
}

base_predictors <- c("word_length", "log_unigram_frequency")
extended_predictors <- c(
  "word_length", "log_unigram_frequency", "gpt3_surprisal"
)

row_cv <- cross_validated_predictions(natural, row_fold, extended_predictors)
participant_cv <- cross_validated_predictions(
  natural, participant_fold, extended_predictors
)
story_cv <- cross_validated_predictions(
  natural, story_fold, extended_predictors
)
story_cv_base <- cross_validated_predictions(
  natural, story_fold, base_predictors
)

score_folds <- function(y, prediction, fold, split_target) {
  rows <- lapply(sort(unique(fold)), function(current) {
    keep <- fold == current
    error <- y[keep] - prediction[keep]
    data.frame(
      split_target = split_target,
      fold = as.character(current),
      held_out_rows = sum(keep),
      rmse_log_rt = sqrt(mean(error^2)),
      mae_log_rt = mean(abs(error)),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

split_scores <- rbind(
  score_folds(natural$log_rt, row_cv$prediction, row_fold,
              "new row; represented readers and stories"),
  score_folds(natural$log_rt, participant_cv$prediction, participant_fold,
              "new participant; represented stories"),
  score_folds(natural$log_rt, story_cv$prediction, story_fold,
              "new enriched story; represented reader population")
)
row.names(split_scores) <- NULL
write_csv(split_scores, "natural-stories-validation-scores.csv")

record_assertion(
  "Natural Stories validation predictions are complete",
  all(is.finite(c(
    row_cv$prediction, participant_cv$prediction,
    story_cv$prediction, story_cv_base$prediction
  ))),
  "all finite",
  TRUE
)

# One participant-held-out fold supplies the concrete train/test calculation.
test_fold <- 1L
test_rows <- participant_fold == test_fold
train_test_assignment <- data.frame(
  set = c("training", "test"),
  rows = c(sum(!test_rows), sum(test_rows)),
  participants = c(
    length(unique(natural$participant_id[!test_rows])),
    length(unique(natural$participant_id[test_rows]))
  ),
  stories = c(
    length(unique(natural$story_id[!test_rows])),
    length(unique(natural$story_id[test_rows]))
  ),
  mean_log_rt = c(
    mean(natural$log_rt[!test_rows]),
    mean(natural$log_rt[test_rows])
  ),
  stringsAsFactors = FALSE
)
write_csv(train_test_assignment, "natural-stories-train-test-assignment.csv")

test_error <- natural$log_rt[test_rows] - participant_cv$prediction[test_rows]
test_participant <- natural$participant_id[test_rows]
participant_mse <- stats::aggregate(
  test_error^2,
  list(participant_id = test_participant),
  mean
)
participant_mae <- stats::aggregate(
  abs(test_error),
  list(participant_id = test_participant),
  mean
)
predictive_loss_summary <- data.frame(
  averaging_unit = c("response row", "participant"),
  n_units = c(length(test_error), nrow(participant_mse)),
  mse_log_rt = c(mean(test_error^2), mean(participant_mse$x)),
  rmse_log_rt = c(
    sqrt(mean(test_error^2)), sqrt(mean(participant_mse$x))
  ),
  mae_log_rt = c(mean(abs(test_error)), mean(participant_mae$x)),
  stringsAsFactors = FALSE
)
write_csv(predictive_loss_summary, "natural-stories-predictive-loss.csv")

prediction_decile <- cut(
  participant_cv$prediction[test_rows],
  breaks = unique(stats::quantile(
    participant_cv$prediction[test_rows],
    probs = seq(0, 1, length.out = 11L),
    names = FALSE
  )),
  include.lowest = TRUE,
  ordered_result = TRUE
)
calibration_data <- data.frame(
  observed = natural$log_rt[test_rows],
  predicted = participant_cv$prediction[test_rows],
  decile = prediction_decile
)
calibration_bins <- do.call(rbind, lapply(
  split(calibration_data, calibration_data$decile),
  function(rows) data.frame(
    decile = as.character(rows$decile[[1]]),
    n = nrow(rows),
    mean_predicted = mean(rows$predicted),
    mean_observed = mean(rows$observed),
    se_observed = stats::sd(rows$observed) / sqrt(nrow(rows))
  )
))
row.names(calibration_bins) <- NULL
write_csv(calibration_bins, "natural-stories-test-calibration.csv")

set.seed(seeds$seed[seeds$object == "Natural Stories display sample"])
display_rows <- sample.int(
  nrow(calibration_data),
  min(12000L, nrow(calibration_data)),
  replace = FALSE
)
calibration_plot <- ggplot2::ggplot(
  calibration_data[display_rows, ],
  ggplot2::aes(predicted, observed)
) +
  ggplot2::geom_point(size = 0.45, alpha = 0.08, color = "grey30") +
  ggplot2::geom_abline(
    slope = 1, intercept = 0, color = "grey55", linewidth = 0.45
  ) +
  ggplot2::geom_errorbar(
    data = calibration_bins,
    ggplot2::aes(
      x = mean_predicted,
      y = mean_observed,
      ymin = mean_observed - 1.96 * se_observed,
      ymax = mean_observed + 1.96 * se_observed
    ),
    inherit.aes = FALSE,
    width = 0,
    linewidth = 0.45,
    color = "#2B6CB0"
  ) +
  ggplot2::geom_point(
    data = calibration_bins,
    ggplot2::aes(mean_predicted, mean_observed),
    inherit.aes = FALSE,
    size = 1.7,
    color = "#2B6CB0"
  ) +
  ggplot2::labs(
    x = "Held-out predicted log reading time",
    y = "Observed log reading time"
  ) +
  theme_reference()
save_plot(calibration_plot, "natural-stories-train-test-calibration.png")

split_scores$split_label <- factor(
  split_scores$split_target,
  levels = c(
    "new row; represented readers and stories",
    "new participant; represented stories",
    "new enriched story; represented reader population"
  ),
  labels = c("Row", "Participant", "Story")
)
split_plot <- ggplot2::ggplot(
  split_scores,
  ggplot2::aes(split_label, rmse_log_rt)
) +
  ggplot2::geom_point(
    position = ggplot2::position_jitter(width = 0.08, height = 0),
    size = 1.6,
    alpha = 0.75,
    color = "grey25"
  ) +
  ggplot2::labs(
    x = "Held-out unit",
    y = "Fold RMSE (log reading time)"
  ) +
  theme_reference()
save_plot(split_plot, "natural-stories-validation-targets.png")

# The bias-variance demonstration is a simulation calibrated to empirical
# position means. It is not an estimate of the unknown Natural Stories
# data-generating process. Predictor values and resampled residuals come from
# the corrected corpus; the fitted cubic reference is explicitly assumed true.
position_means <- stats::aggregate(
  natural[c(
    "log_rt", "word_length", "log_unigram_frequency", "gpt3_surprisal"
  )],
  list(position_id = natural$position_id),
  mean
)
scale_names <- c("word_length", "log_unigram_frequency", "gpt3_surprisal")
position_centers <- vapply(position_means[scale_names], mean, numeric(1))
position_scales <- vapply(position_means[scale_names], stats::sd, numeric(1))
for (name in scale_names) {
  position_means[[paste0(name, "_z")]] <-
    (position_means[[name]] - position_centers[[name]]) /
    position_scales[[name]]
}
linear_formula <- stats::as.formula(
  "log_rt ~ word_length_z + log_unigram_frequency_z + gpt3_surprisal_z"
)
cubic_formula <- stats::as.formula(paste(
  "log_rt ~ word_length_z + I(word_length_z^2) + I(word_length_z^3) +",
  "log_unigram_frequency_z + I(log_unigram_frequency_z^2) +",
  "I(log_unigram_frequency_z^3) + gpt3_surprisal_z +",
  "I(gpt3_surprisal_z^2) + I(gpt3_surprisal_z^3)"
))
reference_fit <- stats::lm(cubic_formula, data = position_means)
reference_residuals <- stats::residuals(reference_fit)

target_distance <- with(
  position_means,
  (gpt3_surprisal - stats::quantile(gpt3_surprisal, 0.90))^2 /
      stats::var(gpt3_surprisal) +
    (log_unigram_frequency - stats::median(log_unigram_frequency))^2 /
      stats::var(log_unigram_frequency) +
    (word_length - stats::median(word_length))^2 /
      stats::var(word_length)
)
target_position <- position_means[which.min(target_distance), ]
truth_at_target <- as.numeric(stats::predict(reference_fit, target_position))

set.seed(seeds$seed[
  seeds$object == "Natural Stories bias-variance calibration"
])
n_repetitions <- 300L
training_positions <- 400L
simulation_predictions <- vector("list", n_repetitions * 2L)
for (repetition in seq_len(n_repetitions)) {
  sampled <- sample.int(
    nrow(position_means), training_positions, replace = TRUE
  )
  training <- position_means[sampled, ]
  training$log_rt <- as.numeric(stats::predict(reference_fit, training)) +
    sample(reference_residuals, training_positions, replace = TRUE)
  fit_linear <- stats::lm(linear_formula, data = training)
  fit_cubic <- stats::lm(cubic_formula, data = training)
  simulation_predictions[[2L * repetition - 1L]] <- data.frame(
    repetition = repetition,
    procedure = "Linear",
    prediction = as.numeric(stats::predict(fit_linear, target_position))
  )
  simulation_predictions[[2L * repetition]] <- data.frame(
    repetition = repetition,
    procedure = "Cubic",
    prediction = as.numeric(stats::predict(fit_cubic, target_position))
  )
}
simulation_predictions <- do.call(rbind, simulation_predictions)
irreducible_variance <- mean(reference_residuals^2)
bias_variance <- do.call(rbind, lapply(
  split(simulation_predictions$prediction, simulation_predictions$procedure),
  function(values) {
    bias <- mean(values) - truth_at_target
    variance <- mean((values - mean(values))^2)
    data.frame(
      empirical_target_position = target_position$position_id,
      assumed_true_mean_log_rt = truth_at_target,
      training_positions_per_repetition = training_positions,
      repetitions = n_repetitions,
      prediction_mean = mean(values),
      bias = bias,
      bias_squared = bias^2,
      prediction_variance = variance,
      irreducible_variance = irreducible_variance,
      expected_squared_error = bias^2 + variance + irreducible_variance,
      stringsAsFactors = FALSE
    )
  }
))
bias_variance$procedure <- rownames(bias_variance)
row.names(bias_variance) <- NULL
write_csv(bias_variance, "natural-stories-bias-variance.csv")
write_csv(
  simulation_predictions,
  "natural-stories-bias-variance-predictions.csv"
)

bias_variance_plot <- ggplot2::ggplot(
  simulation_predictions,
  ggplot2::aes(procedure, prediction)
) +
  ggplot2::geom_violin(
    fill = "grey88", color = "grey45", linewidth = 0.4, width = 0.8
  ) +
  ggplot2::geom_point(
    data = bias_variance,
    ggplot2::aes(procedure, prediction_mean),
    inherit.aes = FALSE,
    size = 2,
    color = "#2B6CB0"
  ) +
  ggplot2::geom_hline(
    yintercept = truth_at_target,
    color = "grey25",
    linewidth = 0.5
  ) +
  ggplot2::labs(
    x = "Learning procedure",
    y = "Predicted mean log reading time"
  ) +
  theme_reference()
save_plot(bias_variance_plot, "natural-stories-bias-variance.png")

# Story-level comparison retains all ten scores so that no broad text-population
# claim is hidden behind a single pooled number.
story_comparison <- do.call(rbind, lapply(1:10, function(story) {
  keep <- natural$story_id == story
  base_error <- natural$log_rt[keep] - story_cv_base$prediction[keep]
  extended_error <- natural$log_rt[keep] - story_cv$prediction[keep]
  data.frame(
    story_id = story,
    n_rows = sum(keep),
    base_rmse = sqrt(mean(base_error^2)),
    extended_rmse = sqrt(mean(extended_error^2)),
    base_minus_extended_rmse =
      sqrt(mean(base_error^2)) - sqrt(mean(extended_error^2)),
    base_mae = mean(abs(base_error)),
    extended_mae = mean(abs(extended_error)),
    stringsAsFactors = FALSE
  )
}))
write_csv(story_comparison, "natural-stories-story-model-comparison.csv")

story_comparison_plot <- ggplot2::ggplot(
  story_comparison,
  ggplot2::aes(factor(story_id), base_minus_extended_rmse)
) +
  ggplot2::geom_hline(
    yintercept = 0, color = "grey55", linewidth = 0.45
  ) +
  ggplot2::geom_point(size = 1.8, color = "#2B6CB0") +
  ggplot2::labs(
    x = "Held-out story",
    y = "RMSE reduction after adding GPT-3 surprisal"
  ) +
  theme_reference()
save_plot(story_comparison_plot, "natural-stories-story-loss-differences.png")

# Keep the exact training-fold transformations for the singled-out train/test
# split. These values make the no-leakage calculation reproducible on the page.
fold_one_object <- participant_cv$folds[[
  which(vapply(
    participant_cv$folds,
    function(x) x$fold == test_fold,
    logical(1)
  ))
]]
fold_one_preprocessing <- data.frame(
  predictor = names(fold_one_object$center),
  training_mean = unname(fold_one_object$center),
  training_sd = unname(fold_one_object$scale),
  stringsAsFactors = FALSE
)
write_csv(
  fold_one_preprocessing,
  "natural-stories-training-preprocessing.csv"
)

# -----------------------------------------------------------------------------
# MegaOrientation: grouped prediction for entirely unseen verbs
# -----------------------------------------------------------------------------

orientation <- utils::read.delim(
  orientation_path,
  stringsAsFactors = FALSE,
  check.names = FALSE
)
orientation_folds <- utils::read.csv(
  orientation_fold_path,
  stringsAsFactors = FALSE
)
orientation <- merge(
  orientation,
  orientation_folds[c("verb", "fold")],
  by = "verb",
  sort = FALSE
)
record_assertion(
  "MegaOrientation multiframe comparison rows",
  nrow(orientation) == 39440L,
  nrow(orientation),
  39440L
)
record_assertion(
  "MegaOrientation multiframe verb count",
  length(unique(orientation$verb)) == 662L,
  length(unique(orientation$verb)),
  662L
)
record_assertion(
  "MegaOrientation verbs do not cross folds",
  all(vapply(
    split(orientation$fold, orientation$verb),
    function(x) length(unique(x)) == 1L,
    logical(1)
  )),
  "all verb fold counts equal one",
  TRUE
)

orientation$outcome <- ordered(orientation$response, levels = 1:7)
orientation$orientation <- factor(
  orientation$orientation,
  levels = c("past", "future")
)
orientation$frame_code <- factor(orientation$frame_code)

ordinal_probabilities <- function(fit, newdata, fixed_formula) {
  design <- stats::model.matrix(fixed_formula, newdata)
  missing_columns <- setdiff(names(fit$beta), colnames(design))
  if (length(missing_columns)) {
    stop("Prediction matrix is missing: ", paste(missing_columns, collapse = ", "))
  }
  eta <- drop(design[, names(fit$beta), drop = FALSE] %*% fit$beta)
  cumulative <- stats::plogis(outer(
    eta,
    fit$alpha,
    function(linear_predictor, threshold) threshold - linear_predictor
  ))
  probability <- cbind(
    cumulative[, 1L],
    cumulative[, 2:ncol(cumulative), drop = FALSE] -
      cumulative[, 1:(ncol(cumulative) - 1L), drop = FALSE],
    1 - cumulative[, ncol(cumulative)]
  )
  probability <- pmax(probability, 1e-12)
  probability / rowSums(probability)
}

orientation_prediction_rows <- vector("list", 5L)
orientation_fold_rows <- vector("list", 5L)
for (fold in 1:5) {
  train <- orientation[orientation$fold != fold, ]
  test <- orientation[orientation$fold == fold, ]
  restricted <- ordinal::clm(
    outcome ~ orientation + frame_code,
    data = train,
    link = "logit",
    Hess = FALSE,
    control = ordinal::clm.control(maxIter = 200L, gradTol = 1e-3)
  )
  interaction <- ordinal::clm(
    outcome ~ orientation * frame_code,
    data = train,
    link = "logit",
    Hess = FALSE,
    control = ordinal::clm.control(maxIter = 200L, gradTol = 1e-3)
  )
  restricted_probability <- ordinal_probabilities(
    restricted, test, ~ orientation + frame_code
  )
  interaction_probability <- ordinal_probabilities(
    interaction, test, ~ orientation * frame_code
  )
  observed_index <- cbind(seq_len(nrow(test)), as.integer(test$outcome))
  restricted_log_score <- log(restricted_probability[observed_index])
  interaction_log_score <- log(interaction_probability[observed_index])
  orientation_prediction_rows[[fold]] <- data.frame(
    verb = test$verb,
    fold = fold,
    restricted_log_score = restricted_log_score,
    interaction_log_score = interaction_log_score,
    stringsAsFactors = FALSE
  )
  orientation_fold_rows[[fold]] <- data.frame(
    fold = fold,
    held_out_verbs = length(unique(test$verb)),
    held_out_rows = nrow(test),
    restricted_mean_log_score = mean(restricted_log_score),
    interaction_mean_log_score = mean(interaction_log_score),
    interaction_minus_restricted = mean(
      interaction_log_score - restricted_log_score
    ),
    stringsAsFactors = FALSE
  )
}
orientation_predictions <- do.call(rbind, orientation_prediction_rows)
orientation_fold_scores <- do.call(rbind, orientation_fold_rows)
orientation_verb_scores <- stats::aggregate(
  orientation_predictions[c(
    "restricted_log_score", "interaction_log_score"
  )],
  list(
    verb = orientation_predictions$verb,
    fold = orientation_predictions$fold
  ),
  mean
)
orientation_verb_scores$interaction_minus_restricted <- with(
  orientation_verb_scores,
  interaction_log_score - restricted_log_score
)

set.seed(seeds$seed[seeds$object == "MegaOrientation verb bootstrap"])
orientation_bootstrap <- replicate(
  999L,
  mean(sample(
    orientation_verb_scores$interaction_minus_restricted,
    nrow(orientation_verb_scores),
    replace = TRUE
  ))
)
orientation_comparison_summary <- data.frame(
  held_out_rows = nrow(orientation_predictions),
  held_out_verbs = nrow(orientation_verb_scores),
  row_weighted_mean_gain = mean(
    orientation_predictions$interaction_log_score -
      orientation_predictions$restricted_log_score
  ),
  verb_weighted_mean_gain = mean(
    orientation_verb_scores$interaction_minus_restricted
  ),
  conditional_verb_bootstrap_low = stats::quantile(
    orientation_bootstrap, 0.025, names = FALSE
  ),
  conditional_verb_bootstrap_high = stats::quantile(
    orientation_bootstrap, 0.975, names = FALSE
  ),
  folds_favoring_interaction = sum(
    orientation_fold_scores$interaction_minus_restricted > 0
  ),
  stringsAsFactors = FALSE
)
record_assertion(
  "MegaOrientation interaction improves all frozen folds",
  orientation_comparison_summary$folds_favoring_interaction == 5L,
  orientation_comparison_summary$folds_favoring_interaction,
  5L
)
write_csv(orientation_fold_scores, "megaorientation-fold-scores.csv")
write_csv(orientation_verb_scores, "megaorientation-verb-scores.csv")
write_csv(
  orientation_comparison_summary,
  "megaorientation-comparison-summary.csv"
)

orientation_loss_plot <- ggplot2::ggplot(
  orientation_verb_scores,
  ggplot2::aes(factor(fold), interaction_minus_restricted)
) +
  ggplot2::geom_hline(
    yintercept = 0, color = "grey55", linewidth = 0.45
  ) +
  ggplot2::geom_point(
    position = ggplot2::position_jitter(width = 0.12, height = 0),
    size = 0.8,
    alpha = 0.35,
    color = "grey25"
  ) +
  ggplot2::geom_point(
    data = orientation_fold_scores,
    ggplot2::aes(factor(fold), interaction_minus_restricted),
    inherit.aes = FALSE,
    size = 2,
    color = "#2B6CB0"
  ) +
  ggplot2::labs(
    x = "Held-out verb fold",
    y = "Interaction minus restricted mean log score"
  ) +
  theme_reference()
save_plot(
  orientation_loss_plot,
  "megaorientation-unseen-verb-loss-differences.png"
)

# Full-data fits provide a raw-plus-fit check on the same represented rows.
orientation_restricted_full <- ordinal::clm(
  outcome ~ orientation + frame_code,
  data = orientation,
  link = "logit",
  Hess = FALSE
)
orientation_interaction_full <- ordinal::clm(
  outcome ~ orientation * frame_code,
  data = orientation,
  link = "logit",
  Hess = FALSE
)
orientation_grid <- expand.grid(
  orientation = levels(orientation$orientation),
  frame_code = levels(orientation$frame_code),
  stringsAsFactors = FALSE
)
orientation_grid$orientation <- factor(
  orientation_grid$orientation,
  levels = levels(orientation$orientation)
)
orientation_grid$frame_code <- factor(
  orientation_grid$frame_code,
  levels = levels(orientation$frame_code)
)
orientation_fit_probability <- ordinal_probabilities(
  orientation_interaction_full,
  orientation_grid,
  ~ orientation * frame_code
)
orientation_empirical <- as.data.frame(table(
  orientation$frame_code,
  orientation$orientation,
  orientation$outcome,
  dnn = c("frame_code", "orientation", "rating")
))
names(orientation_empirical)[4L] <- "count"
orientation_empirical$empirical_probability <- ave(
  orientation_empirical$count,
  orientation_empirical$frame_code,
  orientation_empirical$orientation,
  FUN = function(x) x / sum(x)
)
orientation_fitted <- do.call(rbind, lapply(
  seq_len(nrow(orientation_grid)),
  function(i) data.frame(
    frame_code = as.character(orientation_grid$frame_code[i]),
    orientation = as.character(orientation_grid$orientation[i]),
    rating = as.character(1:7),
    fitted_probability = orientation_fit_probability[i, ],
    stringsAsFactors = FALSE
  )
))
orientation_calibration <- merge(
  orientation_empirical,
  orientation_fitted,
  by = c("frame_code", "orientation", "rating"),
  sort = FALSE
)
write_csv(orientation_calibration, "megaorientation-raw-and-fitted.csv")

orientation_calibration$rating <- as.integer(orientation_calibration$rating)
orientation_raw_fit_plot <- ggplot2::ggplot(
  orientation_calibration,
  ggplot2::aes(rating, empirical_probability, color = orientation)
) +
  ggplot2::geom_point(size = 1.4, alpha = 0.75) +
  ggplot2::geom_line(
    ggplot2::aes(y = fitted_probability),
    linewidth = 0.55
  ) +
  ggplot2::facet_wrap(~ frame_code) +
  ggplot2::scale_color_manual(
    values = c("past" = "grey35", "future" = "#2B6CB0")
  ) +
  ggplot2::scale_x_continuous(breaks = 1:7) +
  ggplot2::labs(
    x = "Acceptability rating",
    y = "Response probability",
    color = "Forced orientation"
  ) +
  theme_reference()
save_plot(
  orientation_raw_fit_plot,
  "megaorientation-raw-and-fitted.png",
  width = 7.2,
  height = 4.7
)

# -----------------------------------------------------------------------------
# Provo: matched likelihood, exact LOO, PSIS-LOO, and WAIC
# -----------------------------------------------------------------------------

provo <- utils::read.csv(provo_path, stringsAsFactors = FALSE)
record_assertion("Provo position count", nrow(provo) == 1593L,
                 nrow(provo), 1593L)
record_assertion(
  "Provo passage count",
  length(unique(provo$Text_ID)) == 55L,
  length(unique(provo$Text_ID)),
  55L
)
provo$cloze_surprisal_bits <- -log2(provo$OrthoMatchModel)

provo_simple <- stats::lm(
  mean_log_ffd ~ cloze_surprisal_bits,
  data = provo
)
provo_quadratic <- stats::lm(
  mean_log_ffd ~ cloze_surprisal_bits + I(cloze_surprisal_bits^2),
  data = provo
)
simple_log_likelihood <- as.numeric(stats::logLik(provo_simple))
quadratic_log_likelihood <- as.numeric(stats::logLik(provo_quadratic))
lr_statistic <- 2 * (quadratic_log_likelihood - simple_log_likelihood)
lr_df <- attr(stats::logLik(provo_quadratic), "df") -
  attr(stats::logLik(provo_simple), "df")
likelihood_ratio <- data.frame(
  restricted_model = "linear cloze-surprisal mean",
  expanded_model = "linear plus quadratic cloze-surprisal mean",
  n_positions = nrow(provo),
  restricted_log_likelihood = simple_log_likelihood,
  expanded_log_likelihood = quadratic_log_likelihood,
  likelihood_ratio_statistic = lr_statistic,
  degrees_of_freedom = lr_df,
  p_value = stats::pchisq(lr_statistic, df = lr_df, lower.tail = FALSE),
  stringsAsFactors = FALSE
)
record_assertion(
  "Provo likelihood-ratio nesting adds one mean parameter",
  lr_df == 1,
  lr_df,
  1
)
write_csv(likelihood_ratio, "provo-likelihood-ratio.csv")

information_criteria <- data.frame(
  model = c("Linear", "Quadratic"),
  mean_parameters = c(2L, 3L),
  likelihood_parameters = c(
    attr(stats::logLik(provo_simple), "df"),
    attr(stats::logLik(provo_quadratic), "df")
  ),
  log_likelihood = c(simple_log_likelihood, quadratic_log_likelihood),
  aic = c(stats::AIC(provo_simple), stats::AIC(provo_quadratic)),
  bic = c(stats::BIC(provo_simple), stats::BIC(provo_quadratic)),
  stringsAsFactors = FALSE
)
information_criteria$delta_aic <-
  information_criteria$aic - min(information_criteria$aic)
information_criteria$delta_bic <-
  information_criteria$bic - min(information_criteria$bic)
record_assertion(
  "Provo AIC and BIC expose a real penalty disagreement",
  information_criteria$model[which.min(information_criteria$aic)] == "Quadratic" &&
    information_criteria$model[which.min(information_criteria$bic)] == "Linear",
  paste(
    information_criteria$model[which.min(information_criteria$aic)],
    information_criteria$model[which.min(information_criteria$bic)],
    sep = "/"
  ),
  "Quadratic/Linear"
)
write_csv(information_criteria, "provo-information-criteria.csv")

provo_grid <- data.frame(
  cloze_surprisal_bits = seq(
    min(provo$cloze_surprisal_bits),
    max(provo$cloze_surprisal_bits),
    length.out = 200L
  )
)
provo_grid$linear_fit <- stats::predict(provo_simple, provo_grid)
provo_grid$quadratic_fit <- stats::predict(provo_quadratic, provo_grid)
write_csv(provo_grid, "provo-fitted-curves.csv")

provo_raw_fit_plot <- ggplot2::ggplot(
  provo,
  ggplot2::aes(cloze_surprisal_bits, mean_log_ffd)
) +
  ggplot2::geom_point(size = 0.75, alpha = 0.22, color = "grey25") +
  ggplot2::geom_line(
    data = provo_grid,
    ggplot2::aes(y = linear_fit, linetype = "Linear"),
    linewidth = 0.7,
    color = "grey25"
  ) +
  ggplot2::geom_line(
    data = provo_grid,
    ggplot2::aes(y = quadratic_fit, linetype = "Quadratic"),
    linewidth = 0.7,
    color = "#2B6CB0"
  ) +
  ggplot2::scale_linetype_manual(values = c("Linear" = 2, "Quadratic" = 1)) +
  ggplot2::labs(
    x = "Modeled cloze surprisal (bits)",
    y = "Mean log first-fixation duration",
    linetype = "Mean model"
  ) +
  theme_reference()
save_plot(provo_raw_fit_plot, "provo-raw-and-fitted-models.png")

ic_long <- rbind(
  data.frame(
    model = information_criteria$model,
    criterion = "AIC",
    delta = information_criteria$delta_aic
  ),
  data.frame(
    model = information_criteria$model,
    criterion = "BIC",
    delta = information_criteria$delta_bic
  )
)
ic_plot <- ggplot2::ggplot(
  ic_long,
  ggplot2::aes(model, delta)
) +
  ggplot2::geom_point(size = 2, color = "#2B6CB0") +
  ggplot2::facet_wrap(~ criterion, scales = "free_y") +
  ggplot2::labs(x = NULL, y = "Difference from best score") +
  theme_reference()
save_plot(ic_plot, "provo-information-criteria.png")

make_study_calibrated_nig_prior <- function(X) {
  # The source paper reports removing fixations below 80 ms and above 800 ms.
  # These study-level bounds fix the prior without using any held-out response
  # or any data-derived centering and scaling operation.
  response_log_bounds <- log(c(80, 800))
  response_log_span <- diff(response_log_bounds)
  prior_sigma2_mean <- (response_log_span / 4)^2
  prior_mean <- c(mean(response_log_bounds), rep(0, ncol(X) - 1L))
  names(prior_mean) <- colnames(X)
  list(
    b0 = prior_mean,
    V0 = diag(rep(
      response_log_span^2 / prior_sigma2_mean,
      ncol(X)
    )),
    a0 = 3,
    d0 = 2 * prior_sigma2_mean,
    response_lower_ms = 80,
    response_upper_ms = 800
  )
}

nig_posterior <- function(X, y, prior) {
  V0_inverse <- solve(prior$V0)
  Vn <- solve(V0_inverse + crossprod(X))
  bn <- drop(Vn %*% (V0_inverse %*% prior$b0 + crossprod(X, y)))
  an <- prior$a0 + length(y) / 2
  dn <- as.numeric(
    prior$d0 + 0.5 * (
      crossprod(y) +
        t(prior$b0) %*% V0_inverse %*% prior$b0 -
        t(bn) %*% solve(Vn) %*% bn
    )
  )
  list(Vn = Vn, bn = bn, an = an, dn = dn)
}

draw_nig <- function(posterior, draws, seed, column_names) {
  set.seed(seed)
  sigma2 <- 1 / stats::rgamma(
    draws,
    shape = posterior$an,
    rate = posterior$dn
  )
  standard_normal <- matrix(
    stats::rnorm(draws * length(posterior$bn)),
    nrow = draws
  )
  beta <- matrix(
    posterior$bn,
    nrow = draws,
    ncol = length(posterior$bn),
    byrow = TRUE
  ) + sweep(
    standard_normal %*% chol(posterior$Vn),
    1L,
    sqrt(sigma2),
    "*"
  )
  colnames(beta) <- column_names
  list(beta = beta, sigma2 = sigma2)
}

log_likelihood_matrix <- function(X, y, draws) {
  mu <- draws$beta %*% t(X)
  standardized <- sweep(mu, 2L, y, "-")
  standardized <- sweep(standardized, 1L, sqrt(draws$sigma2), "/")
  -0.5 * log(2 * pi) - 0.5 * log(draws$sigma2) - 0.5 * standardized^2
}

exact_nig_loo <- function(X, y, prior) {
  n <- nrow(X)
  p <- ncol(X)
  V0_inverse <- solve(prior$V0)
  full_xtx <- crossprod(X)
  full_xty <- crossprod(X, y)
  full_yty <- sum(y^2)
  result <- data.frame(
    observation = seq_len(n),
    predictive_location = NA_real_,
    predictive_scale = NA_real_,
    predictive_df = NA_real_,
    log_predictive_density = NA_real_,
    stringsAsFactors = FALSE
  )
  for (i in seq_len(n)) {
    xi <- matrix(X[i, ], nrow = 1L)
    yi <- y[[i]]
    Vn <- solve(V0_inverse + full_xtx - crossprod(xi))
    bn <- drop(Vn %*% (
      V0_inverse %*% prior$b0 + full_xty - drop(xi) * yi
    ))
    an <- prior$a0 + (n - 1L) / 2
    dn <- as.numeric(
      prior$d0 + 0.5 * (
        full_yty - yi^2 +
          t(prior$b0) %*% V0_inverse %*% prior$b0 -
          t(bn) %*% solve(Vn) %*% bn
      )
    )
    location <- drop(xi %*% bn)
    scale <- sqrt((dn / an) * (1 + drop(xi %*% Vn %*% t(xi))))
    degrees <- 2 * an
    result$predictive_location[i] <- location
    result$predictive_scale[i] <- scale
    result$predictive_df[i] <- degrees
    result$log_predictive_density[i] <-
      stats::dt((yi - location) / scale, df = degrees, log = TRUE) -
      log(scale)
  }
  result
}

X_simple <- stats::model.matrix(provo_simple)
X_quadratic <- stats::model.matrix(provo_quadratic)
y_provo <- provo$mean_log_ffd
prior_simple <- make_study_calibrated_nig_prior(X_simple)
prior_quadratic <- make_study_calibrated_nig_prior(X_quadratic)
posterior_simple <- nig_posterior(X_simple, y_provo, prior_simple)
posterior_quadratic <- nig_posterior(X_quadratic, y_provo, prior_quadratic)

posterior_draw_count <- 4000L
draws_simple <- draw_nig(
  posterior_simple,
  posterior_draw_count,
  seeds$seed[seeds$object == "Provo simple posterior draws"],
  colnames(X_simple)
)
draws_quadratic <- draw_nig(
  posterior_quadratic,
  posterior_draw_count,
  seeds$seed[seeds$object == "Provo quadratic posterior draws"],
  colnames(X_quadratic)
)
log_lik_simple <- log_likelihood_matrix(X_simple, y_provo, draws_simple)
log_lik_quadratic <- log_likelihood_matrix(
  X_quadratic, y_provo, draws_quadratic
)

exact_loo_simple <- exact_nig_loo(X_simple, y_provo, prior_simple)
exact_loo_quadratic <- exact_nig_loo(
  X_quadratic, y_provo, prior_quadratic
)
exact_loo <- data.frame(
  observation = seq_len(nrow(provo)),
  position_id = provo$position_id,
  Text_ID = provo$Text_ID,
  cloze_surprisal_bits = provo$cloze_surprisal_bits,
  observed_mean_log_ffd = y_provo,
  linear_predictive_location = exact_loo_simple$predictive_location,
  quadratic_predictive_location = exact_loo_quadratic$predictive_location,
  linear_log_predictive_density =
    exact_loo_simple$log_predictive_density,
  quadratic_log_predictive_density =
    exact_loo_quadratic$log_predictive_density,
  quadratic_minus_linear_log_predictive_density =
    exact_loo_quadratic$log_predictive_density -
      exact_loo_simple$log_predictive_density,
  stringsAsFactors = FALSE
)
exact_loo_summary <- data.frame(
  model = c("Linear", "Quadratic"),
  n_omitted_position_fits = nrow(provo),
  exact_elpd_loo = c(
    sum(exact_loo_simple$log_predictive_density),
    sum(exact_loo_quadratic$log_predictive_density)
  ),
  exact_loo_rmse = c(
    sqrt(mean((y_provo - exact_loo_simple$predictive_location)^2)),
    sqrt(mean((y_provo - exact_loo_quadratic$predictive_location)^2))
  ),
  stringsAsFactors = FALSE
)
write_csv(exact_loo, "provo-exact-loo-pointwise.csv")
write_csv(exact_loo_summary, "provo-exact-loo-summary.csv")

# These are independent conjugate posterior draws rather than autocorrelated
# MCMC draws, so the relative effective sample size is one for every position.
loo_simple <- loo::loo(log_lik_simple, r_eff = rep(1, ncol(log_lik_simple)))
loo_quadratic <- loo::loo(
  log_lik_quadratic,
  r_eff = rep(1, ncol(log_lik_quadratic))
)
pareto_simple <- loo::pareto_k_values(loo_simple)
pareto_quadratic <- loo::pareto_k_values(loo_quadratic)
psis_pointwise <- data.frame(
  observation = seq_len(nrow(provo)),
  position_id = provo$position_id,
  Text_ID = provo$Text_ID,
  cloze_surprisal_bits = provo$cloze_surprisal_bits,
  linear_elpd_loo = loo_simple$pointwise[, "elpd_loo"],
  quadratic_elpd_loo = loo_quadratic$pointwise[, "elpd_loo"],
  linear_pareto_k = pareto_simple,
  quadratic_pareto_k = pareto_quadratic,
  stringsAsFactors = FALSE
)
psis_summary <- data.frame(
  model = c("Linear", "Quadratic"),
  psis_elpd_loo = c(
    loo_simple$estimates["elpd_loo", "Estimate"],
    loo_quadratic$estimates["elpd_loo", "Estimate"]
  ),
  psis_elpd_se = c(
    loo_simple$estimates["elpd_loo", "SE"],
    loo_quadratic$estimates["elpd_loo", "SE"]
  ),
  p_loo = c(
    loo_simple$estimates["p_loo", "Estimate"],
    loo_quadratic$estimates["p_loo", "Estimate"]
  ),
  max_pareto_k = c(max(pareto_simple), max(pareto_quadratic)),
  positions_pareto_k_over_0_7 = c(
    sum(pareto_simple > 0.7), sum(pareto_quadratic > 0.7)
  ),
  exact_elpd_loo = exact_loo_summary$exact_elpd_loo,
  psis_minus_exact_elpd = c(
    loo_simple$estimates["elpd_loo", "Estimate"] -
      exact_loo_summary$exact_elpd_loo[1L],
    loo_quadratic$estimates["elpd_loo", "Estimate"] -
      exact_loo_summary$exact_elpd_loo[2L]
  ),
  stringsAsFactors = FALSE
)
write_csv(psis_pointwise, "provo-psis-loo-pointwise.csv")
write_csv(psis_summary, "provo-psis-loo-summary.csv")

record_assertion(
  "Provo PSIS approximates exact conjugate LOO",
  max(abs(psis_summary$psis_minus_exact_elpd)) < 0.5,
  max(abs(psis_summary$psis_minus_exact_elpd)),
  "absolute total ELPD error < 0.5"
)

stable_log_mean_exp <- function(x) {
  maximum <- max(x)
  maximum + log(mean(exp(x - maximum)))
}
manual_waic <- function(log_lik) {
  lppd <- apply(log_lik, 2L, stable_log_mean_exp)
  p_waic <- apply(log_lik, 2L, stats::var)
  data.frame(
    lppd = lppd,
    p_waic = p_waic,
    elpd_waic = lppd - p_waic,
    stringsAsFactors = FALSE
  )
}
waic_simple_object <- loo::waic(log_lik_simple)
waic_quadratic_object <- loo::waic(log_lik_quadratic)
waic_simple_point <- manual_waic(log_lik_simple)
waic_quadratic_point <- manual_waic(log_lik_quadratic)
waic_pointwise <- data.frame(
  observation = seq_len(nrow(provo)),
  position_id = provo$position_id,
  Text_ID = provo$Text_ID,
  cloze_surprisal_bits = provo$cloze_surprisal_bits,
  linear_lppd = waic_simple_point$lppd,
  linear_p_waic = waic_simple_point$p_waic,
  linear_elpd_waic = waic_simple_point$elpd_waic,
  quadratic_lppd = waic_quadratic_point$lppd,
  quadratic_p_waic = waic_quadratic_point$p_waic,
  quadratic_elpd_waic = waic_quadratic_point$elpd_waic,
  stringsAsFactors = FALSE
)
waic_summary <- data.frame(
  model = c("Linear", "Quadratic"),
  elpd_waic = c(
    waic_simple_object$estimates["elpd_waic", "Estimate"],
    waic_quadratic_object$estimates["elpd_waic", "Estimate"]
  ),
  elpd_waic_se = c(
    waic_simple_object$estimates["elpd_waic", "SE"],
    waic_quadratic_object$estimates["elpd_waic", "SE"]
  ),
  p_waic = c(
    waic_simple_object$estimates["p_waic", "Estimate"],
    waic_quadratic_object$estimates["p_waic", "Estimate"]
  ),
  waic_deviance = c(
    waic_simple_object$estimates["waic", "Estimate"],
    waic_quadratic_object$estimates["waic", "Estimate"]
  ),
  stringsAsFactors = FALSE
)
write_csv(waic_pointwise, "provo-waic-pointwise.csv")
write_csv(waic_summary, "provo-waic-summary.csv")

record_assertion(
  "manual and loo-package WAIC agree",
  max(abs(
    waic_summary$elpd_waic -
      c(sum(waic_simple_point$elpd_waic),
        sum(waic_quadratic_point$elpd_waic))
  )) < 1e-8,
  max(abs(
    waic_summary$elpd_waic -
      c(sum(waic_simple_point$elpd_waic),
        sum(waic_quadratic_point$elpd_waic))
  )),
  "< 1e-8"
)

provo_prior <- rbind(
  data.frame(
    model = "Linear", term = names(prior_simple$b0),
    prior_mean = prior_simple$b0,
    conditional_variance_multiplier = diag(prior_simple$V0)
  ),
  data.frame(
    model = "Quadratic", term = names(prior_quadratic$b0),
    prior_mean = prior_quadratic$b0,
    conditional_variance_multiplier = diag(prior_quadratic$V0)
  )
)
provo_prior$inverse_gamma_shape <- 3
provo_prior$inverse_gamma_rate <- rep(
  c(prior_simple$d0, prior_quadratic$d0),
  c(ncol(X_simple), ncol(X_quadratic))
)
provo_prior$response_lower_ms <- 80
provo_prior$response_upper_ms <- 800
provo_prior$calibration <- paste(
  "fixed from source-study fixation bounds; no data-derived centering,",
  "scaling, or response values used"
)
write_csv(provo_prior, "provo-fixed-priors.csv")

loo_display <- exact_loo[order(exact_loo$cloze_surprisal_bits), ]
loo_plot <- ggplot2::ggplot(
  provo,
  ggplot2::aes(cloze_surprisal_bits, mean_log_ffd)
) +
  ggplot2::geom_point(size = 0.7, alpha = 0.18, color = "grey25") +
  ggplot2::geom_line(
    data = loo_display,
    ggplot2::aes(y = linear_predictive_location, linetype = "Linear"),
    linewidth = 0.65,
    color = "grey25"
  ) +
  ggplot2::geom_line(
    data = loo_display,
    ggplot2::aes(y = quadratic_predictive_location, linetype = "Quadratic"),
    linewidth = 0.65,
    color = "#2B6CB0"
  ) +
  ggplot2::scale_linetype_manual(values = c("Linear" = 2, "Quadratic" = 1)) +
  ggplot2::labs(
    x = "Modeled cloze surprisal (bits)",
    y = "Observed and LOO-predicted mean log FFD",
    linetype = "LOO mean"
  ) +
  theme_reference()
save_plot(loo_plot, "provo-exact-loo-predictions.png")

psis_long <- rbind(
  data.frame(
    cloze_surprisal_bits = psis_pointwise$cloze_surprisal_bits,
    model = "Linear",
    pareto_k = psis_pointwise$linear_pareto_k
  ),
  data.frame(
    cloze_surprisal_bits = psis_pointwise$cloze_surprisal_bits,
    model = "Quadratic",
    pareto_k = psis_pointwise$quadratic_pareto_k
  )
)
psis_plot <- ggplot2::ggplot(
  psis_long,
  ggplot2::aes(cloze_surprisal_bits, pareto_k)
) +
  ggplot2::geom_hline(
    yintercept = 0.7, color = "grey55", linewidth = 0.45, linetype = 2
  ) +
  ggplot2::geom_point(size = 0.7, alpha = 0.35, color = "grey25") +
  ggplot2::facet_wrap(~ model) +
  ggplot2::labs(
    x = "Modeled cloze surprisal (bits)",
    y = "Pareto k"
  ) +
  theme_reference()
save_plot(psis_plot, "provo-psis-pareto-k.png")

waic_loo_plot_data <- data.frame(
  cloze_surprisal_bits = provo$cloze_surprisal_bits,
  linear_waic_minus_exact_loo =
    waic_pointwise$linear_elpd_waic -
      exact_loo$linear_log_predictive_density,
  quadratic_waic_minus_exact_loo =
    waic_pointwise$quadratic_elpd_waic -
      exact_loo$quadratic_log_predictive_density
)
waic_loo_long <- rbind(
  data.frame(
    cloze_surprisal_bits = waic_loo_plot_data$cloze_surprisal_bits,
    model = "Linear",
    waic_minus_exact_loo =
      waic_loo_plot_data$linear_waic_minus_exact_loo
  ),
  data.frame(
    cloze_surprisal_bits = waic_loo_plot_data$cloze_surprisal_bits,
    model = "Quadratic",
    waic_minus_exact_loo =
      waic_loo_plot_data$quadratic_waic_minus_exact_loo
  )
)
waic_loo_plot <- ggplot2::ggplot(
  waic_loo_long,
  ggplot2::aes(cloze_surprisal_bits, waic_minus_exact_loo)
) +
  ggplot2::geom_hline(
    yintercept = 0, color = "grey55", linewidth = 0.45
  ) +
  ggplot2::geom_point(size = 0.7, alpha = 0.3, color = "grey25") +
  ggplot2::facet_wrap(~ model) +
  ggplot2::labs(
    x = "Modeled cloze surprisal (bits)",
    y = "Pointwise WAIC minus exact LOO contribution"
  ) +
  theme_reference()
save_plot(waic_loo_plot, "provo-waic-versus-exact-loo.png")

# -----------------------------------------------------------------------------
# Page registry, packages, and final assertions
# -----------------------------------------------------------------------------

page_registry <- data.frame(
  page = c(
    "prediction-targets.qmd",
    "predictive-loss.qmd",
    "bias-variance-tradeoff.qmd",
    "training-and-test-data.qmd",
    "cross-validation.qmd",
    "grouped-cross-validation.qmd",
    "comparing-predictive-loss.qmd",
    "likelihood-ratio-tests.qmd",
    "information-criteria.qmd",
    "leave-one-out-cross-validation.qmd",
    "psis-loo.qmd",
    "waic.qmd"
  ),
  dataset = c(
    rep("Natural Stories corrected release", 6L),
    "MegaOrientation v1.1",
    rep("Provo position summaries", 5L)
  ),
  observation_or_grouping_unit = c(
    "reader-by-word response; targets distinguish row, participant, story",
    "reader-by-word response; losses also averaged by participant",
    "story-position mean in empirically calibrated simulation",
    "participant-held-out reader-by-word responses",
    "reader-by-word response under five random row folds",
    "participant folds and ten leave-one-story-out folds",
    "verb-level mean held-out ordinal log score",
    "content-word position aggregated across readers",
    "content-word position aggregated across readers",
    "one omitted content-word position, conditional on its passage remaining",
    "one omitted content-word position, conditional on its passage remaining",
    "one content-word-position likelihood contribution"
  ),
  exact_object = c(
    "natural-stories-target-inventory.csv; natural-stories-target-variation.csv",
    "natural-stories-predictive-loss.csv",
    "natural-stories-bias-variance.csv",
    "natural-stories-train-test-assignment.csv; natural-stories-training-preprocessing.csv",
    "natural-stories-validation-scores.csv (row target)",
    "natural-stories-validation-scores.csv (participant and story targets)",
    "megaorientation-verb-scores.csv; megaorientation-comparison-summary.csv",
    "provo-likelihood-ratio.csv",
    "provo-information-criteria.csv",
    "provo-exact-loo-pointwise.csv; provo-exact-loo-summary.csv",
    "provo-psis-loo-pointwise.csv; provo-psis-loo-summary.csv",
    "provo-waic-pointwise.csv; provo-waic-summary.csv"
  ),
  figure = c(
    "natural-stories-prediction-units.png",
    "natural-stories-train-test-calibration.png",
    "natural-stories-bias-variance.png",
    "natural-stories-train-test-calibration.png",
    "natural-stories-validation-targets.png",
    "natural-stories-validation-targets.png; natural-stories-story-loss-differences.png",
    "megaorientation-unseen-verb-loss-differences.png; megaorientation-raw-and-fitted.png",
    "provo-raw-and-fitted-models.png",
    "provo-information-criteria.png",
    "provo-exact-loo-predictions.png",
    "provo-psis-pareto-k.png",
    "provo-waic-versus-exact-loo.png"
  ),
  status = "ready",
  stringsAsFactors = FALSE
)
page_dependency_order <- c(
  "prediction-targets.qmd",
  "training-and-test-data.qmd",
  "predictive-loss.qmd",
  "bias-variance-tradeoff.qmd",
  "cross-validation.qmd",
  "grouped-cross-validation.qmd",
  "comparing-predictive-loss.qmd",
  "likelihood-ratio-tests.qmd",
  "information-criteria.qmd",
  "leave-one-out-cross-validation.qmd",
  "psis-loo.qmd",
  "waic.qmd"
)
page_registry <- page_registry[
  match(page_dependency_order, page_registry$page),
]
row.names(page_registry) <- NULL
record_assertion(
  "model-evaluation registry covers every non-index page",
  nrow(page_registry) == 12L && !anyDuplicated(page_registry$page),
  paste(nrow(page_registry), "rows and", anyDuplicated(page_registry$page),
        "duplicates"),
  "12 rows and 0 duplicates",
  "The directory contains 12 non-index pages and one index page."
)
write_csv(page_registry, "page-object-registry.csv")

package_versions <- data.frame(
  package = c("R", required_packages),
  version = c(
    paste(R.version$major, R.version$minor, sep = "."),
    vapply(required_packages, function(package) {
      as.character(utils::packageVersion(package))
    }, character(1))
  ),
  stringsAsFactors = FALSE
)
write_csv(package_versions, "package-versions.csv")

assertion_table <- do.call(rbind, assertions)
row.names(assertion_table) <- NULL
write_csv(assertion_table, "assertions.csv")
writeLines(capture.output(sessionInfo()), file.path(output_dir, "session-info.txt"))

finished_at <- Sys.time()
run_metadata <- data.frame(
  started_at = format(started_at, "%Y-%m-%dT%H:%M:%S%z"),
  finished_at = format(finished_at, "%Y-%m-%dT%H:%M:%S%z"),
  elapsed_seconds = as.numeric(difftime(finished_at, started_at, units = "secs")),
  natural_stories_rows = nrow(natural),
  megaorientation_rows = nrow(orientation),
  provo_positions = nrow(provo),
  posterior_draws_per_provo_model = posterior_draw_count,
  assertions_passed = sum(assertion_table$passed),
  assertions_total = nrow(assertion_table),
  stringsAsFactors = FALSE
)
write_csv(run_metadata, "run-metadata.csv")

cat("Model-evaluation reference analysis passed",
    nrow(assertion_table), "assertions in",
    sprintf("%.1f", run_metadata$elapsed_seconds), "seconds.\n")
cat("Natural Stories retained rows:", nrow(natural), "\n")
cat("MegaOrientation unseen-verb log-score gain:",
    sprintf("%.6f", orientation_comparison_summary$verb_weighted_mean_gain),
    "\n")
cat("Provo likelihood-ratio statistic:",
    sprintf("%.4f", lr_statistic), "\n")
