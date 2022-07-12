data {
  int I;
  array[I] int Y;
}

parameters {
  vector[I] f;
  real<lower=0> s_f;
}

model {
  f[2:I] ~ normal(f[1:(I-1)], s_f);
  Y[1:I] ~ poisson_log(f[1:I]);
}

generated quantities {
  vector[I] y_mean = exp(f[1:I]);
}
