library(dplyr)
library(ggplot2)

d <- read.csv('input/data-2Dmesh.csv', header=FALSE)
I <- nrow(d)
J <- ncol(d)

fit_MAP <- readRDS('output/result-model12-9.RDS')
f_est <- fit_MAP$draws('fp', format='matrix') %>% 
  matrix(., I, J)

png('output/fig12-16.png', pointsize=72, width=2400, height=2100)
persp(1:I, 1:J, f_est, theta=55, phi=40, expand=0.5, border='black', col='grey95',
  xlab='Plate Row', ylab='Plate Column', zlab='f', ticktype='detailed', lwd=2)
dev.off()
