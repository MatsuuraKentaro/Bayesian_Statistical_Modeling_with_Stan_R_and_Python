functions {
  real ZIB_lpmf(int Y, int N, real q_f, real q_r) {
    if (Y == 0) {
      return log_sum_exp(
        bernoulli_lpmf(0 | q_f),
        bernoulli_lpmf(1 | q_f) + binomial_lpmf(0 | N, q_r)
      );
    } else {
      return bernoulli_lpmf(1 | q_f) + binomial_lpmf(Y | N, q_r);
    }
  }
}

data {
  int N;
  int D;
  matrix[N,D] X;
  array[N] int<lower=0> Y;
}

parameters {
  vector[D] b_f;
  vector[D] b_r;
}

transformed parameters {
  vector[N] q_f = inv_logit(X*b_f);
  vector[N] q_r = inv_logit(X*b_r);
}

model {
  for (n in 1:N) {
    Y[n] ~ ZIB(60, q_f[n], q_r[n]);
  }
}
