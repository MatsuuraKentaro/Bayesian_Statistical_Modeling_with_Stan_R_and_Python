import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-gp-sparse.csv')
N = len(d)
Ni = 15
Xi = np.linspace(0, 1, Ni)
Np = 61
Xp = np.linspace(0, 1, Np)
data = {'Ni':Ni, 'N':N, 'Np':Np, 'Xi':Xi, 'X':d.X, 'Xp':Xp, 'Mui':np.repeat(0, Ni), 'Mu':np.repeat(0, N), 'Mup':np.repeat(0, Np), 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model12-10.stan')
# fit = model.sample(data=data, seed=123, parallel_chains=4)
fit_MAP = model.optimize(data=data, seed=123)
fit_MAP.save_csvfiles('output/result-model12-10')
