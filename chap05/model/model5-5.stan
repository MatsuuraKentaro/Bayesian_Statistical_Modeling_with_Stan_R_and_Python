data {
  int V;
  vector<lower=0, upper=1>[V] Sex;
  vector<lower=0>[V] Income;
  vector<lower=0, upper=1>[V] Dis;
  array[V] int <lower=0, upper=1> Y;
}

parameters {
  vector[4] b;
}

transformed parameters {
  vector[V] q = inv_logit(
    b[1] + b[2]*Sex[1:V] + b[3]*Income[1:V] + b[4]*Dis[1:V]);
}

model {
  Y[1:V] ~ bernoulli(q[1:V]);
}
