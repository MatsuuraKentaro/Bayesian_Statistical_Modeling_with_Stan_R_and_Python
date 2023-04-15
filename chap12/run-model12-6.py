import pandas
import cmdstanpy

T = 96
d = pandas.read_csv('input/data-2Dmesh.csv', header=None).to_numpy()
I, J = d.shape
ij2t = pandas.read_csv('input/data-2Dmesh-design.csv', header=None)
data = {'I':I, 'J':J, 'Y':d, 'T':T, 'ji2t':ij2t.T}

model = cmdstanpy.CmdStanModel(stan_file='model/model12-6.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4, iter_sampling=5000)
fit.save_csvfiles('output/result-model12-6')
