data {
  int N;
  array[N] int<lower=0> Y;
}

parameters {
  real<lower=0> lambda;
}

model {
  Y[1:N] ~ poisson(lambda*0.5);
}
