import pandas
import numpy as np
from plotnine import ggplot, theme_bw, theme, element_blank, aes, geom_bar, scale_y_continuous, scale_x_continuous, scale_fill_manual, guides, guide_legend, geom_hline, ylab, coord_flip

d = pandas.read_csv('input/data-ageheap.csv')
d['Y'] = d.Y/1000000
d['Sex'] = pandas.Categorical(d.Sex, categories=['M', 'F'])

p = (ggplot()
    + theme_bw(base_size=18)
    + theme(panel_grid_minor_x=element_blank())
    + geom_bar(d[d.Sex=='M'], aes('Age', '-1*Y', fill='Sex'), stat='identity', width=0.6)
    + geom_bar(d[d.Sex=='F'], aes('Age', 'Y',    fill='Sex'), stat='identity', width=0.6)
    + scale_y_continuous(breaks=np.arange(-2.5,3.0,0.5), labels=abs(np.arange(-2.5,3.0,0.5)), limit=[-2.5,2.5])
    + scale_x_continuous(breaks=np.arange(0, 80, 5), labels=np.arange(0, 80, 5))
    + scale_fill_manual(values=['black', 'gray'])
    + guides(fill=guide_legend(reverse=True))
    + geom_hline(yintercept=0)
    + ylab('Y [M]')
    + coord_flip()
)
p.save(filename='output/fig12-3.py.png', dpi=300, width=8, height=6)
