import pandas
from plotnine import ggplot, aes, theme_bw, geom_point, scale_shape_manual, labs

d = pandas.read_csv('input/data-50m.csv')

p = (ggplot(d, aes('Weight', 'Y'))
    + theme_bw(base_size=18)
    + geom_point(shape='o', size=2)
)
p.save(filename='output/fig7-8-left.py.png', dpi=300, width=3.8, height=3)

p = (ggplot(d, aes('Weight', 'Y', shape='factor(Age)'))
    + theme_bw(base_size=18)
    + geom_point(size=2)
    + scale_shape_manual(values=['+', 'o', '^', 'x', 'D', 'v'])
    + labs(shape='Age')
)
p.save(filename='output/fig7-8-right.py.png', dpi=300, width=4.5, height=3)
