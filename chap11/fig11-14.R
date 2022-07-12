library(dplyr)
library(tidyr)
library(ggplot2)

d_ori <- read.csv('input/data-eg2.csv')

d <- d_ori %>% 
  pivot_longer(cols=-Time, names_to='Item', values_to='Y') %>% 
  mutate(Item = factor(Item, levels = c('Weight', 'Bodyfat')))
  
d1 <- d %>% filter((Item == 'Bodyfat' & Time <= 30) | (Item == 'Weight' & Time <= 20))
d2 <- d %>% filter((Item == 'Bodyfat' & Time >= 31 & Time <= 40) | (Item == 'Weight' & Time >= 31 & Time <= 40))
d3 <- d %>% filter((Item == 'Bodyfat' & Time >= 51) | (Item == 'Weight' & Time >= 51))
d_weight_na1a <- d %>% filter(Item == 'Weight', 21 <= Time, Time <= 30)
d_weight_na2a <- d %>% filter(Item == 'Weight', 20 <= Time, Time <= 31)
d_weight_na1b <- d %>% filter(Item == 'Weight', 41 <= Time, Time <= 50)
d_weight_na2b <- d %>% filter(Item == 'Weight', 40 <= Time, Time <= 51)
d_bodyfat_na1 <- d %>% filter(Item == 'Bodyfat', 41 <= Time, Time <= 50)
d_bodyfat_na2 <- d %>% filter(Item == 'Bodyfat', 40 <= Time, Time <= 51)

p <- ggplot(data=d1, aes(Time, Y)) +
  theme_bw(base_size=18) +
  facet_wrap(~Item, ncol=1, scales='free_y') +
  geom_line() +
  geom_point(shape=16, size=2) +
  geom_line(data=d2, aes(Time, Y)) +
  geom_point(data=d2, aes(Time, Y), shape=16, size=2) +
  geom_line(data=d3, aes(Time, Y)) +
  geom_point(data=d3, aes(Time, Y), shape=16, size=2) +
  geom_line(data=d_weight_na2a, aes(Time, Y), linetype='22', alpha=0.5) +
  geom_point(data=d_weight_na1a, aes(Time, Y), shape=1, size=2, alpha=0.5) +
  geom_line(data=d_weight_na2b, aes(Time, Y), linetype='22', alpha=0.5) +
  geom_point(data=d_weight_na1b, aes(Time, Y), shape=1, size=2, alpha=0.5) +
  geom_line(data=d_bodyfat_na2, aes(Time, Y), linetype='22', alpha=0.5) +
  geom_point(data=d_bodyfat_na1, aes(Time, Y), shape=1, size=2, alpha=0.5) +
  labs(x='Time (Day)', y='Y')
ggsave(p, file='output/fig11-14.png', dpi=300, w=6, h=5)
