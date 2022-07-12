library(dplyr)
library(cmdstanr)

d <- read.csv('data-ex3.csv')
N <- nrow(d)
C <- max(d$countryID)
S <- max(d$schoolID)
s2c <- d %>% select(schoolID, countryID) %>% distinct() %>% pull(countryID)
n2s <- d$schoolID
data <- list(N=N, C=C, S=S, Y=d$Y, s2c=s2c, n2s=n2s)

model <- cmdstan_model(stan_file='ex3.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
