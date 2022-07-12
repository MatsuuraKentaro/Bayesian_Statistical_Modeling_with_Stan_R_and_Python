data {
  int N;
  vector[N] X;
  vector[N] Y;
  int Np;
  vector[Np] Xp;
}

parameters {
  real e0;
  real<lower=0> emax;
  real<lower=0, upper=max(X)> ed50;
  real<lower=0, upper=10> h;
  real<lower=0> sigma;
}

model {
  Y[1:N] ~ normal(
    e0 + emax * X[1:N] .^ h ./ (ed50 ^ h + X[1:N] .^ h), sigma);
}

generated quantities {
  array[Np] real yp = normal_rng(
    e0 + emax * Xp[1:Np] .^ h ./ (ed50 ^ h + Xp[1:Np] .^ h), sigma);
}
