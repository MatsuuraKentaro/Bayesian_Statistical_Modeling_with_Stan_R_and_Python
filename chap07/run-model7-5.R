library(cmdstanr)

d <- read.csv(file='input/data-50m.csv')
data <- list(N=nrow(d), Age=d$Age, Weight=d$Weight, Y=d$Y)

model <- cmdstan_model(stan_file='model/model7-5.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model7-5.RDS')
