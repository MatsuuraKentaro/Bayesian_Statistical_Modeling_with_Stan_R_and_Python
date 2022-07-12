data {
  int T;
  array[T] int<lower=1, upper=7> t2wd;
  vector[T] Ho;
  vector[T] BH;
  vector[T] Weather_val;
  vector[T] Event_val;
  int T_obs;
  array[T_obs] int<lower=1, upper=T> t_obs2t;
  vector[T_obs] Y;
}

parameters {
  vector[T-2] trend_raw;
  vector<lower=0, upper=100>[2] trend_ini;
  vector[6] wday_raw;
  real<lower=0, upper=1> b_Ho;
  real<lower=0, upper=1> b_BH;
  real b_weather;
  vector[T-1] b_event_raw;
  real b_event_ini;
  real<lower=0> s_trend;
  real<lower=0> s_b_event;
  real<lower=0> s_y;
}

transformed parameters {
  vector[T] trend;
  vector[7] wday;
  vector[T] calendar;
  vector[T] weather;
  vector[T] b_event;
  vector[T] event;
  vector[T] mu;
  trend[1:2] = trend_ini[1:2];
  for (t in 3:T) {
    trend[t] = 2*trend[t-1] - trend[t-2] + s_trend*trend_raw[t-2];
  }
  wday[1:6] = wday_raw[1:6];
  wday[7] = -sum(wday_raw);
  calendar[1:T] = wday[t2wd] +
    Ho[1:T] .* (b_Ho*(wday[7]-wday[t2wd])) +
    BH[1:T] .* (b_BH*(wday[5]-wday[t2wd]));
  weather[1:T] = b_weather * Weather_val[1:T];
  b_event[1] = b_event_ini;
  for (t in 2:T) {
    b_event[t] = b_event[t-1] + s_b_event*b_event_raw[t-1];
  }
  event[1:T] = b_event .* Event_val[1:T];
  mu = trend + calendar + weather + event;
}

model {
  s_trend ~ normal(0, 1);
  s_b_event ~ normal(0, 1);
  b_event_raw ~ normal(0, 1);
  trend_raw ~ normal(0, 1);
  s_y ~ normal(0, 5);
  Y[1:T_obs] ~ normal(mu[t_obs2t], s_y);
}
