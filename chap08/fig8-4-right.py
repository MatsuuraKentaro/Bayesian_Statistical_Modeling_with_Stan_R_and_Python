import pandas
import numpy as np
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, facet_wrap, geom_line, geom_point, scale_shape_manual, scale_size_manual, scale_linetype_manual, scale_alpha_manual, labs

C = 4
d = pandas.read_csv('input/data-salary-2.csv')

fit1 = cmdstanpy.from_csv('output/result-model8-1')
fit2 = cmdstanpy.from_csv('output/result-model8-2')
fit3 = cmdstanpy.from_csv('output/result-model8-3')
d_ms1 = fit1.draws_pd()
a_ms2 = fit2.stan_variable(var='a')
b_ms2 = fit2.stan_variable(var='b')
a_ms3 = fit3.stan_variable(var='a')
b_ms3 = fit3.stan_variable(var='b')

N_ms = len(d_ms1)
Xp = np.arange(np.min(d.X), np.max(d.X)+1)
Np = len(Xp)

yp_base_mcmc1 = np.zeros(shape=(N_ms, Np))
for n in range(Np):
    yp_base_mcmc1[:,n] = d_ms1.a + d_ms1.b * Xp[n]

yp_base_med1 = np.median(yp_base_mcmc1, axis=0)
d1 = pandas.DataFrame({'X':np.tile(Xp, C), 'Y':np.tile(yp_base_med1, C), \
                       'CID':np.repeat(np.arange(1,C+1), Np), 'Model':['8-1']*C*Np})

d2 = pandas.DataFrame()
d3 = pandas.DataFrame()
for c in range(1,C+1):
    d_tmp = d[d.CID == c]
    Xp = np.arange(np.min(d_tmp.X), np.max(d_tmp.X)+1)
    Np = len(Xp)
    yp_base_mcmc2 = np.zeros(shape=(N_ms, Np))
    yp_base_mcmc3 = np.zeros(shape=(N_ms, Np))
    for n in range(Np):
        yp_base_mcmc2[:,n] = a_ms2[:,c-1] + b_ms2[:,c-1] * Xp[n]
        yp_base_mcmc3[:,n] = a_ms3[:,c-1] + b_ms3[:,c-1] * Xp[n]
    d2_each = pandas.DataFrame({'X':Xp, 'Y':np.median(yp_base_mcmc2, axis=0), 'CID':np.repeat(c, Np), 'Model':['8-2']*Np})
    d2 = pandas.concat([d2, d2_each])
    d3_each = pandas.DataFrame({'X':Xp, 'Y':np.median(yp_base_mcmc3, axis=0), 'CID':np.repeat(c, Np), 'Model':['8-3']*Np})
    d3 = pandas.concat([d3, d3_each])

p = (ggplot(d, aes('X', 'Y', shape='factor(CID)'))
    + theme_bw(base_size=20)
    + facet_wrap('CID')
    + geom_line(d1, aes(alpha='Model', linetype='Model', size='Model'))
    + geom_line(d2, aes(alpha='Model', linetype='Model', size='Model'))
    + geom_line(d3, aes(alpha='Model', linetype='Model', size='Model'))
    + geom_point(size=3, alpha=0.3)
    + scale_shape_manual(values=['o', '^', 'x', 'D'])
    + scale_size_manual(values=[2, 1, 1])
    + scale_linetype_manual(values=['solid', 'dashed', 'solid'])
    + scale_alpha_manual(values=[0.2, 0.6, 1])
    + labs(x='X', y='Y', shape='CID')
)
p.save(filename='output/fig8-4-right.py.png', dpi=300, width=6.3, height=5)
