library(cmdstanr)

d <- read.csv('data-ex4.csv')
T <- nrow(d)
data <- list(T=T, Y=d$Y)

model <- cmdstan_model('ex4.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4,
                    iter_warmup=2000, iter_sampling=4000)
