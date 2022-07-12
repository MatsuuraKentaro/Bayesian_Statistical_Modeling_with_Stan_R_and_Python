library(dplyr)
library(ggplot2)

d <- read.csv(file='input/data-gp.csv')
N <- nrow(d)
Np <- 61
Xp <- seq(from=0, to=1, len=Np)

fit <- readRDS('output/result-model12-7d.RDS')
yp_ms <- fit$draws('yp', format='matrix')
qua <- apply(yp_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=Xp, t(qua), check.names=FALSE)

p <- ggplot(data=d_est) +
  theme_bw(base_size=18) +
  geom_line(aes(x=X, y=`50%`), size=0.5) +
  geom_line(aes(x=X, y=`2.5%`), size=0.4, alpha=0.5) +
  geom_line(aes(x=X, y=`97.5%`), size=0.4, alpha=0.5) +
  geom_line(aes(x=X, y=`25%`), size=0.4, alpha=0.6, linetype='32') +
  geom_line(aes(x=X, y=`75%`), size=0.4, alpha=0.6, linetype='32') +
  geom_point(data=d, aes(x=X, y=Y), size=2, alpha=0.6) +
  ylim(-3, 3) +
  labs(x='X', y='Y')
ggsave(p, file='output/fig12-14.png', dpi=300, w=4, h=3)
