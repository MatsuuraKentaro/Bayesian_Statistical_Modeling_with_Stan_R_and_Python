import cmdstanpy
import numpy as np
import pandas
from scipy import stats
from scipy.stats import norm
from scipy import integrate
import arviz as az
import logging
from cmdstanpy.utils import get_logger
get_logger().setLevel(logging.ERROR)
import warnings
warnings.filterwarnings('ignore')
np.random.seed(123)

model = cmdstanpy.CmdStanModel(stan_file='model/model14-7.stan')
N_sim = 10000
D = 3
b = np.array([1.3, -3.1, 0.7])
SD = 2.5
N = 30
X = np.hstack((np.ones((N,1)), np.random.uniform(-3, 3, (N, D-1))))
Mu = np.matmul(X, b)

res = []
for simID in range(N_sim):
    np.random.seed(simID)
    Y = np.random.normal(Mu, SD, N)
    data = {'N':N, 'D':D, 'X':X, 'Y':Y}
    fit = model.sample(data=data, seed=123, iter_sampling=2500,
                       parallel_chains=4, show_progress=False)
    yp_ms = fit.stan_variable(var='yp')
    ge_by_data_point = []
    for n in range(N):
        f_pred = stats.gaussian_kde(yp_ms[:,n])
        def f_true(y):
            return(norm.pdf(y, Mu[n], SD))
        def f_ge(y):
            return(f_true(y)*(-f_pred.logpdf(y)))
        ge, _ = integrate.nquad(f_ge, [[Mu[n]-6*SD, Mu[n]+6*SD]])
        ge_by_data_point.append(ge)
    ge = np.mean(np.array(ge_by_data_point))
  
    log_lik_ms = fit.stan_variable(var='log_lik')
    waic = - np.mean(az.waic(fit, pointwise=True).waic_i.to_numpy())
    looic = - np.mean(az.loo(fit, pointwise=True).loo_i.to_numpy())
    res.append([ge, waic, looic])

d_res = pandas.DataFrame(res, columns=['ge', 'waic', 'looic'])

## calculate entropy
# def f_true0(y):
#     return(norm.pdf(y, 0, SD))
# 
# def log_f_true0(y):
#     return(norm.logpdf(y, 0, SD))
# 
# def f_en(y):
#     return(f_true0(y)*(-log_f_true0(y)))
# 
# en, _ = integrate.nquad(f_en, [[-6*SD, 6*SD]])

## calculate waic by myself
# def waic_func(log_lik_ms):
#     tr_error_by_data_point = -np.log(np.mean(np.exp(log_lik_ms), axis=0))
#     func_var_by_data_point = np.mean(log_lik_ms**2, axis=0) \
#                        - np.mean(log_lik_ms, axis=0)**2
#     waic_by_data_point = tr_error_by_data_point + func_var_by_data_point
#     waic = np.mean(waic_by_data_point)
#     return(waic)
