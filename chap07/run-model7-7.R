library(cmdstanr)

d <- read.csv(file='input/data-outlier.csv')
Np <- 101
Xp <- seq(from=0, to=11, length=Np)
data <- list(N=nrow(d), X=d$X, Y=d$Y, Np=Np, Xp=Xp)

model <- cmdstan_model(stan_file='model/model7-7.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model7-7.RDS')
