data {
  int N;
  vector[N] Weight;
  vector[N] Age;
  vector[N] Y;
}

parameters {
  vector[2] c;
  vector[3] b;
  real<lower=0> s_w;
  real<lower=0> s_y;
}

transformed parameters {
  vector[N] mu_w = c[1] + c[2]*Age[1:N];
  vector[N] mu_y = b[1] + b[2]*Age[1:N] + b[3]*Weight[1:N];
}

model {
  Weight[1:N] ~ normal(mu_w[1:N], s_w);
  Y[1:N] ~ normal(mu_y[1:N], s_y);
}
