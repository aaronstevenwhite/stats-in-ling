#!/usr/bin/env Rscript

# Paper-first reference analysis for the latent-structure notes.
#
# The script uses Peterson and Barney's (1952) acoustic production table as
# distributed in phonTools 0.2-2.2. Intended-vowel labels are never passed to
# K-means or Gaussian-mixture fitting. They enter only after fitting, where they
# serve as external metadata for interpretation and validation.

required_packages <- c(
  "cluster", "digest", "dplyr", "ggplot2", "jsonlite", "mclust",
  "phonTools", "tidyr"
)
missing_packages <- required_packages[
  !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
]
if (length(missing_packages) > 0L) {
  stop("Install required packages: ", paste(missing_packages, collapse = ", "))
}

expected_versions <- c(
  phonTools = "0.2.2.2",
  mclust = "6.0.1",
  cluster = "2.1.4"
)
installed_versions <- vapply(
  names(expected_versions),
  function(pkg) as.character(utils::packageVersion(pkg)),
  character(1)
)
if (!identical(installed_versions, expected_versions)) {
  stop(
    "Reference package versions differ. Expected ",
    paste(names(expected_versions), expected_versions, sep = "=", collapse = ", "),
    "; found ",
    paste(names(installed_versions), installed_versions, sep = "=", collapse = ", ")
  )
}

suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)
  library(mclust)
  library(tidyr)
})

options(stringsAsFactors = FALSE)

output_dir <- file.path(
  "research", "dataset-audits", "reference-latent-structure-output"
)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

seed <- 1952L
start_time <- Sys.time()

write_csv <- function(x, name) {
  utils::write.csv(
    as.data.frame(x), file.path(output_dir, name), row.names = FALSE,
    na = ""
  )
}

save_plot <- function(plot, name, width = 7, height = 4.5) {
  ggplot2::ggsave(
    filename = file.path(output_dir, name), plot = plot,
    width = width, height = height, units = "in", dpi = 180,
    bg = "white"
  )
}

course_theme <- function(base_size = 11) {
  ggplot2::theme_classic(base_size = base_size) +
    ggplot2::theme(
      legend.position = "top",
      legend.title = element_blank(),
      strip.background = element_blank(),
      strip.text = element_text(face = "plain"),
      plot.title.position = "plot"
    )
}

pairwise_squared_distance <- function(x, centers) {
  x2 <- rowSums(x^2)
  c2 <- rowSums(centers^2)
  pmax(outer(x2, c2, "+") - 2 * tcrossprod(x, centers), 0)
}

nearest_centroid <- function(x, centers) {
  squared <- pairwise_squared_distance(x, centers)
  assignment <- max.col(-squared, ties.method = "first")
  data.frame(
    assignment = assignment,
    squared_distance = squared[cbind(seq_len(nrow(x)), assignment)]
  )
}

log_sum_exp_rows <- function(log_values) {
  row_max <- apply(log_values, 1, max)
  row_max + log(rowSums(exp(sweep(log_values, 1, row_max, "-"))))
}

diagonal_em <- function(
    x, components, seed, max_iterations = 500L, tolerance = 1e-9,
    variance_floor = 1e-4) {
  set.seed(seed)
  initial <- stats::kmeans(
    x, centers = components, nstart = 1L, iter.max = 50L,
    algorithm = "Hartigan-Wong"
  )
  n <- nrow(x)
  dimensions <- ncol(x)
  means <- initial$centers
  proportions <- as.numeric(table(factor(
    initial$cluster, levels = seq_len(components)
  ))) / n
  variances <- matrix(NA_real_, nrow = components, ncol = dimensions)
  for (component in seq_len(components)) {
    component_x <- x[initial$cluster == component, , drop = FALSE]
    variances[component, ] <- pmax(
      apply(component_x, 2, stats::var), variance_floor
    )
  }

  trace <- numeric(max_iterations)
  responsibilities <- matrix(NA_real_, nrow = n, ncol = components)
  for (iteration in seq_len(max_iterations)) {
    log_component_density <- sapply(seq_len(components), function(component) {
      centered <- sweep(x, 2, means[component, ], "-")
      log_variance <- matrix(
        log(2 * pi * variances[component, ]),
        nrow = n, ncol = dimensions, byrow = TRUE
      )
      log(proportions[component]) + rowSums(
        -0.5 * (
          log_variance +
            sweep(centered^2, 2, variances[component, ], "/")
        )
      )
    })
    log_density <- log_sum_exp_rows(log_component_density)
    trace[iteration] <- sum(log_density)
    responsibilities <- exp(sweep(
      log_component_density, 1, log_density, "-"
    ))

    effective_n <- colSums(responsibilities)
    proportions <- effective_n / n
    means <- sweep(t(responsibilities) %*% x, 1, effective_n, "/")
    for (component in seq_len(components)) {
      centered <- sweep(x, 2, means[component, ], "-")
      variances[component, ] <- pmax(
        colSums(responsibilities[, component] * centered^2) /
          effective_n[component],
        variance_floor
      )
    }

    if (
      iteration > 1L &&
        abs(trace[iteration] - trace[iteration - 1L]) <
          tolerance * (1 + abs(trace[iteration - 1L]))
    ) {
      break
    }
  }

  trace <- trace[seq_len(iteration)]
  list(
    seed = seed,
    log_likelihood = trace[length(trace)],
    iterations = iteration,
    trace = trace,
    proportions = proportions,
    means = means,
    variances = variances,
    responsibilities = responsibilities,
    variance_floor = variance_floor,
    tolerance = tolerance
  )
}

