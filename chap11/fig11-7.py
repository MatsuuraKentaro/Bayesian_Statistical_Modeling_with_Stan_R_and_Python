import pandas
import cmdstanpy
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, coord_cartesian, labs

d = pandas.read_csv('input/data-season.csv')
T = len(d)
L = 4

fit = cmdstanpy.from_csv('output/result-model11-4')
season_ms = fit.stan_variable(var='season')
season_ms = np.tile(season_ms, 1 + T//L)[:,:T]
qua = np.quantile(season_ms, [0.1, 0.25, 0.50, 0.75, 0.9], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1, T+1), qua.T]), \
    columns=['X', '10%', '25%', '50%', '75%', '90%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes('X', ymin='10%', ymax='90%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes('X', y='50%'), size=0.5)
    + coord_cartesian(xlim=[1, 44], ylim=[-3.8, 6.2])
    + labs(x='Time (Quarter)', y='Y')
)
p.save(filename='output/fig11-7-left.py.png', dpi=300, width=3.5, height=3)


fit = cmdstanpy.from_csv('output/result-model11-5')
season_ms = fit.stan_variable(var='season')
season_ms = np.tile(season_ms, 1 + T//L)[:,:T]
qua = np.quantile(season_ms, [0.1, 0.25, 0.50, 0.75, 0.9], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1, T+1), qua.T]), \
    columns=['X', '10%', '25%', '50%', '75%', '90%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes('X', ymin='10%', ymax='90%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes('X', y='50%'), size=0.5)
    + coord_cartesian(xlim=[1, 44], ylim=[-3.8, 6.2])
    + labs(x='Time (Quarter)', y='Y')
)
p.save(filename='output/fig11-7-right.py.png', dpi=300, width=3.5, height=3)
