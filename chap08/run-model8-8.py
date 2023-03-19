import pandas
import cmdstanpy
import numpy as np
from sklearn.metrics import roc_curve, auc
from plotnine import *

d = pandas.read_csv('input/data-shopping-3.csv')
N = 50
d2 = d.filter(items=['PersonID', 'Sex', 'Income']).drop_duplicates()
V = len(d)
data = {'N':N, 'V':V, 'Sex':d2.Sex, 'Income':d2.Income/100, 'v2n':d.PersonID, 'Dis':d.Discount, 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='model/model8-8.stan')
fit = model.sample(data=data, seed=123)
fit.save_csvfiles('output/result-model8-8')

q_ms = fit.stan_variable(var='q')
N_ms = len(q_ms)
xp = np.linspace(0, 1, 201)
probs = [0.1, 0.5, 0.9]

auces = np.empty(N_ms)
m_roc = np.empty((N_ms, len(xp)))
for i in range(N_ms):
    fpr, tpr, thresholds = roc_curve(d.Y, q_ms[i,:], drop_intermediate=False)
    auces[i] = auc(fpr, tpr)
    m_roc[i,:] = np.interp(xp, fpr, tpr)

np.quantile(auces, probs)
