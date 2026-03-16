
#############
### Function to initialise the empty dataframe "students"
### Last modified on 24th May 2023 by Sophie Haldemann
#############


# Initialise students dataframe
initialise_df <- function(){
  students <- data.frame( "student_ID" = 1:n_students,
                          "seat_ID" = NA,
                          "row" = NA,
                          "col" = NA,
                          "preference" = NA,
                          "on_campus" = NA,
                          "status" = 0,
                          "old_status" = 0,
                          "immunity" = 0,
                          "n_exposures" = 0,
                          "n_infections" = 0,
                          "n_classes_missed" = 0)
  return(students)
  
}