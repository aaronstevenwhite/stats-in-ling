#!/usr/bin/env Rscript

# Paper-first empirical reference for the mixed-effects notes.
#
# This script does not edit course pages. It verifies four prepared linguistic
# datasets, fits the models that the 15-page mixed-effects run can use, and
# writes the numerical objects and restrained figures needed for implementation.

source("scripts/data-grounding/common.R")

required_packages <- c("digest", "ggplot2", "lme4", "ordinal", "jsonlite")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Missing packages: ", paste(missing_packages, collapse = ", "))
}

set.seed(20261018L)

output_dir <- file.path(
  "research", "dataset-audits", "reference-mixed-effects-output"
)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

write_output <- function(value, filename) {
  write_csv_stable(value, file.path(output_dir, filename))
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
    stop(
      "Assertion failed: ", name, "; observed ", observed,
      "; required ", requirement
    )
  }
  invisible(condition)
}

bind_rows_base <- function(rows) {
  rows <- rows[lengths(rows) > 0L]
  if (!length(rows)) return(data.frame())
  answer <- do.call(rbind, rows)
  row.names(answer) <- NULL
  answer
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
    dpi = 160,
    bg = "white"
  )
}

scale_numeric <- function(x) {
  as.numeric(scale(x))
}

stable_folds <- function(values, salt, folds = 5L) {
  units <- sort(unique(as.character(values)))
  hashes <- vapply(
    units,
    function(unit) digest::digest(
      paste(salt, unit, sep = "|"),
      algo = "sha256",
      serialize = FALSE
    ),
    character(1)
  )
  ordering <- order(hashes)
  fold <- integer(length(units))
  fold[ordering] <- (seq_along(ordering) - 1L) %% folds + 1L
  data.frame(unit = units, fold = fold, stringsAsFactors = FALSE)
}

bernoulli_log_loss <- function(observed, probability) {
  probability <- pmin(pmax(probability, 1e-12), 1 - 1e-12)
  -mean(observed * log(probability) + (1 - observed) * log1p(-probability))
}

poisson_deviance <- function(observed, fitted) {
  fitted <- pmax(fitted, 1e-12)
  terms <- ifelse(
    observed == 0,
    fitted,
    observed * log(observed / fitted) - (observed - fitted)
  )
  2 * sum(terms)
}

clmm_population_probabilities <- function(fit, newdata) {
  design <- stats::model.matrix(
    stats::delete.response(stats::terms(fit)),
    newdata,
    contrasts.arg = fit$contrasts
  )
  if ("(Intercept)" %in% colnames(design)) {
    design <- design[, setdiff(colnames(design), "(Intercept)"), drop = FALSE]
  }
  design <- design[, names(fit$beta), drop = FALSE]
  eta <- drop(design %*% fit$beta)
  cumulative <- vapply(
    fit$alpha,
    function(threshold) stats::plogis(threshold - eta),
    numeric(nrow(newdata))
  )
  if (is.null(dim(cumulative))) cumulative <- matrix(cumulative, ncol = 1L)
  cbind(
    cumulative[, 1L],
    cumulative[, -1L, drop = FALSE] - cumulative[, -ncol(cumulative), drop = FALSE],
    1 - cumulative[, ncol(cumulative)]
  )
}

# -----------------------------------------------------------------------------
# Source integrity and frozen schemas
# -----------------------------------------------------------------------------

input_paths <- c(
  mald = "data/mald/mald-connected-trials.csv",
  supertelicity = "data/supertelicity/supertelicity-cloze.csv",
  megaveridicality =
    "data/megaveridicality/megaveridicality-v1-active-native.csv",
  megaveridicality_folds = "data/megaveridicality/verb-folds.csv",
  ucca = "data/ucca-french-english/passage-counts.csv"
)
expected_sha256 <- c(
  mald = "552720af4714734590e5b6c8005caf951aa4e7a43956ea23e10db26235bd24aa",
  supertelicity =
    "473e0666e180e33ee9383f0bca5940cd8245ff21d44534ba0325dda631c971fe",
  megaveridicality =
    "af8a99642ee63319f74f901fd6b0d194497945b78083af7a4a81452a9da8ce09",
  megaveridicality_folds =
    "bb9af30117f6cd6f7f4b1309e254f4c557c86b04b421a5cb1ffb43eeca0dbcdc",
  ucca = "6cfcc7e88c874243b7b25f939c11d5787b2a4eef377d2dc8261fc35cea8abb20"
)
observed_sha256 <- vapply(input_paths, sha256_file, character(1))
checksum_table <- data.frame(
  dataset = names(input_paths),
  path = unname(input_paths),
  expected_sha256 = unname(expected_sha256),
  observed_sha256 = unname(observed_sha256),
  matches = unname(expected_sha256 == observed_sha256),
  stringsAsFactors = FALSE
)
record_assertion(
  "prepared input checksums",
  all(checksum_table$matches),
  paste(checksum_table$matches, collapse = ","),
  "all TRUE"
)
write_output(checksum_table, "data-checksums.csv")

mald_all <- utils::read.csv(input_paths[["mald"]], stringsAsFactors = FALSE)
super <- utils::read.csv(
  input_paths[["supertelicity"]], stringsAsFactors = FALSE
)
mv <- utils::read.csv(
  input_paths[["megaveridicality"]], stringsAsFactors = FALSE
)
mv_folds <- utils::read.csv(
  input_paths[["megaveridicality_folds"]], stringsAsFactors = FALSE
)
ucca <- utils::read.csv(input_paths[["ucca"]], stringsAsFactors = FALSE)

record_assertion("MALD prepared rows", nrow(mald_all) == 13339L,
                 nrow(mald_all), 13339L)
record_assertion(
  "MALD participants",
  length(unique(mald_all$participant_id)) == 94L,
  length(unique(mald_all$participant_id)),
  94L
)
record_assertion(
  "MALD items",
  length(unique(mald_all$item)) == 5000L,
  length(unique(mald_all$item)),
  5000L
)
record_assertion("SuperTelicity rows", nrow(super) == 9160L,
                 nrow(super), 9160L)
record_assertion(
  "SuperTelicity participants",
  length(unique(super$participant_id)) == 200L,
  length(unique(super$participant_id)),
  200L,
  "The pinned release has 200 identifiers; the manuscript draft reports 120 recruits."
)
record_assertion(
  "SuperTelicity response support",
  setequal(unique(super$preposition), c("for", "in")),
  paste(sort(unique(super$preposition)), collapse = ","),
  "for,in"
)
record_assertion("MegaVeridicality rows", nrow(mv) == 14951L,
                 nrow(mv), 14951L)
record_assertion(
  "MegaVeridicality task-specific respondents",
  length(unique(mv$respondent_id)) == 319L,
  length(unique(mv$respondent_id)),
  319L
)
record_assertion(
  "MegaVeridicality ordinal support",
  setequal(unique(mv$response), c("no", "maybe", "yes")),
  paste(sort(unique(mv$response)), collapse = ","),
  "maybe,no,yes"
)
record_assertion("UCCA rows", nrow(ucca) == 308L, nrow(ucca), 308L)
record_assertion(
  "UCCA complete aligned pairs",
  length(unique(ucca$pair_id)) == 154L && all(table(ucca$pair_id) == 2L),
  paste(length(unique(ucca$pair_id)), min(table(ucca$pair_id)), sep = "/"),
  "154 pairs/two rows each"
)

