library(survival)
library(ggplot2)

d <- read.csv('input/data-surv.csv')
d_plot <- d[1:15, ]
d_plot$Join <- as.Date(d_plot$Join)
d_plot$Leave <- as.Date(d_plot$Leave)

p <- ggplot() +
  theme_bw(base_size=16) +
  geom_segment(data=d_plot, aes(x=Join, y=PersonID, xend=Leave, yend=PersonID), size=1) +
  geom_point(data=d_plot, aes(x=Join, y=PersonID), size=2, shape=16) +
  geom_point(data=subset(d_plot, Cens == 0), aes(x=Leave, y=PersonID), size=2, shape=16) +
  geom_point(data=subset(d_plot, Cens == 1), aes(x=Leave, y=PersonID), size=3, shape=4) +
  scale_y_reverse() +
  xlab('Date')
ggsave(p, file='output/fig14-1-left.png', dpi=300, width=3, height=3)


p <- ggplot() +
  theme_bw(base_size=16) +
  geom_histogram(data=d, aes(x=Time), binwidth=3, color='black', fill='white')
ggsave(p, file='output/fig14-1-middle.png', dpi=300, width=3, height=3)


res <- survfit(Surv(Time, 1-Cens) ~ 1, data=d)
png('output/fig14-1-right.png', pointsize=48, width=1300, height=1150)
plot(res, mark.time=TRUE, lwd=2, xlab='Time (Months)', ylab='Survival')
dev.off()
