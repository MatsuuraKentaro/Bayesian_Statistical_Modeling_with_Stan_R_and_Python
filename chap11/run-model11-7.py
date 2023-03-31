import pandas
import cmdstanpy

d = pandas.read_csv('input/data-switch.csv')
T = len(d)
data = {'T':T, 'Y':d.Y, 'B':0.2}

model = cmdstanpy.CmdStanModel(stan_file='model/model11-7.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4, max_treedepth=15)
fit.save_csvfiles('output/result-model11-7')
