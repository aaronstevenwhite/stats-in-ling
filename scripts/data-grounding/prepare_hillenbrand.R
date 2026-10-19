#!/usr/bin/env Rscript
# Prepare the phonTools-complete Hillenbrand teaching table.

arguments <- commandArgs(trailingOnly = TRUE)
repository <- normalizePath(file.path(dirname(sub("^--file=", "", grep(
  "^--file=", commandArgs(trailingOnly = FALSE), value = TRUE
))), "..", ".."), mustWork = TRUE)
output_directory <- if (length(arguments) >= 1L) arguments[[1]] else file.path(
  repository, "data", "hillenbrand"
)

if (!requireNamespace("phonTools", quietly = TRUE)) {
  stop("Package 'phonTools' 0.2-2.2 is required for the complete teaching table.")
}
if (as.character(utils::packageVersion("phonTools")) != "0.2.2.2") {
  stop("The audited complete-table source is phonTools 0.2-2.2.")
}
utils::data("h95", package = "phonTools", envir = environment())
type_names <- c(b = "boy", g = "girl", m = "man", w = "woman")
complete <- data.frame(
  speaker_id = as.integer(h95$speaker),
  speaker_type = unname(type_names[as.character(h95$type)]),
  vowel = as.character(h95$vowel),
  duration_ms = as.integer(h95$dur),
  f0_hz = as.integer(h95$f0),
  f1_hz = as.integer(h95$f1),
  f2_hz = as.numeric(h95$f2),
  f3_hz = as.numeric(h95$f3),
  stringsAsFactors = FALSE
)
stopifnot(
  nrow(complete) == 1668L,
  length(unique(complete$speaker_id)) == 139L,
  identical(sort(unique(complete$speaker_id)), 1:139),
  all(table(complete$speaker_id) == 12L),
  !anyDuplicated(complete[c("speaker_id", "vowel")]),
  identical(sort(unique(complete$speaker_type)), c("boy", "girl", "man", "woman")),
  identical(sort(unique(complete$vowel)), sort(c(
    "i", "I", "e", "E", "{", "V", "A", "O", "o", "U", "u", "3'"
  ))),
  all(complete$duration_ms >= 111L & complete$duration_ms <= 486L),
  all(complete$f0_hz >= 90L & complete$f0_hz <= 330L),
  all(complete$f1_hz >= 305L & complete$f1_hz <= 1316L),
  all(complete$f2_hz >= 659 & complete$f2_hz <= 3451),
  all(complete$f3_hz >= 1487 & complete$f3_hz <= 4430),
  !anyNA(complete)
)

dir.create(output_directory, recursive = TRUE, showWarnings = FALSE)
utils::write.csv(complete, file.path(output_directory, "vowels-complete.csv"),
                 row.names = FALSE, na = "")
cat("Hillenbrand complete rows:", nrow(complete), "\n")

