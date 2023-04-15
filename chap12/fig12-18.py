import cmdstanpy
import pandas
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_line, geom_point, labs

d = pandas.read_csv('input/data-gp-sparse.csv')
N = len(d)
Np = 61
Xp = np.linspace(0, 1, num=Np)

fit = cmdstanpy.from_csv('output/result-model12-10')
fp = fit.stan_variable('fp')

d_est = pandas.DataFrame({'X':Xp, 'Y':fp})
p = (ggplot(d_est)
    + theme_bw(base_size=18)
    + geom_line(aes('X', 'Y'), size=0.5)
    + geom_point(d, aes('X', 'Y'), color='black', shape='.', size=0.2, alpha=0.2)
    + labs(x='X', y='Y')
)
p.save(filename='output/fig12-18.py.png', dpi=300, width=4, height=3)
