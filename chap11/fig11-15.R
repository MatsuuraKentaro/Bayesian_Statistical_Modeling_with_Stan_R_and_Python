library(dplyr)
library(tidyr)
library(ggplot2)

d_ori <- read.csv('input/data-eg2.csv')
T <- nrow(d_ori)
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

fit <- readRDS('output/result-model11-11.RDS')
mu1_ms <- fit$draws(format='df') %>% select(starts_with('mu[') & ends_with(',1]'))
qua <- apply(mu1_ms, 2, quantile, prob=c(0.025, 0.25, 0.5, 0.75, 0.975)) * 10
d_weight_est <- data.frame(Time=1:T, Item=factor('Weight', levels=c('Weight', 'Bodyfat')), t(qua), check.names=FALSE)
mu2_ms <- fit$draws(format='df') %>% select(starts_with('mu[') & ends_with(',2]'))
qua <- apply(mu2_ms, 2, quantile, prob=c(0.025, 0.25, 0.5, 0.75, 0.975)) * 10
d_bodyfat_est <- data.frame(Time=1:T, Item=factor('Bodyfat', levels=c('Weight', 'Bodyfat')), t(qua), check.names=FALSE)

p <- ggplot() +
  theme_bw(base_size=18) +
  facet_wrap(~Item, ncol=1, scales='free_y') +
  geom_ribbon(data=d_weight_est, aes(x=Time, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_weight_est, aes(x=Time, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_weight_est, aes(x=Time, y=`50%`), size=1) +
  geom_ribbon(data=d_bodyfat_est, aes(x=Time, ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/6) +
  geom_ribbon(data=d_bodyfat_est, aes(x=Time, ymin=`25%`, ymax=`75%`), fill='black', alpha=2/6) +
  geom_line(data=d_bodyfat_est, aes(x=Time, y=`50%`), size=1) +
  geom_line(data=d1, aes(Time, Y), alpha=0.7) +
  geom_point(data=d1, aes(Time, Y), shape=16, size=2, alpha=0.3) +
  geom_line(data=d2, aes(Time, Y), alpha=0.7) +
  geom_point(data=d2, aes(Time, Y), shape=16, size=2, alpha=0.3) +
  geom_line(data=d3, aes(Time, Y), alpha=0.7) +
  geom_point(data=d3, aes(Time, Y), shape=16, size=2, alpha=0.3) +
  geom_line(data=d_weight_na2a, aes(Time, Y), linetype='22', alpha=0.5) +
  geom_point(data=d_weight_na1a, aes(Time, Y), shape=1, size=2, alpha=0.5) +
  geom_line(data=d_weight_na2b, aes(Time, Y), linetype='22', alpha=0.5) +
  geom_point(data=d_weight_na1b, aes(Time, Y), shape=1, size=2, alpha=0.5) +
  geom_line(data=d_bodyfat_na2, aes(Time, Y), linetype='22', alpha=0.5) +
  geom_point(data=d_bodyfat_na1, aes(Time, Y), shape=1, size=2, alpha=0.5) +
  labs(x='Time (Day)', y='Y')
ggsave(p, file='output/fig11-15.png', dpi=300, w=6, h=5)
