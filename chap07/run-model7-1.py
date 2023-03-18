import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-rental.csv')
Np = 50
Xp = np.linspace(10, 120, Np)
data = {'N':len(d), 'X':d.Area, 'Y':d.Y, 'Np':Np, 'Xp':Xp}

model = cmdstanpy.CmdStanModel(stan_file='model/model7-1.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model7-1')
