args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2L) {
  stop("Usage: Rscript prepare.R source-data-similarity.csv output.csv")
}

source_path <- normalizePath(args[[1]], mustWork = TRUE)
output_path <- args[[2]]
trials <- read.csv(source_path, stringsAsFactors = FALSE)

stopifnot(
  nrow(trials) == 12416L,
  sum(trials$verb_type != "calibration") == 10800L,
  all(trials$response >= 0 & trials$response <= 100),
  length(unique(trials$participant[trials$verb_type != "calibration"])) == 202L
)

test <- trials[
  trials$verb_type != "calibration" &
    trials$contentfulness1 == "contentful" &
    trials$contentfulness2 == "contentful",
]
test$same_sense <- as.integer(test$propbank_sense1 == test$propbank_sense2)

verb_has_both <- tapply(test$same_sense, test$verb, function(x) {
  all(c(0L, 1L) %in% x)
})
test <- test[test$verb %in% names(verb_has_both)[verb_has_both], ]

ordered_pair <- ifelse(
  test$sentence1 <= test$sentence2,
  paste(test$sentence1, test$sentence2, sep = " || "),
  paste(test$sentence2, test$sentence1, sep = " || ")
)
test$sentence_pair_id <- sprintf("pair%03d", match(ordered_pair, unique(ordered_pair)))

teaching <- data.frame(
  participant_id = test$participant,
  list_number = as.integer(test$list_num),
  verb = test$verb,
  verb_type = test$verb_type,
  sentence_pair_id = test$sentence_pair_id,
  sentence_1 = test$sentence1,
  sentence_2 = test$sentence2,
  same_sense = test$same_sense,
  dissimilarity = as.integer(test$response),
  response_time_ms = as.integer(test$rt),
  stringsAsFactors = FALSE
)

stopifnot(
  nrow(teaching) == 4405L,
  length(unique(teaching$participant_id)) == 202L,
  length(unique(teaching$verb)) == 14L,
  length(unique(teaching$sentence_pair_id)) == 218L,
  all(tapply(teaching$same_sense, teaching$verb, function(x) {
    all(c(0L, 1L) %in% x)
  }))
)

write.csv(teaching, output_path, row.names = FALSE)
cat("Wrote", nrow(teaching), "rows to", output_path, "\n")

