find_interval <- function(f, a, b) {
  upper <- b
  lower <- a
  h <- abs(b - a)
  while (f(a) * f(b) > 0 && h > 0.0000001) {
    if (b == upper) {
      h <- h / 2
      a <- lower
      b <- a + h
    } else {
      a <- a + h
      b <- b + h
    }
  }

  return(if (h > 0.0000001) c(a, b) else NULL)
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

newton <- function(fexpr, a, b, tolerance) {
  stime <- Sys.time()
  f <- function(x) eval(fexpr, list(x = x))
  fderiv <- function(x) eval(D(fexpr, "x"), list(x = x))
  iterations <- 0
  result <- c(x, "NULL")

  while (TRUE) {
    prev <- x
    if (fderiv(x) == 0) {
      return(list(
        error = sprintf("cannot use newton method f'(%g) = 0", x)
      ))
    }
    x <- x - f(x) / fderiv(x)
    iterations <- iterations + 1

    if (is.nan(x) == 0) {
      return(list(
        error = "newton method diverges"
      ))
    }
    result <- rbind(result, c(x, abs(x - prev) < tolerance))

    if (difftime(Sys.time(), stime, units = "secs") > 120) {
      return(list(
        error = "newton method took too long"
      ))
    }

    if (abs(x - prev) < tolerance) {
      break
    }
  }
  result <- rbind("Xn", "|Xn - X(n-1)| < tolerance")

  return(list(
    output = result,
    time = as.numeric(Sys.time() - stime),
    result = x,
    iterations = iterations
  ))
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
              "x",
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
      eval(
        parse(text = stringify(invcoeff)),
        list(x = x)
      ) ^ (1 / (length(coeff) - 1))
    }
  }
  print(g)

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
    result <- rbind(result, c(x, abs(x - prev) < tolerance))

    if (difftime(Sys.time(), stime, units = "secs") > 120) {
      return(list(
        error = "fixed point method took too long"
      ))
    }

    if (abs(x - prev) < tolerance) {
      break
    }
  }

  result <- rbind(c("Xn", "|Xn - X(n-1)| < tolerance"))
  return(list(
    output = result,
    time = as.numeric(Sys.time() - stime),
    iterations = iterations,
    result = x
  ))
}

root <- function(coeff, a, b, tolerance = 0.000001) {
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
  print(a)
  print(b)
  result <- list(
    bisection = bisection(f, a, b, tolerance),
    newton = newton(expr, a, b, tolerance),
    fixed_point = fixed_point(coeff, a, b, tolerance)
  )

  return(result)
}

root(c(-1, 0, 1), -100, 50)
