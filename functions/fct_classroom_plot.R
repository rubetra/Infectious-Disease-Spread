
#############
### Function to plot the classroom, color-coded by the status of students in a given week
### Last modified on 24th May 2023 by Sophie Haldemann
#############

###### OUTLINE ######
# 1. Generate the plot
# 2. Plot it in R
# 3. Save the plot as a file
####################


library(ggplot2)
library(gridExtra)
library(stringr)
library(magick)

classroom_plot_fct <- function(week){
  
  # Turn the week-number into format 01, 02 etc intead of 1,2
  week_number <- str_pad(week, width = 2, pad = "0")
  
  # Add a title
  main_title <- paste0(setting, " setting", ", ", n_rows, " rows")
  
  # 1. Generate the plot
  # Plot the seats (row/col), considering only on-campus students, color-coded by status
  plot <- ggplot(data = students[students$on_campus == 1, ], aes(x = row, y=col, fill= as.factor(old_status)))+
    scale_fill_manual(values = status_colors, breaks = c(0, 1, 2), labels = c("healthy", "infectious", "sick")) +
    geom_tile(color = "white", linewidth = 0.5) +
    labs(fill = "status") + 
    labs(title = paste0(setting, ", ", n_rows, " rows", "\nweek ", week_number)) + 
    theme_void() +
    theme(plot.title = element_text(hjust = 0.5))
  
  # 2. Plot it in R
  print(plot)
  
  # 3. Save the plot as a file
  dir_name <- file.path(getwd(), "classroom_plots", setting, paste0("n_rows_", str_pad(n_rows, width = 2, pad = "0")))
  dir.create(dir_name, recursive = TRUE)
  file_name <- file.path(dir_name, paste0("week_", week_number, ".png"))
  png(file_name, width = 1200, height = 1000, res = 300)
  print(plot)
  dev.off()
  
}  


