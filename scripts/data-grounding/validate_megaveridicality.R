#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

root <- script_argument(1, "data/megaveridicality")
provenance <- jsonlite::read_json(
  file.path(root, "provenance.json"),
  simplifyVector = TRUE
)

for (entry in provenance$derived) {
  assert_sha256(file.path(root, entry$path), entry$sha256)
}
assert_sha256(file.path(root, "LICENSE"), provenance$source_license_sha256)

source_data <- utils::read.csv(
  file.path(root, "megaveridicality-v1-source.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)
teaching <- utils::read.csv(
  file.path(root, "megaveridicality-v1-active-native.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)
folds <- utils::read.csv(
  file.path(root, "verb-folds.csv"),
  stringsAsFactors = FALSE
)

stopifnot(
  nrow(source_data) == 21760L,
  length(unique(source_data$verb)) == 517L,
  length(unique(source_data$participant)) == 291L,
  length(intersect(
    unique(source_data$participant[source_data$conditional == "False"]),
    unique(source_data$participant[source_data$conditional == "True"])
  )) == 29L,
  nrow(teaching) == 14951L,
  length(unique(teaching$verb)) == 375L,
  length(unique(teaching$respondent_id)) == 319L,
  length(unique(paste(
    teaching$verb, teaching$polarity, teaching$task, sep = ":"
  ))) == 1500L,
  all(startsWith(teaching$respondent_id, paste0(teaching$task, ":"))),
  setequal(teaching$response, c("no", "maybe", "yes")),
  nrow(folds) == 375L,
  !anyDuplicated(folds$verb),
  setequal(folds$verb, unique(teaching$verb)),
  setequal(folds$fold, 1:5)
)

cat("MegaVeridicality v1 validation passed.\n")
