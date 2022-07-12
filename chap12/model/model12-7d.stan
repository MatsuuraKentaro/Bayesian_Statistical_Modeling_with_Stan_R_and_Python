functions {
  real gp_lpdf(vector out, array[] real x, vector mu,
               real a, real rho, real s2) {
    int N = size(x);
    matrix[N,N] k_addI = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    return multi_normal_cholesky_lpdf(out | mu, cholesky_decompose(k_addI));
  }

  vector gp_pred_rng(array[] real x, array[] real xp,
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
  int<lower=1> N;
  int<lower=1> Np;
  array[N] real X;
  array[Np] real Xp;
  vector[N] Mu;
  vector[Np] Mup;
  vector[N] Y;
}

parameters {
  real<lower=0> a;
  real<lower=0> rho;
  real<lower=0> s_y;
}

model {
  a   ~ normal(0, 1);
  rho ~ normal(0.1, 0.1);
  s_y ~ normal(0, 1);
  Y ~ gp(X, Mu, a, rho, square(s_y));
}

generated quantities {
  vector[Np] fp = gp_pred_rng(X, Xp, Mu, Mup, Y, a, rho, square(s_y), 1e-8);
  array[Np] real yp = normal_rng(fp[1:Np], s_y);
}
