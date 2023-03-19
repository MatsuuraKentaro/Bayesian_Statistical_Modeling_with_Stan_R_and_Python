library(ggplot2)

d <- read.csv(file='input/data-conc-2.csv')

bw <- 3.0
p <- ggplot(data=d, aes(x=Time24)) +
  theme_bw(base_size=18) +
  geom_histogram(aes(y=..density..), binwidth=bw, color='black', fill='white') +
  geom_density(color=NA, fill='gray20', alpha=0.4) +
  geom_rug(sides='b') +
  labs(x='Time24', y='count') +
  xlim(range(density(d$Time24)$x)) 
ggsave(p, file='output/fig8-7-right.png', dpi=300, w=4, h=4)
