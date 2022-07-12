data {
  int T;
  vector[T] Y;
  real<lower=0> B;
}

parameters {
  real sw_ini;
  vector[T-1] sw_raw1;
  vector<lower=0>[T-1] sw_raw2;
  real<lower=0> s_sw;
  real<lower=0> s_y;
}

transformed parameters {
  vector[T] sw;
  sw[1] = sw_ini;
  for (t in 2:T) {
    sw[t] = sw[t-1] + 1e-5*s_sw*sw_raw1[t-1]*sqrt(sw_raw2[t-1]);
  }
}

model {
  sw_raw1[1:(T-1)] ~ normal(0, 1);
  sw_raw2[1:(T-1)] ~ inv_gamma(B, 1);
  Y[1:T] ~ normal(sw[1:T], s_y);
}
