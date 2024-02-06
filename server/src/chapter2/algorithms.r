
# Gauusian Elimination with Total Pivoting
gaussianEliminationTotalPivoting <- function(A, b) {
    n <- nrow(A)

    augmentedMatrix <- cbind(A, b)

    # Applying Gaussian elimination with total pivoting
    for (i in 1:(n - 1)) {
        # Total Pivoting
        pivotElement <- which.max(abs(augmentedMatrix[i:n, i:n]))
        pivotRow <- floor((pivotElement - 1) / (n - i + 1)) + i
        pivotCol <- pivotElement - (pivotRow - i) * (n - i + 1)

        if (pivotRow != i) {
            augmentedMatrix[c(i, pivotRow), ] <- augmentedMatrix[c(pivotRow, i), ]
        }
        if (pivotCol != i) {
            augmentedMatrix[, c(i, pivotCol)] <- augmentedMatrix[, c(pivotCol, i)]
        }

        # Elimination
        for (j in (i + 1):n) {
            factor <- augmentedMatrix[j, i] / augmentedMatrix[i, i]
            augmentedMatrix[j, ] <- augmentedMatrix[j, ] - factor * augmentedMatrix[i, ]
        }
    }

    # Back substitution
    x <- numeric(n)
    for (i in n:1) {
        x[i] <- (augmentedMatrix[i, n + 1] - sum(augmentedMatrix[i, (i + 1):n] * x[(i + 1):n])) / augmentedMatrix[i, i]
    }

    return(x)
}


# Gaussian Elimination with Partial Pivoting
gaussianEliminationPartialPivoting <- function(A, b) {
    n <- nrow(A)

    # Augmenting matrix [A|b]
    augmentedMatrix <- cbind(A, b)

    # Applying Gaussian elimination with partial pivoting
    for (i in 1:(n - 1)) {
        # Partial Pivoting
        pivotRow <- which.max(abs(augmentedMatrix[i:n, i])) + (i - 1)
        if (pivotRow != i) {
            augmentedMatrix[c(i, pivotRow), ] <- augmentedMatrix[c(pivotRow, i), ]
        }

        # Elimination
        for (j in (i + 1):n) {
            factor <- augmentedMatrix[j, i] / augmentedMatrix[i, i]
            augmentedMatrix[j, ] <- augmentedMatrix[j, ] - factor * augmentedMatrix[i, ]
        }
    }

    # Back substitution
    x <- numeric(n)
    for (i in n:1) {
        x[i] <- (augmentedMatrix[i, n + 1] - sum(augmentedMatrix[i, (i + 1):n] * x[(i + 1):n])) / augmentedMatrix[i, i]
    }

    return(x)
}


luDecompositionSolve <- function(A, B) {
    n <- nrow(A)
    m <- ncol(A)
   if (nrow(A) != ncol(A)) { 
      return (list(status="error", msg="Matrix A must be square"))

    } 
    # LU decomposition
    lower <- matrix(0, n, n)
    upper <- matrix(0, n, n)

    for (i in 1:n) {
        # Upper Triangular
        for (k in i:m) {
            upper[i, k] <- A[i, k] - sum(lower[i, 1:(i - 1)] * upper[1:(i - 1), k])
        }

        # Lower Triangular
        for (k in i:n) {
            if (i == k) {
                lower[i, i] <- 1 # Diagonal as 1
            } else {
                lower[k, i] <- (A[k, i] - sum(lower[k, 1:(i - 1)] * upper[1:(i - 1), i])) / upper[i, i]
            }
        }
    }

    # Solving the system
    # Ly = B (forward substitution)
    y <- numeric(n)
    for (i in 1:n) {
        y[i] <- (B[i] - sum(lower[i, 1:(i - 1)] * y[1:(i - 1)])) / lower[i, i]
    }

    # Ux = y (back substitution)
    x <- numeric(n)
    for (i in n:1) {
        if (i < n) {
            x[i] <- (y[i] - sum(upper[i, (i + 1):n] * x[(i + 1):n])) / upper[i, i]
        } else {
            x[i] <- y[i] / upper[i, i]
        }
    }

    return(list(status="success", x=x))
    
}



# choleskyDecompositionSolve <- function(A, B) {
#   n <- nrow(A)
  
#   # Cholesky decomposition
#   L <- matrix(0, n, n)
  
#   for (i in 1:n) {
#     for (j in 1:i) {
#       if (i == j) {
#         L[i, i] <- sqrt(A[i, i] - sum(L[i, 1:(i-1)]^2))
#       } else {
#         L[i, j] <- (A[i, j] - sum(L[i, 1:(i-1)] * L[j, 1:(j-1)])) / L[j, j]
#       }
#     }
#   }
  
#   # Solving the system using Cholesky decomposition
#   # Ly = B (forward substitution)
#   y <- numeric(n)
#   for (i in 1:n) {
#     y[i] <- (B[i] - sum(L[i, 1:(i-1)] * y[1:(i-1)])) / L[i, i]
#   }
  
#   # Lt x = y (back substitution)
#   x <- numeric(n)
#   for (i in n:1) {
#     x[i] <- (y[i] - sum(L[i+1:n, i] * x[i+1:n])) / L[i, i]
#   }
  
#   return(x)
# }


choleskyDecompositionSolve <- function(A, B) {
  n <- nrow(A)
  
  # Cholesky decomposition
  L <- matrix(0, n, n)
  
  for (i in 1:n) {
    for (j in 1:i) {
      if (i == j) {
        L[i, i] <- sqrt(A[i, i] - sum(L[i, 1:(i-1)]^2))
      } else {
        L[i, j] <- (A[i, j] - sum(L[i, 1:(i-1)] * L[j, 1:(j-1)])) / L[j, j]
      }
    }
  }
  
  # Solving the system using Cholesky decomposition
  # Ly = B (forward substitution)
  y <- numeric(n)
  for (i in 1:n) {
    y[i] <- (B[i] - sum(L[i, 1:(i-1)] * y[1:(i-1)])) / L[i, i]
  }
  
  # Lt x = y (back substitution)
  x <- numeric(n)
  for (i in n:1) {
    x[i] <- (y[i] - sum(L[i+1:n, i] * x[i+1:n])) / L[i, i]
  }
  
  return(x)
}


# testing LU Decomposition
A <- matrix(c(4, 12, -16, 12, 37, -43, -16, -43, 98), 3, 3)
B <- c(1, 2, 3)
x= luDecompositionSolve(A, B)
print(x)