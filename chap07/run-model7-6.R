library(cmdstanr)

d <- read.csv(file='input/data-protein.csv')
idx <- grep('<', d$Y)
Y_obs <- as.numeric(d[-idx, ])
L <- as.numeric(sub('<', '', d[idx,]))[1]
data <- list(N_obs=length(Y_obs), N_cens=length(idx), Y_obs=Y_obs, L=L)

model <- cmdstan_model(stan_file='model/model7-6.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model7-6.RDS')
