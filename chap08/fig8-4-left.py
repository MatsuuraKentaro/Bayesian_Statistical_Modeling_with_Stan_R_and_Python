import pandas
import numpy as np
import cmdstanpy
from plotnine import ggplot, aes, theme_bw, geom_pointrange, geom_hline, scale_shape_manual, scale_fill_manual, scale_x_continuous, labs

fit1 = cmdstanpy.from_csv('output/result-model8-1')
fit2 = cmdstanpy.from_csv('output/result-model8-2')
fit3 = cmdstanpy.from_csv('output/result-model8-3')
a_ms1 = fit1.stan_variable(var='a')
a_ms2 = fit2.stan_variable(var='a')
a_ms3 = fit3.stan_variable(var='a')

C = 4
qua = np.quantile(a_ms2, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_qua = pandas.DataFrame(qua.T, columns=['2.5%', '25%', '50%', '75%', '97.5%'])
d_label = pandas.DataFrame({'CID': np.arange(1,C+1) - 0.1, 'Model': np.full(C, '8-2')})
d_qua1 = pandas.concat([d_label, d_qua], axis=1)
qua = np.quantile(a_ms3, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_qua = pandas.DataFrame(qua.T, columns=['2.5%', '25%', '50%', '75%', '97.5%'])
d_label = pandas.DataFrame({'CID': np.arange(1,C+1) + 0.1, 'Model': np.full(C, '8-3')})
d_qua2 = pandas.concat([d_label, d_qua], axis=1)
d_qua_all = pandas.concat([d_qua1, d_qua2])

p = (ggplot(d_qua_all, aes('CID', '50%', ymin='2.5%', ymax='97.5%', shape='Model', linetype='Model', fill='Model'))
    + theme_bw(base_size=18)
    + geom_pointrange(size=0.6)
    + geom_hline(yintercept=np.median(a_ms1), color='black', alpha=0.3, linetype='solid', size=1.2)
    + scale_shape_manual(values=['o', 's'])
    + scale_fill_manual(values=['white','black'])
    + scale_x_continuous(breaks=np.arange(1, C+1))
    + labs(y='a')
)
p.save(filename='output/fig8-4-left.py.png', dpi=300, width=4, height=3)
