library(cmdstanr)

d <- read.csv('input/data-matrix-decomp.csv')
N <- 50
K <- 6
I <- 120
d$PersonID <- factor(d$PersonID, 1:N)
d$ItemID <- factor(d$ItemID, 1:I)
Y <- as.matrix(unclass(table(d)))
data <- list(N=N, I=I, K=K, Y=t(Y))

model <- cmdstan_model('model/model14-3.stan')
fit_MAP <- model$optimize(data=data, seed=123)
fit_MAP$save_object(file='output/result-model14-3.RDS')
