library(dplyr)
library(ggplot2)
source('sim-model8-3.R')

d <- d %>% 
  mutate(CID = as.factor(CID),
         CID_label = factor(paste0('CID = ', CID), levels = paste0('CID = ', 1:4)))

p <- ggplot(d, aes(X, Y_sim, shape=CID)) +
  theme_bw(base_size=18) +
  facet_wrap(~CID_label) +
  geom_line(stat='smooth', method='lm', se=FALSE, size=1, color='black', linetype='31', alpha=0.8) +
  geom_point(size=3) +
  scale_shape_manual(values=c(16, 2, 4, 9)) +
  labs(y='Y')
ggsave(p, file='output/fig8-2.png', dpi=300, w=6, h=5)
