library(dplyr)
library(ggplot2)

fit <- readRDS('../chap11/exercise/ex2.RDS')
y <- fit$draws(format='df') %>% pull('yp[1]')

loss_function <- function(a) ifelse(a < y, 2*(y-a), 1-exp(-(a-y)))
expected_loss <- function(a) mean(loss_function(a))

a_best <- optim(median(y), expected_loss, method='Brent',
  lower=5, upper=50)$par

p <- ggplot(data=data.frame(x=y), aes(x)) +
  theme_bw(base_size=18) +
  geom_density(alpha=0.5, color='black', fill='gray20') +
  geom_vline(xintercept=a_best, color='black', linetype='dashed') +
  labs(x='value', y='density')
ggsave(p, file='output/fig13-2.png', dpi=300, w=4, h=3)
