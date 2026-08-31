args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 2) {
  stop(
    "Usage: Rscript prepare_data.R <Provo_Corpus-Eyetracking_Data.csv> <output.csv>"
  )
}

input_path <- args[[1]]
output_path <- args[[2]]

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
  c("IA_FIRST_FIXATION_DURATION", "Word_Content_Or_Function", "position_id")
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

mean_log_ffd <- aggregate(
  log(trials$IA_FIRST_FIXATION_DURATION),
  list(position_id = trials$position_id),
  mean
)
names(mean_log_ffd)[2] <- "mean_log_ffd"

n_fixations <- aggregate(
  trials$IA_FIRST_FIXATION_DURATION,
  list(position_id = trials$position_id),
  length
)
names(n_fixations)[2] <- "n_fixations"

items <- merge(items, mean_log_ffd, by = "position_id", sort = FALSE)
items <- merge(items, n_fixations, by = "position_id", sort = FALSE)
items <- items[order(items$Text_ID, items$Word_Number), ]
row.names(items) <- NULL

stopifnot(
  nrow(items) == 1593L,
  length(unique(items$Text_ID)) == 55L,
  !anyDuplicated(items$position_id),
  length(unique(items$Word_Unique_ID)) == 1592L,
  all(items$OrthoMatchModel > 0),
  all(items$POSMatchModel > 0),
  all(is.finite(items$mean_log_ffd))
)

utils::write.csv(items, output_path, row.names = FALSE)
cat("Wrote", nrow(items), "content-word positions to", output_path, "\n")
