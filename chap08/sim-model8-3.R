set.seed(123)
N <- 40
C <- 4
N_c <- c(15, 12, 10, 3)
a_field <- 350
b_field <- 12
s_a <- 60
s_b <- 4
s_y <- 25
X <- sample(x=0:35, size=N, replace=TRUE)
n2c <- rep(1:4, times=N_c)

a <- rnorm(C, mean=0, sd=s_a) + a_field
b <- rnorm(C, mean=0, sd=s_b) + b_field
d <- data.frame(X=X, CID=n2c, a=a[n2c], b=b[n2c])
d$Y_sim <- rnorm(N, mean=d$a + d$b*X, sd=s_y)
