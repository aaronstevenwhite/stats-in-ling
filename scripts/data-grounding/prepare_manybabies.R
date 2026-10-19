#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

output_dir <- script_argument(1, "data/manybabies")
commit <- "dc3eb5b3578057096d337203635c0759d2fc04b6"
base_url <- paste0(
  "https://raw.githubusercontent.com/manybabies/mb1-analysis-public/",
  commit,
  "/"
)
sources <- list(
  trials = list(
    path = "processed_data/03_data_trial_main.csv",
    sha256 = "a4eb8e27ae40833172009e5e681aba3f07eb3cf56d78fddd373d9ee9510110e4"
  ),
  dictionary = list(
    path = "metadata/Variable_Dictionary_mb1.csv",
    sha256 = "8fdcb82f4dccd877095fd3f50a1f12987432eb5ee5b643a581115aa5b532a9b3"
  ),
  readme = list(
    path = "README.md",
    sha256 = "c0c56675cf691c586269e5166b7b9a85d45c6705a600a47631c16daeddde1074"
  ),
  license = list(
    path = "LICENSE",
    sha256 = "aedf2ccfe00a21fbf2ad74dcb1df9777f30fba395e7108a738754d2bcabcfe2b"
  )
)

local <- lapply(sources, function(source) {
  path <- tempfile(fileext = paste0("-", basename(source$path)))
  utils::download.file(paste0(base_url, source$path), path, mode = "wb")
  assert_sha256(path, source$sha256)
  path
})
on.exit(unlink(unlist(local)), add = TRUE)

raw <- utils::read.csv(
  local$trials,
  stringsAsFactors = FALSE,
  check.names = FALSE,
  na.strings = c("NA", "")
)
required <- c(
  "lab", "subid", "subid_unique", "trial_order", "trial_num",
  "trial_type", "stimulus_num", "method", "age_days", "age_mo",
  "age_group", "nae", "gender", "second_session", "looking_time",
  "missing"
)
assert_columns(raw, required, exact = TRUE)
stopifnot(
  identical(dim(raw), c(37264L, 16L)),
  length(unique(raw$lab)) == 67L,
  setequal(unique(raw$trial_num), 1:16),
  setequal(stats::na.omit(unique(raw$trial_type)), c("ADS", "IDS")),
  setequal(unique(raw$method), c("eyetracking", "hpp", "singlescreen")),
  sum(raw$missing) == 10369L,
  sum(is.na(raw$trial_type)) == 4383L,
  sum(is.na(raw$looking_time)) == 10369L
)

# The released exclusion script completes each participant to eight possible
# trials. Those added rows retain `lab` and `subid` but not `subid_unique`.
# Reconstructing the documented lab-qualified identifier preserves those rows.
participant_id <- paste(raw$lab, raw$subid, sep = ":")
observed_id <- !is.na(raw$subid_unique)
stopifnot(identical(participant_id[observed_id], raw$subid_unique[observed_id]))

fill_participant_value <- function(value, participant) {
  split_value <- split(value, participant)
  lookup <- vapply(split_value, function(current) {
    observed <- unique(current[!is.na(current)])
    if (length(observed) > 1L) {
      stop("A participant has inconsistent participant-level values.")
    }
    if (length(observed)) as.character(observed[[1]]) else NA_character_
  }, character(1))
  unname(lookup[participant])
}

second_session <- fill_participant_value(raw$second_session, participant_id)
second_session <- second_session == "TRUE"

teaching <- data.frame(
  lab_id = raw$lab,
  infant_id = participant_id,
  counterbalance_order = as.integer(raw$trial_order),
  trial_number = as.integer(raw$trial_num),
  register = raw$trial_type,
  stimulus_id = as.integer(raw$stimulus_num),
  method = raw$method,
  age_days = as.integer(raw$age_days),
  age_months = as.numeric(raw$age_mo),
  age_group = raw$age_group,
  north_american_english = as.logical(raw$nae),
  gender = raw$gender,
  second_session = second_session,
  looking_time_seconds = as.numeric(raw$looking_time),
  trial_missing = as.logical(raw$missing),
  trial_metadata_observed = !is.na(raw$trial_type),
  stringsAsFactors = FALSE
)
teaching <- teaching[
  order(teaching$lab_id, teaching$infant_id, teaching$trial_number),
]
row.names(teaching) <- NULL

stopifnot(
  nrow(teaching) == 37264L,
  length(unique(teaching$infant_id)) == 2329L,
  length(unique(teaching$lab_id)) == 67L,
  sum(teaching$trial_missing) == 10369L,
  sum(!teaching$trial_metadata_observed) == 4383L,
  all(is.na(teaching$looking_time_seconds) == teaching$trial_missing),
  !anyNA(teaching$second_session)
)

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
output_path <- file.path(output_dir, "manybabies1-trials.rds")
saveRDS(teaching, output_path, version = 3, compress = "xz")
license_output <- file.path(output_dir, "LICENSE-MIT.txt")
if (!file.copy(local$license, license_output, overwrite = TRUE)) {
  stop("Could not preserve the ManyBabies repository license.")
}

write_json_stable(
  list(
    title = "ManyBabies 1 infant-directed speech preference trials",
    citation = paste(
      "The ManyBabies Consortium (2020), Advances in Methods and",
      "Practices in Psychological Science 3:24-52,",
      "doi:10.1177/2515245919900809"
    ),
    source = "https://github.com/manybabies/mb1-analysis-public",
    source_commit = commit,
    license = paste(
      "MIT repository license; the repository README explicitly states that",
      "the data and code are licensed for reuse"
    ),
    source_files = lapply(names(sources), function(name) {
      list(name = name, path = sources[[name]]$path, sha256 = sources[[name]]$sha256)
    }),
    adaptation = paste(
      "Renamed fields; reconstructed lab-qualified infant IDs for completed",
      "trial rows; filled the participant-level second-session indicator;",
      "retained all released main-analysis rows and natural missingness"
    ),
    rows = nrow(teaching),
    infants = length(unique(teaching$infant_id)),
    labs = length(unique(teaching$lab_id)),
    missing_trials = sum(teaching$trial_missing),
    completed_rows_without_trial_metadata = sum(!teaching$trial_metadata_observed),
    output_sha256 = sha256_file(output_path)
  ),
  file.path(output_dir, "provenance.json")
)

cat(
  "Prepared", nrow(teaching), "ManyBabies 1 rows for",
  length(unique(teaching$infant_id)), "infants in",
  length(unique(teaching$lab_id)), "labs.\n"
)
