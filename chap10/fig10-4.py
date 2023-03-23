import pandas
import seaborn as sns
import matplotlib.pyplot as plt
import math
from scipy import stats

d = pandas.read_csv('input/data-ZIB.csv')

def plot_lower(x, y, **kws):
    d_ = pandas.DataFrame({'x':x, 'y':y})
    if x.nunique() < 5:
        if y.nunique() < 5:
            d_agg = pandas.crosstab(x, y).stack().reset_index(name='total')
            d_agg = d_agg.set_axis(['x', 'y', 'total'], axis='columns', copy=False)
            plt.scatter(d_agg.x, d_agg.y, s=d_agg.total*5)
        else:
            sns.boxplot(data=d_, x='x', y='y')
            sns.swarmplot(data=d_, x='x', y='y', color='black', alpha=0.5)
    else:
        sns.scatterplot(data=d_, x='x', y='y')

def plot_diag(x, **kws):    
    d_ = pandas.DataFrame({'x':x, 'Sex':d.Sex})
    sns.histplot(data=d_, x='x', multiple='stack', kde=True)

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

g = sns.PairGrid(d)
g.map_lower(plot_lower)
g.map_diag(plot_diag)
g.map_upper(plot_upper)
g.savefig('output/fig10-4.py.png')
