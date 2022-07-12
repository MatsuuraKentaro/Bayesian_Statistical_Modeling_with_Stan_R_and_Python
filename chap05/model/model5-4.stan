data {
  int N;
  vector<lower=0, upper=1>[N] Sex;
  vector<lower=0>[N] Income;
  array[N] int<lower=0> M;
  array[N] int<lower=0> Y;
}

parameters {
  vector[3] b;
}

transformed parameters {
  vector[N] q = inv_logit(b[1] + b[2]*Sex[1:N] + b[3]*Income[1:N]);
}

model {
  Y[1:N] ~ binomial(M[1:N], q[1:N]);
}

generated quantities {
  array[N] int yp = binomial_rng(M[1:N], q[1:N]);
}
