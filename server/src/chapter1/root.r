wait_time <- 40

find_interval <- function(f, a, b) {
  upper <- b
  lower <- a
  tolerance <- 0.0001
  h <- abs(b - a)
  while (f(a) * f(b) > 0 && h > tolerance) {
    if (b == upper) {
      h <- h / 2
      a <- lower
      b <- a + h
    } else {
      a <- a + h
      b <- b + h
    }
  }

  return(if (h > tolerance) c(a, b) else NULL)
}

bisection <- function(f, a, b, tolerance) {
  output <- c("a", "b", "x", "f(a)", "f(b)", "f(x)")

  current <- (a + b) / 2
  iterations <- 0
  time <- 0
  while (TRUE) {
    output <- rbind(
      output,
      c(
        a, b, current,
        if (f(a) > 0) "+" else "-",
        if (f(b) > 0) "+" else "-",
        if (f(current) > 0) "+" else "-"
      )
    )
    stime <- Sys.time()
    if (f(a) == 0 || f(b) == 0) {
      current <- if (f(a) == 0) a else b
    }
    if (f(current) == 0) {
      break
    }

    if (f(a) * f(current) < 0) {
      b <- current
    } else {
      a <- current
    }
    previous <- current
    current <- (a + b) / 2
    iterations <- iterations + 1
    if (abs(current - previous) < tolerance) {
      break
    }
    time <- time + (Sys.time() - stime)
  }

  return(list(
    result = current,
    time = time,
    iterations = iterations,
    output = output
  ))
}

find_start <- function(f, fderiv2, a, b) {
  if (f(a) * fderiv2(a) > 0) {
    return(a)
  }
  if (f(b) * fderiv2(b) > 0) {
    return(b)
  }
  upper <- b
  lower <- a

  h <- abs(a - b) / 2
  while (TRUE) {
    if (b == upper) {
      h <- h / 2
      a <- lower
      b <- a + h
    } else {
      a <- a + h
      b <- b + h
    }

    x <- (a + b) / 2
    if (f(x) * fderiv2(x) > 0) {
      return(x)
    }
    if (h < 0.0001) {
      return(NULL)
    }
  }
}

newton <- function(fexpr, a, b, tolerance) {
  fderivexpr <- D(fexpr, "x")
  if (
    isTRUE(all.equal(fexpr, expression(0))) ||
      isTRUE(all.equal(fderivexpr, 0))
  ) {
    return(list(
      error = "cannot use newton method, derivitive is zero"
    ))
  }

  fderiv2expr <- D(D(fexpr, "x"), "x")
  if (isTRUE(all.equal(fderiv2expr, 0))) {
    return(list(
      error = "newton method diverges"
    ))
  }

  stime <- Sys.time()
  f <- function(x) eval(fexpr, list(x = x))
  fderiv <- function(x) eval(fderivexpr, list(x = x))
  fderiv2 <- function(x) {
    return(eval(
      fderiv2expr,
      list(x = x)
    ))
  }
  x <- find_start(f, fderiv2, a, b)

  iterations <- 0

  result <- c(x, "NULL")

  while (TRUE) {
    prev <- x
    if (fderiv(x) == 0) {
      return(list(
        error = sprintf("cannot use newton method f'(%g) = 0", x)
      ))
    }
    x <- x - (f(x) / fderiv(x))
    iterations <- iterations + 1

    print(x)
    if (is.nan(x)) {
      return(list(
        error = "newton method diverges"
      ))
    }
    result <- rbind(
      result,
      c(x, if (abs(x - prev) < tolerance) "TRUE" else "FALSE")
    )

    if (difftime(Sys.time(), stime, units = "secs") > wait_time) {
      return(list(
        error = "newton method took too long"
      ))
    }

    if (abs(x - prev) < tolerance) {
      break
    }
  }
  result <- rbind("Xn", "|Xn - X(n-1)| < tolerance", result)

  return(list(
    output = result,
    time = as.numeric(Sys.time() - stime),
    result = x,
    iterations = iterations
  ))
}

stringify <- function(coefficients) {
  i <- 0
  coefficients <- sapply(
    coefficients,
    function(x) {
      if (x == 0) {
        i <<- i + 1
        return("0")
      }
      string <- sprintf("%g * x ^ %g", x, i)
      i <<- i + 1
      return(string)
    }
  )

  return(paste(coefficients, collapse = " + "))
}

fixed_point <- function(coeff, a, b, tolerance) {
  stime <- Sys.time()
  if (length(coeff) == 1) {
    if (coeff[1] == 0) {
      return(list(
        output = "",
        time = 0,
        result = a,
        iterations = 0
      ))
    }

    return(list(
      error = "couldn't find root"
    ))
  }

  g <- function(x) return(x)
  if (coeff[2] != 0) {
    g <- function(x) {
      eval(
        parse(text = stringify((-1 / coeff[2]) * coeff[-2])),
        list(x = x)
      )
    }
  } else {
    invcoeff <- (-1 / coeff[length(coeff)]) * coeff[-length(coeff)]
    g <- function(x) {
      poly_value <- eval(
        parse(text = stringify(invcoeff)),
        list(x = x)
      )
      return(sign(poly_value) * abs(poly_value) ^ (1 / (length(coeff) - 1)))
    }
  }

  x <- a
  iterations <- 0
  result <- c(x, "NULL")
  while (TRUE) {
    prev <- x
    x <- g(x)
    iterations <- iterations + 1

    if (is.nan(x)) {
      return(list(
        error = "fixed point method diverges"
      ))
    }
    result <- rbind(
      result,
      c(x, if (abs(x - prev) < tolerance) "TRUE" else "FALSE")
    )

    if (difftime(Sys.time(), stime, units = "secs") > wait_time) {
      return(list(
        error = "fixed point method took too long"
      ))
    }

    if (abs(x - prev) < tolerance) {
      break
    }
  }

  result <- rbind(c("Xn", "|Xn - X(n-1)| < tolerance"), result)
  return(list(
    output = result,
    time = as.numeric(Sys.time() - stime),
    iterations = iterations,
    result = x
  ))
}

