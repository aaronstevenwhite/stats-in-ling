"""Rebuild the PS5 answer key from the current student notebook.

The student notebook is the source of truth for prose and exercise order. This
script adds worked solutions without restoring the invalid tests over fold
averages that appeared in the older answer key.
"""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
STUDENT = ROOT / "problem-sets" / "ps5" / "ps5.ipynb"
ANSWER = ROOT / "problem-sets" / "ps5" / "ps5_answer_key.ipynb"


def lines(text: str) -> list[str]:
    """Return notebook source lines while preserving line endings."""
    return text.splitlines(keepends=True)


def set_code(notebook: dict, index: int, source: str) -> None:
    cell = notebook["cells"][index]
    cell["source"] = lines(source.rstrip() + "\n")
    cell["execution_count"] = None
    cell["outputs"] = []


with STUDENT.open(encoding="utf-8") as stream:
    notebook = json.load(stream)

title = "".join(notebook["cells"][0]["source"])
title = title.replace("Problem Set 5", "Problem Set 5 Answer Key", 1)
notebook["cells"][0]["source"] = lines(title)

set_code(
    notebook,
    3,
    r'''required <- c("tidyverse", "reshape2", "cluster", "mclust", "missMDA")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing) > 0) {
  install.packages(missing)
}

library(tidyverse)
library(reshape2)
library(cluster)
library(mclust)
library(missMDA)''',
)

set_code(
    notebook,
    9,
    r'''data <- read.csv("data/malayalam_complete_cases.csv")

cat("Participants:", nrow(data), "\n")
cat("Measures:", ncol(data), "\n")
cat("Missing cells:", sum(is.na(data)), "\n\n")
print(summary(data))''',
)

set_code(
    notebook,
    11,
    r'''cor_matrix <- cor(data)
cor_long <- reshape2::melt(cor_matrix)

ggplot(cor_long, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(
    low = "#d73027", mid = "white", high = "#0066cc",
    midpoint = 0, limits = c(-1, 1)
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = NULL, y = NULL, fill = "Correlation")''',
)

set_code(
    notebook,
    13,
    r'''pca_result <- prcomp(data, scale. = TRUE)
variance_share <- pca_result$sdev^2 / sum(pca_result$sdev^2)
pca_df <- data.frame(PC1 = pca_result$x[, 1], PC2 = pca_result$x[, 2])

cat(
  "Variance represented by PC1 and PC2:",
  round(sum(variance_share[1:2]) * 100, 1), "%\n"
)

ggplot(pca_df, aes(PC1, PC2)) +
  geom_point(alpha = 0.65, size = 2.5, color = "#0066cc") +
  theme_minimal() +
  labs(
    x = paste0("PC1, ", round(variance_share[1] * 100, 1), "%"),
    y = paste0("PC2, ", round(variance_share[2] * 100, 1), "%")
  )''',
)

set_code(
    notebook,
    15,
    r'''data_scaled <- scale(data)
k_range_explore <- 2:15

set.seed(42)
kmeans_results <- lapply(k_range_explore, function(k) {
  kmeans(data_scaled, centers = k, nstart = 25, iter.max = 100)
})
names(kmeans_results) <- paste0("k", k_range_explore)

wss <- vapply(kmeans_results, function(fit) fit$tot.withinss, numeric(1))
data.frame(k = k_range_explore, WSS = wss)''',
)

set_code(
    notebook,
    16,
    r'''elbow_df <- data.frame(k = k_range_explore, WSS = wss)

ggplot(elbow_df, aes(k, WSS)) +
  geom_line(color = "#0066cc", linewidth = 1) +
  geom_point(color = "#0066cc", size = 2.5) +
  scale_x_continuous(breaks = k_range_explore) +
  theme_minimal() +
  labs(
    x = "Number of clusters",
    y = "Within cluster sum of squares"
  )''',
)

