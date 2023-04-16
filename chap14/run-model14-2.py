import pandas
from datetime import datetime
import cmdstanpy

d = pandas.read_csv('input/data-surv.csv')
N = len(d)
d1 = datetime(2018,12,31)
d2 = datetime(2014,1,1)

def diff_month(d1, d2):
    return (d1.year - d2.year) * 12 + d1.month - d2.month

T = diff_month(d1, d2) + 1
data = {'N':N, 'T':T, 'Time':d.Time, 'Cens':d.Cens}

model = cmdstanpy.CmdStanModel(stan_file='model/model14-2.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model14-2')
