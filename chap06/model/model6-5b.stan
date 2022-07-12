data {
  int N;
  int D;
  array[N] vector[D] Y;
}

parameters {
  vector[D] mu_vec;
  cov_matrix[D] cov;
}

model {
  Y[1:N] ~ multi_normal(mu_vec, cov);
}
