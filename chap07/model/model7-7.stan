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

model {
  Y[1:N] ~ normal(b[1] + b[2]*X[1:N], sigma);
}

generated quantities {
  array[Np] real yp = normal_rng(b[1] + b[2]*Xp[1:Np], sigma);
}
