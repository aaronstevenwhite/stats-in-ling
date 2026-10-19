#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

checks <- list()
record <- function(name, expression) {
  result <- tryCatch(
    {
      force(expression)
      "ready"
    },
    error = function(error) paste("FAIL:", conditionMessage(error))
  )
  checks[[name]] <<- result
}

record("MALD", {
  trials <- utils::read.csv("data/mald/mald-connected-trials.csv", check.names = FALSE)
  items <- utils::read.csv("data/mald/mald-items.csv", check.names = FALSE)
  stopifnot(
    nrow(trials) > 10000L,
    length(unique(trials$item)) == 5000L,
    length(unique(trials$participant_id)) >= 90L,
    nrow(items) == 23756L,
    all(c("rt_ms", "correct", "participant_id", "item") %in% names(trials)),
    "part_of_speech" %in% names(items)
  )
})

record("SuperTelicity", {
  data <- utils::read.csv("data/supertelicity/supertelicity-cloze.csv", check.names = FALSE)
  stopifnot(
    nrow(data) == 9160L,
    length(unique(data$participant_id)) == 200L,
    length(unique(data$verb)) == 40L,
    all(data$prep_in %in% 0:1)
  )
})

record("Nettle local", {
  data <- utils::read.csv("data/nettle/nettle-1999-climate.csv", check.names = FALSE)
  stopifnot(nrow(data) == 74L, range(data$language_count) == c(1L, 862L))
})

record("Storme local", {
  data <- utils::read.csv("data/storme-liaison/storme-liaison-counts.csv", check.names = FALSE)
  stopifnot(
    nrow(data) == 11195L,
    sum(data$liaison == "no") == 6270L,
    sum(data$liaison == "yes") == 4925L
  )
})

record("CommitmentBank local", {
  data <- utils::read.csv("data/commitmentbank/commitmentbank-ratings.csv", check.names = FALSE)
  stopifnot(
    nrow(data) == 11545L,
    length(unique(data$discourse_id)) == 1200L,
    length(unique(data$annotator_id)) == 496L,
    setequal(unique(data$rating), -3:3)
  )
})

record("Aspectual similarity", {
  path <- "data/aspectual-similarity/within-verb-similarity.csv"
  assert_sha256(path, "b19edbb7463a6767274e3dde78e902b0e8777424a21d7fdf231ea1e6d0e25f35")
  data <- utils::read.csv(path, check.names = FALSE)
  stopifnot(
    nrow(data) == 4405L,
    length(unique(data$participant_id)) == 202L,
    length(unique(data$verb)) == 14L,
    length(unique(data$sentence_pair_id)) == 218L,
    setequal(unique(data$same_sense), 0:1),
    range(data$dissimilarity) == c(0L, 100L)
  )
})

record("Peterson--Barney", {
  source("scripts/data-grounding/validate_pb52.R", local = TRUE)
})

record("PHOIBLE", {
  data <- readRDS("data/phoible/phoible-pilot.rds")
  stopifnot(
    data$provenance$archive_commit == "350563f179293254be2f92886d6fa8ba8e7cbbb2",
    data$provenance$sha256 == "fb8247bb97b21aea5a482062692f82f13724e6ee53da64f233273f0a705adf0a",
    nrow(data$memberships) == 101977L,
    nrow(data$inventories) == 3020L,
    nrow(data$segments) == 3115L,
    all(c("inventory_id", "glottocode", "segment_id") %in% names(data$memberships))
  )
})

