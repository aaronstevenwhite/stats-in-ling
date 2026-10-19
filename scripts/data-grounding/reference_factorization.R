#!/usr/bin/env Rscript

# Paper-first reference analysis for the factorization notes.
#
# Run from the repository root:
#   Rscript scripts/data-grounding/reference_factorization.R
#
# The script uses PHOIBLE 2.0 for the matrix-method sequence and the frozen,
# leakage-safe VALEX--MegaAcceptability pilot for the final application. It
# writes only to research/dataset-audits/reference-factorization-output/.

options(stringsAsFactors = FALSE)

required_packages <- c("ggplot2", "jsonlite", "ragg")
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages)) {
  stop("Missing required packages: ", paste(missing_packages, collapse = ", "))
}

project_root <- normalizePath(".", mustWork = TRUE)
stopifnot(
  file.exists(file.path(project_root, "_quarto.yml")),
  file.exists(file.path(project_root, "data/phoible/phoible-pilot.rds"))
)

output_dir <- file.path(
  project_root,
  "research/dataset-audits/reference-factorization-output"
)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

write_csv <- function(x, name) {
  utils::write.csv(
    x,
    file.path(output_dir, name),
    row.names = FALSE,
    na = ""
  )
}

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

balanced_loss <- function(truth, prediction, loss = c("brier", "log")) {
  loss <- match.arg(loss)
  stopifnot(setequal(unique(truth), c(0, 1)))
  prediction <- pmin(pmax(prediction, 1e-6), 1 - 1e-6)
  cell_loss <- if (loss == "brier") {
    (truth - prediction)^2
  } else {
    -(truth * log(prediction) + (1 - truth) * log(1 - prediction))
  }
  0.5 * mean(cell_loss[truth == 1]) +
    0.5 * mean(cell_loss[truth == 0])
}

select_one_inventory <- function(inventories, seed = 20260827L) {
  inventories <- inventories[
    order(inventories$glottocode, as.integer(inventories$inventory_id)),
  ]
  by_glottocode <- split(seq_len(nrow(inventories)), inventories$glottocode)
  RNGkind(sample.kind = "Rejection")
  set.seed(seed)
  selected_rows <- vapply(
    by_glottocode,
    function(index) index[[sample.int(length(index), size = 1L)]],
    integer(1)
  )
  selected <- inventories[unname(selected_rows), ]
  selected[order(selected$glottocode), ]
}

make_inventory_split <- function(selected, seed = 20261018L) {
  macroarea <- selected$macroarea
  macroarea[is.na(macroarea) | macroarea == ""] <- "Unclassified"
  split <- rep(NA_character_, nrow(selected))
  set.seed(seed)
  for (area in sort(unique(macroarea))) {
    index <- sample(which(macroarea == area))
    n_validation <- floor(0.15 * length(index))
    n_test <- floor(0.15 * length(index))
    if (n_validation > 0L) {
      split[index[seq_len(n_validation)]] <- "validation"
    }
    if (n_test > 0L) {
      split[index[n_validation + seq_len(n_test)]] <- "test"
    }
    split[index[is.na(split[index])]] <- "training"
  }
  factor(split, levels = c("training", "validation", "test"))
}

build_inventory_matrix <- function(prepared, selected, training_ids, minimum_count = 20L) {
  memberships <- merge(
    prepared$memberships,
    selected[c("inventory_id", "glottocode")],
    by = c("inventory_id", "glottocode"),
    all = FALSE,
    sort = FALSE
  )
  training_frequency <- table(
    memberships$segment_id[memberships$glottocode %in% training_ids]
  )
  column_ids <- sort(names(training_frequency)[training_frequency >= minimum_count])
  row_ids <- selected$glottocode
  matrix <- matrix(
    0,
    nrow = length(row_ids),
    ncol = length(column_ids),
    dimnames = list(row_ids, column_ids)
  )
  retained <- memberships[memberships$segment_id %in% column_ids, ]
  matrix[cbind(
    match(retained$glottocode, row_ids),
    match(retained$segment_id, column_ids)
  )] <- 1
  list(
    matrix = matrix,
    training_frequency = training_frequency[column_ids],
    retained_memberships = retained
  )
}

make_balanced_mask <- function(inventory_matrix, row_index, seed, n_each = 3L) {
  set.seed(seed)
  mask <- matrix(FALSE, nrow = length(row_index), ncol = ncol(inventory_matrix))
  eligible <- logical(length(row_index))
  for (local_row in seq_along(row_index)) {
    global_row <- row_index[[local_row]]
    present <- which(inventory_matrix[global_row, ] == 1)
    unlisted <- which(inventory_matrix[global_row, ] == 0)
    if (length(present) >= n_each && length(unlisted) >= n_each) {
      eligible[[local_row]] <- TRUE
      mask[local_row, c(
        sample(present, n_each, replace = FALSE),
        sample(unlisted, n_each, replace = FALSE)
      )] <- TRUE
    }
  }
  list(rows = row_index[eligible], mask = mask[eligible, , drop = FALSE])
}

