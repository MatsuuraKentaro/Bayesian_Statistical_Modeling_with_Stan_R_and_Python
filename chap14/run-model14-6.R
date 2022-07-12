library(cmdstanr)

d <- read.csv('input/data-oil.csv')
D <- 12
Y <- scale(d[ ,1:D])
N <- nrow(d)
K <- 2
res_pca <- prcomp(Y)
data <- list(N=N, D=D, K=K, Mu=rep(0, N), Y=t(Y))

model <- cmdstan_model('model/model14-6.stan')
fit_vb <- model$variational(
  data=data, seed=123, init=function(){ list(x=res_pca$x[,1:K]) })
fit_vb$save_object(file='output/result-model14-6.RDS')