inventory <- data.frame(
  dataset = c(
    "MALD 1.1 connected trials",
    "SuperTelicity cloze release",
    "MegaVeridicality v1 active/native",
    "UCCA French-English 20K v2"
  ),
  row_unit = c(
    "auditory lexical-decision trial",
    "one participant's preposition-and-duration response to one sentence",
    "one respondent's ordinal veridicality judgment on one sentence item",
    "one released passage graph in one language"
  ),
  rows = c(nrow(mald_all), nrow(super), nrow(mv), nrow(ucca)),
  primary_group_1 = c(
    length(unique(mald_all$participant_id)),
    length(unique(super$participant_id)),
    length(unique(mv$respondent_id)),
    length(unique(ucca$pair_id))
  ),
  primary_group_1_label = c(
    "participant", "participant", "task-specific respondent", "aligned pair"
  ),
  primary_group_2 = c(
    length(unique(mald_all$item)),
    length(unique(super$sentence_id)),
    length(unique(mv$verb)),
    length(unique(ucca$language))
  ),
  primary_group_2_label = c("word item", "sentence", "verb", "language side"),
  stringsAsFactors = FALSE
)
write_output(inventory, "dataset-inventory.csv")

# -----------------------------------------------------------------------------
# MALD: Gaussian crossed-effects run
# -----------------------------------------------------------------------------

# The latency analysis follows the paper's correct-response restriction. The
# prepared table retains all responses so this restriction remains explicit.
mald <- mald_all[mald_all$correct == 1L, ]
mald$participant_id <- factor(mald$participant_id)
mald$item <- factor(mald$item)
mald$z_frequency <- scale_numeric(mald$log_frequency_subtlex)
mald$z_duration <- scale_numeric(mald$log_duration)
mald$z_trial <- scale_numeric(mald$trial_order)

record_assertion("MALD correct latency rows", nrow(mald) == 11987L,
                 nrow(mald), 11987L)
record_assertion(
  "MALD correct-row item count",
  nlevels(mald$item) == 4872L,
  nlevels(mald$item),
  4872L
)

mald_intercept <- lme4::lmer(
  log_rt ~ 1 + (1 | participant_id) + (1 | item),
  data = mald,
  REML = TRUE,
  control = lme4::lmerControl(optimizer = "bobyqa")
)
mald_slope <- lme4::lmer(
  log_rt ~ z_frequency + z_duration + z_trial +
    (1 + z_frequency | participant_id) + (1 | item),
  data = mald,
  REML = TRUE,
  control = lme4::lmerControl(
    optimizer = "bobyqa",
    optCtrl = list(maxfun = 200000L)
  )
)

# This empirically singular model asks for participant variation in a
# frequency-by-duration interaction in addition to four lower-order effects.
# The reduced model keeps the fixed interaction but removes only that unsupported
# random slope and retains the item-specific trial slope.
mald_overfit <- lme4::lmer(
  log_rt ~ z_frequency * z_duration + z_trial +
    (1 + z_frequency * z_duration + z_trial | participant_id) +
    (1 + z_trial | item),
  data = mald,
  REML = TRUE,
  control = lme4::lmerControl(
    optimizer = "bobyqa",
    optCtrl = list(maxfun = 200000L)
  )
)
mald_resolved <- lme4::lmer(
  log_rt ~ z_frequency * z_duration + z_trial +
    (1 + z_frequency + z_duration + z_trial | participant_id) +
    (1 + z_trial | item),
  data = mald,
  REML = TRUE,
  control = lme4::lmerControl(
    optimizer = "bobyqa",
    optCtrl = list(maxfun = 200000L)
  )
)

record_assertion(
  "MALD focal model is nonsingular",
  !lme4::isSingular(mald_slope, tol = 1e-4),
  lme4::isSingular(mald_slope, tol = 1e-4),
  "FALSE"
)
record_assertion(
  "MALD overfit model is singular",
  lme4::isSingular(mald_overfit, tol = 1e-4),
  lme4::isSingular(mald_overfit, tol = 1e-4),
  "TRUE"
)
record_assertion(
  "MALD revised model is nonsingular",
  !lme4::isSingular(mald_resolved, tol = 1e-4),
  lme4::isSingular(mald_resolved, tol = 1e-4),
  "FALSE"
)

mald_model_summary <- data.frame(
  model_id = c(
    "intercept_only", "frequency_slope", "singular_interaction_slope",
    "resolved_without_interaction_slope"
  ),
  formula = c(
    "log_rt ~ 1 + (1 | participant_id) + (1 | item)",
    paste(
      "log_rt ~ z_frequency + z_duration + z_trial +",
      "(1 + z_frequency | participant_id) + (1 | item)"
    ),
    paste(
      "log_rt ~ z_frequency * z_duration + z_trial +",
      "(1 + z_frequency * z_duration + z_trial | participant_id) +",
      "(1 + z_trial | item)"
    ),
    paste(
      "log_rt ~ z_frequency * z_duration + z_trial +",
      "(1 + z_frequency + z_duration + z_trial | participant_id) +",
      "(1 + z_trial | item)"
    )
  ),
  n = c(
    stats::nobs(mald_intercept), stats::nobs(mald_slope),
    stats::nobs(mald_overfit), stats::nobs(mald_resolved)
  ),
  log_likelihood = c(
    as.numeric(stats::logLik(mald_intercept)),
    as.numeric(stats::logLik(mald_slope)),
    as.numeric(stats::logLik(mald_overfit)),
    as.numeric(stats::logLik(mald_resolved))
  ),
  singular_1e_4 = c(
    lme4::isSingular(mald_intercept, tol = 1e-4),
    lme4::isSingular(mald_slope, tol = 1e-4),
    lme4::isSingular(mald_overfit, tol = 1e-4),
    lme4::isSingular(mald_resolved, tol = 1e-4)
  ),
  stringsAsFactors = FALSE
)
write_output(mald_model_summary, "mald-model-summary.csv")

mald_coefficients <- bind_rows_base(lapply(
  list(intercept_only = mald_intercept, frequency_slope = mald_slope,
       singular_interaction_slope = mald_overfit,
       resolved_without_interaction_slope = mald_resolved),
  function(fit) {
    coefficient <- lme4::fixef(fit)
    se <- sqrt(diag(as.matrix(stats::vcov(fit))))
    data.frame(
      term = names(coefficient),
      estimate = unname(coefficient),
      standard_error = unname(se),
      stringsAsFactors = FALSE
    )
  }
))
mald_coefficients$model_id <- rep(
  names(list(
    intercept_only = mald_intercept,
    frequency_slope = mald_slope,
    singular_interaction_slope = mald_overfit,
    resolved_without_interaction_slope = mald_resolved
  )),
  times = vapply(
    list(mald_intercept, mald_slope, mald_overfit, mald_resolved),
    function(fit) length(lme4::fixef(fit)), integer(1)
  )
)
mald_coefficients <- mald_coefficients[
  , c("model_id", "term", "estimate", "standard_error")
]
write_output(mald_coefficients, "mald-fixed-effects.csv")

mald_variance <- bind_rows_base(lapply(
  names(list(intercept_only = mald_intercept, frequency_slope = mald_slope,
             singular_interaction_slope = mald_overfit,
             resolved_without_interaction_slope = mald_resolved)),
  function(model_id) {
    fit <- list(intercept_only = mald_intercept, frequency_slope = mald_slope,
                singular_interaction_slope = mald_overfit,
                resolved_without_interaction_slope = mald_resolved)[[model_id]]
    answer <- as.data.frame(lme4::VarCorr(fit))
    answer$model_id <- model_id
    answer[, c("model_id", "grp", "var1", "var2", "vcov", "sdcor")]
  }
))
write_output(mald_variance, "mald-variance-components.csv")

# Participant and item ICCs for the crossed intercept-only model.
mald_vc0 <- as.data.frame(lme4::VarCorr(mald_intercept))
participant_variance <- mald_vc0$vcov[
  mald_vc0$grp == "participant_id" & is.na(mald_vc0$var2)
]
item_variance <- mald_vc0$vcov[
  mald_vc0$grp == "item" & is.na(mald_vc0$var2)
]
residual_variance <- stats::sigma(mald_intercept)^2
total_variance <- participant_variance + item_variance + residual_variance
mald_icc <- data.frame(
  quantity = c(
    "participant_variance", "item_variance", "residual_variance",
    "participant_icc", "item_icc",
    "same_participant_and_item_correlation"
  ),
  value = c(
    participant_variance, item_variance, residual_variance,
    participant_variance / total_variance,
    item_variance / total_variance,
    (participant_variance + item_variance) / total_variance
  ),
  stringsAsFactors = FALSE
)
write_output(mald_icc, "mald-intraclass-correlations.csv")

