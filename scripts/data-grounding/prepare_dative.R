#!/usr/bin/env Rscript
# Validate and copy the languageR dative-alternation teaching table.

arguments <- commandArgs(trailingOnly = TRUE)
repository <- normalizePath(file.path(dirname(sub("^--file=", "", grep(
  "^--file=", commandArgs(trailingOnly = FALSE), value = TRUE
))), "..", ".."), mustWork = TRUE)
input <- if (length(arguments) >= 1L) arguments[[1]] else file.path(
  repository, "problem-sets", "ps3", "data", "dative-alternation.csv"
)
output <- if (length(arguments) >= 2L) arguments[[2]] else file.path(
  repository, "data", "english-dative", "dative-alternation.csv"
)

items <- utils::read.csv(input, stringsAsFactors = FALSE, na.strings = c("", "NA"))
required <- c(
  "speaker_id", "modality", "verb", "semantic_class",
  "recipient_length_words", "recipient_animacy", "recipient_definiteness",
  "recipient_pronominality", "theme_length_words", "theme_animacy",
  "theme_definiteness", "theme_pronominality", "recipient_realization",
  "recipient_accessibility", "theme_accessibility"
)
stopifnot(
  identical(names(items), required),
  nrow(items) == 3263L,
  length(unique(items$verb)) == 75L,
  sum(items$recipient_realization == "PP") == 849L,
  identical(sort(unique(items$modality)), c("spoken", "written")),
  all(items$recipient_length_words >= 1L & items$recipient_length_words <= 31L),
  all(items$theme_length_words >= 1L & items$theme_length_words <= 46L),
  sum(is.na(items$speaker_id)) == 903L,
  all(is.na(items$speaker_id) == (items$modality == "written")),
  !anyNA(items[setdiff(names(items), "speaker_id")])
)

dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
utils::write.csv(items, output, row.names = FALSE, na = "")
cat("Dative tokens:", nrow(items), "\n")
cat("Structurally absent speaker IDs:", sum(is.na(items$speaker_id)), "\n")
cat("Wrote:", normalizePath(output, mustWork = TRUE), "\n")

