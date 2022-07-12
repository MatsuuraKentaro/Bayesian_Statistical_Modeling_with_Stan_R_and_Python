library(cmdstanr)

d <- read.csv('input/data-surv.csv')
N <- nrow(d)
months <- seq(as.Date('2014-01-01'), as.Date('2018-12-31'), by='month')
T <- length(months)
data <- list(N=N, T=T, Time=d$Time, Cens=d$Cens)

model <- cmdstan_model('model/model14-1.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model14-1.RDS')
