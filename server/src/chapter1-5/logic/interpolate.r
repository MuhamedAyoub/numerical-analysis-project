ord <- function(points) {
  return(points[, order(points[1, ])])
}

mul <- function(p, q) {
  m <- matrix(p, ncol = 1) %*% q
  result <- c(NULL)
  for (i in seq_len(nrow(m))) {
    for (j in seq_len(ncol(m))) {
      if (length(result) < i + j - 1) {
        result <- c(result, m[i, j])
        next
      }
      result[i + j - 1] <- result[i + j - 1] + m[i, j]
    }
  }
  return(c(result))
}

sum <- function(p, q) {
  if (length(p) == length(q)) {
    result <- p + q
    result <- result[1:Position(function(x) x != 0.0, result, right = TRUE)]
    return(if (length(result[result == 0]) == length(result)) c(0) else result)
  }

  min_length <- min(length(p), length(q))
  result <- c(
    p[seq_len(min_length)] + q[seq_len(min_length)],
    if (length(p) != min_length) p[(min_length + 1):length(p)] else NULL,
    if (length(q) != min_length) q[(min_length + 1):length(q)] else NULL
  )
  result <- result[1:Position(function(x) x != 0.0, result, right = TRUE)]
  return(if (length(result[result == 0]) == length(result)) c(0) else result)
}

pretty <- function(coefficients) {
  i <- 0
  coefficients <- Filter(
    function(x) return(x != ""),
    sapply(
      as.vector(mode = "any", coefficients),
      function(x) {
        i <<- i + 1
        result <- ""
        if (x != 0) {
          result <- paste(result, if (x != 1 || i - 1 == 0) x else "", sep = "")
          if (i - 1 != 0) {
            result <- paste(
              result,
              "X",
              if (i - 1 != 1) paste("^", (i - 1), sep = "") else "",
              sep = ""
            )
          }
        }
        return(result)
      }
    )
  )
  return(paste(coefficients, collapse = " + "))
}

lagrange <- function(points) {
  points <- ord(points)
  result <- c(NULL)
  output <- c(NULL)
  time <- 0
  for (i in seq_len(length(points[1, ]))) {
    stime <- Sys.time()
    weight <- c(1)
    for (j in seq_len(length(points[1, ]))) {
      if (j != i) {
        weight <- mul(
          weight,
          (1 / (points[1, i] - points[1, j])) * c(- points[1, j], 1)
        )
      }
    }
    time <- time + (Sys.time() - stime)
    output <- c(output, sprintf("l%g(x) = %s", i, pretty(weight)))
    stime <- Sys.time()
    result <- sum(result, weight * points[2, i])
    time <- time + (Sys.time() - stime)
  }
  result <- list(
    result = result,
    time = as.numeric(time),
    output = output
  )
  return(result)
}

newton_algo <- function(points) {
  points <- ord(points)
  execution <- matrix(c(points[2, ]), nrow = length(points[1, ]))
  header <- c("x", "f[x0]")
  result <- points[2, 1]
  time <- 0

  # first column are already filled
  for (i in seq(2, length(points[1, ]))) {
    header <- c(
      header,
      sprintf(
        "f[%s]",
        paste(
          sapply(
            seq(0, i - 1),
            function(i) return(sprintf("x%g", i))
          ),
          collapse = ", "
        )
      )
    )

    stime <- Sys.time()
    # starts calculating at position [2, 2] before should be empty
    column <- rep(0, i - 1)
    for (j in seq(i, length(points[1, ]))) {
      cell <- (execution[j, i - 1] - execution[j - 1, i - 1]) /
        (points[1, j] - points[1, j - (i - 1)])
      if (j == i) {
        result <- c(result, cell)
      }

      column <- c(
        column,
        cell
      )
    }
    time <- time + (Sys.time() - stime)
    execution <- cbind(execution, column)
  }

  execution <- cbind(points[1, ], execution)
  execution <- rbind(header, execution)

  result <- list(
    result = result,
    time = as.numeric(time),
    output = execution
  )
  return(result)
}

fdf <- function(points) {
  points <- ord(points)
  execution <- matrix(c(points[2, ]), nrow = length(points[1, ]))
  header <- c("x", "f[x0]")
  result <- points[2, 1]
  time <- 0

  # first 2 column are already filled
  for (i in seq(2, length(points[1, ]))) {
    header <- c(
      header,
      sprintf(
        "f[%s]",
        paste(
          sapply(
            seq(0, i - 1),
            function(i) return(sprintf("x%g", i))
          ),
          collapse = ", "
        )
      )
    )

    stime <- Sys.time()
    # starts calculating at position [2, 2] before should be empty
    column <- rep(0, i - 1)
    for (j in seq(i, length(points[1, ]))) {
      cell <- execution[j, i - 1] - execution[j - 1, i - 1]
      if (j == i) {
        result <- c(result, cell)
      }

      column <- c(
        column,
        cell
      )
    }
    time <- time + (Sys.time() - stime)
    execution <- cbind(execution, column)
  }

  execution <- cbind(points[1, ], execution)
  execution <- rbind(header, execution)

  result <- list(
    result = result,
    time = as.numeric(time),
    output = execution
  )
  return(result)
}

