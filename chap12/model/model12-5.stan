data {
  int I;
  vector[I] Y;
  int K;
  array[K] int<lower=1, upper=I> From;
  array[K] int<lower=1, upper=I> To;
}

parameters {
  vector[I] f;
  real<lower=0> s_f;
  real<lower=0> s_y;
}

model {
  vector[K] diff = f[To] - f[From];
  target += - (I-1) * log(s_f)
    - 0.5 * inv_square(s_f) * dot_self(diff);
  Y[1:I] ~ normal(f[1:I], s_y);
}
