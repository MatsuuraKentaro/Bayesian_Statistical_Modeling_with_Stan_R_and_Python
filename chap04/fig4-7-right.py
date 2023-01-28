import seaborn as sns
import cmdstanpy

fit = cmdstanpy.from_csv('output/result-model4-4')
d_ms = fit.draws_pd()
N_ms = len(d_ms)

sns.set(font_scale=1.5)
p = sns.jointplot(data=d_ms, x='a', y='b')
p.figure.savefig('output/fig4-7-right.py.png', dpi=250) 
