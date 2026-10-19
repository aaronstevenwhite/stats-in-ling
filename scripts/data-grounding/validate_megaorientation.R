#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

root <- script_argument(1, "data/megaorientation")
provenance <- jsonlite::read_json(
  file.path(root, "provenance.json"),
  simplifyVector = TRUE
)

for (entry in provenance$derived) {
  assert_sha256(file.path(root, entry$path), entry$sha256)
}
assert_sha256(file.path(root, "LICENSE"), provenance$source_license_sha256)

data <- utils::read.delim(
  file.path(root, "megaorientation-v1.1.tsv"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)
folds <- utils::read.csv(
  file.path(root, "verb-folds-multiframe.csv"),
  stringsAsFactors = FALSE
)

stopifnot(
  nrow(data) == 44160L,
  length(unique(data$verb)) == 898L,
  length(unique(data$participant_id)) == 862L,
  length(unique(data$verb_frame_id)) == 2208L,
  length(unique(data$item_id)) == 4416L,
  all(table(data$item_id) == 10L),
  setequal(data$response, 1:7),
  setequal(data$orientation, c("past", "future")),
  length(unique(data$frame_code)) == 5L,
  nrow(folds) == 662L,
  !anyDuplicated(folds$verb),
  all(folds$frames_observed >= 2L),
  setequal(folds$fold, 1:5)
)

represented_frames <- table(unique(data[c("verb", "frame_code")])$verb)
stopifnot(
  setequal(folds$verb, names(represented_frames[represented_frames >= 2L]))
)

cat("MegaOrientation v1.1 validation passed.\n")
