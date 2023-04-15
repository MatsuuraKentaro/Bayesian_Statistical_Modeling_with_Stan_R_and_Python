import pandas
import numpy as np
import cmdstanpy

Y = pandas.read_csv('../../chap11/exercise/data-ex3.csv').Y
I = len(Y)
Mu = np.repeat(np.mean(Y)/10, I)
X = np.arange(I) / (I-1)
data = {'N':I, 'X':X, 'Mu':Mu, 'Y':Y}

model = cmdstanpy.CmdStanModel(stan_file='ex3.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
