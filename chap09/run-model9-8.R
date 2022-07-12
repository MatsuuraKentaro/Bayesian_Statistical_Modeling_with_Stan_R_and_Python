library(cmdstanr)

model_a <- cmdstan_model(stan_file='model/model9-8.stan')
fit_a <- model_a$sample(seed=123, chains=1, iter_sampling=2000)
fit_a$save_object(file='output/result-model9-8.RDS')

model_b <- cmdstan_model(stan_file='model/model9-9.stan')
fit_b <- model_b$sample(seed=123, chains=1, iter_sampling=2000)
fit_b$save_object(file='output/result-model9-9.RDS')
