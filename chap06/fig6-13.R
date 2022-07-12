library(ggplot2)

d <- read.csv(file='input/data-mvn.csv')
p <- ggplot(data=d, aes(x=Y1, y=Y2)) +
  theme_bw(base_size=18) +
  geom_point(shape=1, size=3)
ggsave(file='output/fig6-13.png', plot=p, dpi=300, w=4, h=3)
