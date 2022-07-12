library(ggplot2)

d <- read.csv('input/data-conc.csv')
Tp <- 60
Xp <- seq(from=0, to=24, length=Tp)

fit <- readRDS('output/result-model7-3.RDS')
yp_ms <- fit$draws('yp', format='matrix')
qua <- apply(yp_ms, 2, quantile, prob=c(0.025, 0.25, 0.5, 0.75, 0.975))
d_est <- data.frame(X=Xp, t(qua), check.names=FALSE)


p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=0.5) +
  geom_point(data=d, aes(x=Time, y=Y), size=2) +
  labs(x='Time (hour)', y='Y') +
  scale_x_continuous(breaks=d$Time, limit=c(0, 24)) +
  ylim(-2.5, 16)
ggsave(file='output/fig7-5-right.png', plot=p, dpi=300, w=4, h=3)
