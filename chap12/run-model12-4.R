library(dplyr)
library(cmdstanr)

model <- cmdstan_model('model/model12-4.stan')

A <- 76  # number of ages from 0 to 75+
Age_idx <- seq(from=0, to=75, by=5) + 1
Flow <- lapply(1:length(Age_idx), function(i) {
  data.frame(from = Age_idx[i] + c(-2,-1,1,2), 
             to   = Age_idx[i])
}) %>% 
  bind_rows() %>% 
  filter(from > 1 & from <= 76)

d <- read.csv(file='input/data-ageheap.csv')
d_M <- d %>% filter(Sex=='M')
d_F <- d %>% filter(Sex=='F')
data_M <- list(A=A, Y=d_M$Y, J=nrow(Flow), From=Flow$from, To=Flow$to)
data_F <- list(A=A, Y=d_F$Y, J=nrow(Flow), From=Flow$from, To=Flow$to)

fit_M <- model$sample(data=data_M, seed=123, parallel_chains=4)
fit_F <- model$sample(data=data_F, seed=123, parallel_chains=4)
fit_M$save_object(file='output/result-model12-4-M.RDS')
fit_F$save_object(file='output/result-model12-4-F.RDS')
