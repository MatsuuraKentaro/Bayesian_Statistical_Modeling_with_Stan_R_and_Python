import pandas
import cmdstanpy
import numpy as np
from scipy import stats
from plotnine import *

d = pandas.read_csv('input/data-rental.csv')
N = len(d)

fit = cmdstanpy.from_csv('output/result-model7-1')
mu_ms = fit.stan_variable(var='mu')
N_ms = len(mu_ms)
noise_ms = np.repeat(d.Y.to_numpy()[None, :], N_ms, axis=0) - mu_ms
# noise_ms = np.einsum('n,m->mn', d.Y, np.repeat(1, N_ms)) - mu_ms

mode_list = []
for i in range(N):
    density = stats.gaussian_kde(noise_ms[:,i])
    xs = np.linspace(-400, 550, 201)
    ys = density(xs)
    mode_i = np.argmax(ys)
    mode_x = xs[mode_i]
    mode_y = ys[mode_i]
    mode_list.append([mode_x, mode_y])

d_mode = pandas.DataFrame(mode_list, columns=['X', 'Y'])

s_dens = stats.gaussian_kde(fit.stan_variable(var='sigma'))
xs = np.linspace(-400, 550, 201)
ys = s_dens(xs)
s_MAP = xs[np.argmax(ys)]
bw = 25
p = (ggplot(d_mode, aes(x='X'))
  + theme_bw(base_size=18)
  + geom_histogram(aes(y='..density..'), binwidth=bw, color='black', fill='white')
  + geom_density(fill='gray', alpha=0.5)
  + geom_rug(sides='b')
  + stat_function(fun=stats.norm.pdf, args=dict(loc=0, scale=s_MAP), linetype='dashed')
  + labs(x='value', y='density')
  + xlim(-400, 550)
) 
p.save(filename='output/fig7-4-left.py.png', dpi=300, width=4, height=3)
