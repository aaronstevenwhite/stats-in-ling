#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

input_path <- script_argument(
  1,
  "problem-sets/ps3/data/MALD1_1_AllData.txt"
)
output_dir <- script_argument(2, "data/mald")
expected_sha256 <-
  "9fd61e5e950ffdc1141814498d4ec126669be70b94571f76c44c534eb3927bd4"

assert_sha256(input_path, expected_sha256)

raw <- utils::read.delim(
  input_path,
  stringsAsFactors = FALSE,
  check.names = FALSE,
  na.strings = c("NA", "")
)

required <- c(
  "Subject", "Session", "ExperimentRunID", "Trial", "List", "Item",
  "IsWord", "RT", "ACC", "FreqSUBTLEX", "Duration", "NumPhones",
  "NumSylls", "PhonotacticProbability", "POS"
)
assert_columns(raw, required)
stopifnot(nrow(raw) == 459147L, length(unique(raw$Subject)) == 440L)

word_trials <- raw[
  raw$IsWord %in% TRUE &
    !is.na(raw$RT) & raw$RT > 200 & raw$RT < 3000 &
    !is.na(raw$FreqSUBTLEX) & raw$FreqSUBTLEX > 0,
  required
]

hash_key <- function(value, salt) {
  vapply(
    as.character(value),
    function(current) digest::digest(
      paste(salt, current, sep = "|"),
      algo = "sha256",
      serialize = FALSE
    ),
    character(1)
  )
}

# The selection is response-blind. Participants are fixed first; eligible items
# must then have at least two observations among those participants.
participants <- sort(unique(as.character(word_trials$Subject)))
participants <- participants[
  order(hash_key(participants, "mald-connected-participants-v1"))
][seq_len(100L)]
candidate <- word_trials[as.character(word_trials$Subject) %in% participants, ]
item_load <- table(candidate$Item)
eligible_items <- names(item_load[item_load >= 2L])
stopifnot(length(eligible_items) >= 5000L)
selected_items <- eligible_items[
  order(hash_key(eligible_items, "mald-connected-items-v1"))
][seq_len(5000L)]
teaching <- candidate[candidate$Item %in% selected_items, ]

trials <- data.frame(
  participant_id = as.character(teaching$Subject),
  session_id = as.character(teaching$Session),
  run_id = as.character(teaching$ExperimentRunID),
  trial_order = as.integer(teaching$Trial),
  list = as.character(teaching$List),
  item = as.character(teaching$Item),
  rt_ms = as.numeric(teaching$RT),
  log_rt = log(as.numeric(teaching$RT)),
  correct = as.integer(teaching$ACC %in% TRUE),
  frequency_subtlex = as.numeric(teaching$FreqSUBTLEX),
  log_frequency_subtlex = log(as.numeric(teaching$FreqSUBTLEX)),
  duration_ms = as.numeric(teaching$Duration),
  log_duration = log(as.numeric(teaching$Duration)),
  n_phones = as.integer(teaching$NumPhones),
  n_syllables = as.integer(teaching$NumSylls),
  phonotactic_probability = as.numeric(teaching$PhonotacticProbability),
  part_of_speech = as.character(teaching$POS),
  stringsAsFactors = FALSE
)
trials <- trials[order(trials$participant_id, trials$run_id, trials$trial_order), ]
row.names(trials) <- NULL

stopifnot(
  nrow(trials) > 10000L,
  length(unique(trials$participant_id)) >= 90L,
  length(unique(trials$item)) == 5000L,
  min(table(trials$item)) >= 2L,
  all(trials$correct %in% 0:1)
)

correct_trials <- raw[
  raw$IsWord %in% TRUE & raw$ACC %in% TRUE &
    !is.na(raw$RT) & raw$RT > 200 & raw$RT < 3000 &
    !is.na(raw$FreqSUBTLEX) & raw$FreqSUBTLEX > 0,
  ]
index <- split(seq_len(nrow(correct_trials)), correct_trials$Item)
summarize_item <- function(rows) {
  current <- correct_trials[rows, ]
  log_rt <- log(current$RT)
  c(
    n_observations = length(rows),
    mean_rt_ms = mean(current$RT),
    sd_rt_ms = stats::sd(current$RT),
    mean_log_rt = mean(log_rt),
    sd_log_rt = stats::sd(log_rt),
    variance_log_rt = stats::var(log_rt),
    frequency_subtlex = current$FreqSUBTLEX[[1]],
    duration_ms = current$Duration[[1]],
    n_phones = current$NumPhones[[1]],
    n_syllables = current$NumSylls[[1]],
    phonotactic_probability = current$PhonotacticProbability[[1]]
  )
}
summaries <- t(vapply(index, summarize_item, numeric(11)))
item_pos <- vapply(index, function(rows) {
  values <- unique(correct_trials$POS[rows])
  values <- values[!is.na(values) & nzchar(values)]
  if (length(values) > 1L) {
    stop("An item has more than one nonmissing part-of-speech label: ",
         correct_trials$Item[rows[[1]]])
  }
  if (length(values)) values[[1]] else NA_character_
}, character(1))
items <- data.frame(
  item = names(index),
  part_of_speech = unname(item_pos),
  summaries,
  stringsAsFactors = FALSE,
  check.names = FALSE
)
items <- items[items$n_observations >= 5L, ]
items$log_frequency_subtlex <- log(items$frequency_subtlex)
items$log_duration <- log(items$duration_ms)
items <- items[order(items$item), ]
row.names(items) <- NULL

stopifnot(nrow(items) == 23756L, all(items$n_observations >= 5L))

trial_path <- file.path(output_dir, "mald-connected-trials.csv")
item_path <- file.path(output_dir, "mald-items.csv")
write_csv_stable(trials, trial_path)
write_csv_stable(items, item_path)

provenance <- list(
  title = "Massive Auditory Lexical Decision (MALD) database 1.1",
  citation = paste(
    "Tucker et al. (2019), Behavior Research Methods 51:1187-1204,",
    "doi:10.3758/s13428-018-1056-1"
  ),
  source = "https://doi.org/10.7939/r3-kh0r-r116",
  license = "CC BY-NC 4.0",
  source_sha256 = expected_sha256,
  filters = list(
    item_table = "word, correct, 200 < RT < 3000 ms, SUBTLEX frequency > 0, at least five trials",
    connected_table = "word, 200 < RT < 3000 ms, SUBTLEX frequency > 0; response-blind hash selection"
  ),
  selection = list(
    participant_salt = "mald-connected-participants-v1",
    requested_participants = 100L,
    retained_participants = length(unique(trials$participant_id)),
    item_salt = "mald-connected-items-v1",
    retained_items = length(unique(trials$item)),
    minimum_item_load = min(table(trials$item))
  ),
  derived = list(
    connected_trials = list(
      path = basename(trial_path),
      rows = nrow(trials),
      sha256 = sha256_file(trial_path)
    ),
    item_summaries = list(
      path = basename(item_path),
      rows = nrow(items),
      sha256 = sha256_file(item_path)
    )
  )
)
write_json_stable(provenance, file.path(output_dir, "provenance.json"))

cat("Prepared", nrow(trials), "connected trials and", nrow(items), "items.\n")
