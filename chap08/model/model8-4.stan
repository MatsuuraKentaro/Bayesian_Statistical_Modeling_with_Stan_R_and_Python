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
  vector[C] a;
  vector[C] b;
  real<lower=0> s_a;
  real<lower=0> s_b;
  real<lower=0> s_y;
}

model {
  a[1:C] ~ normal(a_field, s_a);
  b[1:C] ~ normal(b_field, s_b);
  Y[1:N] ~ normal(a[n2c] + b[n2c] .* X[1:N], s_y);
}
