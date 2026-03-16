#############
### Function to simulate the infection spreading over a week
### Last modified on 24th May 2023 by Sophie Haldemann
#############

###### OUTLINE ######
#
# 1. Define which student is present on campus in current week
# 2. At the start: define infectious patients_0
# 3. Assign seats to students on campus
# 4. Count missed classes
# 5. Calculate the distances between students
# 6. Calculate the number of exposures
# 7. Exposed students becoming infected, depending on beta and n_exposures
# 8. Update statuses, immunity, and number of infections
# 9. Return the updated dataframe

####################

week_of_infections <- function(week, nrows, setting, students){
  
  
  ##### 1. Define which student is present on campus in current week
  # Sick students in hyflex setting are at home (p_oncampus_sick = 0)
  # Sick students in traditional setting sometimes come to campus despite being sick (p_oncampus_sick ≠ 0)
  # Non-sick hybrid students are either at home or on campus (p_oncampus_hybrid)
  # Non-sick onsite students are on campus
  students$on_campus <- ifelse(students$status == 2 , rbinom(n = sum(students$status == 2), size = 1, prob = p_oncampus_sick), 
                               ifelse(students$preference == 2, rbinom(n = n_hybrid, size = 1, prob = p_oncampus_hybrid), 
                                      students$preference ))
  
  ##### 2. At the start: an initial number of students on campus are defined as infectious patients_0
  if (week == 1){
    patients_0 <- sample(students$student_ID[students$on_campus == 1], n_patients_0 )
    students$status[patients_0] <- 1
    students$n_infections[patients_0] <- 1
  }
  
  ##### 3. Assign seats to students on campus
  students$seat_ID[students$on_campus == 1] <- sample(seats$ID, 
                                                      nrow(students[students$on_campus == 1,]), 
                                                      replace = FALSE)
  
  students$row <- seats$rows[students$seat_ID]
  students$col <- seats$cols[students$seat_ID]
  
  
  ##### 4. Count missed classes
  # Only for traditional setting (in hyflex setting there are podcasts, thus assumed no missed classes):
  # Counting one missed class for students who are currently sick
  # Except for those who decided to come to class anyway
  if (setting == "traditional"){
    condition <- students$status == 2 & students$on_campus == 0
    students$n_classes_missed[condition] <- students$n_classes_missed[condition]  + 1
  }
  
  
  ##### 5. Calculate the distances between students
  distances <- as.matrix(dist(students[, c("row", "col")]))
  
  # Only students who are healthy, on campus, and not immune can become infected
  condition_students <- !students$status & students$on_campus & !students$immunity
  
  # Reduce to an [n_on_campus_susceptible x n_on_campus_infectious] matrix
  # In traditional setting: Those students who come to class despite being sick (status 2) are also infectious 
  distances <- distances[which(condition_students) , 
                         which(students$on_campus == 1 & (students$status == 1 | students$status == 2)), drop = FALSE]
  
  
  ##### 6. Calculate the number of exposures
  # Number of exposures = how many infectious students are within transmission threshold
  students$n_exposures[condition_students] <- rowSums(distances <= dist_threshold)
  
  # Save current status
  students$old_status <- students$status
  
  ##### 7. Exposed students become infected depending on beta and n_exposures
  # Changing status of healthy, on-campus, susceptible students to infectious or healthy
  # The probability of catching the disease depends on beta and the number of exposures
  p_catch_disease <- 1 - (1 - beta) ^ students$n_exposures[condition_students]
  students$status[condition_students] <- rbinom(n = sum(condition_students), size = 1, prob = p_catch_disease)
  
  ##### 8. Update statuses, immunity, and number of infections
  # Changing status of infectious -> sick ; sick -> healthy
  students$status[students$old_status == 1] <- 2
  students$status[students$old_status == 2] <- 0
  
  # Count-down for those with immunity
  students$immunity[students$immunity != 0] <- students$immunity[students$immunity != 0] - 1
  
  # Newly infected students receive immunity
  students$immunity[students$status == 1] <- 5
  
  # Counting one infection for newly infected students
  students$n_infections[students$status==1] = students$n_infections[students$status==1] + 1
  
  
  ##### 9. Return the updated dataframe
  return(students)
  
}


