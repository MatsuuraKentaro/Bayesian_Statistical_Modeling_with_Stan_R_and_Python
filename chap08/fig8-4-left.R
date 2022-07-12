library(dplyr)
library(ggplot2)

fit1 <- readRDS('output/result-model8-1.RDS')
fit2 <- readRDS('output/result-model8-2.RDS')
fit3 <- readRDS('output/result-model8-3.RDS')
a_ms1 <- fit1$draws('a', format='matrix')
a_ms2 <- fit2$draws('a', format='matrix')
a_ms3 <- fit3$draws('a', format='matrix')

C <- 4
qua <- apply(a_ms2, 2, quantile, prob=c(0.025, 0.25, 0.5, 0.75, 0.975))
d_qua1 <- data.frame(CID=1:C-0.1, Model='8-2', t(qua), check.names=FALSE)
qua <- apply(a_ms3, 2, quantile, prob=c(0.025, 0.25, 0.5, 0.75, 0.975))
d_qua2 <- data.frame(CID=1:C+0.1, Model='8-3', t(qua), check.names=FALSE)
d_qua <- rbind(d_qua1, d_qua2)

p <- ggplot(data=d_qua, aes(x=CID, y=`50%`, ymin=`2.5%`, ymax=`97.5%`, shape=Model, linetype=Model, fill=Model)) +
  theme_bw(base_size=18) +
  theme(legend.key.height=grid::unit(2.5,'line')) +
  geom_pointrange(size=0.6) +
  geom_hline(yintercept=median(a_ms1), color='black', alpha=0.3, linetype='solid', size=1.2) +
  scale_shape_manual(values=c(21, 21)) +
  scale_linetype_manual(values=c('31', 'solid')) +
  scale_fill_manual(values=c('white','black')) +
  labs(y='a')
ggsave(p, file='output/fig8-4-left.png', dpi=300, w=4, h=3)
