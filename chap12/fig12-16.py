import pandas
import cmdstanpy
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm

d = pandas.read_csv('input/data-2Dmesh.csv', header=None).to_numpy()
I, J = d.shape

fit_MAP = cmdstanpy.from_csv('output/result-model12-9')
f_est = fit_MAP.stan_variable(var='fp').reshape((I, J), order='F')

fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
X, Y = np.meshgrid(np.arange(1,I+1), np.arange(1,J+1))
surf = ax.plot_surface(X, Y, f_est.T, cmap=cm.coolwarm, linewidth=0, antialiased=False)                       
ax.set_xlabel('Plate Row')
ax.set_ylabel('Plate Column')
ax.set_zlabel('f')
ax.view_init(40, -30)
fig.savefig('output/fig12-16.py.png', dpi=200)
