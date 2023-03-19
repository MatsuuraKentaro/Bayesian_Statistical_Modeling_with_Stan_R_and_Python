library(dplyr)
library(ggplot2)

C <- 4
d <- read.csv('input/data-salary-2.csv')
d <- d %>% 
  mutate(CID = as.factor(CID),
         CID_label = factor(paste0('CID = ', CID), levels = paste0('CID = ', 1:C)))

fit1 <- readRDS('output/result-model8-1.RDS')
fit2 <- readRDS('output/result-model8-2.RDS')
fit3 <- readRDS('output/result-model8-3.RDS')
d_ms1 <- fit1$draws(format='df')
d_ms2_a <- fit2$draws('a', format='matrix')
d_ms2_b <- fit2$draws('b', format='matrix')
d_ms3_a <- fit3$draws('a', format='matrix')
d_ms3_b <- fit3$draws('b', format='matrix')

N_ms <- nrow(d_ms1)
range_by_CID <- sapply(split(d, d$CID), function(x) c(Xmin=min(x$X), Xmax=max(x$X)))
d_X <- data.frame(CID=1:C, t(range_by_CID), check.names=FALSE)

Xp <- min(d_X$Xmin):max(d_X$Xmax)
Np <- length(Xp)
yp_base_mcmc1 <- matrix(nrow=N_ms, ncol=Np)
for (n in 1:Np) {
  yp_base_mcmc1[,n] <- d_ms1$a + d_ms1$b * Xp[n]
}
yp_base_med1 <- apply(yp_base_mcmc1, 2, median)
d1 <- data.frame(X=rep(Xp, C), Y=rep(yp_base_med1, C), CID=rep(1:C, each=Np), Model='8-1')

d2 <- NULL
d3 <- NULL
for (c in 1:C) {
  Xp <- d_X$Xmin[c]:d_X$Xmax[c]
  Np <- length(Xp)
  yp_base_mcmc2 <- matrix(nrow=N_ms, ncol=Np)
  yp_base_mcmc3 <- matrix(nrow=N_ms, ncol=Np)
  for (n in 1:Np) {
    yp_base_mcmc2[,n] <- unlist(d_ms2_a[,c] + d_ms2_b[,c] * Xp[n])
    yp_base_mcmc3[,n] <- unlist(d_ms3_a[,c] + d_ms3_b[,c] * Xp[n])
  }
  d2 <- rbind(d2, data.frame(X=Xp, Y=apply(yp_base_mcmc2, 2, median), CID=c, Model='8-2'))
  d3 <- rbind(d3, data.frame(X=Xp, Y=apply(yp_base_mcmc3, 2, median), CID=c, Model='8-3'))
}

d1 <- d1 %>% 
  mutate(CID = as.factor(CID)) %>% 
  mutate(CID_label = factor(paste0('CID = ', CID), levels = paste0('CID = ', 1:C)))
d2 <- d2 %>% 
  mutate(CID = as.factor(CID)) %>% 
  mutate(CID_label=factor(paste0('CID = ', CID), levels = paste0('CID = ', 1:C)))
d3 <- d3 %>% 
  mutate(CID = as.factor(CID)) %>% 
  mutate(CID_label=factor(paste0('CID = ', CID), levels = paste0('CID = ', 1:C)))


p <- ggplot(data=d, aes(x=X, y=Y, shape=CID)) +
  theme_bw(base_size=20) +
  theme(legend.key.width=grid::unit(2.5,'line')) +
  facet_wrap(~CID_label) +
  geom_line(data=d1, aes(alpha=Model, linetype=Model, size=Model)) +
  geom_line(data=d2, aes(alpha=Model, linetype=Model, size=Model)) +
  geom_line(data=d3, aes(alpha=Model, linetype=Model, size=Model)) +
  geom_point(size=3, alpha=0.3) +
  scale_shape_manual(values=c(16, 2, 4, 9)) +
  scale_size_manual(values=c(2, 1, 1)) +
  scale_linetype_manual(values=c('solid', '31', 'solid')) +
  scale_alpha_manual(values=c(0.2, 0.6, 1)) +
  labs(x='X', y='Y')
ggsave(p, file='output/fig8-4-right.png', dpi=300, w=6.3, h=5)
