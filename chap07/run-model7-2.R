library(cmdstanr)

d <- read.csv(file='input/data-rental.csv')
Np <- 50
Xp <- seq(from=10, to=120, length=Np)
data <- list(N=nrow(d), X=log10(d$Area), Y=log10(d$Y), Np=Np, Xp=log10(Xp))

model <- cmdstan_model(stan_file='model/model7-2.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model7-2.RDS')
