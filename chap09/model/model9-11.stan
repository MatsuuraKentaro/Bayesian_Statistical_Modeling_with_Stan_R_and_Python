data {
  int N;
  int C;
  vector[N] X;
  vector[N] Y;
  array[N] int<lower=1, upper=C> n2c;
  real Nu;
}

parameters {
  matrix[2,C] ab_raw;
  vector[2] ab_field;
  cholesky_factor_corr[2] corr_chol;
  vector<lower=0>[2] s_vec;
  real<lower=0> s_y;
}

transformed parameters {
  matrix[2,C] ab;
  vector[C] a;
  vector[C] b;
  matrix[2,2] cov_chol = diag_pre_multiply(s_vec, corr_chol);
  for (c in 1:C) {
    ab[1:2,c] = ab_field[1:2] + cov_chol*ab_raw[1:2,c];
  }
  a[1:C] = ab[1,1:C]';
  b[1:C] = ab[2,1:C]';
}

model {
  ab_field[1] ~ normal(40, 20);
  ab_field[2] ~ normal(1.5, 1.5);
  s_vec[1] ~ student_t(4, 0, 20);
  s_vec[2] ~ student_t(4, 0, 2);
  corr_chol ~ lkj_corr_cholesky(Nu);
  to_vector(ab_raw) ~ normal(0, 1);
  Y[1:N] ~ normal(a[n2c] + b[n2c] .* X[1:N], s_y);
}