reconstruct_heldout <- function(
  inventory_matrix,
  evaluation,
  training_mean,
  loadings,
  rank
) {
  observed <- inventory_matrix[evaluation$rows, , drop = FALSE]
  mean_matrix <- matrix(
    rep(training_mean, each = nrow(observed)),
    nrow = nrow(observed)
  )
  observed[evaluation$mask] <- mean_matrix[evaluation$mask]
  centered <- sweep(observed, 2, training_mean, FUN = "-")
  prediction <- mean_matrix
  if (rank > 0L) {
    directions <- loadings[, seq_len(rank), drop = FALSE]
    scores <- centered %*% directions
    prediction <- prediction + scores %*% t(directions)
  }
  pmin(pmax(prediction, 1e-6), 1 - 1e-6)
}

score_evaluation <- function(
  inventory_matrix,
  evaluation,
  training_mean,
  loadings,
  rank
) {
  prediction <- reconstruct_heldout(
    inventory_matrix,
    evaluation,
    training_mean,
    loadings,
    rank
  )
  truth <- inventory_matrix[evaluation$rows, , drop = FALSE][evaluation$mask]
  predicted <- prediction[evaluation$mask]
  c(
    balanced_brier = balanced_loss(truth, predicted, "brier"),
    balanced_log = balanced_loss(truth, predicted, "log")
  )
}

make_long_matrix <- function(matrix, row_labels, column_labels) {
  grid <- expand.grid(
    row = seq_len(nrow(matrix)),
    column = seq_len(ncol(matrix))
  )
  grid$row_label <- row_labels[grid$row]
  grid$column_label <- column_labels[grid$column]
  grid$value <- matrix[cbind(grid$row, grid$column)]
  grid
}

# -----------------------------------------------------------------------------
# PHOIBLE 2.0: inventory records by segment memberships
# -----------------------------------------------------------------------------

phoible_path <- file.path(project_root, "data/phoible/phoible-pilot.rds")
phoible_object_sha256 <-
  "8aa7c2e8042cb4728d8ff4d24b15e199180d9273df143e86ada2dda01af7e88d"
stopifnot(identical(sha256_file(phoible_path), phoible_object_sha256))
phoible <- readRDS(phoible_path)

stopifnot(
  identical(
    phoible$provenance$archive_commit,
    "350563f179293254be2f92886d6fa8ba8e7cbbb2"
  ),
  identical(
    phoible$provenance$sha256,
    "fb8247bb97b21aea5a482062692f82f13724e6ee53da64f233273f0a705adf0a"
  ),
  nrow(phoible$memberships) == 101977L,
  nrow(phoible$inventories) == 3020L,
  nrow(phoible$segments) == 3115L
)

selected <- select_one_inventory(phoible$inventories)
stopifnot(nrow(selected) == 2186L, !anyDuplicated(selected$glottocode))

split <- make_inventory_split(selected)
selected$analysis_split <- split
training_index <- which(split == "training")
validation_index <- which(split == "validation")
test_index <- which(split == "test")

built <- build_inventory_matrix(
  phoible,
  selected,
  training_ids = selected$glottocode[training_index],
  minimum_count = 20L
)
X <- built$matrix
stopifnot(
  identical(rownames(X), selected$glottocode),
  nrow(X) == 2186L,
  ncol(X) == 254L,
  all(X %in% c(0, 1)),
  length(training_index) == 1538L,
  length(validation_index) == 324L,
  length(test_index) == 324L
)

segment_metadata <- phoible$segments[
  match(colnames(X), phoible$segments$segment_id),
]
stopifnot(!anyNA(segment_metadata$segment))

training_mean <- colMeans(X[training_index, , drop = FALSE])
training_sd <- apply(X[training_index, , drop = FALSE], 2, stats::sd)
stopifnot(all(training_sd > 0))
training_centered <- sweep(
  X[training_index, , drop = FALSE],
  2,
  training_mean,
  FUN = "-"
)
decomposition <- svd(training_centered, nu = 80L, nv = 80L)
total_centered_ss <- sum(decomposition$d^2)

covariance_eigenvalues <- eigen(
  crossprod(training_centered) / (nrow(training_centered) - 1),
  symmetric = TRUE,
  only.values = TRUE
)$values
svd_eigenvalues <- decomposition$d^2 / (nrow(training_centered) - 1)
svd_pca_max_difference <- max(abs(covariance_eigenvalues - svd_eigenvalues))
stopifnot(svd_pca_max_difference < 1e-10)

candidate_ranks <- c(0L, 1L, 2L, 3L, 5L, 8L, 12L, 16L, 24L, 32L, 40L, 50L, 64L)
validation <- make_balanced_mask(X, validation_index, seed = 20261019L)
test <- make_balanced_mask(X, test_index, seed = 20261020L)
stopifnot(
  length(validation$rows) == 324L,
  length(test$rows) == 324L,
  sum(validation$mask) == 1944L,
  sum(test$mask) == 1944L
)

validation_metrics <- t(vapply(
  candidate_ranks,
  function(rank) {
    score_evaluation(X, validation, training_mean, decomposition$v, rank)
  },
  numeric(2)
))
selected_rank <- candidate_ranks[[which.min(validation_metrics[, "balanced_brier"])]]
stopifnot(selected_rank == 40L)

test_metrics <- t(vapply(
  candidate_ranks,
  function(rank) {
    score_evaluation(X, test, training_mean, decomposition$v, rank)
  },
  numeric(2)
))
rank_curve <- data.frame(
  rank = candidate_ranks,
  validation_balanced_brier = validation_metrics[, "balanced_brier"],
  validation_balanced_log = validation_metrics[, "balanced_log"],
  test_balanced_brier = test_metrics[, "balanced_brier"],
  test_balanced_log = test_metrics[, "balanced_log"]
)
write_csv(rank_curve, "phoible-rank-curve.csv")

