library(cmdstanr)

d <- read.csv(file='input/data-gp-sparse.csv')
N <- nrow(d)
Ni <- 15
Xi <- seq(from=0, to=1, len=Ni)
Np <- 61
Xp <- seq(from=0, to=1, len=Np)
data <- list(Ni=Ni, N=N, Np=Np, Xi=Xi, X=d$X, Xp=Xp, 
             Mui=rep(0, Ni), Mu=rep(0, N), Mup=rep(0, Np), Y=d$Y)

model <- cmdstan_model('model/model12-10.stan')
# fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit_MAP <- model$optimize(data=data, seed=123)
fit_MAP$save_object(file='output/result-model12-10.RDS')
