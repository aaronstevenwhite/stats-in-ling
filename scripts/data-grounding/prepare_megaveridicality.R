#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

archive_path <- script_argument(1, "/private/tmp/megaattitude-audit/mega-veridicality-v1.zip")
output_dir <- script_argument(2, "data/megaveridicality")

archive_sha256 <-
  "4a3c103289b9040ff3a34140cde4f65d468aedc61910e493cae7328bb1ab146f"
payload_sha256 <-
  "2950dfc9b2dce9907443caf9e8729eac18c2d3ac3339fd7e9fa3613ff4ab831c"
license_sha256 <-
  "7abe19ec9bb73b36141b999b861d24ad855e808bafe0f81e84cce28556f6c297"

assert_sha256(archive_path, archive_sha256)

temporary_dir <- tempfile("megaveridicality-v1-")
dir.create(temporary_dir, recursive = TRUE)
on.exit(unlink(temporary_dir, recursive = TRUE), add = TRUE)
utils::unzip(archive_path, exdir = temporary_dir)

source_dir <- file.path(temporary_dir, "mega-veridicality-v1")
source_path <- file.path(source_dir, "mega-veridicality-v1.csv")
source_license <- file.path(source_dir, "LICENSE")
source_readme <- file.path(source_dir, "README.md")
assert_sha256(source_path, payload_sha256)
assert_sha256(source_license, license_sha256)

raw <- utils::read.csv(
  source_path,
  stringsAsFactors = FALSE,
  check.names = FALSE,
  na.strings = character()
)

required <- c(
  "participant", "list", "presentationorder", "verb", "frame", "voice",
  "polarity", "conditional", "veridicality", "acceptability",
  "nativeenglish", "exclude"
)
assert_columns(raw, required, exact = TRUE)
stopifnot(
  nrow(raw) == 21760L,
  length(unique(raw$verb)) == 517L,
  length(unique(raw$participant)) == 291L,
  setequal(raw$veridicality, c("no", "maybe", "yes")),
  setequal(raw$acceptability, 1:7),
  setequal(raw$voice, c("active", "passive")),
  setequal(raw$polarity, c("positive", "negative")),
  setequal(raw$conditional, c("True", "False")),
  setequal(raw$exclude, c("True", "False"))
)

direct_participants <- unique(raw$participant[raw$conditional == "False"])
conditional_participants <- unique(raw$participant[raw$conditional == "True"])
stopifnot(length(intersect(direct_participants, conditional_participants)) == 29L)

active_native <- raw[raw$voice == "active" & raw$exclude == "False", ]
active_native$task <- ifelse(
  active_native$conditional == "True",
  "conditional",
  "direct"
)
active_native$respondent_id <- paste(
  active_native$task,
  active_native$participant,
  sep = ":"
)
active_native$item_id <- paste(
  active_native$verb,
  active_native$polarity,
  active_native$task,
  sep = ":"
)

teaching <- data.frame(
  participant_id = as.character(active_native$participant),
  respondent_id = active_native$respondent_id,
  list_id = as.integer(active_native$list),
  presentation_order = as.integer(active_native$presentationorder),
  verb = active_native$verb,
  frame = active_native$frame,
  voice = active_native$voice,
  polarity = active_native$polarity,
  task = active_native$task,
  response = active_native$veridicality,
  acceptability = as.integer(active_native$acceptability),
  stringsAsFactors = FALSE
)
teaching <- teaching[
  order(teaching$verb, teaching$task, teaching$polarity,
        teaching$respondent_id, teaching$presentation_order),
]
row.names(teaching) <- NULL

stopifnot(
  nrow(teaching) == 14951L,
  length(unique(teaching$verb)) == 375L,
  length(unique(teaching$respondent_id)) == 319L,
  length(unique(active_native$item_id)) == 1500L,
  setequal(table(table(active_native$item_id)), c(`9` = 49L, `10` = 1451L))
)

make_grouped_folds <- function(values, salt, folds = 5L) {
  units <- sort(unique(as.character(values)))
  hashes <- vapply(
    units,
    function(unit) digest::digest(
      paste(salt, unit, sep = "|"),
      algo = "sha256",
      serialize = FALSE
    ),
    character(1)
  )
  order_index <- order(hashes)
  fold <- integer(length(units))
  fold[order_index] <- (seq_along(order_index) - 1L) %% folds + 1L
  data.frame(verb = units, fold = fold, stringsAsFactors = FALSE)
}

fold_map <- make_grouped_folds(
  teaching$verb,
  "megaveridicality-v1-active-native-verb-folds-v1"
)
stopifnot(nrow(fold_map) == 375L, setequal(fold_map$fold, 1:5))

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
raw_path <- file.path(output_dir, "megaveridicality-v1-source.csv")
teaching_path <- file.path(output_dir, "megaveridicality-v1-active-native.csv")
fold_path <- file.path(output_dir, "verb-folds.csv")
write_csv_stable(raw, raw_path)
write_csv_stable(teaching, teaching_path)
write_csv_stable(fold_map, fold_path)
file.copy(source_license, file.path(output_dir, "LICENSE"), overwrite = TRUE)
file.copy(source_readme, file.path(output_dir, "SOURCE-README.md"), overwrite = TRUE)

provenance <- list(
  title = "MegaVeridicality v1",
  citation = paste(
    "White, Aaron Steven, and Kyle Rawlins. 2018.",
    "The Role of Veridicality and Factivity in Clause Selection.",
    "Proceedings of NELS 48, 221-234."
  ),
  paper = "https://ling.auf.net/lingbuzz/004012/current.pdf",
  project = "https://megaattitude.io/projects/mega-veridicality/",
  release = paste0(
    "https://megaattitude.io/projects/mega-veridicality/",
    "mega-veridicality-v1.zip"
  ),
  version = "1.0",
  release_date = "2018-05-11",
  license = "CC BY-SA 4.0",
  source_archive_sha256 = archive_sha256,
  source_payload_sha256 = payload_sha256,
  source_license_sha256 = license_sha256,
  source_inventory = list(
    rows = nrow(raw),
    verbs = length(unique(raw$verb)),
    raw_participant_labels = length(unique(raw$participant)),
    cross_task_participant_label_collisions = 29L
  ),
  teaching_filter = paste(
    "voice == active and release exclusion flag == False;",
    "the latter removes the one direct-task participant marked nonnative"
  ),
  teaching_inventory = list(
    rows = nrow(teaching),
    verbs = length(unique(teaching$verb)),
    task_specific_respondents = length(unique(teaching$respondent_id)),
    verb_polarity_task_cells = length(unique(active_native$item_id))
  ),
  fold_definition = list(
    grouping_unit = "verb",
    folds = 5L,
    salt = "megaveridicality-v1-active-native-verb-folds-v1"
  ),
  derived = list(
    source_csv = list(
      path = basename(raw_path), rows = nrow(raw), sha256 = sha256_file(raw_path)
    ),
    active_native_csv = list(
      path = basename(teaching_path), rows = nrow(teaching),
      sha256 = sha256_file(teaching_path)
    ),
    verb_folds = list(
      path = basename(fold_path), rows = nrow(fold_map),
      sha256 = sha256_file(fold_path)
    )
  )
)
write_json_stable(provenance, file.path(output_dir, "provenance.json"))

cat(
  "Prepared", nrow(teaching), "active/native judgments from",
  nrow(raw), "MegaVeridicality v1 rows.\n"
)
