import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-shopping-4.csv')
d.Income /= 100
d.insert(1, 'intercept', 1)
X = d.iloc[:, 1:6].to_numpy()
data = {'N':X.shape[0], 'D':X.shape[1], 'X':X, 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model5-7.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model5-7')
