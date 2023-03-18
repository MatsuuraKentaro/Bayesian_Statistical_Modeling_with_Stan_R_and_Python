import pandas
import cmdstanpy
import numpy as np
from scipy import stats
from plotnine import *

d = pandas.read_csv('input/data-shopping-1.csv')
N = len(d)

fit = cmdstanpy.from_csv('output/result-model5-3')
mu_ms = fit.stan_variable(var='mu')
N_ms = len(mu_ms)
noise_ms = np.repeat(d.Y.to_numpy()[None, :], N_ms, axis=0) - mu_ms
# noise_ms = np.einsum('n,m->mn', d.Y, np.repeat(1, N_ms)) - mu_ms

d_est = pandas.DataFrame(noise_ms, columns=['mu[' + str(i) + ']' for i in range(1,N+1)]) 
d_est = pandas.melt(d_est, var_name='Parameter')
d_est['PersonID'] = d_est.Parameter.str.extract('(\d+)')

mode_list = []
for i in range(N):
    density = stats.gaussian_kde(noise_ms[:,i])
    xs = np.linspace(-0.15, 0.15, 201)
    ys = density(xs)
    mode_i = np.argmax(ys)
    mode_x = xs[mode_i]
    mode_y = ys[mode_i]
    mode_list.append([mode_x, mode_y])

d_mode = pandas.DataFrame(mode_list, columns=['X', 'Y'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_line(d_est, aes(x='value', group='PersonID'), stat='density', color='black', alpha=0.4)
    + geom_segment(d_mode, aes(x='X', xend='X', y='Y', yend=0), color='black', linetype='dashed', alpha=0.4)
    + geom_rug(d_mode, aes(x='X'), sides='b')
    + labs(x='value', y='density')
) 
p.save(filename='output/fig5-3-left.py.png', dpi=300, width=4, height=3)


s_dens = stats.gaussian_kde(fit.stan_variable(var='sigma'))
xs = np.linspace(-0.15, 0.15, 201)
ys = s_dens(xs)
s_MAP = xs[np.argmax(ys)]
bw = 0.01

p = (ggplot(d_mode, aes(x='X'))
    + theme_bw(base_size=18)
    + geom_histogram(aes(y='..density..'), binwidth=bw, color='black', fill='white')
    + geom_density(fill='gray', alpha=0.5)
    + geom_rug(sides='b')
    + stat_function(fun=stats.norm.pdf, args=dict(loc=0, scale=s_MAP), linetype='dashed')
    + labs(x='value', y='density')
    + xlim(-0.13, 0.13)
) 
p.save(filename='output/fig5-3-right.py.png', dpi=300, width=4, height=3)
