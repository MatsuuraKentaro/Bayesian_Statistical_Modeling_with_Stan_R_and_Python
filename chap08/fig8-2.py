from plotnine import ggplot, aes, theme_bw, geom_point, geom_line, scale_shape_manual, facet_wrap, labs

exec(open('sim-model8-3.py').read())

p = (ggplot(d, aes('X', 'Y_sim', shape='factor(CID)'))
    + theme_bw(base_size=20)
    + facet_wrap('CID')
    + geom_line(stat='smooth', method='lm', se=False, size=1, color='black', linetype='dashed', alpha=0.8)
    + geom_point(size=3)
    + scale_shape_manual(values=['o', '^', 'x', 'D'])
    + labs(y='Y', shape='CID')
)
p.save(filename='output/fig8-2.py.png', dpi=300, width=6, height=5)
