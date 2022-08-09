library(dplyr)
library(cmdstanr)
library(KernSmooth)
library(loo)

model <- cmdstan_model('model/model14-7.stan')
N_sim <- 10000
D <- 3
b <- c(1.3, -3.1, 0.7)
SD <- 2.5
EPS <- 1e-12

set.seed(123)
N <- 30
X <- cbind(1, matrix(runif(N*(D-1), -3, 3), N, (D-1)))
Mu <- X %*% b

d_res <- lapply(1:N_sim, function(simID) {
  set.seed(simID)
  Y <- rnorm(N, Mu, SD)
  data <- list(N=N, D=D, X=X, Y=Y)
  mess <- capture.output(
    fit <- model$sample(data=data, seed=123, iter_sampling=2500,
                        parallel_chains=4, show_messages=FALSE))
  yp_ms <- fit$draws('yp', format='matrix')
  ge_by_data_point <- sapply(1:N, function(n) {
    dens <- bkde(yp_ms[,n,drop=TRUE])
    f_pred <- approxfun(dens$x, ifelse(dens$y <= EPS, EPS, dens$y), 
                        yleft=EPS, yright=EPS)
    f_true <- function(y) dnorm(y, mean=Mu[n], sd=SD)
    f_ge   <- function(y) f_true(y)*(-log(f_pred(y)))
    ge <- integrate(f_ge, Mu[n]-6*SD, Mu[n]+6*SD)$value
  })
  ge <- mean(ge_by_data_point)
  
  log_lik_ms <- fit$draws('log_lik', format='matrix')
  waic  <- waic(log_lik_ms)$waic/(2*N)
  looic <- loo(log_lik_ms)$looic/(2*N)
  data.frame(ge=ge, waic=waic, looic=looic)
}) %>% bind_rows()


## calculate entropy
# f_true0 <- function(y) dnorm(y, mean=0, sd=SD)  
# f_en <- function(y) f_true0(y)*(-log(f_true0(y)))
# en <- integrate(f_en, -6*SD, 6*SD)$value

## calculate waic by myself
# waic <- function(log_lik_ms) {
#   tr_error_by_data_point <- - log(colMeans(exp(log_lik_ms)))
#   func_var_by_data_point <- colMeans(log_lik_ms^2) - colMeans(log_lik_ms)^2
#   
#   waic_by_data_point <- tr_error_by_data_point + func_var_by_data_point
#   waic <- mean(waic_by_data_point)
#   return(waic)
# }