test_baseline_matrix <- reconstruct_heldout(
  X, test, training_mean, decomposition$v, rank = 0L
)
test_selected_matrix <- reconstruct_heldout(
  X, test, training_mean, decomposition$v, rank = selected_rank
)
test_cells <- which(test$mask, arr.ind = TRUE)
test_truth <- X[test$rows, , drop = FALSE][test$mask]
test_baseline <- test_baseline_matrix[test$mask]
test_selected <- test_selected_matrix[test$mask]

test_predictions <- data.frame(
  glottocode = rownames(X)[test$rows[test_cells[, "row"]]],
  inventory_id = selected$inventory_id[test$rows[test_cells[, "row"]]],
  language_name = selected$language_name[test$rows[test_cells[, "row"]]],
  macroarea = selected$macroarea[test$rows[test_cells[, "row"]]],
  family_name = selected$family_name[test$rows[test_cells[, "row"]]],
  inventory_source = selected$inventory_source[test$rows[test_cells[, "row"]]],
  segment_id = colnames(X)[test_cells[, "col"]],
  segment = segment_metadata$segment[test_cells[, "col"]],
  listed = test_truth,
  prevalence_prediction = test_baseline,
  low_rank_prediction = test_selected
)
write_csv(test_predictions, "phoible-test-predictions.csv")

prediction_by_inventory <- split(
  seq_len(nrow(test_predictions)),
  test_predictions$glottocode
)
inventory_scores <- do.call(rbind, lapply(prediction_by_inventory, function(index) {
  one <- test_predictions[index, ]
  data.frame(
    glottocode = one$glottocode[[1]],
    baseline_brier = balanced_loss(
      one$listed,
      one$prevalence_prediction,
      "brier"
    ),
    low_rank_brier = balanced_loss(
      one$listed,
      one$low_rank_prediction,
      "brier"
    )
  )
}))
inventory_scores$reconstruction_gain <-
  inventory_scores$baseline_brier - inventory_scores$low_rank_brier
row.names(inventory_scores) <- NULL
write_csv(inventory_scores, "phoible-test-by-inventory.csv")

set.seed(20261021L)
bootstrap_gain <- replicate(
  5000L,
  mean(sample(
    inventory_scores$reconstruction_gain,
    replace = TRUE,
    size = nrow(inventory_scores)
  ))
)
gain_interval <- unname(stats::quantile(bootstrap_gain, c(0.025, 0.975)))

test_summary <- data.frame(
  training_inventories = length(training_index),
  validation_inventories = length(validation$rows),
  test_inventories = length(test$rows),
  retained_segments = ncol(X),
  validation_cells = sum(validation$mask),
  test_cells = sum(test$mask),
  selected_rank = selected_rank,
  selected_variance_fraction = sum(decomposition$d[seq_len(selected_rank)]^2) /
    total_centered_ss,
  test_prevalence_brier = balanced_loss(test_truth, test_baseline, "brier"),
  test_low_rank_brier = balanced_loss(test_truth, test_selected, "brier"),
  test_reconstruction_gain = balanced_loss(test_truth, test_baseline, "brier") -
    balanced_loss(test_truth, test_selected, "brier"),
  test_gain_ci_low = gain_interval[[1]],
  test_gain_ci_high = gain_interval[[2]],
  test_prevalence_log = balanced_loss(test_truth, test_baseline, "log"),
  test_low_rank_log = balanced_loss(test_truth, test_selected, "log")
)
stopifnot(
  test_summary$test_reconstruction_gain > 0.09,
  test_summary$test_gain_ci_low > 0
)
write_csv(test_summary, "phoible-test-summary.csv")

split_summary <- as.data.frame.matrix(table(split, selected$macroarea, useNA = "ifany"))
split_summary$split <- row.names(split_summary)
row.names(split_summary) <- NULL
split_summary <- split_summary[c("split", setdiff(names(split_summary), "split"))]
write_csv(split_summary, "phoible-split-summary.csv")

sample_summary <- data.frame(
  quantity = c(
    "original_value_rows",
    "original_inventories",
    "original_glottocodes",
    "retained_nonmarginal_consonant_vowel_memberships",
    "selected_one_per_glottocode",
    "training_inventories",
    "retained_segments_training_count_at_least_20",
    "matrix_cells",
    "listed_cells",
    "listed_cell_fraction"
  ),
  value = c(
    phoible$provenance$original_value_rows,
    phoible$provenance$original_inventories,
    phoible$provenance$original_glottocodes,
    nrow(phoible$memberships),
    nrow(selected),
    length(training_index),
    ncol(X),
    length(X),
    sum(X),
    mean(X)
  )
)
write_csv(sample_summary, "phoible-sample-summary.csv")

segment_summary <- data.frame(
  segment_id = colnames(X),
  segment = segment_metadata$segment,
  segment_class = segment_metadata$segment_class,
  training_count = as.integer(built$training_frequency[colnames(X)]),
  training_prevalence = training_mean,
  training_sd = training_sd,
  standardization_multiplier = 1 / training_sd
)
segment_summary <- segment_summary[
  order(segment_summary$training_prevalence, decreasing = TRUE),
]
write_csv(segment_summary, "phoible-segment-summary.csv")

