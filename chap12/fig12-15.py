import pandas
import numpy as np
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, geom_point, coord_cartesian, labs

Y = pandas.read_csv('input/data-1D.csv').Y
I = len(Y)
X = np.arange(I) / (I-1)
d = pandas.DataFrame({'X':X, 'Y':Y})

fit = cmdstanpy.from_csv('output/result-model12-8')
y_mean_ms = fit.stan_variable('y_mean')
qua = np.quantile(y_mean_ms, [0.1, 0.25, 0.50, 0.75, 0.9], axis=0)
d_est = pandas.DataFrame(np.column_stack([X, qua.T]), \
    columns=['X', '10%', '25%', '50%', '75%', '90%'])

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_ribbon(d_est, aes(x='X', ymin='10%', ymax='90%'), fill='black', alpha=1/6)
    + geom_ribbon(d_est, aes(x='X', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_est, aes(x='X', y='50%'), size=0.5)
    + geom_point(d, aes(x='X', y='Y'), size=2)
    + coord_cartesian(ylim=[0, 22])
    + labs(x='X', y='Y')
) 
p.save(filename='output/fig12-15.py.png', dpi=300, width=4, height=3)
