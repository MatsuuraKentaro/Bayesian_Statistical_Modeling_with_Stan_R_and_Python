import pandas
import numpy as np
import cmdstanpy

T = 96
d = pandas.read_csv('input/data-2Dmesh.csv', header=None).values
I, J = np.shape(d)
N = I*J
X = np.array([(i/(I-1), j/(J-1)) for j in range(J) for i in range(I)])
Y_ori = d.T.reshape(N)
Y = Y_ori - np.mean(Y_ori)
d_trt = pandas.read_csv('input/data-2Dmesh-design.csv', header=None)
n2t = d_trt.values.T.reshape(N)
data = {'N':N, 'X':X, 'Mu':np.zeros(N), 'Y':Y, 'T':T, 'n2t':n2t}
 
model = cmdstanpy.CmdStanModel(stan_file='model/model12-9.stan')
fit_MAP = model.optimize(data=data, seed=123)
fit_MAP.save_csvfiles('output/result-model12-9')
