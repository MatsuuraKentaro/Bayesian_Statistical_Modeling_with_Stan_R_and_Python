data {
  int N;  // num of players
  int G;  // num of games
  array[G] int<lower=1, upper=N> g2L; // loser of each game
  array[G] int<lower=1, upper=N> g2W; // winner of each game
}

parameters {
  real b;
}

transformed parameters {
  vector[N] mu = [0, b]';
}

model {
  for (g in 1:G) {
    target += normal_lccdf(0 | mu[g2W[g]] - mu[g2L[g]], sqrt(2));
  }
}
