select_inventories <- function(inventory_table, rule) {
  inventory_table <- inventory_table[
    order(
      inventory_table$glottocode,
      as.integer(inventory_table$inventory_id)
    ),
  ]
  by_glottocode <- split(
    seq_len(nrow(inventory_table)),
    inventory_table$glottocode
  )

  if (rule == "seeded_random") {
    RNGkind(sample.kind = "Rejection")
    set.seed(20260827)
    selected_rows <- vapply(
      by_glottocode,
      function(index) index[[sample.int(length(index), size = 1L)]],
      integer(1)
    )
  } else if (rule == "largest_inventory") {
    selected_rows <- vapply(
      by_glottocode,
      function(index) {
        candidate <- inventory_table[index, ]
        index[[order(
          -candidate$n_segments,
          as.integer(candidate$inventory_id)
        )[[1]]]]
      },
      integer(1)
    )
  } else {
    stop("Unknown selection rule: ", rule)
  }

  inventory_table[unname(selected_rows), ]
}

build_inventory_matrix <- function(prepared, selected, minimum_count) {
  selected_memberships <- merge(
    prepared$memberships,
    selected[c("inventory_id", "glottocode")],
    by = c("inventory_id", "glottocode"),
    all = FALSE,
    sort = FALSE
  )
  frequencies <- table(selected_memberships$segment_id)
  retained_segments <- names(frequencies)[frequencies >= minimum_count]
  selected_memberships <- selected_memberships[
    selected_memberships$segment_id %in% retained_segments,
  ]

  row_ids <- sort(unique(selected$glottocode))
  column_ids <- sort(retained_segments)
  inventory_matrix <- matrix(
    0,
    nrow = length(row_ids),
    ncol = length(column_ids),
    dimnames = list(row_ids, column_ids)
  )
  row_index <- match(selected_memberships$glottocode, row_ids)
  column_index <- match(selected_memberships$segment_id, column_ids)
  inventory_matrix[cbind(row_index, column_index)] <- 1

  row_metadata <- selected[match(row_ids, selected$glottocode), ]
  stopifnot(
    identical(row_ids, row_metadata$glottocode),
    !anyDuplicated(row_metadata$glottocode)
  )

  list(
    matrix = inventory_matrix,
    metadata = row_metadata,
    frequencies = frequencies[retained_segments]
  )
}

make_balanced_masks <- function(inventory_matrix, seed) {
  set.seed(seed)
  validation <- matrix(FALSE, nrow(inventory_matrix), ncol(inventory_matrix))
  test <- matrix(FALSE, nrow(inventory_matrix), ncol(inventory_matrix))
  eligible <- logical(nrow(inventory_matrix))

  for (row in seq_len(nrow(inventory_matrix))) {
    present <- which(inventory_matrix[row, ] == 1)
    absent <- which(inventory_matrix[row, ] == 0)
    if (length(present) >= 10L && length(absent) >= 10L) {
      eligible[[row]] <- TRUE
      present <- sample(present, size = 6L, replace = FALSE)
      absent <- sample(absent, size = 6L, replace = FALSE)
      validation[row, c(present[1:3], absent[1:3])] <- TRUE
      test[row, c(present[4:6], absent[4:6])] <- TRUE
    }
  }

  list(validation = validation, test = test, eligible = eligible)
}

fit_low_rank <- function(inventory_matrix, mask, maximum_rank) {
  training <- inventory_matrix
  training[mask] <- NA_real_
  column_means <- colMeans(training, na.rm = TRUE)
  column_means[!is.finite(column_means)] <- 0
  centered <- sweep(training, 2, column_means, FUN = "-")
  centered[is.na(centered)] <- 0
  decomposition <- svd(
    centered,
    nu = maximum_rank,
    nv = maximum_rank
  )
  list(
    mean = column_means,
    u = decomposition$u,
    d = decomposition$d[seq_len(maximum_rank)],
    v = decomposition$v,
    total_squared_singular_values = sum(decomposition$d^2)
  )
}

predict_masked <- function(fit, mask, rank) {
  cells <- which(mask, arr.ind = TRUE)
  predictions <- fit$mean[cells[, "col"]]
  if (rank > 0L) {
    component_index <- seq_len(rank)
    left <- fit$u[cells[, "row"], component_index, drop = FALSE]
    right <- fit$v[cells[, "col"], component_index, drop = FALSE]
    right <- sweep(right, 2, fit$d[component_index], FUN = "*")
    predictions <- predictions + rowSums(left * right)
  }
  pmin(pmax(predictions, 1e-6), 1 - 1e-6)
}

