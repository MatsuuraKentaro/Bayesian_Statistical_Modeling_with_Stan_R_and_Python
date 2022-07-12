library(cmdstanr)

d <- read.csv('input/data-eg2.csv')
T <- 60
t_obs2t <- c(1:20, 31:40, 51:60)
T_obs <- length(t_obs2t)
t_bf2t <- 21:30
T_bf <- length(t_bf2t)
Y_obs <- d[t_obs2t, c('Weight', 'Bodyfat')]/10
Y_bf <- d[t_bf2t, 'Bodyfat']/10
data <- list(T=T, T_obs=T_obs, T_bf=T_bf,
  t_obs2t=t_obs2t, t_bf2t=t_bf2t, Y_obs=Y_obs, Y_bf=Y_bf, Nu=2)

model <- cmdstan_model('model/model11-11.stan')
fit <- model$sample(data=data, seed=12345, parallel_chains=4)
fit$save_object(file='output/result-model11-11.RDS')
