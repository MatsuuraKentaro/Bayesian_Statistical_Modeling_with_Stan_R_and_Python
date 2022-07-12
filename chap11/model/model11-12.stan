data {
  int N;  // num of players
  int G;  // num of games
  int I;  // num of indices of (player, year)
  array[G] int<lower=1, upper=N> g2Ln; // loser playerID of each game
  array[G] int<lower=1, upper=N> g2Wn; // winner playerID of each game
  array[G] int<lower=1, upper=I> g2Li; // loser index in mu of each game
  array[G] int<lower=1, upper=I> g2Wi; // winner index in mu of each game
  array[N] int<lower=1, upper=I> n2Si;
  array[N] int<lower=1, upper=I> n2Ei;
}

parameters {
  vector[N] mu_ini;
  vector[I-N] mu_raw;
  real<lower=0> s_mu;
  vector<lower=0>[N] s_pf;
}

transformed parameters {
  vector[I] mu;
  {
    int idx = 1;
    for (n in 1:N) {
      mu[n2Si[n]] = mu_ini[n];
      for (t in (n2Si[n]+1):n2Ei[n]) {
        mu[t] = mu[t-1] + s_mu*mu_raw[idx];
        idx += 1;
      }
    }
  }
}

model {
  for (g in 1:G) {
    target += normal_lccdf(0 | mu[g2Wi[g]] - mu[g2Li[g]],
      hypot(s_pf[g2Ln[g]], s_pf[g2Wn[g]])
    );
  }
  mu_ini ~ student_t(4, 0, 1);
  mu_raw ~ normal(0, 1);
  s_pf[1:N] ~ gamma(10, 10);
}
