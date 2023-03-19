import pandas
import numpy as np
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, geom_point, coord_cartesian, labs

d = pandas.read_csv('input/data-rental.csv')
Np = 50
Xp = np.linspace(10, 120, num=Np)

fit = cmdstanpy.from_csv('output/result-model7-1')
yp_np_ms = fit.stan_variable(var='yp_np')

qua = np.quantile(yp_np_ms, [0.1, 0.25, 0.50, 0.75, 0.9], axis=0)
d_est = pandas.DataFrame(np.column_stack([Xp, qua.T]), \
    columns=['X', '10%', '25%', '50%', '75%', '90%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes('X', ymin='10%', ymax='90%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes('X', '50%'), size=1)
    + geom_point(d, aes('Area', 'Y'), shape='o', size=2)
    + coord_cartesian(xlim=[11, 118], ylim=[-50, 1900])
    + labs(x='Area', y='Y')
)
p.save(filename='output/fig7-2-left.py.png', dpi=300, width=4, height=3)
