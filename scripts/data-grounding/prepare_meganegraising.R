#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

archive <- script_argument(1, "")
output_dir <- script_argument(2, "data/meganegraising")
source_url <- paste0(
  "https://megaattitude.io/projects/mega-negraising/",
  "mega-negraising-v1.zip"
)
expected_sha256 <-
  "6121ed8da217e1e66c20e115fe90848a2d0c3a61e896ebfaaa388a966106ef23"

downloaded <- FALSE
if (!nzchar(archive)) {
  archive <- tempfile(fileext = ".zip")
  downloaded <- TRUE
  utils::download.file(source_url, archive, mode = "wb", quiet = FALSE)
}
if (downloaded) on.exit(unlink(archive), add = TRUE)
assert_sha256(archive, expected_sha256)

raw <- utils::read.delim(
  unz(archive, "mega-negraising-v1/mega-negraising-v1.tsv"),
  check.names = FALSE
)
stopifnot(
  nrow(raw) == 79360L,
  length(unique(raw$verb)) == 925L,
  length(unique(raw$participant)) == 1108L,
  all(raw$negraising >= 0 & raw$negraising <= 1),
  all(raw$acceptability >= 0 & raw$acceptability <= 1)
)

native <- subset(raw, nativeenglish == "True")
balanced <- subset(
  native,
  tense == "past" &
    frame %in% c("NP V to VP[+eventive]", "NP be V to VP[+eventive]")
)
cells <- unique(balanced[c("verb", "frame", "subject")])
complete_verbs <- names(which(table(cells$verb) == 4L))
balanced <- balanced[balanced$verb %in% complete_verbs, ]
balanced$voice <- ifelse(grepl("^NP be", balanced$frame), "passive", "active")
balanced <- balanced[c(
  "participant", "verb", "frame", "voice", "subject",
  "negraising", "acceptability"
)]
balanced <- balanced[order(
  balanced$verb, balanced$voice, balanced$subject, balanced$participant
), ]
row.names(balanced) <- NULL
stopifnot(
  nrow(native) == 78496L,
  length(unique(native$participant)) == 1098L,
  nrow(balanced) == 7651L,
  length(unique(balanced$participant)) == 1091L,
  length(unique(balanced$verb)) == 193L,
  nrow(unique(balanced[c("verb", "voice", "subject")])) == 772L
)

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
release_summary <- data.frame(
  sample = c("full release", "native-speaker release", "balanced teaching subset"),
  rows = c(nrow(raw), nrow(native), nrow(balanced)),
  participants = c(length(unique(raw$participant)),
                   length(unique(native$participant)),
                   length(unique(balanced$participant))),
  verbs = c(length(unique(raw$verb)), length(unique(native$verb)),
            length(unique(balanced$verb)))
)
release_summary_path <- file.path(output_dir, "meganegraising-release-summary.csv")
write_csv_stable(
  release_summary,
  release_summary_path
)
output_path <- file.path(output_dir, "meganegraising-balanced.csv")
write_csv_stable(balanced, output_path)
write_json_stable(
  list(
    title = "MegaNegRaising v1.1 balanced teaching subset",
    citation = paste(
      "An and White (2020), The Lexical and Grammatical Sources of",
      "Neg-Raising Inferences"
    ),
    source = source_url,
    archive_label = "v1 filename; internal README version 1.1, 2020-08-29",
    source_sha256 = expected_sha256,
    license = "CC BY-SA 4.0",
    filter = paste(
      "Native American English; past tense; active/passive eventive",
      "infinitivals; first/third subject; verbs in all four cells"
    ),
    rows = nrow(balanced),
    participants = length(unique(balanced$participant)),
    verbs = length(unique(balanced$verb)),
    cells = nrow(unique(balanced[c("verb", "voice", "subject")])),
    release_summary_sha256 = sha256_file(release_summary_path),
    output_sha256 = sha256_file(output_path)
  ),
  file.path(output_dir, "provenance.json")
)
cat("Prepared", nrow(balanced), "MegaNegRaising judgments.\n")
