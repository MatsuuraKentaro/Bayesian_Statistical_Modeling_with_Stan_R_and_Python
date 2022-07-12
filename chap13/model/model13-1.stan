data {
  int N;
  int Y1;
  int Y2;
}

parameters {
  real<lower=0, upper=1> theta1;
  real<lower=0, upper=1> theta2;
}

model {
  Y1 ~ binomial(N, theta1);
  Y2 ~ binomial(N, theta2);
}
