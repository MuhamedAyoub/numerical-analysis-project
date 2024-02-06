error <- function(message) return()
success <- function(body) return()

source("../utils/response.r")

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

bisection <- function(f, a, b, err = 0.000001) {
  output <- c("a", "b", "x", "f(a)", "f(b)", "f(x)")

  n <- 0
  current <- (a + b) / 2
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
    n <- n + 1
    if (abs(current - previous) < err) {
      break
    }
    time <- time + (Sys.time() - stime)
  }

  print("                               Bisection Algorithm")
  print(output)

  return(list(result = current, time = time))
}

newton <- function(f, a, b, err) {
  
}

fixed_point <- function(f, a, b, err) {
}

root <- function(f, a, b, err = 0.000001) {
  result <- find_interval(f, a, b)
  if (is.null(result)) {
    error("cannot find root for specified function")
  }

  result <- list(
    bisection = bisection(f, a, b, err),
    newton = newton(f, a, b, err),
    fixed_point = fixed_point(f, a, b, err)
  )

  print(sprintf("bisection: %g", result$bisection$time))
  print(sprintf("newton: %g", result$newton$time))
  print(sprintf("fixed point: %g", result$fixed_point$time))

  success(list(result = result$newton$result))
}

result <- find_interval(function(x) return(x^2 - 1), -1000, 500)
root(function(x) return(x^2 - 1), result[1], result[2])
