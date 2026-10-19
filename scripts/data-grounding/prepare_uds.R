#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

input_path <- script_argument(
  1,
  "research/dataset-audits/uds/uds_natural_parts_teaching.csv"
)
output_dir <- script_argument(2, "data/uds")
expected_sha256 <-
  "2de20140f5ddf3684101fba8599844fb7030a4df001ad29c3887e04b9d938c98"

assert_sha256(input_path, expected_sha256)
data <- utils::read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)
expected_columns <- c(
  "split", "graph_id", "node_id", "item_id", "annotator_id",
  "natural_parts", "released_normalized_value", "released_normalized_confidence"
)
assert_columns(data, expected_columns, exact = TRUE)
stopifnot(
  nrow(data) == 2955L,
  length(unique(data$item_id)) == 1000L,
  length(unique(data$annotator_id)) == 12L,
  identical(as.integer(table(data$natural_parts)[c("0", "1")]), c(2296L, 659L)),
  all(table(data$item_id) >= 2L)
)

output_path <- file.path(output_dir, "uds-natural-parts.csv")
write_csv_stable(data, output_path)
derived_sha256 <- sha256_file(output_path)

write_json_stable(
  list(
    title = "UDS event-structure natural-parts teaching extract",
    citation = "White et al. (2020), LREC, https://aclanthology.org/2020.lrec-1.699/",
    source_release = "decomp 0.3.2",
    source = "https://pypi.org/project/decomp/0.3.2/",
    source_wheel_sha256 = "f93dd0e893d4e726ce71da12e8793170a525184766acb34bd749dbac1a073079",
    extraction_record = "research/dataset-audits/uds/provenance.json",
    license = "CC BY-SA 4.0",
    rows = nrow(data),
    items = length(unique(data$item_id)),
    annotators = length(unique(data$annotator_id)),
    output_sha256 = derived_sha256,
    scope = "binary natural-parts model only; confidence and conditional branches are excluded"
  ),
  file.path(output_dir, "provenance.json")
)
cat("Prepared the approved", nrow(data), "row UDS natural-parts extract.\n")
