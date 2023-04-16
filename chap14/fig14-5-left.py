import pandas
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, theme, element_text, facet_wrap, coord_flip, scale_x_reverse, geom_bar, labs

d = pandas.read_csv('input/data-matrix-decomp.csv')
N = 50
K = 6
I = 120

fit_MAP = cmdstanpy.from_csv('output/result-model14-3')
phi_est = pandas.DataFrame(fit_MAP.stan_variable('phi'), columns=range(1, I+1))
phi_est = pandas.concat([pandas.DataFrame({'Pattern':range(1, K+1)}), phi_est], axis=1)
d_plot = pandas.melt(phi_est, id_vars='Pattern', var_name='ItemID')
d_plot['ItemID'] = d_plot.ItemID.astype('int32')

p = (ggplot(d_plot, aes('ItemID', 'value'))
    + theme_bw(base_size=18)
    + theme(axis_text_x=element_text(angle=65, vjust=1, hjust=1))
    + facet_wrap('~ Pattern', ncol=3)
    + coord_flip()
    + scale_x_reverse(breaks=[1, *range(20, 140, 20)])
    + geom_bar(stat='identity')
    + labs(y='$\phi[k,i]$')
)
p.save(filename='output/fig14-5-left.py.png', dpi=300, width=7, height=5)
