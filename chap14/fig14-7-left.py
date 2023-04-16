import pandas
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, geom_point, scale_shape_manual

d = pandas.read_csv('input/data-oil.csv')
N = len(d)
K = 2

fit_MAP = cmdstanpy.from_csv('output/result-model14-5')
x_est = fit_MAP.stan_variable('x')

d_plot = pandas.DataFrame(x_est, columns=['X1', 'X2'])
d_plot['Class'] = pandas.Categorical(d.Class, categories=[1,2,3])

p = (ggplot(d_plot, aes('X1', 'X2', shape='Class'))
    + theme_bw(base_size=18)
    + geom_point(size=2.5, alpha=0.7)
    + scale_shape_manual(values=['.', 'x', '^'])
)
p.save(filename='output/fig14-7-left.py.png', dpi=300, width=6, height=5)
