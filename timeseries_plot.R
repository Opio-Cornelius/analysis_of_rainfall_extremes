library(ggplot2)
library(ggpubr)

data_3_west <- read.csv(file.choose(), header = T); head(data_3_west)
data_3_cent <- read.csv(file.choose(), header = T); head(data_3_cent)
data_3_east <- read.csv(file.choose(), header = T); head(data_3_east)
p_3_w <- ggplot(data_3_west, aes(x=data_3_west$time, y=data_3_west$rain, color=data_3_west$ï..experiment)) + labs(x="Time (hours)", y="3-hourly Rainfall Accumulation (mm)") + geom_line(size = 1.5) +
  scale_color_manual(values = c("gold4", "green3", "brown", "blue3","lightskyblue4", "darkgreen", "magenta3", "#E7B800","darkturquoise", "red", "black")) + theme(legend.title = element_blank()) + guides(color = guide_legend(override.aes = list(size = 1.5))) + scale_x_continuous(breaks = seq(0,24,3)) + coord_cartesian(ylim=c(0,3.1))
p_3_c <- ggplot(data_3_cent, aes(x=data_3_cent$time, y=data_3_cent$rain, color=data_3_cent$ï..experiment)) + labs(x="Time (hours)", y="3-hourly Rainfall Accumulation (mm)") + geom_line(size = 1.5) +
  scale_color_manual(values = c("gold4", "green3", "brown", "blue3","lightskyblue4", "darkgreen", "magenta3", "#E7B800","darkturquoise", "red", "black")) + theme(legend.title = element_blank()) + guides(color = guide_legend(override.aes = list(size = 1.5))) + scale_x_continuous(breaks = seq(0,24,3)) + coord_cartesian(ylim=c(0,3))
p_3_e <- ggplot(data_3_east, aes(x=data_3_east$time, y=data_3_east$rain, color=data_3_east$ï..experiment)) + labs(x="Time (hours)", y="3-hourly Rainfall Accumulation (mm)") + geom_line(size = 1.5) +
  scale_color_manual(values = c("gold4", "green3", "brown", "blue3","lightskyblue4", "darkgreen", "magenta3", "#E7B800","darkturquoise", "red", "black")) + theme(legend.title = element_blank()) + guides(color = guide_legend(override.aes = list(size = 1.5))) + scale_x_continuous(breaks = seq(0,24,3)) + coord_cartesian(ylim=c(0,3.2))

# For 20-day accumulation
data_wrf_west <- read.csv(file.choose(), header = T); head(data_wrf_west)
data_wrf_cent <- read.csv(file.choose(), header = T); head(data_wrf_cent)
data_wrf_east <- read.csv(file.choose(), header = T); head(data_wrf_east)
p_wrf_west <- ggplot(data_wrf_west, aes(x=data_wrf_west$ï..day, y=accum, color=experiment)) + labs(x="Time (days)", y="Accumulated Rainfall (mm)") + geom_line(size = 1.5) +
  scale_color_manual(values = c("gold4", "green3", "brown", "blue3","lightskyblue4", "darkgreen", "magenta3", "#E7B800","darkturquoise", "red", "black")) + theme(legend.position = "none") + scale_x_continuous(breaks = seq(0,20,2)) + coord_cartesian(ylim=c(0,300))
p_wrf_cent <- ggplot(data_wrf_cent, aes(x=data_wrf_cent$ï..day, y=accum, color=experiment)) + labs(x="Time (days)", y="Accumulated Rainfall (mm)") + geom_line(size = 1.5) +
  scale_color_manual(values = c("gold4", "green3", "brown", "blue3","lightskyblue4", "darkgreen", "magenta3", "#E7B800","darkturquoise", "red", "black")) + theme(legend.position = "none") + scale_x_continuous(breaks = seq(0,20,2)) + coord_cartesian(ylim=c(0,300))
p_wrf_east <- ggplot(data_wrf_east, aes(x=data_wrf_east$ï..day, y=accum, color=experiment)) + labs(x="Time (days)", y="Accumulated Rainfall (mm)") + geom_line(size = 1.5) +
  scale_color_manual(values = c("gold4", "green3", "brown", "blue3","lightskyblue4", "darkgreen", "magenta3", "#E7B800","darkturquoise", "red", "black")) + theme(legend.position = "none") + scale_x_continuous(breaks = seq(0,20,2)) + coord_cartesian(ylim=c(0,300))

#Arranging the plots
ggarrange(p_wrf_east, p_3_e, widths = c(1.2, 2))