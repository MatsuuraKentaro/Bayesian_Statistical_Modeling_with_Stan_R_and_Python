library(ggplot2)

a_x <- -300:300/100
loss <- ifelse(a_x > 0, 1 - exp(-a_x), 2*(-a_x))
d <- data.frame(x=a_x, y=loss)

p <- ggplot(d, aes(x,y)) +
  theme_bw(base_size=18) +
  geom_line(size=2) +
  labs(x='a - y', y='loss')
ggsave(p, file='output/fig13-1.png', dpi=300, w=4, h=3)
