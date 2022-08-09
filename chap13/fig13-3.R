library(dplyr)
library(ggplot2)

load('output/result-model13-3.RData')
times_plot <- c(1,7,14,20)
# times_plot <- 1:20
d_dat <- d_dat %>% mutate(time_lab = factor(paste0('time = ', time), levels=paste0('time = ', times_plot))) %>% filter(time %in% times_plot)
d_pre <- d_pre %>% mutate(time_lab = factor(paste0('time = ', time), levels=paste0('time = ', times_plot))) %>% filter(time %in% times_plot)
d_est <- d_est %>% mutate(time_lab = factor(paste0('time = ', time), levels=paste0('time = ', times_plot))) %>% filter(time %in% times_plot)
d_sel <- d_sel %>% mutate(time_lab = factor(paste0('time = ', time), levels=paste0('time = ', times_plot))) %>% filter(time %in% times_plot)

p <- ggplot() +
  theme_bw(base_size=20) +
  facet_wrap(~time_lab) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), alpha=0.4) +
  geom_line(data=d_est, aes(x=X, y=`50%`), color='black') +
  geom_point(data=d_pre, aes(x=X, y=Y), size=3, color='black', shape=1) +
  geom_point(data=d_dat, aes(x=X, y=Y), size=3, color='black', shape=16) +
  geom_vline(data=d_sel, aes(xintercept=X), size=0.5, color='red', linetype='dashed', alpha=0.7) +
  geom_point(data=d_sel, aes(x=X), y=5, size=3, color='red', shape=17) +
  labs(x='X', y='Y')
ggsave(p, file='output/fig13-3.png', dpi=300, w=8, h=6)
