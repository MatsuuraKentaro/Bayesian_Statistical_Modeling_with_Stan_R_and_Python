import cmdstanpy
import numpy as np
import pandas
from scipy.optimize import minimize
from plotnine import ggplot, aes, theme_bw, geom_density, geom_vline, labs

fit = cmdstanpy.from_csv('../chap11/exercise/result-ex2')
y = fit.draws_pd()['yp[1]'].to_numpy()

def loss_function(a):
    return(np.where(a < y, 2*(y-a), 1 - np.exp(-(a-y))))

def expected_loss(a):
    return(np.mean(loss_function(a)))

a_best = minimize(expected_loss, np.median(y), method='L-BFGS-B', bounds=((5, 50),)).x

p = (ggplot(pandas.DataFrame({'x':y}), aes('x'))
    + theme_bw(base_size=18)
    + geom_density(alpha=0.5, color='black', fill='gray')
    + geom_vline(xintercept=a_best, color='black', linetype='dashed')
    + labs(x='value', y='density')
)
p.save(filename='output/fig13-2.py.png', dpi=300, width=4, height=3)
