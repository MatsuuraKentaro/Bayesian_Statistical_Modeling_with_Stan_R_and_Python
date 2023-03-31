import pandas
import cmdstanpy
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_line, geom_ribbon, labs
import matplotlib.pyplot as plt
import statsmodels.api as sm

plt.style.use('ggplot')

d = pandas.read_csv('input/data-eg4.csv')
d.loc[d.Month == 8, 'Y'] = np.nan
t_obs2t = np.where(~np.isnan(d.Y))[0]
Y = d.Y[t_obs2t]

fit = cmdstanpy.from_csv('output/result-model11-13')
mu_ms = fit.stan_variable(var='mu')
qua = np.quantile(mu_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1, len(d)+1), qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])
d_est = pandas.merge(d_est, pandas.DataFrame({'X':np.arange(1, len(d)+1), 'Y':d.Y}), on='X', how='left')
d_est['2.5%'] = d_est['2.5%'] - Y
d_est['25%'] = d_est['25%'] - Y
d_est['50%'] = d_est['50%'] - Y
d_est['75%'] = d_est['75%'] - Y
d_est['97.5%'] = d_est['97.5%'] - Y

p = (ggplot(d_est, aes('X'))
    + theme_bw(base_size=18)
    + geom_ribbon(aes(ymin='2.5%', ymax='97.5%'), alpha=1/6)
    + geom_ribbon(aes(ymin='25%',  ymax='75%'),   alpha=2/6)
    + geom_line(aes(y='50%'), size=0.2)
    + labs(x='Time (Day)', y='residual')
)
p.save(filename='output/fig11-22-left.py.png', dpi=300, width=4, height=3)

fig = plt.figure(figsize=(6, 4))
ax1 = fig.add_subplot(111)
sm.graphics.tsa.plot_acf(d_est['50%'], lags=32, ax=ax1, missing='drop')
plt.savefig('output/fig11-22-right.py.png', dpi=300)