svd_summary <- data.frame(
  component = seq_along(decomposition$d),
  singular_value = decomposition$d,
  eigenvalue = svd_eigenvalues,
  variance_fraction = decomposition$d^2 / total_centered_ss,
  cumulative_variance_fraction = cumsum(decomposition$d^2) / total_centered_ss
)
write_csv(svd_summary, "phoible-svd-summary.csv")

training_scores <- sweep(
  decomposition$u[, seq_len(5), drop = FALSE],
  2,
  decomposition$d[seq_len(5)],
  FUN = "*"
)
score_output <- data.frame(
  selected[training_index, c(
    "glottocode", "inventory_id", "language_name", "macroarea",
    "family_name", "inventory_source"
  )],
  training_scores
)
names(score_output)[(ncol(score_output) - 4):ncol(score_output)] <- paste0("PC", 1:5)
write_csv(score_output, "phoible-training-scores.csv")

top_loading_rows <- do.call(rbind, lapply(seq_len(5), function(component) {
  order_index <- order(abs(decomposition$v[, component]), decreasing = TRUE)[seq_len(12)]
  data.frame(
    component = component,
    segment_id = colnames(X)[order_index],
    segment = segment_metadata$segment[order_index],
    segment_class = segment_metadata$segment_class[order_index],
    loading = decomposition$v[order_index, component],
    absolute_loading = abs(decomposition$v[order_index, component]),
    rank_by_absolute_loading = seq_along(order_index)
  )
}))
write_csv(top_loading_rows, "phoible-top-loadings.csv")

pca_equivalence <- data.frame(
  maximum_absolute_eigenvalue_difference = svd_pca_max_difference,
  training_rows = nrow(training_centered),
  matrix_columns = ncol(training_centered),
  covariance_divisor = nrow(training_centered) - 1L
)
write_csv(pca_equivalence, "phoible-svd-pca-equivalence.csv")

# Figure 1: a readable empirical slice of the binary inventory matrix.
display_areas <- setdiff(sort(unique(selected$macroarea)), c("", NA, "Unclassified"))
display_rows <- unlist(lapply(display_areas, function(area) {
  candidates <- training_index[selected$macroarea[training_index] == area]
  candidates <- candidates[order(rowSums(X[candidates, , drop = FALSE]))]
  candidates[unique(round(seq(1, length(candidates), length.out = 4)))]
}), use.names = FALSE)
display_columns <- order(training_mean, decreasing = TRUE)[seq_len(20)]
matrix_slice <- X[display_rows, display_columns, drop = FALSE]
matrix_long <- make_long_matrix(
  matrix_slice,
  paste0(selected$language_name[display_rows], " (", selected$macroarea[display_rows], ")"),
  segment_metadata$segment[display_columns]
)
matrix_long$row_label <- factor(
  matrix_long$row_label,
  levels = rev(unique(matrix_long$row_label))
)
matrix_long$column_label <- factor(
  matrix_long$column_label,
  levels = unique(matrix_long$column_label)
)
inventory_plot <- ggplot2::ggplot(
  matrix_long,
  ggplot2::aes(x = column_label, y = row_label, fill = factor(value))
) +
  ggplot2::geom_tile(color = "grey85", linewidth = 0.15) +
  ggplot2::scale_fill_manual(
    values = c("0" = "white", "1" = "black"),
    labels = c("not listed", "listed"),
    name = "Inventory record"
  ) +
  ggplot2::labs(x = "PHOIBLE segment", y = "Selected inventory record") +
  theme_course() +
  ggplot2::theme(
    axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
    axis.ticks = ggplot2::element_blank()
  )
save_plot(inventory_plot, "phoible-inventory-matrix.png", 8.0, 7.0)

# Figure 2: the empirical consequence of standardizing binary columns.
scaling_long <- rbind(
  data.frame(
    segment = segment_summary$segment,
    quantity = "Training prevalence",
    value = segment_summary$training_prevalence
  ),
  data.frame(
    segment = segment_summary$segment,
    quantity = "Standardization multiplier",
    value = segment_summary$standardization_multiplier
  )
)
scaling_plot <- ggplot2::ggplot(
  scaling_long,
  ggplot2::aes(x = value)
) +
  ggplot2::geom_histogram(bins = 28, fill = "grey35", color = "white") +
  ggplot2::facet_wrap(~quantity, scales = "free_x") +
  ggplot2::labs(x = NULL, y = "Number of retained segments") +
  theme_course()
save_plot(scaling_plot, "phoible-centering-scaling.png", 7.2, 3.2)

