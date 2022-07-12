library(cmdstanr)

d <- read.csv('input/data-mvn.csv')
data <- list(N=nrow(d), D=2, Y=d)

model <- cmdstan_model(stan_file='model/model6-5.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model6-5.RDS')

model_b <- cmdstan_model(stan_file='model/model6-5b.stan')
fit_b <- model$sample(data=data, seed=123, parallel_chains=4)
fit_b$save_object(file='output/result-model6-5b.RDS')
