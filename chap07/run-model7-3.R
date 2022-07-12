library(cmdstanr)

d <- read.csv('input/data-conc.csv')
Tp <- 60
Xp <- seq(from=0, to=24, length=Tp)
data <- list(T=nrow(d), X=d$Time, Y=d$Y, Tp=Tp, Xp=Xp)

model <- cmdstan_model(stan_file='model/model7-3.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model7-3.RDS')
