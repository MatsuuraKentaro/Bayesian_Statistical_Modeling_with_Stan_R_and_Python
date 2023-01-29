import pandas
import cmdstanpy

d = pandas.read_csv('input/data-shopping-2.csv')
d.Income /= 100
data = d.to_dict('list')
data.update({'N':len(d)})

model = cmdstanpy.CmdStanModel(stan_file='model/model5-4.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model5-4')
