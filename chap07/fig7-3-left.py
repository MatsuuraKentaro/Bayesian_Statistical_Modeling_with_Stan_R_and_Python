import pandas
import numpy as np
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, coord_fixed, geom_pointrange, geom_abline, labs

d = pandas.read_csv('input/data-rental.csv')

fit = cmdstanpy.from_csv('output/result-model7-1')
yp_np_ms = fit.stan_variable(var='yp_n')

qua = np.quantile(yp_np_ms, [0.1, 0.25, 0.50, 0.75, 0.9], axis=0)
d_est = pandas.DataFrame(np.column_stack([d.Y.values, qua.T]), \
    columns=['X', '10%', '25%', '50%', '75%', '90%'])

p = (ggplot(d_est, aes('X', '50%'))
    + theme_bw(base_size=18)
    + coord_fixed(ratio=1, xlim=[-50, 1900], ylim=[-50, 1900])
    + geom_pointrange(aes(ymin='10%', ymax='90%'), color='gray', fill='gray', shape='o')
    + geom_abline(aes(slope=1, intercept=0), color='black', alpha=3/5, linetype='dashed')
    + labs(x='Observed', y='Predicted')
)
p.save(filename='output/fig7-3-left.py.png', dpi=300, width=4.2, height=4)
