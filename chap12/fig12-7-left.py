import pandas
import numpy as np
from japanmap import picture
import matplotlib.pyplot as plt

d = pandas.read_csv('input/data-map-temperature.csv')
d = pandas.concat([pandas.DataFrame({'prefID':[0], 'Y':[np.mean(d.Y)]}), d]).reset_index(drop=True)
cmap = plt.get_cmap('gray_r')
norm = plt.Normalize(vmin=d.Y.min(), vmax=d.Y.max())
fcol = lambda x: '#' + bytes(cmap(norm(x), bytes=True)[:3]).hex()
plt.colorbar(plt.cm.ScalarMappable(norm, cmap))
plt.imshow(picture(d.Y.apply(fcol)));
plt.savefig('output/fig12-7-left.py.png')
