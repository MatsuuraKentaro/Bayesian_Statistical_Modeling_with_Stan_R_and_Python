library(dplyr)
library(ggplot2)

d <- read.csv(file='input/data-gp-sparse.csv')
N <- nrow(d)
Np <- 61
Xp <- seq(from=0, to=1, len=Np)

fit_MAP <- readRDS('output/result-model12-10.RDS')
fp <- fit_MAP$draws('fp', format='matrix') %>% as.vector()

d_est <- data.frame(X=Xp, Y=fp)
p <- ggplot(data=d_est) +
  theme_bw(base_size=18) +
  geom_line(aes(x=X, y=Y), size=1) +
  geom_point(data=d, aes(x=X, y=Y), color='black', shape=16, size=0.2, alpha=0.3) +
  labs(x='X', y='Y')
ggsave(p, file='output/fig12-18.png', dpi=300, w=4, h=3)
