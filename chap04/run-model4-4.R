library(cmdstanr)

d <- read.csv(file='input/data-salary.csv')
data <- list(N=nrow(d), X=d$X, Y=d$Y)
model <- cmdstan_model(stan_file='model/model4-4.stan')
fit <- model$sample(data=data, seed=123)

fit$save_object(file='output/result-model4-4.RDS')
write.table(fit$summary(), file='output/fit-summary.csv',
            sep=',', quote=TRUE, row.names=FALSE)

library(coda)
pdf(file='output/fit-plot.pdf')
plot(as_mcmc.list(fit))
dev.off()