ellipse_points <- function(mean, covariance, component, level = 0.90) {
  eig <- eigen(covariance, symmetric = TRUE)
  if (any(eig$values <= 0)) {
    stop("Non-positive covariance eigenvalue for component ", component)
  }
  angles <- seq(0, 2 * pi, length.out = 181L)
  unit_circle <- rbind(cos(angles), sin(angles))
  transform <- eig$vectors %*%
    diag(sqrt(eig$values), nrow = 2L) *
    sqrt(stats::qchisq(level, df = 2L))
  points <- t(transform %*% unit_circle)
  data.frame(
    component = factor(component),
    z_f1 = points[, 1] + mean[1],
    z_f2 = points[, 2] + mean[2]
  )
}

# -----------------------------------------------------------------------------
# Source validation and represented objects
# -----------------------------------------------------------------------------

source_file <- system.file("data", "pb52.rda", package = "phonTools")
if (!nzchar(source_file) || !file.exists(source_file)) {
  stop("Could not locate phonTools/data/pb52.rda")
}

source_environment <- new.env(parent = emptyenv())
utils::data("pb52", package = "phonTools", envir = source_environment)
pb52 <- source_environment$pb52
expected_columns <- c(
  "type", "sex", "speaker", "vowel", "repetition", "f0", "f1", "f2", "f3"
)
stopifnot(
  is.data.frame(pb52),
  identical(dim(pb52), c(1520L, 9L)),
  identical(names(pb52), expected_columns),
  length(unique(pb52$speaker)) == 76L,
  all(table(pb52$speaker) == 20L),
  all(table(pb52$vowel) == 152L),
  setequal(unique(pb52$repetition), 1:2),
  all(stats::complete.cases(pb52))
)

pb52_checksums <- data.frame(
  object = c("phonTools/data/pb52.rda", "loaded pb52 R object"),
  algorithm = c("sha256", "sha256"),
  checksum = c(
    digest::digest(file = source_file, algo = "sha256"),
    digest::digest(pb52, algo = "sha256")
  )
)
stopifnot(
  pb52_checksums$checksum[1] ==
    "0084f2d0cd9882bca0652b011f31b91d5e0006be3fc761a962c95090aad7fa83",
  pb52_checksums$checksum[2] ==
    "63e97096d62f0cab8b02d4f77a3d87cc8bf8df26fb5cf8b48acd2dd8561b28f4"
)
write_csv(pb52_checksums, "source-checksums.csv")

speaker_labels <- c(c = "Children", m = "Men", w = "Women")
vowels <- pb52 |>
  mutate(
    row_id = row_number(),
    token_id = sprintf("speaker-%02d-%s-repetition-%d", speaker, vowel, repetition),
    speaker_type = factor(
      speaker_labels[as.character(type)],
      levels = c("Men", "Women", "Children")
    )
  ) |>
  group_by(speaker) |>
  mutate(
    z_f1 = (f1 - mean(f1)) / stats::sd(f1),
    z_f2 = (f2 - mean(f2)) / stats::sd(f2)
  ) |>
  ungroup() |>
  mutate(
    global_z_f1 = as.numeric(scale(f1)),
    global_z_f2 = as.numeric(scale(f2))
  )

stopifnot(
  max(abs(vowels |> group_by(speaker) |> summarise(m = mean(z_f1)) |> pull(m))) < 1e-12,
  max(abs(vowels |> group_by(speaker) |> summarise(m = mean(z_f2)) |> pull(m))) < 1e-12,
  max(abs(vowels |> group_by(speaker) |> summarise(s = sd(z_f1)) |> pull(s) - 1)) < 1e-12,
  max(abs(vowels |> group_by(speaker) |> summarise(s = sd(z_f2)) |> pull(s) - 1)) < 1e-12
)

dataset_summary <- data.frame(
  quantity = c(
    "token rows", "speakers", "tokens per speaker", "intended vowels",
    "repetitions per speaker-vowel", "men", "women", "children"
  ),
  value = c(
    nrow(vowels), n_distinct(vowels$speaker), unique(as.integer(table(vowels$speaker))),
    n_distinct(vowels$vowel), 2L,
    n_distinct(vowels$speaker[vowels$type == "m"]),
    n_distinct(vowels$speaker[vowels$type == "w"]),
    n_distinct(vowels$speaker[vowels$type == "c"])
  )
)
write_csv(dataset_summary, "dataset-summary.csv")

feature_summary <- bind_rows(
  data.frame(
    representation = "raw_hz", feature = c("F1", "F2"),
    mean = c(mean(vowels$f1), mean(vowels$f2)),
    sd = c(sd(vowels$f1), sd(vowels$f2)),
    minimum = c(min(vowels$f1), min(vowels$f2)),
    maximum = c(max(vowels$f1), max(vowels$f2))
  ),
  data.frame(
    representation = "within_speaker_z", feature = c("F1", "F2"),
    mean = c(mean(vowels$z_f1), mean(vowels$z_f2)),
    sd = c(sd(vowels$z_f1), sd(vowels$z_f2)),
    minimum = c(min(vowels$z_f1), min(vowels$z_f2)),
    maximum = c(max(vowels$z_f1), max(vowels$z_f2))
  )
)
write_csv(feature_summary, "representation-feature-summary.csv")

raw_plot <- ggplot(vowels, aes(x = f2, y = f1)) +
  geom_point(color = "grey25", alpha = 0.28, size = 0.7) +
  facet_wrap(~speaker_type, nrow = 1) +
  scale_x_reverse() +
  scale_y_reverse() +
  labs(x = "F2 (Hz)", y = "F1 (Hz)") +
  course_theme()
save_plot(raw_plot, "01-representing-objects.png", width = 8.2, height = 3.3)

normalized_plot <- ggplot(vowels, aes(x = z_f2, y = z_f1)) +
  geom_point(color = "grey25", alpha = 0.28, size = 0.7) +
  facet_wrap(~speaker_type, nrow = 1) +
  scale_x_reverse() +
  scale_y_reverse() +
  labs(
    x = "Within-speaker standardized F2",
    y = "Within-speaker standardized F1"
  ) +
  course_theme()
save_plot(normalized_plot, "02-distance-and-scaling.png", width = 8.2, height = 3.3)

