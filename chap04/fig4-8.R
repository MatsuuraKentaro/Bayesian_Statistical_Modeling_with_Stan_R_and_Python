library(ggplot2)

fit <- readRDS('output/result-model4-4.RDS')
d_ms <- fit$draws(format='df')
N_ms <- nrow(d_ms)

d <- read.csv(file='input/data-salary.csv')
Xp <- seq(0, 28, by = 1)
Np <- length(Xp)

set.seed(123)

yp_base_ms <- matrix(nrow=N_ms, ncol=Np)
yp_ms <- matrix(nrow=N_ms, ncol=Np)
for (n in 1:Np) {
  yp_base_ms[,n] <- d_ms$a + d_ms$b * Xp[n]
  yp_ms[,n] <- rnorm(n=N_ms, mean=yp_base_ms[,n], sd=d_ms$sigma)
}


qua <- apply(yp_base_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=Xp, t(qua), check.names = FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=1) +
  geom_point(data=d, aes(x=X, y=Y), shape=1, size=3) +
  coord_cartesian(ylim = c(32, 67)) +
  scale_y_continuous(breaks=seq(40, 60, 10)) +
  labs(y='Y')
ggsave(p, file='output/fig4-8-left.png', dpi=300, w=3.5, h=3)


qua <- apply(yp_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=Xp, t(qua), check.names = FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=1) +
  geom_point(data=d, aes(x=X, y=Y), shape=1, size=3) +
  coord_cartesian(ylim = c(32, 67)) +
  scale_y_continuous(breaks=seq(40, 60, 10)) +
  labs(y='Y')
ggsave(p, file='output/fig4-8-right.png', dpi=300, w=3.5, h=3)
