data {
  int D;
  int N;
  matrix[N,D] X;
  array[N] int<lower=0, upper=1> Y;
}

parameters {
  vector[D] b;
}

transformed parameters {
  vector[N] mu = X*b;
}

model {
  b[1:D] ~ student_t(6, 0, 5);
  Y[1:N] ~ bernoulli_logit(mu[1:N]);
}

generated quantities {
  array[N] int yp = bernoulli_rng(inv_logit(mu[1:N]));
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = bernoulli_logit_lpmf(Y[n] | mu[n]);
  }
}
