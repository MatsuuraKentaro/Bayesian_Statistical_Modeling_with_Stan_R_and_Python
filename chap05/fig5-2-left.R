library(ggplot2)
library(cmdstanr)

set.seed(123)
X <- rnorm(20, mean=0.7, sd=1.4)
d <- data.frame(x=X, y=0, xend=X, yend=0.05)

model <- cmdstan_model(stan_file='model/for_fig5-2-left.stan')
fit <- model$sample(data=list(N=length(X), Y=X), seed=123, iter_sampling=5000, iter_warmup=1000)
yp_ms <- fit$draws('yp', format='matrix')

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_density(data=data.frame(yp_ms), aes(x=yp), color=NA, fill='gray20', alpha=0.5) +
  geom_rug(data=d, aes(x=x), sides='b') +
  coord_cartesian(xlim=c(-4,4)) +
  labs(x='Y', y='density')
ggsave(p, file='output/fig5-2-left.png', dpi=300, w=3, h=3)
