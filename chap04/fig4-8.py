import cmdstanpy
import pandas
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, geom_point, coord_cartesian, scale_y_continuous, labs

fit = cmdstanpy.from_csv('output/result-model4-4')
d_ms = fit.draws_pd()
N_ms = len(d_ms)

d = pandas.read_csv('input/data-salary.csv')
Xp = np.arange(0, 29)
Np = len(Xp)

np.random.seed(123)

yp_base_ms = np.zeros(shape=(N_ms, Np))
yp_ms = np.zeros(shape=(N_ms, Np))
for n in range(Np):
    yp_base_ms[:,n] = d_ms.a + d_ms.b * Xp[n]
    yp_ms[:,n] = np.random.normal(yp_base_ms[:,n], d_ms.sigma, N_ms)

qua = np.quantile(yp_base_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([Xp, qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes(x='X', ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes(x='X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes(x='X', y='50%'), size=1)
    + geom_point(d, aes(x='X', y='Y'), size=3)
    + coord_cartesian(ylim=[32, 67])
    + scale_y_continuous(breaks=np.arange(40, 70, 10))
    + labs(y='Y')
) 
p.save(filename='output/fig4-8-left.py.png', dpi=300, width=3.5, height=3)

qua = np.quantile(yp_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([Xp, qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes(x='X', ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes(x='X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes(x='X', y='50%'), size=1)
    + geom_point(d, aes(x='X', y='Y'), size=3)
    + coord_cartesian(ylim=[32, 67])
    + scale_y_continuous(breaks=np.arange(40, 70, 10))
    + labs(y='Y')
) 
p.save(filename='output/fig4-8-right.py.png', dpi=300, width=3.5, height=3)
