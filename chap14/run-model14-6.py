import pandas
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-oil.csv')
D = 12
Y = StandardScaler().fit_transform(d.iloc[:, 0:D])
N = len(d)
K = 2
data = {'N':N, 'D':D, 'K':K, 'Mu':np.repeat(0, N), 'Y':Y.T}

pca = PCA()
pca.fit(Y)
res_pca = pca.transform(Y)

def init_fun():
    return {'x': res_pca[:,0:K]}

model = cmdstanpy.CmdStanModel(stan_file='model/model14-6.stan')
fit_vb = model.variational(data=data, seed=123, inits=init_fun())
fit_vb.save_csvfiles('output/result-model14-6')
