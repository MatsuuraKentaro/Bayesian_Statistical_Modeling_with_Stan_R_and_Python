library(cmdstanr)

d <- read.csv(file='input/data-shopping-4.csv')
d$Income <- d$Income/100
N <- nrow(d)
X <- cbind(1, d[, 2:(ncol(d)-1)])
data <- list(N=nrow(d), D=ncol(X), X=X, Y=d$Y)

model <- cmdstan_model(stan_file='model/model5-7.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model5-7.RDS')
