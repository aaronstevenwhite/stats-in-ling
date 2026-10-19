#!/usr/bin/env Rscript

if (!requireNamespace("phonTools", quietly = TRUE)) {
  stop("Install phonTools 0.2.2.2 before using Peterson--Barney data.")
}
if (!identical(as.character(utils::packageVersion("phonTools")), "0.2.2.2")) {
  stop("Expected phonTools 0.2.2.2; found ", utils::packageVersion("phonTools"))
}

environment <- new.env(parent = emptyenv())
utils::data("pb52", package = "phonTools", envir = environment)
pb52 <- environment$pb52
expected <- c("type", "sex", "speaker", "vowel", "repetition", "f0", "f1", "f2", "f3")
stopifnot(
  is.data.frame(pb52),
  identical(dim(pb52), c(1520L, 9L)),
  identical(names(pb52), expected),
  length(unique(pb52$speaker)) == 76L,
  setequal(unique(pb52$repetition), 1:2),
  all(stats::complete.cases(pb52))
)

cat("Validated phonTools::pb52: 1,520 rows, 76 speakers, two repetitions.\n")