balanced_score <- function(truth, prediction, loss = "brier") {
  if (loss == "brier") {
    cell_loss <- (truth - prediction)^2
  } else if (loss == "log") {
    cell_loss <- -(
      truth * log(prediction) + (1 - truth) * log(1 - prediction)
    )
  } else {
    stop("Unknown loss: ", loss)
  }
  0.5 * mean(cell_loss[truth == 1]) +
    0.5 * mean(cell_loss[truth == 0])
}

score_by_inventory <- function(inventory_matrix, mask, baseline, low_rank) {
  cells <- which(mask, arr.ind = TRUE)
  truth <- inventory_matrix[mask]
  cell_scores <- data.frame(
    row = cells[, "row"],
    truth = truth,
    baseline_loss = (truth - baseline)^2,
    low_rank_loss = (truth - low_rank)^2
  )
  by_row <- split(cell_scores, cell_scores$row)
  summaries <- lapply(by_row, function(one_row) {
    data.frame(
      row = one_row$row[[1]],
      baseline_brier = 0.5 * mean(
        one_row$baseline_loss[one_row$truth == 1]
      ) + 0.5 * mean(one_row$baseline_loss[one_row$truth == 0]),
      low_rank_brier = 0.5 * mean(
        one_row$low_rank_loss[one_row$truth == 1]
      ) + 0.5 * mean(one_row$low_rank_loss[one_row$truth == 0])
    )
  })
  output <- do.call(rbind, summaries)
  output$irg <- output$baseline_brier - output$low_rank_brier
  row.names(output) <- NULL
  output
}

summarize_groups <- function(row_scores, metadata) {
  scored_metadata <- cbind(
    metadata[row_scores$row, , drop = FALSE],
    row_scores[c("baseline_brier", "low_rank_brier", "irg")]
  )
  group_variables <- c(
    inventory_source = "inventory_source",
    family = "family_name",
    macroarea = "macroarea"
  )

  output <- lapply(names(group_variables), function(grouping) {
    variable <- group_variables[[grouping]]
    labels <- scored_metadata[[variable]]
    labels[is.na(labels) | labels == ""] <- "Unclassified"
    partitions <- split(seq_len(nrow(scored_metadata)), labels)
    do.call(rbind, lapply(names(partitions), function(label) {
      rows <- partitions[[label]]
      data.frame(
        grouping = grouping,
        group = label,
        n = length(rows),
        baseline_brier = mean(scored_metadata$baseline_brier[rows]),
        low_rank_brier = mean(scored_metadata$low_rank_brier[rows]),
        irg = mean(scored_metadata$irg[rows]),
        proportion_inventories_positive = mean(scored_metadata$irg[rows] > 0),
        stringsAsFactors = FALSE
      )
    }))
  })
  do.call(rbind, output)
}

association_ratio <- function(values, groups) {
  keep <- is.finite(values) & !is.na(groups) & groups != ""
  values <- values[keep]
  groups <- groups[keep]
  grand_mean <- mean(values)
  group_rows <- split(seq_along(values), groups)
  between <- sum(vapply(group_rows, function(rows) {
    length(rows) * (mean(values[rows]) - grand_mean)^2
  }, numeric(1)))
  total <- sum((values - grand_mean)^2)
  if (total == 0) 0 else between / total
}

score_associations <- function(fit, rank, metadata) {
  scores <- sweep(
    fit$u[, seq_len(rank), drop = FALSE],
    2,
    fit$d[seq_len(rank)],
    FUN = "*"
  )
  family <- metadata$family_name
  family[is.na(family) | family == ""] <- "Unclassified"
  family_counts <- table(family)
  family[family_counts[family] < 15L] <- "Other small families"

  groupings <- list(
    inventory_source = metadata$inventory_source,
    family = family,
    macroarea = metadata$macroarea
  )
  output <- lapply(names(groupings), function(grouping) {
    data.frame(
      grouping = grouping,
      component = seq_len(rank),
      association_ratio = vapply(
        seq_len(rank),
        function(component) {
          association_ratio(scores[, component], groupings[[grouping]])
        },
        numeric(1)
      )
    )
  })
  do.call(rbind, output)
}

