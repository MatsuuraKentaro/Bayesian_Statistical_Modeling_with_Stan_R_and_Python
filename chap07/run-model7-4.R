library(cmdstanr)

d <- read.csv('input/data-sigEmax.csv')
N <- nrow(d)
Np <- 60
Xp <- seq(50, 650, len=Np)
data <- list(N=nrow(d), X=d$X, Y=d$Y, Np=Np, Xp=Xp)

model <- cmdstan_model(stan_file='model/model7-4.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model7-4.RDS')
