data {
  int I;
  array[I] int Y;
}

parameters {
  vector[I] f;
  real<lower=0> s_f;
}

model {
  f[3:I] ~ normal(2*f[2:(I-1)] - f[1:(I-2)], s_f);
  Y[1:I] ~ poisson_log(f[1:I]);
}

generated quantities {
  vector[I] y_mean = exp(f[1:I]);
}
