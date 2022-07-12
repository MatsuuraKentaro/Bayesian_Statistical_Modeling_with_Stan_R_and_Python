library(cmdstanr)

d <- read.csv('input/data-map-temperature.csv')
d2 <- read.csv('input/data-map-neighbor.csv')
I <- nrow(d)
data <- list(I=I, Y=d$Y, K=nrow(d2), From=d2$From, To=d2$To)

model <- cmdstan_model('model/model12-5.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4,
                    iter_sampling=5000)
fit$save_object(file='output/result-model12-5.RDS')