# Conditional participant modes and conditional standard deviations.
mald_participant_re <- as.data.frame(
  lme4::ranef(mald_slope, condVar = TRUE)
)
mald_participant_re <- mald_participant_re[
  mald_participant_re$grpvar == "participant_id",
]
mald_participant_re$participant_id <- mald_participant_re$grp
mald_participant_re <- mald_participant_re[
  , c("participant_id", "term", "condval", "condsd")
]
write_output(mald_participant_re, "mald-participant-random-effects.csv")

# Raw group means and partial-pooling estimates from the intercept-only model.
mald_participant_raw <- aggregate(
  mald$log_rt,
  list(participant_id = mald$participant_id),
  function(x) c(n = length(x), mean = mean(x))
)
mald_participant_raw <- data.frame(
  participant_id = mald_participant_raw$participant_id,
  trials = mald_participant_raw$x[, "n"],
  raw_mean_log_rt = mald_participant_raw$x[, "mean"],
  stringsAsFactors = FALSE
)
intercept_re <- lme4::ranef(mald_intercept, condVar = TRUE)$participant_id
postvar <- attr(intercept_re, "postVar")
mald_pooling <- merge(
  mald_participant_raw,
  data.frame(
    participant_id = rownames(intercept_re),
    conditional_mode = intercept_re[, "(Intercept)"],
    conditional_sd = sqrt(postvar[1, 1, ]),
    stringsAsFactors = FALSE
  ),
  by = "participant_id",
  sort = FALSE
)
mald_pooling$complete_pooling_mean <- unname(lme4::fixef(mald_intercept)[1])
mald_pooling$partial_pooling_mean <-
  mald_pooling$complete_pooling_mean + mald_pooling$conditional_mode
mald_pooling$shrinkage_toward_grand_mean <- with(
  mald_pooling,
  abs(raw_mean_log_rt - complete_pooling_mean) -
    abs(partial_pooling_mean - complete_pooling_mean)
)
write_output(mald_pooling, "mald-partial-pooling.csv")

# Frequency grid and empirical bins for raw-plus-fitted figures.
mald_breaks <- unique(stats::quantile(
  mald$z_frequency,
  probs = seq(0, 1, length.out = 13L),
  names = FALSE
))
mald$frequency_bin <- cut(
  mald$z_frequency,
  breaks = mald_breaks,
  include.lowest = TRUE,
  ordered_result = TRUE
)
mald_bins <- bind_rows_base(lapply(split(mald, mald$frequency_bin), function(rows) {
  data.frame(
    frequency_bin = as.character(rows$frequency_bin[[1]]),
    trials = nrow(rows),
    mean_z_frequency = mean(rows$z_frequency),
    mean_log_rt = mean(rows$log_rt),
    se_log_rt = stats::sd(rows$log_rt) / sqrt(nrow(rows)),
    stringsAsFactors = FALSE
  )
}))
mald_grid <- data.frame(
  z_frequency = seq(
    min(mald_bins$mean_z_frequency),
    max(mald_bins$mean_z_frequency),
    length.out = 160L
  ),
  z_duration = 0,
  z_trial = 0
)
mald_grid$fitted_log_rt <- stats::predict(
  mald_slope,
  newdata = mald_grid,
  re.form = NA
)
write_output(mald_bins, "mald-frequency-bins.csv")
write_output(mald_grid, "mald-population-fit.csv")

# A deterministic new-participant/new-item assessment. Training excludes every
# trial from either held-out unit; assessment is their intersection.
mald_participant_folds <- stable_folds(
  mald$participant_id, "mald-participant-validation-v1"
)
names(mald_participant_folds)[1] <- "participant_id"
mald_item_folds <- stable_folds(mald$item, "mald-item-validation-v1")
names(mald_item_folds)[1] <- "item"
mald_validation <- merge(mald, mald_participant_folds, by = "participant_id")
names(mald_validation)[names(mald_validation) == "fold"] <- "participant_fold"
mald_validation <- merge(mald_validation, mald_item_folds, by = "item")
names(mald_validation)[names(mald_validation) == "fold"] <- "item_fold"
mald_train <- mald_validation[
  mald_validation$participant_fold != 1L & mald_validation$item_fold != 1L,
]
mald_test <- mald_validation[
  mald_validation$participant_fold == 1L & mald_validation$item_fold == 1L,
]
mald_validation_fit <- lme4::lmer(
  log_rt ~ z_frequency + z_duration + z_trial +
    (1 + z_frequency | participant_id) + (1 | item),
  data = mald_train,
  REML = FALSE,
  control = lme4::lmerControl(
    optimizer = "bobyqa", optCtrl = list(maxfun = 200000L)
  )
)
mald_test$predicted_log_rt <- stats::predict(
  mald_validation_fit,
  newdata = mald_test,
  re.form = NA,
  allow.new.levels = TRUE
)
mald_validation_summary <- data.frame(
  target = "new participant and new word item",
  held_out_participant_fold = 1L,
  held_out_item_fold = 1L,
  training_rows = nrow(mald_train),
  assessment_rows = nrow(mald_test),
  assessment_participants = length(unique(mald_test$participant_id)),
  assessment_items = length(unique(mald_test$item)),
  rmse_log_rt = sqrt(mean((mald_test$log_rt - mald_test$predicted_log_rt)^2)),
  mae_log_rt = mean(abs(mald_test$log_rt - mald_test$predicted_log_rt)),
  stringsAsFactors = FALSE
)
record_assertion(
  "MALD double holdout contains observations",
  nrow(mald_test) > 100L,
  nrow(mald_test),
  "> 100"
)
write_output(mald_validation_summary, "mald-double-holdout-summary.csv")
write_output(
  mald_test[, c(
    "participant_id", "item", "log_rt", "predicted_log_rt",
    "z_frequency", "z_duration", "z_trial"
  )],
  "mald-double-holdout-predictions.csv"
)

# Singularity diagnostics in orthogonal dimensions.
singularity_rows <- list()
for (model_id in c("singular_interaction_slope", "resolved")) {
  fit <- if (model_id == "singular_interaction_slope") mald_overfit else mald_resolved
  pca <- lme4::rePCA(fit)
  for (group in names(pca)) {
    singularity_rows[[length(singularity_rows) + 1L]] <- data.frame(
      model_id = model_id,
      group = group,
      component = seq_along(pca[[group]]$sdev),
      orthogonal_sd_scaled = pca[[group]]$sdev,
      is_singular_1e_4 = lme4::isSingular(fit, tol = 1e-4),
      stringsAsFactors = FALSE
    )
  }
}
mald_singularity <- bind_rows_base(singularity_rows)
write_output(mald_singularity, "mald-singularity-diagnostics.csv")

# MALD figures.
replication_data <- rbind(
  data.frame(
    unit = "Participant", repetitions = as.numeric(table(mald$participant_id))
  ),
  data.frame(unit = "Word item", repetitions = as.numeric(table(mald$item)))
)
figure_mald_structure <- ggplot2::ggplot(
  replication_data,
  ggplot2::aes(x = repetitions)
) +
  ggplot2::geom_histogram(bins = 30, fill = "grey45", color = "white") +
  ggplot2::facet_wrap(~unit, scales = "free") +
  ggplot2::labs(x = "Correct trials per unit", y = "Units") +
  theme_reference()
save_plot(figure_mald_structure, "figure-mald-repetition.png", 6.4, 3.5)

