data {
  int<lower=1> N;
  int<lower=1> T;
  array[N] int<lower=1, upper=T> Time;
  array[N] int<lower=0, upper=1> Cens; // 0:event, 1:censored
}

transformed data {
  vector[T] Time1toT = linspaced_vector(T, 1, T);
}

parameters {
  real<lower=0, upper=5> c0;
  real<lower=0, upper=T> c1;
  real<lower=0, upper=5> c2;
}

transformed parameters {
  vector[T] h = 1e-4*c0*square(Time1toT[1:T] - c1) + 1e-2*c2;
  vector[T] log_h = log(h[1:T]);
  vector[T] log_F = cumulative_sum(log1m(h[1:T]));
}

model {
  for (n in 1:N) {
    if (Cens[n] == 0) {
      target += log_h[Time[n]];
      if (Time[n] >= 2) {
        target += log_F[Time[n]-1];
      }
    } else {
      target += log_F[Time[n]];
    }
  }
}
