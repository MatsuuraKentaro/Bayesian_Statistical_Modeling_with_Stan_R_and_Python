import pandas
import cmdstanpy

d = pandas.read_csv('input/data-weight.csv')
T = len(d)
Tp = 3
data = {'T':T, 'Tp':Tp, 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model11-3.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model11-3')
