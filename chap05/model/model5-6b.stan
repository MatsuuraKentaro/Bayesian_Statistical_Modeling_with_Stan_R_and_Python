data {
  int N;
  vector<lower=0, upper=1>[N] Sex;
  vector<lower=0>[N] Income;
  array[N] int<lower=0> M;
}

parameters {
  vector[3] b;
}

transformed parameters {
  vector[N] log_lam = b[1] + b[2]*Sex[1:N] + b[3]*Income[1:N];
}

model {
  M[1:N] ~ poisson_log(log_lam[1:N]);
}

generated quantities {
  array[N] int mp = poisson_log_rng(log_lam[1:N]);
}
