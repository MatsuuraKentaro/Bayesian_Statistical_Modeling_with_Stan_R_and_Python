functions {
  matrix calc_prob_vector(matrix x, vector coef) {
    int N = rows(x);
    matrix[N,N-1] p;
    matrix[N,N-1] x_simi;
    for (i in 1:N) {
      int idx = 1;
      for (j in 1:N) {
        if (j == i) {
          continue;
        }
        x_simi[i,idx] = - coef[i] * squared_distance(x[i], x[j]);
        idx += 1;
      }
      p[i] = softmax(x_simi[i]')';
    }
    return(p);
  }
}

data {
  int N;
  int D;
  int K;
  matrix[N,D] Y;
  vector[N] Prec;
}

transformed data {
  matrix[N,N-1] p = calc_prob_vector(Y, 0.5*Prec);
}

parameters {
  matrix[N,K] x;
}

model {
  matrix[N,N-1] q = calc_prob_vector(x, rep_vector(1,N));
  target += - sum(p .* (log(p) - log(q)));
  to_vector(x) ~ normal(0, 5);
}
