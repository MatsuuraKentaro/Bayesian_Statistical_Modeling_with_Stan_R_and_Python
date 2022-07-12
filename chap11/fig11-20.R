library(dplyr)
library(ggplot2)

d <- read.csv('input/data-eg4.csv')
d[d$Month == 8, ]$Y <- NA
t_obs2t <- which(!is.na(d$Y))
Y <- d$Y[t_obs2t]

fit <- readRDS('output/result-model11-13-wo-AR.RDS')
mu_ms <- fit$draws('mu', format='matrix')
qua <- apply(mu_ms, 2, quantile, probs=c(0.025, 0.25, 0.50, 0.75, 0.975))
d_est <- data.frame(X=1:ncol(qua), t(qua), check.names=FALSE)

d_est <- d_est %>%
  left_join(data.frame(X=1:nrow(d), Y=d$Y), by='X') %>%
  mutate(`2.5%` = `2.5%` - Y,
         `25%`  = `25%`  - Y,
         `50%`  = `50%`  - Y,
         `75%`  = `75%`  - Y,
         `97.5%`= `97.5%`- Y)

p <- ggplot(data=d_est, aes(x=X)) +
  theme_bw(base_size=18) +
  geom_ribbon(aes(ymin=`2.5%`, ymax=`97.5%`), alpha=1/6) +
  geom_ribbon(aes(ymin=`25%`,  ymax=`75%`),   alpha=2/6) +
  geom_line(aes(y=`50%`), size=0.2) +
  labs(x='Time (Day)', y='residual')
ggsave(p, file='output/fig11-20-left.png', dpi=300, w=4, h=3)


png('output/fig11-20-right.png', pointsize=48, width=1200, height=900)
par(mar=c(4, 4, 0.1, 0.1))
acf(d_est$`50%`, na.action=na.pass, lag.max=31, lwd=15, lend=1, main='')
dev.off()
