import pandas
import cmdstanpy

d = pandas.read_csv('input/data-salary.csv')
data = d.to_dict('list')
data.update({'N':len(d)})
model = cmdstanpy.CmdStanModel(stan_file='model/model4-4.stan')

def init_fun():
    return dict(a=40, b=1, sigma=5)

fit = model.sample(
    data=data, seed=123,
    inits=init_fun(),
    chains=3, iter_warmup=500, iter_sampling=500, thin=2,
    parallel_chains=3,
    save_warmup=True
)