# -----------------------------------------------------------------------------
# Distance, scaling, K-means, loss, and silhouettes
# -----------------------------------------------------------------------------

representations <- list(
  raw_hz = as.matrix(vowels[, c("f1", "f2")]),
  global_z = as.matrix(vowels[, c("global_z_f1", "global_z_f2")]),
  within_speaker_z = as.matrix(vowels[, c("z_f1", "z_f2")])
)

distance_summaries <- list()
nearest_neighbors <- list()
for (representation_name in names(representations)) {
  representation <- representations[[representation_name]]
  squared <- pairwise_squared_distance(representation, representation)
  diag(squared) <- Inf
  nearest <- max.col(-squared, ties.method = "first")
  difference <- representation - representation[nearest, , drop = FALSE]
  contribution_total <- rowSums(difference^2)
  second_dimension_share <- ifelse(
    contribution_total == 0, NA_real_, difference[, 2]^2 / contribution_total
  )
  distance_summaries[[representation_name]] <- data.frame(
    representation = representation_name,
    nearest_neighbor_same_vowel = mean(vowels$vowel == vowels$vowel[nearest]),
    nearest_neighbor_same_speaker_type = mean(vowels$type == vowels$type[nearest]),
    median_nearest_neighbor_distance = median(sqrt(squared[cbind(
      seq_len(nrow(vowels)), nearest
    )])),
    mean_second_dimension_squared_share = mean(second_dimension_share, na.rm = TRUE)
  )
  nearest_neighbors[[representation_name]] <- nearest
}
write_csv(bind_rows(distance_summaries), "distance-scaling-summary.csv")

x_normalized <- representations$within_speaker_z
reference_row <- which.min(rowSums(sweep(
  x_normalized, 2, colMeans(x_normalized), "-"
)^2))
distance_reference <- bind_rows(lapply(names(representations), function(name) {
  neighbor <- nearest_neighbors[[name]][reference_row]
  data.frame(
    representation = name,
    reference_row = reference_row,
    reference_token = vowels$token_id[reference_row],
    reference_vowel = as.character(vowels$vowel[reference_row]),
    neighbor_row = neighbor,
    neighbor_token = vowels$token_id[neighbor],
    neighbor_vowel = as.character(vowels$vowel[neighbor]),
    distance = sqrt(sum(
      (representations[[name]][reference_row, ] - representations[[name]][neighbor, ])^2
    ))
  )
}))
write_csv(distance_reference, "distance-reference-token.csv")

set.seed(seed)
kmeans_10 <- stats::kmeans(
  x_normalized, centers = 10L, nstart = 100L, iter.max = 200L,
  algorithm = "Hartigan-Wong"
)
kmeans_assignments <- vowels |>
  select(
    row_id, token_id, speaker, speaker_type, vowel, repetition,
    f1, f2, z_f1, z_f2
  ) |>
  mutate(cluster = factor(kmeans_10$cluster))
write_csv(kmeans_assignments, "kmeans-10-assignments.csv")

kmeans_centroids <- data.frame(
  cluster = factor(seq_len(nrow(kmeans_10$centers))),
  z_f1 = kmeans_10$centers[, 1],
  z_f2 = kmeans_10$centers[, 2],
  assigned_tokens = as.integer(table(factor(
    kmeans_10$cluster, levels = seq_len(nrow(kmeans_10$centers))
  )))
)
write_csv(kmeans_centroids, "kmeans-10-centroids.csv")

reference_centroid_distances <- data.frame(
  row_id = reference_row,
  token_id = vowels$token_id[reference_row],
  intended_vowel = as.character(vowels$vowel[reference_row]),
  cluster = seq_len(nrow(kmeans_10$centers)),
  squared_distance = as.numeric(pairwise_squared_distance(
    x_normalized[reference_row, , drop = FALSE], kmeans_10$centers
  ))
) |>
  arrange(squared_distance) |>
  mutate(distance_rank = row_number())
write_csv(reference_centroid_distances, "kmeans-reference-assignment.csv")

cluster_means_check <- vowels |>
  mutate(cluster = kmeans_10$cluster) |>
  group_by(cluster) |>
  summarise(
    assigned_tokens = n(),
    update_z_f1 = mean(z_f1),
    update_z_f2 = mean(z_f2),
    .groups = "drop"
  ) |>
  mutate(
    fitted_z_f1 = kmeans_10$centers[cluster, 1],
    fitted_z_f2 = kmeans_10$centers[cluster, 2],
    maximum_absolute_difference = pmax(
      abs(update_z_f1 - fitted_z_f1),
      abs(update_z_f2 - fitted_z_f2)
    )
  )
stopifnot(max(cluster_means_check$maximum_absolute_difference) < 1e-12)
write_csv(cluster_means_check, "kmeans-centroid-update-check.csv")

kmeans_summary <- data.frame(
  quantity = c(
    "components", "iterations", "total within-cluster sum of squares",
    "adjusted Rand index against withheld intended-vowel metadata"
  ),
  value = c(
    10, kmeans_10$iter, kmeans_10$tot.withinss,
    mclust::adjustedRandIndex(kmeans_10$cluster, vowels$vowel)
  )
)
write_csv(kmeans_summary, "kmeans-10-summary.csv")

kmeans_plot_data <- kmeans_assignments
kmeans_plot <- ggplot(kmeans_plot_data, aes(
  x = z_f2, y = z_f1, color = cluster
)) +
  geom_point(alpha = 0.48, size = 0.65) +
  geom_point(
    data = kmeans_centroids,
    aes(x = z_f2, y = z_f1),
    inherit.aes = FALSE, color = "black", shape = 4, stroke = 1,
    size = 2.3
  ) +
  scale_x_reverse() +
  scale_y_reverse() +
  scale_color_viridis_d(option = "D", end = 0.9) +
  labs(
    x = "Within-speaker standardized F2",
    y = "Within-speaker standardized F1"
  ) +
  course_theme() +
  theme(legend.position = "none")
