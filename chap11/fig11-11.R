library(ggplot2)

d <- read.csv('input/data-pulse.csv')
T <- nrow(d)

fit <- readRDS('output/result-model11-8.RDS')
pulse_ms <- fit$draws('pulse', format='matrix')
qua <- apply(pulse_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=1:T, t(qua), check.names=FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_line(data=d, aes(x=X, y=Y), size=0.3, alpha=0.4) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=0.2) +
  geom_line(data=d_est, aes(x=X, y=`2.5%`), size=0.2) +
  geom_line(data=d_est, aes(x=X, y=`97.5%`), size=0.2) +
  geom_line(data=d_est, aes(x=X, y=`25%`), size=0.2) +
  geom_line(data=d_est, aes(x=X, y=`75%`), size=0.2) +
  ylim(-0.3, 2.3) +
  labs(x='Time (Second)', y='Y')
ggsave(p, file='output/fig11-11-left.png', dpi=300, w=4, h=3)


fit <- readRDS('output/result-model11-9.RDS')
pulse_ms <- fit$draws('pulse', format='matrix')
qua <- apply(pulse_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=1:T, t(qua), check.names=FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_line(data=d, aes(x=X, y=Y), size=0.3, alpha=0.4) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=0.2) +
  geom_line(data=d_est, aes(x=X, y=`2.5%`), size=0.2) +
  geom_line(data=d_est, aes(x=X, y=`97.5%`), size=0.2) +
  geom_line(data=d_est, aes(x=X, y=`25%`), size=0.2) +
  geom_line(data=d_est, aes(x=X, y=`75%`), size=0.2) +
  ylim(-0.3, 2.3) +
  labs(x='Time (Second)', y='Y')
ggsave(p, file='output/fig11-11-right.png', dpi=300, w=4, h=3)
