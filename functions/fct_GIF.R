#############
### Function to create and save a GIF animation of weekly plots
### Last modified on 24th May 2023 by Sophie Haldemann
#############

library(ggplot2)
library(gridExtra)
library(stringr)
library(magick)

GIF_function <- function(){
  path <- file.path(getwd(), "classroom_plots", setting, paste0("n_rows_", str_pad(n_rows, width = 2, pad = "0")))
  imgs <- list.files(path, full.names = TRUE)
  
  img_list <- lapply(imgs, image_read)
  
  ## join the images together
  img_joined <- image_join(img_list)
  
  ## animate at 2 frames per second
  img_animated <- image_animate(img_joined, fps = 2)
  
  ## save to disk
  gif_file <- file.path(path, "classroom_animation.gif")
  
  image_write(image = img_animated, path = gif_file)
  
}