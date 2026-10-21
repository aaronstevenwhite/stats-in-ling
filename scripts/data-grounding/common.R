sha256_file <- function(path) {
  if (!file.exists(path)) {
    stop("Missing file: ", path)
  }
  if (!requireNamespace("digest", quietly = TRUE)) {
    stop("Install the digest package to verify source files.")
  }
  unname(digest::digest(path, algo = "sha256", file = TRUE))
}

assert_sha256 <- function(path, expected) {
  observed <- sha256_file(path)
  if (!identical(observed, expected)) {
    stop(
      "Checksum mismatch for ", path, ": expected ", expected,
      ", observed ", observed
    )
  }
  invisible(observed)
}

assert_columns <- function(data, expected, exact = FALSE) {
  missing <- setdiff(expected, names(data))
  if (length(missing)) {
    stop("Missing required columns: ", paste(missing, collapse = ", "))
  }
  if (exact && !identical(names(data), expected)) {
    stop("Column order or names differ from the frozen schema.")
  }
  invisible(TRUE)
}

write_csv_stable <- function(data, path) {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  temporary <- paste0(path, ".tmp")
  utils::write.csv(
    data,
    temporary,
    row.names = FALSE,
    na = "",
    fileEncoding = "UTF-8",
    quote = TRUE
  )
  if (!file.rename(temporary, path)) {
    stop("Could not move prepared data into place: ", path)
  }
  invisible(path)
}

write_json_stable <- function(value, path) {
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("Install the jsonlite package to write provenance records.")
  }
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  temporary <- paste0(path, ".tmp")
  jsonlite::write_json(
    value,
    temporary,
    pretty = TRUE,
    auto_unbox = TRUE,
    digits = NA
  )
  cat("\n", file = temporary, append = TRUE)
  if (!file.rename(temporary, path)) {
    stop("Could not move provenance record into place: ", path)
  }
  invisible(path)
}

script_argument <- function(position, default) {
  arguments <- commandArgs(trailingOnly = TRUE)
  if (length(arguments) >= position && nzchar(arguments[[position]])) {
    arguments[[position]]
  } else {
    default
  }
}
