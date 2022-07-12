library(dplyr)
library(ggplot2)

d <- read.csv(file='input/data-salary-2.csv') %>% 
  mutate(CID = as.factor(CID),
         CID_label = factor(paste0('CID = ', CID), levels = paste0('CID = ', 1:4)))
res_lm <- lm(Y ~ X, data=d)
coef <- coef(res_lm)

p <- ggplot(data=d, aes(x=X, y=Y, shape=CID)) +
  theme_bw(base_size=18) +
  geom_abline(intercept=coef[1], slope=coef[2], size=2, alpha=0.3) +
  geom_point(size=2) +
  scale_shape_manual(values=c(16, 2, 4, 9))
ggsave(p, file='output/fig8-1-left.png', dpi=300, w=4, h=3)

p <- ggplot(data=d, aes(x=X, y=Y, shape=CID)) +
  theme_bw(base_size=20) +
  geom_abline(intercept=coef[1], slope=coef[2], size=2, alpha=0.3) +
  facet_wrap(~CID_label) +
  geom_line(stat='smooth', method='lm', se=FALSE, size=1, color='black', linetype='21', alpha=0.8) +
  geom_point(size=3) +
  scale_shape_manual(values=c(16, 2, 4, 9)) +
  labs(shape='CID')
ggsave(p, file='output/fig8-1-right.png', dpi=300, w=6, h=5)
