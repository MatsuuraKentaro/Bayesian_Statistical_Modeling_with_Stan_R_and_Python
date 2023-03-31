import pandas
import cmdstanpy

d = pandas.read_csv('../input/data-season.csv')
T = len(d)
data = {'T':T, 'Y':d.Y, 'L':4, 'Tp':8}

model = cmdstanpy.CmdStanModel(stan_file='ex2.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('result-ex2')
