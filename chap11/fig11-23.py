import pandas
import cmdstanpy
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_ribbon, geom_line, coord_flip, geom_violin, geom_pointrange, scale_x_discrete, labs

fit = cmdstanpy.from_csv('output/result-model11-13')
b_event_ms = fit.stan_variable(var='b_event')
qua = np.quantile(b_event_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1, qua.shape[1]+1), qua.T]), \
    columns=['X', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot(d_est, aes('X'))
    + theme_bw(base_size=18)
    + geom_ribbon(aes(ymin='2.5%', ymax='97.5%'), alpha=1/6)
    + geom_ribbon(aes(ymin='25%',  ymax='75%'),   alpha=2/6)
    + geom_line(aes(y='50%'), size=0.2)
    + labs(x='Time (Day)', y='b_event')
)
p.save(filename='output/fig11-23-left.py.png', dpi=300, width=4, height=3)


d_wday_ms = fit.draws_pd().filter(regex='^wday\\[\d+\\]$')
d_long = pandas.melt(d_wday_ms, var_name='Parameter')
qua = np.quantile(d_wday_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_qua = pandas.DataFrame(qua.T, columns=['2.5%', '25%', '50%', '75%', '97.5%'])
d_label = pandas.DataFrame({'Parameter':d_wday_ms.columns})
d_qua = pandas.concat([d_label, d_qua], axis=1)

p = (ggplot()
    + theme_bw(base_size=18)
    + coord_flip()
    + geom_violin(d_long, aes('Parameter', 'value'), fill='white', color='gray', size=2, alpha=0.3, scale='width')
    + geom_pointrange(d_qua, aes('Parameter', '50%', ymin='2.5%', ymax='97.5%'), size=1)
    + scale_x_discrete(limits=sorted(d_qua.Parameter, reverse=True))
)
p.save(filename='output/fig11-23-right.py.png', dpi=300, width=4, height=3)
