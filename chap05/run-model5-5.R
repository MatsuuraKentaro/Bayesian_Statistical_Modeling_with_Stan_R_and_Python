library(cmdstanr)

d <- read.csv(file='input/data-shopping-3.csv')
d$Income <- d$Income/100
data <- list(V=nrow(d), Sex=d$Sex, Income=d$Income, Dis=d$Discount, Y=d$Y)

model <- cmdstan_model(stan_file='model/model5-5.stan')
# model <- cmdstan_model(stan_file='model/model5-5b.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model5-5.RDS')
