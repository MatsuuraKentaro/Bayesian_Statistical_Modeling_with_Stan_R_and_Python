import pandas
import cmdstanpy
import numpy as np
from scipy import stats
from plotnine import *

d = pandas.read_csv('input/data-map-temperature.csv')
N = len(d)
d_name = pandas.read_csv('input/data-map-JIS.csv', header=None)
d_name.columns = ['prefID', 'name']
fit = cmdstanpy.from_csv('output/result-model12-5')
f_ms = fit.stan_variable(var='f')

qua = np.quantile(f_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_qua = pandas.DataFrame(qua.T, columns=['2.5%', '25%', '50%', '75%', '97.5%'])
d_est = pandas.concat([d_name, d.Y, d_qua], axis=1)
d_est['residual'] = d_est.Y - d_est['50%']
top_residual = d_est.iloc[np.argmax(np.abs(d_est.residual))]

p = (ggplot(d_est, aes(x='Y', y='50%', ymin='2.5%', ymax='97.5%'))
    + theme_bw(base_size=18)
    + coord_fixed(ratio=1, xlim=[9, 24], ylim=[9, 24])
    + geom_pointrange(size=0.8, shape='x', fill='white')
    + geom_abline(aes(slope=1, intercept=0), color='black', alpha=3/5, linetype='dashed')
    + labs(x='Observed', y='Predicted')
    + scale_x_continuous(breaks=np.arange(0, 30, 5))
    + scale_y_continuous(breaks=np.arange(0, 30, 5))
)
p.save(filename='output/fig12-8-left.py.png', dpi=300, width=4, height=4)

N_ms = len(f_ms)
noise_ms = np.repeat(d.Y.to_numpy()[None, :], N_ms, axis=0) - f_ms
# noise_ms = np.einsum('n,m->mn', d.Y, np.repeat(1, N_ms)) - f_ms

mode_list = []
for i in range(N):
    density = stats.gaussian_kde(noise_ms[:,i])
    xs = np.linspace(-1.8, 0.5, 201)
    ys = density(xs)
    mode_i = np.argmax(ys)
    mode_x = xs[mode_i]
    mode_y = ys[mode_i]
    mode_list.append([mode_x, mode_y])

d_mode = pandas.DataFrame(mode_list, columns=['X', 'Y'])

s_dens = stats.gaussian_kde(fit.stan_variable(var='s_y'))
xs = np.linspace(-1.8, 0.5, 201)
ys = s_dens(xs)
s_MAP = xs[np.argmax(ys)]
bw = 0.05

p = (ggplot(d_mode, aes(x='X'))
    + theme_bw(base_size=18)
    + geom_histogram(aes(y='..density..'), binwidth=bw, color='black', fill='white')
    + geom_density(fill='gray', alpha=0.5)
    + geom_rug(sides='b')
    + stat_function(fun=stats.norm.pdf, args=dict(loc=0, scale=s_MAP), linetype='dashed')
    + labs(x='value', y='density')
    + xlim(-1.8, 0.5)
) 
p.save(filename='output/fig12-8-right.py.png', dpi=300, width=4, height=4)
