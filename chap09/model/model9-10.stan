data {
  int N;
  int C;
  vector[N] X;
  vector[N] Y;
  array[N] int<lower=1, upper=C> n2c;
}

parameters {
  real a_field;
  real b_field;
  vector[C] a_raw;
  vector[C] b_raw;
  real<lower=0> s_a;
  real<lower=0> s_b;
  real<lower=0> s_y;
}

transformed parameters {
  vector[C] a = a_field + s_a*a_raw[1:C];
  vector[C] b = b_field + s_b*b_raw[1:C];
}

model {
  a_raw[1:C] ~ normal(0, 1);
  b_raw[1:C] ~ normal(0, 1);
  Y[1:N] ~ normal(a[n2c] + b[n2c] .* X[1:N], s_y);
}
