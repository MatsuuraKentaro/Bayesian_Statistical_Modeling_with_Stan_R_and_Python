import pandas
from plotnine import ggplot, aes, theme_bw, geom_point

d = pandas.read_csv('input/data-salary.csv')
p = (ggplot(d, aes('X', 'Y'))
    + theme_bw(base_size=18)
    + geom_point(shape='o', size=3))
p.save(filename='output/fig4-1.py.png', dpi=300, width=4, height=3)
