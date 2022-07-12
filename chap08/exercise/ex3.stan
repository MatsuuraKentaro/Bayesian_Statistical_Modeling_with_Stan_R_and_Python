data {
  int N;  // num of students
  int C;  // num of countries
  int S;  // num of schools
  vector[N] Y;
  array[S] int<lower=1, upper=C> s2c;
  array[N] int<lower=1, upper=S> n2s;
}

parameters {
  vector[C] mu_cou;      // mean of each country
  vector[S] mu_sch;      // mean of each school
  real<lower=0> s_sch;   // SD of school differences
  real<lower=0> s_y;     // SD of observation noise
}

model {
  mu_sch[1:S] ~ normal(mu_cou[s2c], s_sch);
  Y[1:N] ~ normal(mu_sch[n2s], s_y);
}
