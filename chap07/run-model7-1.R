library(cmdstanr)

d <- read.csv(file='input/data-rental.csv')
Np <- 50
Xp <- seq(from=10, to=120, length=Np)
data <- list(N=nrow(d), X=d$Area, Y=d$Y, Np=Np, Xp=Xp)

model <- cmdstan_model(stan_file='model/model7-1.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model7-1.RDS')
