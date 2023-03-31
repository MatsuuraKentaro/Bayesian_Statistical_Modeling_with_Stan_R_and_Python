import pandas
from scipy.stats import sem
from plotnine import ggplot, aes, theme_bw, geom_errorbar, position_dodge, geom_line, scale_x_continuous, scale_linetype_manual, labs

d = pandas.read_csv('input/data-eg1.csv')
d_plot = d.groupby(['Group', 'Time']).agg(mean=('Y', 'mean'), SE=('Y', 'sem')).reset_index()

p = (ggplot()
    + theme_bw(base_size=18)
    + geom_errorbar(d_plot, aes('Time', ymin='mean - SE', ymax='mean + SE', group='factor(Group)', linetype='factor(Group)'), width=0.2, position=position_dodge(0.3))
    + geom_line(d_plot, aes('Time', 'mean', group='factor(Group)', linetype='factor(Group)'), size=0.5)
    + scale_x_continuous(breaks=[0, 5, 10, 15, 20])
    + scale_linetype_manual(values=['solid', 'dashed'])
    + labs(x='Time (Hour)', y='Y', linetype='Group')
)
p.save(filename='output/fig11-12.py.png', dpi=300, width=5, height=3)
