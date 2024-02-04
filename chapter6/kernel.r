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

args <- commandArgs(trailingOnly = TRUE)
paste(
  collapse = ";",
  kernel(
    args[1],
    if (length(args) > 1) as.integer(args[2])
  )
)