set_code(
    notebook,
    19,
    r'''distance_matrix <- dist(data_scaled)
silhouette_scores <- vapply(kmeans_results, function(fit) {
  mean(cluster::silhouette(fit$cluster, distance_matrix)[, "sil_width"])
}, numeric(1))

silhouette_df <- data.frame(
  k = k_range_explore,
  average_silhouette = silhouette_scores
)

ggplot(silhouette_df, aes(k, average_silhouette)) +
  geom_line(color = "#0066cc", linewidth = 1) +
  geom_point(color = "#0066cc", size = 2.5) +
  scale_x_continuous(breaks = k_range_explore) +
  theme_minimal() +
  labs(x = "Number of clusters", y = "Average silhouette")

silhouette_df[which.max(silhouette_df$average_silhouette), ]''',
)

set_code(
    notebook,
    21,
    r'''squared_distance_to_centers <- function(row, centers) {
  differences <- sweep(centers, 2, row, FUN = "-")
  rowSums(differences^2)
}

run_kmeans_cv <- function(seed, data, k_values, folds = 10) {
  set.seed(seed)
  fold_id <- sample(rep(seq_len(folds), length.out = nrow(data)))
  heldout_loss <- matrix(
    NA_real_, nrow = nrow(data), ncol = length(k_values),
    dimnames = list(NULL, paste0("k", k_values))
  )

  for (fold in seq_len(folds)) {
    train_id <- fold_id != fold
    test_id <- !train_id
    train <- data[train_id, , drop = FALSE]
    test <- data[test_id, , drop = FALSE]

    train_center <- colMeans(train)
    train_scale <- apply(train, 2, sd)
    train_z <- scale(train, center = train_center, scale = train_scale)
    test_z <- scale(test, center = train_center, scale = train_scale)

    for (j in seq_along(k_values)) {
      set.seed(seed * 1000 + fold * 100 + j)
      fit <- kmeans(train_z, centers = k_values[j], nstart = 25)
      distances <- apply(test_z, 1, squared_distance_to_centers, centers = fit$centers)
      if (is.null(dim(distances))) distances <- matrix(distances, ncol = 1)
      heldout_loss[test_id, j] <- apply(distances, 2, min)
    }
  }

  heldout_loss
}

cv_by_seed <- lapply(1:5, run_kmeans_cv, data = data, k_values = k_range_explore)
cv_seed_means <- do.call(rbind, lapply(cv_by_seed, colMeans))
round(cv_seed_means, 2)''',
)

set_code(
    notebook,
    22,
    r'''cv_summary <- data.frame(
  k = k_range_explore,
  mean_loss = colMeans(cv_seed_means),
  seed_sd = apply(cv_seed_means, 2, sd)
)
cv_summary$improvement <- c(NA, -diff(cv_summary$mean_loss))

ggplot(cv_summary, aes(k, mean_loss)) +
  geom_ribbon(
    aes(ymin = mean_loss - seed_sd, ymax = mean_loss + seed_sd),
    fill = "#0066cc", alpha = 0.15
  ) +
  geom_line(color = "#0066cc", linewidth = 1) +
  geom_point(color = "#0066cc", size = 2.5) +
  scale_x_continuous(breaks = k_range_explore) +
  theme_minimal() +
  labs(x = "Number of clusters", y = "Held out squared distance")

print(cv_summary)

# The silhouette summary favors two profiles. The largest held out gains occur
# before four profiles, and the full data reveal a theoretically useful third
# profile distinguished by current literacy. We therefore carry k = 3 forward
# and describe the disagreement among the diagnostics.
optimal_k <- 3''',
)

set_code(
    notebook,
    24,
    r'''set.seed(42)
optimal_kmeans <- kmeans(data_scaled, centers = optimal_k, nstart = 100)
pca_df$cluster <- factor(optimal_kmeans$cluster)

centers_original <- sweep(
  sweep(
    optimal_kmeans$centers,
    2, attr(data_scaled, "scaled:scale"), FUN = "*"
  ),
  2, attr(data_scaled, "scaled:center"), FUN = "+"
)

print(table(optimal_kmeans$cluster))
print(round(centers_original, 1))

ggplot(pca_df, aes(PC1, PC2, color = cluster)) +
  geom_point(alpha = 0.7, size = 2.5) +
  theme_minimal() +
  labs(color = "Profile")''',
)

