import pandas
import cmdstanpy
import numpy as np

d = pandas.read_csv('input/data-ZIB.csv')
d.Age /= 10
N = len(d)
X = d.drop(['Y'], axis=1)
X.insert(0, 'intercept', np.ones(N))
D = len(X.columns)
data = {'N':N, 'D':D, 'X':X, 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model10-7.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model10-7')

d_ms = fit.draws_pd()
N_ms = len(d_ms)
q_f_ms = d_ms.filter(regex=('q_f\[')).to_numpy()
q_r_ms = d_ms.filter(regex=('q_r\[')).to_numpy()
r = []
for i in range(N_ms):
    r.append(np.corrcoef(q_f_ms[i,:], q_r_ms[i,:])[0,1])
print(np.quantile(r, [0.025, 0.25, 0.5, 0.75, 0.975]))
#        2.5%         25%         50%         75%       97.5% 
# -0.80517511 -0.70178641 -0.63814771 -0.56803581 -0.40766417
