data {
  int<lower=1> G;
  array[G, 12] int<lower=0> n;
  real<lower=0, upper=0.5> epsilon;
}
parameters {
  array[2] simplex[5] theta_for;
  array[2] simplex[5] theta_in;
}
transformed parameters {
  matrix[2, 12] response_prob;
  response_prob[1, 1] = 1 - epsilon;
  response_prob[1, 2] = ___; // F1: state 0, cloze in probability
  response_prob[2, 1] = epsilon;
  response_prob[2, 2] = ___; // F2: state 1, cloze in probability
  for (k in 1:2) {
    response_prob[k, 3:7] = theta_for[k]';
    response_prob[k, 8:12] = theta_in[k]';
  }
}
model {
  for (k in 1:2) {
    theta_for[k] ~ dirichlet(rep_vector(2.0, 5));
    theta_in[k] ~ dirichlet(rep_vector(2.0, 5));
  }
  for (g in 1:G) {
    vector[2] lp = rep_vector(log(0.5), 2);
    for (k in 1:2)
      for (j in 1:12)
        lp[k] += ___; // F3: count times one log response probability
    target += ___; // F4: sum over the two possible shared states
  }
}
generated quantities {
  vector[G] p_telic;
  vector[G] log_lik_group;
  for (g in 1:G) {
    vector[2] lp = rep_vector(log(0.5), 2);
    for (k in 1:2)
      for (j in 1:12)
        lp[k] += ___; // F3: count times one log response probability
    p_telic[g] = ___; // F5: normalize the state 1 joint contribution
    log_lik_group[g] = log_sum_exp(lp);
  }
}
