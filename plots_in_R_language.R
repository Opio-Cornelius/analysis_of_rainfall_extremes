
###### Final single timeseries with different colors ##########
pwr <- ggplot(data_west_reg, aes(x = data_west_reg$Day, y = rain)) + labs(x="Time (Days)", y="Rainfall (mm/day)") + geom_line(aes(color = year)) + 
geom_smooth(method = 'lm', formula = y ~ x, colour ="black", linetype = "dashed", se = FALSE) + scale_x_continuous(breaks = seq(0,920,92))

pwr + scale_color_manual(values = c("gold4", "green3", "brown", "blue3", "#E7B800", "darkgreen", "magenta3", "gray37","darkturquoise", "red")) + 
theme(legend.title = element_blank()) + guides(color = guide_legend(override.aes = list(size = 2))) + coord_cartesian(ylim=c(0,50))

#### with intercept lines #####
pwr + scale_color_manual(values = c("gold4", "green3", "brown", "blue3", "#E7B800", "darkgreen", "magenta3", "gray37","darkturquoise", "red")) + 
theme(legend.title = element_blank()) + guides(color = guide_legend(override.aes = list(size = 2))) + coord_cartesian(ylim=c(0,50)) + 
geom_hline(aes(yintercept=24, linetype = "99th percentile"), colour = "black") + geom_hline(aes(yintercept=0.2, linetype = "20th percentile"), colour = "black")

###### Final for extreme visualization- jitter plots ##########

pw <- ggplot(data_west, aes(x=year, y=rain, color=year)) + labs(x="Time (years)", y="Rainfall (mm/day)") + geom_jitter()
pw + scale_color_manual(values = c("gold4", "green3", "brown", "blue3", "#E7B800", "darkgreen", "magenta3", "gray37","darkturquoise", "red")) + 
theme(legend.title = element_blank()) + geom_hline(aes(yintercept=24)) + 
scale_y_continuous(breaks = sort(c(ggplot_build(pw)$layout$panel_ranges[[1]]$y.major_source, 24))) + 
guides(color = guide_legend(override.aes = list(size = 2)))


##### Final for dotplot ##############
pwdot <- ggplot(data_west, aes(x=year, y=rain, color=year)) + labs(x="Time (years)", y="Rainfall (mm/day)") + 
geom_dotplot(binaxis = "y", stackdir = "center", binwidth = 0.5)


###### Final for three timeseries on one plot ########

pthree <- ggplot(data_cyc, aes(x=day, y=rain, color=region)) + labs(x="Time (days)", y="Rainfall (mm/day)") + geom_line(size = 1.5)

pthree + scale_color_manual(values = c("#E7B800", "#00AFBB", "green4")) + theme(legend.title = element_blank()) + 
guides(color = guide_legend(override.aes = list(size = 1.3))) + scale_x_continuous(breaks = seq(0,92,30)) + theme(legend.position="bottom")

##### For single versions #######
p_cyc_west <- ggplot(data_cyc_west, aes(x=data_cyc_west$ï..day, y=rain)) + labs(x="Time (days)", y="Rainfall (mm/day)") + geom_line(size = 3, colour = "#E7B800")
p_cyc_west + scale_x_continuous(breaks = seq(0,92,30)) + coord_cartesian(ylim=c(0,12)) + 
geom_smooth(method = 'lm', formula = y ~ x, colour ="black", linetype = "dashed", se = FALSE)


###### Final for anomaly box plots ######################

p_an_ce <- ggplot(data_an_ce, aes(x=year, y=rain, fill=month)) + labs(x="Time (years)", y="Rainfall Anomaly (mm/day)") + geom_bar(stat = "identity")

p_an_ce + theme(legend.title = element_blank()) + scale_x_continuous(breaks = seq(1998,2017,2)) + coord_cartesian(ylim=c(-6,8)) + theme(legend.position="bottom")


###### Slight changes for anomaly box plots (normalized) #############

 p_an_ea <- ggplot(data_an_ea, aes(x=data_an_ea$ï..year, y=rain, fill=month)) + labs(x="Time (years)", y="Rainfall Anomaly (mm/day)") + geom_bar(stat = "identity")
 p_an_ea + theme(legend.title = element_blank()) + scale_x_continuous(breaks = seq(1998,2017,2)) + coord_cartesian(ylim=c(-5,4)

####### Emergency jitter plot with intercepts) #######
ggplot(data_west_reg, aes(x=year, y=rain, color=year)) + 
                                        labs(x="Time (years)", y="Rainfall (mm/day)") + geom_jitter(height = 0.5) + 
                                        geom_hline(aes(yintercept=0.2)) + geom_hline(aes(yintercept=24)) + scale_y_continuous(breaks = sort(c(ggplot_build(pw)$layout$panel_ranges[[1]]$y.major_source, 24))) + 
                                        scale_color_manual(values = c("gold4", "green3", "brown", "blue3", "#E7B800", "darkgreen", "magenta3", "gray37","darkturquoise", "red")) + 
                                                                                                                   expand_limits(y = 0)
