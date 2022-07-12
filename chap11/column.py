from scipy.stats import norm, gaussian_kde

mu_all_ms = fit.draws_pd(vars=['mu_all'])
s_y_ms = fit.draws_pd(vars=['s_y']).s_y.values

t_now = 21 - 1
dens_pred = gaussian_kde(mu_all_ms.iloc[:,t_now])
w = norm.pdf(x=85.2, loc=mu_all_ms.iloc[:,t_now], scale=s_y_ms)
dens_flt = gaussian_kde(mu_all_ms.iloc[:,t_now], weights=w/sum(w))
post_mean = np.sum(mu_all_ms.iloc[:,t_now] * w/sum(w))
