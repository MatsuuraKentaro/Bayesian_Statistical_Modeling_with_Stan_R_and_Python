library(dplyr)
library(ggplot2)

d <- read.csv(file='input/data-shopping-1.csv')

fit <- readRDS('output/result-model5-3.RDS')
yp_ms <- fit$draws('yp', format='matrix')

qua <- apply(yp_ms, 2, quantile, prob=c(0.1, 0.5, 0.9))
d_est <- data.frame(d, t(qua), check.names=FALSE) %>% 
  mutate(Sex = as.factor(Sex))

p <- ggplot(data=d_est, aes(x=Y, y=`50%`, ymin=`10%`, ymax=`90%`, shape=Sex, fill=Sex)) +
  theme_bw(base_size=18) +
  theme(legend.key.height=grid::unit(2.5,'line')) +
  coord_fixed(ratio=1, xlim=c(0.28, .8), ylim=c(0.28, .8)) +
  geom_pointrange(size=0.8, color='gray5') +
  geom_abline(aes(slope=1, intercept=0), color='black', alpha=3/5, linetype='31') +
  scale_shape_manual(values=c(21, 24)) +
  scale_fill_manual(values=c('white', 'gray70')) +
  labs(x='Observed', y='Predicted') +
  scale_x_continuous(breaks=seq(from=0, to=1, by=0.1)) +
  scale_y_continuous(breaks=seq(from=0, to=1, by=0.1))
ggsave(file='output/fig5-2-right.png', plot=p, dpi=300, w=5, h=4)
