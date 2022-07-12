data {
  int N;
  int D;
  int K;
  vector[N] Mu;
  array[D] vector[N] Y;
}

parameters {
  array[N] vector[K] x;
  real<lower=0> a;
  real<lower=0> rho;
  real<lower=0> s_y;
}

model {
  matrix[N,N] cov = add_diag(gp_exp_quad_cov(x, a, rho), square(s_y));
  for (n in 1:N) {
    x[n] ~ normal(0, 1);
  }
  a   ~ normal(0, 1);
  rho ~ normal(0, 0.25);
  s_y ~ normal(0, 1);
  Y[1:D] ~ multi_normal_cholesky(Mu, cholesky_decompose(cov));
}
