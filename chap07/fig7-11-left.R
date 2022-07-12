library(dplyr)
library(ggplot2)

d <- read.csv(file='input/data-outlier.csv')
Np <- 101
Xp <- seq(from=0, to=11, length=Np)

fit <- readRDS('output/result-model7-7.RDS')
yp_ms <- fit$draws('yp', format='matrix')
qua <- apply(yp_ms, 2, quantile, prob=c(0.025, 0.25, 0.5, 0.75, 0.975))
d_est <- data.frame(X=Xp, t(qua), check.names=FALSE)


p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=1) +
  geom_point(data=d, aes(x=X, y=Y), shape=1, size=3) +
  labs(x='X', y='Y') +
  coord_cartesian(xlim=c(-0.2, 11.2), ylim=c(-25, 75))
ggsave(file='output/fig7-11-left.png', plot=p, dpi=300, w=4, h=3)
