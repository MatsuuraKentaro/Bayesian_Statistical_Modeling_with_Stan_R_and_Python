library(cmdstanr)
set.seed(123)

fetch_y <- function(x) {
  mu <- cos(9.5*x-2) - sin(15*x-1) + 5
  SD <- 0.25
  y <- rnorm(n=length(x), mean=mu, sd=SD)
  return(y)
}

T <- 20
Np <- 81
Xp <- seq(0, 1, len=Np)
x_sel <- 0.5
y_sel <- fetch_y(x_sel)
x_cum <- x_sel
y_cum <- y_sel
model <- cmdstan_model('../chap12/model/model12-7d.stan')

for (t in 1:T) {
  N <- length(x_cum)
  data <- list(N=N, Np=Np, X=x_cum, Xp=Xp, Mu=rep(0,N), rep(0,Np),
               Y=y_cum - mean(y_cum))
  mess <- capture.output(
    fit <- model$sample(data=data, seed=123, parallel_chains=4,
                        refresh=0, show_messages=FALSE))
  fp_ms <- fit$draws('fp', format='matrix')
  N_ms <- nrow(fp_ms)
  rand <- sample.int(n=N_ms, size=1)
  np_sel <- which.max(fp_ms[rand,])
  x_sel <- Xp[np_sel]
  y_sel <- fetch_y(x_sel)
  x_cum <- c(x_cum, x_sel)
  y_cum <- c(y_cum, y_sel)
}
