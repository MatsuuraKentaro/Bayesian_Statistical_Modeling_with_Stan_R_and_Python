import pandas
from plotnine import ggplot, aes, theme_bw, geom_point, ylim

d = pandas.read_csv('input/data-gp.csv')

p = (ggplot(d, aes('X', 'Y'))
    + theme_bw(base_size=18)
    + geom_point(size=2, alpha=0.8)
    + ylim(-3, 3)
)
p.save(filename='output/fig12-11.py.png', dpi=300, width=4, height=3)
