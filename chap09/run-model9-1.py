import pandas
import cmdstanpy

d = pandas.read_csv('input/data-category.csv')
d.Age /= 100
d.Income /= 100
d.insert(0, 'intercept', 1)
X = d.iloc[:, 0:4].to_numpy()
data = {'N':X.shape[0], 'D':X.shape[1], 'K':6, 'X':X, 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model9-1.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model9-1')
