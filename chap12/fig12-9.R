library(dplyr)
library(ggplot2)

d_plot <- read.csv('input/data-2Dmesh.csv', header=FALSE) %>% 
  mutate(i=1:16) %>% 
  magrittr::set_colnames(c(1:24, 'i')) %>% 
  tidyr::pivot_longer(cols=-i, names_to='j', values_to='Y') %>% 
  mutate(j=as.integer(j))

p <- ggplot(data=d_plot, aes(x=j, y=i, z=Y, fill=Y)) +
  theme_bw(base_size=20) +
  theme(legend.key.size=grid::unit(2.0, 'lines'), panel.background=element_blank()) +
  geom_tile(color='black') +
  scale_fill_gradient2(midpoint=median(d_plot$Y), low='black', mid='gray50', high='white') +
  scale_y_reverse(limits=c(16.5, 0.5), breaks=c(5,10,15)) +
  xlab('Plate Column') + ylab('Plate Row') +
  coord_cartesian(xlim=c(0.5, 24.5), expand=FALSE)
ggsave(p, file='output/fig12-9.png', dpi=300, w=6.5, h=4)
