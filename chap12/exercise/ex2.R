library(cmdstanr)

d <- read.csv('../../chap11/input/data-weight.csv')
N <- nrow(d)
X <- d$X
Y <- as.vector(scale(d$Y))
Np <- 3
Xp <- 21:23
data <- list(N=N, X=X, Mu=rep(0, N), Y=Y, Np=Np, Xp=Xp)

model <- cmdstan_model('ex2.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
