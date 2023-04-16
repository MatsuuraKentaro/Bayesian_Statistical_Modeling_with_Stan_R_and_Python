import pandas
from datetime import datetime
import cmdstanpy
import numpy as np
from lifelines import KaplanMeierFitter
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, geom_step, geom_point, scale_y_continuous, labs, ylim

d = pandas.read_csv('input/data-surv.csv')
N = len(d)
d1 = datetime(2018,12,31)
d2 = datetime(2014,1,1)

def diff_month(d1, d2):
    return (d1.year - d2.year) * 12 + d1.month - d2.month

T = diff_month(d1, d2) + 1

fit = cmdstanpy.from_csv('output/result-model14-2')
F_ms = np.exp(fit.stan_variable('log_F'))
qua = np.quantile(F_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1, T+1), qua.T]), \
    columns=['time', '2.5%', '25%', '50%', '75%', '97.5%'])
d_est = pandas.concat([d_est, pandas.DataFrame({'time':[0], '2.5%':[1], '25%':[1], '50%':[1], '75%':[1], '97.5%':[1]})]).reset_index()

kmf = KaplanMeierFitter()
kmf.fit(d.Time, event_observed=d.Cens-1)
d_obs = pandas.concat([kmf.survival_function_.reset_index(), kmf.event_table.reset_index()], axis=1)

p = (ggplot()
    + theme_bw(base_size=24)
    + geom_ribbon(d_est, aes('time', ymin='2.5%', ymax='97.5%'), alpha=1/4)
    + geom_line(d_est, aes('time', '50%'), linetype='dashed')
    + geom_step(d_obs, aes('timeline', 'KM_estimate'), color='black', size=0.8)
    # + geom_point(d_obs[d_obs.censored !=0].reset_index(), aes('timeline', 'KM_estimate'), color='black', shape='+', alpha=0.7, size=4)
    + scale_y_continuous(breaks=np.arange(0,1.2,0.2), labels=np.round(np.arange(0,1.2,0.2), 1), limits=[0,1])
    + labs(x='Time (months)', y='Survival')
)
p.save(filename='output/fig14-3-left.py.png', dpi=300, width=6, height=5)


h_ms = fit.stan_variable('h')
qua = np.quantile(h_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1, T+1), qua.T]), \
    columns=['time', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot()
    + theme_bw(base_size=24)
    + geom_ribbon(d_est, aes('time', ymin='2.5%', ymax='97.5%'), alpha=1/4)
    + geom_line(d_est, aes('time', '50%'), linetype='dashed')
    + ylim(0, 0.085)
    + labs(x='Time (months)', y='Hazard')
)
p.save(filename='output/fig14-3-right.py.png', dpi=300, width=6, height=5)
