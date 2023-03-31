import pandas
import cmdstanpy

d = pandas.read_csv('input/data-season.csv')
T = len(d)
Tp = 3
data = {'T':T, 'Y':d.Y, 'L':4}

model = cmdstanpy.CmdStanModel(stan_file='model/model11-4.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model11-4')
