#!/usr/bin/env Rscript
#' Prepare the Hillenbrand vowel table for Problem Set 1
#'
#' Loads `phonTools::h95`, gives the columns assignment-specific names, checks
#' the source dimensions and speaker-by-vowel structure, and writes a CSV.
#'
#' Usage from the repository root:
#'
#' Rscript problem-sets/ps1/scripts/prepare_data.R \
#'   problem-sets/ps1/data/hillenbrand_vowels.csv

script_directory <- function() {
  file_argument <- grep(
    "^--file=",
    commandArgs(trailingOnly = FALSE),
    value = TRUE
  )

  if (length(file_argument) == 0L) {
    return(normalizePath(getwd(), mustWork = TRUE))
  }

  dirname(normalizePath(
    sub("^--file=", "", file_argument[[1]]),
    mustWork = TRUE
  ))
}

prepare_hillenbrand_data <- function(output_path) {
  if (!requireNamespace("phonTools", quietly = TRUE)) {
    stop(
      "Package 'phonTools' is required. Install the frozen 0.2-2.2 release before running this script."
    )
  }

  if (as.character(utils::packageVersion("phonTools")) != "0.2.2.2") {
    warning(
      "The audited package version is 0.2.2.2. Found ",
      as.character(utils::packageVersion("phonTools")),
      ". Schema checks will still run."
    )
  }

  utils::data("h95", package = "phonTools", envir = environment())

  speaker_type <- c(
    b = "boy",
    g = "girl",
    m = "man",
    w = "woman"
  )

  vowels <- data.frame(
    speaker_id = as.integer(h95$speaker),
    speaker_type = unname(speaker_type[as.character(h95$type)]),
    vowel = as.character(h95$vowel),
    duration_ms = as.integer(h95$dur),
    f0_hz = as.integer(h95$f0),
    f1_hz = as.integer(h95$f1),
    f2_hz = as.numeric(h95$f2),
    f3_hz = as.numeric(h95$f3),
    stringsAsFactors = FALSE
  )

  stopifnot(
    nrow(vowels) == 1668L,
    length(unique(vowels$speaker_id)) == 139L,
    all(table(vowels$speaker_id) == 12L),
    sum(vowels$vowel == "i") == 139L,
    sum(vowels$vowel == "I") == 139L,
    !anyDuplicated(vowels[c("speaker_id", "vowel")]),
    !anyNA(vowels[c("speaker_id", "speaker_type", "vowel", "f1_hz")])
  )

  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(vowels, output_path, row.names = FALSE)

  cat("Hillenbrand rows:", nrow(vowels), "\n")
  cat("Hillenbrand speakers:", length(unique(vowels$speaker_id)), "\n")
  cat("Wrote:", normalizePath(output_path, mustWork = TRUE), "\n")

  invisible(vowels)
}

main <- function(arguments = commandArgs(trailingOnly = TRUE)) {
  default_output <- file.path(
    dirname(script_directory()),
    "data",
    "hillenbrand_vowels.csv"
  )
  output_path <- if (length(arguments) >= 1L) arguments[[1]] else default_output

  prepare_hillenbrand_data(output_path)
}

if (sys.nframe() == 0L) {
  main()
}
