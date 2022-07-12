functions {
  real gp_lpdf(vector out, array[] vector x, vector mu,
               real a, real rho, real s2) {
    int N = size(x);
    matrix[N,N] k_addI = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    return multi_normal_cholesky_lpdf(out | mu, cholesky_decompose(k_addI));
  }

  vector gp_pred_rng(array[] vector x, array[] vector xp,
                     vector mu, vector mup, vector out,
                     real a, real rho, real s2, real sp2) {
    int N  = size(x);
    int Np = size(xp);
    matrix[N, N ] k_addI = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    matrix[Np,Np] kpp_addI = add_diag(gp_exp_quad_cov(xp, a, rho), sp2);
    matrix[N, Np] kp = gp_exp_quad_cov(x, xp, a, rho);
    matrix[Np,N ] coef = kp' / k_addI;
    vector[Np] mup_cond = mup + coef * (out - mu);
    matrix[Np,Np] covp_cond = kpp_addI - coef * kp;
    return multi_normal_rng(mup_cond, covp_cond);
  }
}

data {
  int N;
  array[N] vector[2] X;
  vector[N] Mu;
  vector[N] Y;
  int T;
  array[N] int<lower=1, upper=T> n2t;
}

parameters {
  vector[T] beta;
  real<lower=0> s_beta;
  real<lower=0> a;
  real<lower=0> rho;
  real<lower=0> s_y;
}

model {
  beta ~ normal(0, s_beta);
  a   ~ normal(0, 1);
  rho ~ normal(0.1, 0.1);
  s_y ~ normal(0, 1);
  Y ~ gp(X, Mu + beta[n2t], a, rho, square(s_y));
}

generated quantities {
  vector[N] fp = gp_pred_rng(X, X, Mu + beta[n2t], Mu,
                             Y, a, rho, square(s_y), 1e-8);
}
