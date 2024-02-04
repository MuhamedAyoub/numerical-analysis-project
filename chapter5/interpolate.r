points <- function(...) {
  points <- vector(mode = "list", length = ...length())
  for (i in seq_len(...length())) {
    points[[i]] <- ...elt(i)
  }
  points <- points[order(sapply(points, `[`, 1))]
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

lagrange <- function(...) {
  print("                                   Lagrange Method")
  p <- points(...)
  result <- c(NULL)
  for (i in seq_len(length(p))) {
    weight <- c(1)
    for (j in seq_len(length(p))) {
      if (j != i) {
        weight <- mul(weight, (1 / (p[[i]][1] - p[[j]][1])) * c(- p[[j]][1], 1))
      }
    }
    print(sprintf("l%g(x) = %s", i, stringify(weight)))
    result <- sum(result, weight * p[[i]][2])
  }
  return(result)
}

newton <- function(...) {
  p <- points(...)
  execution <- matrix(c(sapply(p, `[`, 2)), nrow = length(p))
  header <- c("x", "f[x0]")
  result <- p[[1]][2]
  # first 2 column are already filled
  for (i in seq(2, length(p))) {
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

    # starts calculating at position [2, 2] before should be empty
    column <- rep(0, i - 1)
    for (j in seq(i, length(p))) {
      cell <- (execution[j, i - 1] - execution[j - 1, i - 1]) /
        (p[[j]][1] - p[[j - (i - 1)]][1])
      if (j == i) {
        result <- c(result, cell)
      }

      column <- c(
        column,
        cell
      )
    }
    execution <- cbind(execution, column)
  }

  print("                                Newton Algorithm")
  execution <- cbind(sapply(p, `[`, 1), execution)
  execution <- rbind(header, execution)
  print(execution)
  return(result)
}

divided_diff <- function(...) {
}

finite_diff <- function(...) {
}

interpolate <- function(...) {
  result <- list(
    "lagrange" = lagrange(...),
    "divided_diff" = divided_diff(...),
    "finite_diff" = finite_diff(...)
  )
  print(result)
  return(result)
}
