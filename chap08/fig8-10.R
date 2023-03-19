library(dplyr)
library(tidyr)
library(ggplot2)

fit <- readRDS('output/result-model8-8.RDS')
d_ms <- fit$draws(format='df') %>% select(starts_with('b['), starts_with('s_person'))
d_long <- d_ms %>% 
  pivot_longer(cols=everything(), names_to='Parameter')
qua <- apply(d_ms, 2, quantile, probs=c(0.025, 0.25, 0.5, 0.75, 0.975))
d_qua <- data.frame(Parameter=colnames(qua), t(qua), check.names=FALSE) %>% 
  mutate(Parameter=factor(Parameter, levels=colnames(d_ms)))

p <- ggplot() +
  theme_bw(base_size=18) +
  coord_flip() +
  geom_violin(data=d_long, aes(x=Parameter, y=value), fill='white', color='gray80', size=2, alpha=0.3, scale='width') +
  geom_pointrange(data=d_qua, aes(x=Parameter, y=`50%`, ymin=`2.5%`, ymax=`97.5%`), size=1) +
  scale_x_discrete(limits=rev(levels(d_qua$Parameter))) +
  scale_y_continuous(breaks=seq(from=-6, to=6, by=2))
ggsave(p, file='output/fig8-10-left.png', dpi=300, w=4, h=3)


b_person_ms <- fit$draws('b_person', format='matrix')
d_mode <- apply(b_person_ms, 2, function(x) {
  dens <- density(x)
  mode_i <- which.max(dens$y)
  mode_x <- dens$x[mode_i]
  mode_y <- dens$y[mode_i]
  c(mode_x, mode_y)
}) %>% 
  t() %>% 
  data.frame() %>% 
  magrittr::set_colnames(c('X', 'Y'))

s_dens <- density(fit$draws('s_person', format='matrix'))
s_MAP <- s_dens$x[which.max(s_dens$y)]
bw <- 0.25
p <- ggplot(data=d_mode, aes(x=X)) +
  theme_bw(base_size=18) +
  geom_histogram(aes(y=..density..), binwidth=bw, color='black', fill='white') +
  geom_density(color=NA, fill='gray20', alpha=0.4) +
  geom_rug(sides='b') +
  stat_function(fun=function(x) dnorm(x, mean=0, sd=s_MAP), linetype='dashed') +
  labs(x='value', y='density') +
  xlim(range(density(d_mode$X)$x))
ggsave(p, file='output/fig8-10-right.png', dpi=300, w=4, h=3)
