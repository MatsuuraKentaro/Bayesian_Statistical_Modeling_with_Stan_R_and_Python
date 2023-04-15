import pandas
import cmdstanpy

Y = pandas.read_csv('input/data-1D.csv').Y
I = len(Y)
data = {'I':I, 'Y':Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model12-3.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model12-3')
