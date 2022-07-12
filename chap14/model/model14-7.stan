data {
  int D;
  int N;
  matrix[N,D] X;
  vector[N] Y;
}

parameters {
  vector[D] b;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu = X*b;
}

model {
  Y[1:N] ~ normal(mu[1:N], sigma);
}

generated quantities {
  array[N] real yp = normal_rng(mu[1:N], sigma);
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = normal_lpdf(Y[n] | mu[n], sigma);
  }
}
