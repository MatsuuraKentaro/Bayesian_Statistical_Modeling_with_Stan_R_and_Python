library(cmdstanr)

d <- read.csv('input/data-weight.csv')
T <- nrow(d)
Tp <- 3
data <- list(T=T, Tp=Tp, Y=d$Y)

model <- cmdstan_model('model/model11-2.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model11-2.RDS')

model_b <- cmdstan_model('model/model11-2b.stan')
fit_b <- model_b$sample(data=data, seed=123, parallel_chains=4)
fit_b$save_object(file='output/result-model11-2b.RDS')
