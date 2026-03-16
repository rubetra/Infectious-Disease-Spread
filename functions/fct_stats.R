
#############
### Function to create the summary statistics 
### Calculates the mean and SD of number of infections and missed classes per student
### Grouped by classroom size (n_rows) and setting (traditional, hyflex)
### Last modified on 24th May 2023 by Sophie Haldemann
#############



# Get the summary statistics
stats <- function(summary_per_size){
  
  stats <- summary_per_size %>%
    group_by(n_rows, setting) %>%
    summarise(mean_classes_missed_per_student = mean(sum_classes_missed/n_students, na.rm = TRUE), 
              SE_classes_missed_per_student = sd(sum_classes_missed/n_students, na.rm = TRUE)/sqrt(n_simulations),
              
              mean_infections_per_student = mean(sum_infections/n_students, na.rm = TRUE), 
              SE_infections_per_student = sd(sum_infections/n_students, na.rm = TRUE )/sqrt(n_simulations)
              )
  
  return(stats)
  
}
