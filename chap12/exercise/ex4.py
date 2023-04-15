import pandas
import numpy as np
import cmdstanpy

d = pandas.read_csv('../../chap11/input/data-eg1.csv')
d = d.set_index(['Group', 'PID', 'Time']).unstack('Time')
Y1 = d.loc[1]
Y2 = d.loc[2]

N1, T = Y1.shape
N2 = len(Y2)
data = {'T':T, 'X':np.arange(1, T+1), 'Mu':np.repeat(np.mean(Y1.to_numpy()),T), 
        'N1':N1, 'N2':N2, 'Y1':Y1, 'Y2':Y2}

model = cmdstanpy.CmdStanModel(stan_file='ex4.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
