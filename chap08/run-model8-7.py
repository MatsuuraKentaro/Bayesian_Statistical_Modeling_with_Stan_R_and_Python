import numpy as np
import pandas
import cmdstanpy

d_wide = pandas.read_csv('input/data-conc-2-NA-wide.csv')
N = len(d_wide)
X = [1, 2, 4, 8, 12, 24]
T = len(X)
Tp = 60
Xp = np.linspace(0.0, 24.0, num=Tp)
colnames = ['PersonID'] + ['Y' + str(x) for x in range(1,T+1)]
d_wide = d_wide.set_axis(colnames, axis='columns')
d = pandas.wide_to_long(d_wide, stubnames='Y', i='PersonID', j='TimeID')
d = d.sort_values(by=['PersonID', 'TimeID']).reset_index()
d = d.dropna()
data = d.rename(columns={'PersonID':'i2n', 'TimeID': 'i2t'}).to_dict('list')
data.update({'I':len(d), 'N':N, 'T':T, 'X':X, 'Tp':Tp, 'Xp':Xp})

model = cmdstanpy.CmdStanModel(stan_file='model/model8-7.stan')
fit = model.sample(data=data, seed=123)
fit.save_csvfiles('output/result-model8-7')
