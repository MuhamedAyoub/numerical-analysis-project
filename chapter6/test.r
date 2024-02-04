f <- function(...) {
  return(as.vector(..., mode = "any"))
}

print(f(1, 2, 3))
