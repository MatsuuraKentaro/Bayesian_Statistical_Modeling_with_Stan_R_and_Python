data {
  int N_obs;
  int N_cens;
  vector[N_obs] Y_obs;
  real L;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  Y_obs[1:N_obs] ~ normal(mu, sigma);
  target += N_cens * normal_lcdf(L | mu, sigma);
}