# Figure 3: observed centered cells and the fitted rank-one pattern.
pc1_order <- order(training_scores[, 1])
rank_one_rows_local <- unique(round(seq(1, length(pc1_order), length.out = 28)))
rank_one_rows <- training_index[pc1_order[rank_one_rows_local]]
rank_one_columns <- order(abs(decomposition$v[, 1]), decreasing = TRUE)[seq_len(22)]
rank_one_observed <- training_centered[
  match(rank_one_rows, training_index),
  rank_one_columns,
  drop = FALSE
]
rank_one_fitted <- training_scores[
  match(rank_one_rows, training_index),
  1,
  drop = FALSE
] %*% t(decomposition$v[rank_one_columns, 1, drop = FALSE])
rank_one_long <- rbind(
  transform(
    make_long_matrix(
      rank_one_observed,
      selected$language_name[rank_one_rows],
      segment_metadata$segment[rank_one_columns]
    ),
    matrix = "Observed centered cells"
  ),
  transform(
    make_long_matrix(
      rank_one_fitted,
      selected$language_name[rank_one_rows],
      segment_metadata$segment[rank_one_columns]
    ),
    matrix = "Rank-one reconstruction"
  )
)
rank_one_long$row_label <- factor(
  rank_one_long$row_label,
  levels = rev(unique(rank_one_long$row_label))
)
rank_one_long$column_label <- factor(
  rank_one_long$column_label,
  levels = unique(rank_one_long$column_label)
)
rank_one_limit <- max(abs(rank_one_long$value))
rank_one_plot <- ggplot2::ggplot(
  rank_one_long,
  ggplot2::aes(x = column_label, y = row_label, fill = value)
) +
  ggplot2::geom_tile() +
  ggplot2::facet_wrap(~matrix, ncol = 2) +
  ggplot2::scale_fill_gradient2(
    low = "#2166ac",
    mid = "white",
    high = "#b2182b",
    midpoint = 0,
    limits = c(-rank_one_limit, rank_one_limit),
    name = "Centered value"
  ) +
  ggplot2::labs(x = "PHOIBLE segment", y = "Selected inventory record") +
  theme_course() +
  ggplot2::theme(
    axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
    axis.ticks = ggplot2::element_blank()
  )
save_plot(rank_one_plot, "phoible-rank-one.png", 11.0, 7.0)

# Figure 4: empirical singular-value spectrum.
scree_plot <- ggplot2::ggplot(
  svd_summary[svd_summary$component <= 64, ],
  ggplot2::aes(x = component, y = variance_fraction)
) +
  ggplot2::geom_line(color = "grey30", linewidth = 0.6) +
  ggplot2::geom_point(color = "grey20", size = 1.2) +
  ggplot2::labs(
    x = "Component",
    y = "Fraction of centered sum of squares"
  ) +
  theme_course()
save_plot(scree_plot, "phoible-scree.png", 6.4, 3.8)

# Figure 5: score coordinates, with metadata used only after fitting.
score_plot_data <- score_output
score_plot_data$macroarea[
  is.na(score_plot_data$macroarea) | score_plot_data$macroarea == ""
] <- "Unclassified"
score_plot <- ggplot2::ggplot(
  score_plot_data,
  ggplot2::aes(x = PC1, y = PC2)
) +
  ggplot2::geom_point(color = "grey25", alpha = 0.45, size = 0.8) +
  ggplot2::facet_wrap(~macroarea) +
  ggplot2::labs(x = "PC1 score", y = "PC2 score") +
  theme_course()
save_plot(score_plot, "phoible-pca-scores.png", 8.2, 5.8)

# Figure 6: segment loadings for the first two components.
loading_plot_data <- top_loading_rows[top_loading_rows$component <= 2, ]
loading_plot_data$component <- paste0("PC", loading_plot_data$component)
loading_plot_data$plot_label <- paste(
  loading_plot_data$component,
  loading_plot_data$segment,
  sep = "::"
)
loading_plot_data$plot_label <- factor(
  loading_plot_data$plot_label,
  levels = loading_plot_data$plot_label[order(loading_plot_data$loading)]
)
loading_labels <- setNames(
  loading_plot_data$segment,
  as.character(loading_plot_data$plot_label)
)
loading_plot <- ggplot2::ggplot(
  loading_plot_data,
  ggplot2::aes(x = loading, y = plot_label)
) +
  ggplot2::geom_vline(xintercept = 0, color = "grey75", linewidth = 0.4) +
  ggplot2::geom_point(color = "grey20", size = 1.8) +
  ggplot2::facet_grid(
    component ~ .,
    scales = "free_y",
    space = "free_y"
  ) +
  ggplot2::scale_y_discrete(labels = loading_labels) +
  ggplot2::labs(x = "Loading", y = "PHOIBLE segment") +
  theme_course()
save_plot(loading_plot, "phoible-loadings.png", 6.0, 6.8)

# Figure 7: raw held-out statuses and fitted probabilities.
reconstruction_plot_data <- rbind(
  data.frame(
    listed = factor(test_predictions$listed, levels = c(0, 1), labels = c("not listed", "listed")),
    prediction = test_predictions$prevalence_prediction,
    model = "Segment prevalence"
  ),
  data.frame(
    listed = factor(test_predictions$listed, levels = c(0, 1), labels = c("not listed", "listed")),
    prediction = test_predictions$low_rank_prediction,
    model = paste0("Rank ", selected_rank, " reconstruction")
  )
)
reconstruction_plot <- ggplot2::ggplot(
  reconstruction_plot_data,
  ggplot2::aes(x = listed, y = prediction)
) +
  ggplot2::geom_jitter(
    width = 0.10,
    height = 0,
    alpha = 0.09,
    size = 0.7,
    color = "grey20"
  ) +
  ggplot2::geom_boxplot(
    width = 0.35,
    outlier.shape = NA,
    fill = NA,
    color = "#0072B2",
    linewidth = 0.7
  ) +
  ggplot2::facet_wrap(~model) +
  ggplot2::coord_cartesian(ylim = c(0, 1)) +
  ggplot2::labs(
    x = "Held-out inventory cell",
    y = "Predicted listing probability"
  ) +
  theme_course()
