import pandas
import cmdstanpy

d = pandas.read_csv('input/data-salary-2.csv')
N = len(d)
C = 4
data = {'N':N, 'C':C, 'X':d.X, 'Y':d.Y, 'n2c':d.CID, 'Nu':2}

model = cmdstanpy.CmdStanModel(stan_file='model/model9-7.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model9-7')
