import pandas
from plotnine import ggplot, aes, theme_bw, geom_line, labs

d = pandas.read_csv('input/data-season.csv')
p = (ggplot()
    + theme_bw(base_size=18)
    + geom_line(d, aes('X', 'Y'), size=0.3)
    + labs(x='Time (Quarter)', y='Y')
)
p.save(filename='output/fig11-6.py.png', dpi=300, width=3.5, height=3)
