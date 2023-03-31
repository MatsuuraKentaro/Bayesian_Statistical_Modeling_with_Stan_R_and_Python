import pandas
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_line, labs

d = pandas.read_csv('input/data-eg4.csv')
d.loc[d.Month == 8, 'Y'] = np.nan
d['Time'] = range(1, len(d)+1)

p = (ggplot(d, aes('Time', 'Y'))
    + theme_bw(base_size=18)
    + geom_line(size=0.3)
    + labs(x='Time (Day)', y='Y')
)
p.save(filename='output/fig11-18.py.png', dpi=300, width=4, height=3)
