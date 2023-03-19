import pandas
import numpy as np
import statsmodels.api as sm
from plotnine import ggplot, aes, theme_bw, facet_wrap, geom_histogram, geom_density, geom_rug, labs

d = pandas.read_csv('input/data-salary-3.csv')
N = len(d)
C = 30
F = 3
coefs = []
for c in range(1,C+1):
    d_tmp = d[d.CID == c]
    ols = sm.OLS(d_tmp.Y, sm.add_constant(d_tmp.X))
    res_lm = ols.fit()
    coef = list(res_lm.params)
    coefs.append(coef)
coefs = pandas.DataFrame(coefs, columns=['a', 'b'])

c2f = d.filter(items=['CID', 'FID']).drop_duplicates().reset_index(drop=True)
d_res = pandas.concat([coefs, c2f], axis=1)

bw = (np.max(d_res.a) - np.min(d_res.a))/20
p = (ggplot(d_res, aes('a'))
    + theme_bw(base_size=18)
    + facet_wrap('FID', nrow=3)
    + geom_histogram(aes(y='..density..'), binwidth=bw, color='black', fill='white')
    + geom_density(fill='gray', alpha=0.2)
    + geom_rug(sides='b')
    + labs(x='a', y='count')
)
p.save(filename='output/fig8-6-left.py.png', dpi=300, width=4, height=6)

bw = (np.max(d_res.b) - np.min(d_res.b))/20
p = (ggplot(d_res, aes('b'))
    + theme_bw(base_size=18)
    + facet_wrap('FID', nrow=3)
    + geom_histogram(aes(y='..density..'), binwidth=bw, color='black', fill='white')
    + geom_density(fill='gray', alpha=0.2)
    + geom_rug(sides='b')
    + labs(x='a', y='count')
)
p.save(filename='output/fig8-6-right.py.png', dpi=300, width=4, height=6)
