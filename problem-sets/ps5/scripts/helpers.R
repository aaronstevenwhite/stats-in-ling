# Count construction, posterior prediction, and sampling checks for the notebook.
blocks <- list(cloze = 1:2, overlap_for = 3:7, overlap_in = 8:12)
category_names <- c("cloze:for", "cloze:in",
                    paste0("overlap_for:", 0:4), paste0("overlap_in:", 0:4))
counts_for <- function(rows, sentences) {
  out <- matrix(0L, nrow(sentences), 12,
                dimnames = list(sentences$sentence_id, category_names))
  i <- match(rows$sentence_id, sentences$sentence_id)
  j <- match(paste(rows$block, rows$category, sep = ":"), category_names)
  stopifnot(!anyNA(i), !anyNA(j))
  for (r in seq_len(nrow(rows))) out[i[r], j[r]] <- out[i[r], j[r]] + 1L
  out
}
group_counts <- function(counts, labels) {
  grouped <- rowsum(counts, labels, reorder = TRUE)
  list(counts = grouped, index = match(labels, rownames(grouped)),
       labels = rownames(grouped))
}
compile_template <- function(path) {
  code <- paste(readLines(path, warn = FALSE), collapse = "\n")
  if (grepl("___", code, fixed = TRUE))
    stop("Complete the numbered blanks in ", path, " before compiling.")
  dir.create("stan_cache", showWarnings = FALSE)
  file <- cmdstanr::write_stan_file(code, dir = "stan_cache")
  cmdstanr::cmdstan_model(file)
}
sample_cached <- function(program, data, label, seed, warmup = 1000,
                          sampling = 1000, adapt_delta = .95, max_treedepth = 12) {
  settings <- list(seed = seed, chains = 4, warmup = warmup, sampling = sampling,
                   adapt_delta = adapt_delta, max_treedepth = max_treedepth,
                   sig_figs = 18)
  key <- digest::digest(list(code = program$code(), data = data, settings = settings),
                        algo = "sha256")
  dir.create("stan_cache", showWarnings = FALSE)
  path <- file.path("stan_cache", paste0(label, "-", substr(key, 1, 16), ".rds"))
  if (file.exists(path)) return(readRDS(path))
  fit <- program$sample(data = data, seed = seed, chains = 4, parallel_chains = 4,
                       iter_warmup = warmup, iter_sampling = sampling,
                       adapt_delta = adapt_delta, max_treedepth = max_treedepth,
                       sig_figs = 18, refresh = 0, output_dir = "stan_cache")
  fit$save_object(path)
  fit
}
check_fit <- function(entry) {
  variables <- c("theta_for", "theta_in", if (entry$kind == "varying") "w")
  summary <- entry$fit$summary(variables = variables)
  sampler <- entry$fit$diagnostic_summary()
  result <- data.frame(max_rhat = max(summary$rhat),
                       min_bulk_ess = min(summary$ess_bulk),
                       min_tail_ess = min(summary$ess_tail),
                       divergences = sum(sampler$num_divergent),
                       depth_hits = sum(sampler$num_max_treedepth),
                       min_ebfmi = min(sampler$ebfmi))
  stopifnot(all(is.finite(as.matrix(result))),
            result$max_rhat < 1.01, result$min_bulk_ess > 400,
            result$min_tail_ess > 400, result$divergences == 0,
            result$depth_hits == 0, result$min_ebfmi > .3)
  result
}
state_draws <- function(entry, ndraws = 400) {
  variables <- c("response_prob", if (entry$kind == "fixed") "p_telic" else "w")
  x <- unclass(posterior::as_draws_matrix(entry$fit$draws(variables = variables)))
  ids <- unique(round(seq(1, nrow(x), length.out = min(ndraws, nrow(x)))))
  x <- x[ids, , drop = FALSE]
  theta <- array(NA_real_, c(nrow(x), 2, 12))
  for (k in 1:2) for (j in 1:12)
    theta[, k, j] <- x[, sprintf("response_prob[%d,%d]", k, j)]
  # Restore the simplex after reading probabilities rounded in a CSV file.
  for (k in 1:2) for (b in blocks) {
    total <- rowSums(matrix(theta[, k, b], nrow = nrow(x)))
    stopifnot(all(is.finite(total)), max(abs(total - 1)) < 1e-4)
    for (j in b) theta[, k, j] <- theta[, k, j] / total
  }
  prefix <- if (entry$kind == "fixed") "p_telic" else "w"
  nunit <- if (entry$kind == "fixed") length(entry$group$labels) else length(entry$group$index)
  weights <- x[, sprintf("%s[%d]", prefix, seq_len(nunit)), drop = FALSE]
  list(theta = theta, weights = weights, index = entry$group$index, draw_ids = ids)
}
predict_probabilities <- function(entry, ndraws = Inf) {
  draws <- state_draws(entry, ndraws)
  q <- matrix(0, length(draws$index), 12)
  for (d in seq_len(nrow(draws$weights))) {
    w <- draws$weights[d, draws$index]
    # Average each draw's product, retaining posterior dependence.
    q <- q + (1 - w) %o% draws$theta[d, 1, ] + w %o% draws$theta[d, 2, ]
  }
  q <- q / nrow(draws$weights)
  colnames(q) <- category_names
  stopifnot(all(q > 0), all(q < 1),
            all(vapply(blocks, function(b) max(abs(rowSums(q[, b]) - 1)), 0.0) < 1e-10))
  q
}
predictive_scores <- function(counts, q) {
  stopifnot(identical(dim(counts), dim(q)))
  average_log <- function(b) sum(counts[, b] * log(q[, b])) / sum(counts[, b])
  c(overall = average_log(1:12), vapply(blocks, average_log, 0.0),
    cloze_brier = sum(counts[, 1] * q[, 2]^2 +
                       counts[, 2] * (1 - q[, 2])^2) / sum(counts[, 1:2]))
}
replicate_counts <- function(entry, counts, ndraws = 400, seed = 587) {
  set.seed(seed)
  draws <- state_draws(entry, ndraws)
  out <- array(0L, c(nrow(draws$weights), nrow(counts), 12))
  for (d in seq_len(nrow(draws$weights))) {
    if (entry$kind == "fixed") {
      # One state per group, reused for all its sentences and diagnostic blocks.
      group_state <- rbinom(ncol(draws$weights), 1, draws$weights[d, ])
      w <- group_state[draws$index]
    } else {
      # Drawing counts from the mixed probabilities integrates a new state per response.
      w <- draws$weights[d, draws$index]
    }
    for (s in seq_len(nrow(counts))) for (b in blocks) {
      q <- (1 - w[s]) * draws$theta[d, 1, b] + w[s] * draws$theta[d, 2, b]
      out[d, s, b] <- rmultinom(1, sum(counts[s, b]), q)[, 1]
    }
  }
  out
}
cloze_check <- function(entry, counts, sentences, min_count = 4) {
  rep <- replicate_counts(entry, counts)
  total <- rowSums(counts[, 1:2])
  keep <- which(total >= min_count)
  observed <- counts[keep, 2] / total[keep]
  simulated <- sweep(rep[, keep, 2, drop = FALSE][, , 1], 2, total[keep], "/")
  limits <- apply(simulated, 2, quantile, c(.025, .5, .975))
  data.frame(sentences[keep, ], n = total[keep], observed = observed,
             lower = limits[1, ], median = limits[2, ], upper = limits[3, ],
             outside = observed < limits[1, ] | observed > limits[3, ])
}
row_probabilities <- function(rows, q, sentences) {
  i <- match(rows$sentence_id, sentences$sentence_id)
  j <- match(paste(rows$block, rows$category, sep = ":"), category_names)
  stopifnot(!anyNA(i), !anyNA(j))
  q[cbind(i, j)]
}
bootstrap_gain <- function(rows, q_baseline, q_candidate, sentences, seed = 588,
                           repetitions = 2000) {
  gain <- log(row_probabilities(rows, q_candidate, sentences)) -
    log(row_probabilities(rows, q_baseline, sentences))
  units <- split(gain, rows$participant)
  sums <- vapply(units, sum, 0.0)
  sizes <- lengths(units)
  set.seed(seed)
  replicate(repetitions, {
    sample <- sample.int(length(units), length(units), replace = TRUE)
    sum(sums[sample]) / sum(sizes[sample])
  })
}
