functions {
  vector gp(array[] real x, vector mu, vector eta,
            real a, real rho, real s2) {
    int N = size(x);
    matrix[N,N] k = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    vector[N] output = mu + cholesky_decompose(k)*eta;
    return output;
  }
}

data {
  int<lower=1> N;
  array[N] real X;
  vector[N] Mu;
  array[N] int Y;
}

parameters {
  vector[N] eta;
  real<lower=0> a;
  real<lower=0> rho;
}

transformed parameters {
  vector[N] f = gp(X, Mu, eta, a, rho, 1e-9);
}

model {
  eta ~ normal(0, 1);
  a   ~ normal(0, 1);
  rho ~ normal(0, 0.25);
  Y[1:N] ~ binomial_logit(10, f[1:N]);
}

generated quantities {
  vector[N] p = inv_logit(f[1:N]);
}
