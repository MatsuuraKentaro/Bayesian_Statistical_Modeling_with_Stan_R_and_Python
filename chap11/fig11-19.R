library(ggplot2)

f <- function(x) { ifelse(x < 8000, 0, 1 - exp(-0.00012*(x - 8000))) }

x <- seq(0, 110000, 100)
d <- data.frame(x=x, y=f(x))

p <- ggplot(data=d, aes(x=x, y=y)) +
  theme_bw(base_size=18) +
  geom_line(size=1) +
  labs(x='Event_n', y='Event_val')
ggsave(p, file='output/fig11-19.png', dpi=300, w=4, h=3)
