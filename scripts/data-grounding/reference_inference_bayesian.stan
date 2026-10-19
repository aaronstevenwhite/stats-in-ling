data {
  int<lower=1> N;
  vector[N] y;
  real<lower=0> prior_mu_sd;
  real<lower=0> prior_sigma_sd;
  real<lower=2> nu;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  mu ~ normal(0, prior_mu_sd);
  sigma ~ normal(0, prior_sigma_sd);
  y ~ student_t(nu, mu, sigma);
}

generated quantities {
  real geometric_duration_ratio = exp(mu);
  array[N] real y_rep;
  vector[N] log_lik;

  for (n in 1:N) {
    y_rep[n] = student_t_rng(nu, mu, sigma);
    log_lik[n] = student_t_lpdf(y[n] | nu, mu, sigma);
  }
}
