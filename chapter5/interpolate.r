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
    return(p + q)
  }

  if (length(p) > length(q)) {
    bigger <- p
    smaller <- q
  } else {
    bigger <- q
    smaller <- p
  }

  result <- bigger[seq(1, length(smaller))] + smaller
  result <- c(result, bigger[seq(length(smaller) + 1, length(bigger))])

  return(result)
}

stringify <- function(coefficients) {
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

multiply <- function(...) {
  result <- c(1)
  for (i in seq_len(...length())) {
    result <- mul(result, ...elt(i))
  }
  return(result)
}

lagrange <- function(points) {
  print("                              Lagrange Method")
  points <- ord(points)
  result <- c(NULL)
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
    print(sprintf("l%g(x) = %s", i, stringify(weight)))
    stime <- Sys.time()
    result <- sum(result, weight * points[2, i])
    time <- time + (Sys.time() - stime)
  }
  result <- list(result = result, time = time)
  return(result)
}

newton <- function(points) {
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

  print("                               Newton Algorithm")
  execution <- cbind(points[1, ], execution)
  execution <- rbind(header, execution)
  print(execution)

  result <- list(result = result, time = time)
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

  print("                               FDF Algorithm")
  execution <- cbind(points[1, ], execution)
  execution <- rbind(header, execution)
  print(execution)

  result <- list(result = result, time = time)
  return(result)
}

divided_diff <- function(points) {
  stime <- Sys.time()
  points <- ord(points)
  time <- Sys.time() - stime

  result <- newton(points)
  coefficients <- result$result
  time <- time + result$time
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

  result <- list(result = result, time = time)
  return(result)
}

finite_diff <- function(points) {
  stime <- Sys.time()
  points <- ord(points)
  a <- points[1, 1]
  h <- abs(a - points[1, length(points[1, ])]) / (length(points[1, ]) - 1)
  for (i in 2:length(points[1, ])) {
    if (a + (i - 1) * h != points[1, i]) {
      print("points are not equidistant")
      return(list(result = NULL, time = 0))
    }
  }
  time <- Sys.time() - stime

  result <- fdf(points)
  coefficients <- result$result
  time <- time + result$time
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

  result <- list(result = result, time = time)
  return(result)
}

interpolate <- function(points) {
  result <- list(
    "lagrange" = lagrange(points),
    "divided_diff" = divided_diff(points),
    "finite_diff" = finite_diff(points)
  )

  print("                               TIME")
  print(sprintf("lagrange: %g", result$lagrange$time))
  print(sprintf("divided differences: %g", result$divided_diff$time))
  print(sprintf("finite differences: %g", result$finite_diff$time))

  return(result$divided_diff$result)
}

# points should b x0,y0;x1,y1;...
args <- commandArgs(trailingOnly = TRUE)

points <- matrix(c(1, 1), nrow = 2)
for (point in strsplit(args[1], ";")) {
  points <- cbind(points, sapply(strsplit(point, ","), as.numeric))
}

points <- points[, 2:length(points[1, ])]

print(paste(interpolate(points), collapse = ";"))
