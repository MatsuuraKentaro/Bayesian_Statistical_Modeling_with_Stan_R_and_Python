import pandas
import cmdstanpy
import numpy as np

d = pandas.read_csv('input/data-eg2.csv')
T = 60
t_obs2t = list([*range(1,21), *range(31,41), *range(51,61)])
T_obs = len(t_obs2t)
t_bf2t = list(range(21,30))
T_bf = len(t_bf2t)
Y_obs = d.loc[np.array(t_obs2t) - 1, ['Weight','Bodyfat']]/10
Y_bf = d.loc[np.array(t_bf2t) - 1].Bodyfat/10
data = {'T':T, 'T_obs':T_obs, 'T_bf':T_bf,
  't_obs2t':t_obs2t, 't_bf2t':t_bf2t, 'Y_obs':Y_obs, 'Y_bf':Y_bf, 'Nu':2}

model = cmdstanpy.CmdStanModel(stan_file='model/model11-11.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model11-11')
