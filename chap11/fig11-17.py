import pandas
import cmdstanpy
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_line, geom_point, geom_ribbon, scale_x_continuous, labs

d_player = pandas.read_csv('input/data-eg3-players.csv')
d_conv = pandas.DataFrame(columns=['idx', 'PID', 'Player', 'Year'])
for i in range(len(d_player)):
    idxes = list(range(d_player.Start_Index[i], d_player.End_Index[i] + 1))
    d_ = pandas.DataFrame({
        'idx': idxes,
        'PID': np.repeat(d_player.PID[i], len(idxes)),
        'Player': np.repeat(d_player.Player[i], len(idxes)),
        'Year': list(range(d_player.Start_Year[i], d_player.End_Year[i] + 1))
    })
    d_conv = pandas.concat([d_conv, d_])

d_conv['Year'] = d_conv.Year.astype('int')

def q25(x):
    return x.quantile(0.25)

def q50(x):
    return x.quantile(0.5)

def q75(x):
    return x.quantile(0.75)

fit = cmdstanpy.from_csv('output/result-model11-12')
d_ms = fit.draws_pd().filter(regex='^mu\\[.*\\]')
d_ms['iteration'] = range(len(d_ms))
d_ms = pandas.melt(d_ms, id_vars='iteration', var_name='name', value_name='value')
d_ms['idx'] = d_ms.name.str.extract('(\d+)').astype('int')

d_qua = d_ms.groupby('idx').agg({'value': [q25, q50, q75]})
d_qua.columns = d_qua.columns.droplevel(0)
d_qua = d_qua.reset_index()
d_qua = pandas.merge(d_qua, d_conv, on='idx', how='left')
d_plot = d_qua[d_qua.PID.isin([100, 125, 182, 292])]

p = (ggplot(d_plot, aes('Year', 'q50', group='Player', linetype='Player', shape='Player'))
    + theme_bw(base_size=18)
    + geom_ribbon(aes(ymin='q25', ymax='q75'), fill='black', alpha=1/6)
    + geom_line(size=0.5)
    + geom_point(size=1.5)
    #+ scale_x_continuous(breaks=np.arange(2000, 2022, 5))
    + scale_x_continuous(breaks=range(2000, 2022, 5), labels=range(2000, 2022, 5))
    + labs(x='Time (Year)', y='Capability')
)
p.save(filename='output/fig11-17-left.py.png', dpi=300, width=4, height=4)


fit = cmdstanpy.from_csv('output/result-model11-12b')
d_ms = fit.draws_pd().filter(regex='^mu\\[.*\\]')
d_ms['iteration'] = range(len(d_ms))
d_ms = pandas.melt(d_ms, id_vars='iteration', var_name='name', value_name='value')
d_ms['idx'] = d_ms.name.str.extract('(\d+)').astype('int')

d_qua = d_ms.groupby('idx').agg({'value': [q25, q50, q75]})
d_qua.columns = d_qua.columns.droplevel(0)
d_qua = d_qua.reset_index()
d_qua = pandas.merge(d_qua, d_conv, on='idx', how='left')
d_plot = d_qua[d_qua.PID.isin([100, 125, 182, 292])]

p = (ggplot(d_plot, aes('Year', 'q50', group='Player', linetype='Player', shape='Player'))
    + theme_bw(base_size=18)
    + geom_ribbon(aes(ymin='q25', ymax='q75'), fill='black', alpha=1/6)
    + geom_line(size=0.5)
    + geom_point(size=1.5)
    #+ scale_x_continuous(breaks=np.arange(2000, 2022, 5))
    + scale_x_continuous(breaks=range(2000, 2022, 5), labels=range(2000, 2022, 5))
    + labs(x='Time (Year)', y='Capability')
)
p.save(filename='output/fig11-17-right.py.png', dpi=300, width=4, height=4)
