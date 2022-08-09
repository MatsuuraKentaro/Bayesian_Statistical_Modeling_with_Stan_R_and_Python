lapply(c('foreach', 'doParallel', 'doRNG', 'cmdstanr', 'loo'), library, character.only=TRUE)

model <- cmdstan_model('model/model14-a-logistic.stan')
logistic <- function(x) 1/(1+exp(-x))
N_sim <- 10000
D <- 3
b <- c(0.8, -1.1, 0.5)
N_vec <- c(10, 30, 100, 300)
param <- expand.grid(simID=seq_len(N_sim), N=N_vec)

registerDoParallel(11)

d_res <- foreach(paraID=seq_len(nrow(param)), .combine=rbind, .export=ls(envir=.GlobalEnv), .packages=c('cmdstanr', 'loo'), .options.RNG=123) %dorng% {
  print(paste0('paraID=', paraID))
  N     <- param$N[paraID]
  simID <- param$simID[paraID]
  set.seed(123)
  X <- cbind(1, matrix(runif(N*(D-1), -3, 3), N, (D-1)))
  Mu <- logistic(X %*% b)
  
  set.seed(simID)
  Y <- rbinom(N, size=1, prob=Mu)
  data <- list(N=N, D=D, X=X, Y=Y)
  fit <- NULL
  mess <- capture.output(
    fit <- model$sample(data=data, seed=123, iter_sampling=2500,
                        refresh=0, show_messages=FALSE))
  if (is.null(fit)) return(NULL)
  
  yp_ms <- fit$draws('yp', format='matrix')
  N_mcmc <- nrow(yp_ms)
  ge_by_data_point <- sapply(1:N, function(n) {
    post <- table(factor(yp_ms[,n,drop=TRUE], levels=0:1))/N_mcmc
    f_pred <- function(y) dbinom(y, size=1, prob=post['1'])
    f_true <- function(y) dbinom(y, size=1, prob=Mu[n])
    f_ge <- function(y) f_true(y)*(-log(f_pred(y)))
    ge <- sum(sapply(0:1, f_ge))
  })
  ge <- mean(ge_by_data_point)
  
  log_lik_ms <- fit$draws('log_lik', format='matrix')
  waic  <- waic(log_lik_ms)$waic/(2*N)
  looic <- loo(log_lik_ms)$looic/(2*N)
  data.frame(N=N, simID=simID, ge=ge, waic=waic, looic=looic)
}

save.image('output/result-model14-a-logistic.RData')
stopImplicitCluster()
