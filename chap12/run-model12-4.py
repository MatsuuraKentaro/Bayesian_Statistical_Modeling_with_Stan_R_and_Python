import pandas
import cmdstanpy
import numpy as np

model = cmdstanpy.CmdStanModel(stan_file='model/model12-4.stan')

A = 76  # number of ages from 0 to 75+
Age_idx = np.arange(0, 76, 5) + 1
Flow = []
for a in Age_idx:
    for f in [-2,-1,1,2]:
        Flow.append([a + f, a])
Flow = pandas.DataFrame(Flow, columns=['from', 'to'])
Flow = Flow[(Flow['from'] > 1) & (Flow['from'] <= 76)]

d = pandas.read_csv('input/data-ageheap.csv')
d_M = d[d['Sex']=='M']
d_F = d[d['Sex']=='F']
data_M = {'A':A, 'Y':d_M.Y, 'J':len(Flow), 'From':Flow['from'], 'To':Flow['to']}
data_F = {'A':A, 'Y':d_F.Y, 'J':len(Flow), 'From':Flow['from'], 'To':Flow['to']}

fit_M = model.sample(data=data_M, seed=123, parallel_chains=4)
fit_F = model.sample(data=data_F, seed=123, parallel_chains=4)
fit_M.save_csvfiles('output/result-model12-4-M')
fit_F.save_csvfiles('output/result-model12-4-F')
