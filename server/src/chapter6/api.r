#* api.r
source("blur.r")
library(magick)

#* @serializer contentType list(type="image/jpeg")
#* @post /chapter6
function(image, sigma = 1) {
  print(image)
  blur(image_read(image[[1]]), sigma)
}
