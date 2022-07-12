library(cmdstanr)

d <- read.csv('input/data-matrix-decomp.csv')
N <- 50
K <- 6
I <- 120
d$PersonID <- factor(d$PersonID, 1:N)
d$ItemID <- factor(d$ItemID, 1:I)
Y <- as.matrix(unclass(table(d)))
data <- list(N=N, I=I, K=K, Y=Y, Alpha=rep(0.5, I))

model <- cmdstan_model('model/model14-4.stan')
fit_vb <- model$variational(data=data, seed=123)
fit_vb$save_object(file='output/result-model14-4.RDS')
