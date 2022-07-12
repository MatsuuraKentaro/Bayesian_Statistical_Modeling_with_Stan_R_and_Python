fit <- readRDS('output/result-model11-2.RDS')

mu_all_ms <- fit$draws('mu_all', format='matrix')
s_y_ms <- fit$draws('s_y', format='df')$s_y

t_now <- 21
dens_pred <- density(mu_all_ms[,t_now])
w <- dnorm(x=85.2, mean=mu_all_ms[,t_now], sd=s_y_ms)
dens_flt <- density(mu_all_ms[,t_now], weight=w/sum(w))
post_mean <- sum(mu_all_ms[,t_now] * w/sum(w))
