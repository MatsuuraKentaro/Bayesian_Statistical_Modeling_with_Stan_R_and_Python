data {
  int T;
  vector[T] Y;
  int L;
}

parameters {
  vector[2]   trend_ini;
  vector[T-2] trend_raw;
  vector[L-1]   season_ini;
  vector[T-L+1] season_raw;
  real<lower=0> s_trend;
  real<lower=0> s_season;
  real<lower=0> s_y;
}

transformed parameters {
  vector[T] trend;
  vector[T] season;
  vector[T] mu;
  trend[1:2] = trend_ini[1:2];
  for (t in 3:T) {
    trend[t] = 2*trend[t-1] - trend[t-2] +
      s_trend*trend_raw[t-2];
  }
  season[1:(L-1)] = season_ini[1:(L-1)];
  for (t in L:T) {
    season[t] = -sum(season[(t-L+1):(t-1)]) +
      s_season*season_raw[t-L+1];
  }
  mu[1:T] = trend[1:T] + season[1:T];
}

model {
  trend_raw ~ normal(0, 1);
  season_raw ~ normal(0, 1);
  Y[1:T] ~ normal(mu[1:T], s_y);
}
