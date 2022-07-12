library(cmdstanr)
library(dplyr)

set.seed(123)
d <- read.csv(file='input/data-tennis-2017.csv')
N <- max(d)
G <- nrow(d)
data <- list(N=N, G=G, g2L=d$Loser, g2W=d$Winner)

model <- cmdstan_model(stan_file='model/model9-3.stan')
fit <- model$sample(data=data, seed=123, 
                    init=function(){ list(mu=rnorm(N, 0, 0.05)) },
                    parallel_chains=4)
fit$save_object(file='output/result-model9-3.RDS')

mu_ms <- fit$draws('mu', format='matrix')
qua <- apply(mu_ms, 2, quantile, prob=c(0.05, 0.5, 0.95))
d_est <- data.frame(NID=1:N, t(qua), check.names=FALSE)
d_top5 <- d_est %>% slice_max(`50%`, n=5)
#         NID        5%      50%      95%
# mu[54]   54 1.6515475 2.142635 2.701341
# mu[117] 117 1.4823785 1.891510 2.354333
# mu[39]   39 0.8753171 1.357045 1.863492
# mu[174] 174 0.9058864 1.256475 1.674837
# mu[35]   35 0.7998884 1.238130 1.713748

s_pf_ms <- fit$draws('s_pf', format='matrix')
qua <- apply(s_pf_ms, 2, quantile, prob=c(0.05, 0.5, 0.95))
d_est <- data.frame(NID=1:N, t(qua), check.names=FALSE)
d_top3 <- d_est %>% slice_max(`50%`, n=3)
d_bot3 <- d_est %>% slice_min(`50%`, n=3)
#           NID        5%      50%      95%
# s_pf[94]   94 0.7668348 1.248740 1.872305
# s_pf[147] 147 0.7287111 1.225655 1.863775
# s_pf[81]   81 0.7037272 1.187765 1.821020

#           NID        5%      50%      95%
# s_pf[8]     8 0.4114912 0.700248 1.124152
# s_pf[117] 117 0.4165578 0.724443 1.163592
# s_pf[24]   24 0.4573924 0.790498 1.289026
