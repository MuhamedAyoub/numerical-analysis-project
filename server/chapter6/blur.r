integrate <- function(f, a, b, r, mode) return()

source("./integrate.r")

gaussian <- function(x, sig) {
  return((1 / (sig * sqrt(2 * pi))) * exp((-1 / 2) * (((x - sig) / sig) ^ 2)))
}

kernel <- function(mode, sig = 1, width = 4) {
  # number of kernel values
  size <- 5 * 5
  a <- -(abs(width / 2))
  h <- width / size
  result <- matrix(
    ncol = 5,
    nrow = 5,
    sapply(
      seq_len(size),
      function(i) {
        return(integrate(
          function(x) return(gaussian(x, sig)),
          a + (i - 1) * h, a + i * h, 3, mode
        ))
      }
    )
  )

  # normalization
  return((1 / sum(result)) * result)
}

sigma <- 1

library(magick)
kernels <- list(
  trapezoids = kernel("trapezoids", sigma),
  simple_trapezoids = kernel("simple_trapezoids", sigma),
  simpson = kernel("simpson", sigma),
  simple_simpson = kernel("simple_simpson", sigma)
)

blur <- function(image) {
  new_image <- image_convolve(image, kernels$trapezoids)
  image_write(new_image, "./trapezoids.jpg")

  new_image <- image_convolve(image, kernels$simple_trapezoids)
  image_write(new_image, "./simple_trapezoids.jpg")

  new_image <- image_convolve(image, kernels$simpson)
  image_write(new_image, "./simpson.jpg")

  new_image <- image_convolve(image, kernels$simple_simpson)
  image_write(new_image, "./simple_simpson.jpg")
}

image <- image_read(
  "./sample.jpg"
)
