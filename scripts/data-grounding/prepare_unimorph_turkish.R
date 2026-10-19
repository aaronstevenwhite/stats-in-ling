#!/usr/bin/env Rscript
# Prepare a paper-audited finite verb population from pinned Turkish UniMorph.

arguments <- commandArgs(trailingOnly = TRUE)
repository <- normalizePath(file.path(dirname(sub("^--file=", "", grep(
  "^--file=", commandArgs(trailingOnly = FALSE), value = TRUE
))), "..", ".."), mustWork = TRUE)
source <- if (length(arguments) >= 1L) arguments[[1]] else ""
output_directory <- if (length(arguments) >= 2L) arguments[[2]] else
  file.path(repository, "data", "unimorph-turkish")

commit <- "6c179ace7d2f3d7f3484020e5304c1544d07bb6b"
source_url <- paste0(
  "https://raw.githubusercontent.com/unimorph/tur/", commit, "/tur"
)
source_sha256 <-
  "4ae44f4b039c344f7078d8073b968b0d67133d1e9d7e653ce8aba5ed24387957"
temporary <- FALSE
if (!nzchar(source)) {
  source <- tempfile(fileext = ".tsv")
  temporary <- TRUE
  utils::download.file(source_url, source, mode = "wb", quiet = TRUE)
}
on.exit(if (temporary && file.exists(source)) unlink(source), add = TRUE)

sha256 <- function(path) {
  output <- system2("shasum", c("-a", "256", path), stdout = TRUE)
  strsplit(output, "[[:space:]]+")[[1]][[1]]
}
stopifnot(identical(sha256(source), source_sha256))

raw <- utils::read.delim(
  source,
  header = FALSE,
  sep = "\t",
  quote = "",
  comment.char = "",
  col.names = c("lemma", "form", "feature_bundle"),
  colClasses = "character",
  fileEncoding = "UTF-8"
)
target_bundle <- "V;IND;PST;3;SG;POS;DECL"
population <- raw[raw$feature_bundle == target_bundle, , drop = FALSE]

stopifnot(
  nrow(raw) == 570420L,
  nrow(population) == 588L,
  !anyDuplicated(population$lemma),
  all(endsWith(population$lemma, "mak") | endsWith(population$lemma, "mek")),
  !anyNA(population)
)

population$stem <- substr(population$lemma, 1L, nchar(population$lemma) - 3L)
population$stem_final <- substring(
  population$stem, nchar(population$stem), nchar(population$stem)
)
voiceless <- c("ç", "f", "h", "k", "p", "s", "ş", "t")
population$stem_final_voiceless <- as.integer(population$stem_final %in% voiceless)

last_vowel <- function(stem) {
  characters <- strsplit(stem, "", fixed = TRUE)[[1]]
  vowels <- characters[characters %in% c("a", "e", "ı", "i", "o", "ö", "u", "ü")]
  if (length(vowels)) vowels[[length(vowels)]] else NA_character_
}
population$stem_last_vowel <- vapply(population$stem, last_vowel, character(1))
population$vowel_class <- ifelse(
  population$stem_last_vowel %in% c("a", "ı"), "back_unrounded",
  ifelse(
    population$stem_last_vowel %in% c("o", "u"), "back_rounded",
    ifelse(
      population$stem_last_vowel %in% c("e", "i"), "front_unrounded",
      "front_rounded"
    )
  )
)
population$past_suffix <- substring(
  population$form, nchar(population$form) - 1L, nchar(population$form)
)
population$past_initial <- substring(population$past_suffix, 1L, 1L)
population$past_vowel <- substring(population$past_suffix, 2L, 2L)
population$t_initial <- as.integer(population$past_initial == "t")
expected_suffix_counts <- c(
  "dı" = 159L, "di" = 128L, "du" = 59L, "dü" = 42L,
  "tı" = 88L, "ti" = 66L, "tu" = 19L, "tü" = 27L
)
observed_suffix_counts <- table(population$past_suffix)

stopifnot(
  !anyNA(population),
  setequal(names(observed_suffix_counts), names(expected_suffix_counts)),
  all(observed_suffix_counts[names(expected_suffix_counts)] == expected_suffix_counts),
  sum(population$t_initial) == 200L,
  all(population$stem_final_voiceless == population$t_initial),
  all(population$past_vowel[
    population$stem_last_vowel %in% c("a", "ı")
  ] == "ı"),
  all(population$past_vowel[
    population$stem_last_vowel %in% c("e", "i")
  ] == "i"),
  all(population$past_vowel[
    population$stem_last_vowel %in% c("o", "u")
  ] == "u"),
  all(population$past_vowel[
    population$stem_last_vowel %in% c("ö", "ü")
  ] == "ü")
)

RNGkind("Mersenne-Twister", "Inversion", "Rejection")
set.seed(414)
sample_indices <- sort(sample(seq_len(nrow(population)), 120L, replace = FALSE))
sample <- population[sample_indices, , drop = FALSE]
stopifnot(
  nrow(sample) == 120L,
  !anyDuplicated(sample$lemma),
  all(sample$lemma %in% population$lemma),
  all(sample$t_initial %in% c(0L, 1L))
)

dir.create(output_directory, recursive = TRUE, showWarnings = FALSE)
utils::write.csv(
  population,
  file.path(output_directory, "verb-past-population.csv"),
  row.names = FALSE,
  na = "",
  fileEncoding = "UTF-8"
)
utils::write.csv(
  sample,
  file.path(output_directory, "verb-past-sample-120.csv"),
  row.names = FALSE,
  na = "",
  fileEncoding = "UTF-8"
)

cat("Turkish past-tense verb population:", nrow(population), "lexemes\n")
cat("Turkish fixed sample:", nrow(sample), "lexemes\n")
cat("Past suffix counts:\n")
print(table(population$past_suffix))
