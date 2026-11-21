# Optional: run from the extracted assignment directory.
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 1L) stop("Pass at most one local source-repository path.")
if (!requireNamespace("digest", quietly = TRUE))
  stop('Install digest first: install.packages("digest").')
commit <- "556fe1be0d7f9a00d507875ed3327055a6d93fb6"
read_source <- function(name, sha256) {
  if (length(args)) path <- file.path(args[1], "data", name)
  else {
    path <- tempfile(fileext = ".csv")
    on.exit(unlink(path), add = TRUE)
    url <- paste0("https://raw.githubusercontent.com/SuperMereo/aspect-is-not-fixed/",
                  commit, "/data/", name)
    download.file(url, path, mode = "wb")
  }
  if (digest::digest(file = path, algo = "sha256") != sha256)
    stop("Source checksum mismatch for ", name, ". Use the revision in data/README.md.")
  x <- read.csv(path, stringsAsFactors = FALSE)
  x[x$contentfulness == "contentful" & x$clause_type == "episodic", ]
}
cloze <- read_source("data-cloze.csv",
  "3156f34a0e5be698ff15be34b52fbd63e9e96b43f97d0479efee309ff0a82754")
overlap <- read_source("data-proportion.csv",
  "b6f1d1a0efe0eba901b54b8fe6de7b3784eeebc08df56ae010be6e12c2ef01db")
metadata <- unique(rbind(
  cloze[c("sentence", "verb", "verb_type", "propbank_sense", "concreteness")],
  overlap[c("sentence", "verb", "verb_type", "propbank_sense", "concreteness")]))
metadata <- metadata[order(metadata$sentence, method = "radix"), ]
stopifnot(!anyDuplicated(metadata$sentence))
metadata$roleset <- sub(":.*", "", metadata$propbank_sense)
sense_label <- paste(metadata$roleset, metadata$concreteness, sep = "_")
sense_levels <- sort(unique(sense_label), method = "radix")
metadata$sense_id <- sprintf("g%03d", match(sense_label, sense_levels))
metadata$sentence_id <- sprintf("s%03d", seq_len(nrow(metadata)))
metadata <- metadata[c("sentence_id", "sentence", "verb", "verb_type",
                       "sense_id", "roleset", "concreteness")]
people <- sort(unique(c(cloze$participant, overlap$participant)), method = "radix")
adapt <- function(x, task) {
  data.frame(
    participant = sprintf("p%03d", match(x$participant, people)),
    sentence_id = metadata$sentence_id[match(x$sentence, metadata$sentence)],
    block = if (task == "cloze") rep("cloze", nrow(x)) else paste0("overlap_", x$preposition),
    category = if (task == "cloze") x$preposition else as.character(x$response),
    stringsAsFactors = FALSE)
}
responses <- rbind(adapt(cloze, "cloze"), adapt(overlap, "overlap"))
stopifnot(nrow(responses) == 4560, nrow(metadata) == 166,
          length(unique(metadata$verb)) == 40,
          length(unique(metadata$sense_id)) == 83,
          all(table(metadata$sense_id) == 2), !anyNA(responses))
dir.create("data", showWarnings = FALSE)
write.csv(responses, "data/aspect-responses.csv", row.names = FALSE)
write.csv(metadata, "data/aspect-sentences.csv", row.names = FALSE)
cat("Wrote", nrow(responses), "responses and", nrow(metadata), "sentences under data/.\n")
