#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

output_dir <- script_argument(1, "data/natural-stories")
commit <- "4700daad696e942f5aba23c957a7423d0de66612"
base_url <- paste0(
  "https://raw.githubusercontent.com/languageMIT/naturalstories/",
  commit,
  "/"
)
sources <- list(
  rt = list(
    path = "naturalstories_RTS/processed_RTs.tsv",
    sha256 = "208ee6c451f3827734d5b2de32b91e2cf3bd76aa177c412cb426373fa7d50b22"
  ),
  tokens = list(
    path = "naturalstories_RTS/all_stories.tok",
    sha256 = "0e4e9bd4708aaa01d8bea342696bb83cedff679c09184545483f6f3f4ba8aca3"
  ),
  parse = list(
    path = "parses/ud/stories-aligned.conllx",
    sha256 = "21e8bfa0fec0484f7fb66aa8220ef1817225cbfebe9ac11334ce916db1d12f41"
  ),
  frequency = list(
    path = "freqs/freqs-1.tsv",
    sha256 = "dfe87aa455e43226eb7f79faa6e5d9926446c3d8346014dd75837f39c3f19add"
  ),
  surprisal = list(
    path = "probs/all_stories_gpt3.csv",
    sha256 = "6ccee02c20a688d5f7e69a023025d725e8fb06d87e2c7f997b399384c200a0ad"
  ),
  license = list(
    path = "LICENSE.txt",
    sha256 = "58032a8173195237068ab02d429948bc3233d8e6858d1b9ddfdc47e3bbc3d847"
  )
)

local <- lapply(sources, function(source) {
  path <- tempfile(fileext = paste0("-", basename(source$path)))
  utils::download.file(paste0(base_url, source$path), path, mode = "wb")
  assert_sha256(path, source$sha256)
  path
})
on.exit(unlink(unlist(local)), add = TRUE)

rt <- utils::read.delim(local$rt, stringsAsFactors = FALSE, check.names = FALSE)
assert_columns(
  rt,
  c(
    "WorkerId", "WorkTimeInSeconds", "correct", "item", "zone", "RT",
    "word", "nItem", "meanItemRT", "sdItemRT", "gmeanItemRT", "gsdItemRT"
  ),
  exact = TRUE
)
stopifnot(
  nrow(rt) == 848875L,
  length(unique(rt$WorkerId)) == 180L,
  setequal(unique(rt$item), 1:10),
  range(rt$RT) == c(101L, 2992L)
)

tokens <- utils::read.delim(local$tokens, stringsAsFactors = FALSE, check.names = FALSE)
assert_columns(tokens, c("word", "zone", "item"), exact = TRUE)
stopifnot(nrow(tokens) == 10256L, setequal(unique(tokens$item), 1:10))
tokens$key <- paste(tokens$item, tokens$zone, sep = ".")
stopifnot(!anyDuplicated(tokens$key))

# Recover released sentence membership from blank-line-delimited UD parses. The
# TokenId field points from parser subtokens to the experiment's story and zone.
parse_lines <- readLines(local$parse, warn = FALSE, encoding = "UTF-8")
sentence_number <- 1L
sentence_map <- list()
for (line in parse_lines) {
  if (!nzchar(line)) {
    sentence_number <- sentence_number + 1L
    next
  }
  fields <- strsplit(line, "\t", fixed = FALSE)[[1]]
  if (length(fields) != 10L || !grepl("^TokenId=", fields[[10]])) {
    stop("Unexpected aligned UD row: ", line)
  }
  token_id <- sub("^TokenId=", "", fields[[10]])
  pieces <- strsplit(token_id, ".", fixed = TRUE)[[1]]
  key <- paste(pieces[[1]], pieces[[2]], sep = ".")
  if (!is.null(sentence_map[[key]]) && sentence_map[[key]] != sentence_number) {
    stop("A token was assigned to two released sentences: ", key)
  }
  sentence_map[[key]] <- sentence_number
}
tokens$sentence_id <- unname(unlist(sentence_map[tokens$key]))
stopifnot(!anyNA(tokens$sentence_id), length(unique(tokens$sentence_id)) == 485L)

# Google Books unigram counts are released with `.word` token identifiers.
frequency <- utils::read.delim(
  local$frequency,
  header = FALSE,
  stringsAsFactors = FALSE,
  quote = ""
)
names(frequency) <- c(
  "token_id", "order", "word", "unigram_frequency", "context_frequency"
)
frequency <- frequency[grepl("[.]word$", frequency$token_id), ]
frequency$key <- sub("[.]word$", "", frequency$token_id)
frequency_lookup <- setNames(frequency$unigram_frequency, frequency$key)
tokens$unigram_frequency <- unname(frequency_lookup[tokens$key])
tokens$log_unigram_frequency <- log(tokens$unigram_frequency)
stopifnot(sum(is.na(tokens$unigram_frequency)) == 10L)

# The GPT-3 file contains byte-pair tokens. A leading space starts a new
# experiment word; summing component log probabilities returns word surprisal.
gpt <- utils::read.csv(local$surprisal, stringsAsFactors = FALSE, check.names = FALSE)
assert_columns(gpt, c("token", "logprob", "offset", "model", "time", "id", "story"), exact = TRUE)
stopifnot(nrow(gpt) == 12373L, setequal(unique(gpt$story), 0:9))

