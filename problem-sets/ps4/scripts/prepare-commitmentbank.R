#!/usr/bin/env Rscript

source_url <- paste0(
  "https://raw.githubusercontent.com/mcdm/CommitmentBank/",
  "master/CommitmentBank-All.csv"
)
expected_sha256 <-
  "34a368dfdd87f4ea75638e34ecd9df0297577e238748a36280a9b047632bb769"

args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
script_path <- if (length(file_arg)) {
  sub("^--file=", "", file_arg[[1]])
} else {
  "problem-sets/ps4/scripts/prepare-commitmentbank.R"
}
ps4_dir <- normalizePath(file.path(dirname(script_path), ".."), mustWork = TRUE)
data_dir <- file.path(ps4_dir, "data")
dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)

raw_path <- file.path(data_dir, "CommitmentBank-All.csv")
model_path <- file.path(data_dir, "commitmentbank-model.csv")
provided_raw <- Sys.getenv("COMMITMENTBANK_RAW", unset = "")

if (nzchar(provided_raw)) {
  if (!file.exists(provided_raw)) {
    stop("COMMITMENTBANK_RAW does not name an existing file.")
  }
  file.copy(provided_raw, raw_path, overwrite = TRUE)
} else if (!file.exists(raw_path)) {
  download.file(source_url, raw_path, mode = "wb", quiet = FALSE)
}

if (!requireNamespace("digest", quietly = TRUE)) {
  stop("Install the digest package before preparing the data.")
}

observed_sha256 <- digest::digest(raw_path, algo = "sha256", file = TRUE)
if (!identical(observed_sha256, expected_sha256)) {
  stop(
    paste0(
      "The source checksum has changed. Expected ", expected_sha256,
      " but found ", observed_sha256, "."
    )
  )
}

raw <- read.csv(
  raw_path,
  stringsAsFactors = FALSE,
  na.strings = "",
  check.names = FALSE
)

stopifnot(
  nrow(raw) == 11545L,
  length(unique(raw$uID)) == 1200L,
  length(unique(raw$WorkerID)) == 496L,
  setequal(unique(raw$Answer), -3:3)
)

model_data <- data.frame(
  discourse = raw$uID,
  annotator = raw$WorkerID,
  predicate = raw$Verb,
  rating = as.integer(raw$Answer),
  embedding = raw$Embedding,
  modal_type = ifelse(is.na(raw$ModalType), "none", raw$ModalType),
  factive = raw$factive,
  genre = raw$genre,
  stringsAsFactors = FALSE
)

write.csv(model_data, model_path, row.names = FALSE, na = "")

cat("Prepared", nrow(model_data), "ratings in", model_path, "\n")
cat("The prepared table omits Context, Target, and Prompt text.\n")

