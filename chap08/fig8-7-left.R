library(dplyr)
library(tidyr)
library(ggplot2)

d <- read.csv(file='input/data-conc-2.csv')
N <- nrow(d)
d <- d %>% 
  pivot_longer(cols=-PersonID, values_to='Y') %>% 
  mutate(Time=readr::parse_number(name)) %>% 
  select(-name) %>% 
  mutate(PersonID_label = factor(paste0('PersonID = ', PersonID), levels = paste0('PersonID = ', 1:N)))

p <- ggplot(data=d, aes(x=Time, y=Y)) +
  theme_bw(base_size=18) +
  facet_wrap(~PersonID_label) +
  geom_line(size=1) +
  geom_point(size=3) +
  labs(x='Time (hour)', y='Y') +
  scale_x_continuous(breaks=c(0,6,12,24), limits=c(0,24)) +
  scale_y_continuous(breaks=seq(0,40,10), limits=c(-3,40))
ggsave(p, file='output/fig8-7-left.png', dpi=300, w=8, h=7)
