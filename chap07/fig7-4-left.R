library(dplyr)
library(ggplot2)

d <- read.csv(file='input/data-rental.csv')

fit <- readRDS('output/result-model7-1.RDS')
mu_ms <- fit$draws('mu', format='matrix')
N_ms <- nrow(mu_ms)
noise_ms <- t(replicate(N_ms, d$Y)) - mu_ms
# noise_ms <- einsum::einsum('n,m->mn', d$Y, rep(1, N_ms)) - mu_ms

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


s_dens <- density(fit$draws('sigma', format='matrix'))
s_MAP <- s_dens$x[which.max(s_dens$y)]
bw <- 25
p <- ggplot(data=d_mode, aes(x=X)) +
  theme_bw(base_size=18) +
  geom_histogram(aes(y=..density..), binwidth=bw, color='black', fill='white') +
  geom_density(color=NA, fill='gray20', alpha=0.5) +
  geom_rug(sides='b') +
  stat_function(fun=function(x) dnorm(x, mean=0, sd=s_MAP), linetype='dashed') +
  labs(x='value', y='density') +
  xlim(range(density(d_mode$X)$x))
ggsave(file='output/fig7-4-left.png', plot=p, dpi=300, w=4, h=3)
