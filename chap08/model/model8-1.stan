data {
  int N;
  vector[N] X;
  vector[N] Y;
}

parameters {
  real a;
  real b;
  real<lower=0> s_y;
}

model {
  Y[1:N] ~ normal(a + b*X[1:N], s_y);
}
