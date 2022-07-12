library(ggplot2)

x <- seq(0, 5, len=101)
y <- 5*exp(-2*x)
d <- data.frame(x=x, y=y)

p <- ggplot(d, aes(x,y)) +
  theme_void() +
  geom_line(size=2)
ggsave(p, file='output/fig-table1-exp1.png', dpi=250, w=6, h=4)


x <- seq(2, 5, len=101)
y <- 5*exp(2*x)
d <- data.frame(x=x, y=y)

p <- ggplot(d, aes(x,y)) +
  theme_void() +
  geom_line(size=2)
ggsave(p, file='output/fig-table1-exp2.png', dpi=250, w=6, h=4)


x <- seq(0, 5, len=101)
y <- 5*(1 - exp(-2*x))
d <- data.frame(x=x, y=y)

p <- ggplot(d, aes(x,y)) +
  theme_void() +
  geom_line(size=2)
ggsave(p, file='output/fig-table1-exp3.png', dpi=250, w=6, h=4)


x <- seq(0, 5, len=101)
y <- ifelse(x < 2, 0, 5*(1 - exp(-3*(x - 2))))
d <- data.frame(x=x, y=y)

p <- ggplot(d, aes(x,y)) +
  theme_void() +
  geom_line(size=2)
ggsave(p, file='output/fig-table1-exp4.png', dpi=250, w=6, h=4)


e0 <- 1
emax <- 2
ed50 <- 1
x <- seq(0, 5, len=101)
y <- e0 + emax*x / (ed50 + x)
d <- data.frame(x=x, y=y)

p <- ggplot(d, aes(x,y)) +
  theme_void() +
  geom_line(size=2)
ggsave(p, file='output/fig-table1-emax.png', dpi=250, w=6, h=4)


e0 <- 1
emax <- 2
ed50 <- 3
h <- 4
x <- seq(0, 7, len=101)
y <- e0 + emax*x^h / (ed50^h + x^h)
d <- data.frame(x=x, y=y)

p <- ggplot(d, aes(x,y)) +
  theme_void() +
  geom_line(size=2)
ggsave(p, file='output/fig-table1-sigemax.png', dpi=250, w=6, h=4)
