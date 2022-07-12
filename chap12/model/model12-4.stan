data {
  int A;
  array[A] int Y;
  int J;
  array[J] int From;
  array[J] int To;
}

parameters {
  simplex[A] q;
  real<lower=0> s_q;
  vector<lower=0, upper=1>[J] r;
}

transformed parameters {
  vector[A] mu = q[1:A];
  for (j in 1:J) {
    mu[To[j]]   = mu[To[j]]   + r[j]*q[From[j]];
    mu[From[j]] = mu[From[j]] - r[j]*q[From[j]];
  }
}

model {
  q[3:(A-1)] ~ normal(2*q[2:(A-2)] - q[1:(A-3)], s_q);
  Y ~ multinomial(mu);
}
