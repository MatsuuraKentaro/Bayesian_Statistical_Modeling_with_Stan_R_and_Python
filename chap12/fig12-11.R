library(ggplot2)

d <- read.csv(file='input/data-gp.csv')

p <- ggplot(data=d, aes(x=X, y=Y)) +
  theme_bw(base_size=18) +
  geom_point(size=2, alpha=0.8) +
  ylim(-3, 3)
ggsave(p, file='output/fig12-11.png', dpi=300, w=4, h=3)

