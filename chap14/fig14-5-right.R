library(dplyr)
library(tidyr)
library(ggplot2)
library(latex2exp)

N <- 50
K <- 6
I <- 120
fit_MAP <- readRDS('output/result-model14-3.RDS')
theta_est <- fit_MAP$draws(format='df') %>% 
  select(starts_with('theta[')) %>% 
  pivot_longer(everything(), names_to='Parameter') %>% 
  extract(col='Parameter', into=c('PersonID', 'Pattern'), regex='theta\\[(\\d+),(\\d+)\\]', convert=TRUE) %>% 
  mutate(PersonID_label=paste0('n = ', PersonID))

p <- ggplot(data=subset(theta_est, PersonID %in% c(1,50)), aes(x=Pattern, y=value)) +
  theme_bw(base_size=18) +
  facet_wrap(~PersonID_label, nrow=2) +
  coord_flip() +
  scale_x_reverse(breaks=1:6) +
  geom_bar(stat='identity') +
  labs(y=TeX('$\\theta\\[n,k\\]$'))
ggsave(p, file='output/fig14-5-right.png', dpi=300, w=5, h=5)
