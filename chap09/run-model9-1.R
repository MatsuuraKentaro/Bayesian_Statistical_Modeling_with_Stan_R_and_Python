library(cmdstanr)

d <- read.csv(file='input/data-category.csv')
d$Age <- d$Age/100
d$Income <- d$Income/1000
X <- cbind(1, d[,-ncol(d)])
data <- list(N=nrow(d), D=ncol(X), K=6, X=X, Y=d$Y)

model <- cmdstan_model(stan_file='model/model9-1.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model9-1.RDS')
