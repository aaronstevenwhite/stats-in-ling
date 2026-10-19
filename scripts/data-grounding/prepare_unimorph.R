#!/usr/bin/env Rscript
# Prepare the pinned German UniMorph lexeme populations and fixed sample.

arguments <- commandArgs(trailingOnly = TRUE)
repository <- normalizePath(file.path(dirname(sub("^--file=", "", grep(
  "^--file=", commandArgs(trailingOnly = FALSE), value = TRUE
))), "..", ".."), mustWork = TRUE)
source_directory <- if (length(arguments) >= 1L) arguments[[1]] else
  file.path(repository, "problem-sets", "ps1", "data")
output_directory <- if (length(arguments) >= 2L) arguments[[2]] else
  file.path(repository, "data", "unimorph-german")

read_table <- function(filename) {
  utils::read.csv(file.path(source_directory, filename), stringsAsFactors = FALSE)
}

genitive <- read_table("unimorph_genitive_lexeme_population.csv")
sample <- read_table("unimorph_genitive_lexemes.csv")
plural <- read_table("unimorph_plural_lexemes.csv")

stopifnot(
  identical(names(genitive), c(
    "lemma", "gender", "syllable_count", "syllable_class",
    "ends_in_sibilant", "es_attested", "s_attested"
  )),
  identical(names(sample), names(genitive)),
  identical(names(plural), c(
    "lemma", "gender", "singular_form", "plural_form", "plural_suffix",
    "syllable_count"
  )),
  nrow(genitive) == 16719L,
  nrow(sample) == 120L,
  nrow(plural) == 13297L,
  !anyDuplicated(genitive$lemma),
  !anyDuplicated(sample$lemma),
  !anyDuplicated(plural$lemma),
  all(sample$lemma %in% genitive$lemma),
  all(sample$gender == genitive$gender[match(sample$lemma, genitive$lemma)]),
  all(genitive$gender %in% c("MASC", "NEUT")),
  all(plural$gender %in% c("FEM", "MASC", "NEUT")),
  all(plural$plural_suffix %in% c("e", "en", "er", "s", "ø")),
  all(genitive$syllable_count >= 0L & genitive$syllable_count <= 11L),
  all(plural$syllable_count >= 0L & plural$syllable_count <= 13L),
  sum(genitive$syllable_count == 0L) == 274L,
  sum(plural$syllable_count == 0L) == 221L,
  !anyNA(genitive),
  !anyNA(sample),
  !anyNA(plural)
)

dir.create(output_directory, recursive = TRUE, showWarnings = FALSE)
utils::write.csv(genitive, file.path(output_directory, "genitive-population.csv"),
                 row.names = FALSE, na = "")
utils::write.csv(sample, file.path(output_directory, "genitive-sample-120.csv"),
                 row.names = FALSE, na = "")
utils::write.csv(plural, file.path(output_directory, "plural-lexemes.csv"),
                 row.names = FALSE, na = "")

cat("German genitive population:", nrow(genitive), "lexemes\n")
cat("German fixed sample:", nrow(sample), "lexemes\n")
cat("German plural table:", nrow(plural), "lexemes\n")

