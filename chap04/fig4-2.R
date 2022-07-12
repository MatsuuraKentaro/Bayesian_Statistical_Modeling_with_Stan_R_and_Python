library(ggplot2)

d <- read.csv(file='input/data-salary.csv')
res_lm <- lm(Y ~ X, data=d)
X_pred <- data.frame(X=0:28)
conf_95 <- predict(res_lm, X_pred, interval='confidence', level=0.95)
pred_95 <- predict(res_lm, X_pred, interval='prediction', level=0.95)
conf_50 <- predict(res_lm, X_pred, interval='confidence', level=0.50)
pred_50 <- predict(res_lm, X_pred, interval='prediction', level=0.50)
conf_95 <- data.frame(X_pred, conf_95)
pred_95 <- data.frame(X_pred, pred_95)
conf_50 <- data.frame(X_pred, conf_50)
pred_50 <- data.frame(X_pred, pred_50)

p <- ggplot() + 
  theme_bw(base_size=18) +
  geom_ribbon(data=conf_95, aes(x=X, ymin=lwr, ymax=upr), alpha=1/6) +
  geom_ribbon(data=conf_50, aes(x=X, ymin=lwr, ymax=upr), alpha=2/6) +
  geom_line(data=conf_50, aes(x=X, y=fit), size=1) +
  geom_point(data=d, aes(x=X, y=Y), shape=1, size=3) +
  scale_y_continuous(breaks=seq(40, 60, 10), limits=c(32, 67)) +
  labs(x='X', y='Y')
ggsave(p, file='output/fig4-2-left.png', dpi=300, w=3.5, h=3)

p <- ggplot() + 
  theme_bw(base_size=18) +
  geom_ribbon(data=pred_95, aes(x=X, ymin=lwr, ymax=upr), alpha=1/6) +
  geom_ribbon(data=pred_50, aes(x=X, ymin=lwr, ymax=upr), alpha=2/6) +
  geom_line(data=pred_50, aes(x=X, y=fit), size=1) +
  geom_point(data=d, aes(x=X, y=Y), shape=1, size=3) +
  scale_y_continuous(breaks=seq(40, 60, 10), limits=c(32, 67)) +
  labs(x='X', y='Y')
ggsave(p, file='output/fig4-2-right.png', dpi=300, w=3.5, h=3)
