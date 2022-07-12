library(dplyr)
library(NipponMap)

fit <- readRDS('output/result-model12-5.RDS')
f_ms <- fit$draws('f', format='matrix')
f_est <- apply(f_ms, 2, mean)
f_est[f_est > 19] <- 19
cols <- lattice::level.colors(
  f_est, at=seq(9, 19, length=81),
  col.regions=colorRampPalette(RColorBrewer::brewer.pal(9,'Greys'))(100)
)
png('output/fig12-7-right.png', w=800, h=600)
JapanPrefMap(col=cols)
dev.off()
