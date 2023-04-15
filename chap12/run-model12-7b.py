import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-gp.csv')
N = len(d)
data = {'N':N, 'X':d.X, 'Mu':np.repeat(0, N), 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model12-7b.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model12-7b')
