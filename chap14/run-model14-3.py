import pandas
import cmdstanpy

d = pandas.read_csv('input/data-matrix-decomp.csv')
N = 50
K = 6
I = 120
Y = pandas.crosstab(d.PersonID, d.ItemID)
data = {'N':N, 'I':I, 'K':K, 'Y':Y.T}

model = cmdstanpy.CmdStanModel(stan_file='model/model14-3.stan')
fit_MAP = model.optimize(data=data, seed=123)
fit_MAP.save_csvfiles('output/result-model14-3')
