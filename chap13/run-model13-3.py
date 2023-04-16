import cmdstanpy
import numpy as np
# from scipy.stats import beta
import logging
from cmdstanpy.utils import get_logger
get_logger().setLevel(logging.ERROR)
np.random.seed(123)

def fetch_y(x):
    mu = np.cos(9.5*x-2) - np.sin(15*x-1) + 5
    SD = 0.25
    y = np.random.normal(mu, SD, x.size)
    return(y)

T = 20
Np = 81
Xp = np.linspace(0, 1, Np)
x_sel = np.array([0.5])
y_sel = fetch_y(x_sel)
x_cum = x_sel
y_cum = y_sel
model = cmdstanpy.CmdStanModel(stan_file='../chap12/model/model12-7d.stan')

for t in range(T):
    N = len(x_cum)
    data = {'N':N, 'Np':Np, 'X':x_cum, 'Xp':Xp,
            'Mu':np.repeat(0,N), 'Mup':np.repeat(0,Np),
            'Y':y_cum - np.mean(y_cum)}
    fit = model.sample(data=data, seed=123, parallel_chains=4,
                       show_progress=False)
    fp_ms = fit.draws_pd(['fp'])
    N_ms = len(fp_ms)
    rand = np.random.randint(0, N_ms)
    np_sel = np.argmax(fp_ms.iloc[rand])
    x_sel = Xp[np_sel]
    y_sel = fetch_y(x_sel)
    x_cum = np.append(x_cum, x_sel)
    y_cum = np.append(y_cum, y_sel)
