functions {
  real gp_lpdf(vector out, array[] real x, vector mu,
               real a, real rho, real s2) {
    int N = size(x);
    matrix[N,N] k_addI = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    return multi_normal_cholesky_lpdf(out | mu, cholesky_decompose(k_addI));
  }
}

data {
  int<lower=1> N;
  array[N] real X;
  vector[N] Mu;
  vector[N] Y;
}

parameters {
  vector[N] f;
  real<lower=0> a;
  real<lower=0> rho;
  real<lower=0> s_y;
}

model {
  a   ~ normal(0, 1);
  rho ~ normal(0.1, 0.1);
  s_y ~ normal(0, 1);
  f ~ gp(X, Mu, a, rho, 1e-8);
  Y[1:N] ~ normal(f[1:N], s_y);
}
