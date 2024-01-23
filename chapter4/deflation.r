is_square <- function(m) {
  return(ncol(m) == nrow(m))
}

is_diagonal <- function(m) {
  if (!is_square(m)) {
    return(FALSE)
  }

  for (i in seq_len(nrow(m))) {
    for (j in seq_len(ncol(m))) {
      if (i == j) {
        next
      }
      if (m[i, j] != 0) {
        return(FALSE)
      }
    }
  }

  return(TRUE)
}

iterative_power <- function(m, vect, precision, decimals = 3) {
  x <- vect
  eigenvalues <- c(NULL)
  eigenvectors <- matrix(vect, ncol = 1, nrow = length(vect))

  iterations <- 0
  repeat {
    x <- c(m %*% vect)
    if (iterations > 0) {
      previous <- eigenvalue
    }

    eigenvalue <- x[which(abs(x) == max(abs(x)))[1]]
    eigenvalues <- append(eigenvalues, eigenvalue)

    vect <- x / eigenvalue
    eigenvectors <- cbind(eigenvectors, c(vect))

    iterations <- iterations + 1
    if (iterations == 1) {
      next
    }

    if (abs(eigenvalue - previous) < precision || iterations > 15) {
      break
    }
  }


  eigenvalue <- round(eigenvalue, decimals)
  vect <- round(vect, decimals)
  print(list("λ" = eigenvalues, "V" = eigenvectors))
  return(list("eigenvalue" = eigenvalue, "eigenvector" = vect))
}

deflation <- function(m, init, precision, decimals = 3) {
  if (!is_square(m)) {
    stop("matrix is not a square matrix")
  }
  iterations <- 1
  eigenvectors <- matrix(rep(1, nrow(m)), nrow = nrow(m))
  eigenvalues <- c(NULL)

  while (iterations <= nrow(m)) {
    sprintf("---------------------------iteration %g------------------------------",
            iterations)
    print(list("A" = m))
    result <- iterative_power(m, init, precision, decimals)
    v <- result$eigenvector
    a <- result$eigenvalue
    eigenvalues <- cbind(eigenvalues, a)
    eigenvectors <- cbind(eigenvectors,  v)

    print(list("t(A)" = m))
    u <- matrix(iterative_power(t(m), init, precision, decimals)$eigenvector,
                nrow = nrow(m))

    m <- m - (a / (v %*% u))[1, 1] * (u %*% v)
    iterations <- iterations + 1
  }
  vector_header <- c(NULL)
  value_header <- c(NULL)
  for (i in seq_len(nrow(m))) {
    value_header <- cbind(value_header, sprintf("λ%g", i))
    vector_header <- cbind(vector_header, sprintf("V%g", i))
  }

  eigenvectors <- eigenvectors[, 2:ncol(eigenvectors)]
  result <- list("eigenvalues" = rbind(value_header, eigenvalues),
                 "eigenvector" = rbind(vector_header, eigenvectors))
  print(result)
  return(result)
}

deflation(matrix(c(1, 2, 0, 2, 1, 0, 0, 0, -1), nrow = 3, byrow = TRUE),
          c(1, 0, 0), 0.1, 1)
