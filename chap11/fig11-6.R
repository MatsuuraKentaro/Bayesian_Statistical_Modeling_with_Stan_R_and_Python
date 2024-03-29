library(ggplot2)

d <- read.csv('input/data-season.csv')

p <- ggplot() +
  theme_bw(base_size=18) +
  geom_line(data=d, aes(x=X, y=Y), linewidth=0.3) +
  labs(x='Time (Quarter)', y='Y')
ggsave(p, file='output/fig11-6.png', dpi=300, width=3.5, height=3)
