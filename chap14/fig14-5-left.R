library(dplyr)
library(tidyr)
library(ggplot2)
library(latex2exp)

N <- 50
K <- 6
I <- 120
fit_MAP <- readRDS('output/result-model14-3.RDS')
phi_est <- fit_MAP$draws('phi', format='df') %>%
  select(starts_with('phi[')) %>% 
  pivot_longer(everything(), names_to='Parameter') %>% 
  extract(col='Parameter', into=c('Pattern', 'ItemID'), regex='phi\\[(\\d+),(\\d+)\\]', convert=TRUE) %>% 
  mutate(Pattern_label=paste0('k = ', Pattern))

p <- ggplot(data=phi_est, aes(x=ItemID, y=value)) +
  theme_bw(base_size=18) +
  theme(axis.text.x=element_text(angle=65, vjust=1, hjust=1)) +
  facet_wrap(~Pattern_label, ncol=3) +
  coord_flip() +
  scale_x_reverse(breaks=c(1, seq(20, 120, 20))) +
  geom_bar(stat='identity') +
  labs(y=TeX('$\\phi\\[k,i\\]$'))
ggsave(p, file='output/fig14-5-left.png', dpi=300, w=7, h=5)
