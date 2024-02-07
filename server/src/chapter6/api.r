#* api.r
source("blur.r")
library(magick)

#* @serializer json list(trapezoids="png",simpson="png",simple_simpson="png",simple_trapezoids="png")
#* @post /chapter6
function(image, sigma = 1) {
  print(image)
  blur(image_read(image[[1]]), sigma)
}
