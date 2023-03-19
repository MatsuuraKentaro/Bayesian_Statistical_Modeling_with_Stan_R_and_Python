import pandas
import cmdstanpy

d = pandas.read_csv('input/data-salary-2.csv')
N = len(d)
C = 4
data = {'N':N, 'C':C, 'X':d.X, 'Y':d.Y, 'n2c':d.CID}

model = cmdstanpy.CmdStanModel(stan_file='model/model8-2.stan')
fit2 = model.sample(data=data, seed=123, parallel_chains=4)
fit2.save_csvfiles('output/result-model8-2')
