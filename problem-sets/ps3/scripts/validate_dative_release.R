items <- read.csv("problem-sets/ps3/data/dative-alternation.csv")

items$pp <- as.integer(items$recipient_realization == "PP")
items$relative_log_length <-
  log(items$theme_length_words) - log(items$recipient_length_words)

factor_levels <- list(
  modality = c("spoken", "written"),
  semantic_class = c("a", "c", "f", "p", "t"),
  recipient_accessibility = c("accessible", "given", "new"),
  theme_accessibility = c("accessible", "given", "new"),
  recipient_pronominality = c("nonpronominal", "pronominal"),
  theme_pronominality = c("nonpronominal", "pronominal"),
  recipient_animacy = c("animate", "inanimate")
)

for (variable in names(factor_levels)) {
  items[[variable]] <- factor(items[[variable]], levels = factor_levels[[variable]])
}

stopifnot(
  nrow(items) == 3263L,
  length(unique(items$verb)) == 75L,
  sum(items$pp) == 849L,
  !anyNA(items$pp),
  !anyNA(items$relative_log_length)
)

scm_formula <- pp ~
  relative_log_length + modality + semantic_class

ham_formula <- update(
  scm_formula,
  . ~ . + recipient_accessibility + theme_accessibility +
    recipient_pronominality + theme_pronominality + recipient_animacy
)

scm <- glm(scm_formula, family = binomial, data = items)
ham <- glm(ham_formula, family = binomial, data = items)

expected_signs <- c(
  relative_log_length = -1,
  recipient_accessibilitygiven = -1,
  recipient_accessibilitynew = 1,
  theme_accessibilitygiven = 1,
  theme_accessibilitynew = -1,
  recipient_pronominalitypronominal = -1,
  theme_pronominalitypronominal = 1,
  recipient_animacyinanimate = 1
)

stopifnot(
  isTRUE(scm$converged),
  isTRUE(ham$converged),
  all(sign(coef(ham)[names(expected_signs)]) == expected_signs)
)

profiles <- data.frame(
  profile = c("NP-aligned", "PP-aligned"),
  relative_log_length = 0,
  modality = factor("spoken", levels = factor_levels$modality),
  semantic_class = factor("t", levels = factor_levels$semantic_class),
  recipient_accessibility = factor(
    c("given", "new"), levels = factor_levels$recipient_accessibility
  ),
  theme_accessibility = factor(
    c("new", "given"), levels = factor_levels$theme_accessibility
  ),
  recipient_pronominality = factor(
    c("pronominal", "nonpronominal"),
    levels = factor_levels$recipient_pronominality
  ),
  theme_pronominality = factor(
    c("nonpronominal", "pronominal"),
    levels = factor_levels$theme_pronominality
  ),
  recipient_animacy = factor(
    c("animate", "inanimate"), levels = factor_levels$recipient_animacy
  )
)
profiles$pp_probability <- predict(ham, profiles, type = "response")

support_columns <- c(
  "modality",
  "semantic_class",
  "recipient_accessibility",
  "theme_accessibility",
  "recipient_pronominality",
  "theme_pronominality",
  "recipient_animacy"
)

count_profile_matches <- function(profile_row, columns, require_equal_length) {
  matches <- rep(TRUE, nrow(items))
  for (variable in columns) {
    matches <- matches &
      as.character(items[[variable]]) == as.character(profile_row[[variable]])
  }
  if (require_equal_length) {
    matches <- matches & items$relative_log_length == 0
  }
  sum(matches)
}

exact_profile_support <- vapply(
  seq_len(nrow(profiles)),
  function(i) count_profile_matches(profiles[i, ], support_columns, TRUE),
  integer(1)
)

accessibility_intervention <- profiles[profiles$profile == "NP-aligned", ]
accessibility_intervention <- accessibility_intervention[rep(1, 2), ]
accessibility_intervention$recipient_accessibility <- factor(
  c("given", "new"), levels = factor_levels$recipient_accessibility
)
accessibility_intervention$pp_probability <- predict(
  ham, accessibility_intervention, type = "response"
)

verb_levels <- unique(items$verb)
verb_scores <- do.call(
  rbind,
  lapply(verb_levels, function(held_out_verb) {
    test <- items$verb == held_out_verb
    train <- !test
    scm_fold <- glm(scm_formula, family = binomial, data = items[train, ])
    ham_fold <- glm(ham_formula, family = binomial, data = items[train, ])
    scm_prediction <- predict(scm_fold, items[test, ], type = "response")
    ham_prediction <- predict(ham_fold, items[test, ], type = "response")
    data.frame(
      verb = held_out_verb,
      n = sum(test),
      scm_brier = mean((items$pp[test] - scm_prediction)^2),
      ham_brier = mean((items$pp[test] - ham_prediction)^2)
    )
  })
)

aggregate_scores <- data.frame(
  model = c("SCM", "HAM"),
  brier = c(
    weighted.mean(verb_scores$scm_brier, verb_scores$n),
    weighted.mean(verb_scores$ham_brier, verb_scores$n)
  )
)

stopifnot(
  profiles$pp_probability[profiles$profile == "NP-aligned"] < .20,
  profiles$pp_probability[profiles$profile == "PP-aligned"] > .80,
  identical(exact_profile_support, c(41L, 1L)),
  diff(aggregate_scores$brier) < -.015,
  mean(verb_scores$ham_brier < verb_scores$scm_brier) >= .60,
  verb_scores$ham_brier[verb_scores$verb == "tell"] >
    verb_scores$scm_brier[verb_scores$verb == "tell"]
)

cat("Rows:", nrow(items), "\n")
cat("Verb types:", length(verb_levels), "\n")
cat("PP responses:", sum(items$pp), "\n")
cat("HAM converged:", ham$converged, "\n")
cat("Focal coefficient signs:\n")
print(round(coef(ham)[names(expected_signs)], 4))
cat("Profile probabilities:\n")
print(profiles[c("profile", "pp_probability")], row.names = FALSE)
cat("Exact profile support:\n")
print(
  data.frame(profile = profiles$profile, tokens = exact_profile_support),
  row.names = FALSE
)
cat("Accessibility intervention:\n")
print(
  accessibility_intervention[
    c("recipient_accessibility", "pp_probability")
  ],
  row.names = FALSE
)
cat(
  "Accessibility difference:",
  round(diff(accessibility_intervention$pp_probability), 6),
  "\n"
)
cat("Token-weighted Brier losses:\n")
print(aggregate_scores, row.names = FALSE)
cat(
  "Proportion of verbs improved:",
  round(mean(verb_scores$ham_brier < verb_scores$scm_brier), 4),
  "\n"
)
cat("tell losses:\n")
print(verb_scores[verb_scores$verb == "tell", ], row.names = FALSE)
cat("Release validation passed.\n")
