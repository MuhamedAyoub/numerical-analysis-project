points <- function(...) {
  points <- vector(mode = "list", length = ...length())
  for (i in seq_len(...length())) {
    points[[i]] <- ...elt(i)
  }
  points <- points[order(sapply(points, `[`, 1))]
}

trapezoids <- function(...) {
  if (...length() < 2) {
    stop("expected at least 2 points")
  }
  p <- points(...)
  a <- p[[1]][1]
  h <- abs(a - p[[2]][1])
  r <- as.integer(abs(a - p[[...length()]][1]) / h)

  # sum = f(a)
  sum <- p[[1]][2]

  # sum += 2 * sum(f(a + i * h))
  for (i in 1:(r - 1)) {
    if (a + i * h != p[[i + 1]][1]) {
      stop("step is not of equal size for all points")
    }
    sum <- sum + 2 * p[[i + 1]][2]
  }

  # sum += f(b)
  sum <- sum + p[[...length()]][2]

  return((h / 2) * (sum))
}

simpson <- function(...) {
  if (...length() < 3) {
    stop("expected at least 3 points")
  }
  p <- points(...)
  a <- p[[1]][1]
  h <- abs(p[[1]][1] - p[[3]][1])
  r <- as.integer(abs(p[[1]][1] - p[[...length()]][1]) / h)

  sum <- p[[1]][2]

  # sum += 4 * f(a + (i - 0.5 * h)) + 2 * f(a + i * h)
  # i selects a pair of (f(a + (i - 0.5 * h)), f(a + i * h))
  # this includes f(b)
  for (i in 1:r) {
    if ((a + (i - (1 / 2)) * h) != p[[2 * i]][1]) {
      stop(sprintf("point %g violiates specified step", 2 * i))
    }
    if ((a + i * h != p[[2 * i + 1]][1])) {
      stop(sprintf("point %g violiates specified step", 2 * i + 1))
    }

    sum <- sum + 4 * p[[2 * i]][2] + 2 * p[[2 * i + 1]][2]
  }

  # so subtract f(b)
  sum <- sum - p[[...length()]][2]

  return((h / 6) * sum)
}

integerate <- function(...) {
  result <- list("trapezoids" = trapezoids(...), "simpson" = simpson(...))
  return(result)
}
