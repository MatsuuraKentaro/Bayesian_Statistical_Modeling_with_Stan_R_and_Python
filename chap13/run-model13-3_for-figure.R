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
d_dat <- NULL
d_pre <- NULL
d_est <- NULL
d_sel <- NULL

for (t in 1:T) {
  d_dat <- rbind(d_dat, data.frame(time=t, X=x_sel, Y=y_sel))
  d_pre <- rbind(d_pre, data.frame(time=t+1, X=x_cum, Y=y_cum))
  
  N <- length(x_cum)
  y_mean <- mean(y_cum)
  data <- list(N=N, Np=Np, X=x_cum, Xp=Xp, Mu=rep(0,N), Mup=rep(0,Np),
               Y=y_cum - y_mean)
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
  
  qua <- apply(fp_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975)) + y_mean
  d_est <- rbind(d_est, data.frame(time=t, X=Xp, t(qua), check.names=FALSE))
  d_sel <- rbind(d_sel, data.frame(time=t, X=x_sel))
}

save.image('output/result-model13-3.RData')
