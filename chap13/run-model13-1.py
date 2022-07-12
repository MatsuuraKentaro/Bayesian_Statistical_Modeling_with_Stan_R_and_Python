import pandas
import cmdstanpy
import numpy as np
import rpy2.robjects as robj
np.random.seed(123)

N = 20
Y1 = 10
Y2 = 14
data = {'N':N, 'Y1':Y1, 'Y2':Y2}
model = cmdstanpy.CmdStanModel(stan_file='model/model13-1.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4,
                   iter_sampling=10000)
n = 93
pval_cut = 0.05
N_sim = 40000
d_ms = fit.draws_pd()
N_ms = len(d_ms)

def calc_pvals(y1, y2):
    robj.globalenv['n'] = robj.FloatVector(np.array([n]))
    robj.globalenv['y1'] = robj.FloatVector(np.array(y1))
    robj.globalenv['y2'] = robj.FloatVector(np.array(y2))
    robj.r('''
        calc_pval <- function(x1, x2) {
          prop.test(c(x1, x2), c(n, n), correct=FALSE)$p.value
        }
        pvals <- mapply(calc_pval, y1, y2)
    ''')
    pvals = np.array(robj.r['pvals'])
    return pvals

y1_MLE = np.random.binomial(n, Y1/N, N_sim)
y2_MLE = np.random.binomial(n, Y2/N, N_sim)
y1_Bay = np.random.binomial(n, d_ms.theta1.values, N_ms)
y2_Bay = np.random.binomial(n, d_ms.theta2.values, N_ms)
pvals_MLE = calc_pvals(y1_MLE, y2_MLE)
pvals_Bay = calc_pvals(y1_Bay, y2_Bay)
power     = np.mean(pvals_MLE < pval_cut)
assurance = np.mean(pvals_Bay < pval_cut)
