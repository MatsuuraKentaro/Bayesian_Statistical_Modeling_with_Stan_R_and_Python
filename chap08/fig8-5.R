library(dplyr)
library(ggplot2)

d <- read.csv(file='input/data-salary-3.csv') %>% 
  mutate(FID = as.factor(FID),
         FID_label = factor(paste0('FID = ', FID), levels = paste0('FID = ', 1:3)))
res_lm <- lm(Y ~ X, data=d)
coef <- coef(res_lm)

p <- ggplot(data=d, aes(x=X, y=Y, shape=FID)) +
  theme_bw(base_size=18) +
  geom_abline(intercept=coef[1], slope=coef[2], size=2, alpha=0.3) +
  geom_point(size=2) +
  scale_shape_manual(values=c(16, 2, 4, 9)) +
  labs(x='X', y='Y')
ggsave(p, file='output/fig8-5-left.png', dpi=300, w=4, h=3)

p <- ggplot(data=d, aes(x=X, y=Y, shape=FID)) +
  theme_bw(base_size=20) +
  geom_abline(intercept=coef[1], slope=coef[2], size=2, alpha=0.3) +
  facet_wrap(~FID_label, ncol=2) +
  geom_line(stat='smooth', method='lm', se=FALSE, size=1, color='black', linetype='21', alpha=0.8) +
  geom_point(size=3, alpha=0.8) +
  scale_shape_manual(values=c(16, 2, 4)) +
  labs(x='X', y='Y')
ggsave(p, file='output/fig8-5-right.png', dpi=300, w=6, h=5)
