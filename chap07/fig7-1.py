import pandas
from plotnine import ggplot, aes, theme_bw, geom_point, scale_x_continuous, scale_x_log10, scale_y_log10

d = pandas.read_csv('input/data-rental.csv')

p = (ggplot(d, aes('Area', 'Y'))
    + theme_bw(base_size=18)
    + geom_point(shape='o', size=2)
    + scale_x_continuous(breaks=range(20, 140, 20))
)
p.save(filename='output/fig7-1-left.py.png', dpi=300, width=4, height=3)

p = (ggplot(d, aes('Area', 'Y'))
    + theme_bw(base_size=18)
    + geom_point(shape='o', size=2)
    + scale_x_log10(breaks=[1,2,5,10,20,50,100], limits=[9, 120])
    + scale_y_log10(breaks=[10,20,50,100,200,500,1000,2000])
)
p.save(filename='output/fig7-1-right.py.png', dpi=300, width=4, height=3)