save_plot(kmeans_plot, "03-kmeans-fit.png")

normalized_distance <- stats::dist(x_normalized)
k_grid <- 1:15
kmeans_fits <- vector("list", length(k_grid))
within_cluster_loss <- vector("list", length(k_grid))
for (k in k_grid) {
  set.seed(seed + k)
  fit <- stats::kmeans(
    x_normalized, centers = k, nstart = 100L, iter.max = 200L,
    algorithm = "Hartigan-Wong"
  )
  kmeans_fits[[k]] <- fit
  within_cluster_loss[[k]] <- data.frame(
    k = k,
    total_within_cluster_loss = fit$tot.withinss,
    iterations = fit$iter
  )
}
within_cluster_loss <- bind_rows(within_cluster_loss) |>
  mutate(
    absolute_drop = lag(total_within_cluster_loss) - total_within_cluster_loss,
    proportional_drop = absolute_drop / lag(total_within_cluster_loss)
  )
stopifnot(all(diff(within_cluster_loss$total_within_cluster_loss) <= 1e-8))
write_csv(within_cluster_loss, "within-cluster-loss.csv")

loss_plot <- ggplot(within_cluster_loss, aes(
  x = k, y = total_within_cluster_loss
)) +
  geom_line(color = "#2B6CB0", linewidth = 0.7) +
  geom_point(color = "#2B6CB0", size = 1.7) +
  scale_x_continuous(breaks = seq(1, 15, by = 2)) +
  labs(x = "Number of centroids", y = "Within-cluster sum of squares") +
  course_theme()
save_plot(loss_plot, "04-within-cluster-loss.png")

silhouette_summary <- list()
silhouette_token <- list()
for (k in 2:15) {
  silhouette_fit <- cluster::silhouette(
    kmeans_fits[[k]]$cluster, normalized_distance
  )
  silhouette_summary[[as.character(k)]] <- data.frame(
    k = k,
    mean_silhouette = mean(silhouette_fit[, "sil_width"]),
    median_silhouette = median(silhouette_fit[, "sil_width"]),
    negative_fraction = mean(silhouette_fit[, "sil_width"] < 0),
    adjusted_rand_index = mclust::adjustedRandIndex(
      kmeans_fits[[k]]$cluster, vowels$vowel
    )
  )
  if (k %in% c(4L, 10L)) {
    silhouette_token[[as.character(k)]] <- data.frame(
      row_id = vowels$row_id,
      token_id = vowels$token_id,
      intended_vowel = as.character(vowels$vowel),
      k = k,
      assigned_cluster = silhouette_fit[, "cluster"],
      neighbor_cluster = silhouette_fit[, "neighbor"],
      silhouette_width = silhouette_fit[, "sil_width"]
    )
  }
}
silhouette_summary <- bind_rows(silhouette_summary)
silhouette_token <- bind_rows(silhouette_token)
write_csv(silhouette_summary, "silhouette-summary.csv")
write_csv(silhouette_token, "silhouette-token-values-k4-k10.csv")

silhouette_10 <- cluster::silhouette(
  kmeans_fits[[10]]$cluster, normalized_distance
)
boundary_row <- which.min(silhouette_10[, "sil_width"])
distance_matrix <- as.matrix(normalized_distance)
assigned_cluster <- kmeans_fits[[10]]$cluster[boundary_row]
other_clusters <- setdiff(sort(unique(kmeans_fits[[10]]$cluster)), assigned_cluster)
within_rows <- which(
  kmeans_fits[[10]]$cluster == assigned_cluster &
    seq_len(nrow(vowels)) != boundary_row
)
a_i <- mean(distance_matrix[boundary_row, within_rows])
between_means <- vapply(other_clusters, function(cluster) {
  mean(distance_matrix[
    boundary_row, kmeans_fits[[10]]$cluster == cluster
  ])
}, numeric(1))
b_i <- min(between_means)
neighbor_cluster <- other_clusters[which.min(between_means)]
s_i <- (b_i - a_i) / max(a_i, b_i)
stopifnot(abs(s_i - silhouette_10[boundary_row, "sil_width"]) < 1e-10)
write_csv(data.frame(
  row_id = boundary_row,
  token_id = vowels$token_id[boundary_row],
  intended_vowel = as.character(vowels$vowel[boundary_row]),
  assigned_cluster = assigned_cluster,
  neighbor_cluster = neighbor_cluster,
  within_cluster_mean_distance_a = a_i,
  nearest_other_cluster_mean_distance_b = b_i,
  silhouette = s_i
), "silhouette-reference-token.csv")

silhouette_plot <- ggplot(silhouette_summary, aes(x = k, y = mean_silhouette)) +
  geom_line(color = "#2B6CB0", linewidth = 0.7) +
  geom_point(color = "#2B6CB0", size = 1.7) +
  scale_x_continuous(breaks = c(seq(2, 14, by = 2), 15)) +
  labs(x = "Number of centroids", y = "Mean silhouette width") +
  course_theme()
save_plot(silhouette_plot, "05-silhouette-scores.png")

# -----------------------------------------------------------------------------
# Speaker-blocked K-means validation
# -----------------------------------------------------------------------------

set.seed(seed)
speaker_folds <- vowels |>
  distinct(speaker, type, sex, speaker_type) |>
  arrange(type, speaker) |>
  group_by(type) |>
  mutate(fold = sample(rep(1:5, length.out = n()))) |>
  ungroup()
stopifnot(
  n_distinct(speaker_folds$speaker) == 76L,
  all(table(speaker_folds$type, speaker_folds$fold) > 0)
)
write_csv(speaker_folds, "speaker-folds.csv")

vowels_with_folds <- vowels |>
  left_join(speaker_folds |> select(speaker, fold), by = "speaker")

