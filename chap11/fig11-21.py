import pandas
import cmdstanpy
import numpy as np
from plotnine import ggplot, aes, theme_bw, facet_wrap, facet_grid, geom_line, geom_ribbon, labs

fit = cmdstanpy.from_csv('output/result-model11-13')
d_ms = fit.draws_pd().filter(regex='^(trend|calendar|weather|event|ar)\\[\d+\\]$')
qua = np.quantile(d_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(qua.T, columns=['2.5%', '25%', '50%', '75%', '97.5%'])
d_est['Parameter'] = d_ms.columns.str.extract('([a-z]+)')
d_est['Parameter'] = pandas.Categorical(d_est.Parameter, categories=['trend', 'calendar', 'weather', 'event', 'ar'])
d_est['X'] = d_ms.columns.str.extract('(\d+)').astype('int')

p = (ggplot()
    + theme_bw(base_size=18)
    + facet_grid('Parameter ~ .', scales='free_y')
    + geom_ribbon(d_est, aes('X', ymin='2.5%', ymax='97.5%'), alpha=1/6)
    + geom_ribbon(d_est, aes('X', ymin='25%',  ymax='75%'),   alpha=2/6)
    + geom_line(d_est, aes('X', '50%'))
    + labs(x='Time (Day)', y='')
)
p.save(filename='output/fig11-21.py.png', dpi=300, width=8, height=6)
