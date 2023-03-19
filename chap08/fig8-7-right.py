import pandas
from plotnine import ggplot, aes, theme_bw, geom_histogram, geom_density, geom_rug, labs, xlim

d = pandas.read_csv('input/data-conc-2.csv')

bw = 3.0
p = (ggplot(d, aes('Time24'))
    + theme_bw(base_size=18)
    + geom_histogram(aes(y='..density..'), binwidth=bw, color='black', fill='white')
    + geom_density(fill='gray', alpha=0.4)
    + geom_rug(sides='b')
    + labs(x='Time24', y='count')
    + xlim([-5, 45])
)
p.save(filename='output/fig8-7-right.py.png', dpi=300, width=4, height=4)
