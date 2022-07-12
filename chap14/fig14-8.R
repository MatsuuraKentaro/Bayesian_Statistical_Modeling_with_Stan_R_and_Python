library(dplyr)
library(ggplot2)

cases <- c('linear', 'logistic', 'nonlinear1', 'nonlinear2')
files <- paste0('output/', c('result-model14-7.RData', 'result-model14-a-logistic.RData', 'result-model14-b-emax.RData', 'result-model14-b-linear.RData'))

d_plot <- lapply(seq_along(cases), function(i) {
  load(files[i])
  d <- d_res %>%
    mutate(N=factor(N), waic_ge=waic - ge, looic_ge=looic - ge) %>%
    select(N, simID, waic_ge, looic_ge) %>%
    tidyr::gather(key='IC', value='value', waic_ge, looic_ge) %>% 
    mutate(IC=case_when(IC == 'waic_ge' ~ 'WAIC - GE',
                        IC == 'looic_ge' ~ 'LOOIC - GE'),
           IC=factor(IC, levels=c('WAIC - GE', 'LOOIC - GE'))) %>% 
    group_by(N, IC) %>% 
    summarise(w_lower = boxplot.stats(value)$stats[1], 
              b_lower = boxplot.stats(value)$stats[2], 
              median  = boxplot.stats(value)$stats[3],
              b_upper = boxplot.stats(value)$stats[4],
              w_upper = boxplot.stats(value)$stats[5]) %>% ungroup() %>% 
    mutate(case=cases[i])
}) %>% bind_rows() %>% 
  mutate(case=factor(case, levels=cases))

p <- ggplot(data=d_plot, aes(x=N)) +
  theme_bw(base_size=18) +
  facet_wrap(~case, scales='free_y', nrow=1) +
  geom_boxplot(aes(ymin=w_lower, lower=b_lower, middle=median, upper=b_upper, ymax=w_upper, fill=IC), 
               stat='identity', alpha=0.3) +
  geom_hline(yintercept=0, linetype='dashed') +
  labs(fill='') +
  scale_fill_manual(values=c('white', 'gray20'))
ggsave(p, file='output/fig14-8.png', dpi=250, w=14, h=4)
