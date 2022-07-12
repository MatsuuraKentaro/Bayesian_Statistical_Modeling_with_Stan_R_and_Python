library(ggplot2)

d <- read.csv('input/data-pulse.csv')

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_line(data=d, aes(x=X, y=Y), size=0.3) +
  labs(x='Time (Second)', y='Y')
ggsave(p, file='output/fig11-10.png', dpi=300, w=3.5, h=3)
