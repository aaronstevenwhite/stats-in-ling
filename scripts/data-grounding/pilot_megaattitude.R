#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

if (!requireNamespace("ordinal", quietly = TRUE)) {
  stop("Install the ordinal package to run the MegaAttitude pilot.")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  stop("Install the ggplot2 package to render pilot figures.")
}

output_dir <- script_argument(
  1,
  "research/dataset-audits/megaattitude-pilot-results"
)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

ordinal_probabilities <- function(fit, newdata, fixed_formula) {
  design <- stats::model.matrix(fixed_formula, newdata)
  beta <- fit$beta
  missing_columns <- setdiff(names(beta), colnames(design))
  if (length(missing_columns)) {
    stop("Prediction matrix is missing: ", paste(missing_columns, collapse = ", "))
  }
  eta <- drop(design[, names(beta), drop = FALSE] %*% beta)
  cumulative <- stats::plogis(outer(
    eta,
    fit$alpha,
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

score_predictions <- function(probabilities, outcome) {
  observed <- probabilities[cbind(seq_along(outcome), as.integer(outcome))]
  log(observed)
}

bootstrap_unit_mean <- function(values, repetitions, seed) {
  set.seed(seed)
  draws <- replicate(
    repetitions,
    mean(sample(values, size = length(values), replace = TRUE))
  )
  unname(stats::quantile(draws, c(0.025, 0.975), names = FALSE))
}

fit_grouped_cv <- function(
    data, restricted_formula, interaction_formula, fixed_restricted,
    fixed_interaction, levels, comparison_name, bootstrap_seed) {
  fold_rows <- vector("list", 5L)
  prediction_rows <- vector("list", 5L)

  for (fold in 1:5) {
    train <- data[data$fold != fold, ]
    test <- data[data$fold == fold, ]
    restricted <- ordinal::clm(
      restricted_formula,
      data = train,
      link = "logit",
      Hess = FALSE,
      control = ordinal::clm.control(maxIter = 200L, gradTol = 1e-3)
    )
    interaction <- ordinal::clm(
      interaction_formula,
      data = train,
      link = "logit",
      Hess = FALSE,
      control = ordinal::clm.control(maxIter = 200L, gradTol = 1e-3)
    )
    restricted_probability <- ordinal_probabilities(
      restricted, test, fixed_restricted
    )
    interaction_probability <- ordinal_probabilities(
      interaction, test, fixed_interaction
    )
    restricted_score <- score_predictions(
      restricted_probability, test$outcome
    )
    interaction_score <- score_predictions(
      interaction_probability, test$outcome
    )

    fold_rows[[fold]] <- data.frame(
      comparison = comparison_name,
      fold = fold,
      held_out_verbs = length(unique(test$verb)),
      held_out_rows = nrow(test),
      restricted_mean_log_score = mean(restricted_score),
      interaction_mean_log_score = mean(interaction_score),
      interaction_minus_restricted = mean(
        interaction_score - restricted_score
      ),
      stringsAsFactors = FALSE
    )
    prediction_rows[[fold]] <- data.frame(
      verb = test$verb,
      fold = fold,
      outcome = as.character(test$outcome),
      restricted_log_score = restricted_score,
      interaction_log_score = interaction_score,
      stringsAsFactors = FALSE
    )
    for (category in seq_along(levels)) {
      prediction_rows[[fold]][[paste0("p_", levels[[category]])]] <-
        interaction_probability[, category]
    }
  }

  folds <- do.call(rbind, fold_rows)
  predictions <- do.call(rbind, prediction_rows)
  by_verb <- stats::aggregate(
    interaction_log_score - restricted_log_score ~ verb,
    data = predictions,
    FUN = mean
  )
  names(by_verb)[[2L]] <- "interaction_minus_restricted"
  interval <- bootstrap_unit_mean(
    by_verb$interaction_minus_restricted,
    repetitions = 999L,
    seed = bootstrap_seed
  )
  summary <- list(
    held_out_rows = nrow(predictions),
    held_out_verbs = nrow(by_verb),
    mean_log_score_difference = mean(
      predictions$interaction_log_score - predictions$restricted_log_score
    ),
    verb_mean_difference = mean(by_verb$interaction_minus_restricted),
    verb_bootstrap_95 = interval,
    folds_favoring_interaction = sum(folds$interaction_minus_restricted > 0)
  )
  list(folds = folds, predictions = predictions, by_verb = by_verb,
       summary = summary)
}

# MegaVeridicality: empirical probabilities, one heterogeneity model, and
# conservative population-level prediction for entirely unseen verbs.
mv <- utils::read.csv(
  "data/megaveridicality/megaveridicality-v1-active-native.csv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)
mv_folds <- utils::read.csv(
  "data/megaveridicality/verb-folds.csv",
  stringsAsFactors = FALSE
)
mv <- merge(mv, mv_folds, by = "verb", all.x = TRUE, sort = FALSE)
stopifnot(!anyNA(mv$fold))
mv$outcome <- ordered(mv$response, levels = c("no", "maybe", "yes"))
mv$polarity <- factor(mv$polarity, levels = c("positive", "negative"))
mv$task <- factor(mv$task, levels = c("direct", "conditional"))
mv$verb <- factor(mv$verb)
mv$respondent_id <- factor(mv$respondent_id)

mv_probabilities <- as.data.frame(table(
  mv$verb, mv$polarity, mv$task, mv$outcome,
  dnn = c("verb", "polarity", "task", "response")
))
names(mv_probabilities)[[5L]] <- "responses"
mv_probabilities$probability <- ave(
  mv_probabilities$responses,
  mv_probabilities$verb,
  mv_probabilities$polarity,
  mv_probabilities$task,
  FUN = function(values) values / sum(values)
)
write_csv_stable(
  mv_probabilities,
  file.path(output_dir, "megaveridicality-category-proportions.csv")
)

mv_model_path <- file.path(output_dir, "megaveridicality-mixed-model.rds")
if (file.exists(mv_model_path)) {
  mv_mixed <- readRDS(mv_model_path)
} else {
  mv_mixed <- ordinal::clmm(
    outcome ~ polarity * task +
      (1 + polarity + task | verb) +
      (1 | respondent_id),
    data = mv,
    link = "logit",
    Hess = FALSE,
    nAGQ = 1L,
    control = ordinal::clmm.control(maxIter = 100L, gradTol = 1e-3)
  )
  saveRDS(mv_mixed, mv_model_path, version = 3)
}
stopifnot(mv_mixed$optRes$convergence == 0L)
mv_fixed <- data.frame(
  term = names(mv_mixed$beta),
  estimate = unname(mv_mixed$beta),
  stringsAsFactors = FALSE
)
mv_random <- do.call(rbind, lapply(names(ordinal::VarCorr(mv_mixed)), function(group) {
  standard_deviation <- attr(ordinal::VarCorr(mv_mixed)[[group]], "stddev")
  data.frame(
    group = group,
    term = names(standard_deviation),
    standard_deviation = unname(standard_deviation),
    stringsAsFactors = FALSE
  )
}))
write_csv_stable(mv_fixed, file.path(output_dir, "megaveridicality-mixed-fixed.csv"))
write_csv_stable(mv_random, file.path(output_dir, "megaveridicality-mixed-random.csv"))

mv_cv <- fit_grouped_cv(
  mv,
  outcome ~ polarity + task,
  outcome ~ polarity * task,
  ~ polarity + task,
  ~ polarity * task,
  levels = c("no", "maybe", "yes"),
  comparison_name = "polarity-by-task",
  bootstrap_seed = 4012L
)
write_csv_stable(mv_cv$folds, file.path(output_dir, "megaveridicality-cv-folds.csv"))
write_csv_stable(mv_cv$by_verb, file.path(output_dir, "megaveridicality-cv-by-verb.csv"))

mv_plot_data <- mv_probabilities[
  mv_probabilities$verb %in% c("think", "know", "regret", "say"),
]
mv_figure <- ggplot2::ggplot(
  mv_plot_data,
  ggplot2::aes(x = polarity, y = probability, fill = response)
) +
  ggplot2::geom_col(width = 0.72) +
  ggplot2::facet_grid(verb ~ task) +
  ggplot2::scale_fill_brewer(palette = "Greys", direction = -1) +
  ggplot2::labs(
    x = NULL,
    y = "Empirical response probability",
    fill = NULL
  ) +
  ggplot2::theme_minimal(base_size = 11) +
  ggplot2::theme(panel.grid.major.x = ggplot2::element_blank())
ggplot2::ggsave(
  file.path(output_dir, "megaveridicality-proportions.pdf"),
  mv_figure,
  width = 6.4,
  height = 6.2
)

# MegaOrientation: retain every repeated judgment, but restrict the comparison
# to verbs with at least two represented frames. The grouped predictive models
# estimate population category probabilities for an unseen verb. They do not
# reproduce the paper's weighted latent-type model.
mo <- utils::read.delim(
  "data/megaorientation/megaorientation-v1.1.tsv",
  stringsAsFactors = FALSE,
  check.names = FALSE
)
mo_folds <- utils::read.csv(
  "data/megaorientation/verb-folds-multiframe.csv",
  stringsAsFactors = FALSE
)
mo <- merge(mo, mo_folds[c("verb", "fold")], by = "verb", sort = FALSE)
stopifnot(nrow(mo) == 39440L, !anyNA(mo$fold))
mo$outcome <- ordered(mo$response, levels = 1:7)
mo$orientation <- factor(mo$orientation, levels = c("past", "future"))
mo$frame_code <- factor(mo$frame_code)
mo$verb <- factor(mo$verb)

mo_pairs <- stats::aggregate(
  response ~ verb + frame_code + orientation,
  data = mo,
  FUN = mean
)
mo_past <- mo_pairs[mo_pairs$orientation == "past", c("verb", "frame_code", "response")]
mo_future <- mo_pairs[mo_pairs$orientation == "future", c("verb", "frame_code", "response")]
names(mo_past)[[3L]] <- "mean_past"
names(mo_future)[[3L]] <- "mean_future"
mo_pairs <- merge(mo_past, mo_future, by = c("verb", "frame_code"))
stopifnot(nrow(mo_pairs) == 1972L)
write_csv_stable(mo_pairs, file.path(output_dir, "megaorientation-paired-means.csv"))

mo_cv <- fit_grouped_cv(
  mo,
  outcome ~ orientation + frame_code,
  outcome ~ orientation * frame_code,
  ~ orientation + frame_code,
  ~ orientation * frame_code,
  levels = as.character(1:7),
  comparison_name = "orientation-by-frame",
  bootstrap_seed = 5282L
)
write_csv_stable(mo_cv$folds, file.path(output_dir, "megaorientation-cv-folds.csv"))
write_csv_stable(mo_cv$by_verb, file.path(output_dir, "megaorientation-cv-by-verb.csv"))

mo_full_restricted <- ordinal::clm(
  outcome ~ orientation + frame_code,
  data = mo,
  link = "logit",
  Hess = FALSE,
  control = ordinal::clm.control(maxIter = 200L, gradTol = 1e-3)
)
mo_full_interaction <- ordinal::clm(
  outcome ~ orientation * frame_code,
  data = mo,
  link = "logit",
  Hess = FALSE,
  control = ordinal::clm.control(maxIter = 200L, gradTol = 1e-3)
)
mo_coefficients <- rbind(
  data.frame(
    model = "restricted",
    term = names(mo_full_restricted$beta),
    estimate = unname(mo_full_restricted$beta),
    stringsAsFactors = FALSE
  ),
  data.frame(
    model = "interaction",
    term = names(mo_full_interaction$beta),
    estimate = unname(mo_full_interaction$beta),
    stringsAsFactors = FALSE
  )
)
write_csv_stable(mo_coefficients, file.path(output_dir, "megaorientation-fixed-effects.csv"))

mo_figure <- ggplot2::ggplot(
  mo_pairs,
  ggplot2::aes(x = mean_past, y = mean_future)
) +
  ggplot2::geom_abline(
    slope = 1,
    intercept = 0,
    color = "grey55",
    linewidth = 0.45
  ) +
  ggplot2::geom_point(size = 0.8, alpha = 0.45) +
  ggplot2::coord_equal(xlim = c(1, 7), ylim = c(1, 7)) +
  ggplot2::facet_wrap(~ frame_code) +
  ggplot2::labs(
    x = "Mean rating: forced past orientation",
    y = "Mean rating: forced future orientation"
  ) +
  ggplot2::theme_minimal(base_size = 11)
ggplot2::ggsave(
  file.path(output_dir, "megaorientation-paired-means.pdf"),
  mo_figure,
  width = 7.2,
  height = 5.1
)

results <- list(
  generated = as.character(Sys.Date()),
  megaveridicality = list(
    inventory = list(
      judgments = nrow(mv),
      verbs = length(unique(mv$verb)),
      task_specific_respondents = length(unique(mv$respondent_id))
    ),
    mixed_model = list(
      formula = paste(
        "outcome ~ polarity * task + (1 + polarity + task | verb) +",
        "(1 | respondent_id)"
      ),
      convergence_code = mv_mixed$optRes$convergence,
      optimizer_message = mv_mixed$optRes$message,
      log_likelihood = as.numeric(stats::logLik(mv_mixed)),
      fixed_effects = as.list(stats::setNames(mv_fixed$estimate, mv_fixed$term)),
      random_sd = as.list(stats::setNames(
        mv_random$standard_deviation,
        paste(mv_random$group, mv_random$term, sep = ":")
      ))
    ),
    grouped_prediction = mv_cv$summary
  ),
  megaorientation = list(
    inventory = list(
      judgments_in_multiframe_comparison = nrow(mo),
      verbs = length(unique(mo$verb)),
      predicate_frame_pairs = nrow(mo_pairs)
    ),
    grouped_prediction = mo_cv$summary,
    estimand_note = paste(
      "Population-level cumulative-logit prediction for a new judgment from an",
      "entirely unseen multi-frame verb. This teaching comparison preserves the",
      "ordinal outcome and orientation-by-frame contrast but does not reproduce",
      "Moon and White's weighted latent lexical/structural type model or model",
      "participant/item heterogeneity."
    )
  )
)
write_json_stable(results, file.path(output_dir, "pilot-results.json"))

cat(
  "MegaVeridicality mean held-out log-score gain:",
  sprintf("%.6f", mv_cv$summary$mean_log_score_difference), "\n"
)
cat(
  "MegaOrientation mean held-out log-score gain:",
  sprintf("%.6f", mo_cv$summary$mean_log_score_difference), "\n"
)