save_plot(reconstruction_plot, "phoible-reconstruction.png", 7.2, 3.8)

# Figure 8: validation selects rank without inspecting test loss.
rank_plot <- ggplot2::ggplot(
  rank_curve,
  ggplot2::aes(x = rank, y = validation_balanced_brier)
) +
  ggplot2::geom_line(color = "grey25", linewidth = 0.7) +
  ggplot2::geom_point(color = "grey20", size = 1.8) +
  ggplot2::geom_vline(
    xintercept = selected_rank,
    color = "#0072B2",
    linewidth = 0.6
  ) +
  ggplot2::labs(x = "Retained rank", y = "Validation balanced Brier loss") +
  theme_course()
save_plot(rank_plot, "phoible-rank-selection.png", 6.4, 3.8)
cat("Completed PHOIBLE computations and figures.\n", file = stderr())

# -----------------------------------------------------------------------------
# VALEX -> MegaAcceptability: read and verify the frozen leakage-safe pilot.
# -----------------------------------------------------------------------------

vm_root <- file.path(
  project_root,
  "research/dataset-audits/valex-megaacceptability"
)
vm_files <- c(
  "data/valex-counts.csv.gz" = "9d49540c06c31feeeac6f3eb0522d24f2f89b5875b18d99a92d7d8f2b120efa6",
  "data/megaacceptability-responses.csv.gz" = "43e56084bcfa87750679732df7ea8abec84ab29a1c33ba1e6b180d30119b8a7a",
  "results/outer-predictions.csv.gz" = "71e4855179739ae9cf102edfb9a24d10187d8492e4d54ed6cea4cde3e8639ceb",
  "results/inner-validation-curves.csv.gz" = "2fb978dad5a47c4ffa6845d4ee6b7d53f801720d1df9986430c9bd0a6d09660b",
  "results/family-metrics.csv" = "4add76f32fcff91634cf72f5eff4f29c80721d7393d731bab0be593aaabd4db2",
  "results/pilot-summary.json" = "d299d4fdfa49dc7e4864ce7e28d647c29f8722894eb7fe8cf29e24f8bcafffc0"
)
observed_vm_hashes <- vapply(
  file.path(vm_root, names(vm_files)),
  sha256_file,
  character(1)
)
stopifnot(identical(unname(observed_vm_hashes), unname(vm_files)))

valex <- utils::read.csv(
  gzfile(file.path(vm_root, "data/valex-counts.csv.gz")),
  check.names = FALSE
)
mega <- utils::read.csv(
  gzfile(file.path(vm_root, "data/megaacceptability-responses.csv.gz")),
  check.names = FALSE
)
outer <- utils::read.csv(
  gzfile(file.path(vm_root, "results/outer-predictions.csv.gz")),
  check.names = FALSE
)
inner <- utils::read.csv(
  gzfile(file.path(vm_root, "results/inner-validation-curves.csv.gz")),
  check.names = FALSE
)
family_metrics <- utils::read.csv(
  file.path(vm_root, "results/family-metrics.csv"),
  check.names = FALSE
)
write_csv(family_metrics, "valex-megaacceptability-frame-families.csv")
pilot_summary <- jsonlite::read_json(
  file.path(vm_root, "results/pilot-summary.json"),
  simplifyVector = TRUE
)
cat("Loaded frozen VALEX--MegaAcceptability inputs.\n", file = stderr())

stopifnot(
  nrow(valex) == 958L,
  ncol(valex) == 110L,
  all(rowSums(valex[-1]) > 0),
  nrow(mega) == 238917L,
  length(unique(mega$participant)) == 727L,
  length(unique(mega$verb)) == 958L,
  length(unique(mega$frame)) == 50L,
  nrow(outer) == 239500L,
  length(unique(outer$verb)) == 958L,
  length(unique(outer$frame)) == 50L
)

skill <- function(outcome, prediction, baseline) {
  1 - sum((outcome - prediction)^2) / sum((outcome - baseline)^2)
}

direct_skill <- skill(outer$outcome, outer$direct, outer$baseline)
factor_skill <- skill(outer$outcome, outer$factor, outer$baseline)
delta_skill <- factor_skill - direct_skill
stopifnot(
  abs(direct_skill - pilot_summary$performance$direct_skill) < 1e-12,
  abs(factor_skill - pilot_summary$performance$factor_skill) < 1e-12,
  abs(delta_skill - pilot_summary$performance$factor_minus_direct) < 1e-12
)

performance <- data.frame(
  model = c("direct", "factor", "factor_minus_direct"),
  heldout_skill = c(direct_skill, factor_skill, delta_skill),
  interval_low = c(
    pilot_summary$performance$bootstrap$direct$ci_low,
    pilot_summary$performance$bootstrap$factor$ci_low,
    pilot_summary$performance$bootstrap$delta$ci_low
  ),
  interval_high = c(
    pilot_summary$performance$bootstrap$direct$ci_high,
    pilot_summary$performance$bootstrap$factor$ci_high,
    pilot_summary$performance$bootstrap$delta$ci_high
  )
)
write_csv(performance, "valex-megaacceptability-performance.csv")

