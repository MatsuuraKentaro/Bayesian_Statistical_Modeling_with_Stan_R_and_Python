data {
  int T;
  int T_obs;
  int T_bf;
  array[T_obs] int t_obs2t;
  array[T_bf] int t_bf2t;
  array[T_obs] vector[2] Y_obs;
  vector[T_bf] Y_bf;
  real Nu;
}

parameters {
  array[T] vector[2] mu;
  cholesky_factor_corr[2] corr_chol_mu;
  cholesky_factor_corr[2] corr_chol_y;
  vector<lower=0>[2] s_mu_vec;
  vector<lower=0>[2] s_y_vec;
}

transformed parameters {
  matrix[2,2] cov_chol_mu = diag_pre_multiply(s_mu_vec, corr_chol_mu);
  matrix[2,2] cov_chol_y  = diag_pre_multiply(s_y_vec,  corr_chol_y);
}

model {
  mu[2:T,] ~ multi_normal_cholesky(mu[1:(T-1),], cov_chol_mu);
  Y_obs[1:T_obs,] ~ multi_normal_cholesky(mu[t_obs2t,], cov_chol_y);
  Y_bf[1:T_bf] ~ normal(mu[t_bf2t, 2], s_y_vec[2]);
  corr_chol_mu ~ lkj_corr_cholesky(Nu);
  corr_chol_y ~ lkj_corr_cholesky(Nu);
  s_mu_vec ~ student_t(6, 0, 0.05);
  s_y_vec ~ student_t(6, 0, 0.1);
}
