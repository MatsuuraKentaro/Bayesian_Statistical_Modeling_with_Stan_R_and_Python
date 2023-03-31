library(dplyr)
library(ggplot2)
library(bayesplot)

fit <- readRDS('output/result-model11-13.RDS')
b_event_ms <- fit$draws('b_event', format='matrix')
qua <- apply(b_event_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=1:ncol(qua), t(qua), check.names=FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`,  ymax=`75%`),   alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`)) +
  labs(x='Time (Day)', y='b_event')
ggsave(p, file='output/fig11-23-left.png', dpi=300, w=4, h=3)

d_wday_ms <- fit$draws(format='df') %>% select(starts_with('wday['))
p <- mcmc_areas(d_wday_ms, pars=sprintf('wday[%d]', 1:7), prob=0.95) +
  theme_bw(base_size=18) +
  labs(x='wday')
ggsave(p, file='output/fig11-23-right.png', dpi=300, w=4, h=3)
