import pandas
import cmdstanpy

d = pandas.read_csv('input/data-salary-2.csv')
N = len(d)
data = {'N':N, 'X':d.X, 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model8-1.stan')
fit1 = model.sample(data=data, seed=123, parallel_chains=4)
fit1.save_csvfiles('output/result-model8-1')
