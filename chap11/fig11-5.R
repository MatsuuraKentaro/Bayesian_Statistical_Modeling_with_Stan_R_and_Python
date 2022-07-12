library(dplyr)
library(ggplot2)

d <- read.csv('input/data-weight.csv')
T <- nrow(d)
Tp <- 3

fit <- readRDS('output/result-model11-3.RDS')
mu_all_ms <- fit$draws('mu_all', format='matrix')
qua <- apply(mu_all_ms, 2, quantile, probs=c(0.1, 0.25, 0.50, 0.75, 0.9))
d_est <- data.frame(X=1:(T+Tp), t(qua), check.names=FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`10%`, ymax=`90%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=1) +
  geom_point(data=d, aes(x=X, y=Y), shape=16, size=2.5) +
  geom_vline(xintercept=T, linetype='dashed') +
  coord_cartesian(xlim=c(1, 24)) +
  labs(x='Time (Day)', y='Y')
ggsave(p, file='output/fig11-5-left.png', dpi=300, w=3.5, h=3)

d_residual <- data.frame(X=1:T, d_est[1:T,] - d$Y, check.names=FALSE)
png('output/fig11-5-right.png', pointsize=48, width=1200, height=900)
par(mar=c(4, 4, 0.1, 0.1))
acf(d_residual$`50%`, lwd=15, lend=1, main='')
dev.off()