figure_mald_pooling <- ggplot2::ggplot(
  mald_pooling,
  ggplot2::aes(x = raw_mean_log_rt, y = partial_pooling_mean)
) +
  ggplot2::geom_abline(slope = 1, intercept = 0, color = "grey70") +
  ggplot2::geom_point(color = "#0072B2", alpha = 0.75, size = 1.7) +
  ggplot2::labs(
    x = "Participant raw mean log RT",
    y = "Partially pooled participant mean log RT"
  ) +
  ggplot2::coord_equal() +
  theme_reference()
save_plot(figure_mald_pooling, "figure-mald-partial-pooling.png")

figure_mald_fit <- ggplot2::ggplot(
  mald_bins,
  ggplot2::aes(x = mean_z_frequency, y = mean_log_rt)
) +
  ggplot2::geom_errorbar(
    ggplot2::aes(ymin = mean_log_rt - 1.96 * se_log_rt,
                 ymax = mean_log_rt + 1.96 * se_log_rt),
    width = 0,
    color = "grey45"
  ) +
  ggplot2::geom_point(color = "grey25", size = 1.8) +
  ggplot2::geom_line(
    data = mald_grid,
    ggplot2::aes(x = z_frequency, y = fitted_log_rt),
    color = "#0072B2",
    linewidth = 0.9
  ) +
  ggplot2::labs(
    x = "SUBTLEX log frequency (standardized)",
    y = "Log response time"
  ) +
  theme_reference()
save_plot(figure_mald_fit, "figure-mald-raw-and-fitted.png")

participant_intercepts <- mald_participant_re[
  mald_participant_re$term == "(Intercept)",
]
participant_intercepts <- participant_intercepts[
  order(participant_intercepts$condval),
]
participant_intercepts$order <- seq_len(nrow(participant_intercepts))
figure_mald_re <- ggplot2::ggplot(
  participant_intercepts,
  ggplot2::aes(x = condval, y = order)
) +
  ggplot2::geom_errorbarh(
    ggplot2::aes(
      xmin = condval - 1.96 * condsd,
      xmax = condval + 1.96 * condsd
    ),
    height = 0,
    color = "grey55"
  ) +
  ggplot2::geom_point(color = "#0072B2", size = 1.2) +
  ggplot2::geom_vline(xintercept = 0, color = "grey75", linewidth = 0.4) +
  ggplot2::labs(x = "Participant conditional mode (log RT)", y = "Participant") +
  theme_reference() +
  ggplot2::theme(axis.text.y = ggplot2::element_blank(), axis.ticks.y = ggplot2::element_blank())
save_plot(figure_mald_re, "figure-mald-random-effect-estimates.png")

slope_re <- mald_participant_re[mald_participant_re$term == "z_frequency", ]
selected_index <- unique(round(stats::quantile(
  seq_len(nrow(slope_re)), probs = seq(0, 1, length.out = 6L)
)))
slope_re <- slope_re[order(slope_re$condval), ]
selected_participants <- as.character(slope_re$participant_id[selected_index])
selected_raw <- mald[as.character(mald$participant_id) %in% selected_participants, ]
selected_raw$participant_id <- factor(
  selected_raw$participant_id, levels = selected_participants
)
selected_raw$within_bin <- ave(
  selected_raw$z_frequency,
  selected_raw$participant_id,
  FUN = function(x) {
    cut(x, unique(stats::quantile(x, seq(0, 1, length.out = 7L))),
        include.lowest = TRUE, labels = FALSE)
  }
)
selected_bins <- aggregate(
  cbind(z_frequency, log_rt) ~ participant_id + within_bin,
  selected_raw,
  mean
)
selected_grid <- expand.grid(
  participant_id = factor(selected_participants, levels = selected_participants),
  z_frequency = seq(-2, 2, length.out = 80L),
  z_duration = 0,
  z_trial = 0
)
selected_grid$item <- factor(levels(mald$item)[[1]], levels = levels(mald$item))
selected_grid$fitted_log_rt <- stats::predict(
  mald_slope,
  newdata = selected_grid,
  re.form = ~(1 + z_frequency | participant_id),
  allow.new.levels = TRUE
)
figure_mald_slopes <- ggplot2::ggplot(
  selected_bins,
  ggplot2::aes(x = z_frequency, y = log_rt)
) +
  ggplot2::geom_point(color = "grey45", size = 1.2) +
  ggplot2::geom_line(
    data = selected_grid,
    ggplot2::aes(y = fitted_log_rt),
    color = "#0072B2",
    linewidth = 0.7
  ) +
  ggplot2::facet_wrap(~participant_id, ncol = 3) +
  ggplot2::labs(
    x = "SUBTLEX log frequency (standardized)",
    y = "Log response time"
  ) +
  theme_reference()
save_plot(figure_mald_slopes, "figure-mald-participant-slopes.png", 7.0, 4.8)

participant_covariance <- as.data.frame(lme4::VarCorr(mald_slope))
participant_correlation <- participant_covariance$sdcor[
  participant_covariance$grp == "participant_id" &
    participant_covariance$var1 == "(Intercept)" &
    !is.na(participant_covariance$var2) &
    participant_covariance$var2 == "z_frequency"
]
write_output(
  data.frame(
    intercept_definition = paste(
      "expected log RT at mean log frequency, mean log duration,",
      "and mean trial order"
    ),
    intercept_frequency_slope_correlation = participant_correlation,
    stringsAsFactors = FALSE
  ),
  "mald-random-effect-correlation.csv"
)

figure_mald_singular <- ggplot2::ggplot(
  mald_singularity[mald_singularity$group == "participant_id", ],
  ggplot2::aes(x = factor(component), y = orthogonal_sd_scaled, fill = model_id)
) +
  ggplot2::geom_col(position = "dodge", width = 0.72) +
  ggplot2::scale_fill_manual(values = c("grey60", "#0072B2")) +
  ggplot2::labs(
    x = "Participant covariance dimension",
    y = "Orthogonal SD (residual-scaled)",
    fill = NULL
  ) +
  theme_reference()
save_plot(figure_mald_singular, "figure-mald-singularity.png")

# -----------------------------------------------------------------------------
# SuperTelicity: binomial GLMM and a one-dimensional Laplace illustration
# -----------------------------------------------------------------------------

super$participant_id <- factor(super$participant_id)
super$sentence_id <- factor(super$sentence_id)
super$verb <- factor(super$verb)
super$verb_type <- factor(super$verb_type, levels = c("manner", "result"))
super$contentfulness <- factor(
  super$contentfulness,
  levels = c("contentful", "bleached", "templatic")
)
contrasts(super$verb_type) <- stats::contr.sum(2)
contrasts(super$contentfulness) <- stats::contr.sum(3)

super_fit <- lme4::glmer(
  prep_in ~ verb_type * contentfulness +
    (1 | participant_id) + (1 | verb) + (1 | sentence_id),
  data = super,
  family = stats::binomial(),
  nAGQ = 1L,
  control = lme4::glmerControl(
    optimizer = "bobyqa", optCtrl = list(maxfun = 200000L)
  )
)
record_assertion(
  "SuperTelicity model nonsingular",
  !lme4::isSingular(super_fit, tol = 1e-4),
  lme4::isSingular(super_fit, tol = 1e-4),
  "FALSE"
)

super_coef <- summary(super_fit)$coefficients
write_output(
  data.frame(
    term = rownames(super_coef),
    estimate = super_coef[, "Estimate"],
    standard_error = super_coef[, "Std. Error"],
    z = super_coef[, "z value"],
    p_value = super_coef[, "Pr(>|z|)"],
    row.names = NULL,
    stringsAsFactors = FALSE
  ),
  "supertelicity-fixed-effects.csv"
)
super_variance <- as.data.frame(lme4::VarCorr(super_fit))
write_output(super_variance, "supertelicity-variance-components.csv")

