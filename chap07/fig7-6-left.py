import pandas
from plotnine import ggplot, aes, theme_bw, geom_point, labs, ylim

d = pandas.read_csv('input/data-sigEmax.csv')

p = (ggplot(d, aes('X', 'Y'))
    + theme_bw(base_size=18)
    + geom_point(size=2)
    + labs(x='X', y='Y')
    + ylim(2, 33)
)
p.save(filename='output/fig7-6-left.py.png', dpi=300, width=4, height=3)
