data {
  int N;
  int F;
  int C;
  vector[N] X;
  vector[N] Y;
  array[N] int<lower=1, upper=C> n2c;
  array[C] int<lower=1, upper=F> c2f;
}

parameters {
  real a_all;
  real b_all;
  vector[F] a_field;
  vector[F] b_field;
  vector[C] a;
  vector[C] b;
  real<lower=0> s_af;
  real<lower=0> s_bf;
  vector<lower=0>[F] s_a;
  vector<lower=0>[F] s_b;
  real<lower=0> s_y;
}

model {
  a_field[1:F] ~ normal(a_all, s_af);
  b_field[1:F] ~ normal(b_all, s_bf);
  a[1:C] ~ normal(a_field[c2f], s_a[c2f]);
  b[1:C] ~ normal(b_field[c2f], s_b[c2f]);
  Y[1:N] ~ normal(a[n2c] + b[n2c] .* X[1:N], s_y);
}
