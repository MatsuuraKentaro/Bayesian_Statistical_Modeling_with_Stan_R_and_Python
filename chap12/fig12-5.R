library(dplyr)
library(ggplot2)

d <- read.csv(file='input/data-ageheap.csv')
d_M <- d %>% filter(Sex=='M')
d_F <- d %>% filter(Sex=='F')

A <- 76  # number of ages from 0 to 75+
Age_idx <- seq(from=0, to=75, by=5) + 1
Flow <- lapply(1:length(Age_idx), function(i) {
  data.frame(from=Age_idx[i] + c(-2,-1,1,2), to=rep(Age_idx[i], 4))
}) %>% bind_rows() %>% 
  filter(from > 1 & from <= 76)

add_col_to_d <- function(d, fit) {
  d_out <- d %>% mutate(ratio=Y/sum(Y) * 100)
  d_ms <- fit$draws(format='df') %>% select(starts_with('q['))
  qua <- apply(d_ms * 100, 2, quantile, probs=c(0.025, 0.5, 0.975))
  d_out <- data.frame(d_out, t(qua), check.names=FALSE)
  return(d_out)
}

fit_M <- readRDS('output/result-model12-4-M.RDS')
fit_F <- readRDS('output/result-model12-4-F.RDS')
d_M <- add_col_to_d(d_M, fit_M)
d_F <- add_col_to_d(d_F, fit_F)

p <- ggplot() +
  theme_bw(base_size=18) +
  theme(panel.grid.minor.x=element_blank()) +
  geom_bar(data=d_M, aes(x=Age, y=-1*ratio), stat='identity', width=0.6, alpha=0.3) +
  geom_bar(data=d_F, aes(x=Age, y=ratio   ), stat='identity', width=0.6, alpha=0.3) +
  geom_point(data=d_M, aes(x=Age, y=-1*`50%`), stat='identity') +
  geom_point(data=d_F, aes(x=Age, y=`50%`),    stat='identity') +
  geom_errorbar(data=d_M, aes(x=Age, ymin=-1*`2.5%`, ymax=-1*`97.5%`), width=0.6) +
  geom_errorbar(data=d_F, aes(x=Age, ymin=`2.5%`,    ymax=`97.5%`),    width=0.6) +
  scale_x_continuous(breaks=seq(0,100,5), labels=seq(0,100,5)) +
  scale_y_continuous(breaks=seq(-3,3,1),labels=abs(seq(-3,3,1)),limit=c(-3,3)) +
  guides(fill=guide_legend(reverse=TRUE)) +
  geom_hline(yintercept=0) +
  labs(x='Age', y='Composition Ratio (%)') +
  coord_flip()
ggsave(p, file='output/fig12-5-left.png', dpi=300, w=7.5, h=6)


make_d_r <- function(Flow, sex, fit) {
  r_ms <- fit$draws('r', format='matrix')
  qua <- apply(r_ms, 2, quantile, probs=c(0.025, 0.5, 0.975))
  d_out <- data.frame(Sex=sex, Age=Flow$from-1, t(qua), check.names=FALSE)
  return(d_out)
}

d_r_M <- make_d_r(Flow, 'M', fit_M)
d_r_F <- make_d_r(Flow, 'F', fit_F)

p <- ggplot() +
  theme_bw(base_size=18) +
  theme(panel.grid.minor.x=element_blank()) +
  geom_point(data=d_r_M, aes(x=Age, y=-`50%`)) +
  geom_point(data=d_r_F, aes(x=Age, y=`50%`)) +
  geom_errorbar(data=d_r_M, aes(x=Age, ymin=-`2.5%`, ymax=-`97.5%`), width=0.6) +
  geom_errorbar(data=d_r_F, aes(x=Age, ymin=`2.5%`,  ymax=`97.5%`), width=0.6) +
  geom_hline(aes(yintercept=0)) +
  scale_x_continuous(breaks=seq(0,100,5), labels=seq(0,100,5)) +
  scale_y_continuous(breaks=seq(-1,1,0.2),labels=abs(seq(-1,1,0.2))) +
  labs(x='Age', y='r') +
  coord_flip()
ggsave(p, file='output/fig12-5-right.png', dpi=300, w=6, h=6)
