#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

output_dir <- script_argument(1, "data/hillenbrand-raw")
commit <- "6dd44decc8ef5b537cbb54732a3b00c8fa652e65"
base_url <- paste0(
  "https://raw.githubusercontent.com/santiagobarreda/",
  "hillenbrand_et_al_1995/", commit, "/"
)
data_sha256 <-
  "3798b6e005a52323247a686259582746a4790e1fe5a301a27535d0f13fb3a6cf"
license_sha256 <-
  "43f09a80bc2c9cb20ef69c803b4910b4f4ea8955ead590fd8573aee892bd9548"

data_path <- tempfile(fileext = ".RDS")
license_path <- tempfile(fileext = ".txt")
on.exit(unlink(c(data_path, license_path)), add = TRUE)
utils::download.file(paste0(base_url, "h95_data.RDS"), data_path, mode = "wb")
utils::download.file(paste0(base_url, "LICENSE"), license_path, mode = "wb")
assert_sha256(data_path, data_sha256)
assert_sha256(license_path, license_sha256)

raw <- readRDS(data_path)
formants <- c("f1", "f2", "f3", unlist(lapply(1:8, function(i) {
  paste0(c("f1_", "f2_", "f3_"), i)
})))
required <- c("file", "type", "speaker", "vowel", "ipa", "dur", "f0", formants)
assert_columns(raw, required)
stopifnot(
  identical(dim(raw), c(1668L, 50L)),
  length(unique(raw$speaker)) == 139L,
  length(unique(raw$vowel)) == 12L,
  sum(is.na(raw$f2)) == 10L,
  sum(is.na(raw$f3)) == 41L
)

teaching <- raw[required]
names(teaching)[names(teaching) == "file"] <- "token_id"
names(teaching)[names(teaching) == "type"] <- "speaker_type"
names(teaching)[names(teaching) == "speaker"] <- "speaker_id"
names(teaching)[names(teaching) == "dur"] <- "duration_ms"
names(teaching)[names(teaching) == "f0"] <- "f0_hz"
names(teaching)[names(teaching) == "f1"] <- "f1_steady_hz"
names(teaching)[names(teaching) == "f2"] <- "f2_steady_hz"
names(teaching)[names(teaching) == "f3"] <- "f3_steady_hz"
for (time_index in 1:8) {
  for (formant in 1:3) {
    source_name <- paste0("f", formant, "_", time_index)
    names(teaching)[names(teaching) == source_name] <- paste0(
      "f", formant, "_time", time_index, "_hz"
    )
  }
}
teaching <- teaching[order(teaching$speaker_id, teaching$vowel), ]
row.names(teaching) <- NULL

output_path <- file.path(output_dir, "hillenbrand-raw-formants.csv")
license_output <- file.path(output_dir, "LICENSE-MIT.txt")
write_csv_stable(teaching, output_path)
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
if (!file.copy(license_path, license_output, overwrite = TRUE)) {
  stop("Could not preserve the Hillenbrand repository license.")
}

missing_counts <- colSums(is.na(teaching))
write_json_stable(
  list(
    title = "Hillenbrand et al. (1995) American English vowel measurements",
    citation = "Hillenbrand et al. (1995), JASA 97:3099-3111, doi:10.1121/1.411872",
    source = "https://github.com/santiagobarreda/hillenbrand_et_al_1995",
    source_commit = commit,
    source_file = "h95_data.RDS",
    source_sha256 = data_sha256,
    license = "MIT; data hosted with permission from Jim Hillenbrand",
    license_sha256 = license_sha256,
    adaptation = "Identifiers, duration, F0, steady-state F1-F3, and eight F1-F3 trajectory samples retained; perception columns omitted",
    rows = nrow(teaching),
    speakers = length(unique(teaching$speaker_id)),
    vowels = length(unique(teaching$vowel)),
    missing_by_column = as.list(missing_counts[missing_counts > 0]),
    output_sha256 = sha256_file(output_path)
  ),
  file.path(output_dir, "provenance.json")
)
cat("Prepared", nrow(teaching), "raw Hillenbrand vowel rows with natural missingness.\n")
