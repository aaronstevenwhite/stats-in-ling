# Draw ordered beta replications while retaining the generated response region.
# R's beta RNG may round an interior draw to an exact endpoint. Endpoint checks
# must use the sampled region, not equality tests on those rounded draws.
ordered_beta_replications <- function(fit, ndraws = 400, seed = 486) {
  set.seed(seed)
  all_draws <- posterior::as_draws_df(fit)
  ids <- sort(sample.int(nrow(all_draws), ndraws))
  # brms returns selected draws in their original order; use the same order here.
  draws <- all_draws[ids, ]
  eta <- brms::posterior_linpred(fit, draw_ids = ids, transform = FALSE)
  lower <- draws$cutzero
  upper <- lower + exp(draws$cutone)
  p_zero <- plogis(lower - eta)
  p_one <- plogis(eta - upper)
  stopifnot(all(is.finite(p_zero)), all(is.finite(p_one)),
            all(p_zero + p_one < 1), all(draws$phi > 0))
  u <- matrix(runif(length(eta)), nrow = nrow(eta))
  zero <- u < p_zero
  one <- u > 1 - p_one
  # Compute both inverse logits directly, avoiding cancellation in 1 - plogis(eta).
  shape_one <- plogis(eta) * draws$phi
  shape_two <- plogis(-eta) * draws$phi
  value <- matrix(rbeta(length(eta), shape_one, shape_two), nrow = nrow(eta))
  value[zero] <- 0
  value[one] <- 1
  stopifnot(all(is.finite(value)), all(value >= 0 & value <= 1), !any(zero & one))
  list(rating = value, zero = zero, one = one, draw_ids = ids)
}