super_raw <- aggregate(
  super$prep_in,
  list(
    verb_type = super$verb_type,
    contentfulness = super$contentfulness,
    sentence_id = super$sentence_id
  ),
  function(x) c(trials = length(x), proportion_in = mean(x))
)
super_raw <- data.frame(
  verb_type = super_raw$verb_type,
  contentfulness = super_raw$contentfulness,
  sentence_id = super_raw$sentence_id,
  trials = super_raw$x[, "trials"],
  proportion_in = super_raw$x[, "proportion_in"],
  stringsAsFactors = FALSE
)
super_grid <- expand.grid(
  verb_type = factor(c("manner", "result"), levels = levels(super$verb_type)),
  contentfulness = factor(
    c("contentful", "bleached", "templatic"),
    levels = levels(super$contentfulness)
  )
)
super_grid$participant_id <- factor(
  levels(super$participant_id)[[1]], levels = levels(super$participant_id)
)
super_grid$verb <- factor(levels(super$verb)[[1]], levels = levels(super$verb))
super_grid$sentence_id <- factor(
  levels(super$sentence_id)[[1]], levels = levels(super$sentence_id)
)
super_grid$conditional_probability <- stats::predict(
  super_fit,
  newdata = super_grid,
  type = "response",
  re.form = NA
)
super_total_random_variance <- sum(
  super_variance$vcov[is.na(super_variance$var2)]
)
super_eta <- stats::predict(
  super_fit,
  newdata = super_grid,
  type = "link",
  re.form = NA
)
super_grid$marginal_probability <- vapply(super_eta, function(eta) {
  stats::integrate(
    function(b) stats::plogis(eta + b) *
      stats::dnorm(b, 0, sqrt(super_total_random_variance)),
    lower = -Inf,
    upper = Inf,
    rel.tol = 1e-10
  )$value
}, numeric(1))
write_output(super_raw, "supertelicity-sentence-proportions.csv")
write_output(super_grid, "supertelicity-conditional-and-marginal.csv")

# Five double-group holdouts: every training fold excludes all rows belonging to
# either held-out participants or held-out verbs. Assessment uses their
# intersection and population predictions for both unseen units.
super_participant_folds <- stable_folds(
  super$participant_id, "supertelicity-participant-folds-v1"
)
names(super_participant_folds)[1] <- "participant_id"
super_verb_folds <- stable_folds(super$verb, "supertelicity-verb-folds-v1")
names(super_verb_folds)[1] <- "verb"
super_cv_data <- merge(super, super_participant_folds, by = "participant_id")
names(super_cv_data)[names(super_cv_data) == "fold"] <- "participant_fold"
super_cv_data <- merge(super_cv_data, super_verb_folds, by = "verb")
names(super_cv_data)[names(super_cv_data) == "fold"] <- "verb_fold"
super_cv <- bind_rows_base(lapply(1:5, function(fold) {
  train <- super_cv_data[
    super_cv_data$participant_fold != fold & super_cv_data$verb_fold != fold,
  ]
  test <- super_cv_data[
    super_cv_data$participant_fold == fold & super_cv_data$verb_fold == fold,
  ]
  fit <- lme4::glmer(
    prep_in ~ verb_type * contentfulness +
      (1 | participant_id) + (1 | verb) + (1 | sentence_id),
    data = train,
    family = stats::binomial(),
    nAGQ = 1L,
    control = lme4::glmerControl(
      optimizer = "bobyqa", optCtrl = list(maxfun = 200000L)
    )
  )
  probability <- stats::predict(
    fit,
    newdata = test,
    type = "response",
    re.form = NA,
    allow.new.levels = TRUE
  )
  data.frame(
    fold = fold,
    training_rows = nrow(train),
    assessment_rows = nrow(test),
    held_out_participants = length(unique(test$participant_id)),
    held_out_verbs = length(unique(test$verb)),
    bernoulli_log_loss = bernoulli_log_loss(test$prep_in, probability),
    brier_score = mean((test$prep_in - probability)^2),
    stringsAsFactors = FALSE
  )
}))
write_output(super_cv, "supertelicity-double-group-cv.csv")

figure_super <- ggplot2::ggplot(
  super_raw,
  ggplot2::aes(x = verb_type, y = proportion_in)
) +
  ggplot2::geom_jitter(
    width = 0.08, height = 0,
    alpha = 0.18, size = 1.0, color = "grey35"
  ) +
  ggplot2::geom_point(
    data = super_grid,
    ggplot2::aes(y = conditional_probability),
    color = "#0072B2",
    size = 2.2
  ) +
  ggplot2::facet_wrap(~contentfulness) +
  ggplot2::scale_y_continuous(limits = c(0, 1)) +
  ggplot2::labs(x = "Verb class", y = "Probability of an in-response") +
  theme_reference()
save_plot(figure_super, "figure-supertelicity-raw-and-fitted.png")

figure_super_marginal <- ggplot2::ggplot(
  super_grid,
  ggplot2::aes(x = conditional_probability, y = marginal_probability)
) +
  ggplot2::geom_abline(slope = 1, intercept = 0, color = "grey70") +
  ggplot2::geom_point(
    ggplot2::aes(shape = verb_type), color = "#0072B2", size = 2.2
  ) +
  ggplot2::facet_wrap(~contentfulness) +
  ggplot2::coord_equal(xlim = c(0, 1), ylim = c(0, 1)) +
  ggplot2::labs(
    x = "Conditional probability (random effects = 0)",
    y = "Probability averaged over fitted random effects",
    shape = "Verb class"
  ) +
  theme_reference()
save_plot(
  figure_super_marginal,
  "figure-supertelicity-conditional-vs-marginal.png"
)

# The Laplace page needs a visible one-dimensional integral. This intentionally
# simplified fit contains only the participant intercept. The computation is an
# illustration of the approximation, not the scientific model for the release.
super_laplace_fit <- lme4::glmer(
  prep_in ~ verb_type * contentfulness + (1 | participant_id),
  data = super,
  family = stats::binomial(),
  nAGQ = 1L,
  control = lme4::glmerControl(optimizer = "bobyqa")
)
participant_sizes <- sort(table(super$participant_id))
laplace_participant <- names(participant_sizes)[ceiling(length(participant_sizes) / 2)]
laplace_rows <- super[super$participant_id == laplace_participant, ]
laplace_X <- stats::model.matrix(
  stats::delete.response(stats::terms(super_laplace_fit, fixed.only = TRUE)),
  laplace_rows
)
laplace_eta_fixed <- drop(laplace_X %*% lme4::fixef(super_laplace_fit))
laplace_y <- laplace_rows$prep_in
laplace_sd <- attr(lme4::VarCorr(super_laplace_fit)$participant_id, "stddev")[[1]]
log1pexp <- function(x) {
  ifelse(x > 0, x + log1p(exp(-x)), log1p(exp(x)))
}
log_integrand <- function(b) {
  sum(laplace_y * (laplace_eta_fixed + b) - log1pexp(laplace_eta_fixed + b)) +
    stats::dnorm(b, mean = 0, sd = laplace_sd, log = TRUE)
}
mode_result <- stats::optimize(
  function(b) -log_integrand(b),
  interval = c(-6 * laplace_sd, 6 * laplace_sd)
)
laplace_mode <- mode_result$minimum
laplace_prob <- stats::plogis(laplace_eta_fixed + laplace_mode)
laplace_curvature <- sum(laplace_prob * (1 - laplace_prob)) + 1 / laplace_sd^2
laplace_log_integral <-
  log_integrand(laplace_mode) + 0.5 * log(2 * pi) - 0.5 * log(laplace_curvature)
