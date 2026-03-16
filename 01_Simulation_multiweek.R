#############
### Script to simulate infection spreading over several weeks
### Last modified on 24th May 2023 by Sophie Haldemann
#############

###### OUTLINE ######

##### 1. Initialise summary dataframe to store summed up results over all weeks
##### 2. Looping over several simulations
##### 3. Looping over traditional and hyflex setting
##### 4. Define parameters unique for class setting
##### 5. Looping over different classroom sizes (n_rows)
##### 6. Skipping over n_rows that are too small for the class setting
##### 7. Initialise students dataframe with preferences
##### 8. Create classroom seats depending on number of rows
##### 9. Looping over several weeks using the week_of_infections function
##### 10. Updating the summary dataframe
##### 11. Show the summary result

####################

# rm(list = ls())

set.seed(3)

# Load custom R-scripts with functions and variables
source("assumptions_and_variables.R")
source("functions/fct_initialise_df.R")
source("functions/fct_seats.R")
source("functions/fct_week_of_infections.R")



##### 1. Initialise summary dataframe to store summed up results over all weeks
summary_per_size <- data.frame(
  sim_iteration = integer(0),
  setting = character(0), 
  n_rows = integer(0), 
  sum_infections = integer(0),
  sum_classes_missed = integer(0)
)



########## 2. Looping over several simulations ########## 
for (iter in 1:n_simulations){
  
  ########## 3. Traditional or hyflex setting ########## 
  for (setting in c("traditional", "hyflex")){ 
    
    ##### 4. Define parameters unique for class setting
    # For each class setting, define student preferences
    # In traditional setting, all students are onsite-only students
    # In traditional setting, p_oncampus_sick (probability that a sick student goes on campus despite being sick) is ≠ 0

    p_per_pref <- dict[[setting]]$p_per_pref
    n_patients_0 <- dict[[setting]]$n_patients_0
    preference <- sample(c(0,1,2), n_students, prob = p_per_pref, replace = TRUE )
    n_online <- sum(preference == 0) # number of fully-online students
    n_onsite <- sum(preference == 1)
    n_hybrid <- sum(preference == 2)
    p_oncampus_sick <- dict[[setting]]$p_oncampus_sick
   
    ########## 5. Different classroom sizes ##########
    for ( n_rows in row_range ){
      
      ##### 6. Skipping over n_rows that are too small for the class setting
      # The room needs to be big enough in case every hybrid student decides to come to campus
      # If it's too small, get NA for the result_per_week and summary dataframe, and skip to the next n_rows size
      max_students_on_campus <- n_onsite
      if (n_rows * n_rows < max_students_on_campus){
        summary_per_size <- rbind(summary_per_size, data.frame(sim_iteration = iter, setting = setting, n_rows = n_rows, sum_infections = NA, sum_classes_missed = NA))
        
        next
      }
      
      ##### 7. Initialise students dataframe with preferences
      # Initialise students dataframe
      students <- initialise_df()
      
      # Assign preferences obtained by pref_function    
      students$preference <- preference
      
      ##### 8. Create classroom seats depending on number of rows
      seats <- seats_function(n_rows)
      
      
      ##########  9. Looping over several weeks ########## 
      # Running simulation of infection spread over several weeks
      for (week in c(1:n_weeks)){
        students <- week_of_infections( week, n_rows, setting, students )

      }
      
      ##### 10. Updating the summary dataframe
      # Sums up the infections over all weeks, for a given setting, classroom size, and iteration:
      summary_per_size <- rbind(summary_per_size, 
                                data.frame(sim_iteration = iter,
                                           setting = setting,
                                           n_rows = n_rows,
                                           sum_infections = sum(students$n_infections),
                                           sum_classes_missed = sum(students$n_classes_missed)))
      
    }
    
  }
  
}


##### 11. Show the summary result
# NAs for those situations where the class room is too small for the number of students
head(summary_per_size)
