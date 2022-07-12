data {
  int T;
  vector[T] X;
  vector[T] Y;
  int Tp;
  vector[Tp] Xp;
}

parameters {
  real<lower=0, upper=100> a;
  real<lower=0, upper=5> b;
  real<lower=0> sigma;
}

model {
  Y[1:T] ~ normal(a*(1 - exp(-b*X[1:T])), sigma);
}

generated quantities {
  array[Tp] real yp = normal_rng(a*(1 - exp(-b*Xp[1:Tp])), sigma);
}
