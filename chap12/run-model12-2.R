library(cmdstanr)

Y <- read.csv('input/data-1D.csv')$Y
I <- length(Y)
data <- list(I=I, Y=Y)

model <- cmdstan_model('model/model12-2.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model12-2.RDS')
