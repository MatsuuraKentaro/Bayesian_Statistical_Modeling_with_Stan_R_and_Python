library(ggplot2)

d <- read.csv('input/data-sigEmax.csv')

p <- ggplot(data=d, aes(x=X, y=Y)) +
  theme_bw(base_size=18) +
  geom_point(size=2) +
  labs(x='X', y='Y') +
  ylim(2, 33)
ggsave(file='output/fig7-6-left.png', plot=p, dpi=300, w=4, h=3)