laplace_center <- log_integrand(laplace_mode)
exact_integral <- stats::integrate(
  function(b) vapply(
    b,
    function(value) exp(log_integrand(value) - laplace_center),
    numeric(1)
  ),
  lower = -Inf,
  upper = Inf,
  rel.tol = 1e-11
)$value
exact_log_integral <- log(exact_integral) + laplace_center
laplace_summary <- data.frame(
  participant_id = laplace_participant,
  trials = nrow(laplace_rows),
  random_intercept_sd = laplace_sd,
  conditional_mode = laplace_mode,
  negative_second_derivative = laplace_curvature,
  exact_log_integral = exact_log_integral,
  laplace_log_integral = laplace_log_integral,
  laplace_minus_exact = laplace_log_integral - exact_log_integral,
  stringsAsFactors = FALSE
)
write_output(laplace_summary, "supertelicity-laplace-summary.csv")

laplace_grid <- data.frame(
  participant_intercept = seq(
    laplace_mode - 4 / sqrt(laplace_curvature),
    laplace_mode + 4 / sqrt(laplace_curvature),
    length.out = 240L
  )
)
laplace_grid$exact_log_integrand <- vapply(
  laplace_grid$participant_intercept, log_integrand, numeric(1)
)
laplace_grid$quadratic_approximation <-
  laplace_center - 0.5 * laplace_curvature *
    (laplace_grid$participant_intercept - laplace_mode)^2
laplace_plot_data <- rbind(
  data.frame(
    participant_intercept = laplace_grid$participant_intercept,
    log_density_relative_to_mode =
      laplace_grid$exact_log_integrand - laplace_center,
    curve = "Exact log integrand"
  ),
  data.frame(
    participant_intercept = laplace_grid$participant_intercept,
    log_density_relative_to_mode =
      laplace_grid$quadratic_approximation - laplace_center,
    curve = "Local quadratic"
  )
)
write_output(laplace_plot_data, "supertelicity-laplace-curve.csv")
figure_laplace <- ggplot2::ggplot(
  laplace_plot_data,
  ggplot2::aes(
    x = participant_intercept,
    y = log_density_relative_to_mode,
    linetype = curve
  )
) +
  ggplot2::geom_line(linewidth = 0.8, color = "#0072B2") +
  ggplot2::scale_linetype_manual(values = c("solid", "dashed")) +
  ggplot2::labs(
    x = "Participant random intercept",
    y = "Log integrand relative to its mode",
    linetype = NULL
  ) +
  theme_reference()
save_plot(figure_laplace, "figure-supertelicity-laplace.png")

# -----------------------------------------------------------------------------
# MegaVeridicality: cumulative-link mixed model
# -----------------------------------------------------------------------------

mv <- merge(mv, mv_folds, by = "verb", all.x = TRUE, sort = FALSE)
record_assertion(
  "MegaVeridicality fold assignment complete",
  !anyNA(mv$fold),
  sum(is.na(mv$fold)),
  0L
)
mv$outcome <- ordered(mv$response, levels = c("no", "maybe", "yes"))
mv$polarity <- factor(mv$polarity, levels = c("positive", "negative"))
mv$task <- factor(mv$task, levels = c("direct", "conditional"))
mv$verb <- factor(mv$verb)
mv$respondent_id <- factor(mv$respondent_id)

mv_model_path <- file.path(output_dir, "megaveridicality-model.rds")
mv_formula_text <- paste(
  "outcome ~ polarity * task +",
  "(1 + polarity + task | verb) + (1 | respondent_id)"
)
mv_cache_signature <- list(
  data_sha256 = unname(observed_sha256[["megaveridicality"]]),
  fold_sha256 = unname(observed_sha256[["megaveridicality_folds"]]),
  formula = mv_formula_text,
  ordinal_version = as.character(utils::packageVersion("ordinal"))
)
mv_cache <- if (file.exists(mv_model_path)) readRDS(mv_model_path) else NULL
mv_cache_valid <- is.list(mv_cache) &&
  all(c("fit", "signature") %in% names(mv_cache)) &&
  identical(mv_cache$signature, mv_cache_signature)
if (mv_cache_valid) {
  mv_fit <- mv_cache$fit
} else {
  mv_fit <- ordinal::clmm(
    outcome ~ polarity * task +
      (1 + polarity + task | verb) + (1 | respondent_id),
    data = mv,
    link = "logit",
    Hess = FALSE,
    nAGQ = 1L,
    control = ordinal::clmm.control(maxIter = 100L, gradTol = 1e-3)
  )
  saveRDS(
    list(fit = mv_fit, signature = mv_cache_signature),
    mv_model_path,
    version = 3
  )
}
record_assertion(
  "MegaVeridicality model converged",
  mv_fit$optRes$convergence == 0L,
  mv_fit$optRes$convergence,
  0L
)

mv_fixed <- data.frame(
  parameter_type = c(rep("threshold", length(mv_fit$alpha)),
                     rep("fixed effect", length(mv_fit$beta))),
  term = c(names(mv_fit$alpha), names(mv_fit$beta)),
  estimate = c(unname(mv_fit$alpha), unname(mv_fit$beta)),
  stringsAsFactors = FALSE
)
write_output(mv_fixed, "megaveridicality-fixed-effects.csv")
mv_random <- bind_rows_base(lapply(names(ordinal::VarCorr(mv_fit)), function(group) {
  matrix <- ordinal::VarCorr(mv_fit)[[group]]
  standard_deviation <- attr(matrix, "stddev")
  data.frame(
    group = group,
    term = names(standard_deviation),
    standard_deviation = unname(standard_deviation),
    stringsAsFactors = FALSE
  )
}))
write_output(mv_random, "megaveridicality-random-effects.csv")

mv_raw <- as.data.frame(table(
  mv$polarity, mv$task, mv$outcome,
  dnn = c("polarity", "task", "response")
))
names(mv_raw)[4] <- "responses"
mv_raw$probability <- ave(
  mv_raw$responses, mv_raw$polarity, mv_raw$task,
  FUN = function(x) x / sum(x)
)
mv_grid <- expand.grid(
  polarity = factor(c("positive", "negative"), levels = levels(mv$polarity)),
  task = factor(c("direct", "conditional"), levels = levels(mv$task))
)
mv_probability_matrix <- clmm_population_probabilities(mv_fit, mv_grid)
colnames(mv_probability_matrix) <- levels(mv$outcome)
mv_fitted <- cbind(mv_grid, as.data.frame(mv_probability_matrix))
mv_fitted <- reshape(
  mv_fitted,
  varying = levels(mv$outcome),
  v.names = "probability",
  timevar = "response",
  times = levels(mv$outcome),
  direction = "long"
)
row.names(mv_fitted) <- NULL
mv_fitted$response <- factor(
  mv_fitted$response, levels = levels(mv$outcome), ordered = TRUE
)
write_output(mv_raw, "megaveridicality-raw-probabilities.csv")
write_output(mv_fitted, "megaveridicality-fitted-probabilities.csv")

# Grouped unseen-verb validation for the population interaction. The mixed fit
# describes observed lexical heterogeneity; the faster CLM comparison isolates
# whether the fixed interaction predicts judgments for verbs absent from fitting.
ordinal_log_probability <- function(fit, newdata, outcome) {
  predicted <- stats::predict(fit, newdata = newdata, type = "prob")$fit
  predicted <- pmax(predicted, 1e-12)
  if (is.null(dim(predicted))) return(log(predicted))
  index <- cbind(seq_len(nrow(newdata)), match(as.character(outcome), colnames(predicted)))
  log(predicted[index])
}
mv_cv <- bind_rows_base(lapply(1:5, function(fold) {
  train <- mv[mv$fold != fold, ]
  test <- mv[mv$fold == fold, ]
  restricted <- ordinal::clm(
    outcome ~ polarity + task,
    data = train,
    link = "logit",
    Hess = FALSE,
    control = ordinal::clm.control(gradTol = 1e-3, maxIter = 100L)
  )
  interaction <- ordinal::clm(
    outcome ~ polarity * task,
    data = train,
    link = "logit",
    Hess = FALSE,
    control = ordinal::clm.control(gradTol = 1e-3, maxIter = 100L)
  )
  restricted_score <- ordinal_log_probability(restricted, test, test$outcome)
  interaction_score <- ordinal_log_probability(interaction, test, test$outcome)
  data.frame(
    fold = fold,
    held_out_verbs = length(unique(test$verb)),
    held_out_rows = nrow(test),
    restricted_mean_log_score = mean(restricted_score),
    interaction_mean_log_score = mean(interaction_score),
    interaction_minus_restricted = mean(interaction_score - restricted_score),
    stringsAsFactors = FALSE
  )
}))
write_output(mv_cv, "megaveridicality-unseen-verb-cv.csv")

