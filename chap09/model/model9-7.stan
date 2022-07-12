data {
  int N;
  int C;
  vector[N] X;
  vector[N] Y;
  array[N] int<lower=1, upper=C> n2c;
  real Nu;
}

parameters {
  array[C] vector[2] ab;
  vector[2] ab_field;
  cholesky_factor_corr[2] corr_chol;
  vector<lower=0>[2] s_vec;
  real<lower=0> s_y;
}

transformed parameters {
  vector[C] a = to_vector(ab[1:C,1]);
  vector[C] b = to_vector(ab[1:C,2]);
  matrix[2,2] cov_chol = diag_pre_multiply(s_vec, corr_chol);
}

model {
  ab_field[1] ~ normal(40, 20);
  ab_field[2] ~ normal(1.5, 1.5);
  s_vec[1] ~ student_t(4, 0, 20);
  s_vec[2] ~ student_t(4, 0, 2);
  corr_chol ~ lkj_corr_cholesky(Nu);
  ab[1:C] ~ multi_normal_cholesky(ab_field, cov_chol);
  Y[1:N] ~ normal(a[n2c] + b[n2c] .* X[1:N], s_y);
}

generated quantities {
  matrix[2,2] corr = multiply_lower_tri_self_transpose(corr_chol);
  matrix[2,2] cov = multiply_lower_tri_self_transpose(cov_chol);
}