vm_summary <- data.frame(
  quantity = c(
    "shared_verbs",
    "valex_dimensions",
    "megaacceptability_frames",
    "retained_native_speaker_responses",
    "participants",
    "outer_repetitions",
    "outer_folds_per_repetition",
    "inner_folds",
    "factor_rank_selected_in_all_outer_folds"
  ),
  value = c(
    nrow(valex),
    ncol(valex) - 1L,
    length(unique(mega$frame)),
    nrow(mega),
    length(unique(mega$participant)),
    length(unique(outer[["repeat"]])),
    length(unique(outer$fold)),
    pilot_summary$frozen_settings$inner_folds,
    50L
  )
)
write_csv(vm_summary, "valex-megaacceptability-sample-summary.csv")

outer_key <- paste(outer$verb, outer$frame, sep = "\r")
outer_levels <- unique(outer_key)
outer_group <- match(outer_key, outer_levels)
outer_count <- tabulate(outer_group, nbins = length(outer_levels))
outer_sums <- rowsum(
  as.matrix(outer[c("outcome", "direct", "factor")]),
  group = outer_group,
  reorder = FALSE
)
outer_first <- match(seq_along(outer_levels), outer_group)
outer_average <- data.frame(
  verb = outer$verb[outer_first],
  frame = outer$frame[outer_first],
  sweep(outer_sums, 1, outer_count, FUN = "/")
)
stopifnot(nrow(outer_average) == 47900L)
cat("Aggregated held-out verb-by-frame predictions.\n", file = stderr())

heldout_plot_data <- rbind(
  data.frame(
    outcome = outer_average$outcome,
    prediction = outer_average$direct,
    model = "Direct VALEX profile"
  ),
  data.frame(
    outcome = outer_average$outcome,
    prediction = outer_average$factor,
    model = "PCA VALEX profile"
  )
)
heldout_limits <- range(
  c(heldout_plot_data$outcome, heldout_plot_data$prediction),
  finite = TRUE
)
heldout_breaks <- seq(heldout_limits[[1]], heldout_limits[[2]], length.out = 35L)
heldout_plot_data$outcome_bin <- cut(
  heldout_plot_data$outcome,
  breaks = heldout_breaks,
  include.lowest = TRUE,
  labels = FALSE
)
heldout_plot_data$prediction_bin <- cut(
  heldout_plot_data$prediction,
  breaks = heldout_breaks,
  include.lowest = TRUE,
  labels = FALSE
)
heldout_bins <- as.data.frame(table(
  heldout_plot_data$model,
  heldout_plot_data$outcome_bin,
  heldout_plot_data$prediction_bin
))
names(heldout_bins) <- c("model", "outcome_bin", "prediction_bin", "cells")
heldout_bins <- heldout_bins[heldout_bins$cells > 0, ]
heldout_centers <- head(heldout_breaks, -1) + diff(heldout_breaks) / 2
heldout_bins$outcome <- heldout_centers[as.integer(heldout_bins$outcome_bin)]
heldout_bins$prediction <- heldout_centers[as.integer(heldout_bins$prediction_bin)]
heldout_plot <- ggplot2::ggplot(
  heldout_bins,
  ggplot2::aes(x = outcome, y = prediction, fill = cells)
) +
  ggplot2::geom_tile() +
  ggplot2::geom_abline(
    slope = 1,
    intercept = 0,
    color = "white",
    linewidth = 0.45
  ) +
  ggplot2::facet_wrap(~model) +
  ggplot2::coord_equal(xlim = heldout_limits, ylim = heldout_limits) +
  ggplot2::scale_fill_gradient(low = "grey90", high = "#0072B2", name = "Cells") +
  ggplot2::labs(
    x = "Held-out normalized acceptability",
    y = "Held-out prediction"
  ) +
  theme_course()
save_plot(heldout_plot, "valex-megaacceptability-heldout.png", 7.4, 3.9)
cat("Rendered held-out prediction figure.\n", file = stderr())

factor_inner <- inner[inner$model == "factor", ]
factor_fold_rank <- stats::aggregate(
  validation_mse ~ `repeat` + outer_fold + rank,
  data = factor_inner,
  FUN = min
)
factor_rank_curve <- stats::aggregate(
  validation_mse ~ rank,
  data = factor_fold_rank,
  FUN = mean
)
write_csv(factor_rank_curve, "valex-megaacceptability-rank-curve.csv")

vm_rank_plot <- ggplot2::ggplot(
  factor_rank_curve,
  ggplot2::aes(x = rank, y = validation_mse)
) +
  ggplot2::geom_line(color = "grey25", linewidth = 0.7) +
  ggplot2::geom_point(color = "grey20", size = 1.8) +
  ggplot2::geom_vline(xintercept = 50, color = "#0072B2", linewidth = 0.6) +
  ggplot2::labs(
    x = "Candidate PCA rank",
    y = "Mean inner-validation squared loss"
  ) +
  theme_course()
save_plot(vm_rank_plot, "valex-megaacceptability-rank-selection.png", 6.4, 3.8)
cat("Rendered VALEX rank-selection figure.\n", file = stderr())

