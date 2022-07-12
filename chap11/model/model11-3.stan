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
  mu[3:T] ~ normal(2*mu[2:(T-1)] - mu[1:(T-2)], s_mu);
  Y[1:T]  ~ normal(mu[1:T], s_y);
}

generated quantities {
  vector[T+Tp] mu_all;
  vector[Tp] yp;
  mu_all[1:T] = mu;
  for (t in 1:Tp) {
    mu_all[T+t] = normal_rng(2*mu_all[T+t-1] - mu_all[T+t-2], s_mu);
    yp[t]       = normal_rng(mu_all[T+t], s_y);
  }
}
