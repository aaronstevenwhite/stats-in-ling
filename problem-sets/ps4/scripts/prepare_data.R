# Run from the extracted ps4-assignment directory.
# Optional argument: a local clone of the authors' source repository.
args <- commandArgs(trailingOnly = TRUE)
commit <- "e4b672a3068820458f42dfb7a4b70d417a887bc5"
source_file <- function(path, checksum) {
  if (length(args)) {
    file <- file.path(args[1], path)
  } else {
    file <- tempfile(fileext = ".csv")
    url <- paste0("https://raw.githubusercontent.com/judith-tonhauser/projective-probability/", commit, "/", path)
    download.file(url, file, mode = "wb")
  }
  stopifnot(digest::digest(file = file, algo = "sha256") == checksum)
  x <- read.csv(file, stringsAsFactors = FALSE)
  x[x$trigger_class != "control", ]
}
binary <- source_file("results/8-projectivity-no-fact-binary/data/cd.csv",
  "abdab939580489843bffa1c882d19be47230b14722cd560aa2b680a38aa5b201")
slider <- source_file("results/3-projectivity/data/cd.csv",
  "ae335e5706fd25203e24a835eedbbdd08fe4534d7a6b82ed344d08451678699c")
contents <- sort(unique(slider$content), method = "radix")
content_id <- setNames(sprintf("c%02d", seq_along(contents)), contents)
nr_id <- setNames(content_id[slider$content], slider$contentNr)
anonymize <- function(ids, prefix) {
  labels <- sort(unique(ids))
  setNames(sprintf(paste0(prefix, "%03d"), seq_along(labels)), labels)[as.character(ids)]
}
choice <- data.frame(participant = unname(anonymize(binary$workerid, "b")),
                     content = unname(nr_id[as.character(binary$contentNr)]),
                     predicate = binary$verb, yes = as.integer(binary$response == "Yes"))
rating <- data.frame(participant = unname(anonymize(slider$workerid, "p")),
                     content = unname(content_id[slider$content]),
                     predicate = slider$verb, prior_condition = slider$fact_type,
                     rating = slider$response)
complement <- gsub("&quotechars", "'s", contents, fixed = TRUE)
complement <- gsub("&quotechart", "'t", complement, fixed = TRUE)
crosswalk <- data.frame(content = unname(content_id), complement = complement)
stopifnot(nrow(choice) == 8720, nrow(rating) == 5320,
          !anyNA(choice), !anyNA(rating), length(unique(choice$participant)) == 436,
          length(unique(rating$participant)) == 266,
          sum(rating$rating == 0) == 643, sum(rating$rating == 1) == 219)
dir.create("data", showWarnings = FALSE)
write.csv(choice, "data/inference-choices.csv", row.names = FALSE)
write.csv(rating, "data/projection-ratings.csv", row.names = FALSE)
write.csv(crosswalk, "data/contents.csv", row.names = FALSE)
