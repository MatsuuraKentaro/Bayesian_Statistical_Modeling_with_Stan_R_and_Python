data {
  int T;
  int Tp;
  vector[T] Y;
}

parameters {
  real mu_ini;
  vector[T-1] mu_raw;
  real<lower=0> s_mu;
  real<lower=0> s_y;
}

transformed parameters {
  vector[T] mu;
  mu[1] = mu_ini;
  for (t in 2:T) {
    mu[t] = mu[t-1] + s_mu*mu_raw[t-1];
  }
}

model {
  mu_raw[1:(T-1)] ~ normal(0, 1);
  Y[1:T]  ~ normal(mu[1:T], s_y);
}
