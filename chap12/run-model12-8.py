import pandas
import cmdstanpy
import numpy as np

Y = pandas.read_csv('input/data-1D.csv').Y
I = len(Y)
Mu = np.repeat(np.mean(np.log(Y.clip(1))), I)
X = np.arange(I) / (I-1)
data = {'N':I, 'X':X, 'Mu':Mu, 'Y':Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model12-8.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model12-8')
