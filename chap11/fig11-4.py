import pandas
import cmdstanpy
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, geom_point, geom_vline, coord_cartesian, labs
import matplotlib.pyplot as plt
import statsmodels.api as sm

plt.style.use('ggplot')

d = pandas.read_csv('input/data-weight.csv')
T = len(d)
Tp = 3
fit = cmdstanpy.from_csv('output/result-model11-2')
mu_all_ms = fit.stan_variable(var='mu_all')
qua = np.quantile(mu_all_ms, [0.1, 0.25, 0.50, 0.75, 0.9], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1, T+Tp+1), qua.T]), \
    columns=['X', '10%', '25%', '50%', '75%', '90%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes('X', ymin='10%', ymax='90%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes('X', y='50%'), size=1)
    + geom_point(d, aes('X', 'Y'), shape='o', size=2.5)
    + geom_vline(xintercept=T, linetype='dashed')
    + coord_cartesian(xlim=[1, 24])
    + labs(x='Time (Day)', y='Y')
)
p.save(filename='output/fig11-4-left.py.png', dpi=300, width=3.5, height=3)

d_residual = pandas.DataFrame({'50%':d_est['50%'][0:T] - d.Y})
fig = plt.figure(figsize=(6, 4))
ax1 = fig.add_subplot(111)
sm.graphics.tsa.plot_acf(d_residual['50%'], lags=13, ax=ax1)
plt.savefig('output/fig11-4-right.py.png', dpi=300)
