import pandas
import cmdstanpy

d = pandas.read_csv('input/data-salary.csv')
data = d.to_dict('list')
data.update({'N':len(d)})
model = cmdstanpy.CmdStanModel(stan_file='model/model4-4.stan')
fit = model.sample(data=data, seed=123)

fit.save_csvfiles('output/result-model4-4')
fit.summary().to_csv('output/fit-summary.csv')

import arviz
axes = arviz.plot_trace(fit)
fig = axes.ravel()[0].figure
fig.savefig('output/fit-plot.pdf')
