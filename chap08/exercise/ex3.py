import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('data-ex3.csv')
N = len(d)
C = np.max(d.countryID)
S = np.max(d.schoolID)
s2c = d.filter(items=['schoolID', 'countryID']).drop_duplicates().countryID
n2s = d.schoolID
data = {'N':N, 'C':C, 'S':S, 'Y':d.Y, 's2c':s2c, 'n2s':n2s}

model = cmdstanpy.CmdStanModel(stan_file='ex3.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('result-ex3')
