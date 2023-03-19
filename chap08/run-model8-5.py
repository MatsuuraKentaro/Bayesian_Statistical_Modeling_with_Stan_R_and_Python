import pandas
import cmdstanpy

d = pandas.read_csv('input/data-salary-3.csv')
N = len(d)
C = 30
F = 3
c2f = d.filter(items=['CID', 'FID']).drop_duplicates().FID
data = {'N':N, 'C':C, 'F':F, 'X':d.X, 'Y':d.Y, 'n2c':d.CID, 'c2f':c2f}

model = cmdstanpy.CmdStanModel(stan_file='model/model8-5.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4)
fit.save_csvfiles('output/result-model8-5')
