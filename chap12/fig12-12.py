import pandas
import itertools
import numpy as np
from plotnine import ggplot, aes, theme_bw, theme, element_text, facet_grid, geom_line

np.random.seed(123)

N = 101
X = np.linspace(0, 1, num=N)
S = 5

a_s = [2, 0.5]
rho_s = [0.05, 0.2]
d_plot = pandas.DataFrame(index=[], columns=['a', 'rho', 'X', 'Sample', 'Y'])
for a, rho in itertools.product(a_s, rho_s):    
    K = np.zeros((N, N))
    for i in range(N):
        for j in range(N):
            K[i,j] = np.square(a) * np.exp(-0.5/np.square(rho)*np.square(X[i]-X[j]))
    ys = np.random.multivariate_normal(np.repeat(0,N), K, S)
    d_ = pandas.DataFrame(np.column_stack([np.repeat(a, N), np.repeat(rho, N), X, ys.T]), \
        columns=['a', 'rho', 'X', *list(range(S))])
    d_ = pandas.melt(d_, id_vars=['a', 'rho', 'X'], var_name='Sample', value_name='Y')
    d_['Sample'] = pandas.Categorical(d_.Sample, categories=list(range(S)))
    d_plot = pandas.concat([d_plot, d_])

p = (ggplot(d_plot, aes('X', 'Y', group='Sample'))
    + theme_bw(base_size=18)
    + theme(axis_text_x=element_text(angle=40, vjust=1, hjust=1))
    + facet_grid('rho ~ a')
    + geom_line(alpha=0.8)
)
p.save(filename='output/fig12-12.py.png', dpi=300, width=6, height=5)
