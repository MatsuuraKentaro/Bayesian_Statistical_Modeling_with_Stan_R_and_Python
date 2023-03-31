import pandas
import cmdstanpy
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, geom_point, coord_cartesian, labs

T = 24
fit = cmdstanpy.from_csv('output/result-model11-10')
trend_ms = fit.stan_variable(var='trend')
qua = np.quantile(trend_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(0, T), qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes('X', ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes('X', y='50%'), size=0.5)
    + geom_point(d_est, aes('X', y='50%'))
    + labs(x='Time (Hour)', y='Y')
)
p.save(filename='output/fig11-13-left.py.png', dpi=300, width=4, height=3)


sw_ms = fit.stan_variable(var='sw')
qua = np.quantile(sw_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(0, T), qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes('X', ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes('X', y='50%'), size=0.5)
    + geom_point(d_est, aes('X', y='50%'))
    + labs(x='Time (Hour)', y='Y')
)
p.save(filename='output/fig11-13-right.py.png', dpi=300, width=4, height=3)
