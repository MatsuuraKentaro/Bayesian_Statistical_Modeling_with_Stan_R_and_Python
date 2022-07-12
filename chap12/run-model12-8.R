library(cmdstanr)

Y <- read.csv('input/data-1D.csv')$Y
I <- length(Y)
Mu <- rep(mean(log(ifelse(Y == 0, 1, Y))), I)
X <- (1:I - 1) / (I-1)
data <- list(N=I, X=X, Mu=Mu, Y=Y)

model <- cmdstan_model('model/model12-8.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model12-8.RDS')