kmeans_cv_token <- list()
for (fold in 1:5) {
  train <- vowels_with_folds$fold != fold
  test <- !train
  train_x <- x_normalized[train, , drop = FALSE]
  test_x <- x_normalized[test, , drop = FALSE]
  for (k in 2:15) {
    set.seed(seed + 100L * fold + k)
    fit <- stats::kmeans(
      train_x, centers = k, nstart = 100L, iter.max = 200L,
      algorithm = "Hartigan-Wong"
    )
    predicted <- nearest_centroid(test_x, fit$centers)
    kmeans_cv_token[[length(kmeans_cv_token) + 1L]] <- data.frame(
      row_id = vowels_with_folds$row_id[test],
      token_id = vowels_with_folds$token_id[test],
      speaker = vowels_with_folds$speaker[test],
      intended_vowel = as.character(vowels_with_folds$vowel[test]),
      fold = fold,
      k = k,
      assigned_cluster = predicted$assignment,
      squared_reconstruction_loss = predicted$squared_distance
    )
  }
}
kmeans_cv_token <- bind_rows(kmeans_cv_token)
kmeans_cv_speaker <- kmeans_cv_token |>
  group_by(speaker, fold, k) |>
  summarise(
    mean_squared_reconstruction_loss = mean(squared_reconstruction_loss),
    .groups = "drop"
  )
kmeans_cv_summary <- kmeans_cv_speaker |>
  group_by(k) |>
  summarise(
    speakers = n(),
    mean_speaker_loss = mean(mean_squared_reconstruction_loss),
    standard_error_across_speakers =
      sd(mean_squared_reconstruction_loss) / sqrt(n()),
    .groups = "drop"
  )
kmeans_cv_external <- kmeans_cv_token |>
  group_by(fold, k) |>
  summarise(
    adjusted_rand_index = mclust::adjustedRandIndex(
      assigned_cluster, intended_vowel
    ),
    .groups = "drop"
  )
write_csv(kmeans_cv_token, "kmeans-speaker-cv-token-loss.csv")
write_csv(kmeans_cv_speaker, "kmeans-speaker-cv-speaker-loss.csv")
write_csv(kmeans_cv_summary, "kmeans-speaker-cv-summary.csv")
write_csv(kmeans_cv_external, "kmeans-speaker-cv-external-ari.csv")

kmeans_cv_plot <- ggplot(kmeans_cv_summary, aes(
  x = k, y = mean_speaker_loss
)) +
  geom_errorbar(aes(
    ymin = mean_speaker_loss - standard_error_across_speakers,
    ymax = mean_speaker_loss + standard_error_across_speakers
  ), width = 0, color = "grey45", linewidth = 0.45) +
  geom_line(color = "#2B6CB0", linewidth = 0.7) +
  geom_point(color = "#2B6CB0", size = 1.7) +
  scale_x_continuous(breaks = c(seq(2, 14, by = 2), 15)) +
  labs(
    x = "Number of training centroids",
    y = "Held-out mean squared distance"
  ) +
  course_theme()
save_plot(kmeans_cv_plot, "06-unsupervised-validation.png")

# -----------------------------------------------------------------------------
# Gaussian mixtures, posterior membership, EM, and BIC
# -----------------------------------------------------------------------------

candidate_models <- c("EEI", "EVI", "VEV", "VVI")
set.seed(seed)
raw_selected <- mclust::Mclust(
  representations$raw_hz, G = 1:16, verbose = FALSE
)
set.seed(seed)
raw_10 <- mclust::Mclust(
  representations$raw_hz, G = 10L, verbose = FALSE
)
set.seed(seed)
normalized_selected <- mclust::Mclust(
  x_normalized, G = 1:16, modelNames = candidate_models,
  verbose = FALSE
)
set.seed(seed)
normalized_10 <- mclust::Mclust(
  x_normalized, G = 10L, modelNames = "EVI", verbose = FALSE
)

gmm_summary <- bind_rows(
  data.frame(
    fit = "raw_selected_all_covariance_families",
    components = raw_selected$G,
    covariance_model = raw_selected$modelName,
    log_likelihood = raw_selected$loglik,
    parameters = raw_selected$df,
    mclust_bic_larger_is_better = raw_selected$bic,
    conventional_bic_smaller_is_better = -raw_selected$bic,
    adjusted_rand_index = mclust::adjustedRandIndex(
      raw_selected$classification, vowels$vowel
    ),
    mean_uncertainty = mean(raw_selected$uncertainty)
  ),
  data.frame(
    fit = "raw_forced_10_all_covariance_families",
    components = raw_10$G,
    covariance_model = raw_10$modelName,
    log_likelihood = raw_10$loglik,
    parameters = raw_10$df,
    mclust_bic_larger_is_better = raw_10$bic,
    conventional_bic_smaller_is_better = -raw_10$bic,
    adjusted_rand_index = mclust::adjustedRandIndex(
      raw_10$classification, vowels$vowel
    ),
    mean_uncertainty = mean(raw_10$uncertainty)
  ),
  data.frame(
    fit = "speaker_normalized_selected_declared_candidate_set",
    components = normalized_selected$G,
    covariance_model = normalized_selected$modelName,
    log_likelihood = normalized_selected$loglik,
    parameters = normalized_selected$df,
    mclust_bic_larger_is_better = normalized_selected$bic,
    conventional_bic_smaller_is_better = -normalized_selected$bic,
    adjusted_rand_index = mclust::adjustedRandIndex(
      normalized_selected$classification, vowels$vowel
    ),
    mean_uncertainty = mean(normalized_selected$uncertainty)
  ),
  data.frame(
    fit = "speaker_normalized_forced_10_EVI",
    components = normalized_10$G,
    covariance_model = normalized_10$modelName,
    log_likelihood = normalized_10$loglik,
    parameters = normalized_10$df,
    mclust_bic_larger_is_better = normalized_10$bic,
    conventional_bic_smaller_is_better = -normalized_10$bic,
    adjusted_rand_index = mclust::adjustedRandIndex(
      normalized_10$classification, vowels$vowel
    ),
    mean_uncertainty = mean(normalized_10$uncertainty)
  )
)
stopifnot(
  raw_selected$G == 9L,
  raw_selected$modelName == "VEV",
  normalized_selected$G == 14L,
  normalized_selected$modelName == "EEI",
  normalized_10$modelName == "EVI",
  abs(
    normalized_10$bic -
      (2 * normalized_10$loglik - normalized_10$df * log(nrow(vowels)))
  ) < 1e-7
)
write_csv(gmm_summary, "gaussian-mixture-summary.csv")

