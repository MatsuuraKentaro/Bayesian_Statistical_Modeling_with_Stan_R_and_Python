import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-conc-2.csv')
N = len(d)
X = [1, 2, 4, 8, 12, 24]
T = len(X)
Tp = 60
Xp = np.linspace(0, 24, num=Tp)
data = {'N':N, 'T':T, 'X':X, 'Y':d.drop('PersonID', axis=1), 'Tp':Tp, 'Xp':Xp}

model = cmdstanpy.CmdStanModel(stan_file='model/model8-6.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model8-6')
