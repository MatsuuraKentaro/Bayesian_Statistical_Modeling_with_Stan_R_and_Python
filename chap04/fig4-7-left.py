import cmdstanpy
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

np.random.seed(123)

fit = cmdstanpy.from_csv('output/result-model4-4')
d_ms = fit.draws_pd()
N_ms = len(d_ms)

fig = plt.figure()
ax = fig.add_subplot(projection='3d')
ax.scatter(d_ms.a, d_ms.b, d_ms.sigma, marker='o', s=20, \
           c=np.random.rand(N_ms,3), edgecolors='black')
ax.scatter(d_ms.a, d_ms.b, np.full(N_ms, 0.8), marker='o', s=20, \
           c='white', edgecolors='black')
ax.view_init(elev=20, azim=-60)
ax.set_zlim(0.8, 6.2)
ax.set_xlabel('a')
ax.set_ylabel('b')
ax.set_zlabel(r'$\sigma$')
fig.savefig('output/fig4-7-left.py.png', dpi=200)
