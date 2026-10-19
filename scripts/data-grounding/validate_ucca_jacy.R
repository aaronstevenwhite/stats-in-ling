#!/usr/bin/env Rscript

ucca_path <- "data/ucca-french-english/passage-counts.csv"
jacy_path <- "data/jacy-mrs/tanaka-selection.csv"
mrs_example_path <- "data/jacy-mrs/selected-mrs-example.csv"

ucca <- utils::read.csv(
  ucca_path,
  stringsAsFactors = FALSE,
  check.names = FALSE
)
required_ucca <- c(
  "pair_id", "chapter", "pair_position_in_chapter",
  "legacy_passage_id", "language", "release_passage_id",
  "terminal_count", "word_count", "foundational_node_count",
  "primary_edge_count", "remote_edge_count", "implicit_node_count",
  "discontiguous_node_count", "scene_count",
  "scene_count_primary_main_relation", "implicit_scene_count",
  "participant_primary_edge_count", "participant_remote_edge_count",
  "adverbial_primary_edge_count", "adverbial_remote_edge_count"
)
stopifnot(
  identical(names(ucca), required_ucca),
  nrow(ucca) == 308L,
  setequal(ucca$language, c("en", "fr")),
  length(unique(ucca$pair_id)) == 154L,
  all(table(ucca$pair_id) == 2L),
  !anyDuplicated(ucca[c("pair_id", "language")])
)

english <- ucca[ucca$language == "en",]
french <- ucca[ucca$language == "fr",]
english <- english[order(english$pair_id),]
french <- french[order(french$pair_id),]
stopifnot(identical(english$pair_id, french$pair_id))

stopifnot(
  sum(english$terminal_count) == 12638L,
  sum(french$terminal_count) == 13021L,
  sum(english$word_count) == 10812L,
  sum(french$word_count) == 11037L,
  sum(english$scene_count) == 1839L,
  sum(french$scene_count) == 2121L,
  sum(english$remote_edge_count) == 824L,
  sum(french$remote_edge_count) == 1011L,
  sum(english$implicit_node_count) == 316L,
  sum(french$implicit_node_count) == 290L,
  sum(english$discontiguous_node_count) == 174L,
  sum(french$discontiguous_node_count) == 229L
)

scene_difference <- french$scene_count - english$scene_count
delta_aligned <- mean(abs(scene_difference))
mean_signed_difference <- mean(scene_difference)
stopifnot(
  isTRUE(all.equal(delta_aligned, 320 / 154, tolerance = 1e-12)),
  isTRUE(all.equal(mean_signed_difference, 282 / 154, tolerance = 1e-12))
)

set.seed(20261018)
repaired <- replicate(
  9999L,
  mean(abs(sample(french$scene_count) - english$scene_count))
)
lower_tail_fraction <- (1 + sum(repaired <= delta_aligned)) / 10000
stopifnot(
  isTRUE(all.equal(mean(repaired), 8.503263, tolerance = 1e-6)),
  lower_tail_fraction == 0.0001
)

jacy <- utils::read.csv(
  jacy_path,
  stringsAsFactors = FALSE,
  check.names = FALSE
)
required_jacy <- c(
  "profile", "item_id", "item_text", "item_length",
  "length_matches_whitespace_split", "item_wellformedness",
  "parse_readings", "parser_message", "preferred_analysis_count",
  "selected_analysis", "coverage_state"
)
stopifnot(
  identical(names(jacy), required_jacy),
  nrow(jacy) == 15000L,
  length(unique(jacy$profile)) == 10L,
  all(table(jacy$profile) == 1500L),
  !anyDuplicated(jacy[c("profile", "item_id")]),
  sum(jacy$selected_analysis) == 8670L,
  sum(jacy$preferred_analysis_count) == 9128L,
  sum(jacy$preferred_analysis_count > 1L) == 333L,
  sum(pmax(jacy$preferred_analysis_count - 1L, 0L)) == 458L,
  sum(jacy$coverage_state == "parsed_unselected") == 3666L,
  sum(jacy$coverage_state == "no_positive_reading") == 2664L,
  sum(jacy$parse_readings == 0L) == 2346L,
  sum(jacy$parse_readings == -1L) == 318L,
  sum(jacy$parser_message) == 513L,
  sum(!jacy$length_matches_whitespace_split) == 3L,
  min(jacy$item_length) == 2L,
  max(jacy$item_length) == 55L
)

jacy$profile <- factor(jacy$profile)
profile_model <- stats::glm(
  selected_analysis ~ profile,
  data = jacy,
  family = stats::binomial()
)
length_model <- stats::glm(
  selected_analysis ~ scale(item_length) + profile,
  data = jacy,
  family = stats::binomial()
)
quadratic_model <- stats::glm(
  selected_analysis ~ poly(item_length, 2, raw = TRUE) + profile,
  data = jacy,
  family = stats::binomial()
)
standardized_length_coefficient <- stats::coef(length_model)[[2]]
length_deviance_gain <- stats::deviance(profile_model) - stats::deviance(length_model)
quadratic_deviance_gain <- stats::deviance(length_model) - stats::deviance(quadratic_model)
stopifnot(
  isTRUE(all.equal(mean(jacy$selected_analysis), 0.578, tolerance = 1e-12)),
  isTRUE(all.equal(standardized_length_coefficient, -0.6448397, tolerance = 1e-6)),
  isTRUE(all.equal(length_deviance_gain, 1220.319, tolerance = 1e-3)),
  isTRUE(all.equal(quadratic_deviance_gain, 51.07106, tolerance = 1e-4))
)

mrs_example <- utils::read.csv(
  mrs_example_path,
  stringsAsFactors = FALSE,
  check.names = FALSE
)
stopifnot(
  nrow(mrs_example) == 1L,
  mrs_example$profile == "tc-006",
  mrs_example$item_id == 109000L,
  grepl("RELS:", mrs_example$mrs, fixed = TRUE),
  grepl("HCONS:", mrs_example$mrs, fixed = TRUE)
)

cat(
  "UCCA: 154 pairs; aligned Scene MAD =",
  format(round(delta_aligned, 3), nsmall = 3),
  "; repaired mean =", format(round(mean(repaired), 3), nsmall = 3),
  "; descriptive lower-tail fraction =", lower_tail_fraction, "\n"
)
cat(
  "Jacy: 15,000 items; 8,670 selected; standardized length coefficient =",
  format(round(standardized_length_coefficient, 3), nsmall = 3), "\n"
)
