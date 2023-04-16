import pandas
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from plotnine import ggplot, aes, theme_bw, geom_point, scale_shape_manual

d = pandas.read_csv('input/data-oil.csv')
D = 12
Y = StandardScaler().fit_transform(d.iloc[:, 0:D])

pca = PCA()
pca.fit(Y)
res_pca = pca.transform(Y)
d_pca = pandas.DataFrame({'X1': res_pca[:,0], 'X2': res_pca[:,1], 'Class':pandas.Categorical(d.Class, categories=[1,2,3])})

p = (ggplot(d_pca, aes('X1', 'X2', shape='Class'))
    + theme_bw(base_size=18)
    + geom_point(size=2.5, alpha=0.7)
    + scale_shape_manual(values=['.','x','^'])
)
p.save(filename='output/fig14-6.py.png', dpi=300, width=6, height=5)

