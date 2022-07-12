library(cmdstanr)

d <- read.csv('../input/data-season.csv')
T <- nrow(d)
data <- list(T=T, Y=d$Y, L=4, Tp=8)

model <- cmdstan_model('ex2.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='ex2.RDS')
