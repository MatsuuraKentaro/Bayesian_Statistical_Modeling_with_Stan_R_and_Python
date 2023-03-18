import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-outlier.csv')
Np = 101
Xp = np.linspace(0, 11, Np)
data = {'N':len(d), 'X':d.X, 'Y':d.Y, 'Np':Np, 'Xp':Xp}

model = cmdstanpy.CmdStanModel(stan_file='model/model7-8.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model7-8')
