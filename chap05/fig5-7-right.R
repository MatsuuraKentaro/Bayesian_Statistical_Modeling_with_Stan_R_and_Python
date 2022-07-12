library(dplyr)
library(pROC)
library(ggplot2)

d <- read.csv(file='input/data-shopping-3.csv')

fit <- readRDS('output/result-model5-5.RDS')
q_ms <- fit$draws('q', format='matrix')
N_ms <- nrow(q_ms)
spec <- seq(from=0, to=1, len=201)
probs <- c(0.1, 0.5, 0.9)

auces <- numeric(N_ms)
m_roc <- matrix(nrow=N_ms, ncol=length(spec))
for (i in 1:N_ms) {
  roc_res <- roc(d$Y, q_ms[i,], quiet=TRUE)
  auces[i] <- as.numeric(roc_res$auc)
  m_roc[i,] <- coords(roc_res, x=spec, input='specificity', ret='sensitivity') %>% unlist()
}

# quantile(auces, prob=probs)
qua <- apply(m_roc, 2, quantile, prob=probs)
d_est <- data.frame(X=1-spec, t(qua), check.names=FALSE)

p <- ggplot(data=d_est, aes(x=X, y=`50%`)) +
  theme_bw(base_size=18) +
  theme(legend.position='none') + 
  coord_fixed(ratio=1, xlim=c(0,1), ylim=c(0,1)) +
  geom_abline(intercept=0, slope=1, alpha=0.5) +
  geom_ribbon(aes(ymin=`10%`, ymax=`90%`), fill='black', alpha=2/6) +
  geom_line(size=1) +
  labs(x='False Positive', y='True Positive')
ggsave(file='output/fig5-7-right.png', plot=p, dpi=300, w=4, h=4)
