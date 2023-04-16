import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-matrix-decomp.csv')
N = 50
K = 6
I = 120
Y = pandas.crosstab(d.PersonID, d.ItemID)
data = {'N':N, 'I':I, 'K':K, 'Y':Y, 'Alpha':np.repeat(0.5, I)}

model = cmdstanpy.CmdStanModel(stan_file='model/model14-4.stan')
fit_vb = model.variational(data=data, seed=123)
fit_vb.save_csvfiles('output/result-model14-4')
