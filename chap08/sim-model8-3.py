import numpy as np
import pandas as pd

np.random.seed(123)
N = 40
C = 4
N_c = np.array([15, 12, 10, 3])
a_field = 350
b_field = 12
s_a = 60
s_b = 4
s_y = 25
X = np.random.randint(low=0, high=36, size=N)
n2c = np.repeat(np.arange(1,5), N_c)

a = np.random.normal(loc=0, scale=s_a, size=C) + a_field
b = np.random.normal(loc=0, scale=s_b, size=C) + b_field
d = pd.DataFrame(data={'X':X, 'CID':n2c, 'a':a[n2c-1], 'b':b[n2c-1]})
d['Y_sim'] = np.random.normal(loc=d.a + d.b*X, scale=s_y, size=N)
