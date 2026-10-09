#!/usr/bin/env Rscript
#' Prepare the German UniMorph teaching tables for Problem Set 1
#'
#' Reduces the form-level extracts to one row per lexeme, validates the derived
#' variables, and draws the fixed 120-lexeme genitive sample.
#'
#' Usage from the repository root:
#'
#' Rscript problem-sets/ps1/scripts/prepare_unimorph_tables.R

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

resolve_source_directory <- function(requested_directory = NULL) {
  assignment_directory <- dirname(script_directory())
  source_files <- c("unimorph_genitive.csv", "unimorph_plural.csv")

  candidates <- if (is.null(requested_directory)) {
    c(
      file.path(assignment_directory, "data"),
      file.path(dirname(assignment_directory), "ps1-2", "data")
    )
  } else {
    requested_directory
  }

  for (candidate in candidates) {
    if (all(file.exists(file.path(candidate, source_files)))) {
      return(candidate)
    }
  }

  stop(
    "Could not find unimorph_genitive.csv and unimorph_plural.csv. ",
    "Run fetch_unimorph_data.py first."
  )
}

collapse_genitive_lexemes <- function(genitive_forms) {
  genitive_by_lemma <- split(genitive_forms, genitive_forms$lemma)

  genitive_lexemes <- do.call(
    rbind,
    lapply(genitive_by_lemma, function(lemma_rows) {
      stopifnot(length(unique(lemma_rows$gender)) == 1L)
      stopifnot(length(unique(lemma_rows$syllable_count)) == 1L)
      stopifnot(length(unique(lemma_rows$syllable_class)) == 1L)
      stopifnot(length(unique(lemma_rows$ends_in_sibilant)) == 1L)

      data.frame(
        lemma = lemma_rows$lemma[[1]],
        gender = lemma_rows$gender[[1]],
        syllable_count = lemma_rows$syllable_count[[1]],
        syllable_class = lemma_rows$syllable_class[[1]],
        ends_in_sibilant = lemma_rows$ends_in_sibilant[[1]],
        es_attested = any(lemma_rows$suffix == "es"),
        s_attested = any(lemma_rows$suffix == "s"),
        stringsAsFactors = FALSE
      )
    })
  )

  rownames(genitive_lexemes) <- NULL
  genitive_lexemes[order(genitive_lexemes$lemma), ]
}

prepare_unimorph_tables <- function(
    source_directory,
    output_directory,
    sample_size = 120L,
    seed = 414L) {
  genitive_forms <- utils::read.csv(
    file.path(source_directory, "unimorph_genitive.csv"),
    stringsAsFactors = FALSE
  )
  plural_lexemes <- utils::read.csv(
    file.path(source_directory, "unimorph_plural.csv"),
    stringsAsFactors = FALSE
  )

  required_genitive_columns <- c(
    "lemma", "gender", "suffix", "syllable_count", "syllable_class",
    "ends_in_sibilant"
  )
  required_plural_columns <- c(
    "lemma", "gender", "singular_form", "plural_form", "plural_suffix",
    "syllable_count"
  )

  stopifnot(all(required_genitive_columns %in% names(genitive_forms)))
  stopifnot(all(required_plural_columns %in% names(plural_lexemes)))
  stopifnot(all(genitive_forms$suffix %in% c("s", "es")))
  stopifnot(!anyDuplicated(plural_lexemes$lemma))

  genitive_lexemes <- collapse_genitive_lexemes(genitive_forms)
  plural_lexemes <- plural_lexemes[order(plural_lexemes$lemma), ]

  stopifnot(!anyDuplicated(genitive_lexemes$lemma))
  stopifnot(nrow(genitive_lexemes) == length(unique(genitive_forms$lemma)))
  stopifnot(all(plural_lexemes$gender %in% c("FEM", "MASC", "NEUT")))
  stopifnot(all(plural_lexemes$plural_suffix %in% c("e", "en", "er", "s", "ø")))
  stopifnot(sample_size <= nrow(genitive_lexemes))

  set.seed(seed)
  sample_rows <- sample.int(
    nrow(genitive_lexemes),
    size = sample_size,
    replace = FALSE
  )
  genitive_sample <- genitive_lexemes[sample_rows, , drop = FALSE]
  genitive_sample <- genitive_sample[order(genitive_sample$lemma), ]
  rownames(genitive_sample) <- NULL

  stopifnot(!anyDuplicated(genitive_sample$lemma))
  stopifnot(nrow(genitive_sample) == sample_size)

  dir.create(output_directory, recursive = TRUE, showWarnings = FALSE)
  utils::write.csv(
    genitive_sample,
    file.path(output_directory, "unimorph_genitive_lexemes.csv"),
    row.names = FALSE
  )
  utils::write.csv(
    genitive_lexemes,
    file.path(output_directory, "unimorph_genitive_lexeme_population.csv"),
    row.names = FALSE
  )
  utils::write.csv(
    plural_lexemes,
    file.path(output_directory, "unimorph_plural_lexemes.csv"),
    row.names = FALSE
  )

  cat("Genitive lexemes in source table:", nrow(genitive_lexemes), "\n")
  cat("Genitive lexemes in teaching sample:", nrow(genitive_sample), "\n")
  cat("Plural lexemes:", nrow(plural_lexemes), "\n")
  cat("Wrote tables to:", normalizePath(output_directory), "\n")

  invisible(list(
    genitive_sample = genitive_sample,
    genitive_population = genitive_lexemes,
    plural_lexemes = plural_lexemes
  ))
}

main <- function(arguments = commandArgs(trailingOnly = TRUE)) {
  assignment_directory <- dirname(script_directory())
  requested_source <- if (length(arguments) >= 1L) arguments[[1]] else NULL
  output_directory <- if (length(arguments) >= 2L) {
    arguments[[2]]
  } else {
    file.path(assignment_directory, "data")
  }

  source_directory <- resolve_source_directory(requested_source)
  prepare_unimorph_tables(source_directory, output_directory)
}

if (!interactive()) {
  main()
}
