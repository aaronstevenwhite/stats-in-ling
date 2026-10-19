#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

output_dir <- script_argument(1, "data/nettle")
source_url <- paste0(
  "https://raw.githubusercontent.com/bodowinter/",
  "applied_statistics_book_data/master/nettle_1999_climate.csv"
)
expected_sha256 <-
  "3c5abfbec7b2132a9b81ee9a178cbd5559426578032b60c6c4ad74046898793b"

source_path <- tempfile(fileext = ".csv")
on.exit(unlink(source_path), add = TRUE)
utils::download.file(source_url, source_path, mode = "wb", quiet = FALSE)
assert_sha256(source_path, expected_sha256)

raw <- utils::read.csv(source_path, stringsAsFactors = FALSE, check.names = FALSE)
assert_columns(
  raw,
  c("Country", "Population", "Area", "MGS", "Langs"),
  exact = TRUE
)
stopifnot(
  nrow(raw) == 74L,
  identical(range(raw$Langs), c(1L, 862L)),
  identical(range(raw$MGS), c(0, 12))
)

teaching <- data.frame(
  country = raw$Country,
  log10_population = raw$Population,
  log10_area_km2 = raw$Area,
  log_area_km2 = log(10) * raw$Area,
  mean_growing_season_months = raw$MGS,
  language_count = as.integer(raw$Langs),
  stringsAsFactors = FALSE
)
stopifnot(all(teaching$language_count > 0), all(is.finite(teaching$log_area_km2)))

output_path <- file.path(output_dir, "nettle-1999-climate.csv")
write_csv_stable(teaching, output_path)
write_json_stable(
  list(
    title = "Nettle (1999) linguistic diversity and climate table",
    citation = "Nettle (1999), Linguistic Diversity",
    source = source_url,
    source_sha256 = expected_sha256,
    license = "No explicit data license found in the source repository",
    redistribution = "local preparation only; the derived CSV is ignored by Git",
    transformation = "Area is retained on log10 scale and converted to natural-log area for a log-link offset",
    rows = nrow(teaching),
    output_sha256 = sha256_file(output_path)
  ),
  file.path(output_dir, "provenance.local.json")
)
cat("Prepared", nrow(teaching), "Nettle country rows.\n")
