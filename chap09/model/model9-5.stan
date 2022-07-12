data {
  int N;
  int C;
  vector[N] X;
  vector[N] Y;
  array[N] int<lower=1, upper=C> n2c;
}

parameters {
  array[C] vector[2] ab;
  vector[2] ab_field;
  cov_matrix[2] cov;
  real<lower=0> s_y;
}

transformed parameters {
  vector[C] a = to_vector(ab[1:C,1]);
  vector[C] b = to_vector(ab[1:C,2]);
}

model {
  ab[1:C] ~ multi_normal(ab_field, cov);
  Y[1:N] ~ normal(a[n2c] + b[n2c] .* X[1:N], s_y);
}
