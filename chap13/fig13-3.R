library(ggplot2)

x <- seq(0, 1, len=201)
y <- dbeta(x, shape1=2, shape2=4)
d <- data.frame(x=x*610, y=y)

X <- c(89, 144, 233, 377)/610
Y <- dbeta(X, shape1=2, shape2=4)
d1 <- data.frame(x=X*610, y=Y)

p <- ggplot(data=d, aes(x, y)) +
  theme_classic() +
  theme(text=element_text(size=22),
        axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  geom_ribbon(data=subset(d, x > 377), aes(x=x, y=y, ymin=0, ymax=y), alpha=0.4) +
  geom_line(color='black', size=2, alpha=0.4) +
  geom_segment(data=d1, aes(x=x, xend=x, y=0, yend=y), linetype='11', size=2) +
  geom_point(data=d1, aes(x=x, y=y), size=5) +
  scale_x_continuous(breaks=c(0, 89, 144, 233, 377, 610)) +
  labs(x='')
ggsave(p, file='output/fig13-3.png', dpi=300, w=6, h=3)

