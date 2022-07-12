library(dplyr)
library(tidyr)
library(ggplot2)

d_wide <- read.csv('input/data-conc-2-NA-wide.csv')
N <- nrow(d_wide)
X <- c(1, 2, 4, 8, 12, 24)
Tp <- 60
Xp <- seq(from=0, to=24, length=Tp)
d <- d_wide %>% 
  magrittr::set_colnames(c('PersonID', 1:length(X))) %>% 
  pivot_longer(cols=-PersonID, names_to='TimeID', values_to='Y') %>% 
  mutate(TimeID=as.integer(TimeID)) %>% 
  na.omit() %>% 
  mutate(Time=X[TimeID]) %>% 
  filter(PersonID %in% c(1, 2, 3, 16)) %>% 
  mutate(PersonID_label = factor(paste0('PersonID = ', PersonID), levels = paste0('PersonID = ', 1:N)))

fit <- readRDS('output/result-model8-7.RDS')

yp_ms <- fit$draws('yp', format='matrix')
qua <- apply(yp_ms, 2, quantile, prob = c(0.025, 0.5, 0.975))
d_est <- data.frame(t(qua), check.names=FALSE) %>% 
  mutate(Parameter=rownames(.)) %>% 
  extract(Parameter, into=c('PersonID', 'TimeID'), regex='([[:digit:]]+),([[:digit:]]+)', convert=TRUE) %>%
  mutate(Time=Xp[TimeID]) %>% 
  filter(PersonID %in% c(1, 2, 3, 16)) %>% 
  mutate(PersonID_label = factor(paste0('PersonID = ', PersonID), levels = paste0('PersonID = ', 1:N)))

p <- ggplot(data=d_est, aes(x=Time, y=`50%`)) +
  theme_bw(base_size=18) +
  facet_wrap(~PersonID_label) +
  geom_ribbon(aes(ymin=`2.5%`, ymax=`97.5%`), fill='black', alpha=1/5) +
  geom_line(size=0.5) +
  geom_point(data=d, aes(x=Time, y=Y), size=3) +
  labs(x='Time (hour)', y='Y') +
  scale_x_continuous(breaks=c(0,6,12,24), limit=c(0,24)) +
  scale_y_continuous(breaks=seq(0,40,10))
ggsave(p, file='output/fig8-9.png', dpi=300, w=6, h=5)
