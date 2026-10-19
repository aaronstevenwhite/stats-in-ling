#!/usr/bin/env Rscript

# Prepare the ten manually treebanked Tanaka/Jacy profiles at a pinned commit.
# Field names are read from each profile's [incr tsdb()] `relations` schema;
# they are not guessed from column positions.

source("scripts/data-grounding/common.R")

commit <- "82c282e2592841478d07aa81a83489344bb16e00"
archive_url <- paste0(
  "https://codeload.github.com/delph-in/jacy/tar.gz/",
  commit
)
archive_sha256 <-
  "a917e936cf82c1cfb56f5397fa6d985016e8ea63c90262e549e2c038861ea53e"

arguments <- commandArgs(trailingOnly = TRUE)
source_directory <- if (length(arguments) >= 1L && nzchar(arguments[[1]])) {
  arguments[[1]]
} else {
  NA_character_
}
output_directory <- if (length(arguments) >= 2L && nzchar(arguments[[2]])) {
  arguments[[2]]
} else {
  "data/jacy-mrs"
}

temporary_directory <- tempfile("jacy-mrs-")
dir.create(temporary_directory, recursive = TRUE)
on.exit(unlink(temporary_directory, recursive = TRUE), add = TRUE)

if (is.na(source_directory)) {
  archive_path <- file.path(temporary_directory, "jacy.tar.gz")
  utils::download.file(archive_url, archive_path, mode = "wb")
  assert_sha256(archive_path, archive_sha256)
  extraction_directory <- file.path(temporary_directory, "source")
  dir.create(extraction_directory)
  utils::untar(archive_path, exdir = extraction_directory)
  roots <- list.dirs(extraction_directory, recursive = FALSE, full.names = TRUE)
  if (length(roots) != 1L) {
    stop("Expected one root directory in the pinned Jacy archive.")
  }
  source_directory <- roots[[1]]
}

source_directory <- normalizePath(source_directory, mustWork = TRUE)
gold_directory <- file.path(source_directory, "tsdb", "gold")
profiles <- sprintf("tc-%03d", 6:15)
stopifnot(
  all(dir.exists(file.path(gold_directory, profiles))),
  file.exists(file.path(source_directory, "LICENSE"))
)

relation_fields <- function(relations_path, relation) {
  lines <- readLines(relations_path, encoding = "UTF-8", warn = FALSE)
  start <- which(lines == paste0(relation, ":"))
  if (length(start) != 1L) {
    stop("Could not find a unique ", relation, " schema in ", relations_path)
  }
  following <- lines[seq.int(start + 1L, length(lines))]
  block_end <- which(!grepl("^  ", following))[1]
  if (!is.na(block_end)) {
    following <- head(following, block_end - 1L)
  }
  fields <- sub("^  ([^ ]+) .*$", "\\1", following[grepl("^  [^ ]+ +:", following)])
  if (!length(fields)) {
    stop("No fields found for ", relation, " in ", relations_path)
  }
  fields
}

read_tsdb_relation <- function(profile_directory, relation) {
  schema <- relation_fields(file.path(profile_directory, "relations"), relation)
  path <- file.path(profile_directory, relation)
  value <- utils::read.delim(
    path,
    sep = "@",
    header = FALSE,
    quote = "",
    comment.char = "",
    fill = TRUE,
    stringsAsFactors = FALSE,
    fileEncoding = "UTF-8",
    check.names = FALSE
  )
  if (ncol(value) != length(schema)) {
    stop(
      relation, " in ", profile_directory, " has ", ncol(value),
      " columns; its declared schema has ", length(schema), "."
    )
  }
  names(value) <- schema
  value
}

profile_rows <- vector("list", length(profiles))
preference_record_counts <- integer(length(profiles))
result_record_counts <- integer(length(profiles))
names(preference_record_counts) <- names(result_record_counts) <- profiles

