import numpy as np
import pandas

np.random.seed(123)

G = 30
mu_pf = [0, 1.5]
pf = np.zeros(shape=[G, 2])
for i, mu in enumerate(mu_pf):
    pf[:,i] = np.random.normal(loc=mu, scale=1, size=G)

d = pandas.DataFrame(np.argsort(pf, axis=1), columns=['Loser', 'Winner'])
tbl = d.Winner.value_counts()
