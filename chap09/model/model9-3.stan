data {
  int N;  // num of players
  int G;  // num of games
  array[G] int<lower=1, upper=N> g2L; // loser of each game
  array[G] int<lower=1, upper=N> g2W; // winner of each game
}

parameters {
  vector[N] mu;
  real<lower=0> s_mu;
  vector<lower=0>[N] s_pf;
}

model {
  for (g in 1:G) {
    target += normal_lccdf(0 | mu[g2W[g]] - mu[g2L[g]],
      hypot(s_pf[g2L[g]], s_pf[g2W[g]])
    );
  }
  mu[1:N] ~ normal(0, s_mu);
  s_pf[1:N] ~ gamma(10, 10);
}
