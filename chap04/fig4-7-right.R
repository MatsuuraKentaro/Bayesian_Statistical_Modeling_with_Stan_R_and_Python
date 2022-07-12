library(ggplot2)
library(patchwork)

fit <- readRDS(file='output/result-model4-4.RDS')
d_ms <- fit$draws(format='df')
x_range <- c(32.5, 46.1)
y_range <- c(0.29, 1.11)
x_breaks <- seq(30, 50, 5)
y_breaks <- seq(0.4, 1.0, 0.2)

p_xy <- ggplot(d_ms,aes(x=a,y=b)) +
  theme_bw(base_size=18) +
  coord_cartesian(xlim = x_range, ylim = y_range) +
  geom_point(size=2, shape=21, bg='white') +
  scale_x_continuous(breaks=x_breaks) +
  scale_y_continuous(breaks=y_breaks)

p_x <- ggplot(d_ms, aes(x=a)) +
  theme_bw(base_size=18) +
  theme(axis.title.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  coord_cartesian(xlim = x_range) +
  geom_histogram(aes(y=..density..), colour='black', fill='white') +
  scale_x_continuous(breaks=x_breaks)

p_y <- ggplot(d_ms, aes(x=b)) +
  theme_bw(base_size=18) +
  theme(axis.title.y = element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank()) + 
  coord_flip(xlim = y_range) +
  geom_histogram(aes(y=..density..), colour='black', fill='white') +
  scale_x_continuous(breaks=y_breaks)

p <- wrap_plots(
  p_x, plot_spacer(), 
  p_xy, p_y, 
  nrow = 2,
  widths = c(1, 0.3),
  heights = c(0.3, 1)
)

ggsave(p, file='output/fig4-7-right.png', dpi=250, w=6, h=6)
