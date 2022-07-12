data {
  int T;
  int Tp;
  vector[T] Y;
}

parameters {
  vector[T] mu;
  real<lower=0> s_mu;
  real<lower=0> s_y;
}

model {
  mu[2:T] ~ normal(mu[1:(T-1)], s_mu);
  Y[1:T]  ~ normal(mu[1:T], s_y);
}

generated quantities {
  vector[T+Tp] mu_all;
  vector[Tp] yp;
  mu_all[1:T] = mu[1:T];
  for (t in 1:Tp) {
    mu_all[T+t] = normal_rng(mu_all[T+t-1], s_mu);
    yp[t]       = normal_rng(mu_all[T+t], s_y);
  }
}
