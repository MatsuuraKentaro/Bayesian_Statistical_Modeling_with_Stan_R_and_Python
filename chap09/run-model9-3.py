import pandas
import numpy as np
import cmdstanpy

np.random.seed(123)
d = pandas.read_csv('input/data-tennis-2017.csv')
N = np.max(d.to_numpy())
G = len(d)
data = {'N':N, 'G':G, 'g2L':d.Loser, 'g2W':d.Winner}

def init_fun():
    return {'mu':np.random.normal(loc=0, scale=0.05, size=N)}

model = cmdstanpy.CmdStanModel(stan_file='model/model9-3.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4, inits=init_fun())
fit.save_csvfiles('output/result-model9-3')

mu_ms = fit.stan_variable(var='mu')
qua = np.quantile(mu_ms, [0.05, 0.50, 0.95], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1,N+1), qua.T]), \
    columns=['NID', '10%', '50%', '90%'])
d_top5 = d_est.nlargest(5, '50%')
#        NID       10%       50%       90%
# 53    54.0  1.647616  2.145335  2.758852
# 116  117.0  1.495580  1.890695  2.370836
# 38    39.0  0.864339  1.350435  1.882290
# 173  174.0  0.894896  1.260735  1.645432
# 34    35.0  0.811560  1.235450  1.688341

s_pf_ms = fit.stan_variable(var='s_pf')
qua = np.quantile(s_pf_ms, [0.05, 0.50, 0.95], axis=0)
d_est = pandas.DataFrame(np.column_stack([np.arange(1,N+1), qua.T]), \
    columns=['NID', '10%', '50%', '90%'])
d_top3 = d_est.nlargest(3, '50%')
d_bot3 = d_est.nsmallest(3, '50%')
#        NID       10%       50%       90%
# 93    94.0  0.745436  1.246845  1.872001
# 146  147.0  0.728718  1.212850  1.853632
# 80    81.0  0.714567  1.192350  1.819750

#        NID       10%       50%       90%
# 7      8.0  0.403085  0.705031  1.138887
# 116  117.0  0.418390  0.726276  1.158035
# 23    24.0  0.447273  0.788228  1.293023
