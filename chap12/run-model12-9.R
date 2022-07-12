library(cmdstanr)

T <- 96
d <- read.csv('input/data-2Dmesh.csv', header=FALSE)
I <- nrow(d)
J <- ncol(d)
N <- I*J

X <- expand.grid(Row=(1:I - 1)/(I-1), Column=(1:J - 1)/(J-1))
Y_ori <- unlist(d)
Y <- Y_ori - mean(Y_ori)
d_trt <- read.csv('input/data-2Dmesh-design.csv', header=FALSE)
n2t <- unlist(d_trt)
data <- list(N=N, X=X, Mu=rep(0, N), Y=Y, T=T, n2t=n2t)

model <- cmdstan_model('model/model12-9.stan')
fit_MAP <- model$optimize(data=data, seed=123)
fit_MAP$save_object(file='output/result-model12-9.RDS')
# fit <- model$sample(data=data, seed=123, parallel_chains=4)
# fit$save_object(file='output/result-model12-9.RDS')
