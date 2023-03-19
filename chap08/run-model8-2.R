library(cmdstanr)

d <- read.csv('input/data-salary-2.csv')
N <- nrow(d)
C <- 4
data <- list(N=N, C=C, X=d$X, Y=d$Y, n2c=d$CID)

model <- cmdstan_model(stan_file='model/model8-2.stan')
fit2 <- model$sample(data=data, seed=123, parallel_chains=4)
fit2$save_object(file='output/result-model8-2.RDS')
