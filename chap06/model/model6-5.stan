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
  for (n in 1:N) {
    Y[n] ~ multi_normal(mu_vec, cov);
  }
}
