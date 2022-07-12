data {
  int N;
  vector[N] X;
  vector[N] Y;
  int Np;
  vector[Np] Xp;
}

parameters {
  real a;
  real b;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] y_base = a + b*X[1:N];
}

model {
  Y[1:N] ~ normal(y_base[1:N], sigma);
}

generated quantities {
  vector[Np] yp_base = a + b*Xp[1:Np];
  array[Np] real yp = normal_rng(yp_base[1:Np], sigma);
}
