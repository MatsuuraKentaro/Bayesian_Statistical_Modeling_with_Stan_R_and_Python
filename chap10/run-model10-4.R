library(cmdstanr)

d <- read.csv(file='input/data-poisson-binomial.csv')
data <- list(N=nrow(d), Y=d$Y)

model <- cmdstan_model(stan_file='model/model10-4.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model10-4.RDS')