root <- function(coeff, a, b, tolerance = 0.00001) {
  expr <- parse(text = stringify(coeff))
  f <- function(x) eval(expr, list(x = x))

  result <- find_interval(f, a, b)
  if (is.null(result)) {
    return(list(
      error = "couldn't find function root"
    ))
  }

  a <- result[1]
  b <- result[2]
  result <- list(
    bisection = bisection(f, a, b, tolerance),
    newton = newton(expr, a, b, tolerance),
    fixed_point = fixed_point(coeff, a, b, tolerance)
  )

  return(result)
}

sum <- function(p, q) {
  if (length(p) == length(q)) {
    result <- p + q
    return(if (length(result[result == 0]) == length(result)) c(0) else result)
  }

  min_length <- min(length(p), length(q))
  result <- c(
    p[seq_len(min_length)] + q[seq_len(min_length)],
    if (length(p) != min_length) p[min_length:length(p)] else NULL,
    if (length(q) != min_length) q[(min_length + 1):length(q)] else NULL
  )
  return(if (length(result[result == 0]) == length(result)) c(0) else result)
}

middle <- function(paths) {
  print(paths)
  outputs <- list()
  points <- list()
  # finding x and y solutions
  for (i in seq_len(length(paths) - 1)) {
    for (j in (i + 1):length(paths)) {
      print(sprintf("i: %g, j: %g", i, j))
      output <- list(operation = sprintf("paths %g-%g", i, j))

      xdifference <- sum(
        sapply(paths[[i]]$x$coefficients, function(x) x),
        sapply(paths[[j]]$x$coefficients, function(x) -1 * x)
      )
      xdifference <- c(xdifference)
      xsolution <- root(
        xdifference,
        max(paths[[i]]$x$start, paths[[j]]$x$start),
        max(paths[[i]]$x$end, paths[[j]]$x$end)
      )
      output <- append(
        output,
        list(
          x = list(
            append(list(method = "bisection"), xsolution$bisection),
            append(list(method = "newton"), xsolution$newton),
            append(list(method = "fixed point"), xsolution$fixed_point)
          )
        )
      )
      xsolution <- list(unique(Filter(
        is.numeric,
        sapply(
          c("bisection", "newton", "fixed_point"),
          function(method) {
            return(
              if (!is.null(get(method, xsolution)$result)) {
                round(get(method, xsolution)$result, digits = 1)
              }
            )
          }
        )
      )))

      ydifference <- sum(
        sapply(paths[[i]]$y$coefficients, function(x) x),
        sapply(paths[[j]]$y$coefficients, function(x) -1 * x)
      )
      ydifference <- c(ydifference)
      ysolution <- root(
        ydifference,
        max(paths[[i]]$y$start, paths[[j]]$y$start),
        max(paths[[i]]$y$end, paths[[j]]$y$end)
      )

      output <- append(
        output,
        list(
          y = list(
            append(list(method = "bisection"), ysolution$bisection),
            append(list(method = "newton"), ysolution$newton),
            append(list(method = "fixed point"), ysolution$fixed_point)
          )
        )
      )

      print(get("bisection", ysolution)$result)
      ysolution <- list(unique(sapply(
        c("bisection", "newton", "fixed_point"),
        function(method) {
          return(
            if (!is.null(get(method, ysolution)$result)) {
              round(get(method, ysolution)$result, digits = 1)
            }
          )
        }
      )))

      solutions <- intersect(xsolution, ysolution)
      points <- append(
        points,
        list(
          sapply(
            solutions,
            function(t) {
              list(
                eval(
                  parse(text = stringify(
                    sapply(paths[[i]]$x$coefficients, function(x) x)
                  )),
                  list(x = t)
                ),
                eval(
                  parse(text = stringify(
                    sapply(paths[[i]]$y$coefficients, function(x) x)
                  )),
                  list(x = t)
                )
              )
            }
          )
        )
      )

      outputs <- append(outputs, list(output))
    }
  }

  # matching x solution with y solution of path i-j
  points <- Filter(function(x) length(x) > 0, points)
  return(list(
    points = points,
    output = output
  ))
}

middle(list(
  list(
    x = list(
      coefficients = list(0, 1),
      start = -10,
      end = 10
    ),
    y = list(
      coefficients = list(0, 1),
      start = -10,
      end = 10
    )
  ),
  list(
    x = list(
      coefficients = list(0, 1),
      start = -10,
      end = 10
    ),
    y = list(
      coefficients = list(0, -1),
      start = -10,
      end = 10
    )
  )
))