for (profile_index in seq_along(profiles)) {
  profile <- profiles[[profile_index]]
  profile_directory <- file.path(gold_directory, profile)
  item <- read_tsdb_relation(profile_directory, "item")
  parse <- read_tsdb_relation(profile_directory, "parse")
  preference <- read_tsdb_relation(profile_directory, "preference")

  stopifnot(
    nrow(item) == 1500L,
    nrow(parse) == 1500L,
    !anyDuplicated(item[["i-id"]]),
    !anyDuplicated(parse[["parse-id"]]),
    setequal(item[["i-id"]], parse[["i-id"]])
  )

  parse <- parse[match(item[["i-id"]], parse[["i-id"]]), ]
  preference_counts <- table(preference[["parse-id"]])
  preferred_analysis_count <- as.integer(
    preference_counts[match(parse[["parse-id"]], names(preference_counts))]
  )
  preferred_analysis_count[is.na(preferred_analysis_count)] <- 0L
  selected_analysis <- preferred_analysis_count > 0L

  # In the release, a preference row identifies an accepted result.  Multiple
  # accepted results may be recorded for one item; the binary observation is
  # therefore whether at least one preference row exists for its parse.
  stopifnot(
    all(!selected_analysis | parse[["readings"]] > 0L),
    all(preference[["parse-id"]] %in% parse[["parse-id"]])
  )

  token_count <- lengths(strsplit(trimws(item[["i-input"]]), "[[:space:]]+"))
  length_matches_whitespace_split <-
    as.integer(token_count) == as.integer(item[["i-length"]])

  coverage_state <- ifelse(
    selected_analysis,
    "selected_analysis",
    ifelse(
      parse[["readings"]] > 0L,
      "parsed_unselected",
      "no_positive_reading"
    )
  )

  profile_rows[[profile_index]] <- data.frame(
    profile = profile,
    item_id = as.integer(item[["i-id"]]),
    item_text = item[["i-input"]],
    item_length = as.integer(item[["i-length"]]),
    length_matches_whitespace_split = length_matches_whitespace_split,
    item_wellformedness = as.integer(item[["i-wf"]]),
    parse_readings = as.integer(parse[["readings"]]),
    parser_message = nzchar(parse[["error"]]),
    preferred_analysis_count = preferred_analysis_count,
    selected_analysis = selected_analysis,
    coverage_state = coverage_state,
    stringsAsFactors = FALSE
  )

  preference_record_counts[[profile]] <- nrow(preference)
  result_record_counts[[profile]] <- length(
    readLines(file.path(profile_directory, "result"), encoding = "UTF-8", warn = FALSE)
  )
}

teaching <- do.call(rbind, profile_rows)
row.names(teaching) <- NULL

stopifnot(
  nrow(teaching) == 15000L,
  sum(teaching$selected_analysis) == 8670L,
  sum(teaching$preferred_analysis_count) == 9128L,
  sum(teaching$preferred_analysis_count > 1L) == 333L,
  sum(pmax(teaching$preferred_analysis_count - 1L, 0L)) == 458L,
  sum(teaching$coverage_state == "parsed_unselected") == 3666L,
  sum(teaching$coverage_state == "no_positive_reading") == 2664L,
  sum(teaching$parse_readings == -1L) == 318L,
  sum(teaching$parse_readings == 0L) == 2346L,
  sum(teaching$parser_message) == 513L,
  identical(preference_record_counts, result_record_counts),
  min(teaching$item_length) == 2L,
  max(teaching$item_length) == 55L
)
stopifnot(
  sum(!teaching$length_matches_whitespace_split) == 3L,
  all(teaching$item_length[!teaching$length_matches_whitespace_split] -
    lengths(strsplit(
      trimws(teaching$item_text[!teaching$length_matches_whitespace_split]),
      "[[:space:]]+"
    )) == 1L)
)

dir.create(output_directory, recursive = TRUE, showWarnings = FALSE)
output_path <- file.path(output_directory, "tanaka-selection.csv")
write_csv_stable(teaching, output_path)

