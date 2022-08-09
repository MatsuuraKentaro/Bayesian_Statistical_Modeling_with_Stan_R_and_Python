library(mvtnorm)
set.seed(123)

S <- 5    # number of draws
N <- 101  # length of f
X <- seq(0, 1, len=N)
a   <- 2
rho <- 0.05

K <- matrix(rep(0, N*N), nrow=N)
for (i in 1:N) {
  for (j in 1:N) {
    K[i,j] <- a^2 * exp(-0.5/rho^2*(X[i]-X[j])^2)
  }
}

f_draws <- rmvnorm(S, mean=rep(0, N), sigma=K)
