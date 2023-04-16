import pandas
from lifelines import KaplanMeierFitter
from plotnine import ggplot, aes, theme_bw, theme, element_text, geom_segment, geom_point, scale_x_datetime, scale_y_reverse, xlab, geom_histogram
from mizani.formatters import date_format
from matplotlib import pyplot as plt

d = pandas.read_csv('input/data-surv.csv', parse_dates=['Join', 'Leave'])
d_plot = d.iloc[0:15,:]

p = (ggplot()
    + theme_bw(base_size=16)
    + theme(axis_text_x=element_text(angle=40, vjust=1, hjust=1))
    + geom_segment(d_plot, aes('Join', 'PersonID', xend='Leave', yend='PersonID'), size=1)
    + geom_point(d_plot, aes('Join', 'PersonID'), size=2, shape='o')
    + geom_point(d_plot[d_plot.Cens == 0].reset_index(), aes('Leave', 'PersonID'), size=2, shape='o')
    + geom_point(d_plot[d_plot.Cens == 1].reset_index(), aes('Leave', 'PersonID'), size=3, shape='x')
    + scale_y_reverse()
    + scale_x_datetime(labels = date_format("%Y"))
    + xlab('Date')
)
p.save(filename='output/fig14-1-left.py.png', dpi=300, width=3, height=3)


p = (ggplot()
    + theme_bw(base_size=16)
    + geom_histogram(d, aes('Time'), binwidth=3, color='black', fill='white')
)
p.save(filename='output/fig14-1-middle.py.png', dpi=300, width=3, height=3)


fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)
kmf = KaplanMeierFitter()
kmf.fit(d.Time, event_observed=d.Cens-1)
ax = kmf.plot()
fig.savefig('output/fig14-1-right.py.png', dpi=200)
