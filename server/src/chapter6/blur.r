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

blur <- function(image, sigma) {
  trapezoids <- image_convolve(image, kernels$trapezoids)
  simple_trapezoids <- image_convolve(image, kernels$simple_trapezoids)
  simpson <- image_convolve(image, kernels$simpson)
  simple_simpson <- image_convolve(image, kernels$simple_simpson)
  image_write(trapezoids, "./sample/trapezoids.jpg")
  image_write(simple_trapezoids, "./sample/simple_trapezoids.jpg")
  image_write(simpson, "./sample/simpson.jpg")
  image_write(simple_simpson, "./sample/simple_simpson.jpg")
}
