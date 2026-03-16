

#############
### Script to plot the average number of classes missed per student in the traditional setting
### In the hyflex setting, it is assumed that no classes are missed due to podcasts
### Bar plot with number of rows (classroom size) on x-axis, and number of missed classes per student on y-axis

### Last modified on 24th May 2023 by Sophie Haldemann
#############


library(ggplot2)
library(dplyr)

source("functions/fct_stats.R")
source("assumptions_and_variables.R")

# The summary_per_size table is obtained by the Simulation_multiweek script !

# Calculate the mean and SD for each setting and n_rows combination
summary_stats <- stats(summary_per_size)

# Consider only the traditional setting
summary_stats_trad <- summary_stats %>% filter(setting == "traditional")

# Plot average number of missed classes per student, with error bars
plot <- ggplot(summary_stats_trad, aes( x = as.factor(n_rows), y = mean_classes_missed_per_student, fill = setting )) +
  geom_bar(stat = "identity", position = "dodge", width = 0.5) +
  geom_errorbar(aes(ymin = mean_classes_missed_per_student - SE_classes_missed_per_student, 
                    ymax = mean_classes_missed_per_student + SE_classes_missed_per_student), 
                position = position_dodge(width = 0.5), width = 0.3) +
  scale_fill_manual(values = color_per_setting[2]) +  
  theme_bw() +
  
  # add labels
  labs(x = "number of rows", 
       y ="",
       title = paste("average number of missed classes per student over", n_simulations, "simulations (mean +/- SE)"), 
       fill = "setting") +
  
  # center title
  theme(plot.title = element_text(hjust = 0.5))

print(plot)


