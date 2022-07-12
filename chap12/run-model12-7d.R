library(cmdstanr)

d <- read.csv(file='input/data-gp.csv')
N <- nrow(d)
Np <- 61
Xp <- seq(from=0, to=1, len=Np)
data <- list(N=N, Np=Np, X=d$X, Xp=Xp, Mu=rep(0, N), Mup=rep(0, Np), Y=d$Y)

model <- cmdstan_model('model/model12-7d.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model12-7d.RDS')
fit_MAP <- model$optimize(data=data, seed=123)
