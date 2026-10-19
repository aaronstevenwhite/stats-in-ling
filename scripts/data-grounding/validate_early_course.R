#!/usr/bin/env Rscript
# Offline integration checks for all canonical early-course teaching inputs.

repository <- normalizePath(file.path(dirname(sub("^--file=", "", grep(
  "^--file=", commandArgs(trailingOnly = FALSE), value = TRUE
))), "..", ".."), mustWork = TRUE)

read_data <- function(...) {
  utils::read.csv(file.path(repository, "data", ...), stringsAsFactors = FALSE,
                  na.strings = c("", "NA"), check.names = FALSE)
}

assert_sha256 <- function(relative_path, expected) {
  path <- file.path(repository, relative_path)
  output <- system2("shasum", c("-a", "256", path), stdout = TRUE)
  observed <- strsplit(output, "[[:space:]]+")[[1]][[1]]
  stopifnot(identical(observed, expected))
}

wh <- read_data("ud-ewt", "ud-ewt-wh.csv")
pronouns <- read_data("ud-ewt", "ud-ewt-pronouns.csv")
tr_questions <- read_data("ud-turkish-boun", "question-core-arguments.csv")
tr_pronouns <- read_data("ud-turkish-boun", "personal-pronoun-cases.csv")
cmu <- read_data("cmudict", "cmudict-pronunciations.csv")
tr_verbs <- read_data("unimorph-turkish", "verb-past-population.csv")
tr_verb_sample <- read_data("unimorph-turkish", "verb-past-sample-120.csv")
de_genitive <- read_data("unimorph-german", "genitive-population.csv")
de_sample <- read_data("unimorph-german", "genitive-sample-120.csv")
de_plural <- read_data("unimorph-german", "plural-lexemes.csv")
dative <- read_data("english-dative", "dative-alternation.csv")
provo_positions <- read_data("provo", "content-word-positions.csv")
provo_passages <- read_data("provo", "passage-summaries.csv")
h95 <- read_data("hillenbrand", "vowels-complete.csv")

stopifnot(
  nrow(wh) == 671L,
  all(c("what", "which", "who") %in% wh$wh_form),
  nrow(pronouns) > 10000L,
  identical(sort(unique(pronouns$case)), c("Acc", "Gen", "Nom")),
  nrow(tr_questions) == 167L,
  identical(
    as.integer(table(tr_questions$lemma, tr_questions$dependency_relation)),
    c(2L, 14L, 35L, 1L, 3L, 112L)
  ),
  nrow(tr_pronouns) == 2128L,
  identical(
    as.integer(table(tr_pronouns$case)),
    c(49L, 430L, 430L, 18L, 421L, 59L, 46L, 675L)
  ),
  nrow(cmu) == 133854L,
  all(cmu$phone_count >= cmu$vowel_phone_count),
  nrow(tr_verbs) == 588L,
  nrow(tr_verb_sample) == 120L,
  !anyDuplicated(tr_verbs$lemma),
  !anyDuplicated(tr_verb_sample$lemma),
  all(tr_verb_sample$lemma %in% tr_verbs$lemma),
  sum(tr_verbs$t_initial) == 200L,
  all(tr_verbs$stem_final_voiceless == tr_verbs$t_initial),
  nrow(de_genitive) == 16719L,
  nrow(de_sample) == 120L,
  nrow(de_plural) == 13297L,
  nrow(dative) == 3263L,
  sum(is.na(dative$speaker_id)) == 903L,
  nrow(provo_positions) == 1593L,
  nrow(provo_passages) == 55L,
  !anyDuplicated(provo_positions$position_id),
  !anyDuplicated(provo_passages$Text_ID),
  nrow(h95) == 1668L,
  !anyNA(h95)
)

checksums <- c(
  "data/ud-ewt/ud-ewt-wh.csv" =
    "fbc4b10149040ee1486fa6d7cc267025f2cc7925fed621e76d903aa9ee9f078d",
  "data/ud-ewt/ud-ewt-pronouns.csv" =
    "bb4c7ae965770584c5ccf00e10c242a7e286407040a77f6f9050d86861eec844",
  "data/ud-turkish-boun/question-core-arguments.csv" =
    "420a4f358b77af61decf75e4536f46c88c26a5ae84c1dd75de6269bc85cc49d9",
  "data/ud-turkish-boun/personal-pronoun-cases.csv" =
    "7ba0b69d2747f01a13960055ca46ff86af48841892b73065c2a3738bcf34eb07",
  "data/cmudict/cmudict-pronunciations.csv" =
    "bbf40ef2e185b32d515f5ba6dea91c640977007b61967dce2e489ccfb99385fd",
  "data/unimorph-turkish/verb-past-population.csv" =
    "440ba51c27fd9b9db0366478dfbcf40ae50e7538e35ec0f8793d6231b9be76a4",
  "data/unimorph-turkish/verb-past-sample-120.csv" =
    "b5d293b2496290b567a86ee7c77ce33cee249c3a9a5c7c38f6a11a2dba28980e",
  "data/unimorph-german/genitive-population.csv" =
    "98127c132956403e7b16447127a5049f656cd0c0f1efc9384919b6a312959239",
  "data/unimorph-german/genitive-sample-120.csv" =
    "176d6c8cbedeadb741ffaedaf1a5df3f91a0a996a6a2238960a39a0a115332cb",
  "data/unimorph-german/plural-lexemes.csv" =
    "f21c1292f2241269cc4cdd3563dd7cb6efe52ccee9c1edd9bdad4e310532ec61",
  "data/english-dative/dative-alternation.csv" =
    "02a49e0ef2da7df73a7ef622ddf31a55ba13c52a9b66bcfdf2fef3def7932bea",
  "data/provo/content-word-positions.csv" =
    "458a5233347c5e5e1b80e9d73a14b448d90bbd7031bd80b295b096d74f50e914",
  "data/provo/passage-summaries.csv" =
    "9d210d419966c96e1a99b0be79049e46e7cd3bdf8285f8cbe3f062d9a1695121",
  "data/hillenbrand/vowels-complete.csv" =
    "de3450982779fe3ac2e914974eb0ba6a7e0f778d7328f6dbb5d5ab5a58af22c9"
)
invisible(mapply(assert_sha256, names(checksums), unname(checksums)))

cat("All early-course data checks passed.\n")
