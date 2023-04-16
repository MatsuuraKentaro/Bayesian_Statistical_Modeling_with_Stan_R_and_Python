import pandas
from plotnine import ggplot, aes, theme_bw, theme, element_blank, geom_tile, scale_fill_gradient

N = 50
I = 120
d_ori = pandas.read_csv('input/data-matrix-decomp.csv')
d = d_ori.value_counts(sort=False).reset_index()
d.columns = ['PersonID', 'ItemID', 'Freq']
d = d[d.Freq >= 1].reset_index()

p = (ggplot(d, aes('ItemID', 'PersonID', fill='Freq'))
    + theme_bw(base_size=22)
    + theme(axis_text=element_blank(), axis_ticks=element_blank())
    + geom_tile()
    + scale_fill_gradient(breaks=[1,5,10], low='gray', high='black')
)
p.save(filename='output/fig14-4.py.png', dpi=300, width=8, height=6)
