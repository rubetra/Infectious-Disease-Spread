#############
### Script to plot the average number of infections per student
### Based on the summary_per_size table obtained by the Simulation_multiweek script

### That is the number of infections per class summed over all weeks, divided by n_students
### This is done for several iterations in the simulation -> from these simulations, get the average value and SE
### Bar plot with number of rows on x-axis, and average number of infections per student on y-axis with SE-errorbar
### Bars are color-coded by setting (traditional vs. hyflex)

### Last modified on 24th May 2023 by Sophie Haldemann
#############



# Load the necessary libraries
library(ggplot2)
library(dplyr)

source("functions/fct_stats.R")
source("assumptions_and_variables.R")

# The summary_per_size table is obtained by the Simulation_multiweek script !

# Calculate the mean and SD for each setting and n_rows combination
summary_stats <- stats(summary_per_size)

# Create a bar plot with error bars
plot <- ggplot( summary_stats, aes( x = as.factor(n_rows), y = mean_infections_per_student, fill = setting )) +
  geom_bar(stat = "identity", position = "dodge", width = 0.5) +
  geom_errorbar(aes(ymin = mean_infections_per_student - SE_infections_per_student, 
                    ymax = mean_infections_per_student + SE_infections_per_student), 
                position = position_dodge(width = 0.5), width = 0.3) +
  scale_fill_manual(values = color_per_setting) +  
  theme_bw() +
  
  # add labels
  labs(x = "number of rows", 
       y ="",
       title = paste("average number of infections per student over", n_simulations, "simulations (mean +/- SE)"), 
       fill = "setting") +
  
  # center the title
  theme(plot.title = element_text(hjust = 0.5))

print(plot)

