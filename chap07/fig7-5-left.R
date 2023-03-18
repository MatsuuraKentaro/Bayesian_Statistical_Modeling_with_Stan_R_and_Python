library(ggplot2)

d <- read.csv('input/data-conc.csv')

p <- ggplot(data=d, aes(x=Time, y=Y)) +
  theme_bw(base_size=18) +
  geom_line(size=1) +
  geom_point(size=3) +
  labs(x='Time (hour)', y='Y') +
  scale_x_continuous(breaks=d$Time, limits=c(0,24)) +
  ylim(-2.5, 16)
ggsave(p, file='output/fig7-5-left.png', dpi=300, w=4, h=3)
