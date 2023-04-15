import pandas
import cmdstanpy

d = pandas.read_csv('input/data-map-temperature.csv')
d2 = pandas.read_csv('input/data-map-neighbor.csv')
I = len(d)
data = {'I':I, 'Y':d.Y, 'K':len(d2), 'From':d2.From, 'To':d2.To}

model = cmdstanpy.CmdStanModel(stan_file='model/model12-5.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4, iter_sampling=5000)
fit.save_csvfiles('output/result-model12-5')
