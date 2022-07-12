import cmdstanpy
import numpy as np
import logging
from cmdstanpy.utils import get_logger
get_logger().setLevel(logging.ERROR)
np.random.seed(123)
K = 5
mu_true = np.array([10.0, 11.5, 10.4, 12.8, 9.7])
sd_true = 3.5
T_ini = 10
T = 90

def fetch_y(k, size):
    return(np.random.normal(mu_true[k], sd_true, size))

k_cum = np.resize(np.arange(K), T_ini)
y_cum = fetch_y(k_cum, T_ini)
model = cmdstanpy.CmdStanModel(stan_file='model/model13-2.stan')
for _ in range(T):
    data = {'N':len(y_cum), 'K':K, 'n2k':k_cum+1, 'Y':y_cum}
    fit = model.sample(data=data, seed=123, parallel_chains=4,
                       show_progress=False)
    mu_ms = fit.draws_pd(['mu'])
    N_ms = len(mu_ms)
    rand = np.random.randint(0, N_ms)
    k_sel = np.argmax(mu_ms.iloc[rand])
    y_sel = fetch_y(k_sel, 1)
    k_cum = np.append(k_cum, k_sel)
    y_cum = np.append(y_cum, y_sel)
