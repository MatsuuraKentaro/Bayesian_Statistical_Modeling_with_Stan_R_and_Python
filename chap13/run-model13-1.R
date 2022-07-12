library(cmdstanr)
set.seed(123)

N <- 20
Y1 <- 10
Y2 <- 14
data <- list(N=N, Y1=Y1, Y2=Y2)
model <- cmdstan_model('model/model13-1.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4, 
                    iter_sampling=10000)
n <- 93
pval_cut <- 0.05
N_sim <- 40000
d_ms <- fit$draws(format='df')
N_ms <- nrow(d_ms)

calc_pval <- function(y1, y2) {
  prop.test(c(y1, y2), c(n, n), correct=FALSE)$p.value
}

y1_MLE <- rbinom(n=N_sim, size=n, prob=Y1/N)
y2_MLE <- rbinom(n=N_sim, size=n, prob=Y2/N)
y1_Bay <- rbinom(n=N_ms, size=n, prob=d_ms$theta1)
y2_Bay <- rbinom(n=N_ms, size=n, prob=d_ms$theta2)
pvals_MLE <- mapply(calc_pval, y1_MLE, y2_MLE)
pvals_Bay <- mapply(calc_pval, y1_Bay, y2_Bay)
power     <- mean(pvals_MLE < pval_cut)
assurance <- mean(pvals_Bay < pval_cut)
