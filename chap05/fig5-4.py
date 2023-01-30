import cmdstanpy
import seaborn as sns
import matplotlib.pyplot as plt
import math
from scipy import stats

fit = cmdstanpy.from_csv('output/result-model5-3')
d = fit.draws_pd().filter(items=['b[1]', 'b[2]', 'b[3]', 'sigma', 'mu[1]', 'mu[50]', 'lp__'])

def plot_upper(x, y, **kws):
    from matplotlib.patches import Ellipse
    r, _ = stats.spearmanr(x, y)
    ax = plt.gca()
    ax.axis('off')
    ellcolor = plt.cm.RdBu(0.5*(r+1))
    txtcolor = 'black' if math.fabs(r) < 0.5 else 'white'
    ax.add_artist(Ellipse(xy=[.5, .5], width=math.sqrt(1+r), height=math.sqrt(1-r), angle=45,
        facecolor=ellcolor, edgecolor='none', transform=ax.transAxes))
    ax.text(.5, .5, '{:.0f}'.format(r*100), color=txtcolor, fontsize=28,
        horizontalalignment='center', verticalalignment='center', transform=ax.transAxes)

sns.set(font_scale=2)
g = sns.PairGrid(d)
g.map_lower(sns.kdeplot, cmap='Blues_d')
g.map_diag(sns.histplot)
g.map_upper(plot_upper)
g.savefig('output/fig5-4.py.png')
