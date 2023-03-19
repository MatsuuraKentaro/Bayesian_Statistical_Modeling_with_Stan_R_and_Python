import pandas
import cmdstanpy
import numpy as np
from plotnine import *

np.random.seed(123)

d = pandas.read_csv('input/data-shopping-3.csv')
fit = cmdstanpy.from_csv('output/result-model5-5')
q_ms = fit.stan_variable(var='q')
qua = np.quantile(q_ms, [0.1, 0.50, 0.9], axis=0)
d_qua = pandas.DataFrame(qua.T, columns=['10%', '50%', '90%'])
d_comp = pandas.concat([d, d_qua], axis=1)

p = (ggplot(d_comp, aes(x='factor(Y)', y='50%'))
    + theme_bw(base_size=18)
    + geom_boxplot(outlier_alpha=0)
    + geom_point(aes(fill='factor(Sex)', shape='factor(Sex)'), position=position_jitter(width=0.2, height=0), size=1.5)
    + scale_shape_manual(values=['o', '^'])
    + labs(x='Y', y='q', fill='Sex', shape='Sex')
)
p.save(filename='output/fig5-7-left.py.png', dpi=300, width=5, height=4)
