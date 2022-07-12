d <- read.csv(file='input/data-weight.csv')

png('output/fig11-3.png', pointsize=48, width=1200, height=900)
par(mar=c(4, 4, 0.1, 0.1))
acf(d$Y, lwd=15, lend=1, main='')
dev.off()
