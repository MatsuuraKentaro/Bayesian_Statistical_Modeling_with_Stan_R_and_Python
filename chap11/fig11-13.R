library(ggplot2)

T <- 24
fit <- readRDS('output/result-model11-10.RDS')
trend_ms <- fit$draws('trend', format='matrix')
qua <- apply(trend_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=0:(T-1), t(qua), check.names = FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=0.5) +
  geom_point(data=d_est, aes(x=X, y=`50%`)) +
  labs(x='Time (Hour)', y='Y')
ggsave(p, file='output/fig11-13-left.png', dpi=300, w=4, h=3)


sw_ms <- fit$draws('sw', format='matrix')
qua <- apply(sw_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=0:(T-1), t(qua), check.names = FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=0.5) +
  geom_hline(yintercept=0, linetype='22', alpha=0.6) +
  geom_point(data=d_est, aes(x=X, y=`50%`)) +
  labs(x='Time (Hour)', y='Y')
ggsave(p, file='output/fig11-13-right.png', dpi=300, w=4, h=3)
