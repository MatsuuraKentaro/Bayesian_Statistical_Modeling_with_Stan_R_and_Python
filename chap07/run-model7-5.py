import pandas
import cmdstanpy

d = pandas.read_csv('input/data-50m.csv')
data = {'N':len(d), 'Age':d.Age, 'Weight':d.Weight, 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model7-5.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model7-5')
