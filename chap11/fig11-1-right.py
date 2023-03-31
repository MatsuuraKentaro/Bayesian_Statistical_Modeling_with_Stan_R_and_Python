import pandas
from plotnine import ggplot, aes, theme_bw, geom_line, geom_point, labs

d = pandas.read_csv('input/data-weight.csv')
p = (ggplot(d, aes('X', 'Y'))
    + theme_bw(base_size=18)
    + geom_line(size=1)
    + geom_point(shape='o', size=3)
    + labs(x='Time (Day)', y='Y')
)
p.save(filename='output/fig11-1-right.py.png', dpi=300, width=4, height=3)
