library(cmdstanr)

d <- read.csv('input/data-conc-2.csv')
N <- nrow(d)
X <- c(1, 2, 4, 8, 12, 24)
T <- length(X)
Tp <- 60
Xp <- seq(from=0, to=24, length=Tp)
data <- list(N=N, T=T, X=X, Y=d[,-1], Tp=Tp, Xp=Xp)

model <- cmdstan_model(stan_file='model/model8-6.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model8-6.RDS')
