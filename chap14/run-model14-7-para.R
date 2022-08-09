lapply(c('foreach', 'doParallel', 'doRNG', 'cmdstanr', 'KernSmooth', 'loo'), library, character.only=TRUE)

model <- cmdstan_model('model/model14-7.stan')
N_sim <- 10000
D <- 3
b <- c(1.3, -3.1, 0.7)
SD <- 2.5
EPS <- 1e-12
N_vec <- c(10, 30, 100, 300)
param <- expand.grid(simID=seq_len(N_sim), N=N_vec)

st_time <- proc.time()

registerDoParallel(10)

d_res <- foreach(paraID=seq_len(nrow(param)), .combine=rbind, .export=ls(envir=.GlobalEnv), .packages=c('cmdstanr', 'KernSmooth', 'loo'), .options.RNG=123) %dorng% {
  print(paste0('paraID=', paraID))
  N     <- param$N[paraID]
  simID <- param$simID[paraID]
  set.seed(123)
  X <- cbind(1, matrix(runif(N*(D-1), -3, 3), N, (D-1)))
  Mu <- X %*% b
  
  set.seed(simID)
  Y <- rnorm(N, Mu, SD)
  data <- list(N=N, D=D, X=X, Y=Y)
  mess <- capture.output(
    fit <- model$sample(data=data, seed=123, iter_sampling=2500,
                        refresh=0, show_messages=FALSE))

  yp_ms <- fit$draws('yp', format='matrix')
  ge_by_data_point <- sapply(1:N, function(n) {
    dens <- bkde(yp_ms[,n,drop=TRUE])
    f_pred <- approxfun(dens$x, ifelse(dens$y <= EPS, EPS, dens$y), 
                        yleft=EPS, yright=EPS)
    f_true <- function(y) dnorm(y, mean=Mu[n], sd=SD)  
    f_ge <- function(y) f_true(y)*(-log(f_pred(y)))
    ge <- NA
    try(ge <- integrate(f_ge, lower=Mu[n]-6*SD, upper=Mu[n]+6*SD)$value)
    if (is.na(ge)) try(ge <- pracma::romberg(f_ge, a=Mu[n]-6*SD, b=Mu[n]+6*SD)$value)
    ge
  })
  ge <- mean(ge_by_data_point, na.rm=TRUE)
  
  log_lik_ms <- fit$draws('log_lik', format='matrix')
  waic  <- NA
  looic <- NA
  try(waic  <- waic(log_lik_ms)$waic/(2*N))
  try(looic <- loo(log_lik_ms)$looic/(2*N))
  data.frame(N=N, simID=simID, ge=ge, waic=waic, looic=looic)
}

elapsed_time <- proc.time() - st_time

# f_true0 <- function(y) dnorm(y, mean=0, sd=SD)  
# f_en <- function(y) f_true0(y)*(-log(f_true0(y)))
# en <- integrate(f_en, lower=-6*SD, upper=6*SD)$value

save.image('output/result-model14-7.RData')
stopImplicitCluster()
