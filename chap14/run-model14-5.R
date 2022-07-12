library(cmdstanr)

d <- read.csv('input/data-oil.csv')
D <- 12
Y <- scale(d[ ,1:D])
N <- nrow(d)
K <- 2
M <- 30
dist <- as.matrix(dist(Y))
var_vec <- numeric(N)
for (n in 1:N) {
  var_vec[n] <- sort(dist[n,], partial=M)[M] / (3*3)
}
Prec <- 1/var_vec
data <- list(N=N, D=D, K=K, Y=Y, Prec=Prec)

model <- cmdstan_model('model/model14-5.stan')
fit_MAP <- model$optimize(data=data, seed=123)
fit_MAP$save_object(file='output/result-model14-5.RDS')


## original version:
softmax <- function(x, n) return(exp(x[-n])/sum(exp(x[-n])))

error_func <- function(var, n) {
  di <- - dist[n,] / (2*var)
  p <- softmax(di, n)
  entropy <- sum(-p * log2(p))
  error <- (2^entropy - M)^2
  return(error)
}

var_vec <- sapply(1:N, function(n) {
  var_best <- optim(1, error_func, n=n,
    method='Brent', lower=0, upper=50)$par
})
