import pandas
import numpy as np
import cmdstanpy
from plotnine import ggplot, theme_bw, theme, element_blank, aes, geom_bar, geom_point, geom_errorbar, scale_y_continuous, scale_x_continuous, scale_fill_manual, guides, guide_legend, geom_hline, labs, coord_flip

d = pandas.read_csv('input/data-ageheap.csv')
d_M = d[d.Sex == 'M'].reset_index(drop=True)
d_F = d[d.Sex == 'F'].reset_index(drop=True)

A = 76  # number of ages from 0 to 75+
Age_idx = list(range(0, 80, 5))
Flow = pandas.DataFrame(index=[], columns=['from', 'to'], dtype=np.int32)
for i in range(len(Age_idx)):
    d_ = pandas.DataFrame({'from': Age_idx[i] + np.array([-2,-1,1,2]), 'to': np.repeat(Age_idx[i], 4)})
    Flow = pandas.concat([Flow, d_])

Flow = Flow[(Flow['from'] > 0) & (Flow['from'] <= 75)].reset_index(drop=True)

def add_col_to_d(d, fit, reverse=False):
    d_out = d.copy()
    d_out['ratio'] = d.Y / sum(d.Y) * 100
    d_ms = fit.draws_pd().filter(regex='^q\[\d+\]$')
    qua = np.quantile(d_ms * 100, [0.025, 0.50, 0.975], axis=0)
    if reverse:
       qua = -qua
    d_out = pandas.concat([d_out, pandas.DataFrame(qua.T, columns=['2.5%', '50%', '97.5%'])], axis=1)
    return(d_out)

fit_M = cmdstanpy.from_csv('output/result-model12-4-M')
fit_F = cmdstanpy.from_csv('output/result-model12-4-F')
d_M = add_col_to_d(d_M, fit_M, reverse=True)
d_F = add_col_to_d(d_F, fit_F)

p = (ggplot()
    + theme_bw(base_size=18)
    + theme(panel_grid_minor_x=element_blank())
    + geom_bar(d_M, aes('Age', '-1*ratio'), stat='identity', width=0.6, alpha=0.3)
    + geom_bar(d_F, aes('Age', 'ratio'   ), stat='identity', width=0.6, alpha=0.3)
    + geom_point(d_M, aes('Age', '50%'), stat='identity')
    + geom_point(d_F, aes('Age', '50%'), stat='identity')
    + geom_errorbar(d_M, aes('Age', ymin='2.5%', ymax='97.5%'), width=0.6)
    + geom_errorbar(d_F, aes('Age', ymin='2.5%', ymax='97.5%'), width=0.6)
    + scale_x_continuous(breaks=np.arange(0,105,5), labels=np.arange(0,105,5))
    + scale_y_continuous(breaks=np.arange(-3,4),labels=np.abs(np.arange(-3,4)),limits=[-3,3])
    + guides(fill=guide_legend(reverse=True))
    + geom_hline(yintercept=0)
    + labs(x='Age', y='Composition Ratio (%)')
    + coord_flip()
)
p.save(filename='output/fig12-5-left.py.png', dpi=300, width=7.5, height=6)

def make_d_r(Flow, sex, fit, reverse=False):
    r_ms = fit.stan_variable('r')
    qua = np.quantile(r_ms, [0.025, 0.50, 0.975], axis=0)
    if reverse:
       qua = -qua
    d_out = pandas.DataFrame({'Sex':np.repeat(sex, len(Flow)), 'Age':Flow['from']})
    d_out = pandas.concat([d_out, pandas.DataFrame(qua.T, columns=['2.5%', '50%', '97.5%'])], axis=1)
    return(d_out)

d_r_M = make_d_r(Flow, 'M', fit_M, reverse=True)
d_r_F = make_d_r(Flow, 'F', fit_F)

p = (ggplot()
    + theme_bw(base_size=18)
    + theme(panel_grid_minor_x=element_blank())
    + geom_point(d_r_M, aes('Age', y='50%'))
    + geom_point(d_r_F, aes('Age', y='50%'))
    + geom_errorbar(d_r_M, aes('Age', ymin='2.5%', ymax='97.5%'), width=0.6)
    + geom_errorbar(d_r_F, aes('Age', ymin='2.5%', ymax='97.5%'), width=0.6)
    + geom_hline(aes(yintercept=0))
    + scale_x_continuous(breaks=np.arange(0,105,5), labels=np.arange(0,105,5))
    + scale_y_continuous(breaks=np.arange(-1,1.2,0.2), labels=np.round(np.abs(np.arange(-1,1.2,0.2)), 1))
    + labs(x='Age', y='r')
    + coord_flip()
)
p.save(filename='output/fig12-5-right.py.png', dpi=300, width=6, height=6)