divided_diff <- function(points) {
  stime <- Sys.time()
  points <- ord(points)
  time <- Sys.time() - stime

  result <- newton_algo(points)
  coefficients <- result$result
  time <- time + result$time
  output <- result$output
  poly <- c(1)
  result <- c(0)

  stime <- Sys.time()
  for (coeff in seq_len(length(coefficients))) {
    if (coeff > 1) {
      poly <- mul(poly, c(-points[1, coeff - 1], 1))
    }
    result <- sum(result, coefficients[coeff] * poly)
  }
  time <- time + (Sys.time() - stime)

  result <- list(
    result = result,
    time = as.numeric(time),
    output = output
  )
  return(result)
}

finite_diff <- function(points) {
  stime <- Sys.time()
  points <- ord(points)
  a <- points[1, 1]
  h <- abs(a - points[1, length(points[1, ])]) / (length(points[1, ]) - 1)
  for (i in 2:length(points[1, ])) {
    if (a + (i - 1) * h != points[1, i]) {
      return(list(
        error = "points are not equidistant"
      ))
    }
  }
  time <- Sys.time() - stime

  result <- fdf(points)
  coefficients <- result$result
  time <- time + result$time
  output <- result$output
  poly <- c(1)
  result <- c(0)

  stime <- Sys.time()
  for (coeff in seq_len(length(coefficients))) {
    if (coeff > 1) {
      poly <- mul(poly, c(-points[1, coeff - 1], 1))
    }
    result <- sum(
      result,
      (coefficients[coeff] / ((h ^ (coeff - 1)) * factorial(coeff - 1))) * poly
    )
  }
  time <- time + (Sys.time() - stime)

  result <- list(
    result = result,
    time = as.numeric(time),
    output = output
  )
  return(result)
}

interpolate <- function(attribute, points) {
  result <- list(
    lagrange = lagrange(points),
    divided_diff = divided_diff(points),
    finite_diff = finite_diff(points)
  )

  polynomial <- result$divided_diff$result
  result$lagrange$result <- pretty(result$lagrange$result)
  result$divided_diff$result <- pretty(result$divided_diff$result)
  result$fintite_diff$result <- pretty(result$fintite_diff$result)

  result <- append(
    list(
      operation = attribute,
      polynomial = polynomial
    ),
    list(
      output = result
    )
  )
}

source(sprintf("%s/../logic/root.r", getwd()))

prepare <- function(points, duration) {
  duration <- as.numeric(duration)
  instants <- duration * points[1, ]
  m <- matrix(c(
    if (length(instants)) instants else rep(0, length(points[1, ])),
    points[2, ]
  ), nrow = 2, byrow = TRUE)
  return(m)
}

tomatrix <- function(points_list) {
  points <- c(NULL)
  n <- length(points_list[[1]])
  for (l in points_list) {
    points <- c(points, sapply(l, `[`, 1))
  }
  m <- matrix(points, ncol = n, byrow = TRUE)
  return(m)
}

middle <- function(obj) {
  objectpolys <- list()
  paths <- list()
  for (object in obj) {
    polynomials <- list()
    for (attribute in object) {
      if (is.null(attribute$duration) || attribute$duration == 0) {
        next
      }
      attribute$points <- t(tomatrix(attribute$points))
      if (attribute$operation != "position") {
        points <- prepare(attribute$points, attribute$duration)
        polynomials <- append(
          polynomials,
          list(
            append(
              interpolate(attribute$operation, points),
              list(duration = attribute$duration)
            )
          )
        )
        next
      }
      position <- list(
        operation = "position",
        duration = attribute$duration,
        polynomials = list(),
        outputs = list()
      )

      xpoints <- prepare(
        rbind(attribute$points[1, ], attribute$points[2, ]),
        attribute$duration
      )
      xresult <- interpolate("x", xpoints)
      position$polynomials <- append(
        position$polynomials,
        list(
          x = xresult$polynomial
        )
      )
      position$outputs <- append(
        position$outputs,
        list(
          x = xresult$output
        )
      )

      xpolynomial <- xresult$polynomial

      ypoints <- prepare(
        rbind(attribute$points[1, ], attribute$points[3, ]),
        attribute$duration
      )
      yresult <- interpolate("y", ypoints)
      position$polynomials <- append(
        position$polynomials,
        list(
          y = yresult$polynomial
        )
      )
      position$outputs <- append(
        position$outputs,
        list(
          y = yresult$output
        )
      )

      ypolynomial <- yresult$polynomial
      paths <- append(
        paths,
        list(
          list(
            x = list(
              coefficients = xpolynomial,
              start = 0,
              end = xpoints[1, length(xpoints[1, ])]
            ),
            y = list(
              coefficients = ypolynomial,
              start = 0,
              end = ypoints[1, length(ypoints[1, ])]
            )
          )
        )
      )
      polynomials <- append(
        polynomials,
        list(
          position
        )
      )
    }
    objectpolys <- append(
      objectpolys,
      list(polynomials)
    )
  }
  return(list(
    objectPolynomials = objectpolys,
    intersections = if (length(paths) == 0 || length(paths) == 1) list()
    else intersections(paths)
  ))
}
