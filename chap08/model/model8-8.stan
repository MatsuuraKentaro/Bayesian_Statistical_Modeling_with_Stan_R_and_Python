data {
  int N;
  int V;
  vector[N] Sex;
  vector[N] Income;
  array[V] int<lower=1, upper=N> v2n;
  vector[V] Dis;
  array[V] int<lower=0, upper=1> Y;
}

parameters {
  vector[4] b;
  vector[N] b_person;
  real<lower=0> s_person;
}

transformed parameters {
  vector[N] x_person = b[2]*Sex[1:N] + b[3]*Income[1:N] + b_person[1:N];
  vector[V] x_visit = b[4]*Dis[1:V];
  vector[V] x = b[1] + x_person[v2n] + x_visit[1:V];
  vector[V] q = inv_logit(x[1:V]);
}

model {
  b_person[1:N] ~ normal(0, s_person);
  Y[1:V] ~ bernoulli(q[1:V]);
}