family_long <- rbind(
  data.frame(
    family = family_metrics$family,
    model = "Direct",
    skill = family_metrics$direct_skill
  ),
  data.frame(
    family = family_metrics$family,
    model = "Factor",
    skill = family_metrics$factor_skill
  )
)
family_order <- family_metrics$family[order(family_metrics$direct_skill)]
family_long$family <- factor(family_long$family, levels = family_order)
family_plot <- ggplot2::ggplot(
  family_long,
  ggplot2::aes(x = skill, y = family, shape = model)
) +
  ggplot2::geom_line(
    ggplot2::aes(group = family),
    color = "grey70",
    linewidth = 0.5
  ) +
  ggplot2::geom_point(color = "grey20", size = 2.0) +
  ggplot2::scale_shape_manual(values = c("Direct" = 16, "Factor" = 1)) +
  ggplot2::labs(x = "Held-out skill", y = "Frame family", shape = NULL) +
  theme_course()
save_plot(family_plot, "valex-megaacceptability-frame-families.png", 7.0, 4.2)
cat("Rendered VALEX frame-family figure.\n", file = stderr())

# -----------------------------------------------------------------------------
# Registry, provenance, and reproducibility artifacts
# -----------------------------------------------------------------------------

page_registry <- data.frame(
  page = c(
    "factorization/data-matrices.qmd",
    "factorization/centering-and-scaling.qmd",
    "factorization/rank-one-structure.qmd",
    "factorization/singular-value-decomposition.qmd",
    "factorization/principal-component-analysis.qmd",
    "factorization/scores-and-loadings.qmd",
    "factorization/reconstruction.qmd",
    "factorization/choosing-components.qmd",
    "factorization/valex-megaacceptability.qmd"
  ),
  dataset = c(rep("PHOIBLE 2.0", 8), "VALEX + MegaAcceptability 1.2"),
  empirical_unit = c(
    rep("one selected inventory record per Glottocode", 8),
    "one matched English verb; raw outcomes are participant-by-item ratings"
  ),
  principal_output = c(
    "phoible-sample-summary.csv; phoible-inventory-matrix.png",
    "phoible-segment-summary.csv; phoible-centering-scaling.png",
    "phoible-rank-one.png; phoible-svd-summary.csv",
    "phoible-svd-summary.csv; phoible-scree.png",
    "phoible-svd-pca-equivalence.csv; phoible-pca-scores.png",
    "phoible-training-scores.csv; phoible-top-loadings.csv; phoible-loadings.png",
    "phoible-test-summary.csv; phoible-test-predictions.csv; phoible-reconstruction.png",
    "phoible-rank-curve.csv; phoible-rank-selection.png",
    "valex-megaacceptability-performance.csv; valex-megaacceptability-heldout.png"
  ),
  heldout_rule = c(
    rep("training inventories define columns, means, and component directions", 6),
    "test inventories contribute observed cells only to their own score; six cells are hidden",
    "validation inventories select rank; test inventories are inspected once",
    "complete verbs are held out; normalization, PCA, rank, and ridge are fitted inside folds"
  )
)
write_csv(page_registry, "page-registry.csv")

input_checksums <- data.frame(
  file = c("data/phoible/phoible-pilot.rds", names(vm_files)),
  observed_sha256 = c(sha256_file(phoible_path), unname(observed_vm_hashes)),
  expected_sha256 = c(phoible_object_sha256, unname(vm_files)),
  check = rep("exact file hash verified", length(vm_files) + 1L)
)
write_csv(input_checksums, "input-checksums.csv")

software <- data.frame(
  component = c("R", "ggplot2", "jsonlite", "ragg", "platform"),
  version = c(
    paste(R.version$major, R.version$minor, sep = "."),
    as.character(utils::packageVersion("ggplot2")),
    as.character(utils::packageVersion("jsonlite")),
    as.character(utils::packageVersion("ragg")),
    R.version$platform
  )
)
write_csv(software, "software-runtime.csv")
writeLines(capture.output(sessionInfo()), file.path(output_dir, "session-info.txt"))

run_summary <- c(
  paste("PHOIBLE matrix:", nrow(X), "selected inventories x", ncol(X), "training-retained segments"),
  paste("PHOIBLE split:", length(training_index), "training,", length(validation_index), "validation,", length(test_index), "test inventories"),
  paste("PHOIBLE selected rank:", selected_rank),
  sprintf("PHOIBLE test balanced Brier: prevalence %.6f; low-rank %.6f; gain %.6f", test_summary$test_prevalence_brier, test_summary$test_low_rank_brier, test_summary$test_reconstruction_gain),
  sprintf("PHOIBLE inventory-bootstrap 95%% gain interval: [%.6f, %.6f]", gain_interval[[1]], gain_interval[[2]]),
  sprintf("VALEX direct held-out skill: %.6f", direct_skill),
  sprintf("VALEX PCA held-out skill: %.6f", factor_skill),
  sprintf("VALEX PCA minus direct: %.6f", delta_skill),
  "All assertions passed."
)
writeLines(run_summary, file.path(output_dir, "run-summary.txt"))

output_files <- list.files(output_dir, full.names = TRUE)
output_files <- output_files[basename(output_files) != "output-checksums.csv"]
output_checksums <- data.frame(
  file = basename(output_files),
  sha256 = vapply(output_files, sha256_file, character(1))
)
write_csv(output_checksums, "output-checksums.csv")

cat(paste(run_summary, collapse = "\n"), "\n")
