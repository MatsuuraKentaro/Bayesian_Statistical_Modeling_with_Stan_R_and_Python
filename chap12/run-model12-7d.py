import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-gp.csv')
N = len(d)
Np = 61
Xp = np.linspace(0, 1, Np)
data = {'N':N, 'Np':Np, 'X':d.X, 'Xp':Xp, 'Mu':np.repeat(0, N), 'Mup':np.repeat(0, Np), 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model12-7d.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model12-7d')
fit_MAP = model.optimize(data=data, seed=123)
