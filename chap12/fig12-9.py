import pandas
import numpy as np
from plotnine import ggplot, aes, theme_bw, theme, element_blank, geom_tile, scale_fill_gradient2, scale_y_reverse, xlab, ylab, coord_cartesian

d = pandas.read_csv('input/data-2Dmesh.csv', header=None)
d['i'] = np.arange(1, 17)
d_plot = pandas.melt(d, id_vars='i', var_name='j', value_name='Y')
d_plot['j'] = d_plot.j.astype('int32') + 1

p = (ggplot(d_plot, aes(x='j', y='i', z='Y', fill='Y'))
    + theme_bw(base_size=20)
    + theme(panel_background=element_blank())
    + geom_tile(color='black')
    + scale_fill_gradient2(midpoint=np.median(d_plot.Y), low='black', mid='gray', high='white')
    + scale_y_reverse(limits=[16.5, 0.5], breaks=[5,10,15])
    + xlab('Plate Column') + ylab('Plate Row')
    + coord_cartesian(xlim=[0.5, 24.5], expand=False)
)
p.save(filename='output/fig12-9.py.png', dpi=300, width=6.5, height=4)
