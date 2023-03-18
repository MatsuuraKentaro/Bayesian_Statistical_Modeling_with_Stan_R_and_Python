import pandas
import cmdstanpy
import numpy as np
from sklearn.metrics import roc_curve, auc
from plotnine import *

d = pandas.read_csv('input/data-shopping-3.csv')
fit = cmdstanpy.from_csv('output/result-model5-5')
q_ms = fit.stan_variable(var='q')
N_ms = len(q_ms)
xp = np.linspace(0, 1, 201)
probs = [0.1, 0.5, 0.9]

auces = np.empty(N_ms)
m_roc = np.empty((N_ms, len(xp)))
for i in range(N_ms):
    fpr, tpr, thresholds = roc_curve(d.Y, q_ms[i,:], drop_intermediate=False)
    auces[i] = auc(fpr, tpr)
    m_roc[i,:] = np.interp(xp, fpr, tpr)

# np.quantile(auces, probs)
qua = np.quantile(m_roc, probs, axis=0)
d_est = pandas.DataFrame(np.column_stack([xp, qua.T]), \
    columns=['X', '10%', '50%', '90%'])

p = (ggplot(d_est, aes(x='X', y='50%'))
    + theme_bw(base_size=18)
    + theme(legend_position='none')
    + coord_fixed(ratio=1, xlim=[0,1], ylim=[0,1])
    + geom_abline(intercept=0, slope=1, alpha=0.5)
    + geom_ribbon(aes(ymin='10%', ymax='90%'), fill='black', alpha=2/6)
    + geom_line(size=1)
    + labs(x='False Positive', y='True Positive')
)
p.save(filename='output/fig5-7-right.py.png', dpi=300, width=4, height=4)
