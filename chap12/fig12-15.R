library(ggplot2)

Y <- read.csv('input/data-1D.csv')$Y
I <- length(Y)
X <- (1:I - 1) / (I-1)
d <- data.frame(X=X, Y=Y)

fit <- readRDS('output/result-model12-8.RDS')
y_mean_ms <- fit$draws('y_mean', format='matrix')
qua <- apply(y_mean_ms, 2, quantile, probs=c(0.1, 0.25, 0.50, 0.75, 0.9))
d_est <- data.frame(X=X, t(qua), check.names=FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`10%`, ymax=`90%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`), size=0.5) +
  geom_point(data=d, aes(x=X, y=Y), shape=1, size=2) +
  coord_cartesian(ylim = c(0, 22)) +
  labs(x='X', y='Y')
ggsave(p, file='output/fig12-15.png', dpi=300, w=4, h=3)
