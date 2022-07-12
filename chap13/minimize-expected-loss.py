import pandas
import cmdstanpy
import numpy as np
from scipy import optimize

d = pandas.read_csv('../chap11/input/data-season.csv')
T = len(d)
data = {'T':T, 'Y':d.Y.values, 'L':4, 'Tp':8}
model = cmdstanpy.CmdStanModel(stan_file='../chap11/exercise/ex2.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)

y = fit.draws_pd(['yp'])['yp[1]']

def loss_function(a):
    return(np.where(a < y, 2*(y-a), 1-np.exp(-(a-y))))

def expected_loss(a):
    return(np.mean(loss_function(a)))

a_best = optimize.brent(expected_loss, brack=(5, 50))
