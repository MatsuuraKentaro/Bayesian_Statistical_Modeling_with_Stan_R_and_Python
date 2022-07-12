functions {
  real gp_lpdf(vector output, array[] real x, vector mu,
               real a, real rho, real s2) {
    int N = size(x);
    matrix[N,N] k = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    return multi_normal_cholesky_lpdf(output | mu, cholesky_decompose(k));
  }

  matrix gp_pred_pars(array[] real xp, array[] real x, vector output,
                      real a, real rho, real s2) {
    int N  = size(x);
    int Np = size(xp);
    matrix[N, N ] k = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    matrix[Np,Np] kpp = add_diag(gp_exp_quad_cov(xp, a, rho), s2);
    matrix[N, Np] kp = gp_exp_quad_cov(x, xp, a, rho);
    matrix[Np,N ] kp_t_div_k = kp' / k;
    vector[Np] mup = kp_t_div_k * output;
    matrix[Np,Np] covp = kpp - kp_t_div_k * kp;
    return append_col(mup, covp);
  }
}

data {
  int<lower=1> N;
  array[N] real X;
  vector[N] Mu;
  vector[N] Y;
  int<lower=1> Np;
  array[Np] real Xp;
}

parameters {
  real<lower=0> a;
  real<lower=0> rho;
  real<lower=0> s_y;
}

model {
  a   ~ normal(0, 1);
  rho ~ normal(0, 0.25);
  s_y ~ normal(0, 1);
  Y ~ gp(X, Mu, a, rho, square(s_y));
}

generated quantities {
  matrix[Np, Np+1] pars = gp_pred_pars(Xp, X, Y, a, rho, square(s_y));
  vector[Np] yp = multi_normal_rng(pars[,1], pars[,2:(Np+1)]);
}
