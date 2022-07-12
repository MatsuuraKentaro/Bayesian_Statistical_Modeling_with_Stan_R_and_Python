library(dplyr)
library(ggplot2)

set.seed(123)
d <- read.csv(file='input/data-shopping-3.csv')

fit <- readRDS('output/result-model5-5.RDS')
q_ms <- fit$draws('q', format='matrix')
qua <- apply(q_ms, 2, quantile, prob=c(0.1, 0.5, 0.9))
d_comp <- data.frame(d, t(qua), check.names=FALSE) %>% 
  mutate(Y = as.factor(Y), Sex = as.factor(Sex))

p <- ggplot(data=d_comp, aes(x=Y, y=`50%`)) +
  theme_bw(base_size=18) +
  geom_boxplot(outlier.shape=NA) +
  geom_point(aes(fill=Sex, shape=Sex), position=position_jitter(w=0.2, h=0), size=1.5) +
  scale_shape_manual(values=c(21, 24)) +
  scale_fill_manual(values=alpha(c('white', 'grey40'), 0.5)) +
  labs(x='Y', y='q')
ggsave(file='output/fig5-7-left.png', plot=p, dpi=300, w=5, h=4)
