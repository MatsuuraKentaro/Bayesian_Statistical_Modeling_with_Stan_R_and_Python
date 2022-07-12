parameters {
  real a_raw;
  vector[1000] r_raw;
}

transformed parameters {
  real a = 3.0 * a_raw;
  vector[1000] r = exp(a/2) * r_raw[1:1000];
}

model {
  a_raw ~ normal(0, 1);
  r_raw[1:1000] ~ normal(0, 1);
}