component_covariance <- normalized_10$parameters$variance$sigma
component_parameters <- bind_rows(lapply(seq_len(normalized_10$G), function(component) {
  covariance <- component_covariance[, , component]
  data.frame(
    component = component,
    weight = normalized_10$parameters$pro[component],
    mean_z_f1 = normalized_10$parameters$mean[1, component],
    mean_z_f2 = normalized_10$parameters$mean[2, component],
    variance_z_f1 = covariance[1, 1],
    covariance_z_f1_z_f2 = covariance[1, 2],
    variance_z_f2 = covariance[2, 2]
  )
}))
write_csv(component_parameters, "gaussian-mixture-10-EVI-parameters.csv")

ellipses <- bind_rows(lapply(seq_len(normalized_10$G), function(component) {
  ellipse_points(
    normalized_10$parameters$mean[, component],
    component_covariance[, , component], component, level = 0.90
  )
}))
write_csv(ellipses, "gaussian-mixture-10-EVI-ellipses.csv")

gmm_points <- vowels |>
  transmute(
    row_id, z_f1, z_f2,
    component = factor(normalized_10$classification),
    uncertainty = normalized_10$uncertainty
  )
gmm_plot <- ggplot(gmm_points, aes(x = z_f2, y = z_f1)) +
  geom_point(color = "grey35", alpha = 0.24, size = 0.6) +
  geom_path(
    data = ellipses,
    aes(x = z_f2, y = z_f1, group = component),
    inherit.aes = FALSE, color = "#2B6CB0", linewidth = 0.65
  ) +
  geom_point(
    data = component_parameters,
    aes(x = mean_z_f2, y = mean_z_f1),
    inherit.aes = FALSE, color = "black", shape = 4, size = 2.1,
    stroke = 0.9
  ) +
  scale_x_reverse() +
  scale_y_reverse() +
  labs(
    x = "Within-speaker standardized F2",
    y = "Within-speaker standardized F1"
  ) +
  course_theme()
save_plot(gmm_plot, "07-gaussian-mixtures.png")

conditional_density <- mclust::cdens(
  x_normalized, modelName = normalized_10$modelName,
  parameters = normalized_10$parameters
)
weighted_density <- sweep(
  conditional_density, 2, normalized_10$parameters$pro, "*"
)
mixture_density <- rowSums(weighted_density)
responsibilities <- sweep(weighted_density, 1, mixture_density, "/")
estep_check <- mclust::estep(
  x_normalized, modelName = normalized_10$modelName,
  parameters = normalized_10$parameters
)
stopifnot(
  max(abs(rowSums(responsibilities) - 1)) < 1e-10,
  max(abs(responsibilities - estep_check$z)) < 1e-10
)
derived_uncertainty <- 1 - apply(responsibilities, 1, max)
membership_row <- which.max(derived_uncertainty)
membership_contributions <- data.frame(
  row_id = membership_row,
  token_id = vowels$token_id[membership_row],
  intended_vowel = as.character(vowels$vowel[membership_row]),
  z_f1 = vowels$z_f1[membership_row],
  z_f2 = vowels$z_f2[membership_row],
  component = seq_len(normalized_10$G),
  mixing_weight = normalized_10$parameters$pro,
  conditional_density = conditional_density[membership_row, ],
  weighted_contribution = weighted_density[membership_row, ],
  mixture_density = mixture_density[membership_row],
  posterior_membership = responsibilities[membership_row, ]
) |>
  arrange(desc(posterior_membership)) |>
  mutate(posterior_rank = row_number())
write_csv(membership_contributions, "posterior-membership-reference-token.csv")

responsibility_by_vowel <- vowels |>
  mutate(
    maximum_posterior_membership = apply(responsibilities, 1, max),
    uncertainty = 1 - maximum_posterior_membership
  ) |>
  group_by(vowel) |>
  summarise(
    tokens = n(),
    mean_uncertainty = mean(uncertainty),
    median_uncertainty = median(uncertainty),
    fraction_uncertainty_above_point_2 = mean(uncertainty > 0.2),
    .groups = "drop"
  )
write_csv(responsibility_by_vowel, "posterior-membership-by-vowel.csv")

responsibility_plot_data <- vowels |>
  mutate(uncertainty = derived_uncertainty)
responsibility_plot <- ggplot(
  responsibility_plot_data,
  aes(x = reorder(vowel, uncertainty, median), y = uncertainty)
) +
  geom_boxplot(
    width = 0.62, outlier.shape = NA, fill = "grey88", color = "grey25",
    linewidth = 0.45
  ) +
  geom_jitter(width = 0.12, height = 0, alpha = 0.18, size = 0.45) +
  labs(x = "Intended vowel (withheld during fitting)", y = "Membership uncertainty") +
  course_theme()
save_plot(responsibility_plot, "08-posterior-membership.png")

