import numpy as np
np.random.seed(123)

S = 5    # number of draws
N = 101  # length of f
X = np.linspace(0, 1, num=N)
a   = 2
rho = 0.05

K = np.zeros((N, N))
for i in range(0, N):
    for j in range(0, N):
        K[i,j] = a**2 * np.exp(-0.5/rho**2 * (X[i]-X[j])**2)

f_draws = np.random.multivariate_normal(np.repeat(0, N), K, S)
