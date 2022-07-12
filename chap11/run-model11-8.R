library(cmdstanr)

d <- read.csv('input/data-pulse.csv')
T <- nrow(d)
data <- list(T=T, Y=d$Y)

model <- cmdstan_model('model/model11-8.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model11-8.RDS')
