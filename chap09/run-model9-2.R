library(cmdstanr)

d <- read.csv(file='input/data-tortoise-hare.csv')
data <- list(N=2, G=nrow(d), g2L=d$Loser, g2W=d$Winner)

model <- cmdstan_model(stan_file='model/model9-2.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model9-2.RDS')
