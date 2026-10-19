#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

archive_path <- script_argument(1, "/private/tmp/megaattitude-audit/mega-orientation-v1.1.zip")
output_dir <- script_argument(2, "data/megaorientation")

archive_sha256 <-
  "12d2b74f07503fd7a521ae6f170b9b74f41f59cd33bc1697b3177a8f8da6a4ca"
payload_sha256 <-
  "d2fb74099e3d2af7e7667f7eadfb8c5ba000a6cbbfe7b03a0962e45664a39d40"
license_sha256 <-
  "7abe19ec9bb73b36141b999b861d24ad855e808bafe0f81e84cce28556f6c297"

assert_sha256(archive_path, archive_sha256)

temporary_dir <- tempfile("megaorientation-v1.1-")
dir.create(temporary_dir, recursive = TRUE)
on.exit(unlink(temporary_dir, recursive = TRUE), add = TRUE)
utils::unzip(archive_path, exdir = temporary_dir)

source_dir <- file.path(temporary_dir, "mega-orientation-v1.1")
source_path <- file.path(source_dir, "mega-orientation-v1.1.tsv")
source_license <- file.path(source_dir, "LICENSE")
source_readme <- file.path(source_dir, "README.md")
assert_sha256(source_path, payload_sha256)
assert_sha256(source_license, license_sha256)

raw <- utils::read.delim(
  source_path,
  stringsAsFactors = FALSE,
  check.names = FALSE,
  na.strings = character()
)
required <- c(
  "list", "participant", "verb", "frame", "orientation", "sentence",
  "response"
)
assert_columns(raw, required, exact = TRUE)

verb_frame <- interaction(raw$verb, raw$frame, drop = TRUE)
sentence_item <- interaction(verb_frame, raw$orientation, drop = TRUE)
stopifnot(
  nrow(raw) == 44160L,
  length(unique(raw$verb)) == 898L,
  length(unique(raw$participant)) == 862L,
  length(unique(verb_frame)) == 2208L,
  length(unique(sentence_item)) == 4416L,
  all(table(sentence_item) == 10L),
  setequal(raw$response, 1:7),
  setequal(raw$orientation, c("future", "past")),
  length(unique(raw$frame)) == 5L
)

frame_labels <- c(
  "NP _ed to VP[-eventive]" = "active_to_stative",
  "NP _ed to VP[+eventive]" = "active_to_eventive",
  "NP _ed VPing" = "active_gerund",
  "NP was _ed to VP[-eventive]" = "passive_to_stative",
  "NP was _ed to VP[+eventive]" = "passive_to_eventive"
)
stopifnot(setequal(names(frame_labels), unique(raw$frame)))

teaching <- data.frame(
  list_id = as.integer(raw$list),
  participant_id = as.character(raw$participant),
  verb = raw$verb,
  frame = raw$frame,
  frame_code = unname(frame_labels[raw$frame]),
  orientation = raw$orientation,
  sentence = raw$sentence,
  response = as.integer(raw$response),
  verb_frame_id = paste(raw$verb, unname(frame_labels[raw$frame]), sep = ":"),
  item_id = paste(
    raw$verb,
    unname(frame_labels[raw$frame]),
    raw$orientation,
    sep = ":"
  ),
  stringsAsFactors = FALSE
)
teaching <- teaching[
  order(teaching$verb, teaching$frame_code, teaching$orientation,
        teaching$participant_id),
]
row.names(teaching) <- NULL

verb_frames <- unique(teaching[c("verb", "frame_code")])
frames_observed <- table(verb_frames$verb)

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
  names(frames_observed[frames_observed >= 2L]),
  "megaorientation-v1.1-multiframe-verb-folds-v1"
)
fold_map$frames_observed <- as.integer(frames_observed[fold_map$verb])
fold_map <- fold_map[order(fold_map$verb), ]
row.names(fold_map) <- NULL
stopifnot(nrow(fold_map) == 662L, setequal(fold_map$fold, 1:5))

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
teaching_path <- file.path(output_dir, "megaorientation-v1.1.tsv")
fold_path <- file.path(output_dir, "verb-folds-multiframe.csv")
temporary <- paste0(teaching_path, ".tmp")
utils::write.table(
  teaching,
  temporary,
  sep = "\t",
  row.names = FALSE,
  na = "",
  quote = TRUE,
  fileEncoding = "UTF-8"
)
if (!file.rename(temporary, teaching_path)) {
  stop("Could not move prepared data into place: ", teaching_path)
}
write_csv_stable(fold_map, fold_path)
file.copy(source_license, file.path(output_dir, "LICENSE"), overwrite = TRUE)
file.copy(source_readme, file.path(output_dir, "SOURCE-README.md"), overwrite = TRUE)

provenance <- list(
  title = "MegaOrientation v1.1",
  citation = paste(
    "Moon, Ellise, and Aaron Steven White. 2020.",
    "The Source of Nonfinite Temporal Interpretation.",
    "Proceedings of NELS 50, 11-24."
  ),
  paper = "https://ling.auf.net/lingbuzz/005282/current.pdf",
  project = "https://megaattitude.io/projects/mega-orientation/",
  release = paste0(
    "https://megaattitude.io/projects/mega-orientation/",
    "mega-orientation-v1.1.zip"
  ),
  version = "1.1",
  release_date = "2020-06-15",
  license = "CC BY-SA 4.0",
  source_archive_sha256 = archive_sha256,
  source_payload_sha256 = payload_sha256,
  source_license_sha256 = license_sha256,
  release_note = paste(
    "Version 1.1 filters and reruns v1 lists containing incorrectly inflected",
    "irregular verbs. The paper analyzes v1 (887 verbs, 869 participants);",
    "all course-computed counts refer to v1.1."
  ),
  inventory = list(
    judgments = nrow(teaching),
    sentence_items = length(unique(teaching$item_id)),
    predicate_frame_pairs = length(unique(teaching$verb_frame_id)),
    verbs = length(unique(teaching$verb)),
    participants = length(unique(teaching$participant_id)),
    multiframe_verbs = nrow(fold_map)
  ),
  fold_definition = list(
    grouping_unit = "verb",
    eligibility = "at least two represented frames",
    folds = 5L,
    salt = "megaorientation-v1.1-multiframe-verb-folds-v1"
  ),
  derived = list(
    teaching_tsv = list(
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
  "Prepared", nrow(teaching), "MegaOrientation v1.1 judgments across",
  length(unique(teaching$verb_frame_id)), "predicate-frame pairs.\n"
)
