#!/usr/bin/env Rscript
# Validate Provo content-word positions and derive passage-level summaries.

arguments <- commandArgs(trailingOnly = TRUE)
repository <- normalizePath(file.path(dirname(sub("^--file=", "", grep(
  "^--file=", commandArgs(trailingOnly = FALSE), value = TRUE
))), "..", ".."), mustWork = TRUE)
input <- if (length(arguments) >= 1L) arguments[[1]] else file.path(
  repository, "problem-sets", "ps2", "data", "provo-content-word-positions.csv"
)
output_directory <- if (length(arguments) >= 2L) arguments[[2]] else file.path(
  repository, "data", "provo"
)

positions <- utils::read.csv(input, stringsAsFactors = FALSE)
required <- c(
  "position_id", "Word_Unique_ID", "Text_ID", "Word_Number", "Word_Length",
  "Word_POS", "Word_In_Sentence_Number", "OrthoMatchModel", "POSMatchModel",
  "LSA_Response_Match_Score", "mean_log_ffd", "n_fixations"
)
stopifnot(
  identical(names(positions), required),
  nrow(positions) == 1593L,
  length(unique(positions$Text_ID)) == 55L,
  !anyDuplicated(positions$position_id),
  !anyNA(positions),
  all(positions$Word_Length >= 1L),
  all(positions$OrthoMatchModel > 0 & positions$OrthoMatchModel <= 1),
  all(positions$POSMatchModel > 0 & positions$POSMatchModel <= 1),
  all(positions$LSA_Response_Match_Score >= 0 &
        positions$LSA_Response_Match_Score <= 1),
  all(positions$n_fixations > 0L),
  all(is.finite(positions$mean_log_ffd))
)

summarize_passage <- function(rows) {
  nouns <- rows$Word_POS == "Noun"
  verbs <- rows$Word_POS == "Verb"
  data.frame(
    Text_ID = rows$Text_ID[[1]],
    n_positions = nrow(rows),
    mean_word_length = mean(rows$Word_Length),
    mean_ortho_predictability = mean(rows$OrthoMatchModel),
    mean_pos_predictability = mean(rows$POSMatchModel),
    mean_lsa_predictability = mean(rows$LSA_Response_Match_Score),
    mean_log_ffd = mean(rows$mean_log_ffd),
    n_nouns = sum(nouns),
    n_verbs = sum(verbs),
    noun_mean_log_ffd = mean(rows$mean_log_ffd[nouns]),
    verb_mean_log_ffd = mean(rows$mean_log_ffd[verbs]),
    noun_minus_verb_log_ffd = mean(rows$mean_log_ffd[nouns]) -
      mean(rows$mean_log_ffd[verbs])
  )
}

passages <- do.call(rbind, lapply(split(positions, positions$Text_ID), summarize_passage))
rownames(passages) <- NULL
passages <- passages[order(passages$Text_ID), ]
stopifnot(
  nrow(passages) == 55L,
  !anyDuplicated(passages$Text_ID),
  all(passages$n_nouns >= 4L),
  all(passages$n_verbs >= 4L),
  !anyNA(passages),
  all(is.finite(as.matrix(passages)))
)

dir.create(output_directory, recursive = TRUE, showWarnings = FALSE)
utils::write.csv(positions, file.path(output_directory, "content-word-positions.csv"),
                 row.names = FALSE)
utils::write.csv(passages, file.path(output_directory, "passage-summaries.csv"),
                 row.names = FALSE)
cat("Provo positions:", nrow(positions), "\n")
cat("Provo passages:", nrow(passages), "\n")

