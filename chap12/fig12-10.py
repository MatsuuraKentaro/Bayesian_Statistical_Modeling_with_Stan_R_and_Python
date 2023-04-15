import pandas
import cmdstanpy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from plotnine import ggplot, aes, theme_bw, coord_fixed, geom_pointrange, geom_abline, labs

T = 96
d = pandas.read_csv('input/data-2Dmesh.csv', header=None).to_numpy()
I, J = d.shape

fit = cmdstanpy.from_csv('output/result-model12-6')
f_ms = fit.stan_variable(var='f')
f_est = np.median(f_ms, axis=0)

fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
X, Y = np.meshgrid(np.arange(1,I+1), np.arange(1,J+1))
surf = ax.plot_surface(X, Y, f_est.T, cmap=cm.coolwarm, linewidth=0, antialiased=False)                       
ax.set_xlabel('Plate Row')
ax.set_ylabel('Plate Column')
ax.set_zlabel('f')
ax.view_init(40, -30)
fig.savefig('output/fig12-10-left.py.png', dpi=200)

ij2t = pandas.read_csv('input/data-2Dmesh-design.csv', header=None).to_numpy()

mean_Y = np.array([np.mean(d[ij2t == t]) - np.mean(d) for t in range(1, T+1)])
beta_ms = fit.stan_variable(var='beta')
qua = np.quantile(beta_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0)
d_est = pandas.DataFrame(np.column_stack([mean_Y, qua.T]), \
    columns=['mean_Y', '2.5%', '25%', '50%', '75%', '97.5%'])

p = (ggplot(d_est, aes(x='mean_Y', y='50%', ymin='2.5%', ymax='97.5%'))
    + theme_bw(base_size=18)
    + coord_fixed(ratio=1, xlim=[-5, 5], ylim=[-5, 5])
    + geom_pointrange(size=0.8, shape='o', fill='gray')
    + geom_abline(aes(slope=1, intercept=0), color='black', alpha=3/5, linetype='dashed')
    + labs(x='Mean of Y[ij2t]', y='beta[t]')
)
p.save(filename='output/fig12-10-right.py.png', dpi=300, width=5, height=5)
