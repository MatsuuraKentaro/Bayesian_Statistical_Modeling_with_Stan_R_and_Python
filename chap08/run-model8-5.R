library(cmdstanr)

d <- read.csv('input/data-salary-3.csv')
N <- nrow(d)
C <- 30
F <- 3
c2f <- unique(d[ , c('CID','FID')])$FID
data <- list(N=N, C=C, F=F, X=d$X, Y=d$Y, n2c=d$CID, c2f=c2f)

model <- cmdstan_model(stan_file='model/model8-5.stan')
fit <- model$sample(data=data, seed=1, parallel_chains=4)
fit$save_object(file='output/result-model8-5.RDS')
