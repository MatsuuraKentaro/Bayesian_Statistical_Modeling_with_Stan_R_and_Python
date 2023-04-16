import numpy as np
import cmdstanpy
import pandas
import logging
from cmdstanpy.utils import get_logger
import dill
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
d_dat = pandas.DataFrame(index=[], columns=['time', 'X', 'Y'])
d_pre = pandas.DataFrame(index=[], columns=['time', 'X', 'Y'])
d_est = pandas.DataFrame(index=[], columns=['time', 'X', '2.5%', '25%', '50%', '75%', '97.5%'])
d_sel = pandas.DataFrame(index=[], columns=['time', 'X'])

for t in range(1, T+1):
    d_dat = pandas.concat([d_dat, pandas.DataFrame({'time':t,   'X':x_sel, 'Y':y_sel})])
    d_pre = pandas.concat([d_pre, pandas.DataFrame({'time':t+1, 'X':x_cum, 'Y':y_cum})])

    N = len(x_cum)
    y_mean = np.mean(y_cum)
    data = {'N':N, 'Np':Np, 'X':x_cum, 'Xp':Xp,
            'Mu':np.repeat(0,N), 'Mup':np.repeat(0,Np),
            'Y':y_cum - y_mean}
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

    qua = np.quantile(fp_ms, [0.025, 0.25, 0.50, 0.75, 0.975], axis=0) + y_mean
    d_qua = pandas.DataFrame(np.column_stack([np.repeat(t, Np), Xp, qua.T]), \
                              columns=['time', 'X', '2.5%', '25%', '50%', '75%', '97.5%'])
    d_est = pandas.concat([d_est, d_qua])
    d_sel = pandas.concat([d_sel, pandas.DataFrame({'time':[t], 'X':[x_sel]})])

dill.dump_session('output/result-model13-3.pkl')
