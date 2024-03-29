library(dplyr)
library(ggplot2)

d <- read.csv('input/data-switch.csv')
T <- nrow(d)

fit <- readRDS('output/result-model11-6.RDS')
sw_ms <- fit$draws('sw', format='matrix')
qua <- apply(sw_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=1:T, t(qua), check.names=FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_line(data=d, aes(x=X, y=Y), linewidth=0.3, alpha=0.4) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), linewidth=0.2) +
  geom_line(data=d_est, aes(x=X, y=`2.5%`), linewidth=0.2) +
  geom_line(data=d_est, aes(x=X, y=`97.5%`), linewidth=0.2) +
  geom_line(data=d_est, aes(x=X, y=`25%`), linewidth=0.2) +
  geom_line(data=d_est, aes(x=X, y=`75%`), linewidth=0.2) +
  labs(x='Time (Second)', y='Y')
ggsave(p, file='output/fig11-9-left.png', dpi=300, w=3.5, h=3)


fit <- readRDS('output/result-model11-7.RDS')
sw_ms <- fit$draws('sw', format='matrix')
qua <- apply(sw_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=1:T, t(qua), check.names=FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_line(data=d, aes(x=X, y=Y), linewidth=0.3, alpha=0.4) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), linewidth=0.2) +
  geom_line(data=d_est, aes(x=X, y=`2.5%`), linewidth=0.2) +
  geom_line(data=d_est, aes(x=X, y=`97.5%`), linewidth=0.2) +
  geom_line(data=d_est, aes(x=X, y=`25%`), linewidth=0.2) +
  geom_line(data=d_est, aes(x=X, y=`75%`), linewidth=0.2) +
  labs(x='Time (Second)', y='Y')
ggsave(p, file='output/fig11-9-right.png', dpi=300, w=3.5, h=3)
