fit <- readRDS('../chap11/exercise/ex2.RDS')
y <- fit$draws(format='df')$`yp[1]`

loss_function <- function(a) ifelse(a < y, 2*(y-a), 1-exp(-(a-y)))

expected_loss <- function(a) mean(loss_function(a))

a_best <- optim(median(y), expected_loss, method='Brent', 
                lower=5, upper=50)$par
