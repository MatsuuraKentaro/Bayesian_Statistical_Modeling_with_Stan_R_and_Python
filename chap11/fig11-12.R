library(dplyr)
library(tidyr)
library(ggplot2)

se <- function(x) sd(x)/sqrt(length(x))

d <- read.csv('input/data-eg1.csv')
d_plot <- d %>%
  group_by(Group, Time) %>%
  summarize(mean=mean(Y), SE=se(Y)) %>% ungroup() %>%
  mutate(Group=as.factor(Group))

p <- ggplot(data=d_plot, aes(x=Time, y=mean, group=Group, color=Group, linetype=Group)) +
  theme_bw(base_size=18) +
  geom_errorbar(aes(ymin=mean - SE, ymax=mean + SE), width=0.2, position=position_dodge(0.3)) +
  geom_line(size=0.5) +
  scale_x_continuous(breaks=c(0, 5, 10, 15, 20)) +
  scale_color_manual(values=c('black', alpha('black', 0.7))) +
  scale_linetype_manual(values=c('solid', '41')) +
  labs(x='Time (Hour)', y='Y')
ggsave(p, file='output/fig11-12.png', dpi=300, w=5, h=3)
