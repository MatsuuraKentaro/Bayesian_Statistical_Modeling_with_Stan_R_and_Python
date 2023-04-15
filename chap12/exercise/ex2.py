import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('../../chap11/input/data-weight.csv')
N = len(d)
X = d.X
Y = (d.Y - np.mean(d.Y)) / np.std(d.Y)
Np = 3
Xp = list(range(21,24))
data = {'N':N, 'X':X, 'Mu':np.repeat(0,N), 'Y':Y, 'Np':Np, 'Xp':Xp}

model = cmdstanpy.CmdStanModel(stan_file='ex2.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
