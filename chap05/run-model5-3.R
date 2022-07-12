library(cmdstanr)
set.seed(123)

d <- read.csv(file='input/data-shopping-1.csv')
d$Income <- d$Income/100
N <- nrow(d)
Y_sim_mean <- 0.2 + 0.15*d$Sex + 0.4*d$Income
Y_sim <- rnorm(N, mean=Y_sim_mean, sd=0.1)
data_sim <- list(N=N, Sex=d$Sex, Income=d$Income, Y=Y_sim)
data     <- list(N=N, Sex=d$Sex, Income=d$Income, Y=d$Y)

model <- cmdstan_model(stan_file='model/model5-3.stan')
fit_sim <- model$sample(data=data_sim, seed=123, parallel_chains=4)
fit     <- model$sample(data=data,     seed=123, parallel_chains=4)
fit$save_object(file='output/result-model5-3.RDS')
