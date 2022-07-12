library(cmdstanr)
library(dplyr)

d <- read.csv('input/data-ZIB.csv')
d$Age <- d$Age/10
X <- cbind(1, d[, 1:(ncol(d)-1)])
data <- list(N=nrow(d), D=ncol(X), X=X, Y=d$Y)

model <- cmdstan_model(stan_file='model/model10-7.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model10-7.RDS')

d_ms <- fit$draws(format='df')
N_ms <- nrow(d_ms)
q_f_ms <- d_ms %>% select(starts_with('q_f[')) %>% as.matrix()
q_r_ms <- d_ms %>% select(starts_with('q_r[')) %>% as.matrix()
r <- sapply(1:N_ms, function(i) cor(q_f_ms[i,], q_r_ms[i,]))
quantile(r, prob=c(0.025, 0.25, 0.5, 0.75, 0.975))
#       2.5%        25%        50%        75%      97.5%
# -0.8051751 -0.7017864 -0.6381477 -0.5680358 -0.4076642 

