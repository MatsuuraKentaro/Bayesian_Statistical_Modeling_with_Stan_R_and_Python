library(dplyr)
library(tidyr)
library(cmdstanr)

d_wide <- read.csv('input/data-conc-2-NA-wide.csv')
N <- nrow(d_wide)
X <- c(1, 2, 4, 8, 12, 24)
T <- length(X)
Tp <- 60
Xp <- seq(from=0, to=24, length=Tp)
colnames(d_wide) <- c('PersonID', paste0('TimeID', 1:T))
d <- d_wide %>% 
  pivot_longer(-PersonID, names_to='TimeID', values_to='Y') %>% 
  mutate(TimeID=readr::parse_number(TimeID)) %>% 
  na.omit()
data <- list(I=nrow(d), N=N, T=T, X=X, Tp=Tp, Xp=Xp,
             i2n=d$PersonID, i2t=d$TimeID, Y=d$Y)

model <- cmdstan_model(stan_file='model/model8-7.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)

fit$save_object(file='output/result-model8-7.RDS')
# write.table(d, file='input/data-conc-2-NA-long.csv', sep=',', quote=FALSE, row.names=FALSE)
