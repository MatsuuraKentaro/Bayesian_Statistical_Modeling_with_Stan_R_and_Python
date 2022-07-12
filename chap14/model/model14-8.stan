data {
  int G;
  int N;
  vector[N] Y;
  array[N] int n2g;
}

parameters {
  real mu_all;
  real<lower=0> s_mu;
  vector[G] mu;
  real<lower=0> s_y;
}

model {
  mu_all ~ student_t(6, 0, 10);
  s_mu  ~ student_t(6, 0, 10);
  mu[1:G] ~ normal(mu_all, s_mu);
  Y[1:N] ~ normal(mu[n2g], s_y);
}

generated quantities {
  array[G] real yp1 = normal_rng(mu[1:G], s_y);
  vector[N] log_lik1;
  real mup = normal_rng(mu_all, s_mu);
  real yp2 = normal_rng(mup, s_y);
  for (n in 1:N) {
    log_lik1[n] = normal_lpdf(Y[n] | mu[n2g[n]], s_y);
  }
}
