#!/usr/bin/env Rscript

source("scripts/data-grounding/common.R")

path <- "data/turkish-propbank/role-agreement-judgments.csv"
assert_sha256(path, "fda552ea364a77fc8dee930112223638601b2d4e90135005693b996dd1e40f70")

data <- utils::read.csv(path, check.names = FALSE, stringsAsFactors = FALSE)
expected_columns <- c(
  "item_id",
  "worker_id",
  "judgment_index",
  "predicate_lemma",
  "sense_id",
  "adjudicated_label",
  "role_group",
  "selected_role_description",
  "adjudicated_role_description",
  "correct"
)
assert_columns(data, expected_columns, exact = TRUE)

prohibited_columns <- c(
  "_worker_id", "_ip", "_country", "_region", "_city",
  "_created_at", "_started_at", "_last_judgment_at",
  "external_id", "last_ip", "email", "hata", "hata2",
  "sent", "sentence", "farg"
)
stopifnot(
  !any(prohibited_columns %in% names(data)),
  nrow(data) == 55207L,
  length(unique(data$item_id)) == 18306L,
  length(unique(data$worker_id)) == 144L,
  all(grepl("^item_[0-9]{5}$", data$item_id)),
  all(grepl("^worker_[0-9]{3}$", data$worker_id)),
  setequal(unique(data$correct), 0:1),
  sum(data$correct) == 46078L,
  identical(
    unname(sort(as.integer(table(data$role_group)))),
    unname(sort(c(16112L, 36672L, 2252L, 171L)))
  )
)

analysis <- subset(data, role_group %in% c("core", "adjunct"))
analysis$role_group <- stats::relevel(factor(analysis$role_group), ref = "core")
raw <- stats::aggregate(
  correct ~ role_group,
  analysis,
  function(values) c(n = length(values), correct = sum(values), probability = mean(values))
)
stopifnot(
  nrow(analysis) == 52784L,
  length(unique(analysis$item_id)) == 17502L,
  length(unique(analysis$worker_id)) == 144L,
  sum(analysis$role_group == "core") == 36672L,
  sum(analysis$role_group == "adjunct") == 16112L,
  sum(analysis$correct[analysis$role_group == "core"]) == 33008L,
  sum(analysis$correct[analysis$role_group == "adjunct"]) == 11660L
)

if (!requireNamespace("lme4", quietly = TRUE)) {
  stop("Install lme4 to validate the crossed-effects pilot.")
}
control <- lme4::glmerControl(
  optimizer = "bobyqa",
  optCtrl = list(maxfun = 200000)
)
baseline <- lme4::glmer(
  correct ~ 1 + (1 | item_id) + (1 | worker_id),
  data = analysis,
  family = stats::binomial(),
  control = control
)
role_model <- lme4::glmer(
  correct ~ role_group + (1 | item_id) + (1 | worker_id),
  data = analysis,
  family = stats::binomial(),
  control = control
)
comparison <- stats::anova(baseline, role_model, test = "Chisq")
coefficient <- unname(lme4::fixef(role_model)["role_groupadjunct"])
fitted_core <- unname(stats::plogis(lme4::fixef(role_model)["(Intercept)"]))
fitted_adjunct <- unname(stats::plogis(sum(lme4::fixef(role_model))))

stopifnot(
  is.null(role_model@optinfo$conv$lme4$messages),
  !lme4::isSingular(role_model, tol = 1e-4),
  abs(coefficient - (-1.329326)) < 1e-5,
  comparison$Chisq[2] > 2000,
  fitted_core > fitted_adjunct,
  fitted_core > 0.85,
  fitted_adjunct < 0.70
)

cat("Raw agreement by role group:\n")
print(raw, row.names = FALSE)
cat("\nCrossed logistic role coefficient (adjunct versus core):\n")
print(coefficient)
cat("Fitted zero-random-effect probabilities (core, adjunct):\n")
print(c(core = fitted_core, adjunct = fitted_adjunct))
cat("Likelihood-ratio statistic for adding role group:\n")
print(comparison$Chisq[2])
cat("\nTurkish PropBank privacy and model checks passed.\n")