em_seeds <- seed + 0:5
em_fits <- lapply(em_seeds, function(current_seed) {
  diagonal_em(x_normalized, components = 10L, seed = current_seed)
})
em_start_summary <- bind_rows(lapply(em_fits, function(fit) {
  data.frame(
    seed = fit$seed,
    iterations = fit$iterations,
    final_log_likelihood = fit$log_likelihood,
    minimum_iteration_gain = min(diff(fit$trace)),
    variance_floor = fit$variance_floor,
    tolerance = fit$tolerance
  )
}))
stopifnot(all(em_start_summary$minimum_iteration_gain >= -1e-8))
best_em_index <- which.max(em_start_summary$final_log_likelihood)
best_em <- em_fits[[best_em_index]]
em_trace <- data.frame(
  seed = best_em$seed,
  iteration = seq_along(best_em$trace),
  observed_data_log_likelihood = best_em$trace,
  gain = c(NA_real_, diff(best_em$trace))
)
write_csv(em_start_summary, "expectation-maximization-starts.csv")
write_csv(em_trace, "expectation-maximization-trace.csv")

em_component_update <- data.frame(
  component = seq_len(10L),
  effective_token_count = colSums(best_em$responsibilities),
  fitted_weight = best_em$proportions,
  weighted_mean_z_f1 = best_em$means[, 1],
  weighted_mean_z_f2 = best_em$means[, 2],
  fitted_variance_z_f1 = best_em$variances[, 1],
  fitted_variance_z_f2 = best_em$variances[, 2]
)
write_csv(em_component_update, "expectation-maximization-component-update.csv")

em_plot <- ggplot(em_trace, aes(
  x = iteration, y = observed_data_log_likelihood
)) +
  geom_line(color = "#2B6CB0", linewidth = 0.7) +
  labs(x = "EM iteration", y = "Observed-data log likelihood") +
  course_theme()
save_plot(em_plot, "09-expectation-maximization.png")

set.seed(seed)
bic_object <- mclust::mclustBIC(
  x_normalized, G = 2:16, modelNames = candidate_models,
  verbose = FALSE
)
bic_matrix <- as.matrix(bic_object)
bic_grid <- as.data.frame(as.table(bic_matrix)) |>
  transmute(
    components = as.integer(as.character(Var1)),
    covariance_model = as.character(Var2),
    mclust_bic_larger_is_better = as.numeric(Freq),
    conventional_bic_smaller_is_better = -mclust_bic_larger_is_better
  ) |>
  filter(is.finite(mclust_bic_larger_is_better))
write_csv(bic_grid, "mixture-bic-grid.csv")

bic_best <- bic_grid |>
  slice_min(conventional_bic_smaller_is_better, n = 1, with_ties = FALSE)
stopifnot(
  bic_best$components == normalized_selected$G,
  bic_best$covariance_model == normalized_selected$modelName
)

bic_plot <- ggplot(bic_grid, aes(
  x = components, y = conventional_bic_smaller_is_better,
  group = covariance_model, color = covariance_model
)) +
  geom_line(linewidth = 0.65) +
  geom_point(size = 1.25) +
  scale_x_continuous(breaks = seq(2, 16, by = 2)) +
  scale_color_viridis_d(option = "D", end = 0.82) +
  labs(x = "Number of mixture components", y = "BIC (smaller is better)") +
  course_theme()
save_plot(bic_plot, "10-choosing-a-mixture.png")

# -----------------------------------------------------------------------------
# Speaker-blocked Gaussian-mixture validation
# -----------------------------------------------------------------------------

mixture_candidates <- data.frame(
  candidate = c("10-component EVI", "14-component EEI"),
  components = c(10L, 14L),
  covariance_model = c("EVI", "EEI")
)
mixture_cv_token <- list()
for (fold in 1:5) {
  train <- vowels_with_folds$fold != fold
  test <- !train
  train_x <- x_normalized[train, , drop = FALSE]
  test_x <- x_normalized[test, , drop = FALSE]
  for (candidate_row in seq_len(nrow(mixture_candidates))) {
    candidate <- mixture_candidates[candidate_row, ]
    set.seed(seed + 1000L * fold + candidate$components)
    fit <- mclust::Mclust(
      train_x, G = candidate$components,
      modelNames = candidate$covariance_model, verbose = FALSE
    )
    log_density <- mclust::dens(
      test_x, modelName = fit$modelName,
      parameters = fit$parameters, logarithm = TRUE
    )
    prediction <- stats::predict(fit, newdata = test_x)
    mixture_cv_token[[length(mixture_cv_token) + 1L]] <- data.frame(
      row_id = vowels_with_folds$row_id[test],
      token_id = vowels_with_folds$token_id[test],
      speaker = vowels_with_folds$speaker[test],
      intended_vowel = as.character(vowels_with_folds$vowel[test]),
      fold = fold,
      candidate = candidate$candidate,
      predicted_component = prediction$classification,
      negative_log_predictive_density = -log_density
    )
  }
}
mixture_cv_token <- bind_rows(mixture_cv_token)
mixture_cv_speaker <- mixture_cv_token |>
  group_by(speaker, fold, candidate) |>
  summarise(
    mean_negative_log_predictive_density =
      mean(negative_log_predictive_density),
    .groups = "drop"
  )
mixture_cv_summary <- mixture_cv_speaker |>
  group_by(candidate) |>
  summarise(
    speakers = n(),
    mean_speaker_log_loss = mean(mean_negative_log_predictive_density),
    standard_error_across_speakers =
      sd(mean_negative_log_predictive_density) / sqrt(n()),
    .groups = "drop"
  )
mixture_cv_external <- mixture_cv_token |>
  group_by(fold, candidate) |>
  summarise(
    adjusted_rand_index = mclust::adjustedRandIndex(
      predicted_component, intended_vowel
    ),
    .groups = "drop"
  )
mixture_cv_difference <- mixture_cv_speaker |>
  pivot_wider(
    names_from = candidate,
    values_from = mean_negative_log_predictive_density
  ) |>
  mutate(
    loss_difference_14_EEI_minus_10_EVI =
      `14-component EEI` - `10-component EVI`
  )
write_csv(mixture_cv_token, "mixture-speaker-cv-token-loss.csv")
write_csv(mixture_cv_speaker, "mixture-speaker-cv-speaker-loss.csv")
write_csv(mixture_cv_summary, "mixture-speaker-cv-summary.csv")
write_csv(mixture_cv_external, "mixture-speaker-cv-external-ari.csv")
write_csv(mixture_cv_difference, "mixture-speaker-cv-paired-differences.csv")

