| page | line | before | after |
|:-----------|:------------|:------------|:------------|
| 62 | Lines 24 and 25 in `model4-4b.stan` | `1:N` |  `1:Np` |
| 229 | Line 5 | $\text{Bernoulli}(0 \mid q_c)$ | $\text{Bernoulli}(0 \mid q_f)$ |
| 233 | Line 26 | $Y_3 = 1 - Y_1 - Y_2$ | $Y_3 = m - Y_1 - Y_2$ |
| 292 | Fig. 12.3 | ![fig wrong](chap12/output/fig12-4.png) | ![fig correct](chap12/output/fig12-3.png) |
| 276 | Line 3 | sunny, cloudy, rain, snow | sunny, cloudy, rain, heavy rain, snow |
| 312 | Line 32 in `model12-7b.stan` | `normal(0, 0.1)`  | `normal(0.1, 0.1)` |
| 314 | Line 11 in `model12-7c.stan` | `normal(0, 0.1)`  | `normal(0.1, 0.1)` |
