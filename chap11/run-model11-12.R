library(cmdstanr)

d_game <- read.csv(file='input/data-eg3.csv')
d_player <- read.csv(file='input/data-eg3-players.csv')
N <- max(d_player$PID)
G <- nrow(d_game)
I <- max(d_player$End_Index)
data <- list(N=N, G=G, I=I, 
             g2Ln=d_game$Loser_PID,     g2Wn=d_game$Winner_PID, 
             g2Li=d_game$Loser_Index,   g2Wi=d_game$Winner_Index,
             n2Si=d_player$Start_Index, n2Ei=d_player$End_Index)

init_fun <- function(chain_id) { 
  set.seed(chain_id)
  list(mu_ini = rnorm(N, 0, 0.01),
       mu_raw = rnorm(I-N, 0, 0.01),
       s_pf = rep(5.0, N))
}
model <- cmdstan_model('model/model11-12.stan')
fit <- model$sample(data=data, seed=123, parallel_chains=4, init=init_fun)
fit$save_object(file='output/result-model11-12.RDS')

init_fun_b <- function(chain_id) {
  set.seed(chain_id)
  list(mu_ini = rnorm(2*N, 0, 0.01),
       mu_raw = rnorm(I-2*N, 0, 0.01),
       s_pf = rep(5.0, N))
}
model_b <- cmdstan_model('model/model11-12b.stan')
fit_b <- model_b$sample(data=data, seed=123, parallel_chains=4, init=init_fun_b)
fit_b$save_object(file='output/result-model11-12b.RDS')
