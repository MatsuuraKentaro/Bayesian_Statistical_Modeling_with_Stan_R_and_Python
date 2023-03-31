import pandas
import cmdstanpy
import numpy as np
from plotnine import ggplot, aes, theme_bw, facet_wrap, geom_line, geom_point, geom_ribbon, labs

d_ori = pandas.read_csv('input/data-eg2.csv')
T = len(d_ori)
d = pandas.melt(d_ori, id_vars='Time', var_name='Item', value_name='Y')
d['Item'] = pandas.Categorical(d.Item, categories=['Weight', 'Bodyfat'])

d1 = d.query("(Item == 'Bodyfat' & Time <= 30) | (Item == 'Weight' & Time <= 20)")
d2 = d.query("(Item == 'Bodyfat' & Time >= 31 & Time <= 40) | (Item == 'Weight' & Time >= 31 & Time <= 40)")
d3 = d.query("(Item == 'Bodyfat' & Time >= 51) | (Item == 'Weight' & Time >= 51)")

d_weight_na1a = d.query("(Item == 'Weight' & 21 <= Time & Time <= 30)")
d_weight_na2a = d.query("(Item == 'Weight' & 20 <= Time & Time <= 31)")
d_weight_na1b = d.query("(Item == 'Weight' & 41 <= Time & Time <= 50)")
d_weight_na2b = d.query("(Item == 'Weight' & 40 <= Time & Time <= 51)")
d_bodyfat_na1 = d.query("(Item == 'Bodyfat' & 41 <= Time & Time <= 50)")
d_bodyfat_na2 = d.query("(Item == 'Bodyfat' & 40 <= Time & Time <= 51)")

fit = cmdstanpy.from_csv('output/result-model11-11')
mu1_ms = fit.draws_pd().filter(regex='^mu\\[.*,1\\]')
qua = np.quantile(mu1_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0) * 10
d_weight_est = pandas.DataFrame(np.column_stack([np.arange(1, T+1), qua.T]), \
    columns=['Time', '2.5%', '25%', '50%', '75%', '97.5%'])
d_weight_est['Item'] = pandas.Categorical(np.repeat('Weight', T), categories=['Weight', 'Bodyfat'])
mu2_ms = fit.draws_pd().filter(regex='^mu\\[.*,2\\]')
qua = np.quantile(mu2_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0) * 10
d_bodyfat_est = pandas.DataFrame(np.column_stack([np.arange(1, T+1), qua.T]), \
    columns=['Time', '2.5%', '25%', '50%', '75%', '97.5%'])
d_bodyfat_est['Item'] = pandas.Categorical(np.repeat('Bodyfat', T), categories=['Weight', 'Bodyfat'])

p = (ggplot()
    + theme_bw(base_size=18)
    + facet_wrap('~Item', ncol=1, scales='free_y')
    + geom_ribbon(d_weight_est, aes('Time', ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/6)
    + geom_ribbon(d_weight_est, aes('Time', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_weight_est, aes('Time', y='50%'), size=1)
    + geom_ribbon(d_bodyfat_est, aes('Time', ymin='2.5%', ymax='97.5%'), fill='black', alpha=1/6)
    + geom_ribbon(d_bodyfat_est, aes('Time', ymin='25%', ymax='75%'), fill='black', alpha=2/6)
    + geom_line(d_bodyfat_est, aes('Time', y='50%'), size=1)
    + geom_line(d1, aes('Time', 'Y'), alpha=0.7)
    + geom_point(d1, aes('Time', 'Y'), shape='o', size=2, alpha=0.3)
    + geom_line(d2, aes('Time', 'Y'), alpha=0.7)
    + geom_point(d2, aes('Time', 'Y'), shape='o', size=2, alpha=0.3)
    + geom_line(d3, aes('Time', 'Y'), alpha=0.7)
    + geom_point(d3, aes('Time', 'Y'), shape='o', size=2, alpha=0.3)
    + geom_line(d_weight_na2a, aes('Time', 'Y'), linetype='dashed', alpha=0.5)
    + geom_point(d_weight_na1a, aes('Time', 'Y'), shape='o', color='gray', size=2, alpha=0.5)
    + geom_line(d_weight_na2b, aes('Time', 'Y'), linetype='dashed', alpha=0.5)
    + geom_point(d_weight_na1b, aes('Time', 'Y'), shape='o', color='gray', size=2, alpha=0.5)
    + geom_line(d_bodyfat_na2, aes('Time', 'Y'), linetype='dashed', alpha=0.5)
    + geom_point(d_bodyfat_na1, aes('Time', 'Y'), shape='o', color='gray', size=2, alpha=0.5)
    + labs(x='Time (Day)', y='Y')
)
p.save(filename='output/fig11-15.py.png', dpi=300, width=6, height=5)
