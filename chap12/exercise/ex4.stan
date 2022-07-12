functions {
  vector gp(array[] real x, vector mu, vector eta,
            real a, real rho, real s2) {
    int T = size(x);
    matrix[T,T] k = add_diag(gp_exp_quad_cov(x, a, rho), s2);
    vector[T] output = mu + cholesky_decompose(k)*eta;
    return output;
  }
}

data {
  int T;
  array[T] real X;
  vector[T] Mu;
  int N1;
  int N2;
  array[N1] vector[T] Y1;
  array[N2] vector[T] Y2;
}

parameters {
  vector[T] eta;
  real<lower=0> a;
  real<lower=0> rho;
  real sw_ini;
  vector<lower=-pi()/2, upper=pi()/2>[T-1] sw_unif;
  real<lower=0> s_sw;
  real<lower=0> s_y;
}

transformed parameters {
  vector[T] f = gp(X, Mu, eta, a, rho, 1e-9);
  vector[T] sw;
  sw[1] = sw_ini;
  for (t in 2:T) {
    sw[t] = sw[t-1] + s_sw*tan(sw_unif[t-1]);
  }
}

model {
  eta ~ normal(0, 1);
  a   ~ normal(0, 1);
  rho ~ normal(0, 0.25);
  for (n in 1:N1) {
    Y1[n] ~ normal(f[1:T], s_y);
  }
  for (n in 1:N2) {
    Y2[n] ~ normal(f[1:T] + sw[1:T], s_y);
  }
}
