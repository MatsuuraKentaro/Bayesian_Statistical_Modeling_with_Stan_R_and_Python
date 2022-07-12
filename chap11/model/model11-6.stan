data {
  int T;
  vector[T] Y;
}

parameters {
  real sw_ini;
  vector<lower=-pi()/2, upper=pi()/2>[T-1] sw_raw;
  real<lower=0> s_sw;
  real<lower=0> s_y;
}

transformed parameters {
  vector[T] sw;
  sw[1] = sw_ini;
  for (t in 2:T) {
    sw[t] = sw[t-1] + s_sw*tan(sw_raw[t-1]);
  }
}

model {
  Y[1:T] ~ normal(sw[1:T], s_y);
}