# Preserve one actual selected MRS so a later note can define the object that
# becomes observed after selection.  This is illustrative representation data,
# not an observation for the coverage model.
example_profile <- profiles[[1]]
example_directory <- file.path(gold_directory, example_profile)
example_preferences <- read_tsdb_relation(example_directory, "preference")
example_results <- read_tsdb_relation(example_directory, "result")
example_items <- read_tsdb_relation(example_directory, "item")
example_parses <- read_tsdb_relation(example_directory, "parse")
example_parse_id <- example_preferences[["parse-id"]][[1]]
example_result_id <- example_preferences[["result-id"]][[1]]
example_result <- example_results[
  example_results[["parse-id"]] == example_parse_id &
    example_results[["result-id"]] == example_result_id,
]
example_parse <- example_parses[example_parses[["parse-id"]] == example_parse_id,]
example_item <- example_items[
  example_items[["i-id"]] == example_parse[["i-id"]][[1]],
]
stopifnot(nrow(example_result) == 1L, nrow(example_item) == 1L)
example <- data.frame(
  profile = example_profile,
  item_id = as.integer(example_item[["i-id"]]),
  item_text = example_item[["i-input"]],
  selected_result_id = as.integer(example_result_id),
  mrs = example_result[["mrs"]],
  stringsAsFactors = FALSE
)
example_path <- file.path(output_directory, "selected-mrs-example.csv")
write_csv_stable(example, example_path)

license_path <- file.path(output_directory, "LICENSE-MIT.txt")
if (!file.copy(file.path(source_directory, "LICENSE"), license_path, overwrite = TRUE)) {
  stop("Could not preserve the pinned Jacy license.")
}

source_files <- c(
  "LICENSE",
  "README.md",
  "METADATA",
  unlist(lapply(profiles, function(profile) {
    file.path("tsdb", "gold", profile, c("relations", "item", "parse", "preference", "result"))
  }))
)
source_checksums <- lapply(source_files, function(relative_path) {
  list(path = relative_path, sha256 = sha256_file(file.path(source_directory, relative_path)))
})

write_json_stable(
  list(
    dataset = "Jacy treebanked Tanaka profiles tc-006 through tc-015",
    source_repository = "https://github.com/delph-in/jacy",
    source_commit = commit,
    source_archive = archive_url,
    source_archive_sha256 = archive_sha256,
    license = "MIT",
    license_file = "LICENSE-MIT.txt",
    preparation_script = "scripts/data-grounding/prepare_jacy_mrs.R",
    observation_unit = "Tanaka Japanese sentence item in one treebanked [incr tsdb()] profile",
    selection_definition = paste(
      "selected_analysis is true when the parse has one or more records in",
      "the release's preference relation; selected MRSs are grammar-derived",
      "results accepted during treebanking, not independent semantic labels"
    ),
    source_checksums = source_checksums,
    summary = list(
      items = nrow(teaching),
      selected_items = sum(teaching$selected_analysis),
      preference_records = sum(teaching$preferred_analysis_count),
      items_with_multiple_preferred_analyses = sum(teaching$preferred_analysis_count > 1L),
      parsed_unselected_items = sum(teaching$coverage_state == "parsed_unselected"),
      no_positive_reading_items =
        sum(teaching$coverage_state == "no_positive_reading"),
      zero_reading_items = sum(teaching$parse_readings == 0L),
      negative_one_reading_sentinel_items = sum(teaching$parse_readings == -1L),
      item_length_min = min(teaching$item_length),
      item_length_max = max(teaching$item_length),
      length_whitespace_split_disagreements =
        sum(!teaching$length_matches_whitespace_split)
    ),
    outputs = list(
      list(
        file = "tanaka-selection.csv",
        rows = nrow(teaching),
        sha256 = sha256_file(output_path)
      ),
      list(
        file = "selected-mrs-example.csv",
        rows = nrow(example),
        sha256 = sha256_file(example_path)
      )
    )
  ),
  file.path(output_directory, "provenance.json")
)

cat(
  "Prepared", nrow(teaching), "Jacy/Tanaka items:",
  sum(teaching$selected_analysis), "selected items and",
  sum(teaching$preferred_analysis_count), "preference records.\n"
)
