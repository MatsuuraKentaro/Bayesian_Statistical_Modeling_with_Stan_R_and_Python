library(dplyr)
library(ggplot2)

d <- read.csv('input/data-season.csv')
T <- nrow(d)
L <- 4

fit <- readRDS('output/result-model11-4.RDS')
season_ms <- fit$draws('season', format='matrix')
season_ms <- season_ms[, rep(1:L, len=T)]
qua <- apply(season_ms, 2, quantile, probs=c(0.1, 0.25, 0.50, 0.75, 0.9))
d_est <- data.frame(X=1:T, t(qua), check.names = FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`10%`, ymax=`90%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=0.5) +
  coord_cartesian(xlim=c(1, 44), ylim=c(-3.8, 6.2)) +
  labs(x='Time (Quarter)', y='Y')
ggsave(p, file='output/fig11-7-left.png', dpi=300, w=3.5, h=3)


fit <- readRDS('output/result-model11-5.RDS')
season_ms <- fit$draws('season', format='matrix')
qua <- apply(season_ms, 2, quantile, probs=c(0.1, 0.25, 0.50, 0.75, 0.9))
d_est <- data.frame(X=1:T, t(qua), check.names = FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`10%`, ymax=`90%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=0.5) +
  coord_cartesian(xlim=c(1, 44), ylim=c(-3.8, 6.2)) +
  labs(x='Time (Quarter)', y='Y')
ggsave(p, file='output/fig11-7-right.png', dpi=300, w=3.5, h=3)
