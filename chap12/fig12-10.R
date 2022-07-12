library(dplyr)
library(ggplot2)

T <- 96
d <- as.matrix(read.csv('input/data-2Dmesh.csv', header=FALSE))
I <- nrow(d)
J <- ncol(d)

fit <- readRDS('output/result-model12-6.RDS')
f_est <- fit$draws('f', format='matrix') %>% 
  apply(., 2, median) %>% 
  matrix(., I, J)

png('output/fig12-10-left.png', pointsize=72, width=2400, height=2100)
persp(1:I, 1:J, f_est, theta=55, phi=40, expand=0.5, border='black', col='grey95',
  xlab='Plate Row', ylab='Plate Column', zlab='f', ticktype='detailed', lwd=2)
dev.off()


ij2t <- read.csv('input/data-2Dmesh-design.csv', header=FALSE)
ij2t <- as.matrix(ij2t)
mean_Y <- sapply(1:T, function(t) mean(d[ij2t==t]) - mean(d))

beta_ms <- fit$draws('beta', format='matrix')
qua <- apply(beta_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(mean_Y=mean_Y, t(qua), check.names=FALSE)

p <- ggplot(data=d_est, aes(x=mean_Y, y=`50%`, ymin=`2.5%`, ymax=`97.5%`)) +
  theme_bw(base_size=18) +
  coord_fixed(ratio=1, xlim=c(-5, 5), ylim=c(-5, 5)) +
  geom_pointrange(size=0.8, shape=21, fill='gray90') +
  geom_abline(aes(slope=1, intercept=0), color='black', alpha=3/5, linetype='31') +
  labs(x='Mean of Y[ij2t]', y='beta[t]')
ggsave(p, file='output/fig12-10-right.png', dpi=300, w=5, h=5)
