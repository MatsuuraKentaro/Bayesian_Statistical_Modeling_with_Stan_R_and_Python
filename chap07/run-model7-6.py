import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('input/data-protein.csv')
idx = np.where(d.Y.str.match('<'))[0]
Y_obs = d.Y[~d.index.isin(idx)].astype(float)
L = d.Y[d.index.isin(idx)].str.extract('([\d\.]+)').astype(float)[0][0]
data = {'N_obs':len(Y_obs), 'N_cens':len(idx), 'Y_obs':Y_obs, 'L':L}

model = cmdstanpy.CmdStanModel(stan_file='model/model7-6.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model7-6')
