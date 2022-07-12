library(dplyr)
library(ggplot2)

d <- read.csv('input/data-ageheap.csv')
d <- d %>% 
  mutate(Y = Y/1000000,
         Sex = factor(Sex, levels=c('M','F')))

p <- ggplot() +
  theme_bw(base_size=18) +
  theme(panel.grid.minor.x=element_blank()) +
  geom_bar(data=d %>% filter(Sex=='M'), aes(x=Age, y=-1*Y, fill=Sex), stat='identity', width=0.6) +
  geom_bar(data=d %>% filter(Sex=='F'), aes(x=Age, y=Y,    fill=Sex), stat='identity', width=0.6) +
  scale_y_continuous(breaks=seq(-2.5,2.5,0.5),labels=abs(seq(-2.5,2.5,0.5)), limit=c(-2.5,2.5)) +
  scale_x_continuous(breaks=seq(0, 75, 5), labels=seq(0, 75, 5)) +
  scale_fill_manual(values=c('black', 'gray50')) +
  guides(fill=guide_legend(reverse=TRUE)) +
  geom_hline(yintercept=0) +
  ylab('Y [M]') +
  coord_flip()
ggsave(p, file='output/fig12-3.png', dpi=300, w=8, h=6)
