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
  vector[C] a_diff;
  vector[C] b_diff;
  real<lower=0> s_a;
  real<lower=0> s_b;
  real<lower=0> s_y;
}

transformed parameters {
  vector[C] a = a_field + a_diff[1:C];
  vector[C] b = b_field + b_diff[1:C];
}

model {
  a_diff[1:C] ~ normal(0, s_a);
  b_diff[1:C] ~ normal(0, s_b);
  Y[1:N] ~ normal(a[n2c] + b[n2c] .* X[1:N], s_y);
}
