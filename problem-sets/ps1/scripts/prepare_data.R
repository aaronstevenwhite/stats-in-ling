args <- commandArgs(trailingOnly = TRUE)
output_path <- if (length(args) >= 1) args[[1]] else "data/hillenbrand_vowels.csv"

if (!requireNamespace("phonTools", quietly = TRUE)) {
  stop(
    "Package 'phonTools' is required. Install the frozen 0.2-2.2 release before running this script."
  )
}

if (as.character(utils::packageVersion("phonTools")) != "0.2.2.2") {
  warning(
    "The audited package version is 0.2.2.2; found ",
    as.character(utils::packageVersion("phonTools")),
    ". Schema checks will still run."
  )
}

utils::data("h95", package = "phonTools", envir = environment())

speaker_type <- c(
  b = "boy",
  g = "girl",
  m = "man",
  w = "woman"
)

vowels <- data.frame(
  speaker_id = as.integer(h95$speaker),
  speaker_type = unname(speaker_type[as.character(h95$type)]),
  vowel = as.character(h95$vowel),
  duration_ms = as.integer(h95$dur),
  f0_hz = as.integer(h95$f0),
  f1_hz = as.integer(h95$f1),
  f2_hz = as.numeric(h95$f2),
  f3_hz = as.numeric(h95$f3),
  stringsAsFactors = FALSE
)

stopifnot(
  nrow(vowels) == 1668L,
  length(unique(vowels$speaker_id)) == 139L,
  all(table(vowels$speaker_id) == 12L),
  sum(vowels$vowel == "i") == 139L,
  sum(vowels$vowel == "I") == 139L,
  !anyDuplicated(vowels[c("speaker_id", "vowel")]),
  !anyNA(vowels[c("speaker_id", "speaker_type", "vowel", "f1_hz")])
)

utils::write.csv(vowels, output_path, row.names = FALSE)

cat("Wrote", nrow(vowels), "rows to", output_path, "\n")
