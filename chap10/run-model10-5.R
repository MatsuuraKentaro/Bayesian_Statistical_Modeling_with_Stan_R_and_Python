library(cmdstanr)

d <- read.csv('input/data-mix1.csv')
data <- list(N=nrow(d), Y=d$Y)
init <- list(a=0.5, mu=c(0,5), sigma=c(1,1))

model <- cmdstan_model(stan_file='model/model10-5.stan')
fit <- model$sample(data=data, init=function() init, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model10-5.RDS')
