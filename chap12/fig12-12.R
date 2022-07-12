library(mvtnorm)
library(dplyr)
library(ggplot2)

set.seed(123)

N <- 101
X <- seq(0, 1, len=N)
S <- 5

a_s   <- c(2, 0.5)
rho_s <- c(0.05, 0.2)
params <- tidyr::crossing(a=a_s, rho=rho_s)

d <- lapply(1:nrow(params), function(paraID) {
  a   <- params$a[paraID]
  rho <- params$rho[paraID]
  K <- matrix(rep(0, N*N), nrow=N)
  for (i in 1:N) {
    for (j in 1:N) {
      K[i,j] <- a^2 * exp(-0.5/(rho^2)*(X[i]-X[j])^2)
    }
  }
  ys <- sapply(1:S, function(s) {
    y <- rmvnorm(1, mean=rep(0, N), sigma=K)
  })
  data.frame(a=a, rho=rho, X=X, ys) %>% 
    magrittr::set_colnames(c('a', 'rho', 'X', 1:S)) %>% 
    tidyr::pivot_longer(cols=-c(a, rho, X), names_to='Sample', values_to='Y')
}) %>% bind_rows()

d_plot <- d %>% 
  mutate(a_disp=paste0('a==', a), rho_disp=paste0('rho==', rho))

p <- ggplot(data=d_plot, aes(x=X, y=Y, linetype=Sample)) +
  theme_bw(base_size=18) +
  theme(axis.text.x=element_text(angle=40, vjust=1, hjust=1)) +
  facet_grid(rho_disp ~ a_disp, labeller=label_parsed) +
  geom_line(alpha=0.8)
ggsave(p, file='output/fig12-12.png', dpi=300, w=6, h=5)
