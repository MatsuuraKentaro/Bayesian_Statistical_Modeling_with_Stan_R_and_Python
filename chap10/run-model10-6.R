library(cmdstanr)

d <- read.csv('input/data-mix2.csv')
K <- 5
data <- list(N=nrow(d), K=K, Y=d$Y)
init <- list(a=rep(1,K)/K, mu=seq(10,40,len=K), s_mu=20, sigma=rep(1,K))

model <- cmdstan_model(stan_file='model/model10-6.stan')
fit <- model$sample(data=data, init=function() init, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model10-6.RDS')

model_b <- cmdstan_model(stan_file='model/model10-6b.stan')
fit_b <- model_b$sample(data=data, init=function() init, seed=123, parallel_chains=4)
fit_b$save_object(file='output/result-model10-6b.RDS')
