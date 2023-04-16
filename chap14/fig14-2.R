library(dplyr)
library(survival)
library(ggplot2)

d <- read.csv('input/data-surv.csv')
N <- nrow(d)
months <- seq(as.Date('2014-01-01'), as.Date('2018-12-31'), by='month')
T <- length(months)

fit <- readRDS('output/result-model14-1.RDS')
F_ms <- fit$draws('log_F', format='matrix') %>% exp()
qua <- apply(F_ms, 2, quantile, prob=c(0.025, 0.25, 0.5, 0.75, 0.975))
d_est <- data.frame(T=1:T, t(qua), check.names=FALSE)
d_est <- rbind(d_est, data.frame(T=0, `2.5%`=1, `25%`=1, `50%`=1, `75%`=1, `97.5%`=1, check.names=FALSE))
d_survfit <- survfit(Surv(Time, 1-Cens) ~ 1, data=d)
d_obs <- data.frame(T=c(0, d_survfit$time), surv=c(1, d_survfit$surv), n.censor=c(0, d_survfit$n.censor))

p <- ggplot() +
  theme_bw(base_size=24) +
  geom_ribbon(data=d_est, aes(x=T, ymin=`2.5%`, ymax=`97.5%`), alpha=1/4) +
  geom_line(data=d_est, aes(x=T, y=`50%`), linetype='dashed') +
  geom_step(data=d_obs, aes(x=T, y=surv), color='black', size=0.8) +
  # geom_point(data=subset(d_obs, n.censor!=0), aes(x=T, y=surv), color='black', shape='+', alpha=0.7, size=4) +
  scale_y_continuous(breaks=seq(0,1,0.2), labels=seq(0,1,0.2), limits=c(0,1)) +
  labs(x='Time (months)', y='Survival')
ggsave(p, file='output/fig14-2-left.png', dpi=300, width=6, height=5)

h_ms <- fit$draws('h', format='matrix')
qua <- apply(h_ms, 2, quantile, prob=c(0.025, 0.25, 0.5, 0.75, 0.975))
d_est <- data.frame(T=1:T, t(qua), check.names=FALSE)

p <- ggplot() +
  theme_bw(base_size=24) +
  geom_ribbon(data=d_est, aes(x=T, ymin=`2.5%`, ymax=`97.5%`), alpha=1/4) +
  geom_line(data=d_est, aes(x=T, y=`50%`), linetype='dashed') +
  ylim(0, 0.085) +
  labs(x='Time (months)', y='Hazard')
ggsave(p, file='output/fig14-2-right.png', dpi=300, width=6, height=5)
