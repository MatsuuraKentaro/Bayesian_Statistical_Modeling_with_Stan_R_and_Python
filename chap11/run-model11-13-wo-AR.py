import pandas
import cmdstanpy
import numpy as np

d = pandas.read_csv('input/data-eg4.csv')
Weather_val = np.array([0, 0.1, 0.5, 1, 1])[d.Weather - 1]
Event_val = np.where(d.Event_n < 8000, \
    0, 1 - np.exp(-0.00012*(d.Event_n - 8000)))
d.loc[d.Month == 8, ['Y']] = np.nan
t_obs2t = d.index[d.Y.notnull()] + 1
Y = d.loc[t_obs2t - 1].Y

data = {'T':len(d), 't2wd':d.Wday, 'Ho':d.Ho, 'BH':d.BHo,
  'Weather_val':Weather_val, 'Event_val':Event_val,
  'T_obs':len(t_obs2t), 't_obs2t':t_obs2t, 'Y':Y}
 
model = cmdstanpy.CmdStanModel(stan_file='model/model11-13-wo-AR.stan')
fit = model.sample(data=data, seed=123,
                   parallel_chains=4, max_treedepth=15)
fit.save_csvfiles('output/result-model11-13-wo-AR')
