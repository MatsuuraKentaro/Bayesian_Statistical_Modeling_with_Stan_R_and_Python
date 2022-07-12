library(dplyr)
library(ggplot2)

d <- read.csv('input/data-oil.csv')
N <- nrow(d)
K <- 2
fit_vb <- readRDS('output/result-model14-6.RDS')
x_est <- fit_vb$draws('x', format='matrix') %>% 
  apply(., 2, median) %>% 
  matrix(., N, K)
d_plot <- data.frame(X1=x_est[,1], X2=x_est[,2], Class=factor(d$Class))

p <- ggplot(data=d_plot, aes(x=X1, y=X2, shape=Class)) +
  theme_bw(base_size=18) +
  geom_point(size=2.5, alpha=0.7) +
  scale_shape_manual(values=c(1,4,17))
ggsave(p, file='output/fig14-7-right.png', dpi=300, w=6, h=5)
