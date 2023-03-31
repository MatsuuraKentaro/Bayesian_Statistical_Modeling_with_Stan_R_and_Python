library(dplyr)
library(ggplot2)

fit <- readRDS('output/result-model11-13.RDS')
d_ms <- fit$draws(format='df') %>% 
  select(starts_with(c('trend[', 'calendar[', 'weather[', 'event[', 'ar[')))
qua <- apply(d_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- qua %>% t() %>% 
  data.frame(check.names=FALSE) %>% 
  tibble::rownames_to_column(var='Parameter_raw') %>% 
  tidyr::separate(Parameter_raw, into=c('Parameter', 'X'), sep='[\\[\\]]', convert=TRUE) %>% 
  mutate(Parameter=factor(Parameter, levels=c('trend', 'calendar', 'weather', 'event', 'ar')))
  
p <- ggplot() +
  theme_bw(base_size=18) +
  facet_grid(Parameter ~ ., scales='free_y') +
  geom_ribbon(data=d_est, aes(x=X, ymin=`2.5%`, ymax=`97.5%`), alpha=1/6) +
  geom_ribbon(data=d_est, aes(x=X, ymin=`25%`,  ymax=`75%`),   alpha=2/6) +
  geom_line(data=d_est, aes(x=X, y=`50%`)) +
  labs(x='Time (Day)', y='')
ggsave(p, file='output/fig11-21.png', dpi=300, w=8, h=6)
