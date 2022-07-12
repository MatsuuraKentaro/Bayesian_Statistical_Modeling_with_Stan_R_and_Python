functions {
  real normal_mixture_lpdf(real Y, int K, vector a, 
                           vector mu, vector sigma) {
    vector[K] lp;
    for (k in 1:K) {
      lp[k] = log(a[k]) + normal_lpdf(Y | mu[k], sigma[k]);
    }
    return log_sum_exp(lp);
  }
}

data {
  int N;
  int K;
  vector[N] Y;
}

parameters {
  simplex[K] a;
  ordered[K] mu;
  vector<lower=0>[K] sigma;
  real<lower=0> s_mu;
}

model {
  mu[1:K] ~ normal(mean(Y), s_mu);
  sigma[1:K] ~ gamma(1.5, 1.0);
  for (n in 1:N) {
    Y[n] ~ normal_mixture(K, a, mu, sigma);
  }
}
