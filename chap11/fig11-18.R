library(ggplot2)

d <- read.csv('input/data-eg4.csv')

d[d$Month == 8, ]$Y <- NA
d$Time <- 1:nrow(d)

p <- ggplot(data=d, aes(Time, Y)) +
  theme_bw(base_size=18) +
  geom_line(size=0.3) +
  labs(x='Time (Day)', y='Y')
ggsave(p, file='output/fig11-18.png', dpi=300, w=4, h=3)
