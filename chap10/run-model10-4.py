import pandas
import cmdstanpy

d = pandas.read_csv('input/data-poisson-binomial.csv')
data = {'N':len(d), 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model10-4.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model10-4')
