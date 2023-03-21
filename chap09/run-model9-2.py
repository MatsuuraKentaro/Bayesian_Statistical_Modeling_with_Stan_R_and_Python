import pandas
import cmdstanpy

d = pandas.read_csv('input/data-tortoise-hare.csv')
data = {'N':2, 'G':len(d), 'g2L':d.Loser, 'g2W':d.Winner}

model = cmdstanpy.CmdStanModel(stan_file='model/model9-2.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model9-2')
