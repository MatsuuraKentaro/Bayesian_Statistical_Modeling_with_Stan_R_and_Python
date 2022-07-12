library(dplyr)
library(ggplot2)
library(ggrepel)

d <- read.csv('input/data-map-temperature.csv')
d_name <- read.csv('input/data-map-JIS.csv', header=FALSE, fileEncoding='UTF-8')
colnames(d_name) <- c('prefID', 'name')

fit <- readRDS('output/result-model12-5.RDS')
f_ms <- fit$draws('f', format='matrix')
qua <- apply(f_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(d_name, Y=d$Y, t(qua), check.names=FALSE) %>% 
  mutate(residual=Y-`50%`)
top_residual <- which(rank(-abs(d_est$residual))==1)

p <- ggplot(data=d_est, aes(x=Y, y=`50%`, ymin=`2.5%`, ymax=`97.5%`)) +
  theme_bw(base_size=18) +
  theme(legend.key.height=grid::unit(2.5,'line')) +
  coord_fixed(ratio=1, xlim=c(9, 24), ylim=c(9, 24)) +
  geom_label_repel(
    data=d_est[top_residual, ], aes(label=name),
    nudge_x = -0.5,
    nudge_y = 0.15,
    box.padding=grid::unit(2, 'lines')
  ) +
  geom_pointrange(size=0.8, shape=21, fill='white') +
  geom_abline(aes(slope=1, intercept=0), color='black', alpha=3/5, linetype='31') +
  labs(x='Observed', y='Predicted') +
  scale_x_continuous(breaks=seq(0, 25, 5)) +
  scale_y_continuous(breaks=seq(0, 25, 5))
ggsave(p, file='output/fig12-8-left.png', dpi=300, w=4, h=4)


noise_ms <- t(replicate(nrow(f_ms), d$Y)) - f_ms
# noise_ms <- einsum::einsum('n,m->mn', d$Y, rep(1, nrow(f_ms))) - f_ms

d_mode <- apply(noise_ms, 2, function(x) {
  dens <- density(x)
  mode_i <- which.max(dens$y)
  mode_x <- dens$x[mode_i]
  mode_y <- dens$y[mode_i]
  c(mode_x, mode_y)
}) %>% 
  t() %>% 
  data.frame() %>% 
  magrittr::set_colnames(c('X', 'Y'))

s_dens <- density(fit$draws('s_y', format='matrix'))
s_MAP <- s_dens$x[which.max(s_dens$y)]
bw <- 0.05
p <- ggplot(data=d_mode, aes(x=X)) +
  theme_bw(base_size=18) +
  geom_histogram(aes(y=..density..), binwidth=bw, color='black', fill='white') +
  geom_density(alpha=0.4, color=NA, fill='gray20') +
  geom_rug(sides='b') +
  stat_function(fun=function(x) dnorm(x, mean=0, sd=s_MAP), linetype='dashed') +
  labs(x='value', y='density') +
  xlim(range(density(d_mode$X)$x))
ggsave(file='output/fig12-8-right.png', plot=p, dpi=300, w=4, h=4)
