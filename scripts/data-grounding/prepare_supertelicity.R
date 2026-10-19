#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

input_path <- script_argument(
  1,
  "slides-archive/lecture11/supertelicity/data/data-cloze.csv"
)
output_dir <- script_argument(2, "data/supertelicity")
expected_sha256 <-
  "a3aaf70ed014180a4c5dab3eaf7d6c3e40b5514fa3cb3e9afe8ffd97e86d96ac"

assert_sha256(input_path, expected_sha256)
raw <- utils::read.csv(input_path, stringsAsFactors = FALSE, check.names = FALSE)
required <- c(
  "participant", "verb_type", "verb", "propbank_sense", "concreteness",
  "contentfulness", "clause_type", "condition", "list_num", "sentence",
  "preposition", "numeral", "duration"
)
assert_columns(raw, required)
stopifnot(
  nrow(raw) == 9160L,
  length(unique(raw$participant)) == 200L,
  length(unique(raw$verb)) == 40L,
  setequal(unique(raw$preposition), c("for", "in")),
  setequal(unique(raw$verb_type), c("manner", "result"))
)

minutes_per_unit <- c(
  milliseconds = 1 / 60000,
  seconds = 1 / 60,
  minutes = 1,
  hours = 60,
  days = 60 * 24,
  weeks = 60 * 24 * 7,
  months = 60 * 24 * 7 * 4.35,
  years = 60 * 24 * 7 * 4.35 * 12,
  decades = 60 * 24 * 7 * 4.35 * 12 * 10,
  centuries = 60 * 24 * 7 * 4.35 * 12 * 100,
  millenia = 60 * 24 * 7 * 4.35 * 12 * 1000
)
stopifnot(
  all(raw$duration %in% names(minutes_per_unit)),
  all(raw$numeral[!is.na(raw$numeral)] > 0),
  sum(is.na(raw$numeral)) == 3780L
)

sentence_id <- vapply(
  raw$sentence,
  function(value) substr(
    digest::digest(value, algo = "sha256", serialize = FALSE),
    1L,
    16L
  ),
  character(1)
)

teaching <- data.frame(
  participant_id = raw$participant,
  sentence_id = sentence_id,
  verb = raw$verb,
  verb_type = raw$verb_type,
  propbank_sense = raw$propbank_sense,
  concreteness = raw$concreteness,
  contentfulness = raw$contentfulness,
  clause_type = raw$clause_type,
  condition = raw$condition,
  list_number = as.integer(raw$list_num),
  preposition = raw$preposition,
  prep_in = as.integer(raw$preposition == "in"),
  numeral = as.numeric(raw$numeral),
  time_unit = raw$duration,
  log_duration_minutes = ifelse(
    is.na(raw$numeral),
    NA_real_,
    log(as.numeric(raw$numeral) * unname(minutes_per_unit[raw$duration]))
  ),
  stringsAsFactors = FALSE
)
teaching <- teaching[
  order(teaching$participant_id, teaching$list_number, teaching$sentence_id),
]
row.names(teaching) <- NULL

stopifnot(
  nrow(teaching) == 9160L,
  all(teaching$prep_in %in% 0:1),
  length(unique(teaching$sentence_id)) == length(unique(raw$sentence)),
  all(is.finite(teaching$log_duration_minutes[!is.na(teaching$log_duration_minutes)])),
  sum(is.na(teaching$log_duration_minutes)) == 3780L
)

output_path <- file.path(output_dir, "supertelicity-cloze.csv")
write_csv_stable(teaching, output_path)
write_json_stable(
  list(
    title = "SuperTelicity cloze experiment",
    creators = "Lelia Glass, Angela Cao, and Aaron Steven White",
    source = "https://github.com/SuperMereo/supertelicity",
    source_commit = "e45277ce466719c1a03629f6ccf1e12db9904421",
    source_file = "data/data-cloze.csv",
    source_sha256 = expected_sha256,
    license = "CC BY-SA 4.0",
    adaptation = paste(
      "The teaching table removes sentence text, hashes sentence identity,",
      "codes in as 1, and converts the selected duration to log minutes."
    ),
    duration_conversion = as.list(minutes_per_unit),
    missing_selected_numerals = sum(is.na(teaching$numeral)),
    rows = nrow(teaching),
    participants = length(unique(teaching$participant_id)),
    sentences = length(unique(teaching$sentence_id)),
    verbs = length(unique(teaching$verb)),
    output_sha256 = sha256_file(output_path)
  ),
  file.path(output_dir, "provenance.json")
)

cat("Prepared", nrow(teaching), "SuperTelicity cloze trials.\n")
