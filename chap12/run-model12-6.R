library(cmdstanr)

T <- 96
d <- as.matrix(read.csv('input/data-2Dmesh.csv', header=FALSE))
I <- nrow(d)
J <- ncol(d)
ij2t <- read.csv('input/data-2Dmesh-design.csv', header=FALSE)
data <- list(I=I, J=J, Y=d, T=T, ji2t=t(ij2t))

model <- cmdstan_model('model/model12-6.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4,
                    iter_sampling=5000)
fit$save_object(file='output/result-model12-6.RDS')
