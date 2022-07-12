lapply(c('foreach', 'doParallel', 'doRNG', 'cmdstanr', 'loo', 'Rcpp', 'RcppGSL'), library, character.only=TRUE)

model <- cmdstan_model('model/model14-8.stan')
N_sim <- 10
Mu_all <- 0
SD_Mu <- 10.0
SD_y <- 2.0
EPS <- 1e-12
G_vec <- c(10, 30, 100)
N_per_G_vec <- c(2, 5, 13)
param <- expand.grid(simID=seq_len(N_sim), G=G_vec, N_per_G=N_per_G_vec)
sourceCpp('gsl_cquad.cpp')

st_time <- proc.time()

registerDoParallel(10)

d_res <- foreach(paraID=seq_len(nrow(param)), .combine=rbind, .export=ls(envir=.GlobalEnv), .packages=c('cmdstanr', 'loo', 'KernSmooth', 'dplyr'), .options.RNG=123) %dorng% {
  print(paste0('paraID=', paraID))
  G       <- param$G[paraID]
  N_per_G <- param$N_per_G[paraID]
  N       <- N_per_G * G
  n2g <- data.frame(n=1:N, g=rep(1:G, times=N_per_G))
  g2n_list <- split(n2g$n, n2g$g)
  simID  <- param$simID[paraID]
  set.seed(simID)
  Mu <- rnorm(G, mean=Mu_all,    sd=SD_Mu)
  Y  <- rnorm(N, mean=Mu[n2g$g], sd=SD_y)
  data <- list(N=N, G=G, n2g=n2g$g, Y=Y)
  fit <- NULL
  mess <- capture.output(
    try(fit <- model$sample(data=data, seed=123, iter_sampling=2500,
                        refresh=0, show_messages=FALSE)))
  if(is.null(fit)) return(NULL)
  
  yp1_ms <- fit$draws('yp1', format='matrix')
  ge_by_group <- sapply(1:G, function(g) {
    dens <- bkde(yp1_ms[,g,drop=TRUE])
    f_pred <- approxfun(dens$x, ifelse(dens$y <= EPS, EPS, dens$y), 
                        yleft=EPS, yright=EPS)
    f_true <- function(y) dnorm(y, mean=Mu[g], sd=SD_y)
    f_ge   <- function(y) f_true(y)*(-log(f_pred(y)))
    ge <- NA
    try(ge <- integrate(f_ge, Mu[g]-6*SD_y, Mu[g]+6*SD_y)$value)
    if (is.na(ge)) try(ge <- pracma::romberg(f_ge, a=Mu[g]-6*SD_y, b=Mu[g]+6*SD_y)$value)
    ge
  })
  
  log_lik1_ms <- fit$draws('log_lik1', format='matrix')
  ic_by_group <- lapply(1:G, function(g) {
    n_vec <- g2n_list[[g]]
    waic  <- NA
    looic <- NA
    try(waic  <- waic(log_lik1_ms[,n_vec])$waic/(2*length(n_vec)))
    try(looic <- loo(log_lik1_ms[,n_vec])$looic/(2*length(n_vec)))
    data.frame(waic=waic, looic=looic)
  }) %>% bind_rows()
  
  yp2_ms <- fit$draws('yp2', format='matrix') %>% as.vector()
  ge_marginal <- {
    dens <- bkde(yp2_ms)
    f_pred <- approxfun(dens$x, ifelse(dens$y <= EPS, EPS, dens$y), 
                        yleft=EPS, yright=EPS)
    f_true <- function(y) f_marginal(y, Mu_all, SD_Mu, SD_y)
    f_ge   <- function(y) f_true(y)*(-log(f_pred(y)))
    ge <- NA
    try(ge <- integrate(f_ge, -6*SD_Mu-6*SD_y, 6*SD_Mu+6*SD_y)$value)
    if (is.na(ge)) try(ge <- pracma::romberg(f_ge, a=-6*SD_Mu-6*SD_y, b=6*SD_Mu+6*SD_y)$value)
    ge
  }

  d_ms <- fit$draws(c('mu_all', 's_mu', 's_y'), format='df')
  log_lik2 <- log(f_marginal_multi(Y, d_ms$mu_all, d_ms$s_mu, d_ms$s_y))
  waic  <- NA
  looic <- NA
  try(waic  <- waic(log_lik2)$waic/(2*N))
  try(looic <- loo(log_lik2)$looic/(2*N))
  
  d1 <- data.frame(G=G, N_per_G=N_per_G, simID=simID, g=1:G, ge=ge_by_group, ic_by_group)
  d2 <- data.frame(G=G, N_per_G=N_per_G, simID=simID, g=-1,  ge=ge_marginal, waic, looic)
  rbind(d1, d2)
}

elapsed_time <- proc.time() - st_time

# f_true1 <- function(y) dnorm(y, mean=0, sd=SD_y)  
# f_en1   <- function(y) f_true1(y)*(-log(f_true1(y)))
# en1 <- integrate(f_en1, lower=-6*SD_y, upper=6*SD_y)$value
# f_true2 <- function(y) integrate_my_cquad(y, Mu_all, SD_Mu, SD_y)
# f_en2   <- function(y) f_true2(y)*(-log(f_true2(y)))
# en2 <- integrate(f_en2, lower=-6*SD_Mu-6*SD_y, upper=6*SD_Mu+6*SD_y)$value

save.image('output/result-model14-8.RData')
stopImplicitCluster()
