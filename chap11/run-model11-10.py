import pandas
import cmdstanpy

d = pandas.read_csv('input/data-eg1.csv')
d = d.pivot(index=['Group', 'PID'], columns='Time', values='Y').reset_index()
Y1 = d[d.Group == 1].drop(['Group', 'PID'], axis='columns')
Y2 = d[d.Group == 2].drop(['Group', 'PID'], axis='columns')
T = Y1.shape[1]
N1 = Y1.shape[0]
N2 = Y2.shape[0]
data = {'T':T, 'N1':N1, 'N2':N2, 'Y1':Y1, 'Y2':Y2}

model = cmdstanpy.CmdStanModel(stan_file='model/model11-10.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model11-10')
