data {
  int T;
  vector[T] Y;
}

parameters {
  real pulse_ini;
  vector<lower=-atan(2), upper=pi()/2>[T-1] pulse_raw;
  real<lower=0, upper=1> rho;
  real<lower=0> s_pulse;
  real<lower=0> s_y;
}

transformed parameters {
  vector[T] pulse;
  pulse[1] = pulse_ini;
  for (t in 2:T) {
    pulse[t] = pulse[t-1]*rho + s_pulse*tan(pulse_raw[t-1]);
  }
}

model {
  Y[1:T] ~ normal(pulse[1:T], s_y);
}
