library(cmdstanr)

d <- read.csv(file='input/data-gp.csv')
N <- nrow(d)
data <- list(N=N, X=d$X, Mu=rep(0, N), Y=d$Y)

model <- cmdstan_model('model/model12-7b.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model12-7b.RDS')
