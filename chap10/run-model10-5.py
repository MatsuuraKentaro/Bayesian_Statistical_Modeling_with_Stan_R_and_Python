import pandas
import cmdstanpy

d = pandas.read_csv('input/data-mix1.csv')
data = {'N':len(d), 'Y':d.Y}

def init_fun():
    return {'a':0.5, 'mu':[0,5], 'sigma':[1,1]}

model = cmdstanpy.CmdStanModel(stan_file='model/model10-5.stan')
fit = model.sample(data=data, seed=123, inits=init_fun(), parallel_chains=4)
fit.save_csvfiles('output/result-model10-5')