record("VALEX + MegaAcceptability", {
  root <- "data/valex-megaacceptability"
  assert_sha256(
    file.path(root, "bundle-provenance.json"),
    "6341f48ea5d5d046bddb80fe9d60bb336d18e5dc970559531ea9485e6519bd8c"
  )
  provenance <- jsonlite::read_json(
    file.path(root, "bundle-provenance.json"),
    simplifyVector = TRUE
  )
  for (name in names(provenance$files)) {
    assert_sha256(file.path(root, name), provenance$files[[name]])
  }
  valex <- utils::read.csv(
    gzfile(file.path(root, "audited/valex-counts.csv.gz")),
    check.names = FALSE
  )
  mega <- utils::read.csv(
    gzfile(file.path(root, "audited/megaacceptability-responses.csv.gz")),
    check.names = FALSE
  )
  outer <- utils::read.csv(
    gzfile(file.path(root, "audited/outer-predictions.csv.gz")),
    check.names = FALSE
  )
  selection <- utils::read.csv(
    file.path(root, "audited/factor-selection-frequency.csv"),
    check.names = FALSE
  )
  summary <- jsonlite::read_json(
    file.path(root, "audited/pilot-summary.json"),
    simplifyVector = TRUE
  )
  skill <- function(outcome, prediction, baseline) {
    1 - sum((outcome - prediction)^2) / sum((outcome - baseline)^2)
  }
  direct_skill <- skill(outer$outcome, outer$direct, outer$baseline)
  factor_skill <- skill(outer$outcome, outer$factor, outer$baseline)
  stopifnot(
    nrow(valex) == 958L,
    ncol(valex) == 110L,
    nrow(mega) == 238917L,
    length(unique(mega$frame)) == 50L,
    length(unique(outer$verb)) == 958L,
    setequal(unique(outer$verb), valex$verb),
    all(c("outcome", "baseline", "direct", "factor") %in% names(outer)),
    nrow(outer) == 239500L,
    nrow(selection) == 2L,
    all(selection$factor_rank == 50L),
    sum(selection$outer_folds) == 50L,
    abs(direct_skill - summary$performance$direct_skill) < 1e-12,
    abs(factor_skill - summary$performance$factor_skill) < 1e-12,
    abs(
      (factor_skill - direct_skill) -
        summary$performance$factor_minus_direct
    ) < 1e-12
  )
})

record("Raw Hillenbrand", {
  path <- "data/hillenbrand-raw/hillenbrand-raw-formants.csv"
  assert_sha256(
    path,
    "8538ef208b5caee7d9eed45e38bcf9c0aacf9f45224753aa1574433dcaf6a069"
  )
  provenance <- jsonlite::read_json(
    "data/hillenbrand-raw/provenance.json",
    simplifyVector = TRUE
  )
  stopifnot(identical(provenance$output_sha256, sha256_file(path)))
  data <- utils::read.csv(path, check.names = FALSE)
  stopifnot(
    nrow(data) == 1668L,
    length(unique(data$speaker_id)) == 139L,
    sum(is.na(data$f2_steady_hz)) == 10L,
    sum(is.na(data$f3_steady_hz)) == 41L
  )
})

record("UDS approved binary extract", {
  data <- utils::read.csv("data/uds/uds-natural-parts.csv", check.names = FALSE)
  stopifnot(
    nrow(data) == 2955L,
    length(unique(data$item_id)) == 1000L,
    length(unique(data$annotator_id)) == 12L,
    setequal(unique(data$natural_parts), 0:1)
  )
})

record("Natural Stories corrected", {
  data <- readRDS("data/natural-stories/natural-stories-corrected.rds")
  stopifnot(
    nrow(data) == 848875L,
    length(unique(data$participant_id)) == 180L,
    length(unique(data$story_id)) == 10L,
    length(unique(data$sentence_id)) == 485L,
    all(c("unigram_frequency", "gpt3_surprisal") %in% names(data))
  )
})

record("ManyBabies 1", {
  data <- readRDS("data/manybabies/manybabies1-trials.rds")
  stopifnot(
    nrow(data) == 37264L,
    length(unique(data$infant_id)) == 2329L,
    length(unique(data$lab_id)) == 67L,
    setequal(stats::na.omit(unique(data$register)), c("ADS", "IDS")),
    sum(data$trial_missing) == 10369L,
    sum(!data$trial_metadata_observed) == 4383L,
    all(is.na(data$looking_time_seconds) == data$trial_missing)
  )
})

result <- data.frame(
  resource = names(checks),
  status = unname(unlist(checks)),
  stringsAsFactors = FALSE
)
print(result, row.names = FALSE)
if (any(grepl("^FAIL:", result$status))) {
  quit(status = 1L)
}
