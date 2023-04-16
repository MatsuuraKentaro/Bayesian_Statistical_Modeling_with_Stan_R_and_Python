import pandas
import cmdstanpy
import numpy as np
from sklearn.preprocessing import StandardScaler
from scipy.spatial.distance import squareform, pdist
from scipy import optimize

d = pandas.read_csv('input/data-oil.csv')
D = 12
std_scaler = StandardScaler()
Y = std_scaler.fit_transform(d.iloc[:,:-1])
N = len(d)
K = 2
M = 30
dist = squareform(pdist(Y))
var_vec = np.zeros(N)
for n in range(N):
    var_vec[n] = np.sort(dist[n,])[M-1] / (3*3)

Prec = 1/var_vec
data = {'N':N, 'D':D, 'K':K, 'Y':Y, 'Prec':Prec}

model = cmdstanpy.CmdStanModel(stan_file='model/model14-5.stan')
fit_MAP = model.optimize(data=data, seed=123)
fit_MAP.save_csvfiles('output/result-model14-5')


## original version:
def softmax_n(x, n):
    idx = np.arange(len(x))
    x_skip = x[idx != n]
    return(np.exp(x_skip)/np.sum(np.exp(x_skip)))

def error_func(var, n):
    di = - dist[n,] / (2*var)
    p = softmax_n(di, n)
    entropy = np.sum(-p * np.log2(p))
    error = (2**entropy - M)**2
    return(error)

var_vec = np.zeros(N)
for n in range(N):
    var_vec[n] = optimize.brent(error_func, args=(n,), brack=(0, 50))
