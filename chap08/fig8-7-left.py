import pandas
from plotnine import ggplot, aes, theme_bw, facet_wrap, geom_line, geom_point, labs, scale_x_continuous, scale_y_continuous

d = pandas.read_csv('input/data-conc-2.csv')
N = len(d)
d = pandas.melt(d, id_vars='PersonID', var_name='Time', value_name='Y')
d['Time'] = d.Time.str.extract(r'(\d+)').astype(float)

p = (ggplot(d, aes('Time', 'Y'))
    + theme_bw(base_size=18)
    + facet_wrap('PersonID')
    + geom_line(size=1)
    + geom_point(size=3)
    + labs(x='Time (hour)', y='Y')
    + scale_x_continuous(breaks=[0,6,12,24], limits=[0,24])
    + scale_y_continuous(breaks=range(0,50,10), limits=[-3,40])
)
p.save(filename='output/fig8-7-left.py.png', dpi=300, width=8, height=7)
