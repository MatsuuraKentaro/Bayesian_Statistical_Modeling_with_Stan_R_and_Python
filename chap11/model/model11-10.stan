data {
  int T;
  int N1;
  int N2;
  array[N1] vector[T] Y1;
  array[N2] vector[T] Y2;
}

parameters {
  vector[T] trend;
  real sw_ini;
  vector<lower=-pi()/2, upper=pi()/2>[T-1] sw_unif;
  real<lower=0> s_trend;
  real<lower=0> s_sw;
  real<lower=0> s_y;
}

transformed parameters {
  vector[T] sw;
  sw[1] = sw_ini;
  for (t in 2:T) {
    sw[t] = sw[t-1] + s_sw*tan(sw_unif[t-1]);
  }
}

model {
  trend[3:T] ~ normal(2*trend[2:(T-1)] - trend[1:(T-2)], s_trend);
  for (n in 1:N1) {
    Y1[n] ~ normal(trend[1:T], s_y);
  }
  for (n in 1:N2) {
    Y2[n] ~ normal(trend[1:T] + sw[1:T], s_y);
  }
}
