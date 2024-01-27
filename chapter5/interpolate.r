points <- function(...) {
  points <- vector(mode = "list", length = ...length())
  for (i in seq_len(...length())) {
    points[[i]] <- ...elt(i)
  }
  points <- points[order(sapply(points, `[`, 1))]
}

poly_multiply <- function(p, q) {
  m <- matrix(p, ncol = 1) %*% q
  print(m)
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
  return(result)
}

poly_print <- function(coefficients) {
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
  print(paste(coefficients, collapse = " + "))
}

lagrange <- function(...) {

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

poly_print(c(1, 1, 2))
