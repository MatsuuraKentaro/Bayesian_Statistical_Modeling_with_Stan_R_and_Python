library(dplyr)
library(ggplot2)

load('output/result-model14-8.RData')

d <- d_res %>% 
  mutate(waic_ge=waic - ge, looic_ge=looic - ge) %>%
  select(G, N_per_G, simID, g, waic_ge, looic_ge) %>%
  tidyr::gather(key='IC', value='value', waic_ge, looic_ge) %>% 
  mutate(IC=case_when(IC == 'waic_ge' ~ 'WAIC - GE',
                      IC == 'looic_ge' ~ 'LOOIC - GE'),
         IC=factor(IC, levels=c('WAIC - GE', 'LOOIC - GE'))) %>% 
  mutate(G=factor(G), N_per_G=factor(N_per_G))

## prediction type 1
d1 <- d %>% filter(g != -1)

d_plot1 <- d1 %>% 
  group_by(G, N_per_G, simID, IC) %>%
  summarise(value=sum(value)) %>% ungroup() %>% 
  group_by(G, N_per_G, IC) %>%
  summarise(w_lower = boxplot.stats(value)$stats[1], 
            b_lower = boxplot.stats(value)$stats[2], 
            median  = boxplot.stats(value)$stats[3],
            b_upper = boxplot.stats(value)$stats[4],
            w_upper = boxplot.stats(value)$stats[5]) %>% ungroup() %>% 
  mutate(G_label=factor(paste0('G = ', G), levels=paste0('G = ', c(10, 30, 100))))

p <- ggplot(data=d_plot1, aes(x=N_per_G)) +
  theme_bw(base_size=18) +
  facet_wrap(~G_label, scale='free_y') +
  geom_boxplot(aes(ymin=w_lower, lower=b_lower, middle=median, upper=b_upper, ymax=w_upper, fill=IC), 
               stat='identity', alpha=0.3) +
  geom_hline(yintercept=0, linetype='dashed') +
  labs(x='N per Group', fill='') +
  scale_fill_manual(values=c('white', 'gray20'))
ggsave(p, file='output/fig14-9.png', dpi=250, w=9, h=4)


## prediction type 2
d2 <- d %>% filter(g == -1)
d_plot2 <- d2 %>% 
  group_by(G, N_per_G, IC) %>%
  summarise(w_lower = boxplot.stats(value)$stats[1], 
            b_lower = boxplot.stats(value)$stats[2], 
            median  = boxplot.stats(value)$stats[3],
            b_upper = boxplot.stats(value)$stats[4],
            w_upper = boxplot.stats(value)$stats[5]) %>% ungroup() %>% 
  mutate(G_label=factor(paste0('G = ', G), levels=paste0('G = ', c(10, 30, 100))))

p <- ggplot(data=d_plot2, aes(x=N_per_G)) +
  theme_bw(base_size=18) +
  facet_wrap(~G_label) +
  geom_boxplot(aes(ymin=w_lower, lower=b_lower, middle=median, upper=b_upper, ymax=w_upper, fill=IC), 
               stat='identity', alpha=0.3) +
  geom_hline(yintercept=0, linetype='dashed') +
  labs(x='N per Group', fill='') +
  scale_fill_manual(values=c('white', 'gray20'))
ggsave(p, file='output/fig14-10.png', dpi=250, w=9, h=4)
