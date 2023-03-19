library(cmdstanr)

d <- read.csv('input/data-salary-2.csv')
N <- nrow(d)
data <- list(N=N, X=d$X, Y=d$Y)

model <- cmdstan_model(stan_file='model/model8-1.stan')
fit1 <- model$sample(data=data, seed=123, parallel_chains=4)
fit1$save_object(file='output/result-model8-1.RDS')
