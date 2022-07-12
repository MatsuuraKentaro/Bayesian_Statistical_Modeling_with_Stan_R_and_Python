library(cmdstanr)
library(dplyr)

d <- read.csv('input/data-shopping-3.csv')
N <- 50
d2 <- unique(d[,c('PersonID', 'Sex', 'Income')])
V <- nrow(d)
data <- list(N=N, V=V, Sex=d2$Sex, Income=d2$Income/100,
  v2n=d$PersonID, Dis=d$Discount, Y=d$Y)

model <- cmdstan_model(stan_file='model/model8-8.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4)
fit$save_object(file='output/result-model8-8.RDS')


library(pROC)
q_ms <- fit$draws('q', format='matrix')
N_ms <- nrow(q_ms)
spec <- seq(from=0, to=1, len=201)
probs <- c(0.1, 0.5, 0.9)

auces <- numeric(N_ms)
m_roc <- matrix(nrow=N_ms, ncol=length(spec))
for (i in 1:N_ms) {
  roc_res <- roc(d$Y, q_ms[i,,drop=TRUE], quiet=TRUE)
  auces[i] <- as.numeric(roc_res$auc)
  m_roc[i,] <- coords(roc_res, x=spec, input='specificity', ret='sensitivity') %>% unlist()
}
quantile(auces, prob=probs)
