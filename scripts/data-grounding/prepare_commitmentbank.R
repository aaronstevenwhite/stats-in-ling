#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

input_path <- script_argument(
  1,
  "problem-sets/ps4/data/CommitmentBank-All.csv"
)
output_dir <- script_argument(2, "data/commitmentbank")
expected_sha256 <-
  "34a368dfdd87f4ea75638e34ecd9df0297577e238748a36280a9b047632bb769"

assert_sha256(input_path, expected_sha256)
raw <- utils::read.csv(
  input_path,
  stringsAsFactors = FALSE,
  check.names = FALSE,
  na.strings = ""
)
required <- c(
  "uID", "HitID", "WorkerID", "Verb", "Answer", "Embedding",
  "ModalType", "MatTense", "MatSubjLemma", "MatSubjPer", "MatSubjNum",
  "genre", "factive"
)
assert_columns(raw, required)
stopifnot(
  nrow(raw) == 11545L,
  length(unique(raw$uID)) == 1200L,
  length(unique(raw$WorkerID)) == 496L,
  setequal(unique(raw$Answer), -3:3)
)

teaching <- data.frame(
  discourse_id = raw$uID,
  hit_id = raw$HitID,
  annotator_id = raw$WorkerID,
  predicate = raw$Verb,
  rating = as.integer(raw$Answer),
  embedding = raw$Embedding,
  modal_type = ifelse(is.na(raw$ModalType), "none", raw$ModalType),
  matrix_tense = raw$MatTense,
  matrix_subject_lemma = raw$MatSubjLemma,
  matrix_subject_person = raw$MatSubjPer,
  matrix_subject_number = raw$MatSubjNum,
  genre = raw$genre,
  factive = raw$factive,
  stringsAsFactors = FALSE
)
teaching <- teaching[order(teaching$discourse_id, teaching$annotator_id), ]
row.names(teaching) <- NULL

stopifnot(
  nrow(teaching) == 11545L,
  all(teaching$rating %in% -3:3),
  all(table(teaching$discourse_id) >= 8L),
  all(!duplicated(teaching[c("discourse_id", "annotator_id")]))
)

output_path <- file.path(output_dir, "commitmentbank-ratings.csv")
write_csv_stable(teaching, output_path)
write_json_stable(
  list(
    title = "CommitmentBank",
    citation = paste(
      "de Marneffe, Simons, and Tonhauser (2019), Semantics and Pragmatics 12,",
      "doi:10.18148/sub/2019.v23i2.601"
    ),
    source = "https://github.com/mcdm/CommitmentBank",
    source_file = "CommitmentBank-All.csv",
    source_sha256 = expected_sha256,
    article_license = "CC BY 4.0",
    data_license = "No explicit data license in the repository",
    corpus_terms = "Source passages include BNC, Switchboard, and Wall Street Journal material",
    redistribution = "local preparation only; the text-free derivative is ignored by Git pending permission",
    omitted_fields = c("Context", "Target", "Prompt"),
    rows = nrow(teaching),
    discourses = length(unique(teaching$discourse_id)),
    annotators = length(unique(teaching$annotator_id)),
    output_sha256 = sha256_file(output_path)
  ),
  file.path(output_dir, "provenance.local.json")
)
cat("Prepared", nrow(teaching), "CommitmentBank ratings without corpus text.\n")
