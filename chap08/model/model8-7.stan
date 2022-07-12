data {
  int I;
  int N;
  int T;
  vector[T] X;
  array[I] int<lower=1, upper=N> i2n;
  array[I] int<lower=1, upper=T> i2t;
  vector[I] Y;
  int Tp;
  vector[Tp] Xp;
}

parameters {
  real a_all;
  real b_all;
  vector[N] log_a;
  vector[N] log_b;
  real<lower=0> s_a;
  real<lower=0> s_b;
  real<lower=0> s_y;
}

transformed parameters {
  vector[N] a = exp(log_a[1:N]);
  vector[N] b = exp(log_b[1:N]);
  array[N] vector[T] mu;
  for (n in 1:N) {
    mu[n,1:T] = a[n]*(1 - exp(-b[n]*X[1:T]));
  }
}

model {
  log_a[1:N] ~ normal(a_all, s_a);
  log_b[1:N] ~ normal(b_all, s_b);
  for (i in 1:I) {
    Y[i] ~ normal(mu[i2n[i], i2t[i]], s_y);
  }
}

generated quantities {
  array[N,Tp] real yp;
  for (n in 1:N) {
    yp[n,1:Tp] = normal_rng(a[n]*(1 - exp(-b[n]*Xp[1:Tp])), s_y);
  }
}