top_loadings <- function(fit, prepared, matrix_columns, component, n = 10L) {
  segment_metadata <- prepared$segments[
    match(matrix_columns, prepared$segments$segment_id),
  ]
  loadings <- fit$v[, component]
  positive <- order(loadings, decreasing = TRUE)[seq_len(n)]
  negative <- order(loadings, decreasing = FALSE)[seq_len(n)]
  data.frame(
    direction = rep(c("positive", "negative"), each = n),
    segment = c(
      segment_metadata$segment[positive],
      segment_metadata$segment[negative]
    ),
    segment_class = c(
      segment_metadata$segment_class[positive],
      segment_metadata$segment_class[negative]
    ),
    loading = c(loadings[positive], loadings[negative]),
    stringsAsFactors = FALSE
  )
}

run_phoible_scenario <- function(
  prepared,
  selection_rule,
  minimum_count,
  candidate_ranks = c(1L, 2L, 3L, 5L, 8L, 12L, 16L, 24L, 32L, 40L)
) {
  selected <- select_inventories(prepared$inventories, selection_rule)
  built <- build_inventory_matrix(prepared, selected, minimum_count)
  inventory_matrix <- built$matrix
  maximum_rank <- min(max(candidate_ranks), min(dim(inventory_matrix)) - 1L)
  ranks <- candidate_ranks[candidate_ranks <= maximum_rank]
  mask_seed <- 20260827L + minimum_count +
    ifelse(selection_rule == "largest_inventory", 1000L, 0L)
  masks <- make_balanced_masks(inventory_matrix, mask_seed)

  validation_fit <- fit_low_rank(
    inventory_matrix,
    masks$validation | masks$test,
    maximum_rank
  )
  validation_truth <- inventory_matrix[masks$validation]
  validation_baseline <- predict_masked(
    validation_fit,
    masks$validation,
    rank = 0L
  )
  validation_scores <- vapply(ranks, function(rank) {
    prediction <- predict_masked(validation_fit, masks$validation, rank)
    balanced_score(validation_truth, prediction, "brier")
  }, numeric(1))
  selected_rank <- ranks[[which.min(validation_scores)]]

  rank_curve <- data.frame(
    rank = c(0L, ranks),
    validation_brier = c(
      balanced_score(validation_truth, validation_baseline, "brier"),
      validation_scores
    )
  )

  test_fit <- fit_low_rank(inventory_matrix, masks$test, maximum_rank)
  test_truth <- inventory_matrix[masks$test]
  test_baseline <- predict_masked(test_fit, masks$test, rank = 0L)
  test_low_rank <- predict_masked(test_fit, masks$test, selected_rank)
  test_baseline_brier <- balanced_score(test_truth, test_baseline, "brier")
  test_low_rank_brier <- balanced_score(test_truth, test_low_rank, "brier")

  row_scores <- score_by_inventory(
    inventory_matrix,
    masks$test,
    test_baseline,
    test_low_rank
  )

  summary <- data.frame(
    selection_rule = selection_rule,
    minimum_count = minimum_count,
    n_inventories = nrow(inventory_matrix),
    n_segments = ncol(inventory_matrix),
    n_eligible_inventories = sum(masks$eligible),
    n_validation_cells = sum(masks$validation),
    n_test_cells = sum(masks$test),
    selected_rank = selected_rank,
    variance_fraction_at_selected_rank = sum(
      test_fit$d[seq_len(selected_rank)]^2
    ) / test_fit$total_squared_singular_values,
    validation_baseline_brier = rank_curve$validation_brier[
      rank_curve$rank == 0L
    ],
    validation_selected_brier = rank_curve$validation_brier[
      rank_curve$rank == selected_rank
    ],
    test_baseline_brier = test_baseline_brier,
    test_low_rank_brier = test_low_rank_brier,
    test_irg = test_baseline_brier - test_low_rank_brier,
    test_baseline_log_loss = balanced_score(
      test_truth,
      test_baseline,
      "log"
    ),
    test_low_rank_log_loss = balanced_score(
      test_truth,
      test_low_rank,
      "log"
    )
  )
  summary$validation_irg <-
    summary$validation_baseline_brier - summary$validation_selected_brier

  list(
    summary = summary,
    selected = selected,
    built = built,
    masks = masks,
    rank_curve = rank_curve,
    validation_fit = validation_fit,
    test_fit = test_fit,
    test_truth = test_truth,
    test_baseline = test_baseline,
    test_low_rank = test_low_rank,
    row_scores = row_scores,
    group_diagnostics = summarize_groups(row_scores, built$metadata),
    score_associations = score_associations(
      test_fit,
      selected_rank,
      built$metadata
    )
  )
}
