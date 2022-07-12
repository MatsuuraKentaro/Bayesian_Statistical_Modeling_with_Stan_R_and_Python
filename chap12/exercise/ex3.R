library(cmdstanr)

Y <- read.csv('../../chap11/exercise/data-ex3.csv')$Y
I <- length(Y)
Mu <- rep(mean(Y/10), I)
X <- (1:I - 1) / (I-1)
data <- list(N=I, X=X, Mu=Mu, Y=Y)

model <- cmdstan_model('ex3.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
