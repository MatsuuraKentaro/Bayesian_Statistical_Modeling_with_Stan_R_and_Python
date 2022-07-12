import pandas
import cmdstanpy
import numpy as np

d_game = pandas.read_csv('input/data-eg3.csv')
d_player = pandas.read_csv('input/data-eg3-players.csv')
N = np.max(d_player.PID)
G = len(d_game)
I = np.max(d_player.End_Index)

data = {'N':N, 'G':G, 'I':I, 
        'g2Ln':d_game.Loser_PID,     'g2Wn':d_game.Winner_PID, 
        'g2Li':d_game.Loser_Index,   'g2Wi':d_game.Winner_Index,
        'n2Si':d_player.Start_Index, 'n2Ei':d_player.End_Index}

def init_fun():
    return dict(
        mu_ini=np.random.uniform(0, 0.01, N),
        mu_raw=np.random.uniform(0, 0.01, I-N),
        s_pf=np.repeat(5.0, N))

model = cmdstanpy.CmdStanModel(stan_file='model/model11-12.stan')
fit = model.sample(data=data, seed=123, parallel_chains=4, inits=init_fun())
fit.save_csvfiles('output/result-model11-12')

def init_fun_b():
    return dict(
        mu_ini=np.random.uniform(0, 0.01, 2*N),
        mu_raw=np.random.uniform(0, 0.01, I-2*N),
        s_pf=np.repeat(5.0, N))

model_b = cmdstanpy.CmdStanModel(stan_file='model/model11-12b.stan')
fit_b = model_b.sample(data=data, seed=123, parallel_chains=4, inits=init_fun_b())
fit_b.save_csvfiles('output/result-model11-12b')
