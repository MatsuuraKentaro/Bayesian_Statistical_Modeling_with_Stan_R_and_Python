library(ggplot2)

d <- read.csv(file='input/data-weight.csv')
p <- ggplot() +
  theme_bw(base_size=18) +
  geom_line(data=d, aes(x=X, y=Y), size=1) +
  geom_point(data=d, aes(x=X, y=Y), size=3) +
  labs(x='Time (Day)', y='Y')
ggsave(file='output/fig11-1-right.png', plot=p, dpi=300, w=4, h=3)
