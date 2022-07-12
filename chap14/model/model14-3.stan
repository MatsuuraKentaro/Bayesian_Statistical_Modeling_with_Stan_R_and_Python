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
  array[I,N] int<lower=0> Y;
}

parameters {
  matrix<lower=0>[N,K] theta;
  array[K] simplex[I] phi;
}

model {
  matrix[K,I] phi_m = vector_array_to_matrix(phi);
  matrix[N,I] lambda = theta * phi_m;

  to_array_1d(Y) ~ poisson(to_vector(lambda));
}
