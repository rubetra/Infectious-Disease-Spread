
#############
### Function to calculate the average number of neighbors within threshold
### Last modified on 24th May 2023 by Sophie Haldemann
#############

# Calculate the average number of neighbors within threshold
# As it is different depending on if the infected student sits in the corner or 
# in the center of the classroom

# This average number is used to determine the fixed beta:
# Class-specific basic reproduction number (R0) for traditional class setting: ~ 3 (Hekmati et al., 2022) 
# = number of infections caused by an infectious individual
# Transmission threshold: 2 (Assumed)
# Average number of neighbors within transmission threshold: ~11 (derived from simulation below)
# Beta = 3 / 11 ≈ 0.27


average_neighbors <- function(n_rows, threshold) {
  classroom <- expand.grid(x = 1:n_rows, y = 1:n_rows)
  distances <- as.matrix(dist(classroom))
  
  # exclude infectious student himself and students further away than threshold
  distances[distances == 0 | distances > threshold] <- NA
  
  # count the seats within the threshold distance
  nearby_seats <- rowSums(!is.na(distances))
  
  return(mean(nearby_seats))
}



# As the R0 is for a traditional class setting, I assume number of rows between 18 and 20
# i.e. a classroom size with between 324 and 400 seats for a class of 300 students
average_neighbors(18, 2)
average_neighbors(20, 2)
# ~11


