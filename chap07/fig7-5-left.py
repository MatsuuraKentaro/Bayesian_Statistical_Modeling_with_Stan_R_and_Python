import pandas
from plotnine import ggplot, aes, theme_bw, geom_line, geom_point, labs, scale_x_continuous, ylim

d = pandas.read_csv('input/data-conc.csv')

p = (ggplot(d, aes('Time', 'Y'))
    + theme_bw(base_size=18)
    + geom_line(size=1)
    + geom_point(size=3)
    + labs(x='Time (hour)', y='Y')
    + scale_x_continuous(breaks=d.Time, limits=[0,24])
    + ylim(-2.5, 16)
)
p.save(filename='output/fig7-5-left.py.png', dpi=300, width=4, height=3)