set_code(
    notebook,
    28,
    r'''set.seed(42)
gmm_complete <- Mclust(data_scaled, G = 2:15, verbose = FALSE)

cat("Selected components:", gmm_complete$G, "\n")
cat("Covariance model:", gmm_complete$modelName, "\n")
cat("Log likelihood:", round(gmm_complete$loglik, 2), "\n")
cat("Mixing proportions:\n")
print(round(gmm_complete$parameters$pro, 3))

plot(gmm_complete, what = "BIC")''',
)

set_code(
    notebook,
    30,
    r'''run_gmm_cv <- function(seed, data, component_values, folds = 10) {
  set.seed(seed)
  fold_id <- sample(rep(seq_len(folds), length.out = nrow(data)))
  heldout_loss <- matrix(
    NA_real_, nrow = nrow(data), ncol = length(component_values),
    dimnames = list(NULL, paste0("G", component_values))
  )

  for (fold in seq_len(folds)) {
    train_id <- fold_id != fold
    test_id <- !train_id
    train <- data[train_id, , drop = FALSE]
    test <- data[test_id, , drop = FALSE]
    train_center <- colMeans(train)
    train_scale <- apply(train, 2, sd)
    train_z <- scale(train, center = train_center, scale = train_scale)
    test_z <- scale(test, center = train_center, scale = train_scale)

    for (j in seq_along(component_values)) {
      fit <- try(
        Mclust(train_z, G = component_values[j], verbose = FALSE),
        silent = TRUE
      )
      if (!inherits(fit, "try-error")) {
        heldout_loss[test_id, j] <- -dens(
          test_z,
          modelName = fit$modelName,
          parameters = fit$parameters,
          logarithm = TRUE
        )
      }
    }
  }

  heldout_loss
}

g_values <- 2:10
gmm_cv_by_seed <- lapply(1:5, run_gmm_cv, data = data, component_values = g_values)
gmm_seed_means <- do.call(rbind, lapply(gmm_cv_by_seed, colMeans, na.rm = TRUE))

gmm_cv_summary <- data.frame(
  components = g_values,
  mean_negative_log_density = colMeans(gmm_seed_means),
  seed_sd = apply(gmm_seed_means, 2, sd)
)
print(gmm_cv_summary)

# The small sample makes the held out density curve unstable, especially for
# larger mixtures. The information criterion favors three components, while
# the held out analysis warns us not to treat that number as a discovered fact.''',
)

set_code(
    notebook,
    32,
    r'''gmm_centers_original <- sweep(
  sweep(
    t(gmm_complete$parameters$mean),
    2, attr(data_scaled, "scaled:scale"), FUN = "*"
  ),
  2, attr(data_scaled, "scaled:center"), FUN = "+"
)

print(round(gmm_centers_original, 1))
cat("Component sizes:\n")
print(table(gmm_complete$classification))
cat("Mean classification uncertainty:", mean(gmm_complete$uncertainty), "\n")
cat("Maximum classification uncertainty:", max(gmm_complete$uncertainty), "\n")''',
)

set_code(
    notebook,
    36,
    r'''all_data <- read.csv("data/malayalam_all_data.csv")

cat("Participants:", nrow(all_data), "\n")
cat("Missing cells:", sum(is.na(all_data)), "\n")

missing_summary <- data.frame(
  variable = names(all_data),
  missing_n = colSums(is.na(all_data)),
  missing_percent = 100 * colMeans(is.na(all_data))
)
print(missing_summary)

missing_long <- as.data.frame(is.na(all_data)) |>
  mutate(participant = row_number()) |>
  pivot_longer(-participant, names_to = "variable", values_to = "missing")

ggplot(missing_long, aes(variable, participant, fill = missing)) +
  geom_tile() +
  scale_fill_manual(values = c("white", "#d73027")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))''',
)

