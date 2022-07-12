data {
  int I;
  int J;
  matrix[I,J] Y;
  int T;
  array[J,I] int<lower=1, upper=T> ji2t;
}

parameters {
  matrix[I,J] f;
  real<lower=0> s_f;
  vector[T] beta;
  real<lower=0> s_beta;
  real<lower=0> s_y;
}

model {
  vector[(I-2)*(J-2)] diff = to_vector(
    f[1:(I-2), 2:(J-1)] + f[3:I, 2:(J-1)] +
    f[2:(I-1), 1:(J-2)] + f[2:(I-1), 3:J] - 4*f[2:(I-1), 2:(J-1)]
  );
  target += - (I*J-3) * log(s_f)
    - 0.5 * inv_square(s_f) * dot_self(diff);

  beta[1:T] ~ normal(0, s_beta);
  to_vector(Y) ~ normal(to_vector(f) + beta[to_array_1d(ji2t)], s_y);
  s_y ~ normal(0, 0.2);
}
