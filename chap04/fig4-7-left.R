library(plot3D)

fit <- readRDS(file='output/result-model4-4.RDS')
d_ms <- fit$draws(format='df')
N_ms <- nrow(d_ms)

png(file='output/fig4-7-left.png', res=300, width=2100, height=1900)
scatter3D(d_ms$a, d_ms$b, d_ms$sigma, 
          bgvar=1:N_ms, bg=jet.col(100, 0.8), 
          bty='b2', type='p', lwd=2, phi=10, theta=30,
          col='black', pch=21,  cex=1, ticktype='detailed', colkey=FALSE,
          xlab='', ylab='', zlab='', zlim=c(0.8, 6.2))
scatter3D(d_ms$a, d_ms$b, rep(0.8, N_ms), colkey=FALSE, add=TRUE,
          type='p', lwd=2, pch=21, 
          col='black', bg='white', alpha=0.8,
          cex=1)
text3D(40, 0.15, 0.9, labels='a', add=TRUE, adj=1)
text3D(47, 0.6, 0.8, labels='b', add=TRUE, adj=1)
text3D(29, 0.3, 3.6, labels=expression(sigma), add=TRUE, adj=1)
dev.off()

## interactive plot
# library(rgl)
# par3d(cex=1.75)
# plot3d(d_ms$a, d_ms$b, d_ms$sigma, col=gl(10,10), size=2, type='s')
# plot3d(d_ms$a, d_ms$b, 0.8, col='black', size=1, type='s', add=TRUE)
# snapshot3d('output/fig4-7-left.png', fmt='png', top=TRUE)
