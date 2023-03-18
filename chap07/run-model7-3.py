import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-conc.csv')
Tp = 60
Xp = np.linspace(0, 24, Tp)
data = {'T':len(d), 'X':d.Time, 'Y':d.Y, 'Tp':Tp, 'Xp':Xp}

model = cmdstanpy.CmdStanModel(stan_file='model/model7-3.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model7-3')
