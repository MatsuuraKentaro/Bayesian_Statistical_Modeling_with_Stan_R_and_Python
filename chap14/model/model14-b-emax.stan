data {
  int N;
  vector[N] X;
  vector[N] Y;
}

parameters {
  real<lower=0, upper=12> k;
  real<lower=0, upper=20> m;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu = m*X[1:N] ./ (X[1:N] + k);
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
