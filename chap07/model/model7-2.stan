data {
  int N;
  vector[N] X;
  vector[N] Y;
  int Np;
  vector[Np] Xp;
}

parameters {
  vector[2] b;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu = b[1] + b[2]*X[1:N];
}

model {
  Y[1:N] ~ normal(mu[1:N], sigma);
}

generated quantities {
  array[N] real yp_n = normal_rng(mu[1:N], sigma);
  array[Np] real yp_np = normal_rng(b[1] + b[2]*Xp[1:Np], sigma);
}
