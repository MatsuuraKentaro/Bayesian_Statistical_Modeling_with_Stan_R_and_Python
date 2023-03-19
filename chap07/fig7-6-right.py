import pandas
import numpy as np
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, geom_point, ylim, labs

d = pandas.read_csv('input/data-sigEmax.csv')
Np = 60
Xp = np.linspace(50, 650, num=Np)

fit = cmdstanpy.from_csv('output/result-model7-4')
yp_ms = fit.stan_variable(var='yp')

qua = np.quantile(yp_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([Xp, qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes('X', ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes('X', '50%'), size=0.5)
    + geom_point(d, aes('X', 'Y'), shape='o', size=2)
    + ylim(2, 33)
    + labs(x='X', y='Y')
)
p.save(filename='output/fig7-6-right.py.png', dpi=300, width=4, height=3)
