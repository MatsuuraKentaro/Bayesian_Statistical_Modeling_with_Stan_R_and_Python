library(cmdstanr)
set.seed(123)

K <- 5
mu_true <- c(10.0, 11.5, 10.4, 12.8, 9.7)
sd_true <- 3.5
T_ini <- 10
T <- 90

fetch_y <- function(len, k) {
  return(rnorm(len, mean=mu_true[k], sd=sd_true))
}

k_cum <- rep(1:K, len=T_ini)
y_cum <- fetch_y(T_ini, k_cum)
model <- cmdstan_model('model/model13-2.stan')

for (t in 1:T) {
  data <- list(N=length(y_cum), K=K, n2k=k_cum, Y=y_cum)
  mess <- capture.output(
    fit <- model$sample(data=data, seed=123, parallel_chains=4,
                        refresh=0, show_messages=FALSE))
  mu_ms <- fit$draws('mu', format='matrix')
  N_ms <- nrow(mu_ms)
  rand <- sample.int(n=N_ms, size=1)
  k_sel <- which.max(mu_ms[rand,])
  y_sel <- fetch_y(1, k_sel)
  k_cum <- c(k_cum, k_sel)
  y_cum <- c(y_cum, y_sel)
}
