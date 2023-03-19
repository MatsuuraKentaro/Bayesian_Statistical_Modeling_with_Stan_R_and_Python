import pandas
import statsmodels.api as sm
from plotnine import ggplot, aes, theme_bw, geom_abline, geom_point, geom_line, scale_shape_manual, facet_wrap, labs

d = pandas.read_csv('input/data-salary-3.csv')
ols = sm.OLS(d.Y, sm.add_constant(d.X))
res_lm = ols.fit()
coef = res_lm.params

p = (ggplot(d, aes('X', 'Y', shape='factor(FID)'))
    + theme_bw(base_size=18)
    + geom_abline(intercept=coef[0], slope=coef[1], size=2, alpha=0.3)
    + geom_point(size=2)
    + scale_shape_manual(values=['o', '^', 'x', 'D'])
    + labs(shape='FID')
)
p.save(filename='output/fig8-5-left.py.png', dpi=300, width=4, height=3)

p = (ggplot(d, aes('X', 'Y', shape='factor(FID)'))
    + theme_bw(base_size=20)
    + geom_abline(intercept=coef[0], slope=coef[1], size=2, alpha=0.3)
    + facet_wrap('FID', ncol=2)
    + geom_line(stat='smooth', method='lm', se=False, size=1, color='black', linetype='dashed', alpha=0.8)
    + geom_point(size=3, alpha=0.8)
    + scale_shape_manual(values=['o', '^', 'x', 'D'])
    + labs(shape='FID')
)
p.save(filename='output/fig8-5-right.py.png', dpi=300, width=6, height=5)
