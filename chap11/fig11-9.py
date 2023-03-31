import pandas
import cmdstanpy
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, labs

d = pandas.read_csv('input/data-switch.csv')
T = len(d)

fit = cmdstanpy.from_csv('output/result-model11-6')
sw_ms = fit.stan_variable(var='sw')
qua = np.quantile(sw_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1, T+1), qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_line(d, aes('X', 'Y'), size=0.3, alpha=0.4)
    + geom_ribbon(d_est, aes('X', ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes('X', y='50%'), size=0.2)
    + geom_line(d_est, aes('X', y='2.5%'), size=0.2)
    + geom_line(d_est, aes('X', y='97.5%'), size=0.2)
    + geom_line(d_est, aes('X', y='25%'), size=0.2)
    + geom_line(d_est, aes('X', y='75%'), size=0.2)
    + labs(x='Time (Second)', y='Y')
)
p.save(filename='output/fig11-9-left.py.png', dpi=300, width=3.5, height=3)


fit = cmdstanpy.from_csv('output/result-model11-7')
sw_ms = fit.stan_variable(var='sw')
qua = np.quantile(sw_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1, T+1), qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_line(d, aes('X', 'Y'), size=0.3, alpha=0.4)
    + geom_ribbon(d_est, aes('X', ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes('X', y='50%'), size=0.2)
    + geom_line(d_est, aes('X', y='2.5%'), size=0.2)
    + geom_line(d_est, aes('X', y='97.5%'), size=0.2)
    + geom_line(d_est, aes('X', y='25%'), size=0.2)
    + geom_line(d_est, aes('X', y='75%'), size=0.2)
    + labs(x='Time (Second)', y='Y')
)
p.save(filename='output/fig11-9-right.py.png', dpi=300, width=3.5, height=3)
