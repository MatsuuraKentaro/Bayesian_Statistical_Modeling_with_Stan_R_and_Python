library(dplyr)
library(tidyr)
library(cmdstanr)

d <- read.csv('input/data-eg1.csv') %>% 
  pivot_wider(id_cols=c(Group, PID), names_from=Time, values_from=Y) 
Y1 <- d %>% filter(Group==1) %>% select(-Group, -PID)
Y2 <- d %>% filter(Group==2) %>% select(-Group, -PID)
T <- ncol(Y1)
N1 <- nrow(Y1)
N2 <- nrow(Y2)
data <- list(T=T, N1=N1, N2=N2, Y1=Y1, Y2=Y2)

model <- cmdstan_model('model/model11-10.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model11-10.RDS')