surprisal_rows <- vector("list", 10L)
alignment_mismatches <- data.frame(
  story = integer(), zone = integer(), experiment_word = character(),
  model_word = character(), stringsAsFactors = FALSE
)
for (story in 1:10) {
  story_gpt <- gpt[gpt$story == story - 1L, ]
  starts <- seq_len(nrow(story_gpt)) == 1L |
    grepl("^[[:space:]]", story_gpt$token)
  word_index <- cumsum(starts)
  story_tokens <- tokens[tokens$item == story, ]
  stopifnot(max(word_index) == nrow(story_tokens))

  split_rows <- split(seq_len(nrow(story_gpt)), word_index)
  model_words <- vapply(split_rows, function(rows) {
    trimws(paste0(story_gpt$token[rows], collapse = ""))
  }, character(1))
  mismatch <- which(model_words != story_tokens$word)
  if (length(mismatch)) {
    alignment_mismatches <- rbind(
      alignment_mismatches,
      data.frame(
        story = story,
        zone = story_tokens$zone[mismatch],
        experiment_word = story_tokens$word[mismatch],
        model_word = model_words[mismatch],
        stringsAsFactors = FALSE
      )
    )
  }

  word_log_probability <- vapply(split_rows, function(rows) {
    values <- story_gpt$logprob[rows]
    if (anyNA(values)) NA_real_ else sum(values)
  }, numeric(1))
  surprisal_rows[[story]] <- data.frame(
    key = story_tokens$key,
    gpt3_surprisal = -word_log_probability,
    stringsAsFactors = FALSE
  )
}
surprisal <- do.call(rbind, surprisal_rows)
stopifnot(
  nrow(surprisal) == 10256L,
  nrow(alignment_mismatches) == 1L,
  alignment_mismatches$story == 2L,
  alignment_mismatches$experiment_word == "peaked",
  alignment_mismatches$model_word == "peeked"
)
surprisal_lookup <- setNames(surprisal$gpt3_surprisal, surprisal$key)
tokens$gpt3_surprisal <- unname(surprisal_lookup[tokens$key])
stopifnot(sum(is.na(tokens$gpt3_surprisal)) == 10L)

rt$key <- paste(rt$item, rt$zone, sep = ".")
token_index <- match(rt$key, tokens$key)
stopifnot(!anyNA(token_index), identical(rt$word, tokens$word[token_index]))

teaching <- data.frame(
  participant_id = rt$WorkerId,
  work_time_seconds = as.integer(rt$WorkTimeInSeconds),
  comprehension_correct = as.integer(rt$correct),
  story_id = as.integer(rt$item),
  sentence_id = as.integer(tokens$sentence_id[token_index]),
  word_position = as.integer(rt$zone),
  word = rt$word,
  word_length = nchar(rt$word, type = "chars"),
  rt_ms = as.integer(rt$RT),
  log_rt = log(as.numeric(rt$RT)),
  unigram_frequency = as.numeric(tokens$unigram_frequency[token_index]),
  log_unigram_frequency = as.numeric(tokens$log_unigram_frequency[token_index]),
  gpt3_surprisal = as.numeric(tokens$gpt3_surprisal[token_index]),
  stringsAsFactors = FALSE
)
stopifnot(
  nrow(teaching) == 848875L,
  length(unique(teaching$sentence_id)) == 485L,
  sum(is.na(teaching$unigram_frequency)) > 0L,
  sum(is.na(teaching$gpt3_surprisal)) > 0L
)

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
output_path <- file.path(output_dir, "natural-stories-corrected.rds")
saveRDS(teaching, output_path, version = 3, compress = "xz")
license_output <- file.path(output_dir, "LICENSE-CC-BY-NC-SA-4.0.txt")
if (!file.copy(local$license, license_output, overwrite = TRUE)) {
  stop("Could not preserve the Natural Stories license.")
}
write_csv_stable(
  alignment_mismatches,
  file.path(output_dir, "gpt3-alignment-exception.csv")
)

write_json_stable(
  list(
    title = "Natural Stories corrected self-paced reading data",
    citation = "Futrell et al. (2021), Language Resources and Evaluation 55:63-77",
    source = "https://github.com/languageMIT/naturalstories",
    source_commit = commit,
    correction = "Pinned after the 2025 one-position SPR realignment correction",
    license = "CC BY-NC-SA 4.0",
    source_files = lapply(names(sources), function(name) {
      list(name = name, path = sources[[name]]$path, sha256 = sources[[name]]$sha256)
    }),
    rows = nrow(teaching),
    participants = length(unique(teaching$participant_id)),
    stories = length(unique(teaching$story_id)),
    sentences = length(unique(teaching$sentence_id)),
    token_positions = length(unique(paste(teaching$story_id, teaching$word_position))),
    missing_unigram_positions = sum(is.na(tokens$unigram_frequency)),
    missing_surprisal_positions = sum(is.na(tokens$gpt3_surprisal)),
    gpt3_alignment_exception = alignment_mismatches,
    output_sha256 = sha256_file(output_path)
  ),
  file.path(output_dir, "provenance.json")
)
cat("Prepared", nrow(teaching), "corrected Natural Stories RT rows.\n")
