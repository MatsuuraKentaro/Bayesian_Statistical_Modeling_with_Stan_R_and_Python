functions {
  matrix vector_array_to_matrix(array[] vector x) {
    matrix[size(x), rows(x[1])] y;
    for (n in 1:size(x)) {
      y[n] = x[n]';
    }
    return y;
  }
}

data {
  int<lower=1> N;
  int<lower=1> I;
  int<lower=1> K;
  array[N,I] int<lower=0> Y;
  vector<lower=0>[I] Alpha;
}

parameters {
  array[N] simplex[K] theta;
  array[K] simplex[I] phi;
}

model {
  matrix[N,K] theta_m = vector_array_to_matrix(theta);
  matrix[K,I] phi_m   = vector_array_to_matrix(phi);
  matrix[N,I] p = theta_m * phi_m;

  for (k in 1:K) {
    phi[k] ~ dirichlet(Alpha);
  }
  for (n in 1:N) {
    Y[n] ~ multinomial(p[n]');
  }
}
