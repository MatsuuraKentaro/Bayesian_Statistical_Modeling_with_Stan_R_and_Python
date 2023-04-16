import numpy as np
import pandas

np.random.seed(123)

N = 50
I = 120
K = 6
alpha0 = np.repeat(0.8, K)
alpha1 = np.repeat(0.2, I)
theta = np.random.dirichlet(alpha0, N)
phi = np.random.dirichlet(alpha1, K)

num_items_by_n = np.rint(np.exp(np.random.normal(2.0, 0.5, N))).astype('int32')

d = pandas.DataFrame(index=[], columns=['PersonID', 'ItemID'])
for n in range(N):    
    z = np.random.choice(list(range(K)), num_items_by_n[n], p=theta[n,:])
    item = np.ravel([np.random.choice(list(range(I)), 1, p=phi[k,:]) for k in z])
    d = pandas.concat([d, pandas.DataFrame({'PersonID':np.repeat(n, len(item)), 'ItemID':item})])
