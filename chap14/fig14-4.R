library(dplyr)
library(ggplot2)

N <- 50
I <- 120
d_ori <- read.csv(file='input/data-matrix-decomp.csv')
d <- data.frame(table(d_ori)) %>% filter(Freq >= 1)
d <- d %>% 
  mutate(PersonID = as.integer(PersonID),
         ItemID = as.integer(ItemID))

p <- ggplot(data=d, aes(x=ItemID, y=PersonID, fill=Freq)) +
  theme_bw(base_size=22) +
  theme(axis.text=element_blank(), axis.ticks=element_blank()) +
  geom_tile() +
  scale_fill_gradient(breaks=c(1,5,10), low='gray80', high='black')
ggsave(file='output/fig14-4.png', plot=p, dpi=300, w=8, h=6)
