library(dplyr)
set.seed(123)

N <- 50
I <- 120
K <- 6
alpha0 <- rep(0.8, K)
alpha1 <- rep(0.2, I)
theta <- gtools::rdirichlet(N, alpha0)
phi <- gtools::rdirichlet(K, alpha1)
num_items_by_n <- round(exp(rnorm(N, 2.0, 0.5)))

d <- lapply(1:N, function(n) {
  z <- sample(K, num_items_by_n[n], prob=theta[n,], replace=TRUE)
  item <- sapply(z, function(k) sample(I, 1, prob=phi[k,]))
  data.frame(PersonID=n, ItemID=item)
}) %>% bind_rows()
