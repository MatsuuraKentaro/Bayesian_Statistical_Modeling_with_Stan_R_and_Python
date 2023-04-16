import pandas
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, geom_point, scale_shape_manual

d = pandas.read_csv('input/data-oil.csv')
N = len(d)
K = 2

fit_vb = cmdstanpy.from_csv('output/result-model14-6')
# x_est = np.median(fit_vb.stan_variable('x'), axis=0) # This will be fixed via https://github.com/stan-dev/cmdstanpy/pull/652
x_est = fit_vb.stan_variable('x')

d_plot = pandas.DataFrame({'X1': x_est[:,0], 'X2':x_est[:,1], 'Class':pandas.Categorical(d.Class, categories=[1,2,3])})

p = (ggplot(d_plot, aes('X1', 'X2', shape='Class'))
    + theme_bw(base_size=18)
    + geom_point(size=2.5, alpha=0.7)
    + scale_shape_manual(values=['.', 'x', '^'])
)
p.save(filename='output/fig14-7-right.py.png', dpi=300, width=6, height=5)
