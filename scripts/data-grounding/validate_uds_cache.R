#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
root <- if (length(args)) normalizePath(args[[1]], mustWork = TRUE) else getwd()
source(file.path(root, "scripts/data-grounding/common.R"))

cache_path <- file.path(root, "data/uds/uds-natural-parts-posterior-cache.rds")
csv_path <- file.path(root, "data/uds/uds-natural-parts.csv")

assert_sha256(
  cache_path,
  "19b9920f55506717d9b54667f9495f9703d6e5fc213b5f4fb4350f99096bfb08"
)
assert_sha256(
  csv_path,
  "a9d49305fe6b4780a0f3da845bd3d6bc8ed8908c3664c6931180d4346a46e2f8"
)

audit_paths <- c(
  cache = file.path(
    root,
    "research/dataset-audits/reference-missing-custom-output/uds-natural-parts-posterior-cache.rds"
  ),
  fit = file.path(
    root,
    "research/dataset-audits/uds/results/fit-objects/released-fit.rds"
  ),
  stan = file.path(root, "research/dataset-audits/uds/uds_natural_parts.stan")
)
audit_hashes <- c(
  cache = "19b9920f55506717d9b54667f9495f9703d6e5fc213b5f4fb4350f99096bfb08",
  fit = "f48a5b9d37fc91728804366515b8c34864fa69f9ece7755f33a6007a4641005c",
  stan = "5d85750a5090c6b1cd709844336372e945ec85e68f8391f0c72d7a8141329fc0"
)
for (name in names(audit_paths)) {
  if (file.exists(audit_paths[[name]])) {
    assert_sha256(audit_paths[[name]], audit_hashes[[name]])
  }
}

cache <- readRDS(cache_path)
responses <- read.csv(csv_path, stringsAsFactors = FALSE, check.names = FALSE)

stopifnot(
  identical(dim(cache$population_draws), c(400L, 3L)),
  identical(dim(cache$item_effect_draws), c(400L, 1000L)),
  identical(dim(cache$annotator_effect_draws), c(400L, 12L)),
  identical(cache$item_levels, unique(responses$item_id)),
  identical(cache$annotator_levels, unique(responses$annotator_id)),
  identical(
    unname(cache$provenance$source_csv_sha256),
    "a9d49305fe6b4780a0f3da845bd3d6bc8ed8908c3664c6931180d4346a46e2f8"
  ),
  identical(
    unname(cache$provenance$source_fit_sha256),
    "f48a5b9d37fc91728804366515b8c34864fa69f9ece7755f33a6007a4641005c"
  ),
  identical(
    unname(cache$provenance$stan_sha256),
    "5d85750a5090c6b1cd709844336372e945ec85e68f8391f0c72d7a8141329fc0"
  ),
  identical(cache$provenance$fit_seeds, 880001:880004),
  identical(cache$provenance$retained_cache_rows, seq(4L, 3200L, by = 8L))
)

cat("UDS posterior cache validation passed.\n")
