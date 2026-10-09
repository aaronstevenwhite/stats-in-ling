#!/usr/bin/env Rscript
#' Prepare the Provo content-word table for Problem Set 2
#'
#' Filters the raw eye-tracking release to complete content-word observations,
#' verifies that source predictors are constant within word position, and
#' aggregates positive first-fixation durations by position.
#'
#' Usage from the repository root:
#'
#' Rscript problem-sets/ps2/scripts/prepare_data.R \
#'   /path/to/Provo_Corpus-Eyetracking_Data.csv \
#'   problem-sets/ps2/data/provo-content-word-positions.csv

prepare_provo_data <- function(input_path, output_path) {
  if (!file.exists(input_path)) {
    stop("Provo input file does not exist: ", input_path)
  }

  raw <- utils::read.csv(
    input_path,
    na.strings = c("NA", "."),
    check.names = FALSE,
    stringsAsFactors = FALSE
  )

  required <- c(
    "Word_Unique_ID",
    "Text_ID",
    "Word_Number",
    "Word_Length",
    "Word_POS",
    "Word_In_Sentence_Number",
    "OrthoMatchModel",
    "POSMatchModel",
    "LSA_Response_Match_Score",
    "IA_FIRST_FIXATION_DURATION",
    "Word_Content_Or_Function"
  )

  if (!all(required %in% names(raw))) {
    stop("The Provo release is missing one or more required columns.")
  }

  trials <- raw[
    stats::complete.cases(raw[required]) &
      raw$IA_FIRST_FIXATION_DURATION > 0 &
      raw$Word_Content_Or_Function == "Content",
    required
  ]

  # The release reuses QID2687 in Texts 18 and 55, despite documenting
  # Word_Unique_ID as unique. Text_ID plus Word_Number is the stable position key.
  trials$position_id <- paste(trials$Text_ID, trials$Word_Number, sep = "-")

  item_predictors <- setdiff(
    required,
    c(
      "IA_FIRST_FIXATION_DURATION",
      "Word_Content_Or_Function",
      "position_id"
    )
  )

  for (variable in item_predictors) {
    n_values <- tapply(
      trials[[variable]],
      trials$position_id,
      function(x) length(unique(x))
    )
    if (any(n_values != 1L)) {
      stop(variable, " varies within a word-position identifier.")
    }
  }

  items <- trials[
    !duplicated(trials$position_id),
    c("position_id", item_predictors)
  ]

  mean_log_ffd <- stats::aggregate(
    log(trials$IA_FIRST_FIXATION_DURATION),
    list(position_id = trials$position_id),
    mean
  )
  names(mean_log_ffd)[2] <- "mean_log_ffd"

  n_fixations <- stats::aggregate(
    trials$IA_FIRST_FIXATION_DURATION,
    list(position_id = trials$position_id),
    length
  )
  names(n_fixations)[2] <- "n_fixations"

  items <- merge(items, mean_log_ffd, by = "position_id", sort = FALSE)
  items <- merge(items, n_fixations, by = "position_id", sort = FALSE)
  items <- items[order(items$Text_ID, items$Word_Number), ]
  rownames(items) <- NULL

  stopifnot(
    nrow(items) == 1593L,
    length(unique(items$Text_ID)) == 55L,
    !anyDuplicated(items$position_id),
    length(unique(items$Word_Unique_ID)) == 1592L,
    all(items$OrthoMatchModel > 0),
    all(items$POSMatchModel > 0),
    all(is.finite(items$mean_log_ffd))
  )

  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(items, output_path, row.names = FALSE)

  cat("Provo content-word positions:", nrow(items), "\n")
  cat("Provo passages:", length(unique(items$Text_ID)), "\n")
  cat("Wrote:", normalizePath(output_path, mustWork = TRUE), "\n")

  invisible(items)
}

main <- function(arguments = commandArgs(trailingOnly = TRUE)) {
  if (length(arguments) != 2L) {
    stop(
      "Usage: Rscript prepare_data.R ",
      "<Provo_Corpus-Eyetracking_Data.csv> <output.csv>"
    )
  }

  prepare_provo_data(arguments[[1]], arguments[[2]])
}

if (!interactive()) {
  main()
}