mixture_cv_plot <- ggplot(mixture_cv_difference, aes(
  x = loss_difference_14_EEI_minus_10_EVI, y = 0
)) +
  geom_vline(xintercept = 0, color = "grey55", linewidth = 0.55) +
  geom_point(
    position = position_jitter(width = 0, height = 0.075, seed = seed),
    color = "#2B6CB0", alpha = 0.7, size = 1.4
  ) +
  scale_y_continuous(NULL, breaks = NULL) +
  labs(
    x = "Speaker log-loss difference: 14-component EEI minus 10-component EVI"
  ) +
  course_theme()
save_plot(mixture_cv_plot, "11-validating-a-mixture.png", width = 7, height = 3.2)

# -----------------------------------------------------------------------------
# Page registry, assertions, and run metadata
# -----------------------------------------------------------------------------

page_registry <- data.frame(
  sidebar_order = 1:11,
  page = c(
    "representing-objects.qmd", "distance-and-scaling.qmd", "k-means.qmd",
    "within-cluster-loss.qmd", "silhouette-scores.qmd",
    "unsupervised-validation.qmd", "gaussian-mixtures.qmd",
    "posterior-membership.qmd", "expectation-maximization.qmd",
    "choosing-a-mixture.qmd", "validating-a-mixture.qmd"
  ),
  primary_empirical_object = c(
    "1,520 raw F1-F2 token vectors with speaker identifiers retained",
    "raw-Hz, global-z, and within-speaker-z distances",
    "10-centroid fit in within-speaker-z F1-F2 space",
    "training within-cluster loss for K=1,...,15",
    "token silhouettes and mean silhouettes for K=2,...,15",
    "five-fold speaker-blocked nearest-centroid loss",
    "10-component EVI Gaussian mixture and 90% component ellipses",
    "full posterior-membership vectors and token uncertainty",
    "10-component diagonal EM trace across six starts",
    "BIC grid for four declared covariance families and G=2,...,16",
    "five-fold speaker-blocked predictive density for two fixed mixtures"
  ),
  figure = sprintf("%02d-%s.png", 1:11, c(
    "representing-objects", "distance-and-scaling", "kmeans-fit",
    "within-cluster-loss", "silhouette-scores", "unsupervised-validation",
    "gaussian-mixtures", "posterior-membership",
    "expectation-maximization", "choosing-a-mixture",
    "validating-a-mixture"
  ))
)
write_csv(page_registry, "page-registry.csv")

assertions <- data.frame(
  assertion = c(
    "phonTools version is pinned",
    "pb52 source-file checksum matches",
    "pb52 object checksum matches",
    "schema and repeated-speaker design match documentation",
    "within-speaker z scores have speaker mean zero and sample SD one",
    "intended-vowel labels were omitted from all fitted feature matrices",
    "K-means training loss is non-increasing over the fitted K grid",
    "manual silhouette calculation matches cluster::silhouette",
    "posterior membership rows sum to one",
    "EM observed-data log likelihood is non-decreasing within tolerance",
    "mclust BIC equals 2 log L minus parameter count times log n",
    "all validation splits hold out complete speakers"
  ),
  passed = TRUE
)
write_csv(assertions, "assertions.csv")

analysis_summary <- list(
  source = list(
    study = "Peterson and Barney (1952)",
    doi = "https://doi.org/10.1121/1.1906875",
    distribution = "phonTools::pb52",
    package_version = installed_versions[["phonTools"]],
    source_file_sha256 = pb52_checksums$checksum[1],
    object_sha256 = pb52_checksums$checksum[2]
  ),
  represented_unit = "one recorded hVd vowel token",
  sampling_group = "speaker",
  fitting_features = c("within-speaker standardized F1", "within-speaker standardized F2"),
  labels_used_in_fit = FALSE,
  intended_vowel_role = "post-fit external metadata only",
  validation_target = paste(
    "an unseen speaker's complete 20-token calibration panel; the panel's",
    "unlabeled F1 and F2 values determine that speaker's normalization, while",
    "no held-out token enters centroid or mixture estimation"
  ),
  seed = seed,
  kmeans = list(
    components = 10,
    nstart = 100,
    algorithm = "Hartigan-Wong",
    adjusted_rand_index = mclust::adjustedRandIndex(
      kmeans_10$cluster, vowels$vowel
    )
  ),
  gaussian_mixture = list(
    descriptive_model = "10-component EVI",
    selected_candidate_components = normalized_selected$G,
    selected_candidate_covariance = normalized_selected$modelName,
    forced_10_adjusted_rand_index = mclust::adjustedRandIndex(
      normalized_10$classification, vowels$vowel
    ),
    forced_10_mean_uncertainty = mean(normalized_10$uncertainty)
  ),
  runtime_seconds = as.numeric(difftime(Sys.time(), start_time, units = "secs"))
)
jsonlite::write_json(
  analysis_summary,
  file.path(output_dir, "analysis-summary.json"),
  pretty = TRUE, auto_unbox = TRUE, digits = 10
)

session_lines <- capture.output(utils::sessionInfo())
writeLines(session_lines, file.path(output_dir, "session-info.txt"))
writeLines(
  c(
    paste("Start:", format(start_time, tz = "UTC", usetz = TRUE)),
    paste("End:", format(Sys.time(), tz = "UTC", usetz = TRUE)),
    paste("Runtime seconds:", round(
      as.numeric(difftime(Sys.time(), start_time, units = "secs")), 3
    ))
  ),
  file.path(output_dir, "runtime.txt")
)

cat(
  "Completed latent-structure reference analysis in ",
  round(as.numeric(difftime(Sys.time(), start_time, units = "secs")), 2),
  " seconds.\nOutputs: ", output_dir, "\n", sep = ""
)
