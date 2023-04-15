import cmdstanpy
import pandas
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_line, geom_point, ylim, labs

d = pandas.read_csv('input/data-gp.csv')
N = len(d)
Np = 61
Xp = np.linspace(0, 1, num=Np)

fit = cmdstanpy.from_csv('output/result-model12-7d')
yp_ms = fit.stan_variable('yp')
qua = np.quantile(yp_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([Xp, qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot(d_est)
    + theme_bw(base_size=18)
    + geom_line(aes(x='X', y='50%'), size=0.5)
    + geom_line(aes(x='X', y='2.5%'), size=0.4, alpha=0.5)
    + geom_line(aes(x='X', y='97.5%'), size=0.4, alpha=0.5)
    + geom_line(aes(x='X', y='25%'), size=0.4, alpha=0.6, linetype='dashed')
    + geom_line(aes(x='X', y='75%'), size=0.4, alpha=0.6, linetype='dashed')
    + geom_point(d, aes(x='X', y='Y'), size=2, alpha=0.6)
    + ylim(-3, 3)
    + labs(x='X', y='Y')
) 
p.save(filename='output/fig12-14.py.png', dpi=300, width=4, height=3)
