ord <- function(points) {
  points <- points[, order(points[1, ])]
}

generate <- function(f, a, b, intervals, mode = "trapazoid") {
  if (mode == "simpson") {
    intervals <- intervals * 2
  }
  h <- abs(b - a) / intervals
  return(sapply(seq(a, b, h), function(x) return(c(x, f(x)))))
}

trapezoids <- function(points) {
  if (length(points[1, ]) < 2) {
    stop("expected at least 2 points")
  }
  points <- ord(points)
  a <- points[1, 1]
  h <- abs(a - points[1, 2])
  r <- as.integer(abs(a - points[1, length(points[1, ])]) / h)

  # f(a)
  sum <- points[2, 1]

  # sum += 2 * sum(f(a + i * h))
  for (i in seq_len(r - 1)) {
    sum <- sum + 2 * points[2, i + 1]
  }

  # sum += f(b)
  sum <- sum + points[2, length(points[1, ])]

  return((h / 2) * (sum))
}

simpson <- function(points) {
  if (length(points[1, ]) < 3) {
    stop("expected at least 3 points")
  }
  points <- ord(points)
  h <- abs(points[1, 1] - points[1, 3])
  r <- as.integer(abs(points[1, 1] - points[1, length(points[1, ])]) / h)

  sum <- points[2, 1]

  # sum += 4 * f(a + (i - 0.5 * h)) + 2 * f(a + i * h)
  # i selects a pair of (f(a + (i - 0.5 * h)), f(a + i * h))
  # this includes f(b)
  for (i in seq_len(r)) {
    sum <- sum + 4 * points[2, 2 * i] + 2 * points[2, 2 * i + 1]
  }

  # so subtract f(b)
  sum <- sum - points[2, length(points[1, ])]

  return((h / 6) * sum)
}

simple_trapezoids <- function(points) {
  if (length(points[1, ]) != 2) {
    stop(sprintf(
      "trapezoids: expected 2 points, gotten %g",
      length(points[1, ])
    ))
  }
  return(trapezoids(points))
}

simple_simpson <- function(points) {
  if (length(points[1, ]) != 3) {
    stop(sprintf(
      "simpon: expected through points, gotten %g",
      length(points[1, ])
    ))
  }
  points <- ord(points)
  return(simpson(points))
}

integrate <- function(f, a, b, r, mode) {
  result <- switch(
    mode,
    "simple_simpson" = simple_simpson(
      generate(f, a, b, 1, "simpson")
    ),
    "simple_trapezoids" = simple_trapezoids(
      generate(f, a, b, 1)
    ),
    "trapezoids" = trapezoids(
      generate(f, a, b, r)
    ),
    "simpson" = simpson(
      generate(f, a, b, r, "simpson")
    )
  )
  return(result)
}
