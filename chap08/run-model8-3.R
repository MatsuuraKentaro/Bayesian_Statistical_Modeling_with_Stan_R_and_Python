library(cmdstanr)

d <- read.csv('input/data-salary-2.csv')
N <- nrow(d)
C <- 4
data <- list(N=N, C=C, X=d$X, Y=d$Y, n2c=d$CID)

model <- cmdstan_model(stan_file='model/model8-3.stan')
fit3 <- model$sample(data=data, seed=123, parallel_chains=4)
fit3$save_object(file='output/result-model8-3.RDS')
