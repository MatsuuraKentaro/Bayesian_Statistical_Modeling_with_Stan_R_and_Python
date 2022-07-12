data {
  int T;
  vector[T] Y;
  int L;
}

parameters {
  vector[T] trend;
  vector[L-1] season_raw;
  real<lower=0> s_trend;
  real<lower=0> s_y;
}

transformed parameters {
  vector[T] mu;
  vector[L] season;
  season[1:(L-1)] = season_raw[1:(L-1)];
  season[L] = -sum(season_raw[1:(L-1)]);
  for (t in 1:T) {
    mu[t] = trend[t] + season[(t-1)%L + 1];
  }
}

model {
  trend[3:T] ~ normal(2*trend[2:(T-1)] - trend[1:(T-2)], s_trend);
  Y[1:T] ~ normal(mu[1:T], s_y);
}
