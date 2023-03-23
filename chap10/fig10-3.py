import pandas
from scipy import stats
from plotnine import ggplot, aes, theme_bw, geom_histogram, geom_density, geom_rug, labs, xlim

d = pandas.read_csv('input/data-mix2.csv')
dens = stats.gaussian_kde(d.Y)

bw = 1
p = (ggplot(d, aes('Y'))
    + theme_bw(base_size=18)
    + geom_histogram(binwidth=bw, color='black', fill='white')
    + geom_density(aes(y='..count..'), alpha=0.35, color='gray', fill='gray')
    + geom_rug(sides='b')
    + labs(x='Y')
    + xlim(5, 40)
)
p.save(filename='output/fig10-3.py.png', dpi=300, width=4, height=3)
