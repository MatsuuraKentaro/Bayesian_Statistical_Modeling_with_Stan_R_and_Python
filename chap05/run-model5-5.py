import pandas
import cmdstanpy

d = pandas.read_csv('input/data-shopping-3.csv')
d.Income /= 100
d.rename(columns={'Discount': 'Dis'}, inplace=True)
data = d.to_dict('list')
data.update({'V':len(d)})

model = cmdstanpy.CmdStanModel(stan_file='model/model5-5.stan')
# model = cmdstanpy.CmdStanModel(stan_file='model/model5-5b.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model5-5')
