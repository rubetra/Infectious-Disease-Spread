
### Defining assumptions and variables ###
### Last modified on 23.05.2023 by Sophie Haldemann ###

### OUTLINE
# 1. Assumptions
# 2. Definitions of variables
# 3. Assigned values of base variables




### 1. Assumptions 
# - Square classroom

# - Fixed beta (0.27)

# - Simulation runs for 14 weeks (semester)

# - HyFlex setting: students have a certain (fixed) preference, i.e. fully online, fully onsite or hybrid
#   Hybrid students have a certain probability of being on campus in a given week, given non-sick
#   In the hybrid setting, students are assumed to not miss any classes (due to podcasts)

# - Traditional setting: students have no choice (fully onsite)
#   There's a chance a stick student goes to class despite being sick (to not miss any class)

# - Note: I will use the term "onsite student" for students with preference 1, 
#   and "on campus" to describe whether a (non-sick hybrid or onsite) student is currently on campus

# - There is 3 weeks cross-immunity after recovery (Eggo et al., 2016)
#   And assuming infected/sick people can't get re-infected either:
#   Timeline: susceptible -> infected -> sick -> immune -> immune -> immune -> susceptible
#   Immunity:           0 ->        5 ->    4 ->      3 ->      2 ->      1 ->           0


### 2. Definitions of variables
# - beta: probability that an uninfected agent becomes infected given contact with one infected agent.
# - dist_threshold: how far the virus spreads
# - immunity: 0 = susceptible, non-0 = immune
# - n_patients_0: number of patient zeros
# - on_campus: 0 = no (sick, online, or hybrid student), 1 = yes (onsite or hybrid student, can be sick in traditional setting)
# - p_oncampus_hybrid: probability that a hybrid student is coming on campus in a given week
# - p_oncampus_sick: probability that a sick student is coming on campus despite being sick (≠0 in traditional setting)
# - p_per_pref: probabilities that a given student is a fully-online, fully-onsite or hybrid student
# - preference: 0 = fully online, 1 = fully onsite, 2 = hybrid
# - setting: traditional or hyflex
# - status: 0 = healthy, 1 = infectious but asymptomatic, 2 = sick


### 3. Assigned values of base variables

# rm(list = ls())

row_range <- seq(14, 27)
n_students <- 300
dist_threshold <- 2 
beta <- 0.2
n_weeks <- 14
p_oncampus_hybrid <- 0.5
status_colors <- c("0" = "#E2F5D5", "1" = "#FAD7A0", "2" = "#E5D9FE")
color_per_setting <- c("#83D3C2", "#E79068")
n_simulations <- 100

# Dictionary with parameters based on class setting
dict <- list(
  traditional = list( p_per_pref = c(0, 1, 0), 
                      n_patients_0 = 3 , 
                      p_oncampus_sick = 0.2),

  hyflex = list( p_per_pref = c(1/3, 1/3, 1/3), 
                 n_patients_0 = 2, 
                 p_oncampus_sick = 0 ) )














