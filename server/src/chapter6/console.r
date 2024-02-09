
args <- commandArgs(trailingOnly = TRUE)

# Rscript console.r [image path] sigma
sigma <- as.numeric(args[2])
image <- magick::image_read(args[1])

source(sprintf("%s/blur.r", getwd()))
blur(image, sigma)
print("done")
