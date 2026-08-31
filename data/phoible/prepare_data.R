archive_url <- paste0(
  "https://zenodo.org/records/2593234/files/",
  "cldf-datasets/phoible-v2.0.zip?download=1"
)
expected_md5 <- "b3de624b0a9e22787f040059bb6cd22e"
expected_sha256 <- "fb8247bb97b21aea5a482062692f82f13724e6ee53da64f233273f0a705adf0a"
output_path <- "data/phoible/phoible-pilot.rds"

sha256_file <- function(path) {
  if (nzchar(Sys.which("shasum"))) {
    output <- system2("shasum", c("-a", "256", path), stdout = TRUE)
  } else if (nzchar(Sys.which("sha256sum"))) {
    output <- system2("sha256sum", path, stdout = TRUE)
  } else {
    stop("Neither shasum nor sha256sum is available.")
  }
  strsplit(output[[1]], "[[:space:]]+")[[1]][[1]]
}

archive_path <- tempfile(fileext = ".zip")
extract_path <- tempfile(pattern = "phoible-v2.0-")
dir.create(extract_path)
on.exit(unlink(c(archive_path, extract_path), recursive = TRUE), add = TRUE)

utils::download.file(archive_url, archive_path, mode = "wb", quiet = FALSE)
observed_md5 <- unname(tools::md5sum(archive_path))
observed_sha256 <- sha256_file(archive_path)

stopifnot(
  identical(observed_md5, expected_md5),
  identical(observed_sha256, expected_sha256)
)

utils::unzip(archive_path, exdir = extract_path)
roots <- list.dirs(extract_path, recursive = FALSE, full.names = TRUE)
stopifnot(length(roots) == 1L)
cldf_path <- file.path(roots[[1]], "cldf")

values <- utils::read.csv(
  file.path(cldf_path, "values.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)
languages <- utils::read.csv(
  file.path(cldf_path, "languages.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)
parameters <- utils::read.csv(
  file.path(cldf_path, "parameters.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)
contributions <- utils::read.csv(
  file.path(cldf_path, "contributions.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)

stopifnot(
  nrow(values) == 105462L,
  nrow(contributions) == 3020L,
  nrow(languages) == 2186L,
  length(unique(values$Contribution_ID)) == 3020L,
  length(unique(values$Language_ID)) == 2186L
)

segment_metadata <- parameters[
  parameters$SegmentClass %in% c("consonant", "vowel"),
  c("ID", "Name", "Description", "SegmentClass")
]
names(segment_metadata) <- c(
  "segment_id", "segment", "description", "segment_class"
)

memberships <- values[
  values$Marginal != "true" &
    values$Parameter_ID %in% segment_metadata$segment_id,
  c("Contribution_ID", "Language_ID", "Parameter_ID")
]
names(memberships) <- c("inventory_id", "glottocode", "segment_id")
memberships <- unique(memberships)

inventory_sizes <- aggregate(
  segment_id ~ inventory_id + glottocode,
  data = memberships,
  FUN = length
)
names(inventory_sizes)[[3]] <- "n_segments"

inventory_metadata <- merge(
  contributions[c("ID", "Name", "Contributor_ID", "Source", "URL")],
  inventory_sizes,
  by.x = "ID",
  by.y = "inventory_id",
  all.y = TRUE,
  sort = FALSE
)
names(inventory_metadata)[1:5] <- c(
  "inventory_id", "inventory_name", "inventory_source",
  "bibliographic_source", "inventory_url"
)
inventory_metadata <- merge(
  inventory_metadata,
  languages[
    c(
      "ID", "Name", "Macroarea", "Latitude", "Longitude",
      "ISO639P3code", "Family_Glottocode", "Family_Name"
    )
  ],
  by.x = "glottocode",
  by.y = "ID",
  all.x = TRUE,
  sort = FALSE
)
names(inventory_metadata)[
  names(inventory_metadata) == "Name"
] <- "language_name"
names(inventory_metadata)[
  names(inventory_metadata) == "Macroarea"
] <- "macroarea"
names(inventory_metadata)[
  names(inventory_metadata) == "Latitude"
] <- "latitude"
names(inventory_metadata)[
  names(inventory_metadata) == "Longitude"
] <- "longitude"
names(inventory_metadata)[
  names(inventory_metadata) == "ISO639P3code"
] <- "iso639p3"
names(inventory_metadata)[
  names(inventory_metadata) == "Family_Glottocode"
] <- "family_glottocode"
names(inventory_metadata)[
  names(inventory_metadata) == "Family_Name"
] <- "family_name"

prepared <- list(
  provenance = list(
    title = "PHOIBLE 2.0",
    editors = "Steven Moran and Daniel McCloy",
    year = 2019L,
    doi = "10.5281/zenodo.2593234",
    archive_url = archive_url,
    md5 = observed_md5,
    sha256 = observed_sha256,
    archive_commit = "350563f179293254be2f92886d6fa8ba8e7cbbb2",
    license = "CC BY-SA 3.0",
    original_value_rows = nrow(values),
    original_inventories = nrow(contributions),
    original_glottocodes = nrow(languages)
  ),
  memberships = memberships,
  inventories = inventory_metadata,
  segments = segment_metadata
)

dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
saveRDS(prepared, output_path, version = 3)
cat("Wrote", output_path, "\n")
cat("Retained memberships:", nrow(memberships), "\n")
cat("Retained inventories:", nrow(inventory_metadata), "\n")
cat("Retained segments:", nrow(segment_metadata), "\n")
