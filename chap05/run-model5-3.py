import pandas
import cmdstanpy
import numpy as np
np.random.seed(123)

d = pandas.read_csv('input/data-shopping-1.csv')
d.Income /= 100
Y_sim_mean = 0.2 + 0.15*d.Sex + 0.4*d.Income
Y_sim = np.random.normal(loc=Y_sim_mean, scale=0.1)
data = d.to_dict('list')
data.update({'N':len(d)})
data_sim = data.copy()
data_sim['Y'] = Y_sim

model = cmdstanpy.CmdStanModel(stan_file='model/model5-3.stan')
fit_sim = model.sample(data=data_sim, seed=123, parallel_chains=4)
fit     = model.sample(data=data,     seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model5-3')
