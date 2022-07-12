library(ggplot2)

d <- read.csv('input/data-oil.csv')
D <- 12
Y <- scale(d[ ,1:D])

res_pca <- prcomp(Y)
d_pca <- data.frame(X1=res_pca$x[ ,1], X2=res_pca$x[ ,2], Class=factor(d$Class))

p <- ggplot(data=d_pca, aes(x=X1, y=X2, shape=Class)) +
  theme_bw(base_size=18) +
  geom_point(size=2.5, alpha=0.7) +
  scale_shape_manual(values=c(1,4,17))
ggsave(p, file='output/fig14-6.png', dpi=300, w=6, h=5)

