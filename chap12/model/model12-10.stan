functions {
  vector gp(array[] real x, vector mu, vector eta,
            real a, real rho, real s2) {
    int N = size(x);
    matrix[N,N] k_addI = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    vector[N] out = mu + cholesky_decompose(k_addI)*eta;
    return out;
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

  real gp_pred_approx_lpdf(vector outp, array[] real x, array[] real xp,
                           vector mu, vector mup, vector out,
                           real a, real rho, real s2, real sp2) {
    int N  = size(x);
    int Np = size(xp);
    matrix[N, N ] k_addI = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    vector[Np] kpp_diag = rep_vector(square(a) + sp2, Np);
    matrix[N, Np] kp = gp_exp_quad_cov(x, xp, a, rho);
    matrix[Np,N ] coef = kp' / k_addI;
    vector[Np] mup_cond = mup + coef * (out - mu);
    vector[Np] sp_cond = sqrt(kpp_diag - rows_dot_product(coef, kp'));
    return normal_lpdf(outp | mup_cond, sp_cond);
  }
}

data {
  int<lower=1> Ni;
  int<lower=1> N;
  int<lower=1> Np;
  array[Ni] real Xi;
  array[N] real X;
  array[Np] real Xp;
  vector[Ni] Mui;
  vector[N] Mu;
  vector[Np] Mup;
  vector[N] Y;
}

parameters {
  vector[Ni] eta;
  real<lower=0> a;
  real<lower=0> rho;
  real<lower=0> s_y;
}

transformed parameters {
  vector[Ni] fi = gp(Xi, Mui, eta, a, rho, 1e-8);
}

model {
  eta ~ normal(0, 1);
  a   ~ normal(0, 1);
  rho ~ normal(0.1, 0.1);
  s_y ~ normal(0, 1);
  Y[1:N] ~ gp_pred_approx(Xi, X, Mui, Mu, fi, a, rho, 1e-8, square(s_y));
}

generated quantities {
  vector[Np] fp = gp_pred_rng(Xi, Xp, Mui, Mup, fi, a, rho, 1e-8, 1e-8);
  array[Np] real yp = normal_rng(fp[1:Np], s_y);
}
