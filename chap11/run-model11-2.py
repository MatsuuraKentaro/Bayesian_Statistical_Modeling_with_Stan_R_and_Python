import pandas
import cmdstanpy

d = pandas.read_csv('input/data-weight.csv')
T = len(d)
Tp = 3
data = {'T':T, 'Tp':Tp, 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model11-2.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model11-2')

model_b = cmdstanpy.CmdStanModel(stan_file='model/model11-2b.stan')
fit_b = model_b.sample(data=data, seed=123, parallel_chains=4)
fit_b.save_csvfiles('output/result-model11-2b')
