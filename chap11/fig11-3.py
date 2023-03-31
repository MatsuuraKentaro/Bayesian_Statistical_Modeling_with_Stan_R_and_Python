import pandas
import matplotlib.pyplot as plt
import statsmodels.api as sm

plt.style.use('ggplot')

d = pandas.read_csv('input/data-weight.csv')
fig = plt.figure(figsize=(6, 4))
ax1 = fig.add_subplot(111)
sm.graphics.tsa.plot_acf(d.Y, lags=13, ax=ax1)
plt.savefig('output/fig11-3.py.png', dpi=300)
