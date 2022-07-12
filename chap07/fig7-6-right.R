library(ggplot2)

d <- read.csv('input/data-sigEmax.csv')
Np <- 60
Xp <- seq(50, 650, len=Np)

fit <- readRDS('output/result-model7-4.RDS')
yp_ms <- fit$draws('yp', format='matrix')
qua <- apply(yp_ms, 2, quantile, prob=c(0.025, 0.25, 0.5, 0.75, 0.975))
d_est <- data.frame(X=Xp, t(qua), check.names=FALSE)


p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=0.5) +
  geom_point(data=d, aes(x=X, y=Y), size=2) +
  labs(x='X', y='Y') +
  ylim(2, 33)
ggsave(file='output/fig7-6-right.png', plot=p, dpi=300, w=4, h=3)
