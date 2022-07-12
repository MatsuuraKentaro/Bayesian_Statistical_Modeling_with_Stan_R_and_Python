library(dplyr)
library(tidyr)
library(ggplot2)

d_player <- read.csv('input/data-eg3-players.csv')
d_conv <- lapply(1:nrow(d_player), function(i) {
  data.frame(idx=d_player$Start_Index[i]:d_player$End_Index[i], 
             PID=d_player$PID[i], 
             Player=d_player$Player[i],
             Year=d_player$Start_Year[i]:d_player$End_Year[i])
}) %>% bind_rows()


fit <- readRDS('output/result-model11-12.RDS')
d_ms <- fit$draws(format='df') %>% select(starts_with('mu[')) %>% 
  mutate(iteration=1:nrow(.)) %>% 
  pivot_longer(cols=-iteration) %>% 
  tidyr::extract(col=name, into='idx', regex='([[:digit:]]+)', convert=TRUE)

d_qua <- d_ms %>% 
  group_by(idx) %>% 
  summarise(`25%` = quantile(value, probs=0.25),
            `50%` = quantile(value, probs=0.5),
            `75%` = quantile(value, probs=0.75)) %>% ungroup() %>% 
  left_join(d_conv, by='idx')

d_plot <- d_qua %>% filter(PID %in% c(100, 125, 182, 292))

p <- ggplot(data=d_plot, aes(x=Year, y=`50%`, group=Player, linetype=Player, shape=Player)) +
  theme_bw(base_size=18) +
  theme(legend.position = 'none') +
  geom_ribbon(aes(ymin=`25%`, ymax=`75%`), fill='black', alpha=1/6) +
  geom_line(size=0.5) +
  geom_point(size=1.5) +
  scale_x_continuous(breaks=seq(2000, 2022, 5), labels=seq(2000, 2022, 5)) +
  labs(x='Time (Year)', y='Capability')
ggsave(p, file='output/fig11-17-left.png', dpi=300, w=4, h=4)


fit <- readRDS('output/result-model11-12b.RDS')
d_ms <- fit$draws(format='df') %>% select(starts_with('mu[')) %>% 
  mutate(iteration=1:nrow(.)) %>% 
  pivot_longer(cols=-iteration) %>% 
  tidyr::extract(col=name, into='idx', regex='([[:digit:]]+)', convert=TRUE)

d_qua <- d_ms %>% 
  group_by(idx) %>% 
  summarise(`25%` = quantile(value, probs=0.25),
            `50%` = quantile(value, probs=0.5),
            `75%` = quantile(value, probs=0.75)) %>% ungroup() %>% 
  left_join(d_conv, by='idx')

d_plot <- d_qua %>% filter(PID %in% c(100, 125, 182, 292))

p <- ggplot(data=d_plot, aes(x=Year, y=`50%`, group=Player, linetype=Player, shape=Player)) +
  theme_bw(base_size=18) +
  theme(legend.key.width=grid::unit(2.5,'line')) +
  geom_ribbon(aes(ymin=`25%`, ymax=`75%`), fill='black', alpha=1/6) +
  geom_line(size=0.5) +
  geom_point(size=1.5) +
  scale_x_continuous(breaks=seq(2000, 2022, 5), labels=seq(2000, 2022, 5)) +
  labs(x='Time (Year)', y='Capability')
ggsave(p, file='output/fig11-17-right.png', dpi=300, w=6, h=4)
