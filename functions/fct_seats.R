#############
### Function to create a square classroom with seats (n_rows X n_rows)
### And assigns a unique seatID to each seat
### Last modified on 24th May 2023 by Sophie Haldemann
#############


seats_function <- function(n_rows){
  seats <- expand.grid(rows=1:n_rows, cols=1:n_rows)
  seats$ID <- 1:nrow(seats)
  return(seats)
}