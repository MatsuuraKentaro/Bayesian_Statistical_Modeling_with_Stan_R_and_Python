library(cmdstanr)

d <- read.csv('input/data-eg4.csv')
Weather_val <- c(0, 0.1, 0.5, 1, 1)[d$Weather]
Event_val <- ifelse(
  d$Event_n < 8000, 0, 1 - exp(-0.00012*(d$Event_n - 8000)))
d[d$Month == 8, ]$Y <- NA
t_obs2t <- which(!is.na(d$Y))
Y <- d$Y[t_obs2t]

data <- list(
  T = nrow(d), t2wd = d$Wday, Ho = d$Ho, BH = d$BHo,
  Weather_val = Weather_val, Event_val = Event_val,
  T_obs = length(t_obs2t), t_obs2t = t_obs2t, Y = Y
)

model <- cmdstan_model('model/model11-13.stan')
fit <- model$sample(data=data, seed=123, 
                    parallel_chains=4, max_treedepth=15)
fit$save_object(file='output/result-model11-13.RDS')
