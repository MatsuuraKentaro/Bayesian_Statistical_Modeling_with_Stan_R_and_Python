import pandas
import numpy as np
from plotnine import ggplot, aes, theme_bw, geom_line, labs

a_x = np.linspace(-3, 3, num=601)
loss = np.where(a_x > 0, 1 - np.exp(-a_x), 2*(-a_x))
d = pandas.DataFrame({'x':a_x, 'y':loss})

p = (ggplot(d, aes('x','y'))
    + theme_bw(base_size=18)
    + geom_line(size=2)
    + labs(x='a - y', y='loss')
)
p.save(filename='output/fig13-1.py.png', dpi=300, width=4, height=3)
