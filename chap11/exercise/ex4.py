import pandas
import cmdstanpy

d = pandas.read_csv('data-ex4.csv')
T = len(d)
data = {'T':T, 'Y':d.Y}

model = cmdstanpy.CmdStanModel(stan_file='ex4.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4,
                   iter_warmup=2000, iter_sampling=4000)
fit.save_csvfiles('result-ex4')
