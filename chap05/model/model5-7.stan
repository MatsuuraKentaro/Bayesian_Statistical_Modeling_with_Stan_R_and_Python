data {
  int N;
  int D;
  matrix[N,D] X;
  vector<lower=0, upper=1>[N] Y;
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
