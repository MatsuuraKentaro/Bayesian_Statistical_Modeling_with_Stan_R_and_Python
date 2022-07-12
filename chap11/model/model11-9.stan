data {
  int T;
  vector[T] Y;
}

parameters {
  vector[T] pulse;
  real<lower=0, upper=1> q;
  real<lower=0> beta;
  real<lower=0, upper=1> rho;
  real<lower=0> s_pulse;
  real<lower=0> s_y;
}

model {
  for (t in 2:T) {
    target += log_mix(q,
      normal_lpdf(pulse[t] | rho*pulse[t-1] + beta, s_pulse),
      normal_lpdf(pulse[t] | rho*pulse[t-1],        s_pulse)
    );
  }
  beta ~ normal(2, 1);
  q ~ normal(0, 0.1);
  Y[1:T] ~ normal(pulse[1:T], s_y);
}
