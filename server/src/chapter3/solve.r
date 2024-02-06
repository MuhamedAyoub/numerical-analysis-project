#* solve.r

filter <- function(mat, predicate) {
  is_top <- c(predicate(mat))
  return(matrix(sapply(
    seq_len(length(mat)),
    function(i) if (is_top[i]) return(mat[i]) else return(0)
  ), nrow = nrow(mat)))
}

iterate <- function(b, m, n, x, tolerance, method) {
  stime <- Sys.time()
  if (det(m) == 0) {
    return(list(
      error = sprintf("matrix not inversible for method: %s", method)
    ))
  }

  m <- solve(m)
  a <- m %*% n
  b <- m %*% b

  iterations <- 0
  step <- function(vect) a %*% vect + b
  xresult <- matrix(x, nrow = length(x))
  diff_result <- c("NULL")
  while (TRUE) {
    prev <- x
    x <- step(x)
    iterations <- iterations + 1

    # case of divergence
    if (is.infinite(abs(norm(x - prev, type = "I")))) {
      return(list(
        error = "method diverges"
      ))
    }

    if (difftime(Sys.time(), stime, units = "secs") > 120) {
      return(list(
        error = "finding solution took too long"
      ))
    }

    xresult <- cbind(xresult, x)
    diff_result <- c(
      diff_result,
      if (abs(norm(x - prev, type = "I")) < tolerance) "TRUE" else "FALSE"
    )


    if (abs(norm(prev - x, type = "I")) < tolerance) {
      break
    }

  }

  time <- Sys.time() - stime
  result <- rbind(xresult, diff_result)
  result <- cbind(
    c("Xn", rep("", length(x) - 1), "|Xn - X(n-1)| < tolerance"),
    result
  )

  return(list(
    time = as.numeric(time),
    result = c(x),
    iterations = iterations,
    output = result
  ))
}

jacobi <- function(mat, b, x, tolerance) {
  return(iterate(
    b,
    filter(mat, function(m) return(col(m) == row(m))),
    -1 * filter(mat, function(m) return(col(m) != row(m))),
    x, tolerance, "jacobi"
  ))
}

gauss <- function(mat, b, x, tolerance) {
  return(iterate(
    b,
    filter(mat, function(m) return(col(m) <= row(m))),
    -1 * filter(mat, function(m) return(col(m) > row(m))),
    x, tolerance, "gauss seidel"
  ))
}

relaxation <- function(mat, b, x, tolerance, w) {
  if (w == 0) {
    return(list(
      error = "cannot use relaxation method"
    ))
  }

  d <- filter(mat, function(m) return(col(m) == row(m)))
  e <- -1 * filter(mat, function(m) return(col(m) < row(m)))
  f <- -1 * filter(mat, function(m) return(col(m) > row(m)))
  warnings()
  return(iterate(
    b,
    (1 / w) * d - e,
    f - (1 - (1 / w)) * d,
    x, tolerance, "relaxation"
  ))
}

solvesys <- function(mat, b, x, tolerance = 0.0001, w = 1.2) {
  return(list(
    jacobi = jacobi(mat, b, x, tolerance),
    gauss = gauss(mat, b, x, tolerance),
    relaxation = relaxation(mat, b, x, tolerance, w)
  ))
}

#* returns the original vector
#* @param base
#* @param vector
#* @post /chapter3/original
function(vector, base) {
  base <- matrix(c(base), nrow = length(vector), byrow = TRUE)
  return(solvesys(base, vector, rep(0, length(vector))))
}
