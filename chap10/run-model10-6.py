import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-mix2.csv')
K = 5
data = {'N':len(d), 'K':K, 'Y':d.Y}

def init_fun():
    return {'a':np.repeat(1,K)/K, 'mu':np.linspace(10,40,num=K), 's_mu':20, 'sigma':np.repeat(1,K)}

model = cmdstanpy.CmdStanModel(stan_file='model/model10-6.stan')
fit = model.sample(data=data, seed=123, inits=init_fun(), parallel_chains=4)
fit.save_csvfiles('output/result-model10-6')

model_b = cmdstanpy.CmdStanModel(stan_file='model/model10-6b.stan')
fit_b = model_b.sample(data=data, seed=123, inits=init_fun(), parallel_chains=4)
fit_b.save_csvfiles('output/result-model10-6b')
