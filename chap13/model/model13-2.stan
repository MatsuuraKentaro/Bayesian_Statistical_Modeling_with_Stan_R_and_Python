data {
  int N;
  int K;
  array[N] int<lower=1, upper=K> n2k;
  vector[N] Y;
}

parameters {
  vector[K] mu;
  real<lower=0> s_y;
}

model {
  Y[1:N] ~ normal(mu[n2k], s_y);
}
