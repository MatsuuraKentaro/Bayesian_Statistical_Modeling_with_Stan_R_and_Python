import pandas
from plotnine import ggplot, aes, theme_bw, geom_point, labs, coord_cartesian

d = pandas.read_csv('input/data-outlier.csv')

p = (ggplot(d, aes('X', 'Y'))
    + theme_bw(base_size=18)
    + geom_point(shape='o', size=3)
    + labs(x='X', y='Y')
    + coord_cartesian(xlim=[-0.2, 11.2], ylim=[-25, 75])
)
p.save(filename='output/fig7-10.py.png', dpi=300, width=4, height=3)
