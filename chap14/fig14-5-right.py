import pandas
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, facet_wrap, coord_flip, scale_x_reverse, geom_bar, labs

d = pandas.read_csv('input/data-matrix-decomp.csv')
N = 50
K = 6
I = 120

fit_MAP = cmdstanpy.from_csv('output/result-model14-3')
theta_est = pandas.DataFrame(fit_MAP.stan_variable('theta'), columns=range(1, K+1))
theta_est = pandas.concat([pandas.DataFrame({'PersonID':range(1, N+1)}), theta_est], axis=1)
d_plot = pandas.melt(theta_est, id_vars='PersonID', var_name='Pattern')
d_plot['Pattern'] = d_plot.Pattern.astype('int32')

p = (ggplot(d_plot.query('PersonID in [1,50]').reset_index(), aes('Pattern', 'value'))
    + theme_bw(base_size=18)
    + facet_wrap('~ PersonID', nrow=2)
    + coord_flip()
    + scale_x_reverse(breaks=range(1,K+1))
    + geom_bar(stat='identity')
    + labs(y='$\theta[n,k]$')
)
p.save(filename='output/fig14-5-right.py.png', dpi=300, width=5, height=5)