mv_plot <- merge(
  mv_raw,
  mv_fitted,
  by = c("polarity", "task", "response"),
  suffixes = c("_raw", "_fitted")
)
mv_plot$response <- factor(
  mv_plot$response, levels = c("no", "maybe", "yes"), ordered = TRUE
)
figure_mv <- ggplot2::ggplot(
  mv_plot,
  ggplot2::aes(x = response)
) +
  ggplot2::geom_col(
    ggplot2::aes(y = probability_raw),
    width = 0.68,
    fill = "grey80",
    color = "grey45"
  ) +
  ggplot2::geom_point(
    ggplot2::aes(y = probability_fitted),
    color = "#0072B2",
    size = 2.2
  ) +
  ggplot2::facet_grid(task ~ polarity) +
  ggplot2::scale_y_continuous(limits = c(0, 1)) +
  ggplot2::labs(x = "Veridicality response", y = "Response probability") +
  theme_reference()
save_plot(figure_mv, "figure-megaveridicality-raw-and-fitted.png")

# -----------------------------------------------------------------------------
# UCCA: paired Poisson mixed model with word exposure
# -----------------------------------------------------------------------------

ucca$pair_id <- factor(ucca$pair_id)
ucca$language <- factor(ucca$language, levels = c("en", "fr"))
ucca_fit <- lme4::glmer(
  scene_count ~ language + offset(log(word_count)) + (1 | pair_id),
  data = ucca,
  family = stats::poisson(),
  nAGQ = 1L,
  control = lme4::glmerControl(optimizer = "bobyqa")
)
record_assertion(
  "UCCA Poisson mixed model nonsingular",
  !lme4::isSingular(ucca_fit, tol = 1e-4),
  lme4::isSingular(ucca_fit, tol = 1e-4),
  "FALSE"
)
ucca_coef <- summary(ucca_fit)$coefficients
write_output(
  data.frame(
    term = rownames(ucca_coef),
    estimate = ucca_coef[, "Estimate"],
    standard_error = ucca_coef[, "Std. Error"],
    z = ucca_coef[, "z value"],
    p_value = ucca_coef[, "Pr(>|z|)"],
    row.names = NULL,
    stringsAsFactors = FALSE
  ),
  "ucca-poisson-fixed-effects.csv"
)
ucca_variance <- as.data.frame(lme4::VarCorr(ucca_fit))
write_output(ucca_variance, "ucca-poisson-variance-components.csv")

ucca$population_fitted_scenes <- stats::predict(
  ucca_fit, type = "response", re.form = NA
)
ucca$conditional_fitted_scenes <- stats::predict(
  ucca_fit, type = "response", re.form = NULL
)
write_output(
  ucca[, c(
    "pair_id", "chapter", "language", "word_count", "scene_count",
    "population_fitted_scenes", "conditional_fitted_scenes"
  )],
  "ucca-raw-and-fitted.csv"
)

ucca_pearson <- residuals(ucca_fit, type = "pearson")
ucca_df <- nrow(ucca) - length(lme4::fixef(ucca_fit)) - 1L
ucca_pair_variance <- ucca_variance$vcov[
  ucca_variance$grp == "pair_id" & is.na(ucca_variance$var2)
]
ucca_reference_exposure <- 100
ucca_reference_eta <-
  lme4::fixef(ucca_fit)["(Intercept)"] + log(ucca_reference_exposure)
ucca_reference_conditional_mean <- exp(ucca_reference_eta)
ucca_reference_marginal_mean <-
  ucca_reference_conditional_mean * exp(ucca_pair_variance / 2)
ucca_reference_marginal_variance <-
  ucca_reference_marginal_mean +
  ucca_reference_marginal_mean^2 * (exp(ucca_pair_variance) - 1)
ucca_dispersion <- data.frame(
  quantity = c(
    "pearson_chisq", "pearson_df", "pearson_ratio",
    "pair_intercept_variance", "reference_exposure_words",
    "reference_conditional_mean_en",
    "reference_marginal_mean_en",
    "reference_marginal_variance_en",
    "reference_marginal_variance_to_mean_en"
  ),
  value = c(
    sum(ucca_pearson^2), ucca_df, sum(ucca_pearson^2) / ucca_df,
    ucca_pair_variance, ucca_reference_exposure,
    ucca_reference_conditional_mean,
    ucca_reference_marginal_mean,
    ucca_reference_marginal_variance,
    ucca_reference_marginal_variance / ucca_reference_marginal_mean
  ),
  stringsAsFactors = FALSE
)
write_output(ucca_dispersion, "ucca-overdispersion-quantities.csv")

ucca_grid <- expand.grid(
  word_count = seq(min(ucca$word_count), max(ucca$word_count), length.out = 180L),
  language = factor(c("en", "fr"), levels = levels(ucca$language))
)
ucca_grid$pair_id <- factor(levels(ucca$pair_id)[[1]], levels = levels(ucca$pair_id))
ucca_grid$population_fitted_scenes <- stats::predict(
  ucca_fit,
  newdata = ucca_grid,
  type = "response",
  re.form = NA
)
write_output(ucca_grid, "ucca-poisson-prediction-grid.csv")

ucca_pair_folds <- stable_folds(ucca$pair_id, "ucca-pair-folds-v1")
names(ucca_pair_folds)[1] <- "pair_id"
ucca_cv_data <- merge(ucca, ucca_pair_folds, by = "pair_id")
ucca_cv <- bind_rows_base(lapply(1:5, function(fold) {
  train <- ucca_cv_data[ucca_cv_data$fold != fold, ]
  test <- ucca_cv_data[ucca_cv_data$fold == fold, ]
  fit <- lme4::glmer(
    scene_count ~ language + offset(log(word_count)) + (1 | pair_id),
    data = train,
    family = stats::poisson(),
    nAGQ = 1L,
    control = lme4::glmerControl(optimizer = "bobyqa")
  )
  prediction <- stats::predict(
    fit,
    newdata = test,
    type = "response",
    re.form = NA,
    allow.new.levels = TRUE
  )
  data.frame(
    fold = fold,
    held_out_pairs = length(unique(test$pair_id)),
    held_out_rows = nrow(test),
    mean_poisson_deviance = poisson_deviance(test$scene_count, prediction) /
      nrow(test),
    mean_absolute_error = mean(abs(test$scene_count - prediction)),
    stringsAsFactors = FALSE
  )
}))
write_output(ucca_cv, "ucca-held-out-pair-cv.csv")

figure_ucca <- ggplot2::ggplot(
  ucca,
  ggplot2::aes(x = word_count, y = scene_count, shape = language)
) +
  ggplot2::geom_point(alpha = 0.55, size = 1.5, color = "grey30") +
  ggplot2::geom_line(
    data = ucca_grid,
    ggplot2::aes(y = population_fitted_scenes, linetype = language),
    color = "#0072B2",
    linewidth = 0.8
  ) +
  ggplot2::labs(
    x = "Words in passage",
    y = "UCCA Scenes",
    shape = "Language",
    linetype = "Language"
  ) +
  theme_reference()
