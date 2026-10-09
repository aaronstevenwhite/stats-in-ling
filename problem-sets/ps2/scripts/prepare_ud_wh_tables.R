#!/usr/bin/env Rscript
#' Prepare the UD English EWT teaching table for Problem Set 2
#'
#' Selects `what`, `which`, and `who` tokens annotated as `nsubj` or `obj`,
#' retains sentences with exactly one selected token, and writes the six-column
#' table used in the assignment.
#'
#' Usage from the repository root:
#'
#' Rscript problem-sets/ps2/scripts/prepare_ud_wh_tables.R

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

resolve_source_path <- function(requested_path = NULL) {
  assignment_directory <- dirname(script_directory())
  candidates <- if (is.null(requested_path)) {
    c(
      file.path(assignment_directory, "data", "ud_wh_dependencies_raw.csv"),
      file.path(
        dirname(assignment_directory),
        "ps1-2",
        "data",
        "wh_filler_gap.csv"
      )
    )
  } else {
    requested_path
  }

  existing <- candidates[file.exists(candidates)]
  if (length(existing) == 0L) {
    stop(
      "Could not find the raw UD dependency table. ",
      "Run fetch_wh_data.py first."
    )
  }

  existing[[1]]
}

prepare_ud_wh_table <- function(source_path, output_path) {
  wh_dependencies <- utils::read.csv(
    source_path,
    stringsAsFactors = FALSE
  )

  required_columns <- c(
    "sentence_id",
    "sentence_text",
    "wh_word",
    "wh_lemma",
    "wh_pos",
    "deprel"
  )
  stopifnot(all(required_columns %in% names(wh_dependencies)))

  target_rows <- wh_dependencies[
    tolower(wh_dependencies$wh_word) %in% c("what", "which", "who") &
      wh_dependencies$deprel %in% c("nsubj", "obj"),
    required_columns
  ]

  sentence_counts <- table(target_rows$sentence_id)
  single_dependency_sentences <- names(sentence_counts[sentence_counts == 1L])

  teaching_table <- target_rows[
    as.character(target_rows$sentence_id) %in% single_dependency_sentences,
  ]

  teaching_table$wh_word <- tolower(teaching_table$wh_word)
  teaching_table <- teaching_table[order(teaching_table$sentence_id), ]
  rownames(teaching_table) <- NULL

  stopifnot(!anyDuplicated(teaching_table$sentence_id))
  stopifnot(nrow(teaching_table) == 671L)
  stopifnot(all(teaching_table$wh_word %in% c("what", "which", "who")))
  stopifnot(all(teaching_table$deprel %in% c("nsubj", "obj")))

  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(teaching_table, output_path, row.names = FALSE)

  cat("UD sentences:", nrow(teaching_table), "\n")
  print(with(teaching_table, table(wh_word, deprel)))
  cat("Wrote:", normalizePath(output_path, mustWork = TRUE), "\n")

  invisible(teaching_table)
}

main <- function(arguments = commandArgs(trailingOnly = TRUE)) {
  assignment_directory <- dirname(script_directory())
  requested_source <- if (length(arguments) >= 1L) arguments[[1]] else NULL
  output_path <- if (length(arguments) >= 2L) {
    arguments[[2]]
  } else {
    file.path(assignment_directory, "data", "ud_wh_dependencies.csv")
  }

  source_path <- resolve_source_path(requested_source)
  prepare_ud_wh_table(source_path, output_path)
}

if (!interactive()) {
  main()
}
