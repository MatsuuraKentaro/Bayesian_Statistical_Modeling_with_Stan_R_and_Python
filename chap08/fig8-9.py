import pandas
import numpy as np
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, facet_wrap, geom_ribbon, geom_line, geom_point, labs, scale_x_continuous, scale_y_continuous

d_wide = pandas.read_csv('input/data-conc-2-NA-wide.csv')
N = len(d_wide)
X = np.array([1, 2, 4, 8, 12, 24])
Tp = 60
Xp = np.linspace(0, 24, num=Tp)
d_wide = d_wide.set_axis(['PersonID', *[str(x) for x in range(len(X))]], axis='columns')
d = pandas.melt(d_wide, id_vars='PersonID', var_name='TimeID', value_name='Y')
d.TimeID = d.TimeID.astype(int)
d.dropna(inplace=True)
d['Time'] = X[d.TimeID]
d = d[d.PersonID.isin([1, 2, 3, 16])]

fit = cmdstanpy.from_csv('output/result-model8-7')
yp_ms = fit.stan_variable(var='yp')
qua = np.quantile(yp_ms, [0.025, 0.50, 0.975], axis=[0])
qua = np.moveaxis(qua, 0, -1)
d_qua = pandas.DataFrame(qua.reshape([-1, 3]), columns=['2.5%', '50%', '97.5%'])
d_label = pandas.DataFrame({'PersonID':np.repeat(np.arange(1,N+1), Tp), 'TimeID':np.tile(np.arange(0,Tp), N)})
d_est = pandas.concat([d_label, d_qua], axis=1)
d_est['Time'] = Xp[d_est.TimeID]
d_est = d_est[d_est.PersonID.isin([1, 2, 3, 16])]

p = (ggplot(d_est, aes('Time', '50%'))
    + theme_bw(base_size=18)
    + facet_wrap('PersonID')
    + geom_ribbon(aes(ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/5)
    + geom_line(size=0.5)
    + geom_point(d, aes('Time', 'Y'), size=3)
    + labs(x='Time (hour)', y='Y')
    + scale_x_continuous(breaks=[0,6,12,24], limits=[0,24])
    + scale_y_continuous(breaks=range(0,50,10))
)
p.save(filename='output/fig8-9.py.png', dpi=300, width=8, height=7)
