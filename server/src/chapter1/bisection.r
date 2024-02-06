
bisection <- function(a, b, f) {
  if (!(f(a) * f(b) < 0)) {
    stop("cannot continue function doesn't 
          satisfy conditions of bisection method")
  }

}
