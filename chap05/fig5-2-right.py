import pandas
import cmdstanpy
import numpy as np
from plotnine import *

d = pandas.read_csv('input/data-shopping-1.csv')

fit = cmdstanpy.from_csv('output/result-model5-3')
yp_ms = fit.stan_variable(var='yp')

qua = np.quantile(yp_ms, [0.1, 0.50, 0.9], axis=0)
d_qua = pandas.DataFrame(qua.T, columns=['10%', '50%', '90%'])
d_est = pandas.concat([d, d_qua], axis=1)

p = (ggplot(d_est, aes(x='Y', y='50%', ymin='10%', ymax='90%', shape='factor(Sex)', fill='factor(Sex)'))
    + theme_bw(base_size=18)
    + coord_fixed(ratio=1, xlim=[0.28, .8], ylim=[0.28, .8])
    + geom_abline(aes(slope=1, intercept=0), color='black', alpha=3/5, linetype='dashed')
    + geom_pointrange(size=0.8, color='gray')
    + scale_shape_manual(values=['o', '^'])
    + scale_fill_manual(values=['white', 'lightgrey'])
    + labs(x='Observed', y='Predicted')
    + scale_x_continuous(breaks=np.arange(0, 1.1, 0.1))
    + scale_y_continuous(breaks=np.arange(0, 1.1, 0.1))
    + labs(x='Observed', y='Predicted', shape='Sex', fill='Sex')
) 
p.save(filename='output/fig5-2-right.py.png', dpi=300, width=5, height=4)
