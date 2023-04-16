import dill
from plotnine import ggplot, aes, theme_bw, facet_wrap, geom_ribbon, geom_line, geom_point, geom_vline, labs

dill.load_session('output/result-model13-3.pkl')
times_plot = [1,7,14,20]

d_dat = d_dat.query('time in @times_plot')
d_pre = d_pre.query('time in @times_plot')
d_est = d_est.query('time in @times_plot')
d_sel = d_sel.query('time in @times_plot')

p = (ggplot()
    + theme_bw(base_size=20)
    + facet_wrap('~ time')
    + geom_ribbon(d_est, aes('X', ymin='2.5%', ymax='97.5%'), alpha=0.4)
    + geom_line(d_est, aes('X', '50%'), color='black')
    + geom_point(d_pre, aes('X', 'Y'), size=3, color='black', shape='.')
    + geom_point(d_dat, aes('X', 'Y'), size=3, color='black', shape='o')
    + geom_vline(d_sel, aes(xintercept='X'), size=0.5, color='red', linetype='dashed', alpha=0.7)
    + geom_point(d_sel, aes('X'), y=5, size=3, color='red', shape='^')
    + labs(x='X', y='Y')
)
p.save(filename='output/fig13-3.py.png', dpi=300, width=8, height=6)
