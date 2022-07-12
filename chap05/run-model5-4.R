library(cmdstanr)

d <- read.csv(file='input/data-shopping-2.csv')
d$Income <- d$Income/100
data <- list(N=nrow(d), Sex=d$Sex, Income=d$Income, M=d$M, Y=d$Y)

model <- cmdstan_model(stan_file='model/model5-4.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model5-4.RDS')
