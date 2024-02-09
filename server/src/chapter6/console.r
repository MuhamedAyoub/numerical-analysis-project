
args <- commandArgs(trailingOnly = TRUE)

# Rscript console.r [image path] sigma
if (length(args) == 2) {
  sigma <- as.numeric(args[2])
  if (sigma < 0 || sigma > 2) {
    stop("invalid sigma value")
  }
  image <- magick::image_read(args[1])
} else {
  sigma <- 1
}


source(sprintf("%s/blur.r", getwd()))
blur(image, sigma)
print("done")
