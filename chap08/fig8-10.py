import pandas
import numpy as np
import cmdstanpy
from scipy import stats
from plotnine import *

N = 50
fit = cmdstanpy.from_csv('output/result-model8-8')
d_ms = fit.draws_pd()
d_ms = d_ms.filter(regex='(b\\[|s_person)', axis='columns')
d_long = pandas.melt(d_ms, var_name='Parameter')

qua = np.quantile(d_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_qua = pandas.DataFrame(qua.T, columns=['2.5%', '25%', '50%', '75%', '97.5%'])
d_label = pandas.DataFrame({'Parameter':d_ms.columns})
d_qua = pandas.concat([d_label, d_qua], axis=1)

p = (ggplot()
    + theme_bw(base_size=18)
    + coord_flip()
    + geom_violin(d_long, aes('Parameter', 'value'), fill='white', color='gray', size=2, alpha=0.3, scale='width')
    + geom_pointrange(d_qua, aes('Parameter', '50%', ymin='2.5%', ymax='97.5%'), size=1)
    + scale_x_discrete(limits=sorted(d_qua.Parameter, reverse=True))
    + scale_y_continuous(breaks=range(-6, 8, 2))
)
p.save(filename='output/fig8-10-left.py.png', dpi=300, width=4, height=3)


b_person_ms = fit.stan_variable('b_person')
mode_list = []
for n in range(N):
    density = stats.gaussian_kde(b_person_ms[:,n])
    xs = np.linspace(-4, 4, 201)
    ys = density(xs)
    mode_i = np.argmax(ys)
    mode_x = xs[mode_i]
    mode_y = ys[mode_i]
    mode_list.append([mode_x, mode_y])

d_mode = pandas.DataFrame(mode_list, columns=['X', 'Y'])

s_dens = stats.gaussian_kde(fit.stan_variable(var='s_person'))
xs = np.linspace(1, 3, 201)
ys = s_dens(xs)
s_MAP = xs[np.argmax(ys)]
bw = 0.25

p = (ggplot(d_mode, aes(x='X'))
    + theme_bw(base_size=18)
    + geom_histogram(aes(y='..density..'), binwidth=bw, color='black', fill='white')
    + geom_density(fill='gray', alpha=0.5)
    + geom_rug(sides='b')
    + stat_function(fun=stats.norm.pdf, args=dict(loc=0, scale=s_MAP), linetype='dashed')
    + labs(x='value', y='density')
    + xlim(-4, 4)
) 
p.save(filename='output/fig8-10-right.py.png', dpi=300, width=4, height=3)
