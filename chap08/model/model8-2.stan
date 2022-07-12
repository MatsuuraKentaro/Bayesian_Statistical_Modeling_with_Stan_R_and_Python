data {
  int N;
  int C;
  vector[N] X;
  vector[N] Y;
  array[N] int<lower=1, upper=C> n2c;
}

parameters {
  vector[C] a;
  vector[C] b;
  real<lower=0> s_y;
}

model {
  Y[1:N] ~ normal(a[n2c] + b[n2c] .* X[1:N], s_y);
}
