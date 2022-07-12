data {
  int N;
  vector[N] Y;
}

parameters {
  real mu;
}

model {
  Y ~ normal(mu, 1);
}

generated quantities {
  real yp = normal_rng(mu, 1);
}