set_code(
    notebook,
    39,
    r'''set.seed(42)
component_search <- estim_ncpPCA(
  all_data, ncp.min = 0, ncp.max = 5,
  method.cv = "Kfold", nbsim = 50
)
imputation_components <- component_search$ncp

imputed_result <- imputePCA(all_data, ncp = imputation_components)
imputed_data <- as.data.frame(imputed_result$completeObs)
names(imputed_data) <- names(all_data)

cat("PCA components used:", imputation_components, "\n")
cat("Missing cells after imputation:", sum(is.na(imputed_data)), "\n")''',
)

set_code(
    notebook,
    41,
    r'''observed_locations <- which(!is.na(as.matrix(all_data)), arr.ind = TRUE)
observed_scale <- apply(all_data, 2, sd, na.rm = TRUE)

validate_imputation <- function(seed, mask_share = 0.10) {
  set.seed(seed)
  selected <- sample(
    seq_len(nrow(observed_locations)),
    floor(mask_share * nrow(observed_locations))
  )
  masked_locations <- observed_locations[selected, , drop = FALSE]
  masked_data <- all_data
  true_values <- numeric(nrow(masked_locations))

  for (i in seq_len(nrow(masked_locations))) {
    row <- masked_locations[i, 1]
    column <- masked_locations[i, 2]
    true_values[i] <- masked_data[row, column]
    masked_data[row, column] <- NA
  }

  component_fit <- estim_ncpPCA(
    masked_data, ncp.min = 0, ncp.max = 5,
    method.cv = "Kfold", nbsim = 20
  )
  completed <- imputePCA(masked_data, ncp = component_fit$ncp)$completeObs
  predicted_values <- completed[masked_locations]
  variables <- names(all_data)[masked_locations[, 2]]
  standardized_error <-
    (predicted_values - true_values) / observed_scale[masked_locations[, 2]]

  data.frame(
    seed = seed,
    variable = variables,
    squared_error = standardized_error^2
  )
}

masked_results <- bind_rows(lapply(1:5, validate_imputation))
overall_rmse <- masked_results |>
  group_by(seed) |>
  summarize(RMSE = sqrt(mean(squared_error)), .groups = "drop")
variable_rmse <- masked_results |>
  group_by(variable) |>
  summarize(RMSE = sqrt(mean(squared_error)), .groups = "drop") |>
  arrange(desc(RMSE))

print(overall_rmse)
print(variable_rmse)

# In a reference run, overall RMSE ranged from about 0.59 to 0.83 standard
# deviations. Q16_1 and Q18_3 had the largest errors. The completed data are
# therefore useful for a sensitivity analysis, but not a replacement for the
# observed answers.''',
)

set_code(
    notebook,
    43,
    r'''imputed_scaled <- scale(imputed_data)
set.seed(42)
gmm_imputed <- Mclust(imputed_scaled, G = 2:10, verbose = FALSE)

imputed_centers_original <- sweep(
  sweep(
    t(gmm_imputed$parameters$mean),
    2, attr(imputed_scaled, "scaled:scale"), FUN = "*"
  ),
  2, attr(imputed_scaled, "scaled:center"), FUN = "+"
)

cat("Complete case components:", gmm_complete$G, "\n")
cat("Imputed data components:", gmm_imputed$G, "\n")
cat("Imputed data covariance model:", gmm_imputed$modelName, "\n")
cat("Imputed data mixing proportions:\n")
print(round(gmm_imputed$parameters$pro, 3))
cat("Imputed data mean uncertainty:", mean(gmm_imputed$uncertainty), "\n")
cat("Imputed data maximum uncertainty:", max(gmm_imputed$uncertainty), "\n")
print(round(imputed_centers_original, 1))

# A reference run selects three components for both datasets. The three broad
# profiles survive, but some means and uncertainty estimates change. That is
# the intended conclusion: the linguistic profile contrast is fairly stable,
# while its exact numerical description depends on the treatment of missing
# responses.''',
)

with ANSWER.open("w", encoding="utf-8") as stream:
    json.dump(notebook, stream, indent=1, ensure_ascii=False)
    stream.write("\n")

