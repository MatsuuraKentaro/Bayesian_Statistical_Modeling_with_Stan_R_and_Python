data {
  int N;
  int C;
  vector[N] X;
  vector[N] Y;
  array[N] int<lower=1, upper=C> n2c;
}

parameters {
  array[C] vector[2] ab;
  vector[2] ab_field;
  real<lower=0> s_a;
  real<lower=0> s_b;
  real<lower=-1, upper=1> rho;
  real<lower=0> s_y;
}

transformed parameters {
  vector[C] a = to_vector(ab[1:C,1]);
  vector[C] b = to_vector(ab[1:C,2]);
  matrix[2,2] cov;
  cov[1,1] = square(s_a); cov[1,2] = s_a*s_b*rho;
  cov[2,1] = s_a*s_b*rho; cov[2,2] = square(s_b);
}

model {
  ab_field[1] ~ normal(40, 20);
  ab_field[2] ~ normal(1.5, 1.5);
  s_a ~ student_t(4, 0, 20);
  s_b ~ student_t(4, 0, 2);
  ab[1:C] ~ multi_normal(ab_field, cov);
  Y[1:N] ~ normal(a[n2c] + b[n2c] .* X[1:N], s_y);
}
