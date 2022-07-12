library(dplyr)
library(ggplot2)

d <- read.csv('input/data-salary-3.csv')
N <- nrow(d)
C <- 30
F <- 3
coefs <- sapply(1:C, function(c) {
  d %>% filter(CID == c) %>% lm(Y ~ X, data=.) %>% coef()
}) %>% t() %>% 
  magrittr::set_colnames(c('a', 'b'))

c2f <- d %>% select(CID, FID) %>% distinct()
d_res <- data.frame(coefs, c2f) %>% 
  mutate(FID_label = factor(paste0('FID = ', FID), levels = paste0('FID = ', 1:3)))

bw <- diff(range(d_res$a))/20
p <- ggplot(data=d_res, aes(x=a)) +
  theme_bw(base_size=18) +
  facet_wrap(~FID_label, nrow=3) +
  geom_histogram(aes(y=..density..), binwidth=bw, color='black', fill='white') +
  geom_density(color=NA, fill='gray20', alpha=0.2) +
  geom_rug(sides='b') +
  labs(x='a', y='count')
ggsave(p, file='output/fig8-6-left.png', dpi=300, w=4, h=6)

bw <- diff(range(d_res$b))/20
p <- ggplot(data=d_res, aes(x=b)) +
  theme_bw(base_size=18) +
  facet_wrap(~FID_label, nrow=3) +
  geom_histogram(aes(y=..density..), binwidth=bw, color='black', fill='white') +
  geom_density(color=NA, fill='gray20', alpha=0.2) +
  geom_rug(sides='b') +
  labs(x='b', y='count')
ggsave(p, file='output/fig8-6-right.png', dpi=300, w=4, h=6)
