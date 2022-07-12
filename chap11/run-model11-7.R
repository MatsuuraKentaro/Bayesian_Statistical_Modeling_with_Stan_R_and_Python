library(cmdstanr)

d <- read.csv('input/data-switch.csv')
T <- nrow(d)
data <- list(T=T, Y=d$Y, B=0.2)

model <- cmdstan_model('model/model11-7.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4,
                    max_treedepth=15)
fit$save_object(file='output/result-model11-7.RDS')
