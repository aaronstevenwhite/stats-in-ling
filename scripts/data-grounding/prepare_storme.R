#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

output_dir <- script_argument(1, "data/storme-liaison")
source_url <- paste0(
  "https://zenodo.org/api/records/12733801/files/",
  "study1-data.csv/content"
)
expected_md5 <- "8a7788489b6820822cda3f338881f77e"

source_path <- tempfile(fileext = ".csv")
on.exit(unlink(source_path), add = TRUE)
utils::download.file(source_url, source_path, mode = "wb", quiet = FALSE)
observed_md5 <- unname(tools::md5sum(source_path))
if (!identical(observed_md5, expected_md5)) {
  stop("Storme source checksum mismatch: ", observed_md5)
}

raw <- utils::read.csv(source_path, stringsAsFactors = FALSE, check.names = FALSE)
assert_columns(raw, c("final_morph", "FinalConsonant", "Liaison", "freqfilms2"))
stopifnot(nrow(raw) == 85635L, setequal(unique(raw$Liaison), c("no", "yes")))

counts <- stats::aggregate(
  freqfilms2 ~ final_morph + FinalConsonant + Liaison,
  data = raw,
  FUN = sum
)
counts$reconstructed_count <- as.integer(counts$freqfilms2 * 100)
names(counts) <- c(
  "final_morpheme", "final_consonant", "liaison", "frequency_per_million_sum",
  "reconstructed_count"
)
counts <- counts[order(counts$final_morpheme, counts$final_consonant, counts$liaison), ]
row.names(counts) <- NULL

stopifnot(
  nrow(counts) == 11195L,
  sum(counts$liaison == "no") == 6270L,
  sum(counts$liaison == "yes") == 4925L,
  all(counts$reconstructed_count >= 0L)
)

output_path <- file.path(output_dir, "storme-liaison-counts.csv")
write_csv_stable(counts, output_path)
write_json_stable(
  list(
    title = "Storme (2024) French liaison lexical statistics",
    citation = "Storme (2024), Morphology, doi:10.1007/s11525-024-09429-8",
    source = "https://doi.org/10.5281/zenodo.12733801",
    source_file = "study1-data.csv",
    source_md5 = expected_md5,
    source_sha256 = sha256_file(source_path),
    article_license = "CC BY 4.0",
    data_license = "No separate data license stated on the Zenodo record",
    redistribution = "local preparation only; the derived CSV is ignored by Git",
    count_construction = "integer truncation of 100 times summed freqfilms2 within final_morph, FinalConsonant, and Liaison",
    rows = nrow(counts),
    zero_rows = sum(counts$reconstructed_count == 0L),
    output_sha256 = sha256_file(output_path)
  ),
  file.path(output_dir, "provenance.local.json")
)
cat("Prepared", nrow(counts), "Storme reconstructed count rows.\n")
