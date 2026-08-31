args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2L) {
  stop(
    "Usage: Rscript prepare_data.R /path/to/languageR_1.5.0.tar.gz output.csv"
  )
}

archive_path <- normalizePath(args[[1]], mustWork = TRUE)
output_path <- args[[2]]
unpack_dir <- tempfile("languageR-")
dir.create(unpack_dir)
on.exit(unlink(unpack_dir, recursive = TRUE), add = TRUE)

utils::untar(archive_path, files = "languageR/data/dative.rda", exdir = unpack_dir)
load(file.path(unpack_dir, "languageR", "data", "dative.rda"))

stopifnot(
  nrow(dative) == 3263L,
  ncol(dative) == 15L,
  sum(is.na(dative$Speaker)) == 903L,
  identical(levels(dative$RealizationOfRecipient), c("NP", "PP")),
  !anyNA(dative[setdiff(names(dative), "Speaker")])
)

items <- data.frame(
  speaker_id = as.character(dative$Speaker),
  modality = as.character(dative$Modality),
  verb = as.character(dative$Verb),
  semantic_class = as.character(dative$SemanticClass),
  recipient_length_words = as.integer(dative$LengthOfRecipient),
  recipient_animacy = as.character(dative$AnimacyOfRec),
  recipient_definiteness = as.character(dative$DefinOfRec),
  recipient_pronominality = as.character(dative$PronomOfRec),
  theme_length_words = as.integer(dative$LengthOfTheme),
  theme_animacy = as.character(dative$AnimacyOfTheme),
  theme_definiteness = as.character(dative$DefinOfTheme),
  theme_pronominality = as.character(dative$PronomOfTheme),
  recipient_realization = as.character(dative$RealizationOfRecipient),
  recipient_accessibility = as.character(dative$AccessOfRec),
  theme_accessibility = as.character(dative$AccessOfTheme),
  stringsAsFactors = FALSE
)

stopifnot(
  nrow(items) == 3263L,
  length(unique(items$verb)) == 75L,
  sum(items$recipient_realization == "PP") == 849L,
  all(items$recipient_length_words >= 1L),
  all(items$theme_length_words >= 1L)
)

utils::write.csv(items, output_path, row.names = FALSE, na = "")
cat("Wrote", nrow(items), "rows to", output_path, "\n")

