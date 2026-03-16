
#############
### Script to produce a gridplot of the classroom after each week
### For a given class setting and a given classroom size (number of rows)
### Plots show a grid of the seats of the on-campus students color-coded by status (infected, healthy, sick)
### Last modified on 24th May 2023 by Sophie Haldemann
#############

###### OUTLINE ######

##### 1. Define parameters
##### 2. Initialise students dataframe with preferences
##### 3. Create classroom seats depending on number of rows
##### 4. Looping over several weeks:
         # Run infection spread simulation
         # Print and save a plot of the classroom, showing which students are healthy/infected/sick/at home
##### 5. Create GIF (spanning all weeks) and save it

####################



# Load libraries
library(ggplot2)
library(gridExtra)
library(stringr)
library(magick)

source("assumptions_and_variables.R")
source("functions/fct_initialise_df.R")
source("functions/fct_seats.R")
source("functions/fct_week_of_infections.R")
source("functions/fct_classroom_plot.R")
source("functions/fct_GIF.R")

set.seed(0)

##### 1. Define parameters
setting <- "hyflex"
n_rows <- 20


# Parameters unique for class setting
# For each class setting, define student preferences
# In traditional setting, all students are onsite-only students
# In traditional setting, p_oncampus_sick (probability that a sick student goes on campus despite being sick) is ≠ 0
p_per_pref <- dict[[setting]]$p_per_pref
n_patients_0 <- dict[[setting]]$n_patients_0
preference <- sample(c(0,1,2), n_students, prob = p_per_pref, replace = TRUE )
n_online <- sum(preference == 0)
n_onsite <- sum(preference == 1)
n_hybrid <- sum(preference == 2)
p_oncampus_sick <- dict[[setting]]$p_oncampus_sick

##### 2. Initialise students dataframe with preferences
students <- initialise_df()

# Assign preferences obtained by pref_function    
students$preference <- preference

##### 3. Create classroom seats depending on number of rows
seats <- seats_function(n_rows)

##### 4. Looping over several weeks
for (week in c(1:n_weeks)){
  
  # Simulate one week and update the students dataframe
  students <- week_of_infections(week, n_rows, setting, students)
  
  # Classroom plot
  # Plot the classroom grid and color-code by status (green = healthy, orange = infected, purple = sick, white = at home)
  # Save weekly plot as files in subfolders named after setting and number of rows 
  classroom_plot_fct(week)
  
}

##### 5. Create GIF (spanning all weeks) and save it
GIF_function()

# The warnings are about the directory already existing
# It will be overwritten so it's okay

