import numpy as np
import pandas
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, geom_density, geom_rug, coord_cartesian, labs

np.random.seed(123)
X = np.random.normal(0.7, 1.4, 20)
d = pandas.DataFrame({'x':X, 'y':np.full(20, 0), 'xend':X, 'yend':np.full(20,0.05)})

model = cmdstanpy.CmdStanModel(stan_file='model/for_fig5-2-left.stan')
fit = model.sample(data={'N':len(X), 'Y':X}, seed=123, iter_sampling=5000, iter_warmup=1000)
d_yp_ms = fit.draws_pd()
yp_ms = fit.stan_variable(var='yp')

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_density(d_yp_ms, aes('yp'), fill='gray', alpha=0.5)
    + geom_rug(d, aes('x'), sides='b')
    + coord_cartesian(xlim=[-4,4])
    + labs(x='Y', y='density')
) 
p.save(filename='output/fig5-2-left.py.png', dpi=300, width=3, height=3)
