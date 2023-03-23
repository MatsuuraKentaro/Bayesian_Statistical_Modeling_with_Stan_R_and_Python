import pandas
from scipy import stats
from plotnine import ggplot, aes, theme_bw, geom_histogram, geom_density, geom_rug, scale_y_continuous, labs, xlim

d = pandas.read_csv('input/data-mix1.csv')
dens = stats.gaussian_kde(d.Y)

bw = 0.5
p = (ggplot(d, aes('Y'))
    + theme_bw(base_size=18)
    + geom_histogram(binwidth=bw, color='black', fill='white')
    + geom_density(aes(y='..count..*(0.5)'), alpha=0.35, color='gray', fill='gray')
    + geom_rug(sides='b')
    + scale_y_continuous(breaks=range(0, 12, 2))
    + labs(x='Y', y='count * 0.5')
    + xlim(-7, 14)
)
p.save(filename='output/fig10-2.py.png', dpi=300, width=4, height=3)
