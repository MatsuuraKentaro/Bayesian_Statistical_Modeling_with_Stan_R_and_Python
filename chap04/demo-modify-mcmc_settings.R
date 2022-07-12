library(cmdstanr)

d <- read.csv(file='input/data-salary.csv')
data <- list(N=nrow(d), X=d$X, Y=d$Y)
model <- cmdstan_model('model/model4-4.stan')

init_fun <- function(chain_id) {
  set.seed(chain_id)
  list(a=runif(1,30,50), b=runif(1,0,1), sigma=5)
}

fit <- model$sample(
  data=data, seed=123,
  init=init_fun,
  chains=3, iter_warmup=500, iter_sampling=500, thin=2,
  parallel_chains=3,
  save_warmup=TRUE
)