save_plot(figure_ucca, "figure-ucca-poisson-raw-and-fitted.png")

# -----------------------------------------------------------------------------
# Page contract, reproducibility records, and final assertions
# -----------------------------------------------------------------------------

page_map <- data.frame(
  page = c(
    "structured-data.qmd",
    "fixed-and-random-effects.qmd",
    "random-effects.qmd",
    "random-intercepts.qmd",
    "intraclass-correlation.qmd",
    "random-effect-estimates.qmd",
    "random-slopes.qmd",
    "random-effect-correlations.qmd",
    "singular-fits.qmd",
    "generalized-linear-mixed-models.qmd",
    "ordinal-mixed-models.qmd",
    "aspectual-similarity-example.qmd",
    "laplace-approximation.qmd",
    "poisson-mixed-models.qmd",
    "overdispersion-and-random-effects.qmd"
  ),
  dataset = c(
    rep("MALD 1.1 connected correct word trials", 9),
    "SuperTelicity cloze release",
    "MegaVeridicality v1 active/native",
    "MegaVeridicality v1 active/native (replacement page)",
    "SuperTelicity cloze release",
    "UCCA French-English 20K v2",
    "UCCA French-English 20K v2"
  ),
  formula_or_object = c(
    "participant-by-word trial table",
    "log_rt ~ z_frequency + z_duration + z_trial + (1 + z_frequency | participant_id) + (1 | item)",
    "raw participant means; complete-pooling mean; crossed random-intercept conditional means",
    "log_rt ~ 1 + (1 | participant_id) + (1 | item)",
    "crossed intercept-only variance decomposition",
    "ranef(mald_slope, condVar = TRUE)",
    "log_rt ~ z_frequency + z_duration + z_trial + (1 + z_frequency | participant_id) + (1 | item)",
    "participant intercept-slope covariance from mald_slope",
    "overfit participant interaction slope; revised lower-rank random structure",
    "prep_in ~ verb_type * contentfulness + (1 | participant_id) + (1 | verb) + (1 | sentence_id)",
    "outcome ~ polarity * task + (1 + polarity + task | verb) + (1 | respondent_id)",
    "same ordinal fit plus deterministic unseen-verb validation; delete aspectual analysis",
    "one-participant integral from prep_in ~ verb_type * contentfulness + (1 | participant_id)",
    "scene_count ~ language + offset(log(word_count)) + (1 | pair_id)",
    "conditional Poisson plus lognormal pair-intercept marginal moments"
  ),
  estimand = c(
    "which rows share a listener, word, or both",
    "population log-RT associations and sampled listener/word variation",
    "participant mean log RT after partial pooling across the crossed table",
    "participant and word deviations from a shared log-RT intercept",
    "correlation induced by a shared participant or word in the fitted model",
    "participant conditional modes with conditional uncertainty",
    "distribution of participant-specific frequency associations",
    "correlation between participant baseline and frequency association at centered predictors",
    "supported rank of the participant random-effect covariance",
    "conditional and random-effect-averaged probability of choosing in",
    "probabilities of no, maybe, and yes by polarity and task",
    "population ordinal interaction and held-out log score for unseen verbs",
    "exact versus local-quadratic integral for one observed participant's trials",
    "within-pair French/English Scene-rate ratio per annotated word",
    "conditional versus marginal Scene-count variance at a fixed exposure"
  ),
  validation_target = c(
    rep("new participant and new word item; double-group holdout", 9),
    "new participant and new verb; double-group five-fold assessment",
    "new verb; frozen five-fold verb assessment",
    "new verb; frozen five-fold verb assessment",
    "computational approximation check against one-dimensional numerical integration",
    "new aligned passage pair; five-fold grouped assessment",
    "new aligned passage pair; Pearson diagnostic conditional on fitted means"
  ),
  figure = c(
    "figure-mald-repetition.png",
    "figure-mald-raw-and-fitted.png",
    "figure-mald-partial-pooling.png",
    "figure-mald-partial-pooling.png",
    "figure-mald-repetition.png",
    "figure-mald-random-effect-estimates.png",
    "figure-mald-participant-slopes.png",
    "figure-mald-participant-slopes.png",
    "figure-mald-singularity.png",
    "figure-supertelicity-raw-and-fitted.png; figure-supertelicity-conditional-vs-marginal.png",
    "figure-megaveridicality-raw-and-fitted.png",
    "figure-megaveridicality-raw-and-fitted.png",
    "figure-supertelicity-laplace.png",
    "figure-ucca-poisson-raw-and-fitted.png",
    "figure-ucca-poisson-raw-and-fitted.png"
  ),
  limitation = c(
    "The connected extract is response-blind but is not the full MALD release.",
    "The course fit is simpler than Tucker et al.'s control structure.",
    "Exchangeability is a model assumption, not a claim that listeners are identical.",
    "A shared intercept does not model participant-specific lexical associations.",
    "The ICCs are conditional on this intercept-only Gaussian model.",
    "Conditional modes are not independently observed participant traits.",
    "Frequency varies within listeners but is fixed within word items.",
    "The correlation depends on centering and is weakly estimated when slope variance is small.",
    "Removing one unsupported dimension is a documented model revision, not an automatic recipe.",
    "The teaching random structure is smaller than the manuscript's Bayesian model.",
    "The model simplifies the paper's normalization and does not retest responsivity.",
    "The filename must be retired or redirected; the aspectual source is blocked by a source mismatch.",
    "The one-group fit is a computation illustration, not the scientific SuperTelicity model.",
    "Language is a paired fixed contrast in one translated novel, not a sampled language population.",
    "The fitted UCCA model is conditionally underdispersed; random intercepts do not repair every dispersion pattern."
  ),
  stringsAsFactors = FALSE
)
write_output(page_map, "page-map.csv")

package_versions <- data.frame(
  package = c("R", required_packages, "Matrix"),
  version = c(
    as.character(getRversion()),
    vapply(required_packages, function(package) {
      as.character(utils::packageVersion(package))
    }, character(1)),
    as.character(utils::packageVersion("Matrix"))
  ),
  stringsAsFactors = FALSE
)
write_output(package_versions, "package-versions.csv")

writeLines(capture.output(utils::sessionInfo()), file.path(output_dir, "session-info.txt"))
write_output(bind_rows_base(assertions), "assertions.csv")

run_summary <- c(
  paste("Generated:", format(Sys.time(), tz = "UTC", usetz = TRUE)),
  paste("MALD correct trials:", nrow(mald)),
  paste("MALD participant ICC:", signif(mald_icc$value[mald_icc$quantity == "participant_icc"], 6)),
  paste("MALD item ICC:", signif(mald_icc$value[mald_icc$quantity == "item_icc"], 6)),
  paste("MALD singular model detected:", lme4::isSingular(mald_overfit, tol = 1e-4)),
  paste("SuperTelicity rows:", nrow(super)),
  paste("SuperTelicity double-group folds:", nrow(super_cv)),
  paste("Laplace minus exact log integral:", signif(laplace_summary$laplace_minus_exact, 8)),
  paste("MegaVeridicality rows:", nrow(mv)),
  paste("MegaVeridicality log likelihood:", signif(as.numeric(stats::logLik(mv_fit)), 8)),
  paste("UCCA rows/pairs:", nrow(ucca), nlevels(ucca$pair_id)),
  paste("UCCA French Scene-rate ratio:", signif(exp(lme4::fixef(ucca_fit)["languagefr"]), 6)),
  paste("UCCA Pearson ratio:", signif(sum(ucca_pearson^2) / ucca_df, 6)),
  "Aspectual-similarity analysis: BLOCKED and excluded; replacement is the MegaVeridicality worked page."
)
writeLines(run_summary, file.path(output_dir, "run-summary.txt"))

cat(paste(run_summary, collapse = "\n"), "\n")
