library(dplyr)
library(cmdstanr)
library(KernSmooth)
library(loo)

model <- cmdstan_model('model/model14-8.stan')
N_sim <- 10000
Mu_all <- 0
SD_Mu <- 10.0
SD_y <- 2.0
EPS <- 1e-12

G       <- 10
N_per_G <- 5
N       <- N_per_G * G
n2g <- data.frame(n=1:N, g=rep(1:G, times=N_per_G))
g2n_list <- split(n2g$n, n2g$g)

f_marginal <- Vectorize(function(y, mu_all, s_mu, s_y) {
  f <- function(x, y, mu_all, s_mu, s_y) {
    dnorm(x, mean=mu_all, sd=s_mu) * dnorm(y, mean=x, sd=s_y)
  }
  integrate(f, mu_all-6*s_mu, mu_all+6*s_mu, 
            y, mu_all, s_mu, s_y)$value
})

d_res <- lapply(1:N_sim, function(simID) {
  set.seed(simID)
  Mu <- rnorm(G, mean=Mu_all,    sd=SD_Mu)
  Y  <- rnorm(N, mean=Mu[n2g$g], sd=SD_y)
  data <- list(N=N, G=G, n2g=n2g$g, Y=Y)
  mess <- capture.output(
    fit <- model$sample(data=data, seed=123, iter_sampling=2500,
                        refresh=0, show_messages=FALSE))
  
  yp1_ms <- fit$draws('yp1', format='matrix')
  ge_by_group <- sapply(1:G, function(g) {
    dens <- bkde(yp1_ms[,g,drop=TRUE])
    f_pred <- approxfun(dens$x, ifelse(dens$y <= EPS, EPS, dens$y), 
                        yleft=EPS, yright=EPS)
    f_true <- function(y) dnorm(y, mean=Mu[g], sd=SD_y)
    f_ge   <- function(y) f_true(y)*(-log(f_pred(y)))
    ge <- integrate(f_ge, Mu[g]-6*SD_y, Mu[g]+6*SD_y)$value
  })

  log_lik1_ms <- fit$draws('log_lik1', format='matrix')
  ic_by_group <- lapply(1:G, function(g) {
    n_vec <- g2n_list[[g]]
    waic  <- waic(log_lik1_ms[,n_vec])$waic/(2*length(n_vec))
    looic <- loo(log_lik1_ms[,n_vec])$looic/(2*length(n_vec))
    data.frame(waic=waic, looic=looic)
  }) %>% bind_rows()
  
  yp2_ms <- fit$draws('yp2', format='matrix') %>% as.vector()
  ge_marginal <- {
    dens <- bkde(yp2_ms)
    f_pred <- approxfun(dens$x, ifelse(dens$y <= EPS, EPS, dens$y), 
                        yleft=EPS, yright=EPS)
    f_true <- function(y) f_marginal(y, Mu_all, SD_Mu, SD_y)
    f_ge   <- function(y) f_true(y)*(-log(f_pred(y)))
    ge <- integrate(f_ge, -6*SD_Mu-6*SD_y, 6*SD_Mu+6*SD_y)$value
  }
  
  d_ms <- fit$draws(c('mu_all', 's_mu', 's_y'), format='df')
  N_mcmc <- nrow(d_ms)
  log_lik2 <- t(sapply(seq_len(N_mcmc), function(i) {
    log(f_marginal(Y, d_ms$mu_all[i], d_ms$s_mu[i], d_ms$s_y[i]))
  }))
  waic  <- waic(log_lik2)$waic/(2*N)
  looic <- loo(log_lik2)$looic/(2*N)
  
  d1 <- data.frame(simID=simID, g=1:G, ge=ge_by_group, ic_by_group)
  d2 <- data.frame(simID=simID, g=-1,  ge=ge_marginal, waic, looic)
  rbind(d1, d2)
}) %>% bind_rows()


## calculate entropy
# f_true1 <- function(y) dnorm(y, mean=0, sd=SD_y)  
# f_en1   <- function(y) f_true1(y)*(-log(f_true1(y)))
# en1 <- integrate(f_en1, lower=-6*SD_y, upper=6*SD_y)$value
# f_true2 <- function(y) f_marginal(y, Mu_all, SD_Mu, SD_y)
# f_en2   <- function(y) f_true2(y)*(-log(f_true2(y)))
# en2 <- integrate(f_en2, lower=-6*SD_Mu-6*SD_y, upper=6*SD_Mu+6*SD_y)$value
