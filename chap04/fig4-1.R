library(ggplot2)

d <- read.csv(file='input/data-salary.csv')
p <- ggplot(data=d, aes(x=X, y=Y)) +
  theme_bw(base_size=18) +
  geom_point(shape=1, size=3)
ggsave(p, file='output/fig4-1.png', dpi=300, w=4, h=3)
